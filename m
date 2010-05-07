Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414Ab0EGVNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509Ab0EGVM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:12:57 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com
Subject: [PATCH 7/8] [watchdog] resolve softlockup.c conflicts
Date: Fri,  7 May 2010 17:11:50 -0400
Message-Id: <1273266711-18706-8-git-send-email-dzickus@redhat.com>
In-Reply-To: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
References: <1273266711-18706-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My changes with the softlockup code uses an older version of softlockup.c.
A couple of commits have been committed that were not on the branch I am
using.  This patch resolves those conflicts.

Commit 8c2eb4 softlockup: Stop spurious softlockup messages due to overflow
       d6ad3e softlockup: Add sched_clock_tick() to avoid kernel warning on kgdb resume

Conflicts:

	include/linux/sched.h
	kernel/kgdb.c
	kernel/softlockup.c

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/sched.h |    4 ++++
 kernel/kgdb.c         |    6 +++---
 kernel/watchdog.c     |   17 ++++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e9c6c1d..720e7e9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -310,6 +310,7 @@ extern void sched_show_task(struct task_struct *p);
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
+extern void touch_softlockup_watchdog_sync(void);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
 extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
@@ -322,6 +323,9 @@ static inline void touch_softlockup_watchdog(void)
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
+static inline void touch_softlockup_watchdog_sync(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 2eb517e..87f2cc5 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -596,7 +596,7 @@ static void kgdb_wait(struct pt_regs *regs)
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
-	touch_softlockup_watchdog();
+	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
@@ -1450,7 +1450,7 @@ acquirelock:
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
-		touch_softlockup_watchdog();
+		touch_softlockup_watchdog_sync();
 		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
@@ -1550,7 +1550,7 @@ kgdb_restore:
 	}
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
-	touch_softlockup_watchdog();
+	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 03671b7..80a282c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -33,6 +33,7 @@ int __read_mostly softlockup_thresh = 60;
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
+static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 #ifdef CONFIG_PERF_EVENTS_NMI
@@ -136,6 +137,12 @@ void touch_all_softlockup_watchdogs(void)
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 }
 
+void touch_softlockup_watchdog_sync(void)
+{
+	__raw_get_cpu_var(softlockup_touch_sync) = true;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+}
+
 void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
@@ -161,7 +168,7 @@ static int is_softlockup(unsigned long touch_ts, int cpu)
 	unsigned long now = get_timestamp(cpu);
 
 	/* Warn about unreasonable delays: */
-	if (now > (touch_ts + softlockup_thresh))
+	if (time_after(now, touch_ts + softlockup_thresh))
 		return now - touch_ts;
 
 	return 0;
@@ -250,6 +257,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
 
 	if (touch_ts == 0) {
+		if (unlikely(per_cpu(softlockup_touch_sync, this_cpu))) {
+			/*
+			 * If the time stamp was touched atomically
+			 * make sure the scheduler tick is up to date.
+			 */
+			per_cpu(softlockup_touch_sync, this_cpu) = false;
+			sched_clock_tick();
+		}
 		__touch_watchdog();
 		return HRTIMER_RESTART;
 	}
-- 
1.7.0.1

