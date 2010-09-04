Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0IDNod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:44:33 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60084 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab0IDNob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:44:31 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 3/5] input: wacom: Collect device quirks into single function (rev2)
Date: Sat,  4 Sep 2010 15:43:01 +0200
Message-Id: <1283607783-29388-4-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Ort23-0005L6-By.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Ort23-0005L6-By c575214c0a307f91e5029e363397d750
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
index bfe5654..ca18b4d 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -941,6 +941,22 @@ static void wacom_setup_intuos(struct wacom_wac *wacom_wac)
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
index fb30895..6a1ff10 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -38,6 +38,9 @@
 #define WACOM_REPORT_TPC1FG		6
 #define WACOM_REPORT_TPC2FG		13
 
+/* device quirks */
+#define WACOM_QUIRK_MULTI_INPUT		0x0001
+
 enum {
 	PENPARTNER = 0,
 	GRAPHIRE,
@@ -79,6 +82,7 @@ struct wacom_features {
 	int y_fuzz;
 	int pressure_fuzz;
 	int distance_fuzz;
+	unsigned quirks;
 };
 
 struct wacom_shared {
-- 
1.7.1

