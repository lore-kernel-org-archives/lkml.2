Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1BZJXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:20 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:43669 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1BZJXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:23:12 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.37
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org (open list:X86 PLATFORM DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...)
Subject: [PATCH 13/14] asus-wmi: add hwmon interface and pwm1
Date: Sat, 26 Feb 2011 10:20:42 +0100
Message-Id: <1298712045-17671-14-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig    |    1 +
 drivers/platform/x86/asus-wmi.c |  128 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index cd65dac..486f016 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -440,6 +440,7 @@ config ASUS_WMI
 	tristate "ASUS WMI Driver (EXPERIMENTAL)"
 	depends on ACPI_WMI
 	depends on INPUT
+	depends on HWMON
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL || RFKILL = n
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 05db6b2..5b779a9 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -39,6 +39,8 @@
 #include <linux/rfkill.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
@@ -167,6 +169,7 @@ struct asus_wmi {
 
 	struct input_dev *inputdev;
 	struct backlight_device *backlight_device;
+	struct device *hwmon_device;
 	struct platform_device *platform_device;
 
 	struct led_classdev tpd_led;
@@ -791,6 +794,124 @@ exit:
 }
 
 /*
+ * Hwmon device
+ */
+static ssize_t asus_hwmon_pwm1(struct device *dev,
+			    struct device_attribute *attr,
+			    char *buf)
+{
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+	u32 value;
+	int err;
+
+	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_FAN_CTRL, &value);
+
+	if (err < 0)
+		return err;
+
+	value |= 0xFF;
+
+	if (value == 1) /* Low Speed */
+		value = 85;
+	else if (value == 2)
+		value = 170;
+	else if (value == 3)
+		value = 255;
+	else if (value != 0) {
+		pr_err("Unknown fan speed %#x", value);
+		value = -1;
+	}
+
+	return sprintf(buf, "%d\n", value);
+}
+
+static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO, asus_hwmon_pwm1, NULL, 0);
+
+static ssize_t
+show_name(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "asus\n");
+}
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
+
+static struct attribute *hwmon_attributes[] = {
+	&sensor_dev_attr_pwm1.dev_attr.attr,
+	&sensor_dev_attr_name.dev_attr.attr,
+	NULL
+};
+
+static mode_t asus_hwmon_sysfs_is_visible(struct kobject *kobj,
+				    struct attribute *attr, int idx)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev->parent);
+	struct asus_wmi *asus = platform_get_drvdata(pdev);
+	bool ok = true;
+	int dev_id = -1;
+	u32 value = ASUS_WMI_UNSUPPORTED_METHOD;
+
+	if (attr == &sensor_dev_attr_pwm1.dev_attr.attr)
+		dev_id = ASUS_WMI_DEVID_FAN_CTRL;
+
+	if (dev_id != -1) {
+		int err = asus_wmi_get_devstate(asus, dev_id, &value);
+
+		if (err < 0)
+			return err;
+	}
+
+	if (dev_id == ASUS_WMI_DEVID_FAN_CTRL) {
+		/*
+		 * We need to find a better way, probably using sfun,
+		 * bits or spec ...
+		 * Currently we disable it if:
+		 * - ASUS_WMI_UNSUPPORTED_METHOD is returned
+		 * - reverved bits are non-zero
+		 * - sfun and presence bit are not set
+		 */
+		if (value != ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
+		    || (!asus->sfun && !(value & ASUS_WMI_DSTS_PRESENCE_BIT)))
+			ok = false;
+	}
+
+	return ok ? attr->mode : 0;
+}
+
+static struct attribute_group hwmon_attribute_group = {
+	.is_visible = asus_hwmon_sysfs_is_visible,
+	.attrs = hwmon_attributes
+};
+
+static void asus_wmi_hwmon_exit(struct asus_wmi *asus)
+{
+	struct device *hwmon;
+
+	hwmon = asus->hwmon_device;
+	if (!hwmon)
+		return;
+	sysfs_remove_group(&hwmon->kobj, &hwmon_attribute_group);
+	hwmon_device_unregister(hwmon);
+	asus->hwmon_device = NULL;
+}
+
+static int asus_wmi_hwmon_init(struct asus_wmi *asus)
+{
+	struct device *hwmon;
+	int result;
+
+	hwmon = hwmon_device_register(&asus->platform_device->dev);
+	if (IS_ERR(hwmon)) {
+		pr_err("Could not register asus hwmon device\n");
+		return PTR_ERR(hwmon);
+	}
+	asus->hwmon_device = hwmon;
+	result = sysfs_create_group(&hwmon->kobj, &hwmon_attribute_group);
+	if (result)
+		asus_wmi_hwmon_exit(asus);
+	return result;
+}
+
+/*
  * Backlight
  */
 static int read_backlight_power(struct asus_wmi *asus)
@@ -1331,6 +1452,10 @@ static int asus_wmi_add(struct platform_device *pdev)
 	if (err)
 		goto fail_input;
 
+	err = asus_wmi_hwmon_init(asus);
+	if (err)
+		goto fail_hwmon;
+
 	err = asus_wmi_led_init(asus);
 	if (err)
 		goto fail_leds;
@@ -1369,6 +1494,8 @@ fail_backlight:
 fail_rfkill:
 	asus_wmi_led_exit(asus);
 fail_leds:
+	asus_wmi_hwmon_exit(asus);
+fail_hwmon:
 	asus_wmi_input_exit(asus);
 fail_input:
 	asus_wmi_platform_exit(asus);
@@ -1385,6 +1512,7 @@ static int asus_wmi_remove(struct platform_device *device)
 	wmi_remove_notify_handler(asus->driver->event_guid);
 	asus_wmi_backlight_exit(asus);
 	asus_wmi_input_exit(asus);
+	asus_wmi_hwmon_exit(asus);
 	asus_wmi_led_exit(asus);
 	asus_wmi_rfkill_exit(asus);
 	asus_wmi_debugfs_exit(asus);
-- 
1.7.4

