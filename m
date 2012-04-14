Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2DNH7c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 03:59:32 -0400
Received: from vitalin.sorra.shikadi.net ([173.255.220.46]:56394 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2DNH7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 03:59:30 -0400
X-Greylist: delayed 1287 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2012 03:59:30 EDT
Message-ID: <4F892952.6020409@shikadi.net>
Date: Sat, 14 Apr 2012 17:37:54 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.23) Gecko/20091130 Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
CC: Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH] Input: wacom - add support for the DTI-520 graphics tablet
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the two interfaces provided by the Wacom DTI-520 tablet.  This
allows both the tablet itself as well as the hardware buttons to be seen by the
kernel.

Signed-off-by: Adam Nielsen <a.nielsen@shikadi.net>
---
 drivers/input/tablet/wacom_sys.c |   13 +++++
 drivers/input/tablet/wacom_wac.c |  113 +++++++++++++++++++++++++++++++++++++-
 drivers/input/tablet/wacom_wac.h |    3 +
 3 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 0d26921..5d1e35d 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -459,6 +459,19 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	features->y_fuzz = 4;
 	features->pressure_fuzz = 0;
 	features->distance_fuzz = 0;
+	features->x_phy = 0;
+	features->y_phy = 0;
+
+	/* DTI devices have two interfaces */
+	if (features->type == WACOM_DTI) {
+		if (interface->desc.bInterfaceNumber == 0) {
+			/* digitizer */
+		} else {
+			/* buttons */
+			features->device_type = 0;
+			features->pktlen = WACOM_PKGLEN_DTIBTN;
+		}
+	}
 
 	/*
 	 * The wireless device HID is basic and layout conflicts with
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index cecd35c..f0ada18 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1073,6 +1073,80 @@ static int wacom_wireless_irq(struct wacom_wac *wacom, size_t len)
 	return 0;
 }
 
+static int wacom_dti_pen(struct wacom_wac *wacom)
+{
+	struct wacom_features *features = &wacom->features;
+	char *data = wacom->data;
+	struct input_dev *input = wacom->input;
+	int pressure;
+	bool prox = data[1] & 0x40;
+
+	if (data[0] != WACOM_REPORT_PENABLED) {
+		dbg("wacom_dti_pen: received unknown report #%d", data[0]);
+		return 0;
+	}
+
+	input_report_key(input, wacom->tool[0], prox);
+
+	if (prox) {
+		wacom->tool[0] = BTN_TOOL_PEN;
+		wacom->id[0] = STYLUS_DEVICE_ID;
+	}
+	if (wacom->id[0]) {
+		input_report_key(input, BTN_STYLUS, data[7] & 0x01);
+		input_report_key(input, BTN_STYLUS2, data[7] & 0x02);
+		input_report_abs(input, ABS_X, be16_to_cpup((__be16 *)&data[2]));
+		input_report_abs(input, ABS_Y, be16_to_cpup((__be16 *)&data[4]));
+		pressure = (data[6] << 1) | ((data[7] & 0x80) >> 7);
+		if (pressure < 0)
+			pressure = features->pressure_max + pressure + 1;
+		input_report_abs(input, ABS_PRESSURE, pressure);
+
+		return 1;
+	}
+
+	if (!prox)
+		wacom->id[0] = 0;
+
+	return 0;
+}
+
+static int wacom_dti_pad(struct wacom_wac *wacom)
+{
+	char *data = wacom->data;
+	struct input_dev *input = wacom->input;
+
+	if (data[0] == WACOM_REPORT_DTIBTN) {
+		input_report_key(input, BTN_3, data[1] & 0x01); /* up */
+		input_report_key(input, BTN_4, data[1] & 0x02); /* down */
+		input_report_key(input, BTN_0, data[1] & 0x04); /* L */
+		input_report_key(input, BTN_2, data[1] & 0x08); /* R */
+		input_report_key(input, BTN_1, data[1] & 0x10); /* both Ctrl */
+
+		/* Buttons along the top of the display */
+		input_report_key(input, BTN_7, data[2] & 0x01);
+		input_report_key(input, BTN_5, data[2] & 0x02);
+		input_report_key(input, BTN_6, data[2] & 0x04);
+		input_report_key(input, BTN_8, data[2] & 0x08);
+		input_report_key(input, BTN_9, data[2] & 0x10);
+
+		return 1;
+	}
+
+	dbg("wacom_dti_pad: received unknown report #%d", data[0]);
+	return 0;
+}
+
+static int wacom_dti_irq(struct wacom_wac *wacom, size_t len)
+{
+	if (len == WACOM_PKGLEN_GRAPHIRE)
+		return wacom_dti_pen(wacom);
+	else if (len == WACOM_PKGLEN_DTIBTN)
+		return wacom_dti_pad(wacom);
+
+	return 0;
+}
+
 void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
 {
 	bool sync;
@@ -1127,6 +1201,10 @@ void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
 		sync = wacom_wireless_irq(wacom_wac, len);
 		break;
 
+	case WACOM_DTI:
+		sync = wacom_dti_irq(wacom_wac, len);
+		break;
+
 	default:
 		sync = false;
 		break;
@@ -1241,7 +1319,7 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 		/* penabled devices have fixed resolution for each model */
 		input_abs_set_res(input_dev, ABS_X, features->x_resolution);
 		input_abs_set_res(input_dev, ABS_Y, features->y_resolution);
-	} else {
+	} else if ((features->x_phy > 0) && (features->y_phy > 0)) {
 		input_abs_set_res(input_dev, ABS_X,
 			wacom_calculate_touch_res(features->x_max,
 						features->x_phy));
@@ -1404,6 +1482,35 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 		__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
 		break;
 
+	case WACOM_DTI:
+		__clear_bit(ABS_MISC, input_dev->absbit);
+		switch (features->device_type) {
+		case BTN_TOOL_PEN:
+			__set_bit(BTN_TOOL_PEN, input_dev->keybit);
+			__set_bit(BTN_STYLUS, input_dev->keybit);
+			__set_bit(BTN_STYLUS2, input_dev->keybit);
+
+			__set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
+			break;
+
+		case 0:
+			__set_bit(BTN_0, input_dev->keybit);
+			__set_bit(BTN_1, input_dev->keybit);
+			__set_bit(BTN_2, input_dev->keybit);
+			__set_bit(BTN_3, input_dev->keybit);
+			__set_bit(BTN_4, input_dev->keybit);
+
+			__set_bit(BTN_5, input_dev->keybit);
+			__set_bit(BTN_6, input_dev->keybit);
+			__set_bit(BTN_7, input_dev->keybit);
+			__set_bit(BTN_8, input_dev->keybit);
+			__set_bit(BTN_9, input_dev->keybit);
+
+			__clear_bit(BTN_TOUCH, input_dev->keybit);
+			break;
+		}
+		break;
+
 	case PTU:
 		__set_bit(BTN_STYLUS2, input_dev->keybit);
 		/* fall through */
@@ -1566,6 +1673,9 @@ static const struct wacom_features wacom_features_0x38 =
 static const struct wacom_features wacom_features_0x39 =
 	{ "Wacom DTU710",         WACOM_PKGLEN_GRAPHIRE,  34080, 27660,  511,
 	  0, PL, WACOM_PL_RES, WACOM_PL_RES };
+static const struct wacom_features wacom_features_0x3A =
+	{ "Wacom DTI520UB/L",     WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,
+	  0, WACOM_DTI, WACOM_PL_RES, WACOM_PL_RES };
 static const struct wacom_features wacom_features_0xC4 =
 	{ "Wacom DTF521",         WACOM_PKGLEN_GRAPHIRE,   6282,  4762,  511,
 	  0, PL, WACOM_PL_RES, WACOM_PL_RES };
@@ -1780,6 +1890,7 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x37) },
 	{ USB_DEVICE_WACOM(0x38) },
 	{ USB_DEVICE_WACOM(0x39) },
+	{ USB_DEVICE_WACOM(0x3A) },
 	{ USB_DEVICE_WACOM(0xC4) },
 	{ USB_DEVICE_WACOM(0xC0) },
 	{ USB_DEVICE_WACOM(0xC2) },
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index ba5a334..008aa12 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -15,6 +15,7 @@
 #define WACOM_PKGLEN_MAX	64
 
 /* packet length for individual models */
+#define WACOM_PKGLEN_DTIBTN	 3
 #define WACOM_PKGLEN_PENPRTN	 7
 #define WACOM_PKGLEN_GRAPHIRE	 8
 #define WACOM_PKGLEN_BBFUN	 9
@@ -35,6 +36,7 @@
 
 /* wacom data packet report IDs */
 #define WACOM_REPORT_PENABLED		2
+#define WACOM_REPORT_DTIBTN		4
 #define WACOM_REPORT_INTUOSREAD		5
 #define WACOM_REPORT_INTUOSWRITE	6
 #define WACOM_REPORT_INTUOSPAD		12
@@ -72,6 +74,7 @@ enum {
 	WACOM_MO,
 	TABLETPC,
 	TABLETPC2FG,
+	WACOM_DTI,
 	MAX_TYPE
 };
 
-- 
1.7.10

