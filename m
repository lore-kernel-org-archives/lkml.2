Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab1LEVzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:55:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:57586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372Ab1LEVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:55:03 -0500
Date: Mon, 5 Dec 2011 22:55:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ido Yariv <ido@wizery.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] genirq: Flush the irq thread on synchronization
In-Reply-To: <alpine.LFD.2.02.1112022345300.2735@ionos>
Message-ID: <alpine.LFD.2.02.1112052248010.2735@ionos>
References: <1322843052-7166-1-git-send-email-ido@wizery.com> <alpine.LFD.2.02.1112022345300.2735@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Dec 2011, Thomas Gleixner wrote:
> On Fri, 2 Dec 2011, Ido Yariv wrote:
> 
> > The current implementation does not always flush the threaded handler
> > when disabling the irq. In case the irq handler was called, but the
> > threaded handler hasn't started running yet, the interrupt will be
> > flagged as pending, and the handler will not run. This implementation
> > has some issues:
> > 
> > First, if the interrupt is a wake source and flagged as pending, the
> > system will not be able to suspend.
> > 
> > Second, when quickly disabling and re-enabling the irq, the threaded
> > handler might continue to run after the irq is re-enabled without the
> > irq handler being called first. This might be an unexpected behavior.
> 
> I'd wish people would stop calling disable/enable_irq() in loops and
> circles for no reason.
> 
> > In addition, it might be counter-intuitive that the threaded handler
> > will not be called even though the irq handler was called and returned
> > IRQ_WAKE_THREAD.
> > 
> > Fix this by always waiting for the threaded handler to complete in
> > synchronize_irq().
> 
> I can see your problem, but this might lead to threads_active leaks
> under certain conditions. desc->threads_active was only meant to deal
> with shared interrupts.
> 
> We explicitely allow a design where the primary handler can leave the
> device interrupt enabled and allow further interrupts to occur while
> the handler is running. We only have a single bit to note that the
> thread should run, but your wakeup would up the threads_active count
> in that scenario several times w/o a counterpart which decrements it.
> 
> The solution for this is to keep the current threads_active semantics
> and make the wait function different. Instead of waiting for
> threads_active to become 0 it should wait for threads_active == 0 and
> the IRQTF_RUNTHREAD for all actions to be cleared. To avoid looping
> over the actions, we can take a similar approach as we take with the
> desc->threads_oneshot bitfield.

Does the following (untested) patch solve your issues?

Thanks,

	tglx

Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -28,6 +28,18 @@ static int __init setup_forced_irqthread
 early_param("threadirqs", setup_forced_irqthreads);
 #endif
 
+static bool irq_threads_stopped(struct irq_desc *desc)
+{
+	unsigned long flags;
+	bool res;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	res = !atomic_read(&desc->threads_active) &&
+		!desc->threads_oneshot;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	return res;
+}
+
 /**
  *	synchronize_irq - wait for pending IRQ handlers (on other CPUs)
  *	@irq: interrupt number to wait for
@@ -68,7 +80,7 @@ void synchronize_irq(unsigned int irq)
 	 * We made sure that no hardirq handler is running. Now verify
 	 * that no threaded handlers are active.
 	 */
-	wait_event(desc->wait_for_threads, !atomic_read(&desc->threads_active));
+	wait_event(desc->wait_for_threads, irq_threads_stopped(desc));
 }
 EXPORT_SYMBOL(synchronize_irq);
 
@@ -639,13 +651,11 @@ static int irq_wait_for_interrupt(struct
 /*
  * Oneshot interrupts keep the irq line masked until the threaded
  * handler finished. unmask if the interrupt has not been disabled and
- * is marked MASKED.
+ * is marked MASKED. We also track that way that all threads are done.
  */
 static void irq_finalize_oneshot(struct irq_desc *desc,
 				 struct irqaction *action, bool force)
 {
-	if (!(desc->istate & IRQS_ONESHOT))
-		return;
 again:
 	chip_bus_lock(desc);
 	raw_spin_lock_irq(&desc->lock);
@@ -681,6 +691,9 @@ again:
 
 	desc->threads_oneshot &= ~action->thread_mask;
 
+	if (!(desc->istate & IRQS_ONESHOT))
+		goto out_unlock;
+
 	if (!desc->threads_oneshot && !irqd_irq_disabled(&desc->irq_data) &&
 	    irqd_irq_masked(&desc->irq_data))
 		unmask_irq(desc);
@@ -780,30 +793,15 @@ static int irq_thread(void *data)
 	current->irqaction = action;
 
 	while (!irq_wait_for_interrupt(action)) {
+		irqreturn_t action_ret;
 
 		irq_thread_check_affinity(desc, action);
 
 		atomic_inc(&desc->threads_active);
 
-		raw_spin_lock_irq(&desc->lock);
-		if (unlikely(irqd_irq_disabled(&desc->irq_data))) {
-			/*
-			 * CHECKME: We might need a dedicated
-			 * IRQ_THREAD_PENDING flag here, which
-			 * retriggers the thread in check_irq_resend()
-			 * but AFAICT IRQS_PENDING should be fine as it
-			 * retriggers the interrupt itself --- tglx
-			 */
-			desc->istate |= IRQS_PENDING;
-			raw_spin_unlock_irq(&desc->lock);
-		} else {
-			irqreturn_t action_ret;
-
-			raw_spin_unlock_irq(&desc->lock);
-			action_ret = handler_fn(desc, action);
-			if (!noirqdebug)
-				note_interrupt(action->irq, desc, action_ret);
-		}
+		action_ret = handler_fn(desc, action);
+		if (!noirqdebug)
+			note_interrupt(action->irq, desc, action_ret);
 
 		wake = atomic_dec_and_test(&desc->threads_active);
 
@@ -993,7 +991,7 @@ __setup_irq(unsigned int irq, struct irq
 	 * Setup the thread mask for this irqaction. Unlikely to have
 	 * 32 resp 64 irqs sharing one line, but who knows.
 	 */
-	if (new->flags & IRQF_ONESHOT && thread_mask == ~0UL) {
+	if (thread_mask == ~0UL) {
 		ret = -EBUSY;
 		goto out_mask;
 	}
