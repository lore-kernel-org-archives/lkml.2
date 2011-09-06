Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab1IFGgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:36:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab1IFGgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:36:12 -0400
From: John Sung <penmount.touch@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        John Sung <penmount.touch@gmail.com>
Subject: [PATCH 2/3] Input: penmount - add PenMount 6000 support
Date: Tue,  6 Sep 2011 14:36:01 +0800
Message-Id: <1315290961-23570-1-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for PenMount 6000 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/touchscreen/penmount.c |   58 +++++++++++++++++++++++++++++-----
 1 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 3342c6d..b60796b 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -33,7 +33,7 @@ MODULE_LICENSE("GPL");
  * Definitions & global arrays.
  */
 
-#define	PM_MAX_LENGTH	5
+#define	PM_MAX_LENGTH	6
 
 /*
  * Per-touchscreen data.
@@ -45,6 +45,7 @@ struct pm {
 	int idx;
 	unsigned char data[PM_MAX_LENGTH];
 	char phys[32];
+	unsigned char packetsize;
 };
 
 static irqreturn_t pm_interrupt(struct serio *serio,
@@ -55,20 +56,48 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 
 	pm->data[pm->idx] = data;
 
-	if (pm->data[0] & 0x80) {
-		if (PM_MAX_LENGTH == ++pm->idx) {
-			input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
-			input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
-			input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
-			input_sync(dev);
-			pm->idx = 0;
+	switch (pm->dev->id.product) {
+	case 0x9000:
+		if (pm->data[0] & 0x80) {
+			if (pm->packetsize == ++pm->idx) {
+				input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
+				input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
+				input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
+				input_sync(dev);
+				pm->idx = 0;
+			}
 		}
+		break;
+	case 0x6000:
+		if ((pm->data[0] == 0x70) || (pm->data[0] == 0x30)) {
+			if (pm->packetsize == ++pm->idx) {
+				input_report_abs(dev, ABS_X, pm->data[2] * 256 + pm->data[1]);
+				input_report_abs(dev, ABS_Y, pm->data[4] * 256 + pm->data[3]);
+				input_report_key(dev, BTN_TOUCH, (pm->data[0] == 0x70));
+				input_sync(dev);
+				pm->idx = 0;
+			}
+		}
+		break;
 	}
 
 	return IRQ_HANDLED;
 }
 
 /*
+ * pm_enable() sends command that can enable the PenMount 6000 controller
+ */
+
+static void pm_enable(struct serio *serio)
+{
+	int i = 0;
+	unsigned char command[6] = { 0xF1, 0x00, 0x00, 0x00, 0x00, 0x0E };
+
+	for (i = 0; i < 6; i++)
+		serio_write(serio, command[i]);
+}
+
+/*
  * pm_disconnect() is the opposite of pm_connect()
  */
 
@@ -120,6 +149,19 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
         input_set_abs_params(pm->dev, ABS_X, 0, 0x3ff, 0, 0);
         input_set_abs_params(pm->dev, ABS_Y, 0, 0x3ff, 0, 0);
 
+	switch (serio->id.id) {
+	default:
+	case 0:
+		pm->packetsize = 5;
+		input_dev->id.product = 0x9000;
+		break;
+	case 1:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x6000;
+		pm_enable(serio);
+		break;
+	}
+
 	serio_set_drvdata(serio, pm);
 
 	err = serio_open(serio, drv);
-- 
1.7.4.1

