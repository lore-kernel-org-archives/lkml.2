Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1BJXoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:44:34 -0500
Received: from www.tglx.de ([62.245.132.106]:44358 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab1BJXhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:55 -0500
Message-Id: <20110210223259.231195512@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 51/75] genirq: Remove CONFIG_IRQ_PER_CPU
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-config-irq-per-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The saving of this switch is minimal versus the ifdef mess it
creates. Simple enable PER_CPU unconditionally and remove the config
switch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h    |    5 -----
 kernel/irq/Kconfig     |    3 ---
 kernel/irq/internals.h |    2 --
 kernel/irq/manage.c    |    9 +++------
 4 files changed, 3 insertions(+), 16 deletions(-)

Index: linux-2.6-tip/include/linux/irq.h
===================================================================
--- linux-2.6-tip.orig/include/linux/irq.h
+++ linux-2.6-tip/include/linux/irq.h
@@ -76,13 +76,8 @@ typedef	void (*irq_flow_handler_t)(unsig
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
 	 IRQ_PER_CPU)
 
-#ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
 # define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
-#else
-# define CHECK_IRQ_PER_CPU(var) 0
-# define IRQ_NO_BALANCING_MASK	IRQ_NO_BALANCING
-#endif
 
 /*
  * Return value for chip->irq_set_affinity()
Index: linux-2.6-tip/kernel/irq/Kconfig
===================================================================
--- linux-2.6-tip.orig/kernel/irq/Kconfig
+++ linux-2.6-tip/kernel/irq/Kconfig
@@ -32,9 +32,6 @@ config GENERIC_PENDING_IRQ
 config AUTO_IRQ_AFFINITY
        def_bool n
 
-config IRQ_PER_CPU
-       def_bool n
-
 config HARDIRQS_SW_RESEND
        def_bool n
 
Index: linux-2.6-tip/kernel/irq/internals.h
===================================================================
--- linux-2.6-tip.orig/kernel/irq/internals.h
+++ linux-2.6-tip/kernel/irq/internals.h
@@ -161,9 +161,7 @@ static inline void print_irq_desc(unsign
 	}
 
 	P(IRQ_LEVEL);
-#ifdef CONFIG_IRQ_PER_CPU
 	P(IRQ_PER_CPU);
-#endif
 	P(IRQ_NOPROBE);
 	P(IRQ_NOREQUEST);
 	P(IRQ_NOAUTOEN);
Index: linux-2.6-tip/kernel/irq/manage.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/manage.c
+++ linux-2.6-tip/kernel/irq/manage.c
@@ -871,12 +871,10 @@ __setup_irq(unsigned int irq, struct irq
 			goto mismatch;
 		}
 
-#if defined(CONFIG_IRQ_PER_CPU)
 		/* All handlers must agree on per-cpuness */
 		if ((old->flags & IRQF_PERCPU) !=
 		    (new->flags & IRQF_PERCPU))
 			goto mismatch;
-#endif
 
 		/* add new interrupt at end of irq queue */
 		do {
@@ -900,15 +898,14 @@ __setup_irq(unsigned int irq, struct irq
 				goto out_mask;
 		} else
 			compat_irq_chip_set_default_handler(desc);
-#if defined(CONFIG_IRQ_PER_CPU)
-		if (new->flags & IRQF_PERCPU)
-			desc->status |= IRQ_PER_CPU;
-#endif
 
 		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
 				  IRQS_INPROGRESS | IRQS_ONESHOT | \
 				  IRQS_WAITING);
 
+		if (new->flags & IRQF_PERCPU)
+			desc->status |= IRQ_PER_CPU;
+
 		if (new->flags & IRQF_ONESHOT)
 			desc->istate |= IRQS_ONESHOT;
 


