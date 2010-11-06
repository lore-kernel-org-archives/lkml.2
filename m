Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0KFSv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:51:58 -0400
Received: from mail-in-18.arcor-online.net ([151.189.21.58]:54286 "EHLO
	mail-in-18.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab0KFSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:51:56 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-09.arcor-online.net 8A04619769A
Subject: [PATCH 1/3] HID: roccat: Reducing number of functions in kone and
 pyra drivers
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011051400250.15851@pobox.suse.cz>
References: <1287943025.2623.16.camel@neuromancer>
	 <alpine.LNX.2.00.1011041418530.15851@pobox.suse.cz>
	 <1288978962.2585.15.camel@neuromancer>
	 <alpine.LNX.2.00.1011051400250.15851@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Nov 2010 19:51:52 +0100
Message-ID: <1289069512.5166.2.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The profile number is now passed via bin_attribute->private instead
of function parameter to reduce number of functions.
This patch does for kone and pyra what a previous patch did for
koneplus.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-kone.c |  107 ++++++++++---------------------------
 drivers/hid/hid-roccat-pyra.c |  120 +++++++++--------------------------------
 2 files changed, 54 insertions(+), 173 deletions(-)

diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index f776957..128d1b0 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -35,6 +35,8 @@
 #include "hid-roccat.h"
 #include "hid-roccat-kone.h"
 
+static uint profile_numbers[5] = {0, 1, 2, 3, 4};
+
 static void kone_set_settings_checksum(struct kone_settings *settings)
 {
 	uint16_t checksum = 0;
@@ -319,9 +321,10 @@ static ssize_t kone_sysfs_write_settings(struct file *fp, struct kobject *kobj,
 	return sizeof(struct kone_settings);
 }
 
-static ssize_t kone_sysfs_read_profilex(struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, int number) {
+static ssize_t kone_sysfs_read_profilex(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 
@@ -332,46 +335,17 @@ static ssize_t kone_sysfs_read_profilex(struct kobject *kobj,
 		count = sizeof(struct kone_profile) - off;
 
 	mutex_lock(&kone->kone_lock);
-	memcpy(buf, ((char const *)&kone->profiles[number - 1]) + off, count);
+	memcpy(buf, ((char const *)&kone->profiles[*(uint *)(attr->private)]) + off, count);
 	mutex_unlock(&kone->kone_lock);
 
 	return count;
 }
 
-static ssize_t kone_sysfs_read_profile1(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 1);
-}
-
-static ssize_t kone_sysfs_read_profile2(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 2);
-}
-
-static ssize_t kone_sysfs_read_profile3(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 3);
-}
-
-static ssize_t kone_sysfs_read_profile4(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 4);
-}
-
-static ssize_t kone_sysfs_read_profile5(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_read_profilex(kobj, attr, buf, off, count, 5);
-}
-
 /* Writes data only if different to stored data */
