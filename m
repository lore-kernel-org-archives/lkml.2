Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab2BGBGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:06:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab2BGBGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:06:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 4/8] PM / Sleep: Use wait queue to signal "no wakeup events in progress"
Date: Tue, 7 Feb 2012 02:04:19 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <greg@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl>
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202070204.19615.rjw@sisk.pl>
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
 drivers/base/power/wakeup.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

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
  * wakeup_source_create - Create a struct wakeup_source object.
  * @name: Name of the new wakeup source.
@@ -84,7 +84,7 @@ void wakeup_source_destroy(struct wakeup
 	while (ws->active) {
 		spin_unlock_irq(&ws->lock);
 
-		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
+		schedule_timeout_interruptible(msecs_to_jiffies(100));
 
 		spin_lock_irq(&ws->lock);
 	}
@@ -411,6 +411,7 @@ EXPORT_SYMBOL_GPL(pm_stay_awake);
  */
 static void wakeup_source_deactivate(struct wakeup_source *ws)
 {
+	unsigned int cnt, inpr;
 	ktime_t duration;
 	ktime_t now;
 
@@ -444,6 +445,10 @@ static void wakeup_source_deactivate(str
 	 * couter of wakeup events in progress simultaneously.
 	 */
 	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
+
+	split_counters(&cnt, &inpr);
+	if (!inpr)
+		wake_up_all(&wakeup_count_wait_queue);
 }
 
 /**
@@ -624,14 +629,19 @@ bool pm_wakeup_pending(void)
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

