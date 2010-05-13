Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab0EMBVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:21:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41117 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab0EMBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=I9XKGXXnCjNUQ7cy6SOZWW3JmmQ+Nqx3Oqs3GV1sjbv7sgX31ccWE70e0FnJxeeowN
         K5DC8RoZSvgeFANg2snrqVQ/iLOAgG35Gj9aYDTzF93pUzHFl4K4UYaPWVysBnEURa1k
         qvHD46vKDdJDGnce4KSHc2Rv0TygFn8I78Xbw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Eric Paris <eparis@redhat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/9] lockup_detector: Touch_softlockup cleanups and softlockup_tick removal
Date: Thu, 13 May 2010 03:21:07 +0200
Message-Id: <1273713674-8434-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
References: <1273713674-8434-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

Just some code cleanup to make touch_softlockup clearer and remove the
softlockup_tick function as it is no longer needed.

Also remove the /proc softlockup_thres call as it has been changed to
watchdog_thres.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <1273266711-18706-3-git-send-email-dzickus@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/sched.h |   16 +++-------------
 kernel/sysctl.c       |    9 ---------
 kernel/timer.c        |    1 -
 kernel/watchdog.c     |   35 +++--------------------------------
 4 files changed, 6 insertions(+), 55 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 37efe8f..33f9b2a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -312,19 +312,15 @@ extern void scheduler_tick(void);
 extern void sched_show_task(struct task_struct *p);
 
 #ifdef CONFIG_DETECT_SOFTLOCKUP
-extern void softlockup_tick(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
 extern void touch_all_softlockup_watchdogs(void);
-extern int proc_dosoftlockup_thresh(struct ctl_table *table, int write,
-				    void __user *buffer,
-				    size_t *lenp, loff_t *ppos);
+extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
+				  void __user *buffer,
+				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
 #else
-static inline void softlockup_tick(void)
-{
-}
 static inline void touch_softlockup_watchdog(void)
 {
 }
@@ -346,12 +342,6 @@ extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
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
index 0f9adda..999bc3f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -817,15 +817,6 @@ static struct ctl_table kern_table[] = {
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
index aeb6a54..e8de5eb 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1225,7 +1225,6 @@ void run_local_timers(void)
 {
 	hrtimer_run_queues();
 	raise_softirq(TIMER_SOFTIRQ);
-	softlockup_tick();
 }
 
 /*
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6b7fad8..f1541b7 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -119,13 +119,12 @@ static void __touch_watchdog(void)
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
 
@@ -140,35 +139,16 @@ void touch_all_watchdog(void)
 
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
 void touch_softlockup_watchdog_sync(void)
 {
 	__raw_get_cpu_var(softlockup_touch_sync) = true;
 	__raw_get_cpu_var(watchdog_touch_ts) = 0;
 }
 
-void softlockup_tick(void)
-{
-}
-
 #ifdef CONFIG_PERF_EVENTS_NMI
 /* watchdog detector functions */
 static int is_hardlockup(int cpu)
@@ -522,15 +502,6 @@ int proc_dowatchdog_thresh(struct ctl_table *table, int write,
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
1.6.2.3

