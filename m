Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0LMAeF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:34:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48366 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab0LMAdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:33:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 2/4] PM: Remove redundant checks from core device resume routines
Date: Mon, 13 Dec 2010 01:31:24 +0100
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
Message-Id: <201012130131.24970.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since a separate list of devices is used to link devices that have
completed each stage of suspend (or resume), it is not necessary to
check dev->power.status in the core device resume routines any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -485,20 +485,17 @@ void dpm_resume_noirq(pm_message_t state
 	transition_started = false;
 	while (!list_empty(&dpm_noirq_list)) {
 		struct device *dev = to_device(dpm_noirq_list.next);
+		int error;
 
 		get_device(dev);
-		if (dev->power.status > DPM_OFF) {
-			int error;
-
-			dev->power.status = DPM_OFF;
-			mutex_unlock(&dpm_list_mtx);
+		dev->power.status = DPM_OFF;
+		mutex_unlock(&dpm_list_mtx);
 
-			error = device_resume_noirq(dev, state);
+		error = device_resume_noirq(dev, state);
 
-			mutex_lock(&dpm_list_mtx);
-			if (error)
-				pm_dev_err(dev, state, " early", error);
-		}
+		mutex_lock(&dpm_list_mtx);
+		if (error)
+			pm_dev_err(dev, state, " early", error);
 		if (!list_empty(&dev->power.entry))
 			list_move_tail(&dev->power.entry, &dpm_suspended_list);
 		put_device(dev);
@@ -619,9 +616,6 @@ static void dpm_resume(pm_message_t stat
 	async_error = 0;
 
 	list_for_each_entry(dev, &dpm_suspended_list, power.entry) {
-		if (dev->power.status < DPM_OFF)
-			continue;
-
 		INIT_COMPLETION(dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
@@ -632,7 +626,7 @@ static void dpm_resume(pm_message_t stat
 	while (!list_empty(&dpm_suspended_list)) {
 		dev = to_device(dpm_suspended_list.next);
 		get_device(dev);
-		if (dev->power.status >= DPM_OFF && !is_async(dev)) {
+		if (!is_async(dev)) {
 			int error;
 
 			mutex_unlock(&dpm_list_mtx);
@@ -697,15 +691,13 @@ static void dpm_complete(pm_message_t st
 		struct device *dev = to_device(dpm_prepared_list.prev);
 
 		get_device(dev);
-		if (dev->power.status > DPM_ON) {
-			dev->power.status = DPM_ON;
-			mutex_unlock(&dpm_list_mtx);
+		dev->power.status = DPM_ON;
+		mutex_unlock(&dpm_list_mtx);
 
-			device_complete(dev, state);
-			pm_runtime_put_sync(dev);
+		device_complete(dev, state);
+		pm_runtime_put_sync(dev);
 
-			mutex_lock(&dpm_list_mtx);
-		}
+		mutex_lock(&dpm_list_mtx);
 		if (!list_empty(&dev->power.entry))
 			list_move(&dev->power.entry, &list);
 		put_device(dev);

