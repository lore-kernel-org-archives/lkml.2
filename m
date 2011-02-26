Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab1BZJXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:06 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:47513 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1BZJW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:22:59 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 07/14] asus-wmi: try to guess the right DSTS methods
Date: Sat, 26 Feb 2011 10:20:36 +0100
Message-Id: <1298712045-17671-8-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is tricky, new WMI aware notebooks seems to use
0x53545344 while Eee PCs are using 0x53544344. But there
is no way to know if there is an Eee PC in that wild that is
using 0x53545344 or a notebook using 0x53544344. So the
driver try to guess the available DSTS method ... But most Eee PCs
never return 0xFFFFFFFE when a method is not available, they return
0 instead (and that's useless).

So, first, try 0x53544344 then 0x53545344. We will find
a better way when we got more data.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |   99 ++++++++++++++++++++++++++-------------
 1 files changed, 66 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 34e6b4d..fd5b08ee 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -67,6 +67,7 @@ MODULE_LICENSE("GPL");
 
 /* WMI Methods */
 #define ASUS_WMI_METHODID_DSTS		0x53544344
+#define ASUS_WMI_METHODID_DSTS2		0x53545344
 #define ASUS_WMI_METHODID_DEVS		0x53564544
 #define ASUS_WMI_METHODID_CFVS		0x53564643
 
@@ -124,6 +125,8 @@ struct asus_rfkill {
 };
 
 struct asus_wmi {
+	int dsts_id;
+
 	struct input_dev *inputdev;
 	struct backlight_device *backlight_device;
 	struct platform_device *platform_device;
@@ -229,26 +232,26 @@ exit:
 	return 0;
 }
 
-static int asus_wmi_get_devstate(u32 dev_id, u32 *retval)
+static int asus_wmi_get_devstate(struct asus_wmi *asus, u32 dev_id, u32 *retval)
 {
-	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS, dev_id,
-					0, retval);
+	return asus_wmi_evaluate_method(asus->dsts_id, dev_id, 0, retval);
 }
 
 static int asus_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
-					 u32 *retval)
+				 u32 *retval)
 {
 	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_DEVS, dev_id,
 					ctrl_param, retval);
 }
 
 /* Helper for special devices with magic return codes */
-static int asus_wmi_get_devstate_bits(u32 dev_id, u32 mask)
+static int asus_wmi_get_devstate_bits(struct asus_wmi *asus,
+				      u32 dev_id, u32 mask)
 {
 	u32 retval = 0;
 	int err;
 
-	err = asus_wmi_get_devstate(dev_id, &retval);
+	err = asus_wmi_get_devstate(asus, dev_id, &retval);
 
 	if (err < 0)
 		return err;
@@ -264,9 +267,10 @@ static int asus_wmi_get_devstate_bits(u32 dev_id, u32 mask)
 	return retval & mask;
 }
 
-static int asus_wmi_get_devstate_simple(u32 dev_id)
+static int asus_wmi_get_devstate_simple(struct asus_wmi *asus, u32 dev_id)
 {
-	return asus_wmi_get_devstate_bits(dev_id, ASUS_WMI_DSTS_STATUS_BIT);
+	return asus_wmi_get_devstate_bits(asus, dev_id,
+					  ASUS_WMI_DSTS_STATUS_BIT);
 }
 
 /*
@@ -302,7 +306,7 @@ static void tpd_led_set(struct led_classdev *led_cdev,
 
 static int read_tpd_led_state(struct asus_wmi *asus)
 {
-	return asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_TOUCHPAD_LED);
+	return asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_TOUCHPAD_LED);
 }
 
 static enum led_brightness tpd_led_get(struct led_classdev *led_cdev)
@@ -353,7 +357,7 @@ static void asus_wmi_led_exit(struct asus_wmi *asus)
  */
 static bool asus_wlan_rfkill_blocked(struct asus_wmi *asus)
 {
-	int result = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WLAN);
+	int result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_WLAN);
 
 	if (result < 0)
 		return false;
@@ -482,7 +486,8 @@ static void asus_unregister_rfkill_notifier(struct asus_wmi *asus, char *node)
 static int asus_get_adapter_status(struct hotplug_slot *hotplug_slot,
 				   u8 *value)
 {
-	int result = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WLAN);
+	struct asus_wmi *asus = hotplug_slot->private;
+	int result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_WLAN);
 
 	if (result < 0)
 		return result;
