Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab1IISDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:03:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60700 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1IISDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:03:14 -0400
Date: Fri, 9 Sep 2011 11:03:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: penmount - add PenMount 3000 support
Message-ID: <20110909180309.GB32383@core.coreip.homeip.net>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
 <1315555667-5893-2-git-send-email-penmount.touch@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315555667-5893-2-git-send-email-penmount.touch@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 04:07:46PM +0800, John Sung wrote:
> @@ -166,6 +217,16 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
>  		pm->packetsize = 6;
>  		input_dev->id.product = 0x6000;
>  		break;
> +	case 2:
> +		pm->packetsize = 6;
> +		input_dev->id.product = 0x3000;
> +		input_set_abs_params(pm->dev, ABS_X, 0, 0x7ff, 0, 0);
> +		input_set_abs_params(pm->dev, ABS_Y, 0, 0x7ff, 0, 0);
> +		pm->maxcontacts = PM_3000_MTSLOT;
> +		input_mt_init_slots(pm->dev, PM_3000_MTSLOT);
> +		input_set_abs_params(pm->dev, ABS_MT_POSITION_X, 0, 0x7ff, 0, 0);
> +		input_set_abs_params(pm->dev, ABS_MT_POSITION_Y, 0, 0x7ff, 0, 0);
> +		break;
>  	}
>  

I do not like how we set up input device with default values for ranges and then we are
overriding for some protocols. How about we do it like the patch below?

Thanks.

-- 
Dmitry

Input: penmount - add PenMount 3000 support

From: John Sung <penmount.touch@gmail.com>

Add dual touch support for PenMount 3000 touch controller.

Signed-off-by: John Sung <penmount.touch@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/penmount.c |   79 ++++++++++++++++++++++++++++++++--
 1 files changed, 75 insertions(+), 4 deletions(-)


diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index dd882eb..86e0612 100644
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
+	bool active; /* is the touch valid? */
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
+				pm->slots[i].active);
+		if (pm->slots[i].active) {
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
 
@@ -99,6 +135,21 @@ static irqreturn_t pm_interrupt(struct serio *serio,
 			}
 		}
 		break;
+
+	case 0x3000:
+		if ((pm->data[0] & 0xce) == 0x40) {
+			if (pm->packetsize == ++pm->idx) {
+				if (pm_checkpacket(pm->data)) {
+					int slotnum = pm->data[0] & 0x0f;
+					pm->slots[slotnum].active = pm->data[0] & 0x30;
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
@@ -130,6 +181,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 {
 	struct pm *pm;
 	struct input_dev *input_dev;
+	int max_x, max_y;
 	int err;
 
 	pm = kzalloc(sizeof(struct pm), GFP_KERNEL);
@@ -142,6 +194,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	pm->serio = serio;
 	pm->dev = input_dev;
 	snprintf(pm->phys, sizeof(pm->phys), "%s/input0", serio->phys);
+	pm->maxcontacts = 1;
 
 	input_dev->name = "PenMount Serial TouchScreen";
 	input_dev->phys = pm->phys;
@@ -151,24 +204,42 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	input_dev->id.version = 0x0100;
 	input_dev->dev.parent = &serio->dev;
 
-        input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-        input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
-        input_set_abs_params(pm->dev, ABS_X, 0, 0x3ff, 0, 0);
-        input_set_abs_params(pm->dev, ABS_Y, 0, 0x3ff, 0, 0);
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	switch (serio->id.id) {
 	default:
 	case 0:
 		pm->packetsize = 5;
 		input_dev->id.product = 0x9000;
+		max_x = max_y = 0x3ff;
 		break;
 
 	case 1:
 		pm->packetsize = 6;
 		input_dev->id.product = 0x6000;
+		max_x = max_y = 0x3ff;
+		break;
+
+	case 2:
+		pm->packetsize = 6;
+		input_dev->id.product = 0x3000;
+		max_x = max_y = 0x7ff;
+		pm->maxcontacts = PM_3000_MTSLOT;
 		break;
 	}
 
+	input_set_abs_params(pm->dev, ABS_X, 0, max_x, 0, 0);
+	input_set_abs_params(pm->dev, ABS_Y, 0, max_y, 0, 0);
+
+	if (pm->maxcontacts > 1) {
+		input_mt_init_slots(pm->dev, pm->maxcontacts);
+		input_set_abs_params(pm->dev,
+				     ABS_MT_POSITION_X, 0, max_x, 0, 0);
+		input_set_abs_params(pm->dev,
+				     ABS_MT_POSITION_Y, 0, max_y, 0, 0);
+	}
+
 	serio_set_drvdata(serio, pm);
 
 	err = serio_open(serio, drv);
