Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0EGVMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464Ab0EGVMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:12:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 2/8] [nmi watchdog] touch_softlockup cleanups and softlockup_tick removal
Date: Fri,  7 May 2010 17:11:45 -0400
Message-Id: <1273266711-18706-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some code cleanup to make touch_softlockup clearer and remove the
softlockup_tick function as it is no longer needed.

Also remove the /proc softlockup_thres call as it has been changed to
watchdog_thres.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/sched.h |   16 +++-------------
 kernel/sysctl.c       |    9 ---------
 kernel/timer.c        |    1 -
 kernel/watchdog.c     |   35 +++--------------------------------
 4 files changed, 6 insertions(+), 55 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2455ff5..e9c6c1d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -308,18 +308,14 @@ extern void scheduler_tick(void);
 extern void sched_show_task(struct task_struct *p);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
-extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-				    void __user *buffer,
-				    size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
+extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos);
 #else
-static inline void softlockup_tick(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
@@ -338,12 +334,6 @@ extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
 					 size_t *lenp, loff_t *ppos);
 #endif
 
-#ifdef CONFIG_LOCKUP_DETECTOR
-extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
-				  void __user *buffer,
-				  size_t *lenp, loff_t *ppos);
-#endif
-
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1083897..1fec781 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -827,15 +827,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-	{
-		.procname	= "softlockup_thresh",
-		.data		= &softlockup_thresh,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dosoftlockup_thresh,
-		.extra1		= &neg_one,
-		.extra2		= &sixty,
-	},
 #endif
 #ifdef CONFIG_DETECT_HUNG_TASK
 	{
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..80c8da5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1223,7 +1223,6 @@ void run_local_timers(void)
 {
 	hrtimer_run_queues();
 	raise_softirq(TIMER_SOFTIRQ);
-	softlockup_tick();
 }
 
 /*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 2684e95..03671b7 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -118,13 +118,12 @@ static void __touch_watchdog(void)
 	__get_cpu_var(watchdog_touch_ts) = get_timestamp(this_cpu);
 }
 
-void touch_watchdog(void)
+void touch_softlockup_watchdog(void)
 {
 	__get_cpu_var(watchdog_touch_ts) = 0;
 }
-EXPORT_SYMBOL(touch_watchdog);
 
-void touch_all_watchdog(void)
+void touch_all_softlockup_watchdogs(void)
 {
 	int cpu;
 
@@ -139,29 +138,10 @@ void touch_all_watchdog(void)
 
 void touch_nmi_watchdog(void)
 {
-	touch_watchdog();
+	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
-void touch_all_nmi_watchdog(void)
-{
-	touch_all_watchdog();
-}
-
-void touch_softlockup_watchdog(void)
-{
-	touch_watchdog();
-}
-
-void touch_all_softlockup_watchdogs(void)
-{
-	touch_all_watchdog();
-}
-
-void softlockup_tick(void)
-{
-}
-
 #ifdef CONFIG_PERF_EVENTS_NMI
 /* watchdog detector functions */
 static int is_hardlockup(int cpu)
@@ -507,15 +487,6 @@ int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 {
 	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 }
-
-/* stub functions */
-int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-			     void __user *buffer,
-			     size_t *lenp, loff_t *ppos)
-{
-	return proc_dowatchdog_thresh(table, write, buffer, lenp, ppos);
-}
-/* end of stub functions */
 #endif /* CONFIG_SYSCTL */
 
 
-- 
1.7.0.1

