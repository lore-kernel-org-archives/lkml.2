Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2KGHIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:08:51 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50989 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353Ab2KGHHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:07:41 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 3/7] input: ti_am335x_tsc: Add variance filter
Date: Wed, 7 Nov 2012 12:22:00 +0530
Message-ID: <1352271124-5513-4-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352271124-5513-1-git-send-email-rachna@ti.com>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only fine tuning variance parameter present in tslib
utility does not help in removing all the ADC noise.
This logic of filtering is necessary to get this
touchscreen to work finely.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 6a817a8..7a26810 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -32,6 +32,8 @@
 #define ADCFSM_STEPID		0x10
 #define SEQ_SETTLE		275
 #define MAX_12BIT		((1 << 12) - 1)
+#define TSCADC_DELTA_X		15
+#define TSCADC_DELTA_Y		15
 
 /*
  * Refer to function regbit_map() to
@@ -51,6 +53,8 @@ struct titsc {
 	unsigned int		wires;
 	unsigned int		x_plate_resistance;
 	unsigned int		enable_bits;
+	unsigned int		bckup_x;
+	unsigned int		bckup_y;
 	bool			pen_down;
 	int			steps_to_configure;
 	int			config_inp[20];
@@ -309,12 +313,18 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 	unsigned int z1, z2, z;
 	unsigned int fsm;
 	unsigned int fifo1count, fifo0count;
+	unsigned int diffx = 0, diffy = 0;
 	int i;
 
 	status = titsc_readl(ts_dev, REG_IRQSTATUS);
 	if (status & IRQENB_FIFO0THRES) {
 		titsc_read_coordinates(ts_dev, &x, &y);
 
+		diffx = abs(x - (ts_dev->bckup_x));
+		diffy = abs(y - (ts_dev->bckup_y));
+		ts_dev->bckup_x = x;
+		ts_dev->bckup_y = y;
+
 		z1 = titsc_readl(ts_dev, REG_FIFO0) & 0xfff;
 		z2 = titsc_readl(ts_dev, REG_FIFO1) & 0xfff;
 
@@ -338,7 +348,8 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 			z /= z1;
 			z = (z + 2047) >> 12;
 
-			if (z <= MAX_12BIT) {
+			if ((diffx < TSCADC_DELTA_X) &&
+			(diffy < TSCADC_DELTA_Y) && (z <= MAX_12BIT)) {
 				input_report_abs(input_dev, ABS_X, x);
 				input_report_abs(input_dev, ABS_Y, y);
 				input_report_abs(input_dev, ABS_PRESSURE, z);
@@ -361,6 +372,8 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 		fsm = titsc_readl(ts_dev, REG_ADCFSM);
 		if (fsm == ADCFSM_STEPID) {
 			ts_dev->pen_down = false;
+			ts_dev->bckup_x = 0;
+			ts_dev->bckup_y = 0;
 			input_report_key(input_dev, BTN_TOUCH, 0);
 			input_report_abs(input_dev, ABS_PRESSURE, 0);
 			input_sync(input_dev);
-- 
1.7.0.4

