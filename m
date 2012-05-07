Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2EGR7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:59:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:41407 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2EGR7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:59:52 -0400
Message-Id: <20120507175652.190382227@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 07 May 2012 17:59:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: [patch 4/8] x86: Use kick_all_cpus_sync()
References: <20120507175450.513667947@linutronix.de>
Content-Disposition: inline; filename=x86-use-kick_all_cpus_sync.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kick_all_cpus_sync() and remove cpu_idle_wait().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/Kconfig                 |    3 ---
 arch/x86/include/asm/processor.h |    2 --
 arch/x86/kernel/apm_32.c         |    2 +-
 arch/x86/kernel/process.c        |   20 --------------------
 4 files changed, 1 insertion(+), 26 deletions(-)

Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -161,9 +161,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
-config ARCH_HAS_CPU_IDLE_WAIT
-	def_bool y
-
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
Index: tip/arch/x86/include/asm/processor.h
===================================================================
--- tip.orig/arch/x86/include/asm/processor.h
+++ tip/arch/x86/include/asm/processor.h
@@ -974,8 +974,6 @@ extern bool cpu_has_amd_erratum(const in
 #define cpu_has_amd_erratum(x)	(false)
 #endif /* CONFIG_CPU_SUP_AMD */
 
-void cpu_idle_wait(void);
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
Index: tip/arch/x86/kernel/apm_32.c
===================================================================
--- tip.orig/arch/x86/kernel/apm_32.c
+++ tip/arch/x86/kernel/apm_32.c
@@ -2401,7 +2401,7 @@ static void __exit apm_exit(void)
 		 * (pm_idle), Wait for all processors to update cached/local
 		 * copies of pm_idle before proceeding.
 		 */
-		cpu_idle_wait();
+		kick_all_cpus_sync();
 	}
 	if (((apm_info.bios.flags & APM_BIOS_DISENGAGED) == 0)
 	    && (apm_info.connection_version > 0x0100)) {
Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c
+++ tip/arch/x86/kernel/process.c
@@ -525,26 +525,6 @@ void stop_this_cpu(void *dummy)
 	}
 }
 
-static void do_nothing(void *unused)
-{
-}
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
-
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {


