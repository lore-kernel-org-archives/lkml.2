Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2DVVUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:20:48 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58203 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab2DVVUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:20:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/8] PM / Sleep: Use wait queue to signal "no wakeup events in progress"
Date: Sun, 22 Apr 2012 23:20:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl> <201204222319.02228.rjw@sisk.pl>
In-Reply-To: <201204222319.02228.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204222320.39725.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The current wakeup source deactivation code doesn't do anything when
the counter of wakeup events in progress goes down to zero, which
requires pm_get_wakeup_count() to poll that counter periodically.
Although this reduces the average time it takes to deactivate a
wakeup source, it also may lead to a substantial amount of unnecessary
polling if there are extended periods of wakeup activity.  Thus it
seems reasonable to use a wait queue for signaling the "no wakeup
events in progress" condition and remove the polling.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -17,8 +17,6 @@
 
 #include "power.h"
 
-#define TIMEOUT		100
-
 /*
  * If set, the suspend/hibernate code will abort transitions to a sleep state
  * if wakeup events are registered during or immediately before the transition.
@@ -52,6 +50,8 @@ static void pm_wakeup_timer_fn(unsigned
 
 static LIST_HEAD(wakeup_sources);
 
+static DECLARE_WAIT_QUEUE_HEAD(wakeup_count_wait_queue);
+
 /**
  * wakeup_source_prepare - Prepare a new wakeup source for initialization.
  * @ws: Wakeup source to prepare.
@@ -442,6 +442,7 @@ EXPORT_SYMBOL_GPL(pm_stay_awake);
  */
 static void wakeup_source_deactivate(struct wakeup_source *ws)
 {
+	unsigned int cnt, inpr;
 	ktime_t duration;
 	ktime_t now;
 
@@ -476,6 +477,10 @@ static void wakeup_source_deactivate(str
 	 * couter of wakeup events in progress simultaneously.
 	 */
 	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
+
+	split_counters(&cnt, &inpr);
+	if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
+		wake_up(&wakeup_count_wait_queue);
 }
 
 /**
@@ -667,14 +672,19 @@ bool pm_wakeup_pending(void)
 bool pm_get_wakeup_count(unsigned int *count)
 {
 	unsigned int cnt, inpr;
+	DEFINE_WAIT(wait);
 
 	for (;;) {
+		prepare_to_wait(&wakeup_count_wait_queue, &wait,
+				TASK_INTERRUPTIBLE);
 		split_counters(&cnt, &inpr);
 		if (inpr == 0 || signal_pending(current))
 			break;
 		pm_wakeup_update_hit_counts();
-		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
+
+		schedule();
 	}
+	finish_wait(&wakeup_count_wait_queue, &wait);
 
 	split_counters(&cnt, &inpr);
 	*count = cnt;