-static ssize_t kone_sysfs_write_profilex(struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, int number) {
+static ssize_t kone_sysfs_write_profilex(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct kone_device *kone = hid_get_drvdata(dev_get_drvdata(dev));
 	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
@@ -382,13 +356,13 @@ static ssize_t kone_sysfs_write_profilex(struct kobject *kobj,
 	if (off != 0 || count != sizeof(struct kone_profile))
 		return -EINVAL;
 
-	profile = &kone->profiles[number - 1];
+	profile = &kone->profiles[*(uint *)(attr->private)];
 
 	mutex_lock(&kone->kone_lock);
 	difference = memcmp(buf, profile, sizeof(struct kone_profile));
 	if (difference) {
 		retval = kone_set_profile(usb_dev,
-				(struct kone_profile const *)buf, number);
+				(struct kone_profile const *)buf, *(uint *)(attr->private) + 1);
 		if (!retval)
 			memcpy(profile, buf, sizeof(struct kone_profile));
 	}
@@ -400,36 +374,6 @@ static ssize_t kone_sysfs_write_profilex(struct kobject *kobj,
 	return sizeof(struct kone_profile);
 }
 
-static ssize_t kone_sysfs_write_profile1(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 1);
-}
-
-static ssize_t kone_sysfs_write_profile2(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 2);
-}
-
-static ssize_t kone_sysfs_write_profile3(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 3);
-}
-
-static ssize_t kone_sysfs_write_profile4(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 4);
-}
-
-static ssize_t kone_sysfs_write_profile5(struct file *fp, struct kobject *kobj,
-		struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count) {
-	return kone_sysfs_write_profilex(kobj, attr, buf, off, count, 5);
-}
-
 static ssize_t kone_sysfs_show_actual_profile(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -678,36 +622,41 @@ static struct bin_attribute kone_settings_attr = {
 static struct bin_attribute kone_profile1_attr = {
 	.attr = { .name = "profile1", .mode = 0660 },
 	.size = sizeof(struct kone_profile),
-	.read = kone_sysfs_read_profile1,
-	.write = kone_sysfs_write_profile1
+	.read = kone_sysfs_read_profilex,
+	.write = kone_sysfs_write_profilex,
+	.private = &profile_numbers[0]
 };
 
 static struct bin_attribute kone_profile2_attr = {
 	.attr = { .name = "profile2", .mode = 0660 },
 	.size = sizeof(struct kone_profile),
-	.read = kone_sysfs_read_profile2,
-	.write = kone_sysfs_write_profile2
+	.read = kone_sysfs_read_profilex,
+	.write = kone_sysfs_write_profilex,
+	.private = &profile_numbers[1]
 };
 
 static struct bin_attribute kone_profile3_attr = {
 	.attr = { .name = "profile3", .mode = 0660 },
 	.size = sizeof(struct kone_profile),
-	.read = kone_sysfs_read_profile3,
-	.write = kone_sysfs_write_profile3
+	.read = kone_sysfs_read_profilex,
+	.write = kone_sysfs_write_profilex,
+	.private = &profile_numbers[2]
 };
 
 static struct bin_attribute kone_profile4_attr = {
 	.attr = { .name = "profile4", .mode = 0660 },
 	.size = sizeof(struct kone_profile),
-	.read = kone_sysfs_read_profile4,
-	.write = kone_sysfs_write_profile4
+	.read = kone_sysfs_read_profilex,
+	.write = kone_sysfs_write_profilex,
+	.private = &profile_numbers[3]
 };
 
 static struct bin_attribute kone_profile5_attr = {
 	.attr = { .name = "profile5", .mode = 0660 },
 	.size = sizeof(struct kone_profile),
-	.read = kone_sysfs_read_profile5,
-	.write = kone_sysfs_write_profile5
+	.read = kone_sysfs_read_profilex,
+	.write = kone_sysfs_write_profilex,
+	.private = &profile_numbers[4]
 };
 
 static int kone_create_sysfs_attributes(struct usb_interface *intf)
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 9bf2304..0dad5c6 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -27,6 +27,8 @@
 #include "hid-roccat.h"
 #include "hid-roccat-pyra.h"
 
+static uint profile_numbers[5] = {0, 1, 2, 3, 4};
+
 static void profile_activated(struct pyra_device *pyra,
 		unsigned int new_profile)
 {
@@ -221,7 +223,7 @@ static int pyra_set_settings(struct usb_device *usb_dev,
 
 static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, int number)
+		loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
@@ -233,56 +235,16 @@ static ssize_t pyra_sysfs_read_profilex_settings(struct file *fp,
 		count = sizeof(struct pyra_profile_settings) - off;
 
 	mutex_lock(&pyra->pyra_lock);
-	memcpy(buf, ((char const *)&pyra->profile_settings[number]) + off,
+	memcpy(buf, ((char const *)&pyra->profile_settings[*(uint *)(attr->private)]) + off,
 			count);
 	mutex_unlock(&pyra->pyra_lock);
 
 	return count;
 }
 
-static ssize_t pyra_sysfs_read_profile1_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 0);
-}
-
-static ssize_t pyra_sysfs_read_profile2_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 1);
-}
-
-static ssize_t pyra_sysfs_read_profile3_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 2);
-}
-
-static ssize_t pyra_sysfs_read_profile4_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 3);
-}
-
-static ssize_t pyra_sysfs_read_profile5_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 4);
-}
-
 static ssize_t pyra_sysfs_read_profilex_buttons(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, int number)
