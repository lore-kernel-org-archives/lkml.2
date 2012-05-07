Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab2EGSBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:01:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:41397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2EGR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:51 -0400
Message-Id: <20120507175652.330322737@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 6/8] powerpc: Remove unused cpu_idle_wait()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=powerpc-use-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuidle uses a generic function now. Remove the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/Kconfig                 |    4 ----
 arch/powerpc/include/asm/processor.h |    1 -
 arch/powerpc/kernel/idle.c           |   19 -------------------
 3 files changed, 24 deletions(-)

Index: tip/arch/powerpc/Kconfig
===================================================================
--- tip.orig/arch/powerpc/Kconfig
+++ tip/arch/powerpc/Kconfig
@@ -87,10 +87,6 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y if 64BIT
 
-config ARCH_HAS_CPU_IDLE_WAIT
-	bool
-	default y
-
 config GENERIC_HWEIGHT
 	bool
 	default y
Index: tip/arch/powerpc/include/asm/processor.h
===================================================================
--- tip.orig/arch/powerpc/include/asm/processor.h
+++ tip/arch/powerpc/include/asm/processor.h
@@ -386,7 +386,6 @@ extern unsigned long cpuidle_disable;
 enum idle_boot_override {IDLE_NO_OVERRIDE = 0, IDLE_POWERSAVE_OFF};
 
 extern int powersave_nap;	/* set if nap mode can be used in idle loop */
-void cpu_idle_wait(void);
 
 #ifdef CONFIG_PSERIES_IDLE
 extern void update_smt_snooze_delay(int snooze);
Index: tip/arch/powerpc/kernel/idle.c
===================================================================
--- tip.orig/arch/powerpc/kernel/idle.c
+++ tip/arch/powerpc/kernel/idle.c
@@ -113,25 +113,6 @@ void cpu_idle(void)
 	}
 }
 
-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs come out of the old
- * idle loop and start using the new idle loop.
- * Required while changing idle handler on SMP systems.
- * Caller must have changed idle handler to the new value before the call.
- * This window may be larger on shared systems.
- */
-void cpu_idle_wait(void)
-{
-	smp_mb();
-	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
 int powersave_nap;
 
 #ifdef CONFIG_SYSCTL


