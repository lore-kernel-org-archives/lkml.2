Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0I2WRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 18:17:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54678 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707Ab0I2WRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 18:17:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH] PM: Allow wakeup events to abort freezing of tasks
Date: Thu, 30 Sep 2010 00:16:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009300016.50128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Allow wakeup events to abort freezing of tasks

If there is a wakeup event during the freezing of tasks, suspend or
hibernation will fail anyway.  Since try_to_freeze_tasks() can take
up to 20 seconds to complete or fail, aborting it as soon as a wakeup
event is detected improves the worst case wakeup latency.

Based on a patch from Arve Hjønnevåg.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/process.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/process.c
===================================================================
--- linux-2.6.orig/kernel/power/process.c
+++ linux-2.6/kernel/power/process.c
@@ -40,6 +40,7 @@ static int try_to_freeze_tasks(bool sig_
 	struct timeval start, end;
 	u64 elapsed_csecs64;
 	unsigned int elapsed_csecs;
+	bool wakeup = false;
 
 	do_gettimeofday(&start);
 
@@ -78,6 +79,11 @@ static int try_to_freeze_tasks(bool sig_
 		if (!todo || time_after(jiffies, end_time))
 			break;
 
+		if (!pm_check_wakeup_events()) {
+			wakeup = true;
+			break;
+		}
+
 		/*
 		 * We need to retry, but first give the freezing tasks some
 		 * time to enter the regrigerator.
@@ -97,8 +103,9 @@ static int try_to_freeze_tasks(bool sig_
 		 * but it cleans up leftover PF_FREEZE requests.
 		 */
 		printk("\n");
-		printk(KERN_ERR "Freezing of tasks failed after %d.%02d seconds "
+		printk(KERN_ERR "Freezing of tasks %s after %d.%02d seconds "
 		       "(%d tasks refusing to freeze, wq_busy=%d):\n",
+		       wakeup ? "aborted" : "failed",
 		       elapsed_csecs / 100, elapsed_csecs % 100,
 		       todo - wq_busy, wq_busy);
 
@@ -107,7 +114,7 @@ static int try_to_freeze_tasks(bool sig_
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
 			task_lock(p);
-			if (freezing(p) && !freezer_should_skip(p))
+			if (!wakeup && freezing(p) && !freezer_should_skip(p))
 				sched_show_task(p);
 			cancel_freezing(p);
 			task_unlock(p);
