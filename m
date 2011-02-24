Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1BXR5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:57:08 -0500
Received: from www.tglx.de ([62.245.132.106]:37090 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab1BXR5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:57:03 -0500
Date: Thu, 24 Feb 2011 18:56:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] genirq: Prepare the handling of shared oneshot
 interrupts
In-Reply-To: <AANLkTikoYrPjf4-6X7PLUShXXXrDU45t_T+ZkxyCtLnG@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102241849310.2701@localhost6.localdomain6>
References: <20110223231601.613115832@linutronix.de> <20110223234956.388095876@linutronix.de> <AANLkTikoYrPjf4-6X7PLUShXXXrDU45t_T+ZkxyCtLnG@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-322103401-1298570180=:2701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-322103401-1298570180=:2701
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 23 Feb 2011, Linus Torvalds wrote:
> On Wed, Feb 23, 2011 at 3:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > +               /*
> > +                * We or the mask lockless. Safe because the code
> > +                * which clears the mask is serialized
> > +                * vs. IRQ_INPROGRESS.
> > +                */
> > +               desc->threads_oneshot |= action->thread_mask;
> > +               wake_up_process(action->thread);
> 
> That comment makes no sense.
> 
> What has "code which clears the mask" to do with anything?
> 
> Even if another CPU _sets_ a bit, doing so in parallel will lose bits
> if it's not locked. One CPU will read the old value, set its bit, and
> store the new value: with the race, only one of the bits will be set.
> 
> So maybe the code is safe, but the comment is still totally wrong. You
> had better be safe not just against people clearing bits, you need to
> be safe against ANY OTHER WRITER (clear or set), including very much
> OTHER BITS in the same word.
> 
> So if it really is safe, comment on ALL the cases.

Fair enough, that comment really sucks if you are not familiar with
the gory details of that code.

What about the following replacement, which might be overly detailed,
but that's exactly how it works.

Thanks,

	tglx

Index: linux-2.6-tip/kernel/irq/handle.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/handle.c
+++ linux-2.6-tip/kernel/irq/handle.c
@@ -57,18 +57,60 @@ static void irq_wake_thread(struct irq_d
 	 * Wake up the handler thread for this action. In case the
 	 * thread crashed and was killed we just pretend that we
 	 * handled the interrupt. The hardirq handler has disabled the
-	 * device interrupt, so no irq storm is lurking.
+	 * device interrupt, so no irq storm is lurking. If the
+	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if (!test_bit(IRQTF_DIED, &action->thread_flags) &&
-	    !test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags)) {
-		/*
-		 * We or the mask lockless. Safe because the code
-		 * which clears the mask is serialized
-		 * vs. IRQ_INPROGRESS.
-		 */
-		desc->threads_oneshot |= action->thread_mask;
-		wake_up_process(action->thread);
-	}
+	if (test_bit(IRQTF_DIED, &action->thread_flags) ||
+	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+		return;
+
+	/*
+	 * It's safe to OR the mask lockless here. We have only two
+	 * places which write to threads_oneshot: This code and the
+	 * irq thread.
+	 *
+	 * This code is the hard irq context and can never run on two
+	 * cpus in parallel. If it ever does we have more serious
+	 * problems than this bitmask.
+	 *
+	 * The irq threads of this irq which clear their "running" bit
+	 * in threads_oneshot are serialized via desc->lock against
+	 * each other and they are serialized against this code by
+	 * IRQS_INPROGRESS.
+	 *
+	 * Hard irq handler:
+	 *
+	 *	spin_lock(desc->lock);
+	 *	desc->state |= IRQS_INPROGRESS;
+	 *	spin_unlock(desc->lock);
+	 *	set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
+	 *	desc->threads_oneshot |= mask;
+	 *	spin_unlock(desc->lock);
+	 *	desc->state &= ~IRQS_INPROGRESS;
+	 *	spin_unlock(desc->lock);
+	 *
+	 * irq thread:
+	 *
+	 * again:
+	 *	spin_lock(desc->lock);
+	 *	if (desc->state & IRQS_INPROGRESS) {
+	 *		spin_unlock(desc->lock);
+	 *		while(desc->state & IRQS_INPROGRESS)
+	 *			cpu_relax();
+	 *		goto again;
+	 *	}
+	 *	if (!test_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	 *		desc->threads_oneshot &= ~mask;
+	 *	spin_unlock(desc->lock);
+	 *
+	 * So either the thread waits for us to clear IRQS_INPROGRESS
+	 * or we are waiting in the flow handler for desc->lock to be
+	 * released before we reach this point. The thread also checks
+	 * IRQTF_RUNTHREAD under desc->lock. If set it leaves
+	 * threads_oneshot untouched and runs the thread another time.
+	 */
+	desc->threads_oneshot |= action->thread_mask;
+	wake_up_process(action->thread);
 }
 
 irqreturn_t
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -637,7 +637,8 @@ again:
 	 *
 	 * This also serializes the state of shared oneshot handlers
 	 * versus "desc->threads_onehsot |= action->thread_mask;" in
-	 * handle_irq_event().
+	 * irq_wake_thread(). See the comment there which explains the
+	 * serialization.
 	 */
 	if (unlikely(desc->istate & IRQS_INPROGRESS)) {
 		raw_spin_unlock_irq(&desc->lock);
---1463795968-322103401-1298570180=:2701--
