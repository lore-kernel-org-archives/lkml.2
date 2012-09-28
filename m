Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031045Ab2I1TT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:19:27 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971Ab2I1TEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ping Cheng <pingc@wacom.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [ 215/262] Input: wacom - add support to Cintiq 22HD
Date: Fri, 28 Sep 2012 11:52:24 -0700
Message-Id: <20120928183023.491484069@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping Cheng <pinglinux@gmail.com>

commit d838c644fea603eb24811333c6e2cf4f9722bf10 upstream.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/tablet/wacom_wac.c |   21 +++++++++++++++++++--
 drivers/input/tablet/wacom_wac.h |    3 ++-
 2 files changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -464,7 +464,7 @@ static void wacom_intuos_general(struct
 		t = (data[6] << 2) | ((data[7] >> 6) & 3);
 		if ((features->type >= INTUOS4S && features->type <= INTUOS4L) ||
                     (features->type >= INTUOS5S && features->type <= INTUOS5L) ||
-		    features->type == WACOM_21UX2 || features->type == WACOM_24HD) {
+		    (features->type >= WACOM_21UX2 && features->type <= WACOM_24HD)) {
 			t = (t << 1) | (data[1] & 1);
 		}
 		input_report_abs(input, ABS_PRESSURE, t);
@@ -614,7 +614,7 @@ static int wacom_intuos_irq(struct wacom
 				input_report_abs(input, ABS_MISC, 0);
 			}
 		} else {
-			if (features->type == WACOM_21UX2) {
+			if (features->type == WACOM_21UX2 || features->type == WACOM_22HD) {
 				input_report_key(input, BTN_0, (data[5] & 0x01));
 				input_report_key(input, BTN_1, (data[6] & 0x01));
 				input_report_key(input, BTN_2, (data[6] & 0x02));
@@ -633,6 +633,12 @@ static int wacom_intuos_irq(struct wacom
 				input_report_key(input, BTN_Z, (data[8] & 0x20));
 				input_report_key(input, BTN_BASE, (data[8] & 0x40));
 				input_report_key(input, BTN_BASE2, (data[8] & 0x80));
+
+				if (features->type == WACOM_22HD) {
+					input_report_key(input, KEY_PROG1, data[9] & 0x01);
+					input_report_key(input, KEY_PROG2, data[9] & 0x02);
+					input_report_key(input, KEY_PROG3, data[9] & 0x04);
+				}
 			} else {
 				input_report_key(input, BTN_0, (data[5] & 0x01));
 				input_report_key(input, BTN_1, (data[5] & 0x02));
@@ -1230,6 +1236,7 @@ void wacom_wac_irq(struct wacom_wac *wac
 	case CINTIQ:
 	case WACOM_BEE:
 	case WACOM_21UX2:
+	case WACOM_22HD:
 	case WACOM_24HD:
 		sync = wacom_intuos_irq(wacom_wac);
 		break;
@@ -1432,6 +1439,12 @@ int wacom_setup_input_capabilities(struc
 		wacom_setup_cintiq(wacom_wac);
 		break;
 
+	case WACOM_22HD:
+		__set_bit(KEY_PROG1, input_dev->keybit);
+		__set_bit(KEY_PROG2, input_dev->keybit);
+		__set_bit(KEY_PROG3, input_dev->keybit);
+		/* fall through */
+
 	case WACOM_21UX2:
 		__set_bit(BTN_A, input_dev->keybit);
 		__set_bit(BTN_B, input_dev->keybit);
@@ -1855,6 +1868,9 @@ static const struct wacom_features wacom
 static const struct wacom_features wacom_features_0xCC =
 	{ "Wacom Cintiq 21UX2",   WACOM_PKGLEN_INTUOS,    87200, 65600, 2047,
 	  63, WACOM_21UX2, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
+static const struct wacom_features wacom_features_0xFA =
+	{ "Wacom Cintiq 22HD",    WACOM_PKGLEN_INTUOS,    95840, 54260, 2047,
+	  63, WACOM_22HD, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
 static const struct wacom_features wacom_features_0x90 =
 	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,
 	  0, TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -2064,6 +2080,7 @@ const struct usb_device_id wacom_ids[] =
 	{ USB_DEVICE_WACOM(0xEC) },
 	{ USB_DEVICE_WACOM(0x47) },
 	{ USB_DEVICE_WACOM(0xF4) },
+	{ USB_DEVICE_WACOM(0xFA) },
 	{ USB_DEVICE_LENOVO(0x6004) },
 	{ }
 };
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -74,8 +74,9 @@ enum {
 	INTUOS5S,
 	INTUOS5,
 	INTUOS5L,
-	WACOM_24HD,
 	WACOM_21UX2,
+	WACOM_22HD,
+	WACOM_24HD,
 	CINTIQ,
 	WACOM_BEE,
 	WACOM_MO,


