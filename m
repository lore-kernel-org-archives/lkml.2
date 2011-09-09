Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab1IISGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 14:06:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53436 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759479Ab1IISGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 14:06:43 -0400
Date: Fri, 9 Sep 2011 11:06:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Sung <penmount.touch@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Input: penmount - add PenMount 6250 support
Message-ID: <20110909180637.GD32383@core.coreip.homeip.net>
References: <1315555667-5893-1-git-send-email-penmount.touch@gmail.com>
 <1315555667-5893-3-git-send-email-penmount.touch@gmail.com>
 <20110909180419.GC32383@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909180419.GC32383@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 11:04:19AM -0700, Dmitry Torokhov wrote:
> On Fri, Sep 09, 2011 at 04:07:47PM +0800, John Sung wrote:
> > Add multi touch support for PenMount 6250 touch controller.
> > 
> 
> Given the changes to previous patches, this one turns into:
> 

Also, I wonder if we should do something like this:

Input: penmount - rework handling of different protocols

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Instead of having one large switch based on product ID use pointer to
function actually doing protocol decoding.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/touchscreen/penmount.c |  120 ++++++++++++++++++----------------
 1 files changed, 64 insertions(+), 56 deletions(-)


diff --git a/drivers/input/touchscreen/penmount.c b/drivers/input/touchscreen/penmount.c
index df42519..7ebed38 100644
--- a/drivers/input/touchscreen/penmount.c
+++ b/drivers/input/touchscreen/penmount.c
@@ -61,6 +61,7 @@ struct pm {
 	unsigned char packetsize;
 	unsigned char maxcontacts;
 	struct mt_slot slots[PM_MAX_MTSLOT];
+	void (*parse_packet)(struct pm *);
 };
 
 /*
@@ -100,73 +101,76 @@ static int pm_checkpacket(unsigned char *packet)
 	return packet[5] == (unsigned char)~(total & 0xff);
 }
 
-static irqreturn_t pm_interrupt(struct serio *serio,
-		unsigned char data, unsigned int flags)
+static void pm_parse_9000(struct pm *pm)
 {
-	struct pm *pm = serio_get_drvdata(serio);
 	struct input_dev *dev = pm->dev;
 
-	pm->data[pm->idx] = data;
+	if ((pm->data[0] & 0x80) && pm->packetsize == ++pm->idx) {
+		input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
+		input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
+		input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
+		input_sync(dev);
+		pm->idx = 0;
+	}
+}
 
-	switch (pm->dev->id.product) {
-	case 0x9000:
-		if (pm->data[0] & 0x80) {
-			if (pm->packetsize == ++pm->idx) {
-				input_report_abs(dev, ABS_X, pm->data[1] * 128 + pm->data[2]);
-				input_report_abs(dev, ABS_Y, pm->data[3] * 128 + pm->data[4]);
-				input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
-				input_sync(dev);
-				pm->idx = 0;
-			}
-		}
-		break;
+static void pm_parse_6000(struct pm *pm)
+{
+	struct input_dev *dev = pm->dev;
 
-	case 0x6000:
-		if ((pm->data[0] & 0xbf) == 0x30) {
-			if (pm->packetsize == ++pm->idx) {
-				if (pm_checkpacket(pm->data)) {
-					input_report_abs(dev, ABS_X,
-							pm->data[2] * 256 + pm->data[1]);
-					input_report_abs(dev, ABS_Y,
-							pm->data[4] * 256 + pm->data[3]);
-					input_report_key(dev, BTN_TOUCH, !!(pm->data[0] & 0x40));
-					input_sync(dev);
-				}
-				pm->idx = 0;
-			}
+	if ((pm->data[0] & 0xbf) == 0x30 && pm->packetsize == ++pm->idx) {
+		if (pm_checkpacket(pm->data)) {
+			input_report_abs(dev, ABS_X,
+					pm->data[2] * 256 + pm->data[1]);
+			input_report_abs(dev, ABS_Y,
+					pm->data[4] * 256 + pm->data[3]);
+			input_report_key(dev, BTN_TOUCH, pm->data[0] & 0x40);
+			input_sync(dev);
 		}
-		break;
+		pm->idx = 0;
+	}
+}
+
+static void pm_parse_3000(struct pm *pm)
+{
+	struct input_dev *dev = pm->dev;
 
-	case 0x3000:
-		if ((pm->data[0] & 0xce) == 0x40) {
-			if (pm->packetsize == ++pm->idx) {
-				if (pm_checkpacket(pm->data)) {
-					int slotnum = pm->data[0] & 0x0f;
-					pm->slots[slotnum].active = pm->data[0] & 0x30;
-					pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
-					pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
-					pm_mtevent(pm, dev);
-				}
-				pm->idx = 0;
-			}
+	if ((pm->data[0] & 0xce) == 0x40 && pm->packetsize == ++pm->idx) {
+		if (pm_checkpacket(pm->data)) {
+			int slotnum = pm->data[0] & 0x0f;
+			pm->slots[slotnum].active = pm->data[0] & 0x30;
+			pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
+			pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
+			pm_mtevent(pm, dev);
 		}
-		break;
+		pm->idx = 0;
+	}
+}
+
+static void pm_parse_6250(struct pm *pm)
+{
+	struct input_dev *dev = pm->dev;
 
-	case 0x6250:
-		if ((pm->data[0] & 0xb0) == 0x30) {
-			if (pm->packetsize == ++pm->idx) {
-				if (pm_checkpacket(pm->data)) {
-					int slotnum = pm->data[0] & 0x0f;
-					pm->slots[slotnum].active = pm->data[0] & 0x40;
-					pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
-					pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
-					pm_mtevent(pm, dev);
-				}
-				pm->idx = 0;
-			}
+	if ((pm->data[0] & 0xb0) == 0x30 && pm->packetsize == ++pm->idx) {
+		if (pm_checkpacket(pm->data)) {
+			int slotnum = pm->data[0] & 0x0f;
+			pm->slots[slotnum].active = pm->data[0] & 0x40;
+			pm->slots[slotnum].x = pm->data[2] * 256 + pm->data[1];
+			pm->slots[slotnum].y = pm->data[4] * 256 + pm->data[3];
+			pm_mtevent(pm, dev);
 		}
-		break;
+		pm->idx = 0;
 	}
+}
+
+static irqreturn_t pm_interrupt(struct serio *serio,
+		unsigned char data, unsigned int flags)
+{
+	struct pm *pm = serio_get_drvdata(serio);
+
+	pm->data[pm->idx] = data;
+
+	pm->parse_packet(pm);
 
 	return IRQ_HANDLED;
 }
@@ -227,18 +231,21 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 	default:
 	case 0:
 		pm->packetsize = 5;
+		pm->parse_packet = pm_parse_9000;
 		input_dev->id.product = 0x9000;
 		max_x = max_y = 0x3ff;
 		break;
 
 	case 1:
 		pm->packetsize = 6;
+		pm->parse_packet = pm_parse_6000;
 		input_dev->id.product = 0x6000;
 		max_x = max_y = 0x3ff;
 		break;
 
 	case 2:
 		pm->packetsize = 6;
+		pm->parse_packet = pm_parse_3000;
 		input_dev->id.product = 0x3000;
 		max_x = max_y = 0x7ff;
 		pm->maxcontacts = PM_3000_MTSLOT;
@@ -246,6 +253,7 @@ static int pm_connect(struct serio *serio, struct serio_driver *drv)
 
 	case 3:
 		pm->packetsize = 6;
+		pm->parse_packet = pm_parse_6250;
 		input_dev->id.product = 0x6250;
 		max_x = max_y = 0x3ff;
 		pm->maxcontacts = PM_6250_MTSLOT;

-- 
Dmitry
