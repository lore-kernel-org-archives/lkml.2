Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0ICMSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:18:30 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:40681 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757936Ab0ICMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:18:20 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/5] input: wacom: Add a quirk for lowres Bamboo devices
Date: Fri,  3 Sep 2010 14:17:27 +0200
Message-Id: <1283516247-11624-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OrVDf-0006wF-8q.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OrVDf-0006wF-8q ac0adea833dd13a9f110d5e1a3a8299b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Bamboo Touch reports a sub-screen resolution of 480x320.
The signal-to-noise ratio is only about 100, so filtering is
needed in order to reduce the jitter to a usable level. However,
the low resolution leads to round-off errors in the EWMA filter,
resulting in extremely jerky pointer motion. This patch explicitly
sets a higher resolution for those devices, and tells this to
the completion handler via a low-resolution quirk.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/tablet/wacom_wac.c |   15 +++++++++++++++
 drivers/input/tablet/wacom_wac.h |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 78e5345..fd2d46a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -858,6 +858,7 @@ static int wacom_tpc_irq(struct wacom_wac *wacom, size_t len)
 static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
 {
 	static int trkid;
+	struct wacom_features *features = &wacom->features;
 	struct input_dev *input = wacom->input;
 	unsigned char *data = wacom->data;
 	int sp = 0, sx = 0, sy = 0, count = 0;
@@ -872,6 +873,10 @@ static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
 		if (p) {
 			int x = get_unaligned_be16(&data[9 * i + 3]) & 0x7ff;
 			int y = get_unaligned_be16(&data[9 * i + 5]) & 0x7ff;
+			if (features->quirks & WACOM_QUIRK_BBTOUCH_LOWRES) {
+				x <<= 5;
+				y <<= 5;
+			}
 			input_report_abs(input, ABS_MT_PRESSURE, p);
 			input_report_abs(input, ABS_MT_POSITION_X, x);
 			input_report_abs(input, ABS_MT_POSITION_Y, y);
@@ -1007,6 +1012,16 @@ void wacom_setup_device_quirks(struct wacom_features *features)
 	if (features->type == TABLETPC || features->type == TABLETPC2FG ||
 	    features->type == BAMBOO_PT)
 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
+
+	/* quirks for bamboo touch */
+	if (features->x_max == 480 && features->y_max == 320) {
+		features->x_max = 15360;
+		features->y_max = 10240;
+		features->x_fuzz = 128;
+		features->y_fuzz = 128;
+		features->pressure_fuzz = 16;
+		features->quirks |= WACOM_QUIRK_BBTOUCH_LOWRES;
+	}
 }
 
 void wacom_setup_input_capabilities(struct input_dev *input_dev,
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 1284f33..b9de134 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -43,6 +43,7 @@
 
 /* device quirks */
 #define WACOM_QUIRK_MULTI_INPUT		0x0001
+#define WACOM_QUIRK_BBTOUCH_LOWRES	0x0002
 
 enum {
 	PENPARTNER = 0,
-- 
1.7.1

