Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab2D0STn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:19:43 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43500 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760965Ab2D0STj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:19:39 -0400
From: Sameer Nanda <snanda@chromium.org>
To: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, akpm@linux-foundation.org, dzickus@redhat.com,
        msb@chromium.org
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, olofj@chromium.org,
        Sameer Nanda <snanda@chromium.org>
Subject: [PATCH] watchdog: fix for lockup detector breakage on resume
Date: Fri, 27 Apr 2012 11:10:40 -0700
Message-Id: <1335550240-17765-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the suspend/resume path the boot CPU does not go though an
offline->online transition.  This breaks the NMI detector
post-resume since it depends on PMU state that is lost when
the system gets suspended.

Fix this by forcing a CPU offline->online transition for the
lockup detector on the boot CPU during resume.

Signed-off-by: Sameer Nanda <snanda@chromium.org>
---
To provide more context, we enable NMI watchdog on
Chrome OS.  We have seen several reports of systems freezing
up completely which indicated that the NMI watchdog was not
firing for some reason.

Debugging further, we found a simple way of repro'ing system
freezes -- issuing the command 'tasket 1 sh -c "echo nmilockup > /proc/breakme"'
after the system has been suspended/resumed one or more times.

With this patch in place, the system freeze result in panics,
as expected.  These panics provide a nice stack trace for us
to debug the actual issue causing the freeze.


 include/linux/sched.h  |    4 ++++
 kernel/power/suspend.c |    3 +++
 kernel/watchdog.c      |   16 ++++++++++++++++
 3 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a173c..118cc38 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -317,6 +317,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 void lockup_detector_init(void);
+void lockup_detector_bootcpu_resume(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -330,6 +331,9 @@ static inline void touch_all_softlockup_watchdogs(void)
 static inline void lockup_detector_init(void)
 {
 }
+static inline void lockup_detector_bootcpu_resume(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 396d262..0d262a8 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -177,6 +177,9 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
 
+	/* Kick the lockup detector */
+	lockup_detector_bootcpu_resume();
+
  Enable_cpus:
 	enable_nonboot_cpus();
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index df30ee0..dd2ac93 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -585,6 +585,22 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+void lockup_detector_bootcpu_resume(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+
+	/*
+	 * On the suspend/resume path the boot CPU does not go though the
+	 * offline->online transition. This breaks the NMI detector post
+	 * resume. Force an offline->online transition for the boot CPU on
+	 * resume.
+	 */
+	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
+	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
+
+	return;
+}
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
-- 
1.7.7.3

