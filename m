Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1BFMaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:11 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:39440 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1BFMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:04 -0500
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH v2 11/18] eeepc-wmi: add camera and card reader support
Date: Sun,  6 Feb 2011 13:28:36 +0100
Message-Id: <1296995324-5462-12-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 Documentation/ABI/testing/sysfs-platform-eeepc-wmi |   14 +++
 drivers/platform/x86/eeepc-wmi.c                   |   89 +++++++++++++++++++-
 2 files changed, 102 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-platform-eeepc-wmi b/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
index e4b5fef..9fc8d33 100644
--- a/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-eeepc-wmi
@@ -8,3 +8,17 @@ Description:
 		    * 0 -> Super Performance Mode
 		    * 1 -> High Performance Mode
 		    * 2 -> Power Saving Mode
+
+What:		/sys/devices/platform/eeepc-wmi/camera
+Date:		Jan 2010
+KernelVersion:	2.6.39
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Control the camera. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/eeepc-wmi/cardr
+Date:		Jan 2010
+KernelVersion:	2.6.39
+Contact:	"Corentin Chary" <corentincj@iksaif.net>
+Description:
+		Control the card reader. 1 means on, 0 means off.
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 391c32b..83415dd 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -73,6 +73,8 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
 #define EEEPC_WMI_DEVID_WWAN3G		0x00010019
 #define EEEPC_WMI_DEVID_BACKLIGHT	0x00050012
+#define EEEPC_WMI_DEVID_CAMERA		0x00060013
+#define EEEPC_WMI_DEVID_CARDREADER	0x00080013
 #define EEEPC_WMI_DEVID_TPDLED		0x00100011
 
 #define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
@@ -879,6 +881,70 @@ static void eeepc_wmi_notify(u32 value, void *context)
 	kfree(obj);
 }
 
+/*
+ * Sys helpers
+ */
+static int parse_arg(const char *buf, unsigned long count, int *val)
+{
+	if (!count)
+		return 0;
+	if (sscanf(buf, "%i", val) != 1)
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t store_sys_wmi(int devid, const char *buf, size_t count)
+{
+	acpi_status status;
+	u32 retval;
+	int rv, value;
+
+	value = eeepc_wmi_get_devstate_simple(devid);
+	if (value == -ENODEV) /* Check device presence */
+		return value;
+
+	rv = parse_arg(buf, count, &value);
+	status = eeepc_wmi_set_devstate(devid, value, &retval);
+
+	if (ACPI_FAILURE(status))
+		return -EIO;
+	return rv;
+}
+
+static ssize_t show_sys_wmi(int devid, char *buf)
+{
+	int value = eeepc_wmi_get_devstate_simple(devid);
+
+	if (value < 0)
+		return value;
+
+	return sprintf(buf, "%d\n", value);
+}
+
+#define EEEPC_WMI_CREATE_DEVICE_ATTR(_name, _mode, _cm)			\
+	static ssize_t show_##_name(struct device *dev,			\
+				    struct device_attribute *attr,	\
+				    char *buf)				\
+	{								\
+		return show_sys_wmi(_cm, buf);				\
+	}								\
+	static ssize_t store_##_name(struct device *dev,		\
+				     struct device_attribute *attr,	\
+				     const char *buf, size_t count)	\
+	{								\
+		return store_sys_wmi(_cm, buf, count);			\
+	}								\
+	static struct device_attribute dev_attr_##_name = {		\
+		.attr = {						\
+			.name = __stringify(_name),			\
+			.mode = _mode },				\
+		.show   = show_##_name,					\
+		.store  = store_##_name,				\
+	}
+
+EEEPC_WMI_CREATE_DEVICE_ATTR(camera, 0644, EEEPC_WMI_DEVID_CAMERA);
+EEEPC_WMI_CREATE_DEVICE_ATTR(cardr, 0644, EEEPC_WMI_DEVID_CARDREADER);
+
 static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
@@ -904,11 +970,32 @@ static DEVICE_ATTR(cpufv, S_IRUGO | S_IWUSR, NULL, store_cpufv);
 
 static struct attribute *platform_attributes[] = {
 	&dev_attr_cpufv.attr,
+	&dev_attr_camera.attr,
+	&dev_attr_cardr.attr,
 	NULL
 };
 
+static mode_t eeepc_sysfs_is_visible(struct kobject *kobj,
+				     struct attribute *attr,
+				     int idx)
+{
+	bool supported = true;
+	int devid = -1;
+
+	if (attr == &dev_attr_camera.attr)
+		devid = EEEPC_WMI_DEVID_CAMERA;
+	else if (attr == &dev_attr_cardr.attr)
+		devid = EEEPC_WMI_DEVID_CARDREADER;
+
+	if (devid != -1)
+		supported = eeepc_wmi_get_devstate_simple(devid) != -ENODEV;
+
+	return supported ? attr->mode : 0;
+}
+
 static struct attribute_group platform_attribute_group = {
-	.attrs = platform_attributes
+	.is_visible	= eeepc_sysfs_is_visible,
+	.attrs		= platform_attributes
 };
 
 static void eeepc_wmi_sysfs_exit(struct platform_device *device)
-- 
1.7.4.rc3