@@ -578,7 +583,7 @@ static void asus_rfkill_query(struct rfkill *rfkill, void *data)
 	struct asus_rfkill *priv = data;
 	int result;
 
-	result = asus_wmi_get_devstate_simple(priv->dev_id);
+	result = asus_wmi_get_devstate_simple(priv->asus, priv->dev_id);
 
 	if (result < 0)
 		return;
@@ -619,7 +624,7 @@ static int asus_new_rfkill(struct asus_wmi *asus,
 			   struct asus_rfkill *arfkill,
 			   const char *name, enum rfkill_type type, int dev_id)
 {
-	int result = asus_wmi_get_devstate_simple(dev_id);
+	int result = asus_wmi_get_devstate_simple(asus, dev_id);
 	struct rfkill **rfkill = &arfkill->rfkill;
 
 	if (result < 0)
@@ -750,9 +755,9 @@ exit:
 /*
  * Backlight
  */
-static int read_backlight_power(void)
+static int read_backlight_power(struct asus_wmi *asus)
 {
-	int ret = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_BACKLIGHT);
+	int ret = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_BACKLIGHT);
 
 	if (ret < 0)
 		return ret;
@@ -762,10 +767,11 @@ static int read_backlight_power(void)
 
 static int read_brightness(struct backlight_device *bd)
 {
+	struct asus_wmi *asus = bl_get_data(bd);
 	u32 retval;
 	int err;
 
-	err = asus_wmi_get_devstate(ASUS_WMI_DEVID_BRIGHTNESS, &retval);
+	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_BRIGHTNESS, &retval);
 
 	if (err < 0)
 		return err;
