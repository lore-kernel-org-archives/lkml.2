Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab0HTFAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 01:00:52 -0400
Received: from leo.clearchain.com ([199.73.29.74]:53352 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0HTFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 01:00:50 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 01:00:49 EDT
From: Peter Hutterer <peter.hutterer@who-t.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pinglinux@gmail.com, rydberg@euromail.se
Cc: Peter Hutterer <peter.hutterer@who-t.net>
Subject: =?UTF-8?q?=5BPATCH=201/3=5D=20input=3A=20send=20BTN=5FTOOL=5FPEN/RUBBER=20and=20BTN=5FSTYLUS=20for=20the=20w8001=2E?=
Date: Fri, 20 Aug 2010 14:55:33 +1000
Message-Id: <1282280135-15942-2-git-send-email-peter.hutterer@who-t.net>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1282280135-15942-1-git-send-email-peter.hutterer@who-t.net>
References: <1282280135-15942-1-git-send-email-peter.hutterer@who-t.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Fri, 20 Aug 2010 14:25:01 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The protocol used by the w8001 supports status fields for tip, side
switch and eraser as well as a RDY field for proximity.

The protocol has a double usage for the f2 bit in the packet. If set,
the data is either pen + side2 button or eraser. Assume eraser if the
device comes into proximity with the f2 bit set, otherwise trigger the
side2 button.
If the device comes into proximity with the f2 bit and that bit
disappears afterwards, fake proximity out for the eraser and proximity
in for the pen.

Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
---
 drivers/input/touchscreen/wacom_w8001.c |   51 +++++++++++++++++++++++++++----
 1 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/wacom_w8001.c b/drivers/input/touchscreen/wacom_w8001.c
index 56dc35c..0e14ae1 100644
--- a/drivers/input/touchscreen/wacom_w8001.c
+++ b/drivers/input/touchscreen/wacom_w8001.c
@@ -62,6 +62,7 @@ struct w8001 {
 	unsigned char response[W8001_MAX_LENGTH];
 	unsigned char data[W8001_MAX_LENGTH];
 	char phys[32];
+	int type;
 };
 
 static void parse_data(u8 *data, struct w8001_coord *coord)
@@ -88,11 +89,49 @@ static void parse_data(u8 *data, struct w8001_coord *coord)
 	coord->tilt_y = data[8] & 0x7F;
 }
 
+static void report_pen_events(struct w8001 *w8001, struct w8001_coord *coord)
+{
+	struct input_dev *dev = w8001->dev;
+
+	/* We have 1 bit for proximity (rdy) and 3 bits for tip, side,
+	 * side2/eraser. If rdy && f2 are set, this can be either pen + side2,
+	 * or eraser. assume
+	 * - if dev is already in proximity and f2 is toggled → pen + side2
+	 * - if dev comes into proximity with f2 set → eraser
+	 * If f2 disappears after assuming eraser, fake proximity out for
+	 * eraser and in for pen.
+	 */
+
+	if (!w8001->type) {
+		w8001->type = coord->f2 ? BTN_TOOL_RUBBER : BTN_TOOL_PEN;
+	} else if (w8001->type == BTN_TOOL_RUBBER) {
+		if (!coord->f2) {
+			input_report_abs(dev, ABS_PRESSURE, 0);
+			input_report_key(dev, BTN_TOUCH, 0);
+			input_report_key(dev, BTN_STYLUS, 0);
+			input_report_key(dev, BTN_STYLUS2, 0);
+			input_report_key(dev, BTN_TOOL_RUBBER, 0);
+			input_sync(dev);
+			w8001->type = BTN_TOOL_PEN;
+		}
+	} else
+		input_report_key(dev, BTN_STYLUS2, coord->f2);
+
+	input_report_abs(dev, ABS_X, coord->x);
+	input_report_abs(dev, ABS_Y, coord->y);
+	input_report_abs(dev, ABS_PRESSURE, coord->pen_pressure);
+	input_report_key(dev, BTN_TOUCH, coord->tsw);
+	input_report_key(dev, BTN_STYLUS, coord->f1);
+	input_report_key(dev, w8001->type, coord->rdy);
+	input_sync(dev);
+	if (!coord->rdy)
+		w8001->type = 0;
+}
+
 static irqreturn_t w8001_interrupt(struct serio *serio,
 				   unsigned char data, unsigned int flags)
 {
 	struct w8001 *w8001 = serio_get_drvdata(serio);
-	struct input_dev *dev = w8001->dev;
 	struct w8001_coord coord;
 	unsigned char tmp;
 
@@ -112,11 +151,7 @@ static irqreturn_t w8001_interrupt(struct serio *serio,
 
 		w8001->idx = 0;
 		parse_data(w8001->data, &coord);
-		input_report_abs(dev, ABS_X, coord.x);
-		input_report_abs(dev, ABS_Y, coord.y);
-		input_report_abs(dev, ABS_PRESSURE, coord.pen_pressure);
-		input_report_key(dev, BTN_TOUCH, coord.tsw);
-		input_sync(dev);
+		report_pen_events(w8001, &coord);
 		break;
 
 	case 10:
@@ -221,6 +256,10 @@ static int w8001_connect(struct serio *serio, struct serio_driver *drv)
 
 	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+	input_dev->keybit[BIT_WORD(BTN_TOOL_PEN)] |= BIT_MASK(BTN_TOOL_PEN);
+	input_dev->keybit[BIT_WORD(BTN_TOOL_RUBBER)] |= BIT_MASK(BTN_TOOL_RUBBER);
+	input_dev->keybit[BIT_WORD(BTN_STYLUS)] |= BIT_MASK(BTN_STYLUS);
+	input_dev->keybit[BIT_WORD(BTN_STYLUS2)] |= BIT_MASK(BTN_STYLUS2);
 
 	serio_set_drvdata(serio, w8001);
 	err = serio_open(serio, drv);
-- 
1.7.2.1

