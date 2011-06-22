Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1FVIFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:05:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59195 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1FVIFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:05:52 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] ideapad: define cfg bits and create sysfs node for cfg
Date: Wed, 22 Jun 2011 16:05:43 +0800
Message-Id: <1308729943-2624-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308729781-2590-1-git-send-email-ike.pan@canonical.com>
References: <1308729781-2590-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create /sys/devices/platform/ideapad/cfg for showing cfg value.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 .../ABI/testing/sysfs-platform-ideapad-laptop      |   17 +++++++
 drivers/platform/x86/ideapad-laptop.c              |   51 +++++++++++++------
 2 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
index 807fca2..ff53183 100644
--- a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
+++ b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
@@ -4,3 +4,20 @@ KernelVersion:	2.6.37
 Contact:	"Ike Panhc <ike.pan@canonical.com>"
 Description:
 		Control the power of camera module. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/ideapad/cfg
+Date:		Jun 2011
+KernelVersion:	3.1
+Contact:	"Ike Panhc <ike.pan@canonical.com>"
+Description:
+		Ideapad capability bits.
+		Bit 8-10: 1 - Intel graphic only
+		          2 - ATI graphic only
+		          3 - Nvidia graphic only
+		          4 - Intel and ATI graphic
+		          5 - Intel and Nvidia graphic
+		Bit 16: Bluetooth exist (1 for exist)
+		Bit 17: 3G exist (1 for exist)
+		Bit 18: Wifi exist (1 for exist)
+		Bit 19: Camera exist (1 for exist)
+
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index bfdda33..51d4144 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -35,10 +35,15 @@
 
 #define IDEAPAD_RFKILL_DEV_NUM	(3)
 
+#define CFG_BT_BIT	(16)
+#define CFG_3G_BIT	(17)
+#define CFG_WIFI_BIT	(18)
+
 struct ideapad_private {
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
 	struct platform_device *platform_device;
 	struct input_dev *inputdev;
+	unsigned long cfg;
 };
 
 static acpi_handle ideapad_handle;
@@ -155,7 +160,7 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 }
 
 /*
- * camera power
+ * sysfs
  */
 static ssize_t show_ideapad_cam(struct device *dev,
 				struct device_attribute *attr,
@@ -186,6 +191,27 @@ static ssize_t store_ideapad_cam(struct device *dev,
 
 static DEVICE_ATTR(camera_power, 0644, show_ideapad_cam, store_ideapad_cam);
 
+static ssize_t show_ideapad_cfg(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct ideapad_private *priv = dev_get_drvdata(dev);
+
+	return sprintf(buf, "0x%.8X\n", (unsigned int)(priv->cfg));
+}
+
+static DEVICE_ATTR(cfg, 0444, show_ideapad_cfg, NULL);
+
+static struct attribute *ideapad_attributes[] = {
+	&dev_attr_camera_power.attr,
+	&dev_attr_cfg.attr,
+	NULL
+};
+
+static struct attribute_group ideapad_attribute_group = {
+	.attrs = ideapad_attributes
+};
+
 /*
  * Rfkill
  */
@@ -197,9 +223,9 @@ struct ideapad_rfk_data {
 };
 
 const struct ideapad_rfk_data ideapad_rfk_data[] = {
-	{ "ideapad_wlan",	18, 0x15, RFKILL_TYPE_WLAN },
-	{ "ideapad_bluetooth",	16, 0x17, RFKILL_TYPE_BLUETOOTH },
-	{ "ideapad_3g",		17, 0x20, RFKILL_TYPE_WWAN },
+	{ "ideapad_wlan",      CFG_WIFI_BIT, 0x15, RFKILL_TYPE_WLAN },
+	{ "ideapad_bluetooth", CFG_BT_BIT,   0x17, RFKILL_TYPE_BLUETOOTH },
+	{ "ideapad_3g",        CFG_3G_BIT,   0x20, RFKILL_TYPE_WWAN },
 };
 
 static int ideapad_rfk_set(void *data, bool blocked)
@@ -280,15 +306,6 @@ static void __devexit ideapad_unregister_rfkill(struct acpi_device *adevice,
 /*
  * Platform device
  */
-static struct attribute *ideapad_attributes[] = {
-	&dev_attr_camera_power.attr,
-	NULL
-};
-
-static struct attribute_group ideapad_attribute_group = {
-	.attrs = ideapad_attributes
-};
-
 static int __devinit ideapad_platform_init(struct ideapad_private *priv)
 {
 	int result;
@@ -393,10 +410,11 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
 static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 {
-	int ret, i, cfg;
+	int ret, i;
+	unsigned long cfg;
 	struct ideapad_private *priv;
 
-	if (read_method_int(adevice->handle, "_CFG", &cfg))
+	if (read_method_int(adevice->handle, "_CFG", (int *)&cfg))
 		return -ENODEV;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -404,6 +422,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 		return -ENOMEM;
 	dev_set_drvdata(&adevice->dev, priv);
 	ideapad_handle = adevice->handle;
+	priv->cfg = cfg;
 
 	ret = ideapad_platform_init(priv);
 	if (ret)
@@ -414,7 +433,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 		goto input_failed;
 
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++) {
-		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
+		if (test_bit(ideapad_rfk_data[i].cfgbit, &cfg))
 			ideapad_register_rfkill(adevice, i);
 		else
 			priv->rfk[i] = NULL;
-- 
1.7.4.1

