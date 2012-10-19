Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2JSMtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:49:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2JSMtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:49:51 -0400
Message-ID: <1350650972.30157.34.camel@twins>
Subject: Re: MAX_LOCKDEP_ENTRIES too low  (called from ioc_release_fn)
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 19 Oct 2012 14:49:32 +0200
In-Reply-To: <20121019052136.GA30852@redhat.com>
References: <20121018015312.GA29865@redhat.com> <507F9944.50505@kernel.dk>
	 <20121019052136.GA30852@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 01:21 -0400, Dave Jones wrote:
>  > Not sure why you are CC'ing a call site, rather than the maintainers of
>  > the code. Just looks like lockdep is using too small a static value.
>  > Though it is pretty darn large...
> 
> You're right, it's a huge chunk of memory.
> It looks like I can trigger this from multiple callsites..
> Another different trace below.
> 
> Not sure why this suddenly got a lot worse in 3.7 

Did we add a static array of structures with locks in somewhere? Doing
that is a great way of blowing up the number of lock classes and the
resulting amount of lock dependency chains.

>From Documentation/lockdep-design.txt; it talks about overflowing
MAX_LOCKDEP_KEYS, but I suppose its a good starts for overflowing the
dependency entries too, more classes means more dependencies after all.

---
Of course, if you do run out of lock classes, the next thing to do is
to find the offending lock classes.  First, the following command gives
you the number of lock classes currently in use along with the maximum:

        grep "lock-classes" /proc/lockdep_stats

This command produces the following output on a modest system:

         lock-classes:                          748 [max: 8191]

If the number allocated (748 above) increases continually over time,
then there is likely a leak.  The following command can be used to
identify the leaking lock classes:

        grep "BD" /proc/lockdep

Run the command and save the output, then compare against the output from
a later run of this command to identify the leakers.  This same output
can also help you find situations where runtime lock initialization has
been omitted.

