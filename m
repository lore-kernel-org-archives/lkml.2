Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1IIIJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:09:05 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64304 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab1IIII4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:08:56 -0400
From: John Sung <penmount.touch@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        John Sung <penmount.touch@gmail.com>
Subject: [PATCH 2/3] Input: penmount - add PenMount 3000 support
Date: Fri,  9 Sep 2011 16:07:46 +0800
Message-Id: <1315555667-5893-2-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dual touch support for PenMount 3000 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/touchscreen/penmount.c |   61 ++++++++++++++++++++++++++++++++++
 1 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index 240f6a2..e4f953e 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/serio.h>
 #include <linux/init.h>
 
@@ -34,6 +35,17 @@ MODULE_LICENSE("GPL");
  */
 
 #define	PM_MAX_LENGTH	6
+#define	PM_MAX_MTSLOT	16
+#define	PM_3000_MTSLOT	2
+
+/*
+ * Multi-touch slot
+ */
+
+struct mt_slot {
+	unsigned short x, y;
+	unsigned char state; /* is the touch valid? */
+};
 
 /*
  * Per-touchscreen data.
@@ -46,9 +58,33 @@ struct pm {
 	unsigned char data[PM_MAX_LENGTH];
 	char phys[32];
 	unsigned char packetsize;
+	unsigned char maxcontacts;
+	struct mt_slot slots[PM_MAX_MTSLOT];
 };
 
 /*
+ * pm_mtevent() sends mt events and also emulates pointer movement
+ */
+
+static void pm_mtevent(struct pm *pm, struct input_dev *input)
+{
+	int i;
+
+	for (i = 0; i < pm->maxcontacts; ++i) {
+		input_mt_slot(input, i);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER,
+				pm->slots[i].state);
+		if (pm->slots[i].state) {
+			input_event(input, EV_ABS, ABS_MT_POSITION_X, pm->slots[i].x);
+			input_event(input, EV_ABS, ABS_MT_POSITION_Y, pm->slots[i].y);
+		}
+	}
+
+	input_mt_report_pointer_emulation(input, true);
+	input_sync(input);
+}
+
+/*
  * pm_checkpacket() checks if data packet is valid
  */
 
@@ -99,6 +135,20 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 			}
 		}
 		break;
+	case 0x3000:
+		if ((pm->data[0] & 0xce) == 0x40) {
+			if (pm->packetsize == ++pm->idx) {
+				if (pm_checkpacket(pm->data)) {
+					int slotnum = pm->data[0] & 0x0f;
+					pm->slots[slotnum].state = !!(pm->data[0] & 0x30);
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
@@ -142,6 +192,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	pm->serio = serio;
 	pm->dev = input_dev;
 	snprintf(pm->phys, sizeof(pm->phys), "%s/input0", serio->phys);
+	pm->maxcontacts = 1;
 
 	input_dev->name = "PenMount Serial TouchScreen";
 	input_dev->phys = pm->phys;
@@ -166,6 +217,16 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 		pm->packetsize = 6;
 		input_dev->id.product = 0x6000;
 		break;
+	case 2:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x3000;
+		input_set_abs_params(pm->dev, ABS_X, 0, 0x7ff, 0, 0);
+		input_set_abs_params(pm->dev, ABS_Y, 0, 0x7ff, 0, 0);
+		pm->maxcontacts = PM_3000_MTSLOT;
+		input_mt_init_slots(pm->dev, PM_3000_MTSLOT);
+		input_set_abs_params(pm->dev, ABS_MT_POSITION_X, 0, 0x7ff, 0, 0);
+		input_set_abs_params(pm->dev, ABS_MT_POSITION_Y, 0, 0x7ff, 0, 0);
+		break;
 	}
 
 	serio_set_drvdata(serio, pm);
-- 
1.7.4.1

