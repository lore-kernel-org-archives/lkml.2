Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1BZJZo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:25:44 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:43320 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab1BZJWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:22:45 -0500
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
Subject: [PATCH 06/14] asus-wmi: factorise wmi_evaluate_method call
Date: Sat, 26 Feb 2011 10:20:35 +0100
Message-Id: <1298712045-17671-7-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch create a single function to call the
WMI methods. This function handle inexistent methods (when
implemented by the WMI devices, and this is not the case on
Eee PCs), ACPI errors, etc..

Also pack struct bios_arg, and make sure that we always send
a 64bit buffer when calling a WMI method, because this is
needed on Asus notebooks.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |  162 ++++++++++++++++-----------------------
 1 files changed, 65 insertions(+), 97 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 39ce3c1..34e6b4d 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -70,6 +70,8 @@ MODULE_LICENSE("GPL");
 #define ASUS_WMI_METHODID_DEVS		0x53564544
 #define ASUS_WMI_METHODID_CFVS		0x53564643
 
+#define ASUS_WMI_UNSUPPORTED_METHOD	0xFFFFFFFE
+
 /* Wireless */
 #define ASUS_WMI_DEVID_WLAN		0x00010011
 #define ASUS_WMI_DEVID_BLUETOOTH	0x00010013
@@ -98,9 +100,9 @@ MODULE_LICENSE("GPL");
 #define ASUS_WMI_DSTS_MAX_BRIGTH_MASK	0x0000FF00
 
 struct bios_args {
-	u32 dev_id;
-	u32 ctrl_param;
-};
+	u32 arg0;
+	u32 arg1;
+} __packed;
 
 /*
  * <platform>/    - debugfs root directory
@@ -187,20 +189,24 @@ static void asus_wmi_input_exit(struct asus_wmi *asus)
 	asus->inputdev = NULL;
 }
 
-static acpi_status asus_wmi_get_devstate(u32 dev_id, u32 *retval)
+static int asus_wmi_evaluate_method(u32 method_id, u32 arg0, u32 arg1,
+				    u32 *retval)
 {
-	struct acpi_buffer input = { (acpi_size) sizeof(u32), &dev_id };
+	struct bios_args args = {
+		.arg0 = arg0,
+		.arg1 = arg1,
+	};
+	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object *obj;
 	acpi_status status;
+	union acpi_object *obj;
 	u32 tmp;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
-				     1, ASUS_WMI_METHODID_DSTS,
+	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1, method_id,
 				     &input, &output);
 
 	if (ACPI_FAILURE(status))
-		return status;
+		goto exit;
 
 	obj = (union acpi_object *)output.pointer;
 	if (obj && obj->type == ACPI_TYPE_INTEGER)
@@ -213,60 +219,39 @@ static acpi_status asus_wmi_get_devstate(u32 dev_id, u32 *retval)
 
 	kfree(obj);
 
-	return status;
+exit:
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	if (tmp == ASUS_WMI_UNSUPPORTED_METHOD)
+		return -ENODEV;
 
+	return 0;
 }
 
-static acpi_status asus_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
-					 u32 *retval)
+static int asus_wmi_get_devstate(u32 dev_id, u32 *retval)
 {
-	struct bios_args args = {
-		.dev_id = dev_id,
-		.ctrl_param = ctrl_param,
-	};
-	struct acpi_buffer input = { (acpi_size) sizeof(args), &args };
-	acpi_status status;
-
-	if (!retval) {
-		status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1,
-					     ASUS_WMI_METHODID_DEVS,
-					     &input, NULL);
-	} else {
-		struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-		union acpi_object *obj;
-		u32 tmp;
-
-		status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID, 1,
-					     ASUS_WMI_METHODID_DEVS,
-					     &input, &output);
-
-		if (ACPI_FAILURE(status))
-			return status;
-
-		obj = (union acpi_object *)output.pointer;
-		if (obj && obj->type == ACPI_TYPE_INTEGER)
-			tmp = (u32) obj->integer.value;
-		else
-			tmp = 0;
-
-		*retval = tmp;
-
-		kfree(obj);
-	}
+	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_DSTS, dev_id,
+					0, retval);
+}
 
-	return status;
+static int asus_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
+					 u32 *retval)
+{
+	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_DEVS, dev_id,
+					ctrl_param, retval);
 }
 
 /* Helper for special devices with magic return codes */
 static int asus_wmi_get_devstate_bits(u32 dev_id, u32 mask)
 {
 	u32 retval = 0;
-	acpi_status status;
+	int err;
 
-	status = asus_wmi_get_devstate(dev_id, &retval);
+	err = asus_wmi_get_devstate(dev_id, &retval);
 
-	if (ACPI_FAILURE(status))
-		return -EINVAL;
+	if (err < 0)
+		return err;
 
 	if (!(retval & ASUS_WMI_DSTS_PRESENCE_BIT))
 		return -ENODEV;
@@ -584,14 +569,8 @@ static int asus_rfkill_set(void *data, bool blocked)
 {
 	struct asus_rfkill *priv = data;
 	u32 ctrl_param = !blocked;
-	acpi_status status;
-
-	status = asus_wmi_set_devstate(priv->dev_id, ctrl_param, NULL);
-
-	if (ACPI_FAILURE(status))
-		return -EIO;
 
-	return 0;
+	return asus_wmi_set_devstate(priv->dev_id, ctrl_param, NULL);
 }
 
 static void asus_rfkill_query(struct rfkill *rfkill, void *data)
@@ -784,38 +763,34 @@ static int read_backlight_power(void)
 static int read_brightness(struct backlight_device *bd)
 {
 	u32 retval;
-	acpi_status status;
+	int err;
 
-	status = asus_wmi_get_devstate(ASUS_WMI_DEVID_BRIGHTNESS, &retval);
+	err = asus_wmi_get_devstate(ASUS_WMI_DEVID_BRIGHTNESS, &retval);
 
-	if (ACPI_FAILURE(status))
-		return -EIO;
-	else
-		return retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK;
+	if (err < 0)
+		return err;
+
+	return retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK;
 }
 
 static int update_bl_status(struct backlight_device *bd)
 {
 	u32 ctrl_param;
-	acpi_status status;
-	int power;
+	int power, err;
 
 	ctrl_param = bd->props.brightness;
 
-	status = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
-				       ctrl_param, NULL);
+	err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
+				    ctrl_param, NULL);
 
