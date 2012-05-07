Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2EGSAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:00:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:41410 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2EGR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:53 -0400
Message-Id: <20120507175652.461648208@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mundt <lethal@linux-sh.org>
Subject: [patch 8/8] sh: Remove cpu_idle_wait()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=sh-use-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle uses the generic kick_all_cpus_sync() now. Remove the unused
code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig                 |    3 ---
 arch/sh/include/asm/processor.h |    1 -
 arch/sh/kernel/idle.c           |   20 --------------------
 3 files changed, 24 deletions(-)

Index: tip/arch/sh/Kconfig
===================================================================
--- tip.orig/arch/sh/Kconfig
+++ tip/arch/sh/Kconfig
@@ -153,9 +153,6 @@ config ARCH_NO_VIRT_TO_BUS
 config ARCH_HAS_DEFAULT_IDLE
 	def_bool y
 
-config ARCH_HAS_CPU_IDLE_WAIT
-	def_bool y
-
 config NO_IOPORT
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN
Index: tip/arch/sh/include/asm/processor.h
===================================================================
--- tip.orig/arch/sh/include/asm/processor.h
+++ tip/arch/sh/include/asm/processor.h
@@ -98,7 +98,6 @@ extern struct sh_cpuinfo cpu_data[];
 #define cpu_relax()	barrier()
 
 void default_idle(void);
-void cpu_idle_wait(void);
 void stop_this_cpu(void *);
 
 /* Forward decl */
Index: tip/arch/sh/kernel/idle.c
===================================================================
--- tip.orig/arch/sh/kernel/idle.c
+++ tip/arch/sh/kernel/idle.c
@@ -132,10 +132,6 @@ void __init select_idle_routine(void)
 		pm_idle = poll_idle;
 }
 
-static void do_nothing(void *unused)
-{
-}
-
 void stop_this_cpu(void *unused)
 {
 	local_irq_disable();
@@ -144,19 +140,3 @@ void stop_this_cpu(void *unused)
 	for (;;)
 		cpu_sleep();
 }
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);


