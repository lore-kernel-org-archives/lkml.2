Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1BWV66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:58:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53157 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1BWV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:58:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Make ACPI wakeup from S5 work again if CONFIG_PM_SLEEP is unset
Date: Wed, 23 Feb 2011 22:58:44 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Justin Maggard <jmaggard10@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102232258.44784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 074037e (PM / Wakeup: Introduce wakeup source objects and
event statistics (v3)) caused ACPI wakeup to only work if
CONFIG_PM_SLEEP is set, but it also worked for CONFIG_PM_SLEEP unset
before.  This can be fixed by making device_set_wakeup_enable(),
device_init_wakeup() and device_may_wakeup() work in the same way
as before commit 074037e when CONFIG_PM_SLEEP is unset.

Reported-and-tested-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h        |    2 ++
 include/linux/pm_wakeup.h |   23 +++++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -431,6 +431,8 @@ struct dev_pm_info {
 	struct list_head	entry;
 	struct completion	completion;
 	struct wakeup_source	*wakeup;
+#else
+	unsigned int		should_wakeup:1;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
Index: linux-2.6/include/linux/pm_wakeup.h
===================================================================
--- linux-2.6.orig/include/linux/pm_wakeup.h
+++ linux-2.6/include/linux/pm_wakeup.h
@@ -103,11 +103,6 @@ static inline bool device_can_wakeup(str
 	return dev->power.can_wakeup;
 }
 
-static inline bool device_may_wakeup(struct device *dev)
-{
-	return false;
-}
-
 static inline struct wakeup_source *wakeup_source_create(const char *name)
 {
 	return NULL;
@@ -128,24 +123,32 @@ static inline void wakeup_source_unregis
 
 static inline int device_wakeup_enable(struct device *dev)
 {
-	return -EINVAL;
+	dev->power.should_wakeup = true;
+	return 0;
 }
 
 static inline int device_wakeup_disable(struct device *dev)
 {
+	dev->power.should_wakeup = false;
+	return 0;
+}
+
+static inline int device_set_wakeup_enable(struct device *dev, bool enable)
+{
+	dev->power.should_wakeup = enable;
 	return 0;
 }
 
 static inline int device_init_wakeup(struct device *dev, bool val)
 {
 	device_set_wakeup_capable(dev, val);
-	return val ? -EINVAL : 0;
+	device_set_wakeup_enable(dev, val);
+	return 0;
 }
 
-
-static inline int device_set_wakeup_enable(struct device *dev, bool enable)
+static inline bool device_may_wakeup(struct device *dev)
 {
-	return -EINVAL;
+	return dev->power.can_wakeup && dev->power.should_wakeup;
 }
 
 static inline void __pm_stay_awake(struct wakeup_source *ws) {}
