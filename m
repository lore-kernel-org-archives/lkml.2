Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1KPWTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:19:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42988 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1KPWTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:19:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM Sleep: Don't extend wakeup paths to devices with ignore_children set
Date: Wed, 16 Nov 2011 23:21:58 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111162321.58572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 4ca46ff3e0d8c234cb40ebb6457653b59584426c (PM / Sleep: Mark
devices involved in wakeup signaling during suspend) introduced
the power.wakeup_path field in struct dev_pm_info to mark devices
whose children are enabled to wake up the system from sleep states,
so that power domains containing the parents that provide their
children with wakeup power and/or relay their wakeup signals are not
turned off.  Unfortunately, that introduced a PM regression on SH7372
whose power consumption in the system "memory sleep" state increased
as a result of it, because it prevented the power domain containing
the I2C controller from being turned off when some children of that
controller were enabled to wake up the system, although the
controller was not necessary for them to signal wakeup.

To fix this issue use the observation that devices whose
power.ignore_children flag is set for runtime PM should be treated
analogously during system suspend.  Namely, they shouldn't be
included in wakeup paths going through their children.  Since the
SH7372 I2C controller's power.ignore_children flag is set, doing so
will restore the previous behavior of that SOC.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c  |    3 ++-
 include/linux/device.h     |    5 +++++
 include/linux/pm.h         |    2 +-
 include/linux/pm_runtime.h |    6 ------
 4 files changed, 8 insertions(+), 8 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -447,6 +447,7 @@ struct dev_pm_info {
 	unsigned int		async_suspend:1;
 	bool			is_prepared:1;	/* Owned by the PM core */
 	bool			is_suspended:1;	/* Ditto */
+	bool			ignore_children:1;
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;
@@ -464,7 +465,6 @@ struct dev_pm_info {
 	atomic_t		usage_count;
 	atomic_t		child_count;
 	unsigned int		disable_depth:3;
-	unsigned int		ignore_children:1;
 	unsigned int		idle_notification:1;
 	unsigned int		request_pending:1;
 	unsigned int		deferred_resume:1;
Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -920,7 +920,8 @@ static int __device_suspend(struct devic
  End:
 	if (!error) {
 		dev->power.is_suspended = true;
-		if (dev->power.wakeup_path && dev->parent)
+		if (dev->power.wakeup_path
+		    && dev->parent && !dev->parent->power.ignore_children)
 			dev->parent->power.wakeup_path = true;
 	}
 
Index: linux/include/linux/pm_runtime.h
===================================================================
--- linux.orig/include/linux/pm_runtime.h
+++ linux/include/linux/pm_runtime.h
@@ -54,11 +54,6 @@ static inline bool pm_children_suspended
 		|| !atomic_read(&dev->power.child_count);
 }
 
-static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
-{
-	dev->power.ignore_children = enable;
-}
-
 static inline void pm_runtime_get_noresume(struct device *dev)
 {
 	atomic_inc(&dev->power.usage_count);
@@ -132,7 +127,6 @@ static inline void pm_runtime_allow(stru
 static inline void pm_runtime_forbid(struct device *dev) {}
 
 static inline bool pm_children_suspended(struct device *dev) { return false; }
-static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
 static inline void pm_runtime_get_noresume(struct device *dev) {}
 static inline void pm_runtime_put_noidle(struct device *dev) {}
 static inline bool device_run_wake(struct device *dev) { return false; }
Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -682,6 +682,11 @@ static inline bool device_async_suspend_
 	return !!dev->power.async_suspend;
 }
 
+static inline void pm_suspend_ignore_children(struct device *dev, bool enable)
+{
+	dev->power.ignore_children = enable;
+}
+
 static inline void device_lock(struct device *dev)
 {
 	mutex_lock(&dev->mutex);
