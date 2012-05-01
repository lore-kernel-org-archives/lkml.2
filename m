Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2EARXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 13:23:09 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:59520 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757918Ab2EARXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 13:23:06 -0400
From: Sameer Nanda <snanda@chromium.org>
To: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, akpm@linux-foundation.org, dzickus@redhat.com,
        msb@chromium.org
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, olofj@chromium.org,
        Sameer Nanda <snanda@chromium.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2] watchdog: fix for lockup detector breakage on resume
Date: Tue,  1 May 2012 10:22:36 -0700
Message-Id: <1335892956-30606-1-git-send-email-snanda@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335550240-17765-1-git-send-email-snanda@chromium.org>
References: <1335550240-17765-1-git-send-email-snanda@chromium.org>
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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
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

 include/linux/sched.h  |    8 ++++++++
 kernel/power/suspend.c |    3 +++
 kernel/watchdog.c      |   17 +++++++++++++++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81a173c..44f6046 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -332,6 +332,14 @@ static inline void lockup_detector_init(void)
 }
 #endif
 
+#if defined(CONFIG_LOCKUP_DETECTOR) && defined(CONFIG_SUSPEND)
+void lockup_detector_bootcpu_resume(void);
+#else
+static inline void lockup_detector_bootcpu_resume(void)
+{
+}
+#endif
+
 #ifdef CONFIG_DETECT_HUNG_TASK
 extern unsigned int  sysctl_hung_task_panic;
 extern unsigned long sysctl_hung_task_check_count;
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
index df30ee0..dae2482 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -585,6 +585,23 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
 	.notifier_call = cpu_callback
 };
 
+#ifdef CONFIG_SUSPEND
+/*
+ * On exit from suspend we force an offline->online transition on the boot CPU
+ * so that the PMU state that was lost while in suspended state gets set up
+ * properly for the boot CPU.  This information is required for restarting the
+ * NMI watchdog.
+ */
+void lockup_detector_bootcpu_resume(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+
+	cpu_callback(&cpu_nfb, CPU_DEAD_FROZEN, cpu);
+	cpu_callback(&cpu_nfb, CPU_UP_PREPARE_FROZEN, cpu);
+	cpu_callback(&cpu_nfb, CPU_ONLINE_FROZEN, cpu);
+}
+#endif
+
 void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
-- 
1.7.7.3