-	if (ACPI_FAILURE(status))
-		return -EIO;
+	if (err < 0)
+		return err;
 
 	power = read_backlight_power();
 	if (power != -ENODEV && bd->props.power != power) {
 		ctrl_param = !!(bd->props.power == FB_BLANK_UNBLANK);
-		status = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT,
-					       ctrl_param, NULL);
-
-		if (ACPI_FAILURE(status))
-			return -EIO;
+		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT,
+					    ctrl_param, NULL);
 	}
 	return 0;
 }
@@ -948,19 +923,19 @@ static int parse_arg(const char *buf, unsigned long count, int *val)
 
 static ssize_t store_sys_wmi(int devid, const char *buf, size_t count)
 {
-	acpi_status status;
 	u32 retval;
-	int rv, value;
+	int rv, err, value;
 
 	value = asus_wmi_get_devstate_simple(devid);
 	if (value == -ENODEV)	/* Check device presence */
 		return value;
 
 	rv = parse_arg(buf, count, &value);
-	status = asus_wmi_set_devstate(devid, value, &retval);
+	err = asus_wmi_set_devstate(devid, value, &retval);
+
+	if (err < 0)
+		return err;
 
-	if (ACPI_FAILURE(status))
-		return -EIO;
 	return rv;
 }
 
@@ -1003,21 +978,13 @@ static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
 	int value;
-	struct acpi_buffer input = { (acpi_size) sizeof(value), &value };
-	acpi_status status;
 
 	if (!count || sscanf(buf, "%i", &value) != 1)
 		return -EINVAL;
 	if (value < 0 || value > 2)
 		return -EINVAL;
 
-	status = wmi_evaluate_method(ASUS_WMI_MGMT_GUID,
-				     1, ASUS_WMI_METHODID_CFVS, &input, NULL);
-
-	if (ACPI_FAILURE(status))
-		return -EIO;
-	else
-		return count;
+	return asus_wmi_evaluate_method(ASUS_WMI_METHODID_CFVS, value, 0, NULL);
 }
 
 static DEVICE_ATTR(cpufv, S_IRUGO | S_IWUSR, NULL, store_cpufv);
@@ -1089,13 +1056,13 @@ struct asus_wmi_debugfs_node {
 static int show_dsts(struct seq_file *m, void *data)
 {
 	struct asus_wmi *asus = m->private;
-	acpi_status status;
+	int err;
 	u32 retval = -1;
 
-	status = asus_wmi_get_devstate(asus->debug.dev_id, &retval);
+	err = asus_wmi_get_devstate(asus->debug.dev_id, &retval);
 
-	if (ACPI_FAILURE(status))
-		return -EIO;
+	if (err < 0)
+		return err;
 
 	seq_printf(m, "DSTS(%x) = %x\n", asus->debug.dev_id, retval);
 
@@ -1105,13 +1072,14 @@ static int show_dsts(struct seq_file *m, void *data)
 static int show_devs(struct seq_file *m, void *data)
 {
 	struct asus_wmi *asus = m->private;
-	acpi_status status;
+	int err;
 	u32 retval = -1;
 
-	status = asus_wmi_set_devstate(asus->debug.dev_id,
-				       asus->debug.ctrl_param, &retval);
-	if (ACPI_FAILURE(status))
-		return -EIO;
+	err = asus_wmi_set_devstate(asus->debug.dev_id, asus->debug.ctrl_param,
+				    &retval);
+
+	if (err < 0)
+		return err;
 
 	seq_printf(m, "DEVS(%x, %x) = %x\n", asus->debug.dev_id,
 		   asus->debug.ctrl_param, retval);
-- 
1.7.4

