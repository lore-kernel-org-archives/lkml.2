Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab0DTQRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:17:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0DTQRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:17:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, fweisbec@gmail.com
Cc: peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       dzickus@redhat.com, colin.king@canonical.com,
       jason.wessel@windriver.com
Subject: [PATCH 7/6] [watchdog] resolve softlockup.c conflicts
Date: Tue, 20 Apr 2010 12:16:41 -0400
Message-Id: <1271780201-19163-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
References: <1271777043-3807-1-git-send-email-dzickus@redhat.com>
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

--

Hi Ingo,

If there is a better way to deal with these conflicts please let me know.

---
 include/linux/sched.h |    4 ++++
 kernel/kgdb.c         |    6 +++---
 kernel/watchdog.c     |   17 ++++++++++++++++-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0c128ad..e039e22 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -310,6 +310,7 @@ extern void sched_show_task(struct task_struct *p);
 #ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_watchdog(void);
 extern void touch_all_watchdogs(void);
+extern void touch_watchdog_sync(void);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
 extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
@@ -322,6 +323,9 @@ static inline void touch_watchdog(void)
 static inline void touch_all_watchdogs(void)
 {
 }
+static inline void touch_watchdog_sync(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 15df969..da98119 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -596,7 +596,7 @@ static void kgdb_wait(struct pt_regs *regs)
 
 	/* Signal the primary CPU that we are done: */
 	atomic_set(&cpu_in_kgdb[cpu], 0);
-	touch_watchdog();
+	touch_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 }
@@ -1450,7 +1450,7 @@ acquirelock:
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
-		touch_watchdog();
+		touch_watchdog_sync();
 		clocksource_touch_watchdog();
 		local_irq_restore(flags);
 
@@ -1550,7 +1550,7 @@ kgdb_restore:
 	}
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
-	touch_watchdog();
+	touch_watchdog_sync();
 	clocksource_touch_watchdog();
 	local_irq_restore(flags);
 
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 73529a8..9898c7c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -33,6 +33,7 @@ int __read_mostly softlockup_thresh = 60;
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
 static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
 static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
+static DEFINE_PER_CPU(bool, watchdog_touch_sync);
 #define HARDLOCKUP	1
 #define SOFTLOCKUP	2
 static DEFINE_PER_CPU(char, watchdog_warn);
@@ -138,6 +139,12 @@ void touch_all_watchdogs(void)
 		per_cpu(watchdog_touch_ts, cpu) = 0;
 }
 
+void touch_watchdog_sync(void)
+{
+	__raw_get_cpu_var(watchdog_touch_sync) = true;
+	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+}
+
 void touch_nmi_watchdog(void)
 {
 	touch_watchdog();
@@ -163,7 +170,7 @@ static int is_softlockup(unsigned long touch_ts, int cpu)
 	unsigned long now = get_timestamp(cpu);
 
 	/* Warn about unreasonable delays: */
-	if (now > (touch_ts + softlockup_thresh))
+	if (time_after(now, touch_ts + softlockup_thresh))
 		return now - touch_ts;
 
 	return 0;
@@ -254,6 +261,14 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	hrtimer_forward_now(hrtimer, ns_to_ktime(get_sample_period()));
 
 	if (touch_ts == 0) {
+		if (unlikely(per_cpu(watchdog_touch_sync, this_cpu))) {
+			/*
+			 * If the time stamp was touched atomically
+			 * make sure the scheduler tick is up to date.
+			 */
+			per_cpu(watchdog_touch_sync, this_cpu) = false;
+			sched_clock_tick();
+		}
 		__touch_watchdog();
 		return HRTIMER_RESTART;
 	}
-- 
1.6.5.2

