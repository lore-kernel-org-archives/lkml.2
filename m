Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1IFGgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:36:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43167 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1IFGgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:36:31 -0400
From: John Sung <penmount.touch@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        John Sung <penmount.touch@gmail.com>
Subject: [PATCH 3/3] Input: penmount - add PenMount 3000 support
Date: Tue,  6 Sep 2011 14:36:20 +0800
Message-Id: <1315290980-23608-1-git-send-email-penmount.touch@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add multi touch support for PenMount 3000 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
---
 drivers/input/touchscreen/penmount.c |   59 ++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index b60796b..bbb7a20 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/input.h>
+#include <linux/input/mt.h>
 #include <linux/serio.h>
 #include <linux/init.h>
 
@@ -34,6 +35,16 @@ MODULE_LICENSE("GPL");
  */
 
 #define	PM_MAX_LENGTH	6
+#define	PM_MAX_MTSLOT	2
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
@@ -46,8 +57,32 @@ struct pm {
 	unsigned char data[PM_MAX_LENGTH];
 	char phys[32];
 	unsigned char packetsize;
+	unsigned char maxcontacts;
+	struct mt_slot slots[PM_MAX_MTSLOT];
 };
 
+/*
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
 static irqreturn_t pm_interrupt(struct serio *serio,
 		unsigned char data, unsigned int flags)
 {
@@ -79,6 +114,19 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 			}
 		}
 		break;
+	case 0x3000:
+		if ((pm->data[0] == 0x70) || (pm->data[0] == 0x40)
+				|| (pm->data[0] == 0x71) || (pm->data[0] == 0x41)) {
+			if (pm->packetsize == ++pm->idx) {
+				int slotnum = pm->data[0] & 0x0F;
+				pm->slots[slotnum].state = ((pm->data[0] & 0xF0) == 0x70);
+				pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
+				pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
+				pm_mtevent(pm, dev);
+				pm->idx = 0;
+			}
+		}
+		break;
 	}
 
 	return IRQ_HANDLED;
@@ -135,6 +183,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	pm->serio = serio;
 	pm->dev = input_dev;
 	snprintf(pm->phys, sizeof(pm->phys), "%s/input0", serio->phys);
+	pm->maxcontacts = 1;
 
 	input_dev->name = "PenMount Serial TouchScreen";
 	input_dev->phys = pm->phys;
@@ -160,6 +209,16 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 		input_dev->id.product = 0x6000;
 		pm_enable(serio);
 		break;
+	case 2:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x3000;
+		input_set_abs_params(pm->dev, ABS_X, 0, 0x7ff, 0, 0);
+		input_set_abs_params(pm->dev, ABS_Y, 0, 0x7ff, 0, 0);
+		pm->maxcontacts = PM_MAX_MTSLOT;
+		input_mt_init_slots(pm->dev, PM_MAX_MTSLOT);
+		input_set_abs_params(pm->dev, ABS_MT_POSITION_X, 0, 0x7ff, 0, 0);
+		input_set_abs_params(pm->dev, ABS_MT_POSITION_Y, 0, 0x7ff, 0, 0);
+		break;
 	}
 
 	serio_set_drvdata(serio, pm);
-- 
1.7.4.1

