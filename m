Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1LUVSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:18:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab1LUVSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:18:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        avi@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/5] kgdb, softlockup:  Remove touch_softlockup_watchdog_sync
Date: Wed, 21 Dec 2011 16:17:45 -0500
Message-Id: <1324502265-24521-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
References: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous softlockup patches remove the delayed timestamp
and instead just stamp the time at invocation of
touch_softlockup_watchdog.  As a result, I don't think
touch_softlockup_watchdog_sync is needed anymore because
the call to cpu_clock() mimics what the _sync command
was trying to do.

I haven't tested this to see if this is true, instead I did
this on code inspection.

Jason, do you think you can test this and let me know if it
works?

CC: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/sched.h     |    4 ----
 kernel/debug/debug_core.c |    2 +-
 kernel/watchdog.c         |    6 ------
 3 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b1e4364..c896830 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -311,7 +311,6 @@ extern void sched_show_task(struct task_struct *p);
 
 #ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_softlockup_watchdog(void);
-extern void touch_softlockup_watchdog_sync(void);
 extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
@@ -321,9 +320,6 @@ void lockup_detector_init(void);
 static inline void touch_softlockup_watchdog(void)
 {
 }
-static inline void touch_softlockup_watchdog_sync(void)
-{
-}
 static inline void lockup_detector_init(void)
 {
 }
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0d7c087..58f74e3 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -450,7 +450,7 @@ static int kgdb_reenter_check(struct kgdb_state *ks)
 
 static void dbg_touch_watchdogs(void)
 {
-	touch_softlockup_watchdog_sync();
+	touch_softlockup_watchdog();
 	clocksource_touch_watchdog();
 	rcu_cpu_stall_reset();
 }
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4d242f5..a9fb54c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -154,12 +154,6 @@ EXPORT_SYMBOL(touch_nmi_watchdog);
 
 #endif
 
-void touch_softlockup_watchdog_sync(void)
-{
-	sched_clock_tick();
-	__touch_watchdog();
-}
-
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
 static int is_hardlockup(void)
-- 
1.7.7.4

