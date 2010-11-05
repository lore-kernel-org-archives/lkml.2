Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab0KERyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:54:09 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:58428 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab0KERyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:54:06 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-14.arcor-online.net 911479CCAC
Subject: [PATCH] HID: roccat: Using bin-attribute->private to reduce code
 duplication
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>,
        Dmitry Torokhov <dtor@mail.ru>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011041418530.15851@pobox.suse.cz>
References: <1287943025.2623.16.camel@neuromancer>
	 <alpine.LNX.2.00.1011041418530.15851@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 18:53:59 +0100
Message-ID: <1288979639.2585.17.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The profile number is now passed via bin-attribute->private instead
of function parameter to reduce number of functions.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-koneplus.c |  120 ++++++++-----------------------------
 1 files changed, 26 insertions(+), 94 deletions(-)

diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 780acb4..7327e1a 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -26,6 +26,8 @@
 #include "hid-roccat.h"
 #include "hid-roccat-koneplus.h"
 
+static uint profile_numbers[5] = {0, 1, 2, 3, 4};
+
 static void koneplus_profile_activated(struct koneplus_device *koneplus,
 		uint new_profile)
 {
@@ -328,7 +330,7 @@ static ssize_t koneplus_sysfs_read_tcu_image(struct file *fp,
 
 static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, uint number)
+		loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
@@ -340,53 +342,13 @@ static ssize_t koneplus_sysfs_read_profilex_settings(struct file *fp,
 		count = sizeof(struct koneplus_profile_settings) - off;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	memcpy(buf, ((void const *)&koneplus->profile_settings[number]) + off,
+	memcpy(buf, ((void const *)&koneplus->profile_settings[*(uint *)(attr->private)]) + off,
 			count);
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	return count;
 }
 
-static ssize_t koneplus_sysfs_read_profile1_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 0);
-}
-
-static ssize_t koneplus_sysfs_read_profile2_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 1);
-}
-
-static ssize_t koneplus_sysfs_read_profile3_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 2);
-}
-
-static ssize_t koneplus_sysfs_read_profile4_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 3);
-}
-
-static ssize_t koneplus_sysfs_read_profile5_settings(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_settings(fp, kobj,
-			attr, buf, off, count, 4);
-}
-
 static ssize_t koneplus_sysfs_write_profile_settings(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -425,7 +387,7 @@ static ssize_t koneplus_sysfs_write_profile_settings(struct file *fp,
 
 static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count, uint number)
+		loff_t off, size_t count)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct koneplus_device *koneplus = hid_get_drvdata(dev_get_drvdata(dev));
@@ -437,53 +399,13 @@ static ssize_t koneplus_sysfs_read_profilex_buttons(struct file *fp,
 		count = sizeof(struct koneplus_profile_buttons) - off;
 
 	mutex_lock(&koneplus->koneplus_lock);
-	memcpy(buf, ((void const *)&koneplus->profile_buttons[number]) + off,
+	memcpy(buf, ((void const *)&koneplus->profile_buttons[*(uint *)(attr->private)]) + off,
 			count);
 	mutex_unlock(&koneplus->koneplus_lock);
 
 	return count;
 }
 
-static ssize_t koneplus_sysfs_read_profile1_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 0);
-}
-
-static ssize_t koneplus_sysfs_read_profile2_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 1);
-}
-
-static ssize_t koneplus_sysfs_read_profile3_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 2);
-}
-
-static ssize_t koneplus_sysfs_read_profile4_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 3);
-}
-
-static ssize_t koneplus_sysfs_read_profile5_buttons(struct file *fp,
-		struct kobject *kobj, struct bin_attribute *attr, char *buf,
-		loff_t off, size_t count)
-{
-	return koneplus_sysfs_read_profilex_buttons(fp, kobj,
-			attr, buf, off, count, 4);
-}
-
 static ssize_t koneplus_sysfs_write_profile_buttons(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -611,31 +533,36 @@ static struct bin_attribute koneplus_profile_settings_attr = {
 static struct bin_attribute koneplus_profile1_settings_attr = {
 		.attr = { .name = "profile1_settings", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_settings),
-		.read = koneplus_sysfs_read_profile1_settings
+		.read = koneplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[0]
 };
 
 static struct bin_attribute koneplus_profile2_settings_attr = {
 		.attr = { .name = "profile2_settings", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_settings),
-		.read = koneplus_sysfs_read_profile2_settings
+		.read = koneplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[1]
 };
 
 static struct bin_attribute koneplus_profile3_settings_attr = {
 		.attr = { .name = "profile3_settings", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_settings),
-		.read = koneplus_sysfs_read_profile3_settings
+		.read = koneplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[2]
 };
 
 static struct bin_attribute koneplus_profile4_settings_attr = {
 		.attr = { .name = "profile4_settings", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_settings),
-		.read = koneplus_sysfs_read_profile4_settings
+		.read = koneplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[3]
 };
 
 static struct bin_attribute koneplus_profile5_settings_attr = {
 		.attr = { .name = "profile5_settings", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_settings),
-		.read = koneplus_sysfs_read_profile5_settings
+		.read = koneplus_sysfs_read_profilex_settings,
+		.private = &profile_numbers[4]
 };
 
 static struct bin_attribute koneplus_profile_buttons_attr = {
@@ -647,31 +574,36 @@ static struct bin_attribute koneplus_profile_buttons_attr = {
 static struct bin_attribute koneplus_profile1_buttons_attr = {
 		.attr = { .name = "profile1_buttons", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_buttons),
-		.read = koneplus_sysfs_read_profile1_buttons
+		.read = koneplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[0]
 };
 
 static struct bin_attribute koneplus_profile2_buttons_attr = {
 		.attr = { .name = "profile2_buttons", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_buttons),
-		.read = koneplus_sysfs_read_profile2_buttons
+		.read = koneplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[1]
 };
 
 static struct bin_attribute koneplus_profile3_buttons_attr = {
 		.attr = { .name = "profile3_buttons", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_buttons),
-		.read = koneplus_sysfs_read_profile3_buttons
+		.read = koneplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[2]
 };
 
 static struct bin_attribute koneplus_profile4_buttons_attr = {
 		.attr = { .name = "profile4_buttons", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_buttons),
-		.read = koneplus_sysfs_read_profile4_buttons
+		.read = koneplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[3]
 };
 
 static struct bin_attribute koneplus_profile5_buttons_attr = {
 		.attr = { .name = "profile5_buttons", .mode = 0440 },
 		.size = sizeof(struct koneplus_profile_buttons),
-		.read = koneplus_sysfs_read_profile5_buttons
+		.read = koneplus_sysfs_read_profilex_buttons,
+		.private = &profile_numbers[4]
 };
 
 static struct bin_attribute koneplus_macro_attr = {
-- 
1.7.2.3



