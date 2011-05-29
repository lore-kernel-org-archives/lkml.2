Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1E2RdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 13:33:10 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:40113 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844Ab1E2RdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 13:33:05 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-12.arcor-online.net 51664267B7
Subject: [PATCH] HID: roccat: Add "Roccat Talk" support for koneplus
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Sylvestre Ledru <sylvestre.ledru@scilab.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 May 2011 19:32:57 +0200
Message-ID: <1306690377.2266.11.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added binary sysfs attribute to support new functionality the manufacturer
added to koneplus.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 .../ABI/testing/sysfs-driver-hid-roccat-koneplus   |    8 ++++++++
 drivers/hid/hid-roccat-koneplus.c                  |   13 +++++++++++++
 drivers/hid/hid-roccat-koneplus.h                  |    9 +++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
index c1b53b8..65e6e5d 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
+++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-koneplus
@@ -92,6 +92,14 @@ Description:	The mouse has a tracking- and a distance-control-unit. These
 		This file is writeonly.
 Users:		http://roccat.sourceforge.net
 
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/talk
+Date:		May 2011
+Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
+Description:	Used to active some easy* functions of the mouse from outside.
+		The data has to be 16 bytes long.
+		This file is writeonly.
+Users:		http://roccat.sourceforge.net
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/koneplus/roccatkoneplus<minor>/tcu
 Date:		October 2010
 Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 5b640a7..23cdb44 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -240,6 +240,14 @@ static ssize_t koneplus_sysfs_write(struct file *fp, struct kobject *kobj,
 	return real_size;
 }
 
+static ssize_t koneplus_sysfs_write_talk(struct file *fp,
+		struct kobject *kobj, struct bin_attribute *attr, char *buf,
+		loff_t off, size_t count)
+{
+	return koneplus_sysfs_write(fp, kobj, buf, off, count,
+			sizeof(struct koneplus_talk), KONEPLUS_USB_COMMAND_TALK);
+}
+
 static ssize_t koneplus_sysfs_write_macro(struct file *fp,
 		struct kobject *kobj, struct bin_attribute *attr, char *buf,
 		loff_t off, size_t count)
@@ -557,6 +565,11 @@ static struct bin_attribute koneplus_bin_attributes[] = {
 		.size = sizeof(struct koneplus_macro),
 		.write = koneplus_sysfs_write_macro
 	},
+	{
+		.attr = { .name = "talk", .mode = 0220 },
+		.size = sizeof(struct koneplus_talk),
+		.write = koneplus_sysfs_write_talk
+	},
 	__ATTR_NULL
 };
 
diff --git a/drivers/hid/hid-roccat-koneplus.h b/drivers/hid/hid-roccat-koneplus.h
index c57a376..0bf2520 100644
--- a/drivers/hid/hid-roccat-koneplus.h
+++ b/drivers/hid/hid-roccat-koneplus.h
@@ -14,6 +14,12 @@
 
 #include <linux/types.h>
 
+struct koneplus_talk {
+	uint8_t command; /* KONEPLUS_COMMAND_TALK */
+	uint8_t size; /* always 0x10 */
+	uint8_t data[14];
+} __packed;
+
 /*
  * case 1: writes request 80 and reads value 1
  *
@@ -139,6 +145,7 @@ enum koneplus_commands {
 	KONEPLUS_COMMAND_INFO = 0x9,
 	KONEPLUS_COMMAND_E = 0xe,
 	KONEPLUS_COMMAND_SENSOR = 0xf,
+	KONEPLUS_COMMAND_TALK = 0x10,
 	KONEPLUS_COMMAND_FIRMWARE_WRITE = 0x1b,
 	KONEPLUS_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
 };
@@ -153,6 +160,7 @@ enum koneplus_usb_commands {
 	KONEPLUS_USB_COMMAND_TCU = 0x30c,
 	KONEPLUS_USB_COMMAND_E = 0x30e,
 	KONEPLUS_USB_COMMAND_SENSOR = 0x30f,
+	KONEPLUS_USB_COMMAND_TALK = 0x310,
 	KONEPLUS_USB_COMMAND_FIRMWARE_WRITE = 0x31b,
 	KONEPLUS_USB_COMMAND_FIRMWARE_WRITE_CONTROL = 0x31c,
 };
@@ -193,6 +201,7 @@ enum koneplus_mouse_report_button_types {
 	 * data2 = action
 	 */
 	KONEPLUS_MOUSE_REPORT_BUTTON_TYPE_MULTIMEDIA = 0xf0,
+	KONEPLUS_MOUSE_REPORT_TALK = 0xff,
 };
 
 enum koneplus_mouse_report_button_action {
-- 
1.7.3.4



