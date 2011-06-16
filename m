Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab1FPVKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:10:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932360Ab1FPVKd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <1308255972.17300.450.camel@schen9-DESK>
References: <1308097798.17300.142.camel@schen9-DESK> <1308101214.15392.151.camel@sli10-conroe>
 <1308138750.15315.62.camel@twins> <20110615161827.GA11769@tassilo.jf.intel.com>
 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
 <BANLkTim5TPKQ9RdLYRxy=mphOVKw5EXvTA@mail.gmail.com> <1308255972.17300.450.camel@schen9-DESK>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Jun 2011 13:47:32 -0700
Message-ID: <BANLkTinptaydNvK4ZvGvy0KVLnRmmza7tA@mail.gmail.com>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <ak@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 1:26 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
>
> I ran exim with different kernel versions.  Using 2.6.39-vanilla
> kernel as a baseline, the results are as follow:
>
>                        Throughput
> 2.6.39(vanilla)         100.0%
> 2.6.39+ra-patch         166.7%  (+66.7%)        (note: tmpfs readahead patchset is merged in 3.0-rc2)
> 3.0-rc2(vanilla)         68.0%  (-32%)
> 3.0-rc2+linus           115.7%  (+15.7%)
> 3.0-rc2+linus+softirq    86.2%  (-17.3%)

Ok, so batching the semaphore operations makes more of a difference
than I would have expected.

I guess I'll cook up an improved patch that does it for the vma exit
case too, and see if that just makes the semaphores be a non-issue.

> I also notice that the run to run variations have increased quite a bit for 3.0-rc2.
> I'm using 6 runs per kernel.  Perhaps a side effect of converting the anon_vma->lock to mutex?

So the thing about using the mutexes is that heavy contention on a
spinlock is very stable: it may be *slow*, but it's reliable, nicely
queued, and has very few surprises.

On a mutex, heavy contention results in very subtle behavior, with the
adaptive spinning often - but certainly not always - making the mutex
act as a spinlock, but once you have lots of contention the adaptive
spinning breaks down. And then you have lots of random interactions
with the scheduler and 'need_resched' etc.

The only valid answer to lock contention is invariably always just
"don't do that then". We've been pretty good at getting rid of
problematic locks, but this one clearly isn't one of the ones we've
fixed ;)

                        Linus
