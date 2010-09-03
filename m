Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0ICNBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:01:11 -0400
Received: from wacom-nt10.wacom.com ([204.119.25.43]:57147 "EHLO
	wacom-nt10.wacom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0ICNBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:01:08 -0400
X-Greylist: delayed 793 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Sep 2010 09:01:03 EDT
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 5/5] input: wacom: Add a quirk for lowres Bamboo devices
Date: Fri, 3 Sep 2010 05:47:46 -0700
Message-ID: <6753EB6004AFF34FAA275742C104F952022BB10D@wacom-nt10.wacom.com>
In-Reply-To: <1283516247-11624-6-git-send-email-rydberg@euromail.se>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se> <1283516247-11624-6-git-send-email-rydberg@euromail.se>
From: "Ping Cheng" <pingc@wacom.com>
To: "Henrik Rydberg" <rydberg@euromail.se>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Chris Bagwell" <chris@cnpbagwell.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Henrik Rydberg [mailto:rydberg@euromail.se] 
Sent: Friday, September 03, 2010 2:17 PM
To: Dmitry Torokhov
Cc: Ping Cheng; Chris Bagwell; linux-input@vger.kernel.org;
linux-kernel@vger.kernel.org; Henrik Rydberg
Subject: [PATCH 5/5] input: wacom: Add a quirk for lowres Bamboo devices

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

diff --git a/drivers/input/tablet/wacom_wac.c
b/drivers/input/tablet/wacom_wac.c
index 78e5345..fd2d46a 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -858,6 +858,7 @@ static int wacom_tpc_irq(struct wacom_wac *wacom,
size_t len)
 static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
 {
 	static int trkid;
+	struct wacom_features *features = &wacom->features;
 	struct input_dev *input = wacom->input;
 	unsigned char *data = wacom->data;
 	int sp = 0, sx = 0, sy = 0, count = 0;
@@ -872,6 +873,10 @@ static int wacom_bpt_irq(struct wacom_wac *wacom,
size_t len)
 		if (p) {
 			int x = get_unaligned_be16(&data[9 * i + 3]) &
0x7ff;
 			int y = get_unaligned_be16(&data[9 * i + 5]) &
0x7ff;
+			if (features->quirks &
WACOM_QUIRK_BBTOUCH_LOWRES) {
+				x <<= 5;
+				y <<= 5;
+			}
 			input_report_abs(input, ABS_MT_PRESSURE, p);
 			input_report_abs(input, ABS_MT_POSITION_X, x);
 			input_report_abs(input, ABS_MT_POSITION_Y, y);
@@ -1007,6 +1012,16 @@ void wacom_setup_device_quirks(struct
wacom_features *features)
 	if (features->type == TABLETPC || features->type == TABLETPC2FG
||
 	    features->type == BAMBOO_PT)
 		features->quirks |= WACOM_QUIRK_MULTI_INPUT;
+
+	/* quirks for bamboo touch */
+	if (features->x_max == 480 && features->y_max == 320) {
 
A check on all Bamboo touch devices can be a generic way to cover all
Bamboos with touch feature (4 models). This check can be based on the
product id or features->type (== BAMBOO_PT) in combination with the
actual type (pen/touch) of the device.  All Bamboo touch devices use the
same protocol.

+		features->x_max = 15360;
+		features->y_max = 10240;

I guess these two numbers rely on the original maxes: (480, 320). If so,
can we also make them generic by accessing features->x_max/y_max
directly?

+		features->x_fuzz = 128;
+		features->y_fuzz = 128;
+		features->pressure_fuzz = 16;
+		features->quirks |= WACOM_QUIRK_BBTOUCH_LOWRES;
+	}
 }
 
 void wacom_setup_input_capabilities(struct input_dev *input_dev,
diff --git a/drivers/input/tablet/wacom_wac.h
b/drivers/input/tablet/wacom_wac.h
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

