Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2KGHHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:07:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59944 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2KGHHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:07:39 -0500
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
Subject: [PATCH RESEND 1/7] input: ti_am335x_tsc: Step enable bits made configurable
Date: Wed, 7 Nov 2012 12:21:58 +0530
Message-ID: <1352271124-5513-2-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352271124-5513-1-git-send-email-rachna@ti.com>
References: <1352271124-5513-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has hard coded value written to
step enable bits. Now the bits are updated based
on how many steps are needed to be configured got
from platform data.

The user needs to take care not to exceed
the count more than 16. While using ADC and TSC
one should take care to set this parameter correctly.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   10 ++++++++--
 include/linux/mfd/ti_am335x_tscadc.h      |    1 -
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 7a18a8a..4369224 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -39,6 +39,7 @@ struct titsc {
 	unsigned int		irq;
 	unsigned int		wires;
 	unsigned int		x_plate_resistance;
+	unsigned int		enable_bits;
 	bool			pen_down;
 	int			steps_to_configure;
 };
@@ -57,6 +58,7 @@ static void titsc_writel(struct titsc *tsc, unsigned int reg,
 static void titsc_step_config(struct titsc *ts_dev)
 {
 	unsigned int	config;
+	unsigned int	stepenable = 0;
 	int i, total_steps;
 
 	/* Configure the Step registers */
@@ -128,7 +130,11 @@ static void titsc_step_config(struct titsc *ts_dev)
 	titsc_writel(ts_dev, REG_STEPDELAY(total_steps + 2),
 			STEPCONFIG_OPENDLY);
 
-	titsc_writel(ts_dev, REG_SE, STPENB_STEPENB_TC);
+	for (i = 0; i <= (total_steps + 2); i++)
+		stepenable |= 1 << i;
+	ts_dev->enable_bits = stepenable;
+
+	titsc_writel(ts_dev, REG_SE, ts_dev->enable_bits);
 }
 
 static void titsc_read_coordinates(struct titsc *ts_dev,
@@ -250,7 +256,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 
 	titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
 
-	titsc_writel(ts_dev, REG_SE, STPENB_STEPENB_TC);
+	titsc_writel(ts_dev, REG_SE, ts_dev->enable_bits);
 	return IRQ_HANDLED;
 }
 
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index c79ad5d..23e4f33 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -47,7 +47,6 @@
 #define STEPENB_MASK		(0x1FFFF << 0)
 #define STEPENB(val)		((val) << 0)
 #define STPENB_STEPENB		STEPENB(0x1FFFF)
-#define STPENB_STEPENB_TC	STEPENB(0x1FFF)
 
 /* IRQ enable */
 #define IRQENB_HW_PEN		BIT(0)
-- 
1.7.0.4

