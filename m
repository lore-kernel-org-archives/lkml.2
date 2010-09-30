Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0I3XRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:33 -0400
Received: from www.tglx.de ([62.245.132.106]:52869 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0I3XRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:31 -0400
Message-Id: <20100930221740.348118306@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 19/47] genirq: Query arch for number of early descriptors
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline;
	filename=genirq-ask-arch-for-number-of-irqs-to-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse irq sets up NR_IRQS_LEGACY irq descriptors and archs then go
ahead and allocate more.

Use the unused return value of arch_probe_nr_irqs() to let the
architecture return the number of early allocations. Fix up all users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/kernel/irq.c          |    8 +-------
 arch/sh/kernel/irq.c           |    2 +-
 arch/x86/kernel/apic/io_apic.c |    2 +-
 kernel/irq/irqdesc.c           |    6 +++---
 kernel/softirq.c               |    2 +-
 5 files changed, 7 insertions(+), 13 deletions(-)

Index: linux-2.6-tip/arch/arm/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/kernel/irq.c
+++ linux-2.6-tip/arch/arm/kernel/irq.c
@@ -148,12 +148,6 @@ void set_irq_flags(unsigned int irq, uns
 
 void __init init_IRQ(void)
 {
-	struct irq_desc *desc;
-	int irq;
-
-	for (irq = 0; irq < nr_irqs; irq++)
-		desc = irq_to_desc_alloc_node(irq, 0);
-
 	init_arch_irq();
 }
 
@@ -161,7 +155,7 @@ void __init init_IRQ(void)
 int __init arch_probe_nr_irqs(void)
 {
 	nr_irqs = arch_nr_irqs ? arch_nr_irqs : NR_IRQS;
-	return 0;
+	return nr_irqs;
 }
 #endif
 
Index: linux-2.6-tip/arch/sh/kernel/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/kernel/irq.c
+++ linux-2.6-tip/arch/sh/kernel/irq.c
@@ -290,7 +290,7 @@ void __init init_IRQ(void)
 int __init arch_probe_nr_irqs(void)
 {
 	nr_irqs = sh_mv.mv_nr_irqs;
-	return 0;
+	return NR_IRQS_LEGACY;
 }
 #endif
 
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -3886,7 +3886,7 @@ int __init arch_probe_nr_irqs(void)
 	if (nr < nr_irqs)
 		nr_irqs = nr;
 
-	return 0;
+	return nr_irqs_gsi;
 }
 #endif
 
Index: linux-2.6-tip/kernel/irq/irqdesc.c
===================================================================
--- linux-2.6-tip.orig/kernel/irq/irqdesc.c
+++ linux-2.6-tip/kernel/irq/irqdesc.c
@@ -225,16 +225,16 @@ struct irq_desc * __ref irq_to_desc_allo
 
 int __init early_irq_init(void)
 {
-	int i, node = first_online_node;
+	int i, initcnt, node = first_online_node;
 	struct irq_desc *desc;
 
 	init_irq_default_affinity();
 
 	 /* initialize nr_irqs based on nr_cpu_ids */
-	arch_probe_nr_irqs();
+	initcnt = arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
 
-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
+	for (i = 0; i < initcnt; i++) {
 		desc = alloc_desc(i, node);
 		set_bit(i, allocated_irqs);
 		irq_insert_desc(i, desc);
Index: linux-2.6-tip/kernel/softirq.c
===================================================================
--- linux-2.6-tip.orig/kernel/softirq.c
+++ linux-2.6-tip/kernel/softirq.c
@@ -888,7 +888,7 @@ int __init __weak early_irq_init(void)
 
 int __init __weak arch_probe_nr_irqs(void)
 {
-	return 0;
+	return NR_IRQS_LEGACY;
 }
 
 int __init __weak arch_early_irq_init(void)