+		loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct pyra_device *pyra = hid_get_drvdata(dev_get_drvdata(dev));
@@ -294,53 +256,13 @@ static ssize_t pyra_sysfs_read_profilex_buttons(struct file *fp,
 		count = sizeof(struct pyra_profile_buttons) - off;
 
 	mutex_lock(&pyra->pyra_lock);
-	memcpy(buf, ((char const *)&pyra->profile_buttons[number]) + off,
+	memcpy(buf, ((char const *)&pyra->profile_buttons[*(uint *)(attr->private)]) + off,
 			count);
 	mutex_unlock(&pyra->pyra_lock);
 
 	return count;
 }
 
-static ssize_t pyra_sysfs_read_profile1_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 0);
-}
-
-static ssize_t pyra_sysfs_read_profile2_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 1);
-}
-
-static ssize_t pyra_sysfs_read_profile3_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 2);
-}
-
-static ssize_t pyra_sysfs_read_profile4_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 3);
-}
-
-static ssize_t pyra_sysfs_read_profile5_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return pyra_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 4);
-}
-
 static ssize_t pyra_sysfs_write_profile_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -525,31 +447,36 @@ static struct bin_attribute pyra_profile_settings_attr = {
 static struct bin_attribute pyra_profile1_settings_attr = {
 		.attr = { .name = "profile1_settings", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_settings),
-		.read = pyra_sysfs_read_profile1_settings
+		.read = pyra_sysfs_read_profilex_settings,
+		.private = &profile_numbers[0]
 };
 
 static struct bin_attribute pyra_profile2_settings_attr = {
 		.attr = { .name = "profile2_settings", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_settings),
-		.read = pyra_sysfs_read_profile2_settings
+		.read = pyra_sysfs_read_profilex_settings,
+		.private = &profile_numbers[1]
 };
 
 static struct bin_attribute pyra_profile3_settings_attr = {
 		.attr = { .name = "profile3_settings", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_settings),
-		.read = pyra_sysfs_read_profile3_settings
+		.read = pyra_sysfs_read_profilex_settings,
+		.private = &profile_numbers[2]
 };
 
 static struct bin_attribute pyra_profile4_settings_attr = {
 		.attr = { .name = "profile4_settings", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_settings),
-		.read = pyra_sysfs_read_profile4_settings
+		.read = pyra_sysfs_read_profilex_settings,
+		.private = &profile_numbers[3]
 };
 
 static struct bin_attribute pyra_profile5_settings_attr = {
 		.attr = { .name = "profile5_settings", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_settings),
-		.read = pyra_sysfs_read_profile5_settings
+		.read = pyra_sysfs_read_profilex_settings,
+		.private = &profile_numbers[4]
 };
 
 static struct bin_attribute pyra_profile_buttons_attr = {
@@ -561,31 +488,36 @@ static struct bin_attribute pyra_profile_buttons_attr = {
 static struct bin_attribute pyra_profile1_buttons_attr = {
 		.attr = { .name = "profile1_buttons", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_buttons),
-		.read = pyra_sysfs_read_profile1_buttons
+		.read = pyra_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[0]
 };
 
 static struct bin_attribute pyra_profile2_buttons_attr = {
 		.attr = { .name = "profile2_buttons", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_buttons),
-		.read = pyra_sysfs_read_profile2_buttons
+		.read = pyra_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[1]
 };
 
 static struct bin_attribute pyra_profile3_buttons_attr = {
 		.attr = { .name = "profile3_buttons", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_buttons),
-		.read = pyra_sysfs_read_profile3_buttons
+		.read = pyra_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[2]
 };
 
 static struct bin_attribute pyra_profile4_buttons_attr = {
 		.attr = { .name = "profile4_buttons", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_buttons),
-		.read = pyra_sysfs_read_profile4_buttons
+		.read = pyra_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[3]
 };
 
 static struct bin_attribute pyra_profile5_buttons_attr = {
 		.attr = { .name = "profile5_buttons", .mode = 0440 },
 		.size = sizeof(struct pyra_profile_buttons),
-		.read = pyra_sysfs_read_profile5_buttons
+		.read = pyra_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[4]
 };
 
 static struct bin_attribute pyra_settings_attr = {
-- 
1.7.2.3



