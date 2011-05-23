Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab1EWFMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:12:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1EWFMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:12:00 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] watchdog: disable watchdog when thresh is zero
Date: Sun, 22 May 2011 22:10:22 -0700
Message-Id: <1306127423-3347-3-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1306127423-3347-1-git-send-email-msb@chromium.org>
References: <1306127423-3347-1-git-send-email-msb@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This restores the previous behavior of softlock_thresh.

Currently, setting watchdog_thresh to zero causes the watchdog
kthreads to consume a lot of CPU.

In addition, the logic of proc_dowatchdog_thresh and proc_dowatchdog_enabled
has been factored into proc_dowatchdog.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
LKML-Reference: <20110517071018.GE22305@elte.hu>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/nmi.h   |    5 +++--
 include/linux/sched.h |    1 -
 kernel/sysctl.c       |   12 ++++++++----
 kernel/watchdog.c     |   25 +++++++++----------------
 4 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index c536f85..5317b8b 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -47,9 +47,10 @@ static inline bool trigger_all_cpu_backtrace(void)
 int hw_nmi_is_cpu_stuck(struct pt_regs *);
 u64 hw_nmi_get_sample_period(void);
 extern int watchdog_enabled;
+extern int watchdog_thresh;
 struct ctl_table;
-extern int proc_dowatchdog_enabled(struct ctl_table *, int ,
-			void __user *, size_t *, loff_t *);
+extern int proc_dowatchdog(struct ctl_table *, int ,
+			   void __user *, size_t *, loff_t *);
 #endif
 
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7ee2530..aaf71e0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -315,7 +315,6 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
-extern int softlockup_thresh;
 void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c0bb324..3dd0c46 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -730,14 +730,16 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog_enabled,
+		.proc_handler   = proc_dowatchdog,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 	{
 		.procname	= "watchdog_thresh",
-		.data		= &softlockup_thresh,
+		.data		= &watchdog_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dowatchdog_thresh,
+		.proc_handler	= proc_dowatchdog,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
@@ -755,7 +757,9 @@ static struct ctl_table kern_table[] = {
 		.data           = &watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = proc_dowatchdog_enabled,
+		.proc_handler   = proc_dowatchdog,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index cf0e09f..6030191 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -28,7 +28,7 @@
 #include <linux/perf_event.h>
 
 int watchdog_enabled = 1;
-int __read_mostly softlockup_thresh = 60;
+int __read_mostly watchdog_thresh = 60;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
@@ -105,12 +105,12 @@ static unsigned long get_timestamp(int this_cpu)
 static unsigned long get_sample_period(void)
 {
 	/*
-	 * convert softlockup_thresh from seconds to ns
+	 * convert watchdog_thresh from seconds to ns
 	 * the divide by 5 is to give hrtimer 5 chances to
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return softlockup_thresh * (NSEC_PER_SEC / 5);
+	return watchdog_thresh * (NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
@@ -182,7 +182,7 @@ static int is_softlockup(unsigned long touch_ts)
 	unsigned long now = get_timestamp(smp_processor_id());
 
 	/* Warn about unreasonable delays: */
-	if (time_after(now, touch_ts + softlockup_thresh))
+	if (time_after(now, touch_ts + watchdog_thresh))
 		return now - touch_ts;
 
 	return 0;
@@ -501,19 +501,19 @@ static void watchdog_disable_all_cpus(void)
 /* sysctl functions */
 #ifdef CONFIG_SYSCTL
 /*
- * proc handler for /proc/sys/kernel/nmi_watchdog
+ * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
-int proc_dowatchdog_enabled(struct ctl_table *table, int write,
-		     void __user *buffer, size_t *length, loff_t *ppos)
+int proc_dowatchdog(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
 
-	ret = proc_dointvec(table, write, buffer, length, ppos);
+	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret || !write)
 		goto out;
 
-	if (watchdog_enabled)
+	if (watchdog_enabled && watchdog_thresh)
 		watchdog_enable_all_cpus();
 	else
 		watchdog_disable_all_cpus();
@@ -521,13 +521,6 @@ int proc_dowatchdog_enabled(struct ctl_table *table, int write,
 out:
 	return ret;
 }
-
-int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-			     void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-}
 #endif /* CONFIG_SYSCTL */
 
 
-- 
1.7.3.1

