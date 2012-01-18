Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2ARXHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:07:24 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:48993 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2ARXHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:07:22 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 1/2] power: Add function to init wakeup capability without enabling
Date: Wed, 18 Jan 2012 15:07:06 -0800
Message-Id: <1326928027-20610-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326826563-32215-3-git-send-email-sjg@chromium.org>
References: <1326826563-32215-3-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_init_wakeup() offers two options:

1. Wakeup capable and wakeup enabled
2  Not wakeup capable and not wakeup enabled

serial_core wants a third option:

3. Wakeup capable but not wakeup enabled (yet)

Add a new init routine which takes a flag indicating which of the three
options is required. This avoids creating and then destroying the wakeup
source to no purpose, and a sometimes large rcu_synchronise() delay.

Q: What is a good name for the new function?

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/base/power/wakeup.c |   26 ++++++++++++++++++++++----
 include/linux/pm_wakeup.h   |   22 +++++++++++++++++++---
 2 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index caf995f..ae3b3c5 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -273,7 +273,7 @@ EXPORT_SYMBOL_GPL(device_set_wakeup_capable);
 /**
  * device_init_wakeup - Device wakeup initialization.
  * @dev: Device to handle.
- * @enable: Whether or not to enable @dev as a wakeup device.
+ * @flags: flags PM_WAKEUP_...
  *
  * By default, most devices should leave wakeup disabled.  The exceptions are
  * devices that everyone expects to be wakeup sources: keyboards, power buttons,
@@ -281,19 +281,37 @@ EXPORT_SYMBOL_GPL(device_set_wakeup_capable);
  * own wakeup requests but merely forward requests from one bus to another
  * (like PCI bridges) should have wakeup enabled by default.
  */
-int device_init_wakeup(struct device *dev, bool enable)
+int device_init_wakeup_flag(struct device *dev, int flags)
 {
 	int ret = 0;
 
-	if (enable) {
+	if (flags & PM_WAKEUP_CAP) {
 		device_set_wakeup_capable(dev, true);
-		ret = device_wakeup_enable(dev);
+		if (flags & PM_WAKEUP_EN)
+			ret = device_wakeup_enable(dev);
 	} else {
+		WARN_ON(flags & PM_WAKEUP_EN);
 		device_set_wakeup_capable(dev, false);
 	}
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(device_init_wakeup_flag);
+
+/**
+ * device_init_wakeup - Device wakeup initialization.
+ * @dev: Device to handle.
+ * @enable: Whether or not to enable @dev as a wakeup device.
+ *
+ * By default, most devices should leave wakeup disabled.  The exceptions are
+ * devices that everyone expects to be wakeup sources: keyboards, power buttons,
+ * possibly network interfaces, etc.
+ */
+int device_init_wakeup(struct device *dev, bool enable)
+{
+	return device_init_wakeup_flag(dev, enable ? PM_WAKEUP_CAP_EN :
+				       PM_WAKEUP_NONE);
+}
 EXPORT_SYMBOL_GPL(device_init_wakeup);
 
 /**
diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
index a32da96..3035875 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -56,6 +56,14 @@ struct wakeup_source {
 	unsigned int		active:1;
 };
 
+/* Flags for device_init_wakeup_flag() */
+enum {
+	PM_WAKEUP_NONE,		/* Not wakeup capable */
+	PM_WAKEUP_CAP,		/* Wakeup capable but not enabled */
+	PM_WAKEUP_EN,		/* Don't use */
+	PM_WAKEUP_CAP_EN,	/* Wakeup capable and enabled */
+};
+
 #ifdef CONFIG_PM_SLEEP
 
 /*
@@ -83,6 +91,7 @@ extern int device_wakeup_enable(struct device *dev);
 extern int device_wakeup_disable(struct device *dev);
 extern void device_set_wakeup_capable(struct device *dev, bool capable);
 extern int device_init_wakeup(struct device *dev, bool val);
+extern int device_init_wakeup_flag(struct device *dev, int flags);
 extern int device_set_wakeup_enable(struct device *dev, bool enable);
 extern void __pm_stay_awake(struct wakeup_source *ws);
 extern void pm_stay_awake(struct device *dev);
@@ -139,13 +148,20 @@ static inline int device_set_wakeup_enable(struct device *dev, bool enable)
 	return 0;
 }
 
-static inline int device_init_wakeup(struct device *dev, bool val)
+static inline device_init_wakeup_flag(struct device *dev, int flags)
 {
-	device_set_wakeup_capable(dev, val);
-	device_set_wakeup_enable(dev, val);
+	device_set_wakeup_capable(dev, flags & PM_WAKEUP_CAP);
+	if (flags & PM_WAKEUP_EN)
+		device_set_wakeup_enable(dev, true);
 	return 0;
 }
 
+static inline int device_init_wakeup(struct device *dev, bool enable)
+{
+	return device_init_wakeup_flag(enable ? PM_WAKEUP_CAP_EN :
+				       PM_WAKEUP_NONE);
+}
+
 static inline bool device_may_wakeup(struct device *dev)
 {
 	return dev->power.can_wakeup && dev->power.should_wakeup;
-- 
1.7.7.3

