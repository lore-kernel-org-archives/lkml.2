Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab2EHM2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:28:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54730 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab2EHM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:27:59 -0400
Date: Tue, 8 May 2012 05:27:47 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-85f7f656274fa0ba109dd8774db3887d42de5c6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20120507175652.190382227@linutronix.de>
References: <20120507175652.190382227@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] x86: Use kick_all_cpus_sync()
Git-Commit-ID: 85f7f656274fa0ba109dd8774db3887d42de5c6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:27:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85f7f656274fa0ba109dd8774db3887d42de5c6b
Gitweb:     http://git.kernel.org/tip/85f7f656274fa0ba109dd8774db3887d42de5c6b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:06 +0200

x86: Use kick_all_cpus_sync()

Use kick_all_cpus_sync() and remove cpu_idle_wait().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120507175652.190382227@linutronix.de
Cc: x86@kernel.org
---
 arch/x86/Kconfig                 |    3 ---
 arch/x86/include/asm/processor.h |    2 --
 arch/x86/kernel/apm_32.c         |    2 +-
 arch/x86/kernel/process.c        |   20 --------------------
 4 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 046bf4b..98876f5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -161,9 +161,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool X86_XADD
 
-config ARCH_HAS_CPU_IDLE_WAIT
-	def_bool y
-
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4fa7dcc..ccbb1ea 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -974,8 +974,6 @@ extern bool cpu_has_amd_erratum(const int *);
 #define cpu_has_amd_erratum(x)	(false)
 #endif /* CONFIG_CPU_SUP_AMD */
 
-void cpu_idle_wait(void);
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 459e78c..07b0c0d 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -2401,7 +2401,7 @@ static void __exit apm_exit(void)
 		 * (pm_idle), Wait for all processors to update cached/local
 		 * copies of pm_idle before proceeding.
 		 */
-		cpu_idle_wait();
+		kick_all_cpus_sync();
 	}
 	if (((apm_info.bios.flags & APM_BIOS_DISENGAGED) == 0)
 	    && (apm_info.connection_version > 0x0100)) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 8aa532f..8215458 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
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
