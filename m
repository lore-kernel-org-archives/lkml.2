Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1BCAsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:48:09 -0500
Received: from www.tglx.de ([62.245.132.106]:37640 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab1BCAr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:47:27 -0500
Message-Id: <20110203004210.722023160@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 Feb 2011 00:47:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
        David Howells <dhowells@redhat.com>, Michal Simek <monstr@monstr.eu>
Subject: [patch 8/8] genirq-remove-stale-irq-end.patch
References: <20110203003745.371989282@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-stale-irq-end.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    2 --
 kernel/irq/chip.c      |    3 ---
 kernel/irq/dummychip.c |    9 ---------
 kernel/irq/internals.h |   10 ----------
 kernel/irq/spurious.c  |    6 ------
 5 files changed, 30 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -126,7 +126,6 @@ struct irq_data {
  * @mask_ack:		deprecated, replaced by irq_mask_ack
  * @unmask:		deprecated, replaced by irq_unmask
  * @eoi:		deprecated, replaced by irq_eoi
- * @end:		deprecated, will go away with __do_IRQ()
  * @set_affinity:	deprecated, replaced by irq_set_affinity
  * @retrigger:		deprecated, replaced by irq_retrigger
  * @set_type:		deprecated, replaced by irq_set_type
@@ -166,7 +165,6 @@ struct irq_chip {
 	void		(*unmask)(unsigned int irq);
 	void		(*eoi)(unsigned int irq);
 
-	void		(*end)(unsigned int irq);
 	int		(*set_affinity)(unsigned int irq,
 					const struct cpumask *dest);
 	int		(*retrigger)(unsigned int irq);
Index: linux-2.6-tip/kernel/irq/chip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/chip.c
+++ linux-2.6-tip/kernel/irq/chip.c
@@ -348,9 +348,6 @@ void irq_chip_set_defaults(struct irq_ch
 			chip->irq_disable : default_shutdown;
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-	if (!chip->end)
-		chip->end = dummy_irq_chip.end;
-
 	/*
 	 * Now fix up the remaining compat handlers
 	 */
Index: linux-2.6-tip/kernel/irq/dummychip.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/dummychip.c
+++ linux-2.6-tip/kernel/irq/dummychip.c
@@ -31,13 +31,6 @@ static unsigned int noop_ret(struct irq_
 	return 0;
 }
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-static void compat_noop(unsigned int irq) { }
-#define END_INIT .end = compat_noop
-#else
-#define END_INIT
-#endif
-
 /*
  * Generic no controller implementation
  */
@@ -48,7 +41,6 @@ struct irq_chip no_irq_chip = {
 	.irq_enable	= noop,
 	.irq_disable	= noop,
 	.irq_ack	= ack_bad,
-	END_INIT
 };
 
 /*
@@ -64,5 +56,4 @@ struct irq_chip dummy_irq_chip = {
 	.irq_ack	= noop,
 	.irq_mask	= noop,
 	.irq_unmask	= noop,
-	END_INIT
 };
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -41,16 +41,6 @@ extern int irq_select_affinity_usr(unsig
 
 extern void irq_set_thread_affinity(struct irq_desc *desc);
 
-#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
-static inline void irq_end(unsigned int irq, struct irq_desc *desc)
-{
-	if (desc->irq_data.chip && desc->irq_data.chip->end)
-		desc->irq_data.chip->end(irq);
-}
-#else
-static inline void irq_end(unsigned int irq, struct irq_desc *desc) { }
-#endif
-
 /* Inline functions for support of irq chips on slow busses */
 static inline void chip_bus_lock(struct irq_desc *desc)
 {
Index: linux-2.6-tip/kernel/irq/spurious.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/spurious.c
+++ linux-2.6-tip/kernel/irq/spurious.c
@@ -76,12 +76,6 @@ static int try_one_irq(int irq, struct i
 		desc->status &= ~IRQ_PENDING;
 	}
 	desc->status &= ~IRQ_INPROGRESS;
-	/*
-	 * If we did actual work for the real IRQ line we must let the
-	 * IRQ controller clean up too
-	 */
-	if (work)
-		irq_end(irq, desc);
 	raw_spin_unlock(&desc->lock);
 
 	return ok;


