Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1IFGen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:34:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64256 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1IFGeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:34:37 -0400
From: John Sung <penmount.touch@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        John Sung <penmount.touch@gmail.com>
Subject: [PATCH 1/3] Input: penmount - fix the protocol
Date: Tue,  6 Sep 2011 14:34:24 +0800
Message-Id: <1315290864-23531-1-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSB and LSB of the XY axis value are switched according to the PenMount 9000 protocol. The driver name is also changed from penmountlpc, since it is not for LPC interface at all.

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/touchscreen/penmount.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index c7f9ceb..3342c6d 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -2,6 +2,7 @@
  * Penmount serial touchscreen driver
  *
  * Copyright (c) 2006 Rick Koch <n1gp@hotmail.com>
+ * Copyright (c) 2011 John Sung <penmount.touch@gmail.com>
  *
  * Based on ELO driver (drivers/input/touchscreen/elo.c)
  * Copyright (c) 2004 Vojtech Pavlik
@@ -21,9 +22,10 @@
 #include <linux/serio.h>
 #include <linux/init.h>
 
-#define DRIVER_DESC	"Penmount serial touchscreen driver"
+#define DRIVER_DESC	"PenMount serial touchscreen driver"
 
 MODULE_AUTHOR("Rick Koch <n1gp@hotmail.com>");
+MODULE_AUTHOR("John Sung <penmount.touch@gmail.com>");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
@@ -55,8 +57,8 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 
 	if (pm->data[0] & 0x80) {
 		if (PM_MAX_LENGTH == ++pm->idx) {
-			input_report_abs(dev, ABS_X, pm->data[2] * 128 + pm->data[1]);
-			input_report_abs(dev, ABS_Y, pm->data[4] * 128 + pm->data[3]);
+			input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
+			input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
 			input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
 			input_sync(dev);
 			pm->idx = 0;
@@ -84,7 +86,7 @@ static void pm_disconnect(struct serio *serio)
 
 /*
  * pm_connect() is the routine that is called when someone adds a
- * new serio device that supports Gunze protocol and registers it as
+ * new serio device that supports PenMount protocol and registers it as
  * an input device.
  */
 
@@ -105,7 +107,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	pm->dev = input_dev;
 	snprintf(pm->phys, sizeof(pm->phys), "%s/input0", serio->phys);
 
-	input_dev->name = "Penmount Serial TouchScreen";
+	input_dev->name = "PenMount Serial TouchScreen";
 	input_dev->phys = pm->phys;
 	input_dev->id.bustype = BUS_RS232;
 	input_dev->id.vendor = SERIO_PENMOUNT;
@@ -155,7 +157,7 @@ MODULE_DEVICE_TABLE(serio, pm_serio_ids);
 
 static struct serio_driver pm_drv = {
 	.driver		= {
-		.name	= "penmountlpc",
+		.name	= "serio-penmount",
 	},
 	.description	= DRIVER_DESC,
 	.id_table	= pm_serio_ids,
-- 
1.7.4.1

