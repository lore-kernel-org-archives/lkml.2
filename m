Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1GAJge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:36:34 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:38110 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1GAJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:30 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 11/16] asus-wmi: add thermal sensor
Date: Fri,  1 Jul 2011 11:34:36 +0200
Message-Id: <1309512881-2901-12-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index a972d8e..cc947cc 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
+#include <linux/thermal.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -930,7 +931,26 @@ static ssize_t asus_hwmon_pwm1(struct device *dev,
 	return sprintf(buf, "%d\n", value);
 }
 
+static ssize_t asus_hwmon_temp1(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct asus_wmi *asus = dev_get_drvdata(dev);
+	u32 value;
+	int err;
+
+	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_THERMAL_CTRL, &value);
+
+	if (err < 0)
+		return err;
+
+	value = KELVIN_TO_CELSIUS((value & 0xFFFF)) * 1000;
+
+	return sprintf(buf, "%d\n", value);
+}
+
 static SENSOR_DEVICE_ATTR(pwm1, S_IRUGO, asus_hwmon_pwm1, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, asus_hwmon_temp1, NULL, 0);
 
 static ssize_t
 show_name(struct device *dev, struct device_attribute *attr, char *buf)
@@ -941,6 +961,7 @@ static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
 
 static struct attribute *hwmon_attributes[] = {
 	&sensor_dev_attr_pwm1.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
 	&sensor_dev_attr_name.dev_attr.attr,
 	NULL
 };
-- 
1.7.3.4

