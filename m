Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0LMAdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:33:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0LMAdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:33:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 1/4] PM: Use a different list of devices for each stage of device suspend
Date: Mon, 13 Dec 2010 01:29:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012130128.31243.rjw@sisk.pl>
In-Reply-To: <201012130128.31243.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012130129.55483.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Instead of keeping all devices in the same list during system suspend
and resume, regardless of what suspend-resume callbacks have been
executed for them already, use separate lists of devices that have
had their ->prepare(), ->suspend() and ->suspend_noirq() callbacks
executed.  This will allow us to simplify the core device suspend and
resume routines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   53 ++++++++++++++++------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -42,6 +42,9 @@
  */
 
 LIST_HEAD(dpm_list);
+LIST_HEAD(dpm_prepared_list);
+LIST_HEAD(dpm_suspended_list);
+LIST_HEAD(dpm_noirq_list);
 
 static DEFINE_MUTEX(dpm_list_mtx);
 static pm_message_t pm_transition;
@@ -476,14 +479,12 @@ End:
  */
 void dpm_resume_noirq(pm_message_t state)
 {
-	struct list_head list;
 	ktime_t starttime = ktime_get();
 
-	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.next);
+	while (!list_empty(&dpm_noirq_list)) {
+		struct device *dev = to_device(dpm_noirq_list.next);
 
 		get_device(dev);
 		if (dev->power.status > DPM_OFF) {
@@ -499,10 +500,9 @@ void dpm_resume_noirq(pm_message_t state
 				pm_dev_err(dev, state, " early", error);
 		}
 		if (!list_empty(&dev->power.entry))
-			list_move_tail(&dev->power.entry, &list);
+			list_move_tail(&dev->power.entry, &dpm_suspended_list);
 		put_device(dev);
 	}
-	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	dpm_show_time(starttime, state, "early");
 	resume_device_irqs();
@@ -611,16 +611,14 @@ static bool is_async(struct device *dev)
  */
 static void dpm_resume(pm_message_t state)
 {
-	struct list_head list;
 	struct device *dev;
 	ktime_t starttime = ktime_get();
 
-	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 	async_error = 0;
 
-	list_for_each_entry(dev, &dpm_list, power.entry) {
+	list_for_each_entry(dev, &dpm_suspended_list, power.entry) {
 		if (dev->power.status < DPM_OFF)
 			continue;
 
@@ -631,8 +629,8 @@ static void dpm_resume(pm_message_t stat
 		}
 	}
 
-	while (!list_empty(&dpm_list)) {
-		dev = to_device(dpm_list.next);
+	while (!list_empty(&dpm_suspended_list)) {
+		dev = to_device(dpm_suspended_list.next);
 		get_device(dev);
 		if (dev->power.status >= DPM_OFF && !is_async(dev)) {
 			int error;
@@ -644,15 +642,11 @@ static void dpm_resume(pm_message_t stat
 			mutex_lock(&dpm_list_mtx);
 			if (error)
 				pm_dev_err(dev, state, "", error);
-		} else if (dev->power.status == DPM_SUSPENDING) {
-			/* Allow new children of the device to be registered */
-			dev->power.status = DPM_RESUMING;
 		}
 		if (!list_empty(&dev->power.entry))
-			list_move_tail(&dev->power.entry, &list);
+			list_move_tail(&dev->power.entry, &dpm_prepared_list);
 		put_device(dev);
 	}
-	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
 	dpm_show_time(starttime, state, NULL);
@@ -699,8 +693,8 @@ static void dpm_complete(pm_message_t st
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = false;
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.prev);
+	while (!list_empty(&dpm_prepared_list)) {
+		struct device *dev = to_device(dpm_prepared_list.prev);
 
 		get_device(dev);
 		if (dev->power.status > DPM_ON) {
@@ -803,15 +797,13 @@ End:
  */
 int dpm_suspend_noirq(pm_message_t state)
 {
-	struct list_head list;
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
-	INIT_LIST_HEAD(&list);
 	suspend_device_irqs();
 	mutex_lock(&dpm_list_mtx);
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.prev);
+	while (!list_empty(&dpm_suspended_list)) {
+		struct device *dev = to_device(dpm_suspended_list.prev);
 
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
@@ -826,10 +818,9 @@ int dpm_suspend_noirq(pm_message_t state
 		}
 		dev->power.status = DPM_OFF_IRQ;
 		if (!list_empty(&dev->power.entry))
-			list_move(&dev->power.entry, &list);
+			list_move(&dev->power.entry, &dpm_noirq_list);
 		put_device(dev);
 	}
-	list_splice_tail(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	if (error)
 		dpm_resume_noirq(resume_event(state));
@@ -957,16 +948,14 @@ static int device_suspend(struct device
  */
 static int dpm_suspend(pm_message_t state)
 {
-	struct list_head list;
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
-	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 	async_error = 0;
-	while (!list_empty(&dpm_list)) {
-		struct device *dev = to_device(dpm_list.prev);
+	while (!list_empty(&dpm_prepared_list)) {
+		struct device *dev = to_device(dpm_prepared_list.prev);
 
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
@@ -980,12 +969,11 @@ static int dpm_suspend(pm_message_t stat
 			break;
 		}
 		if (!list_empty(&dev->power.entry))
-			list_move(&dev->power.entry, &list);
+			list_move(&dev->power.entry, &dpm_suspended_list);
 		put_device(dev);
 		if (async_error)
 			break;
 	}
-	list_splice(&list, dpm_list.prev);
 	mutex_unlock(&dpm_list_mtx);
 	async_synchronize_full();
 	if (!error)
@@ -1044,10 +1032,8 @@ static int device_prepare(struct device
  */
 static int dpm_prepare(pm_message_t state)
 {
-	struct list_head list;
 	int error = 0;
 
-	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	transition_started = true;
 	while (!list_empty(&dpm_list)) {
@@ -1084,10 +1070,9 @@ static int dpm_prepare(pm_message_t stat
 		}
 		dev->power.status = DPM_SUSPENDING;
 		if (!list_empty(&dev->power.entry))
-			list_move_tail(&dev->power.entry, &list);
+			list_move_tail(&dev->power.entry, &dpm_prepared_list);
 		put_device(dev);
 	}
-	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 	return error;
 }

