Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab2FMHc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:32:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51230 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2FMHc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:32:26 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rob Landley <rob@landley.net>, Matthew Garrett <mjg@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net
Subject: [PATCH 7/7] asus-wmi: enable resume on lid open
Date: Wed, 13 Jun 2012 09:32:07 +0200
Message-Id: <1339572727-24744-8-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
References: <1339572727-24744-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

According to the ASUS WMI spec., to enable resume on lid open should
use the device ID(0x00120032), but it doesn't work indeed.

After discussing with ASUS' BIOS engineer, they say wake on lid open
doesn't have a uniq device ID(0x00120032) in the BIOS. It shares the same
device ID with deep S3(0x00120031), and the deep S3(resume on lid open)
is disable by default.

Adding this option in asus wmi sysfs
   /sys/devices/platform/<platform>/lid_resume
so that userspace apps can enable/disable this feature by themselves.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 Documentation/ABI/testing/sysfs-platform-asus-wmi |    7 +++++++
 drivers/platform/x86/asus-wmi.c                   |    7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-platform-asus-wmi b/Documentation/ABI/testing/sysfs-platform-asus-wmi
index 2e7df91..019e1e2 100644
--- a/Documentation/ABI/testing/sysfs-platform-asus-wmi
+++ b/Documentation/ABI/testing/sysfs-platform-asus-wmi
@@ -29,3 +29,10 @@ KernelVersion:	2.6.39
 Contact:	"Corentin Chary" <corentincj@iksaif.net>
 Description:
 		Control the card touchpad. 1 means on, 0 means off.
+
+What:		/sys/devices/platform/<platform>/lid_resume
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	"AceLan Kao" <acelan.kao@canonical.com>
+Description:
+		Resume on lid open. 1 means on, 0 means off.
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 4beded3..c4d9b0e 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -139,6 +139,9 @@ MODULE_LICENSE("GPL");
 /* Power */
 #define ASUS_WMI_DEVID_PROCESSOR_STATE	0x00120012
 
+/* Deep S3 / Resume on LID open */
+#define ASUS_WMI_DEVID_LID_RESUME	0x00120031
+
 /* DSTS masks */
 #define ASUS_WMI_DSTS_STATUS_BIT	0x00000001
 #define ASUS_WMI_DSTS_UNKNOWN_BIT	0x00000002
@@ -1368,6 +1371,7 @@ static ssize_t show_sys_wmi(struct asus_wmi *asus, int devid, char *buf)
 ASUS_WMI_CREATE_DEVICE_ATTR(touchpad, 0644, ASUS_WMI_DEVID_TOUCHPAD);
 ASUS_WMI_CREATE_DEVICE_ATTR(camera, 0644, ASUS_WMI_DEVID_CAMERA);
 ASUS_WMI_CREATE_DEVICE_ATTR(cardr, 0644, ASUS_WMI_DEVID_CARDREADER);
+ASUS_WMI_CREATE_DEVICE_ATTR(lid_resume, 0644, ASUS_WMI_DEVID_LID_RESUME);
 
 static ssize_t store_cpufv(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
@@ -1393,6 +1397,7 @@ static struct attribute *platform_attributes[] = {
 	&dev_attr_camera.attr,
 	&dev_attr_cardr.attr,
 	&dev_attr_touchpad.attr,
+	&dev_attr_lid_resume.attr,
 	NULL
 };
 
@@ -1411,6 +1416,8 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
 		devid = ASUS_WMI_DEVID_CARDREADER;
 	else if (attr == &dev_attr_touchpad.attr)
 		devid = ASUS_WMI_DEVID_TOUCHPAD;
+	else if (attr == &dev_attr_lid_resume.attr)
+		devid = ASUS_WMI_DEVID_LID_RESUME;
 
 	if (devid != -1)
 		ok = !(asus_wmi_get_devstate_simple(asus, devid) < 0);
-- 
1.7.9.5

