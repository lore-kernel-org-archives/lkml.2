Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030614Ab2CFMqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:46:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:41569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030545Ab2CFMqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:46:01 -0500
Message-ID: <1331037942.11248.307.camel@twins>
Subject: Re: [RFC PATCH] checkpatch: Warn on use of yield()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Miao Xie <miaox@cn.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Tue, 06 Mar 2012 13:45:42 +0100
In-Reply-To: <1330999280.10358.3.camel@joe2Laptop>
References: <20120302112358.GA3481@suse.de>
	 <1330723262.11248.233.camel@twins>
	 <20120305121804.3b4daed4.akpm@linux-foundation.org>
	 <1330999280.10358.3.camel@joe2Laptop>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 18:01 -0800, Joe Perches wrote:

> +# check for use of yield()
> +		if ($line =~ /\byield\s*\(\s*\)/ {
> +			WARN("YIELD",
> +			     "yield() is deprecated, consider cpu_relax()\n"  . $herecurr);
> +		}

Its not deprecated as such, its just a very dangerous and ill considered
API.

cpu_relax() is not a good substitute suggestion in that its still a busy
wait and prone to much of the same problems.

The case at hand was a life-lock due to expecting that yield() would run
another process which it needed in order to complete. Yield() does not
provide that guarantee.

Looking at fs/ext4/mballoc.c, we have this gem:


		/*
                 * Yield the CPU here so that we don't get soft lockup
                 * in non preempt case.
                 */
                yield();

This is of course complete crap as well.. I suspect they want
cond_resched() there. And:

                        /* let others to free the space */
                        yield();

Like said, yield() doesn't guarantee anything like running anybody else,
does it rely on that? Or is it optimistic?

Another fun user:

void tasklet_kill(struct tasklet_struct *t)
{
        if (in_interrupt())
                printk("Attempt to kill tasklet from interrupt\n");

        while (test_and_set_bit(TASKLET_STATE_SCHED, &t->state)) {
                do {
                        yield();
                } while (test_bit(TASKLET_STATE_SCHED, &t->state));
        }
        tasklet_unlock_wait(t);
        clear_bit(TASKLET_STATE_SCHED, &t->state);
}

The only reason that doesn't explode is because running tasklets is
non-preemptible, However since they're non-preemptible they shouldn't
run long and you might as well busy spin. If they can run long, yield()
isn't your biggest problem.

mm/memory_hotplug.c has two yield() calls in offline_pages() and I've no
idea what they're trying to achieve.

But really, yield() is basically _always_ the wrong thing. The right
thing can be:

 cond_resched(); wait_event(); or something entirely different.

So instead of suggesting an alternative, I would suggest thinking about
the actual problem in order to avoid the non-thinking solutions the
checkpatch brigade is so overly fond of :/

Maybe something like:

 "yield() is dangerous and wrong, rework your code to not use it."

That at least requires some sort of thinking and doesn't suggest blind
substitution.
