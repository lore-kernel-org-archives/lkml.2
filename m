Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab2F1THV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 15:07:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab2F1THT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 15:07:19 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH] backlight: add support for disabling backlights via sysfs
Date: Thu, 28 Jun 2012 14:07:06 -0500
Message-Id: <1340910426-13269-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been several attempts recently to find ways to disable broken
backlight interfaces on laptops, such as [1]. These haven't always
worked as well as hoped and tend to be driver-specific, so we're seeing
attempts to add an expanding number of interfaces between drivers to try
to cope with the situation, such as [2] and [3]. We're also seeing
difficulties properly expressing the inter-module dependencies[4].

Rather than trying to address this situation in a piecemeal fashion, we
should find a solution that deal with disabling broken backlights more
generically. This patch does so by adding an "enabled" attribute to
sysfs for backlight devices. Writing 0 to this attribute disables the
backlight, blocking most attempts to change the state. Tools like udev
can set use this attribute to disable known broken backlight interfaces,
and tools like gnome-settings-daemon can query the attribute to avoid
using disabled backlights.

[1] https://lkml.org/lkml/2012/3/22/156
[2] https://lkml.org/lkml/2012/3/15/529
[3] https://lkml.org/lkml/2012/6/13/48
[4] https://lkml.org/lkml/2012/6/28/159

Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---

I wanted to send this out for comments to see how people felt about this
idea. If it's well received I can follow up with patches to remove the
acpi_video_unregister() and apple_bl_unregister() calls currently being
used for this purpose.

 Documentation/ABI/stable/sysfs-class-backlight |   10 +++++
 drivers/video/backlight/backlight.c            |   54 +++++++++++++++++++++---
 include/linux/backlight.h                      |    1 +
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-backlight b/Documentation/ABI/stable/sysfs-class-backlight
index 70302f3..3b3c477 100644
--- a/Documentation/ABI/stable/sysfs-class-backlight
+++ b/Documentation/ABI/stable/sysfs-class-backlight
@@ -54,3 +54,13 @@ Description:
 		backlight state. Platform interfaces are mostly a
 		holdover from pre-standardisation of firmware
 		interfaces.
+
+What:		/sys/class/backlight/<backlight>/enabled
+Date:		May 2012
+KernelVersion:	3.6
+Contact:	Seth Forshee <seth.forshee@canonical.com>
+Description:
+		Enable or disable this <backlight>. Also shows whether
+		the backlight is enabled. This can be used by tools like
+		udev to disable backlights that are known to be broken
+		on a given platform.
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 297db2f..5275738 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -53,7 +53,8 @@ static int fb_notifier_callback(struct notifier_block *self,
 				bd->props.state &= ~BL_CORE_FBBLANK;
 			else
 				bd->props.state |= BL_CORE_FBBLANK;
-			backlight_update_status(bd);
+			if (!(bd->props.state & BL_CORE_DISABLED))
+				backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
 	return 0;
@@ -124,7 +125,7 @@ static ssize_t backlight_store_power(struct device *dev,
 
 	rc = -ENXIO;
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops) {
+	if (!(bd->props.state & BL_CORE_DISABLED) && bd->ops) {
 		pr_debug("set power to %lu\n", power);
 		if (bd->props.power != power) {
 			bd->props.power = power;
@@ -159,7 +160,7 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	rc = -ENXIO;
 
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops) {
+	if (!(bd->props.state & BL_CORE_DISABLED) && bd->ops) {
 		if (brightness > bd->props.max_brightness)
 			rc = -EINVAL;
 		else {
@@ -206,6 +207,43 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
 	return rc;
 }
 
+static ssize_t backlight_show_enabled(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	return sprintf(buf, "%d\n", !(bd->props.state & BL_CORE_DISABLED));
+}
+
+static ssize_t backlight_store_enabled(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+	int rc;
+	unsigned long enabled;
+
+	rc = kstrtoul(buf, 0, &enabled);
+	if (rc)
+		return rc;
+	if (enabled != 0 && enabled != 1)
+		return -EINVAL;
+
+	mutex_lock(&bd->ops_lock);
+
+	if (enabled)
+		bd->props.state &= ~BL_CORE_DISABLED;
+	else
+		bd->props.state |= BL_CORE_DISABLED;
+
+	if (bd->ops)
+		backlight_update_status(bd);
+
+	mutex_unlock(&bd->ops_lock);
+
+	sysfs_notify(&bd->dev.kobj, NULL, "enabled");
+	return count;
+}
+
 static struct class *backlight_class;
 
 static int backlight_suspend(struct device *dev, pm_message_t state)
@@ -213,7 +251,8 @@ static int backlight_suspend(struct device *dev, pm_message_t state)
 	struct backlight_device *bd = to_backlight_device(dev);
 
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
+	if (!(bd->props.state & BL_CORE_DISABLED) &&
+	    bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state |= BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
 	}
@@ -227,7 +266,8 @@ static int backlight_resume(struct device *dev)
 	struct backlight_device *bd = to_backlight_device(dev);
 
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
+	if (!(bd->props.state & BL_CORE_DISABLED) &&
+	    bd->ops && bd->ops->options & BL_CORE_SUSPENDRESUME) {
 		bd->props.state &= ~BL_CORE_SUSPENDED;
 		backlight_update_status(bd);
 	}
@@ -250,6 +290,7 @@ static struct device_attribute bl_device_attributes[] = {
 		     NULL),
 	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
 	__ATTR(type, 0444, backlight_show_type, NULL),
+	__ATTR(enabled, 0644, backlight_show_enabled, backlight_store_enabled),
 	__ATTR_NULL,
 };
 
@@ -265,7 +306,8 @@ void backlight_force_update(struct backlight_device *bd,
 			    enum backlight_update_reason reason)
 {
 	mutex_lock(&bd->ops_lock);
-	if (bd->ops && bd->ops->get_brightness)
+	if (!(bd->props.state & BL_CORE_DISABLED) &&
+	    bd->ops && bd->ops->get_brightness)
 		bd->props.brightness = bd->ops->get_brightness(bd);
 	mutex_unlock(&bd->ops_lock);
 	backlight_generate_event(bd, reason);
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 5ffc6dd..31917d0 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -77,6 +77,7 @@ struct backlight_properties {
 
 #define BL_CORE_SUSPENDED	(1 << 0)	/* backlight is suspended */
 #define BL_CORE_FBBLANK		(1 << 1)	/* backlight is under an fb blank event */
+#define BL_CORE_DISABLED	(1 << 2)	/* backlight disabled by userspace */
 #define BL_CORE_DRIVER4		(1 << 28)	/* reserved for driver specific use */
 #define BL_CORE_DRIVER3		(1 << 29)	/* reserved for driver specific use */
 #define BL_CORE_DRIVER2		(1 << 30)	/* reserved for driver specific use */
-- 
1.7.9.5

