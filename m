Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1JNJIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:08:36 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51320 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab1JNJId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:33 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 2/8] asus-laptop: Pegatron Lucid ALS sensor
Date: Fri, 14 Oct 2011 11:13:36 +0200
Message-Id: <1318583622-23518-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Ross <andy.ross@windriver.com>

Ambient light sensor for Pegatron Lucid.  Supports pre-existing
ls_switch sysfs interface to en/disable automatic control, and exports
the brightness from the device as "ls_value".

Signed-off-by: Andy Ross <andy.ross@windriver.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |   80 +++++++++++++++++++++++++++++++++--
 1 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index c08f4c2..afed9ff 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -177,9 +177,15 @@ MODULE_PARM_DESC(wwan_status, "Set the wireless status on boot "
 
 /* For Pegatron Lucid tablet */
 #define DEVICE_NAME_PEGA	"Lucid"
+
 #define METHOD_PEGA_ENABLE	"ENPR"
 #define METHOD_PEGA_DISABLE	"DAPR"
+#define PEGA_ALS	0x04
+#define PEGA_ALS_POWER	0x05
+
 #define METHOD_PEGA_READ	"RDLN"
+#define PEGA_READ_ALS_H	0x02
+#define PEGA_READ_ALS_L	0x03
 
 /*
  * Define a specific led structure to keep the main structure clean
@@ -340,6 +346,12 @@ static bool asus_check_pega_lucid(struct asus_laptop *asus)
 	   !acpi_check_handle(asus->handle, METHOD_PEGA_READ, NULL);
 }
 
+static int asus_pega_lucid_set(struct asus_laptop *asus, int unit, bool enable)
+{
+	char *method = enable ? METHOD_PEGA_ENABLE : METHOD_PEGA_DISABLE;
+	return write_acpi_int(asus->handle, method, unit);
+}
+
 /* Generic LED function */
 static int asus_led_set(struct asus_laptop *asus, const char *method,
 			 int value)
@@ -924,8 +936,18 @@ static ssize_t store_disp(struct device *dev, struct device_attribute *attr,
  */
 static void asus_als_switch(struct asus_laptop *asus, int value)
 {
-	if (write_acpi_int(asus->handle, METHOD_ALS_CONTROL, value))
-		pr_warn("Error setting light sensor switch\n");
+	int ret;
+
+	if (asus->is_pega_lucid) {
+		ret = asus_pega_lucid_set(asus, PEGA_ALS, value);
+		if (!ret)
+			ret = asus_pega_lucid_set(asus, PEGA_ALS_POWER, value);
+	} else {
+		ret = write_acpi_int(asus->handle, METHOD_ALS_CONTROL, value);
+	}
+	if (ret)
+		pr_warning("Error setting light sensor switch\n");
+
 	asus->light_switch = value;
 }
 
@@ -981,6 +1003,35 @@ static ssize_t store_lslvl(struct device *dev, struct device_attribute *attr,
 	return rv;
 }
 
+static int pega_int_read(struct asus_laptop *asus, int arg, int *result)
+{
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	int err = write_acpi_int_ret(asus->handle, METHOD_PEGA_READ, arg,
+				     &buffer);
+	if (!err) {
+		union acpi_object *obj = buffer.pointer;
+		if (obj && obj->type == ACPI_TYPE_INTEGER)
+			*result = obj->integer.value;
+		else
+			err = -EIO;
+	}
+	return err;
+}
+
+static ssize_t show_lsvalue(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct asus_laptop *asus = dev_get_drvdata(dev);
+	int err, hi, lo;
+
+	err = pega_int_read(asus, PEGA_READ_ALS_H, &hi);
+	if (!err)
+		err = pega_int_read(asus, PEGA_READ_ALS_L, &lo);
+	if (!err)
+		return sprintf(buf, "%d\n", 10 * hi + lo);
+	return err;
+}
+
 /*
  * GPS
  */
@@ -1169,6 +1220,7 @@ static DEVICE_ATTR(wimax, S_IRUGO | S_IWUSR, show_wimax, store_wimax);
 static DEVICE_ATTR(wwan, S_IRUGO | S_IWUSR, show_wwan, store_wwan);
 static DEVICE_ATTR(display, S_IWUSR, NULL, store_disp);
 static DEVICE_ATTR(ledd, S_IRUGO | S_IWUSR, show_ledd, store_ledd);
+static DEVICE_ATTR(ls_value, S_IRUGO, show_lsvalue, NULL);
 static DEVICE_ATTR(ls_level, S_IRUGO | S_IWUSR, show_lslvl, store_lslvl);
 static DEVICE_ATTR(ls_switch, S_IRUGO | S_IWUSR, show_lssw, store_lssw);
 static DEVICE_ATTR(gps, S_IRUGO | S_IWUSR, show_gps, store_gps);
@@ -1181,6 +1233,7 @@ static struct attribute *asus_attributes[] = {
 	&dev_attr_wwan.attr,
 	&dev_attr_display.attr,
 	&dev_attr_ledd.attr,
+	&dev_attr_ls_value.attr,
 	&dev_attr_ls_level.attr,
 	&dev_attr_ls_switch.attr,
 	&dev_attr_gps.attr,
@@ -1197,6 +1250,19 @@ static mode_t asus_sysfs_is_visible(struct kobject *kobj,
 	acpi_handle handle = asus->handle;
 	bool supported;
 
+	if (asus->is_pega_lucid) {
+		/* no ls_level interface on the Lucid */
+		if (attr == &dev_attr_ls_switch.attr)
+			supported = true;
+		else if (attr == &dev_attr_ls_level.attr)
+			supported = false;
+		else
+			goto normal;
+
+		return supported;
+	}
+
+normal:
 	if (attr == &dev_attr_wlan.attr) {
 		supported = !acpi_check_handle(handle, METHOD_WLAN, NULL);
 
@@ -1219,7 +1285,9 @@ static mode_t asus_sysfs_is_visible(struct kobject *kobj,
 	} else if (attr == &dev_attr_ls_switch.attr ||
 		   attr == &dev_attr_ls_level.attr) {
 		supported = !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
-			    !acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
+			!acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
+	} else if (attr == &dev_attr_ls_value.attr) {
+		supported = asus->is_pega_lucid;
 	} else if (attr == &dev_attr_gps.attr) {
 		supported = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
 			    !acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
@@ -1407,8 +1475,10 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 	asus->light_switch = 0;	/* Default to light sensor disabled */
 	asus->light_level = 5;	/* level 5 for sensor sensitivity */
 
-	if (!acpi_check_handle(asus->handle, METHOD_ALS_CONTROL, NULL) &&
-	    !acpi_check_handle(asus->handle, METHOD_ALS_LEVEL, NULL)) {
+	if (asus->is_pega_lucid) {
+		asus_als_switch(asus, asus->light_switch);
+	} else if (!acpi_check_handle(asus->handle, METHOD_ALS_CONTROL, NULL) &&
+		   !acpi_check_handle(asus->handle, METHOD_ALS_LEVEL, NULL)) {
 		asus_als_switch(asus, asus->light_switch);
 		asus_als_level(asus, asus->light_level);
 	}
-- 
1.7.3.4

