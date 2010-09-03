Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab0ICMSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:18:05 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33812 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab0ICMSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:18:02 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pinglinux@gmail.com>, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 2/5] input: wacom: Parse the Bamboo device family
Date: Fri,  3 Sep 2010 14:17:24 +0200
Message-Id: <1283516247-11624-3-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OrVDO-0005J8-BQ.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OrVDO-0005J8-BQ a504fa3cf9f21785c96b12b65a7bd4ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ping Cheng <pinglinux@gmail.com>

The Bamboo devices have multiple interfaces which need to be setup
separately. Use the HID parsing mechanism to achieve that.

Signed-off-by: Ping Cheng <pinglinux@gmail.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/tablet/wacom_sys.c |   44 ++++++++++++++++++++++++++++++-------
 drivers/input/tablet/wacom_wac.h |    2 +
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index e510e4f..98cba08 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -195,17 +195,30 @@ static int wacom_parse_hid(struct usb_interface *intf, struct hid_descriptor *hi
 							features->pktlen = WACOM_PKGLEN_TPC2FG;
 							features->device_type = BTN_TOOL_TRIPLETAP;
 						}
-						features->x_max =
-							get_unaligned_le16(&report[i + 3]);
-						features->x_phy =
-							get_unaligned_le16(&report[i + 6]);
-						features->unit = report[i + 9];
-						features->unitExpo = report[i + 11];
-						i += 12;
+						if (features->type == BAMBOO_PT) {
+							/* need to reset back */
+							features->pktlen = WACOM_PKGLEN_BBTOUCH;
+							features->device_type = BTN_TOOL_TRIPLETAP;
+							features->x_phy =
+								get_unaligned_le16(&report[i + 5]);
+							features->x_max =
+								get_unaligned_le16(&report[i + 8]);
+							i += 15;
+						} else {
+							features->x_max =
+								get_unaligned_le16(&report[i + 3]);
+							features->x_phy =
+								get_unaligned_le16(&report[i + 6]);
+							features->unit = report[i + 9];
+							features->unitExpo = report[i + 11];
+							i += 12;
+						}
 					} else if (pen) {
 						/* penabled only accepts exact bytes of data */
 						if (features->type == TABLETPC2FG)
 							features->pktlen = WACOM_PKGLEN_GRAPHIRE;
+						if (features->type == BAMBOO_PT)
+							features->pktlen = WACOM_PKGLEN_BBFUN;
 						features->device_type = BTN_TOOL_PEN;
 						features->x_max =
 							get_unaligned_le16(&report[i + 3]);
@@ -234,6 +247,15 @@ static int wacom_parse_hid(struct usb_interface *intf, struct hid_descriptor *hi
 							features->y_phy =
 								get_unaligned_le16(&report[i + 6]);
 							i += 7;
+						} else if (features->type == BAMBOO_PT) {
+							/* need to reset back */
+							features->pktlen = WACOM_PKGLEN_BBTOUCH;
+							features->device_type = BTN_TOOL_TRIPLETAP;
+							features->y_phy =
+								get_unaligned_le16(&report[i + 3]);
+							features->y_max =
+								get_unaligned_le16(&report[i + 6]);
+							i += 12;
 						} else {
 							features->y_max =
 								features->x_max;
@@ -245,6 +267,8 @@ static int wacom_parse_hid(struct usb_interface *intf, struct hid_descriptor *hi
 						/* penabled only accepts exact bytes of data */
 						if (features->type == TABLETPC2FG)
 							features->pktlen = WACOM_PKGLEN_GRAPHIRE;
+						if (features->type == BAMBOO_PT)
+							features->pktlen = WACOM_PKGLEN_BBFUN;
 						features->device_type = BTN_TOOL_PEN;
 						features->y_max =
 							get_unaligned_le16(&report[i + 3]);
@@ -341,7 +365,8 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	features->distance_fuzz = 0;
 
 	/* only Tablet PCs need to retrieve the info */
-	if ((features->type != TABLETPC) && (features->type != TABLETPC2FG))
+	if ((features->type != TABLETPC) && (features->type != TABLETPC2FG) &&
+	    (features->type != BAMBOO_PT))
 		goto out;
 
 	if (usb_get_extra_descriptor(interface, HID_DEVICET_HID, &hid_desc)) {
@@ -499,7 +524,8 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	strlcpy(wacom_wac->name, features->name, sizeof(wacom_wac->name));
 
-	if (features->type == TABLETPC || features->type == TABLETPC2FG) {
+	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
+	    features->type == BAMBOO_PT) {
 		/* Append the device type to the name */
 		strlcat(wacom_wac->name,
 			features->device_type == BTN_TOOL_PEN ?
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index d769e9a..fb30895 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -21,6 +21,7 @@
 #define WACOM_PKGLEN_INTUOS	10
 #define WACOM_PKGLEN_TPC1FG	 5
 #define WACOM_PKGLEN_TPC2FG	14
+#define WACOM_PKGLEN_BBTOUCH	20
 
 /* device IDs */
 #define STYLUS_DEVICE_ID	0x02
@@ -44,6 +45,7 @@ enum {
 	PTU,
 	PL,
 	DTU,
+	BAMBOO_PT,
 	INTUOS,
 	INTUOS3S,
 	INTUOS3,
-- 
1.7.1

