Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1LUVSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:18:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab1LUVSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:18:30 -0500
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        avi@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        tglx@linutronix.de, Anton Blanchard <anton@samba.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 3/5] watchdog: Remove touch_all_softlockup_watchdogs
Date: Wed, 21 Dec 2011 16:17:43 -0500
Message-Id: <1324502265-24521-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
References: <1324502265-24521-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

commit 04c9167f91e3 (add touch_all_softlockup_watchdogs()) added a
way to touch the watchdog on all cpus because show_state_filter
could hold the tasklist_lock for extended periods of time.

commit 510f5acc4f4f (sched: Don't use tasklist_lock for debug prints)
has since removed the tasklist_lock in show_state_filter so we can
use touch_softlockup_watchdog instead.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/sched.h |    4 ----
 kernel/sched/core.c   |    2 +-
 kernel/watchdog.c     |   13 -------------
 3 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index cc8c620..b1e4364 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -312,7 +312,6 @@ extern void sched_show_task(struct task_struct *p);
 #ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
-extern void touch_all_softlockup_watchdogs(void);
 extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
@@ -325,9 +324,6 @@ static inline void touch_softlockup_watchdog(void)
 static inline void touch_softlockup_watchdog_sync(void)
 {
 }
-static inline void touch_all_softlockup_watchdogs(void)
-{
-}
 static inline void lockup_detector_init(void)
 {
 }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3c5b21e..4b01286 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4812,7 +4812,7 @@ void show_state_filter(unsigned long state_filter)
 			sched_show_task(p);
 	} while_each_thread(g, p);
 
-	touch_all_softlockup_watchdogs();
+	touch_softlockup_watchdog();
 
 #ifdef CONFIG_SCHED_DEBUG
 	sysrq_sched_debug_show();
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1d7bca7..d63975f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -138,19 +138,6 @@ void touch_softlockup_watchdog(void)
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
-void touch_all_softlockup_watchdogs(void)
-{
-	int cpu;
-
-	/*
-	 * this is done lockless
-	 * do we care if a 0 races with a timestamp?
-	 * all it means is the softlock check starts one cycle later
-	 */
-	for_each_online_cpu(cpu)
-		per_cpu(watchdog_touch_ts, cpu) = 0;
-}
-
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-- 
1.7.7.4

