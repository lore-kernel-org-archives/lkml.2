Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0LMAeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:34:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48381 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0LMAeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:34:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [RFC][PATCH 4/4] PM: Permit registrarion of parentless devices during system suspend
Date: Mon, 13 Dec 2010 01:33:51 +0100
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
Message-Id: <201012130133.52072.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The registration of a new parentless device during system suspend
will not lead to any complications affecting the PM core (the device
will be effectively seen after the subsequent resume has completed),
so remove the code used for detection of such events.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -49,12 +49,6 @@ LIST_HEAD(dpm_noirq_list);
 static DEFINE_MUTEX(dpm_list_mtx);
 static pm_message_t pm_transition;
 
-/*
- * Set once the preparation of devices for a PM transition has started, reset
- * before starting to resume devices.  Protected by dpm_list_mtx.
- */
-static bool transition_started;
-
 static int async_error;
 
 /**
@@ -97,19 +91,9 @@ void device_pm_add(struct device *dev)
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
-	if (dev->parent) {
-		if (dev->parent->power.in_suspend)
-			dev_warn(dev, "parent %s should not be sleeping\n",
-				 dev_name(dev->parent));
-	} else if (transition_started) {
-		/*
-		 * We refuse to register parentless devices while a PM
-		 * transition is in progress in order to avoid leaving them
-		 * unhandled down the road
-		 */
-		dev_WARN(dev, "Parentless device registered during a PM transaction\n");
-	}
-
+	if (dev->parent && dev->parent->power.in_suspend)
+		dev_warn(dev, "parent %s should not be sleeping\n",
+			dev_name(dev->parent));
 	list_add_tail(&dev->power.entry, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 }
@@ -482,7 +466,6 @@ void dpm_resume_noirq(pm_message_t state
 	ktime_t starttime = ktime_get();
 
 	mutex_lock(&dpm_list_mtx);
-	transition_started = false;
 	while (!list_empty(&dpm_noirq_list)) {
 		struct device *dev = to_device(dpm_noirq_list.next);
 		int error;
@@ -683,7 +666,6 @@ static void dpm_complete(pm_message_t st
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
-	transition_started = false;
 	while (!list_empty(&dpm_prepared_list)) {
 		struct device *dev = to_device(dpm_prepared_list.prev);
 
@@ -1020,7 +1002,6 @@ static int dpm_prepare(pm_message_t stat
 	int error = 0;
 
 	mutex_lock(&dpm_list_mtx);
-	transition_started = true;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
 

