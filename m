Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2DKKRq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:17:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:57955 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2DKKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:17:44 -0400
Date: Wed, 11 Apr 2012 12:17:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.4-rc2-rt2
Message-ID: <alpine.LFD.2.02.1204111212440.2542@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.4-rc2-rt2 release.

Changes since 3.4-rc2-rt1:

	* Fix cpumask fallout (Carsten)

	* Convert omap wakeupgen_lock to raw

The delta patch to 3.4-rc2-rt1 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/incr/patch-3.4-rc2-rt1-rt2.patch.xz


The RT patch against 3.4-rc2 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patch-3.4-rc2-rt2.patch.xz


The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.4/patches-3.4-rc2-rt2.tar.xz

Enjoy,

	tglx
---
Index: linux-3.4/kernel/posix-cpu-timers.c
===================================================================
--- linux-3.4.orig/kernel/posix-cpu-timers.c
+++ linux-3.4/kernel/posix-cpu-timers.c
@@ -1483,8 +1483,8 @@ static int posix_cpu_thread_call(struct 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 		/* Unbind it from offline cpu so it can run.  Fall thru. */
-		kthread_bind(per_cpu(posix_timer_task,cpu),
-			     any_online_cpu(cpu_online_map));
+		kthread_bind(per_cpu(posix_timer_task, cpu),
+			     cpumask_any(cpu_online_mask));
 		kthread_stop(per_cpu(posix_timer_task,cpu));
 		per_cpu(posix_timer_task,cpu) = NULL;
 		break;
@@ -1512,7 +1512,7 @@ static int __init posix_cpu_thread_init(
 	unsigned long cpu;
 
 	/* init the per-cpu posix_timer_tasklets */
-	for_each_cpu_mask(cpu, cpu_possible_map)
+	for_each_possible_cpu(cpu)
 		per_cpu(posix_timer_tasklist, cpu) = NULL;
 
 	posix_cpu_thread_call(&posix_cpu_thread_notifier, CPU_UP_PREPARE, hcpu);
Index: linux-3.4/localversion-rt
===================================================================
--- linux-3.4.orig/localversion-rt
+++ linux-3.4/localversion-rt
@@ -1 +1 @@
--rt1
+-rt2
Index: linux-3.4/arch/arm/mach-omap2/omap-wakeupgen.c
===================================================================
--- linux-3.4.orig/arch/arm/mach-omap2/omap-wakeupgen.c
+++ linux-3.4/arch/arm/mach-omap2/omap-wakeupgen.c
@@ -43,7 +43,7 @@
 
 static void __iomem *wakeupgen_base;
 static void __iomem *sar_base;
-static DEFINE_SPINLOCK(wakeupgen_lock);
+static DEFINE_RAW_SPINLOCK(wakeupgen_lock);
 static unsigned int irq_target_cpu[NR_IRQS];
 
 /*
@@ -128,9 +128,9 @@ static void wakeupgen_mask(struct irq_da
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wakeupgen_lock, flags);
+	raw_spin_lock_irqsave(&wakeupgen_lock, flags);
 	_wakeupgen_clear(d->irq, irq_target_cpu[d->irq]);
-	spin_unlock_irqrestore(&wakeupgen_lock, flags);
+	raw_spin_unlock_irqrestore(&wakeupgen_lock, flags);
 }
 
 /*
@@ -140,9 +140,9 @@ static void wakeupgen_unmask(struct irq_
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wakeupgen_lock, flags);
+	raw_spin_lock_irqsave(&wakeupgen_lock, flags);
 	_wakeupgen_set(d->irq, irq_target_cpu[d->irq]);
-	spin_unlock_irqrestore(&wakeupgen_lock, flags);
+	raw_spin_unlock_irqrestore(&wakeupgen_lock, flags);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -183,7 +183,7 @@ static void wakeupgen_irqmask_all(unsign
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&wakeupgen_lock, flags);
+	raw_spin_lock_irqsave(&wakeupgen_lock, flags);
 	if (set) {
 		_wakeupgen_save_masks(cpu);
 		_wakeupgen_set_all(cpu, WKG_MASK_ALL);
@@ -191,7 +191,7 @@ static void wakeupgen_irqmask_all(unsign
 		_wakeupgen_set_all(cpu, WKG_UNMASK_ALL);
 		_wakeupgen_restore_masks(cpu);
 	}
-	spin_unlock_irqrestore(&wakeupgen_lock, flags);
+	raw_spin_unlock_irqrestore(&wakeupgen_lock, flags);
 }
 #endif
 
