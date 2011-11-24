Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1KXDxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:53:18 -0500
Received: from ozlabs.org ([203.10.76.45]:35081 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab1KXDxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:53:17 -0500
Date: Thu, 24 Nov 2011 14:53:15 +1100
From: Anton Blanchard <anton@samba.org>
To: Don Zickus <dzickus@redhat.com>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] watchdog: Remove touch_all_softlockup_watchdogs
Message-ID: <20111124145315.5d0c4686@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 04c9167f91e3 (add touch_all_softlockup_watchdogs()) added a
way to touch the watchdog on all cpus because show_state_filter
could hold the tasklist_lock for extended periods of time.

commit 510f5acc4f4f (sched: Don't use tasklist_lock for debug prints)
has since removed the tasklist_lock in show_state_filter so we can
use touch_softlockup_watchdog instead.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-build/include/linux/sched.h
===================================================================
--- linux-build.orig/include/linux/sched.h	2011-11-16 07:57:25.054353865 +1100
+++ linux-build/include/linux/sched.h	2011-11-16 08:04:56.270478443 +1100
@@ -310,7 +310,6 @@ extern void sched_show_task(struct task_
 #ifdef CONFIG_LOCKUP_DETECTOR
 extern void touch_softlockup_watchdog(void);
 extern void touch_softlockup_watchdog_sync(void);
-extern void touch_all_softlockup_watchdogs(void);
 extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  void __user *buffer,
 				  size_t *lenp, loff_t *ppos);
@@ -323,9 +322,6 @@ static inline void touch_softlockup_watc
 static inline void touch_softlockup_watchdog_sync(void)
 {
 }
-static inline void touch_all_softlockup_watchdogs(void)
-{
-}
 static inline void lockup_detector_init(void)
 {
 }
Index: linux-build/kernel/sched.c
===================================================================
--- linux-build.orig/kernel/sched.c	2011-11-16 07:57:25.066354081 +1100
+++ linux-build/kernel/sched.c	2011-11-16 08:04:56.274478516 +1100
@@ -6033,7 +6033,7 @@ void show_state_filter(unsigned long sta
 			sched_show_task(p);
 	} while_each_thread(g, p);
 
-	touch_all_softlockup_watchdogs();
+	touch_softlockup_watchdog();
 
 #ifdef CONFIG_SCHED_DEBUG
 	sysrq_sched_debug_show();
Index: linux-build/kernel/watchdog.c
===================================================================
--- linux-build.orig/kernel/watchdog.c	2011-11-16 07:57:25.626364139 +1100
+++ linux-build/kernel/watchdog.c	2011-11-16 08:04:56.274478516 +1100
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
