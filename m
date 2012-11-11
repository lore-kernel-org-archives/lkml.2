Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2KKFVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 00:21:07 -0500
Received: from mout.web.de ([212.227.17.11]:56343 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2KKFVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 00:21:04 -0500
Subject: [PATCH 3/7] HID: roccat: Cleaned up isku driver
From: Stefan Achatz <stefan_achatz@web.de>
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Nov 2012 06:21:02 +0100
Message-ID: <1352611262.2463.223.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:q+31X12yD347XfrxdD6RILAK1GIib42EeSZSL4vXsdX
 KAzra0uLWtLpWo8fOx/uF+b7dKQUzdoZIAci6EMIxV2XdqjMb2
 nwrDLuCUw2M/cfjdVCd8mTE/GcTpSUp+pA/UX9fmW9FZZXKL0y
 f/Hfr2Sb5SITrupNx9j+v1QK/nFWnqXrEyEcDY/TA4vOYu40Ue
 R+lmdgBuVxTO3C/+f5k4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unneeded structures from header.
Using enums instead of sizeof(struct) to unify drivers.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-isku.c |   42 +++++++++++-----------
 drivers/hid/hid-roccat-isku.h |   76 +++++++++--------------------------------
 2 files changed, 37 insertions(+), 81 deletions(-)

diff --git a/drivers/hid/hid-roccat-isku.c b/drivers/hid/hid-roccat-isku.c
index 5669916..020d6cd 100644
--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -167,7 +167,7 @@ static ssize_t isku_sysfs_write_ ## thingy(struct file *fp, struct kobject *kobj
 		loff_t off, size_t count) \
 { \
 	return isku_sysfs_write(fp, kobj, buf, off, count, \
-			sizeof(struct isku_ ## thingy), ISKU_COMMAND_ ## THINGY); \
+			ISKU_SIZE_ ## THINGY, ISKU_COMMAND_ ## THINGY); \
 }
 
 #define ISKU_SYSFS_R(thingy, THINGY) \
@@ -176,32 +176,32 @@ static ssize_t isku_sysfs_read_ ## thingy(struct file *fp, struct kobject *kobj,
 		loff_t off, size_t count) \
 { \
 	return isku_sysfs_read(fp, kobj, buf, off, count, \
-			sizeof(struct isku_ ## thingy), ISKU_COMMAND_ ## THINGY); \
+			ISKU_SIZE_ ## THINGY, ISKU_COMMAND_ ## THINGY); \
 }
 
 #define ISKU_SYSFS_RW(thingy, THINGY) \
 ISKU_SYSFS_R(thingy, THINGY) \
 ISKU_SYSFS_W(thingy, THINGY)
 
-#define ISKU_BIN_ATTR_RW(thingy) \
+#define ISKU_BIN_ATTR_RW(thingy, THINGY) \
 { \
 	.attr = { .name = #thingy, .mode = 0660 }, \
-	.size = sizeof(struct isku_ ## thingy), \
+	.size = ISKU_SIZE_ ## THINGY, \
 	.read = isku_sysfs_read_ ## thingy, \
 	.write = isku_sysfs_write_ ## thingy \
 }
 
-#define ISKU_BIN_ATTR_R(thingy) \
+#define ISKU_BIN_ATTR_R(thingy, THINGY) \
 { \
 	.attr = { .name = #thingy, .mode = 0440 }, \
-	.size = sizeof(struct isku_ ## thingy), \
+	.size = ISKU_SIZE_ ## THINGY, \
 	.read = isku_sysfs_read_ ## thingy, \
 }
 
-#define ISKU_BIN_ATTR_W(thingy) \
+#define ISKU_BIN_ATTR_W(thingy, THINGY) \
 { \
 	.attr = { .name = #thingy, .mode = 0220 }, \
-	.size = sizeof(struct isku_ ## thingy), \
+	.size = ISKU_SIZE_ ## THINGY, \
 	.write = isku_sysfs_write_ ## thingy \
 }
 
@@ -220,19 +220,19 @@ ISKU_SYSFS_R(info, INFO)
 ISKU_SYSFS_W(control, CONTROL)
 
 static struct bin_attribute isku_bin_attributes[] = {
-	ISKU_BIN_ATTR_RW(macro),
-	ISKU_BIN_ATTR_RW(keys_function),
-	ISKU_BIN_ATTR_RW(keys_easyzone),
-	ISKU_BIN_ATTR_RW(keys_media),
-	ISKU_BIN_ATTR_RW(keys_thumbster),
-	ISKU_BIN_ATTR_RW(keys_macro),
-	ISKU_BIN_ATTR_RW(keys_capslock),
-	ISKU_BIN_ATTR_RW(light),
-	ISKU_BIN_ATTR_RW(key_mask),
-	ISKU_BIN_ATTR_RW(last_set),
-	ISKU_BIN_ATTR_W(talk),
-	ISKU_BIN_ATTR_R(info),
-	ISKU_BIN_ATTR_W(control),
+	ISKU_BIN_ATTR_RW(macro, MACRO),
+	ISKU_BIN_ATTR_RW(keys_function, KEYS_FUNCTION),
+	ISKU_BIN_ATTR_RW(keys_easyzone, KEYS_EASYZONE),
+	ISKU_BIN_ATTR_RW(keys_media, KEYS_MEDIA),
+	ISKU_BIN_ATTR_RW(keys_thumbster, KEYS_THUMBSTER),
+	ISKU_BIN_ATTR_RW(keys_macro, KEYS_MACRO),
+	ISKU_BIN_ATTR_RW(keys_capslock, KEYS_CAPSLOCK),
+	ISKU_BIN_ATTR_RW(light, LIGHT),
+	ISKU_BIN_ATTR_RW(key_mask, KEY_MASK),
+	ISKU_BIN_ATTR_RW(last_set, LAST_SET),
+	ISKU_BIN_ATTR_W(talk, TALK),
+	ISKU_BIN_ATTR_R(info, INFO),
+	ISKU_BIN_ATTR_W(control, CONTROL),
 	__ATTR_NULL
 };
 
diff --git a/drivers/hid/hid-roccat-isku.h b/drivers/hid/hid-roccat-isku.h
index 605b3ce..0062ab5 100644
--- a/drivers/hid/hid-roccat-isku.h
+++ b/drivers/hid/hid-roccat-isku.h
@@ -15,76 +15,32 @@
 #include <linux/types.h>
 
 enum {
+	ISKU_SIZE_CONTROL = 0x03,
+	ISKU_SIZE_INFO = 0x06,
+	ISKU_SIZE_KEY_MASK = 0x06,
+	ISKU_SIZE_KEYS_FUNCTION = 0x29,
+	ISKU_SIZE_KEYS_EASYZONE = 0x41,
+	ISKU_SIZE_KEYS_MEDIA = 0x1d,
+	ISKU_SIZE_KEYS_THUMBSTER = 0x17,
+	ISKU_SIZE_KEYS_MACRO = 0x23,
+	ISKU_SIZE_KEYS_CAPSLOCK = 0x06,
+	ISKU_SIZE_LAST_SET = 0x14,
+	ISKU_SIZE_LIGHT = 0x0a,
+	ISKU_SIZE_MACRO = 0x823,
+	ISKU_SIZE_TALK = 0x10,
+};
+
+enum {
 	ISKU_PROFILE_NUM = 5,
 	ISKU_USB_INTERFACE_PROTOCOL = 0,
 };
 
-struct isku_control {
-	uint8_t command; /* ISKU_COMMAND_CONTROL */
-	uint8_t value;
-	uint8_t request;
-} __packed;
-
 struct isku_actual_profile {
 	uint8_t command; /* ISKU_COMMAND_ACTUAL_PROFILE */
 	uint8_t size; /* always 3 */
 	uint8_t actual_profile;
 } __packed;
 
-struct isku_key_mask {
-	uint8_t command; /* ISKU_COMMAND_KEY_MASK */
-	uint8_t size; /* 6 */
-	uint8_t profile_number; /* 0-4 */
-	uint8_t mask;
-	uint16_t checksum;
-} __packed;
-
-struct isku_keys_function {
-	uint8_t data[0x29];
-} __packed;
-
-struct isku_keys_easyzone {
-	uint8_t data[0x41];
-} __packed;
-
-struct isku_keys_media {
-	uint8_t data[0x1d];
-} __packed;
-
-struct isku_keys_thumbster {
-	uint8_t data[0x17];
-} __packed;
-
-struct isku_keys_macro {
-	uint8_t data[0x23];
-} __packed;
-
-struct isku_keys_capslock {
-	uint8_t data[0x6];
-} __packed;
-
-struct isku_macro {
-	uint8_t data[0x823];
-} __packed;
-
-struct isku_light {
-	uint8_t data[0xa];
-} __packed;
-
-struct isku_info {
-	uint8_t data[2];
-	uint8_t firmware_version;
-	uint8_t unknown[3];
-} __packed;
-
-struct isku_talk {
-	uint8_t data[0x10];
-} __packed;
-
-struct isku_last_set {
-	uint8_t data[0x14];
-} __packed;
-
 enum isku_commands {
 	ISKU_COMMAND_CONTROL = 0x4,
 	ISKU_COMMAND_ACTUAL_PROFILE = 0x5,
-- 
1.7.3.4



