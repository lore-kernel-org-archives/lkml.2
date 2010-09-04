Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0IDNnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:43:40 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52235 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0IDNnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:43:37 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 1/5] input: wacom: Add fuzz parameters to features
Date: Sat,  4 Sep 2010 15:42:59 +0200
Message-Id: <1283607783-29388-2-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Ort1i-0002te-6N.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Ort1i-0002te-6N ab7d3e5f14908794b3ccde90666f1461
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The signal-to-noise ratio varies between devices, but currently all
devices are treated the same way. Add fuzz parameters to the feature
struct, allowing for tailored treatment of devices.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/tablet/wacom_sys.c |    6 +++++-
 drivers/input/tablet/wacom_wac.c |    9 ++++++---
 drivers/input/tablet/wacom_wac.h |    4 ++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 42ba369..e510e4f 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -333,8 +333,12 @@ static int wacom_retrieve_hid_descriptor(struct usb_interface *intf,
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	struct hid_descriptor *hid_desc;
 
-	/* default device to penabled */
+	/* default features */
 	features->device_type = BTN_TOOL_PEN;
+	features->x_fuzz = 4;
+	features->y_fuzz = 4;
+	features->pressure_fuzz = 0;
+	features->distance_fuzz = 0;
 
 	/* only Tablet PCs need to retrieve the info */
 	if ((features->type != TABLETPC) && (features->type != TABLETPC2FG))
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 40d77ba..bfe5654 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -951,9 +951,12 @@ void wacom_setup_input_capabilities(struct input_dev *input_dev,
 
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 
-	input_set_abs_params(input_dev, ABS_X, 0, features->x_max, 4, 0);
-	input_set_abs_params(input_dev, ABS_Y, 0, features->y_max, 4, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE, 0, features->pressure_max, 0, 0);
+	input_set_abs_params(input_dev, ABS_X, 0, features->x_max,
+			     features->x_fuzz, 0);
+	input_set_abs_params(input_dev, ABS_Y, 0, features->y_max,
+			     features->y_fuzz, 0);
+	input_set_abs_params(input_dev, ABS_PRESSURE, 0, features->pressure_max,
+			     features->pressure_fuzz, 0);
 
 	__set_bit(ABS_MISC, input_dev->absbit);
 
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 99e1a54..d769e9a 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -73,6 +73,10 @@ struct wacom_features {
 	int y_phy;
 	unsigned char unit;
 	unsigned char unitExpo;
+	int x_fuzz;
+	int y_fuzz;
+	int pressure_fuzz;
+	int distance_fuzz;
 };
 
 struct wacom_shared {
-- 
1.7.1

