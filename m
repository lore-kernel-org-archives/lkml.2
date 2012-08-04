Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2HDUQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 16:16:35 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2HDUQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 16:16:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [Regression, post-3.5][PATCH] Revert "NMI watchdog: fix for lockup detector breakage on resume"
Date: Sat, 4 Aug 2012 22:22:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sameer Nanda <snanda@chromium.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208042222.22413.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Revert commit 45226e9 (NMI watchdog: fix for lockup detector breakage
on resume) which breaks resume from system suspend on my SH7372
Mackerel board (by causing a NULL pointer dereference to happen) and
is generally wrong, because it abuses CPU hotplug notifications in a
shamelessly blatant way.

The original issue should be addressed through appropriate syscore
resume callback instead.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/sched.h  |    8 --------
 kernel/power/suspend.c |    3 ---
 kernel/watchdog.c      |   21 ++-------------------
 3 files changed, 2 insertions(+), 30 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -334,14 +334,6 @@ static inline void lockup_detector_init(
 }
 #endif
 
-#if defined(CONFIG_LOCKUP_DETECTOR) && defined(CONFIG_SUSPEND)
-void lockup_detector_bootcpu_resume(void);
-#else
-static inline void lockup_detector_bootcpu_resume(void)
-{
-}
-#endif
-
 #ifdef CONFIG_DETECT_HUNG_TASK
 extern unsigned int  sysctl_hung_task_panic;
 extern unsigned long sysctl_hung_task_check_count;
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -178,9 +178,6 @@ static int suspend_enter(suspend_state_t
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
-	/* Kick the lockup detector */
-	lockup_detector_bootcpu_resume();
-
  Enable_cpus:
 	enable_nonboot_cpus();
 
Index: linux/kernel/watchdog.c
===================================================================
--- linux.orig/kernel/watchdog.c
+++ linux/kernel/watchdog.c
@@ -575,7 +575,7 @@ out:
 /*
  * Create/destroy watchdog threads as CPUs come and go:
  */
-static int
+static int __cpuinit
 cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -610,27 +610,10 @@ cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpu_nfb = {
+static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
-#ifdef CONFIG_SUSPEND
-/*
- * On exit from suspend we force an offline->online transition on the boot CPU
- * so that the PMU state that was lost while in suspended state gets set up
- * properly for the boot CPU.  This information is required for restarting the
- * NMI watchdog.
- */
-void lockup_detector_bootcpu_resume(void)
-{
-	void *cpu = (void *)(long)smp_processor_id();
-
-	cpu_callback(&cpu_nfb, CPU_DEAD_FROZEN, cpu);
-	cpu_callback(&cpu_nfb, CPU_UP_PREPARE_FROZEN, cpu);
-	cpu_callback(&cpu_nfb, CPU_ONLINE_FROZEN, cpu);
-}
-#endif
-
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
