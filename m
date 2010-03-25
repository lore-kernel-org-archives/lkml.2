Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0CYS3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:29:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab0CYS3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:29:52 -0400
Date: Thu, 25 Mar 2010 19:29:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325182930.GA7709@elte.hu>
References: <20100324190150.GA18803@basil.fritz.box>
 <alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
 <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
 <20100325003652.GG20695@one.firstfloor.org>
 <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org>
 <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
 <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
 <1269539254.12097.100.camel@laptop>
 <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 25 Mar 2010, Peter Zijlstra wrote:
> > 
> > FWIW lockdep forces IRQF_DISABLED and yells when anybody does 
> > local_irq_enable() while in hardirq context, I haven't seen any such 
> > splats in a long while, except from the ARM people who did funny things 
> > with building their own threaded interrupts or somesuch.
> 
> The thing is, that won't show the drivers that just simply _expect_ other 
> interrupts to happen.
> 
> The SCSI situation, iirc, used to be that certain error conditions simply 
> caused a delay loop (reset? I forget) that depended on 'jiffies'. So there 
> was no 'local_irq_enable()' involved, nor did it even happen under any 
> normal load - only in error situations.
> 
> Now, I think (and sincerely) that the SCSI situation is likely long since 
> fixed, but we have thousands and thousands of drivers, and these kinds of 
> things are very hard to notice automatically. Are there any cases around 
> that still have busy-loop delays based on real-time in their irq handlers? I 
> simply don't know.

Yes, but that kind of crap should not go unnoticed if it triggers (which may 
be rare): in form of a hard lockup. We had that lockdep behavior of disabling 
irqs in all handlers forever, ever since it went upstream four years ago.

So we had 3 separate mechanisms in the past 3-4 years:

 - lockdep [which disables irqs in all handlers, indiscriminately]
 - dynticks [which found in-irq jiffies loops]
 - -rt [which found hardirqs-off loops]

That should have weeded out most of that kind of IRQ handler abuse.

In terms of test coverage, beyond upstream kernel testers who enable lockdep, 
Fedora rawhide has also been running kernels with lockdep enabled for the past 
3-4 years, so there's a fair amount of 'weird hardware' coverage as well. It 
certainly wont cover 100% everything, but it should cover everything that 
people bothered to test + report.

I'm fairly certain, based on having played with those aspects from many angles 
that disabling irqs in all drivers should work just fine today already.

So the patch below should at most trigger bugs in areas that need fixing 
anyway, and i'm quite sure that under no circumstance would it cause 
unforeseen problems in 'thousands of drivers'.

So i think this would be a clear step forward. (It's also probably the best 
thing for performance to batch up IRQs instead of nesting them.)

We could do this carefully, first in the IRQ tree then in linux-next, them 
upstream, with plenty of time for people to test. If it causes _any_ 
widespread problems that make you uncomfortable it would be very easy to 
revert. What do you think?

Thanks,

	Ingo

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 76d5a67..27e5c69 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -370,9 +370,6 @@ irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action)
 	irqreturn_t ret, retval = IRQ_NONE;
 	unsigned int status = 0;
 
-	if (!(action->flags & IRQF_DISABLED))
-		local_irq_enable_in_hardirq();
-
 	do {
 		trace_irq_handler_entry(irq, action);
 		ret = action->handler(irq, action->dev_id);