@@ -775,6 +781,7 @@ static int read_brightness(struct backlight_device *bd)
 
 static int update_bl_status(struct backlight_device *bd)
 {
+	struct asus_wmi *asus = bl_get_data(bd);
 	u32 ctrl_param;
 	int power, err;
 
@@ -786,7 +793,7 @@ static int update_bl_status(struct backlight_device *bd)
 	if (err < 0)
 		return err;
 
-	power = read_backlight_power();
+	power = read_backlight_power(asus);
 	if (power != -ENODEV && bd->props.power != power) {
 		ctrl_param = !!(bd->props.power == FB_BLANK_UNBLANK);
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT,
@@ -825,9 +832,9 @@ static int asus_wmi_backlight_init(struct asus_wmi *asus)
 	int max;
 	int power;
 
-	max = asus_wmi_get_devstate_bits(ASUS_WMI_DEVID_BRIGHTNESS,
+	max = asus_wmi_get_devstate_bits(asus, ASUS_WMI_DEVID_BRIGHTNESS,
 					 ASUS_WMI_DSTS_MAX_BRIGTH_MASK);
-	power = read_backlight_power();
+	power = read_backlight_power(asus);
 
 	if (max < 0 && power < 0) {
 		/* Try to keep the original error */
@@ -921,12 +928,13 @@ static int parse_arg(const char *buf, unsigned long count, int *val)
 	return count;
 }
 
-static ssize_t store_sys_wmi(int devid, const char *buf, size_t count)
+static ssize_t store_sys_wmi(struct asus_wmi *asus, int devid,
+			     const char *buf, size_t count)
 {
 	u32 retval;
 	int rv, err, value;
 
-	value = asus_wmi_get_devstate_simple(devid);
+	value = asus_wmi_get_devstate_simple(asus, devid);
 	if (value == -ENODEV)	/* Check device presence */
 		return value;
 
@@ -939,9 +947,9 @@ static ssize_t store_sys_wmi(int devid, const char *buf, size_t count)
 	return rv;
 }
 
-static ssize_t show_sys_wmi(int devid, char *buf)
+static ssize_t show_sys_wmi(struct asus_wmi *asus, int devid, char *buf)
 {
-	int value = asus_wmi_get_devstate_simple(devid);
+	int value = asus_wmi_get_devstate_simple(asus, devid);
 
 	if (value < 0)
 		return value;
@@ -954,13 +962,17 @@ static ssize_t show_sys_wmi(int devid, char *buf)
 				    struct device_attribute *attr,	\
 				    char *buf)				\
 	{								\
-		return show_sys_wmi(_cm, buf);				\
+		struct asus_wmi *asus = dev_get_drvdata(dev);		\
+									\
+		return show_sys_wmi(asus, _cm, buf);			\
 	}								\
 	static ssize_t store_##_name(struct device *dev,		\
 				     struct device_attribute *attr,	\
 				     const char *buf, size_t count)	\
 	{								\
-		return store_sys_wmi(_cm, buf, count);			\
+		struct asus_wmi *asus = dev_get_drvdata(dev);		\
+									\
+		return store_sys_wmi(asus, _cm, buf, count);		\
 	}								\
 	static struct device_attribute dev_attr_##_name = {		\
 		.attr = {						\
@@ -1000,7 +1012,10 @@ static struct attribute *platform_attributes[] = {
 static mode_t asus_sysfs_is_visible(struct kobject *kobj,
 				    struct attribute *attr, int idx)
 {
-	bool supported = true;
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct asus_wmi *asus = platform_get_drvdata(pdev);
+	bool ok = true;
 	int devid = -1;
 
 	if (attr == &dev_attr_camera.attr)
@@ -1011,9 +1026,9 @@ static mode_t asus_sysfs_is_visible(struct kobject *kobj,
 		devid = ASUS_WMI_DEVID_TOUCHPAD;
 
 	if (devid != -1)
-		supported = asus_wmi_get_devstate_simple(devid) != -ENODEV;
+		ok = !(asus_wmi_get_devstate_simple(asus, devid) < 0);
 
-	return supported ? attr->mode : 0;
+	return ok ? attr->mode : 0;
 }
 
 static struct attribute_group platform_attribute_group = {
@@ -1036,6 +1051,23 @@ static int asus_wmi_sysfs_init(struct platform_device *device)
  */
 static int __init asus_wmi_platform_init(struct asus_wmi *asus)
 {
+	/*
+	 * Eee PC and Notebooks seems to have different method_id for DSTS,
+	 * but it may also be related to the BIOS's SPEC.
+	 * Note, on most Eeepc, there is no way to check if a method exist
+	 * or note, while on notebooks, they returns 0xFFFFFFFE on failure,
+	 * but once again, SPEC may probably be used for that kind of things.
+	 */
+	if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS, 0, 0, NULL))
+		asus->dsts_id = ASUS_WMI_METHODID_DSTS;
+	else if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS2, 0, 0, NULL))
+		asus->dsts_id = ASUS_WMI_METHODID_DSTS2;
+
+	if (!asus->dsts_id) {
+		pr_err("Can't find DSTS");
+		return -ENODEV;
+	}
+
 	return asus_wmi_sysfs_init(asus->platform_device);
 }
 
@@ -1059,7 +1091,7 @@ static int show_dsts(struct seq_file *m, void *data)
 	int err;
 	u32 retval = -1;
 
-	err = asus_wmi_get_devstate(asus->debug.dev_id, &retval);
+	err = asus_wmi_get_devstate(asus, asus->debug.dev_id, &retval);
 
 	if (err < 0)
 		return err;
@@ -1262,7 +1294,7 @@ static int asus_hotk_thaw(struct device *device)
 		 * during suspend.  Normally it restores it on resume, but
 		 * we should kick it ourselves in case hibernation is aborted.
 		 */
-		wlan = asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WLAN);
+		wlan = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_WLAN);
 		asus_wmi_set_devstate(ASUS_WMI_DEVID_WLAN, wlan, NULL);
 	}
 
@@ -1279,15 +1311,16 @@ static int asus_hotk_restore(struct device *device)
 		asus_rfkill_hotplug(asus);
 
 	if (asus->bluetooth.rfkill) {
-		bl = !asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_BLUETOOTH);
+		bl = !asus_wmi_get_devstate_simple(asus,
+						   ASUS_WMI_DEVID_BLUETOOTH);
 		rfkill_set_sw_state(asus->bluetooth.rfkill, bl);
 	}
 	if (asus->wimax.rfkill) {
-		bl = !asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WIMAX);
+		bl = !asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_WIMAX);
 		rfkill_set_sw_state(asus->wimax.rfkill, bl);
 	}
 	if (asus->wwan3g.rfkill) {
-		bl = !asus_wmi_get_devstate_simple(ASUS_WMI_DEVID_WWAN3G);
+		bl = !asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_WWAN3G);
 		rfkill_set_sw_state(asus->wwan3g.rfkill, bl);
 	}
 
-- 
1.7.4

