Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab0ICMTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:19:09 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52511 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757754Ab0ICMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:19:07 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 4/5] input: wacom: Collect device quirks into single function
Date: Fri,  3 Sep 2010 14:17:26 +0200
Message-Id: <1283516247-11624-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OrVDY-0003xE-3W.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OrVDY-0003xE-3W 3bbc85bc89534370f9a8c267ddf9a2d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect device-specific code into a single function, and use quirks to
flag specific behavior instead.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/tablet/wacom.h     |    1 +
 drivers/input/tablet/wacom_sys.c |   11 +++--------
 drivers/input/tablet/wacom_wac.c |   16 ++++++++++++++++
 drivers/input/tablet/wacom_wac.h |    4 ++++
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 284dfaa..de5adb1 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -118,6 +118,7 @@ struct wacom {
 extern const struct usb_device_id wacom_ids[];
 
 void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len);
+void wacom_setup_device_quirks(struct wacom_features *features);
 void wacom_setup_input_capabilities(struct input_dev *input_dev,
 				    struct wacom_wac *wacom_wac);
 #endif
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 98cba08..fc6fd53 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -381,12 +381,6 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	if (error)
 		goto out;
 
-	/* touch device found but size is not defined. use default */
-	if (features->device_type == BTN_TOOL_DOUBLETAP && !features->x_max) {
-		features->x_max = 1023;
-		features->y_max = 1023;
-	}
-
  out:
 	return error;
 }
@@ -522,10 +516,11 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	if (error)
 		goto fail2;
 
+	wacom_setup_device_quirks(features);
+
 	strlcpy(wacom_wac->name, features->name, sizeof(wacom_wac->name));
 
-	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
-	    features->type == BAMBOO_PT) {
+	if (features->quirks & WACOM_QUIRK_MULTI_INPUT) {
 		/* Append the device type to the name */
 		strlcat(wacom_wac->name,
 			features->device_type == BTN_TOOL_PEN ?
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index a980306..78e5345 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -993,6 +993,22 @@ static void wacom_setup_intuos(struct wacom_wac *wacom_wac)
 	input_set_abs_params(input_dev, ABS_THROTTLE, -1023, 1023, 0, 0);
 }
 
+
+void wacom_setup_device_quirks(struct wacom_features *features)
+{
+
+	/* touch device found but size is not defined. use default */
+	if (features->device_type == BTN_TOOL_DOUBLETAP && !features->x_max) {
+		features->x_max = 1023;
+		features->y_max = 1023;
+	}
+
+	/* these device have multiple inputs */
+	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
+	    features->type == BAMBOO_PT)
+		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
+}
+
 void wacom_setup_input_capabilities(struct input_dev *input_dev,
 				    struct wacom_wac *wacom_wac)
 {
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 7717285..1284f33 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -41,6 +41,9 @@
 /* largest reported tracking id */
 #define MAX_TRACKING_ID			0xfff
 
+/* device quirks */
+#define WACOM_QUIRK_MULTI_INPUT		0x0001
+
 enum {
 	PENPARTNER = 0,
 	GRAPHIRE,
@@ -82,6 +85,7 @@ struct wacom_features {
 	int y_fuzz;
 	int pressure_fuzz;
 	int distance_fuzz;
+	unsigned quirks;
 };
 
 struct wacom_shared {
-- 
1.7.1

