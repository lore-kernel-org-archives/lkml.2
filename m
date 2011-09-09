Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1IIIJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:09:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39361 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab1IIIJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:09:05 -0400
From: John Sung <penmount.touch@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        John Sung <penmount.touch@gmail.com>
Subject: [PATCH 3/3] Input: penmount - add PenMount 6250 support
Date: Fri,  9 Sep 2011 16:07:47 +0800
Message-Id: <1315555667-5893-3-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add multi touch support for PenMount 6250 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/touchscreen/penmount.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index e4f953e..68da847 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -37,6 +37,7 @@ MODULE_LICENSE("GPL");
 #define	PM_MAX_LENGTH	6
 #define	PM_MAX_MTSLOT	16
 #define	PM_3000_MTSLOT	2
+#define	PM_6250_MTSLOT	12
 
 /*
  * Multi-touch slot
@@ -149,6 +150,20 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 			}
 		}
 		break;
+	case 0x6250:
+		if ((pm->data[0] & 0xb0) == 0x30) {
+			if (pm->packetsize == ++pm->idx) {
+				if (pm_checkpacket(pm->data)) {
+					int slotnum = pm->data[0] & 0x0f;
+					pm->slots[slotnum].state = !!(pm->data[0] & 0x40);
+					pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
+					pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
+					pm_mtevent(pm, dev);
+				}
+				pm->idx = 0;
+			}
+		}
+		break;
 	}
 
 	return IRQ_HANDLED;
@@ -227,6 +242,14 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 		input_set_abs_params(pm->dev, ABS_MT_POSITION_X, 0, 0x7ff, 0, 0);
 		input_set_abs_params(pm->dev, ABS_MT_POSITION_Y, 0, 0x7ff, 0, 0);
 		break;
+	case 3:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x6250;
+		pm->maxcontacts = PM_6250_MTSLOT;
+		input_mt_init_slots(pm->dev, PM_6250_MTSLOT);
+		input_set_abs_params(pm->dev, ABS_MT_POSITION_X, 0, 0x3ff, 0, 0);
+		input_set_abs_params(pm->dev, ABS_MT_POSITION_Y, 0, 0x3ff, 0, 0);
+		break;
 	}
 
 	serio_set_drvdata(serio, pm);
-- 
1.7.4.1

