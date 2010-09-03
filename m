Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab0ICMSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:18:21 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:55115 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757939Ab0ICMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:18:16 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/5] input: wacom: Add support for the Bamboo Touch trackpad (rev3)
Date: Fri,  3 Sep 2010 14:17:25 +0200
Message-Id: <1283516247-11624-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OrVDT-0003nh-47.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OrVDT-0003nh-47 844809ca10adc0a9a40f88502cdcdbbf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the Bamboo Touch trackpad, and make it work well with
both the Synaptics X Driver and the Multitouch X Driver. The device
uses MT slots internally, so the choice of protocol is a given.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/tablet/wacom_wac.c |   82 ++++++++++++++++++++++++++++++++++++++
 drivers/input/tablet/wacom_wac.h |    3 +
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index bfe5654..a980306 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -855,6 +855,54 @@ static int wacom_tpc_irq(struct wacom_wac *wacom, size_t len)
 	return retval;
 }
 
+static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
+{
+	static int trkid;
+	struct input_dev *input = wacom->input;
+	unsigned char *data = wacom->data;
+	int sp = 0, sx = 0, sy = 0, count = 0;
+	int i;
+
+	if (len != WACOM_PKGLEN_BBTOUCH)
+		return 0;
+
+	for (i = 0; i < 2; i++) {
+		int p = data[9 * i + 2];
+		input_mt_slot(input, i);
+		if (p) {
+			int x = get_unaligned_be16(&data[9 * i + 3]) & 0x7ff;
+			int y = get_unaligned_be16(&data[9 * i + 5]) & 0x7ff;
+			input_report_abs(input, ABS_MT_PRESSURE, p);
+			input_report_abs(input, ABS_MT_POSITION_X, x);
+			input_report_abs(input, ABS_MT_POSITION_Y, y);
+			if (wacom->id[i] < 0)
+				wacom->id[i] = trkid++ & MAX_TRACKING_ID;
+			if (!count++)
+				sp = p, sx = x, sy = y;
+		} else {
+			wacom->id[i] = -1;
+		}
+		input_report_abs(input, ABS_MT_TRACKING_ID, wacom->id[i]);
+	}
+
+	input_report_key(input, BTN_TOUCH, count > 0);
+	input_report_key(input, BTN_TOOL_FINGER, count == 1);
+	input_report_key(input, BTN_TOOL_DOUBLETAP, count == 2);
+
+	input_report_abs(input, ABS_PRESSURE, sp);
+	input_report_abs(input, ABS_X, sx);
+	input_report_abs(input, ABS_Y, sy);
+
+	input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
+	input_report_key(input, BTN_MIDDLE, (data[1] & 0x04) != 0);
+	input_report_key(input, BTN_4, (data[1] & 0x02) != 0);
+	input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
+
+	input_sync(input);
+
+	return 0;
+}
+
 void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
 {
 	bool sync;
@@ -900,6 +948,10 @@ void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
 		sync = wacom_tpc_irq(wacom_wac, len);
 		break;
 
+	case BAMBOO_PT:
+		sync = wacom_bpt_irq(wacom_wac, len);
+		break;
+
 	default:
 		sync = false;
 		break;
@@ -1079,6 +1131,33 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 	case PENPARTNER:
 		__set_bit(BTN_TOOL_RUBBER, input_dev->keybit);
 		break;
+
+	case BAMBOO_PT:
+		__clear_bit(ABS_MISC, input_dev->absbit);
+
+		if (features->device_type == BTN_TOOL_TRIPLETAP) {
+			__set_bit(BTN_LEFT, input_dev->keybit);
+			__set_bit(BTN_MIDDLE, input_dev->keybit);
+			__set_bit(BTN_RIGHT, input_dev->keybit);
+			__set_bit(BTN_4, input_dev->keybit);
+
+			__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+			__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
+
+			input_mt_create_slots(input_dev, 2);
+			input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+					     0, features->x_max,
+					     features->x_fuzz, 0);
+			input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+					     0, features->y_max,
+					     features->y_fuzz, 0);
+			input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+					     0, features->pressure_max,
+					     features->pressure_fuzz, 0);
+			input_set_abs_params(input_dev, ABS_MT_TRACKING_ID, 0,
+					     MAX_TRACKING_ID, 0, 0);
+		}
+		break;
 	}
 }
 
@@ -1216,6 +1295,8 @@ static const struct wacom_features wacom_features_0xE3 =
 	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,  0, TABLETPC2FG };
 static const struct wacom_features wacom_features_0x47 =
 	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023, 31, INTUOS };
+static struct wacom_features wacom_features_0xD0 =
+	{ "Wacom Bamboo 2FG",     WACOM_PKGLEN_BBFUN,     14720,  9200, 1023, 63, BAMBOO_PT };
 
 #define USB_DEVICE_WACOM(prod)					\
 	USB_DEVICE(USB_VENDOR_ID_WACOM, prod),			\
@@ -1280,6 +1361,7 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xC6) },
 	{ USB_DEVICE_WACOM(0xC7) },
 	{ USB_DEVICE_WACOM(0xCE) },
+	{ USB_DEVICE_WACOM(0xD0) },
 	{ USB_DEVICE_WACOM(0xF0) },
 	{ USB_DEVICE_WACOM(0xCC) },
 	{ USB_DEVICE_WACOM(0x90) },
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index fb30895..7717285 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -38,6 +38,9 @@
 #define WACOM_REPORT_TPC1FG		6
 #define WACOM_REPORT_TPC2FG		13
 
+/* largest reported tracking id */
+#define MAX_TRACKING_ID			0xfff
+
 enum {
 	PENPARTNER = 0,
 	GRAPHIRE,
-- 
1.7.1

