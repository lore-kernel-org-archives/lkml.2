Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1JQBVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:21:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49821 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab1JQBUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:20:52 -0400
From: chris@cnpbagwell.com
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        pinglinux@gmail.com
Cc: Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH 6/6] Input: wacom - 3rd gen Bamboo P&Touch packet support
Date: Sun, 16 Oct 2011 20:20:30 -0500
Message-Id: <1318814430-30316-7-git-send-email-chris@cnpbagwell.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
References: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Bagwell <chris@cnpbagwell.com>

3rd generation Bamboo Pen and Touch tablets reuse the older
stylus packet but add an extra fixed zero pad byte to end.

The touch packets are quite different since it supports tracking
of up to 16 touches. The packet is 64-byte fixed size but contains
up to 15 smaller messages indicating data for a single touch or
for tablet button presses.

Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
---
 drivers/input/tablet/wacom_wac.c |   94 ++++++++++++++++++++++++++++++++++++--
 drivers/input/tablet/wacom_wac.h |    4 +-
 2 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index d1ced32..d142023 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -836,6 +836,64 @@ static int wacom_bpt_touch(struct wacom_wac *wacom)
 	return 0;
 }
 
+static void wacom_bpt3_touch_msg(struct wacom_wac *wacom, unsigned char *data)
+{
+	struct input_dev *input = wacom->input;
+	int slot_id = data[0] - 2;
+	bool touch = data[1] & 0x80;
+
+	touch = touch && !wacom->shared->stylus_in_proximity;
+
+	input_mt_slot(input, slot_id);
+	input_mt_report_slot_state(input, MT_TOOL_FINGER, touch);
+
+	if (touch) {
+	    int x = (data[2] << 4) | (data[4] >> 4);
+	    int y = (data[3] << 4) | (data[4] & 0x0f);
+	    int w = data[6];
+
+	    input_report_abs(input, ABS_MT_POSITION_X, x);
+	    input_report_abs(input, ABS_MT_POSITION_Y, y);
+	    input_report_abs(input, ABS_MT_TOUCH_MAJOR, w);
+	}
+}
+
+static void wacom_bpt3_button_msg(struct wacom_wac *wacom, unsigned char *data)
+{
+	struct input_dev *input = wacom->input;
+
+	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
+	input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
+	input_report_key(input, BTN_BACK, (data[1] & 0x02) != 0);
+	input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
+}
+
+static int wacom_bpt3_touch(struct wacom_wac *wacom)
+{
+	struct input_dev *input = wacom->input;
+	unsigned char *data = wacom->data;
+	int count = data[1] & 0x03;
+	int i;
+
+	/* data has up to 7 fixed sized 8-byte messages starting at data[2] */
+	for (i = 0; i < count && i < 8; i++) {
+		int offset = (8 * i)+2;
+		int msg_id = data[offset];
+
+		if (msg_id >= 2 && msg_id <= 17)
+		    wacom_bpt3_touch_msg(wacom, data+offset);
+		else if (msg_id == 128)
+		    wacom_bpt3_button_msg(wacom, data+offset);
+
+	}
+
+	input_mt_report_pointer_emulation(input, true);
+
+	input_sync(input);
+
+	return 0;
+}
+
 static int wacom_bpt_pen(struct wacom_wac *wacom)
 {
 	struct input_dev *input = wacom->input;
@@ -906,7 +964,9 @@ static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
 {
 	if (len == WACOM_PKGLEN_BBTOUCH)
 		return wacom_bpt_touch(wacom);
-	else if (len == WACOM_PKGLEN_BBFUN)
+	else if (len == WACOM_PKGLEN_BBTOUCH3)
+		return wacom_bpt3_touch(wacom);
+	else if (len == WACOM_PKGLEN_BBFUN || len == WACOM_PKGLEN_BBPEN)
 		return wacom_bpt_pen(wacom);
 
 	return 0;
@@ -1025,9 +1085,9 @@ void wacom_setup_device_quirks(struct wacom_features *features)
 	    features->type == BAMBOO_PT)
 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
 
-	/* quirks for bamboo touch */
+	/* quirk for bamboo touch with 2 low res touches */
 	if (features->type == BAMBOO_PT &&
-	    features->device_type == BTN_TOOL_DOUBLETAP) {
+	    features->pktlen == WACOM_PKGLEN_BBTOUCH) {
 		features->x_max <<= 5;
 		features->y_max <<= 5;
 		features->x_fuzz <<= 5;
@@ -1213,7 +1273,21 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 			__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
 			__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
 
-			input_mt_init_slots(input_dev, 2);
+			if (features->pktlen == WACOM_PKGLEN_BBTOUCH3) {
+				__set_bit(BTN_TOOL_TRIPLETAP,
+					  input_dev->keybit);
+				__set_bit(BTN_TOOL_QUADTAP,
+					  input_dev->keybit);
+
+				input_mt_init_slots(input_dev, 16);
+
+				input_set_abs_params(input_dev,
+						     ABS_MT_TOUCH_MAJOR,
+						     0, 255, 0, 0);
+			} else {
+				input_mt_init_slots(input_dev, 2);
+			}
+
 			input_set_abs_params(input_dev, ABS_MT_POSITION_X,
 					     0, features->x_max,
 					     features->x_fuzz, 0);
@@ -1479,6 +1553,15 @@ static const struct wacom_features wacom_features_0xDA =
 static struct wacom_features wacom_features_0xDB =
 	{ "Wacom Bamboo 2FG 6x8 SE", WACOM_PKGLEN_BBFUN,  21648, 13700, 1023,
 	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+static const struct wacom_features wacom_features_0xDD =
+        { "Wacom Bamboo Connect", WACOM_PKGLEN_BBPEN,     14720,  9200, 1023,
+          31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+static const struct wacom_features wacom_features_0xDE =
+        { "Wacom Bamboo 16FG 4x5", WACOM_PKGLEN_BBPEN,    14720,  9200, 1023,
+          31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+static const struct wacom_features wacom_features_0xDF =
+        { "Wacom Bamboo 16FG 6x8", WACOM_PKGLEN_BBPEN,    21648, 13700, 1023,
+          31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
 static const struct wacom_features wacom_features_0x6004 =
 	{ "ISD-V4",               WACOM_PKGLEN_GRAPHIRE,  12800,  8000,  255,
 	  0, TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -1574,6 +1657,9 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xD8) },
 	{ USB_DEVICE_WACOM(0xDA) },
 	{ USB_DEVICE_WACOM(0xDB) },
+	{ USB_DEVICE_WACOM(0xDD) },
+	{ USB_DEVICE_WACOM(0xDE) },
+	{ USB_DEVICE_WACOM(0xDF) },
 	{ USB_DEVICE_WACOM(0xF0) },
 	{ USB_DEVICE_WACOM(0xCC) },
 	{ USB_DEVICE_WACOM(0x90) },
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 53eb71b..d54ffcb 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -12,7 +12,7 @@
 #include <linux/types.h>
 
 /* maximum packet length for USB devices */
-#define WACOM_PKGLEN_MAX	32
+#define WACOM_PKGLEN_MAX	64
 
 /* packet length for individual models */
 #define WACOM_PKGLEN_PENPRTN	 7
@@ -22,6 +22,8 @@
 #define WACOM_PKGLEN_TPC1FG	 5
 #define WACOM_PKGLEN_TPC2FG	14
 #define WACOM_PKGLEN_BBTOUCH	20
+#define WACOM_PKGLEN_BBPEN	10
+#define WACOM_PKGLEN_BBTOUCH3	64
 
 /* device IDs */
 #define STYLUS_DEVICE_ID	0x02
-- 
1.7.6.4

