Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab2KDIjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:39:09 -0500
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:47948 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398Ab2KDIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:39:06 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 7D6138576
Subject: [PATCH 3/4] HID: roccat: Enabling Koneplus device reset
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Nov 2012 09:39:04 +0100
Message-ID: <1352018344.2673.133.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device can be reset to factory state by sending a command via info sysfs attr.
Added binary attribute info for this purpose, which obsoletes firmware_version
attribute.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/obsolete/sysfs-driver-hid-roccat-koneplus  |   11 ++++++++++
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |   13 ++++-------
 drivers/hid/hid-roccat-koneplus.c                  |   22 ++++++++++++++++++++
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
index c2a270b..22568b4 100644
--- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus
@@ -8,3 +8,14 @@ Description:	The integer value of this attribute ranges from 0-4.
 		When written, this file sets the number of the startup profile
 		and the mouse activates this profile immediately.
 		Please use actual_profile, it does the same thing.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/firmware_version
+Date:		October 2010
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	When read, this file returns the raw integer version number of the
+		firmware reported by the mouse. Using the integer value eases
+		further usage in other programs. To receive the real version
+		number the decimal point has to be shifted 2 positions to the
+		left. E.g. a returned value of 121 means 1.21
+		This file is readonly.
+		Please read binary attribute info which contains firmware version.
diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index f9e2a61..ed1213d 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -9,15 +9,12 @@ Description:	The integer value of this attribute ranges from 0-4.
 		and the mouse activates this profile immediately.
 Users:		http://roccat.sourceforge.net
 
-What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/firmware_version
-Date:		October 2010
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/info
+Date:		November 2012
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
-Description:	When read, this file returns the raw integer version number of the
-		firmware reported by the mouse. Using the integer value eases
-		further usage in other programs. To receive the real version
-		number the decimal point has to be shifted 2 positions to the
-		left. E.g. a returned value of 121 means 1.21
-		This file is readonly.
+Description:	When read, this file returns general data like firmware version.
+		When written, the device can be reset.
+		The data is 8 bytes long.
 Users:		http://roccat.sourceforge.net
 
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/macro
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 0df4083..69592f4 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -183,6 +183,22 @@ static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
 	return real_size;
 }
 
+static ssize_t koneplus_sysfs_read_info(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_read(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_info), KONEPLUS_COMMAND_INFO);
+}
+
+static ssize_t koneplus_sysfs_write_info(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_write(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_info), KONEPLUS_COMMAND_INFO);
+}
+
 static ssize_t koneplus_sysfs_write_talk(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -429,6 +445,12 @@ static struct device_attribute koneplus_attributes[] = {
 
 static struct bin_attribute koneplus_bin_attributes[] = {
 	{
+		.attr = { .name = "info", .mode = 0660 },
+		.size = sizeof(struct koneplus_info),
+		.read = koneplus_sysfs_read_info,
+		.write = koneplus_sysfs_write_info
+	},
+	{
 		.attr = { .name = "sensor", .mode = 0660 },
 		.size = sizeof(struct koneplus_sensor),
 		.read = koneplus_sysfs_read_sensor,
-- 
1.7.3.4



