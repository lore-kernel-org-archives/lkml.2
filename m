Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2EHMb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:31:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54854 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2EHMb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:31:28 -0400
Date: Tue, 8 May 2012 05:31:07 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-86627c93b35082f7a0e4d3111546943984b932c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, lethal@linux-sh.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lethal@linux-sh.org
In-Reply-To: <20120507175652.461648208@linutronix.de>
References: <20120507175652.461648208@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sh: Remove cpu_idle_wait()
Git-Commit-ID: 86627c93b35082f7a0e4d3111546943984b932c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 05:31:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86627c93b35082f7a0e4d3111546943984b932c7
Gitweb:     http://git.kernel.org/tip/86627c93b35082f7a0e4d3111546943984b932c7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 7 May 2012 17:59:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 8 May 2012 12:35:07 +0200

sh: Remove cpu_idle_wait()

cpuidle uses generic kick_all_cpus_sync() now. Remove the unused code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120507175652.461648208@linutronix.de
---
 arch/sh/Kconfig                 |    3 ---
 arch/sh/include/asm/processor.h |    1 -
 arch/sh/kernel/idle.c           |   20 --------------------
 3 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 244cfd0..04a8cb4 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -153,9 +153,6 @@ config ARCH_NO_VIRT_TO_BUS
 config ARCH_HAS_DEFAULT_IDLE
 	def_bool y
 
-config ARCH_HAS_CPU_IDLE_WAIT
-	def_bool y
-
 config NO_IOPORT
 	def_bool !PCI
 	depends on !SH_CAYMAN && !SH_SH4202_MICRODEV && !SH_SHMIN
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index 6d87912..6dbc1be 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -98,7 +98,6 @@ extern struct sh_cpuinfo cpu_data[];
 #define cpu_relax()	barrier()
 
 void default_idle(void);
-void cpu_idle_wait(void);
 void stop_this_cpu(void *);
 
 /* Forward decl */
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index ee226e2..0c91016 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
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
