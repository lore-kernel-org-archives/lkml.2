Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab0IDNoa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 09:44:30 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:40488 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab0IDNo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 09:44:27 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 5/5] input: wacom: Add a quirk for lowres Bamboo devices (rev2)
Date: Sat,  4 Sep 2010 15:43:03 +0200
Message-Id: <1283607783-29388-6-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
References: <1283607783-29388-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Ort2F-0007Q6-8f.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Ort2F-0007Q6-8f a357ffddb98c5a308c1f6a0bafa1ea55
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
 drivers/input/tablet/wacom_wac.c |   10 ++++++++++
 drivers/input/tablet/wacom_wac.h |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 97295aa..8193892 100644
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
@@ -1010,8 +1015,13 @@ void wacom_setup_device_quirks(struct wacom_features *features)
 
 	/* quirks for bamboo touch */
 	if (features->type == BAMBOO_PT) {
+		features->x_max <<= 5;
+		features->y_max <<= 5;
+		features->x_fuzz <<= 5;
+		features->y_fuzz <<= 5;
 		features->pressure_max = 256;
 		features->pressure_fuzz = 16;
+		features->quirks |= WACOM_QUIRK_BBTOUCH_LOWRES;
 	}
 }
 
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index 816ab0f..22cafe2 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -40,6 +40,7 @@
 
 /* device quirks */
 #define WACOM_QUIRK_MULTI_INPUT		0x0001
+#define WACOM_QUIRK_BBTOUCH_LOWRES	0x0002
 
 /* largest reported tracking id */
 #define MAX_TRACKING_ID			0xfff
-- 
1.7.1

