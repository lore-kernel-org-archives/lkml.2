Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2JPHmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:42:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35678 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab2JPHm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:42:27 -0400
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>,
        "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH RESEND 3/8] input: TSC: ti_tscadc: set FIFO0 threshold Interrupt
Date: Tue, 16 Oct 2012 12:55:40 +0530
Message-ID: <1350372345-27108-4-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350372345-27108-1-git-send-email-rachna@ti.com>
References: <1350372345-27108-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code currently uses FIFO1 threshold interrupt.
since this is a MFD, Dedicating FIFO0 to touchscreen
and making way for other devices to use FIFO1 as well.
The FIFO can be shared between 2 devices but since the
interrupt used is threshold interrupt on FIFO1, we would
end up having wrong interrupts. Hence changing the same.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/input/touchscreen/ti_tscadc.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/ti_tscadc.c b/drivers/input/touchscreen/ti_tscadc.c
index c1bd8e5..2cc19b0 100644
--- a/drivers/input/touchscreen/ti_tscadc.c
+++ b/drivers/input/touchscreen/ti_tscadc.c
@@ -42,6 +42,7 @@
 #define REG_STEPCONFIG(n)	(0x64 + ((n - 1) * 8))
 #define REG_STEPDELAY(n)	(0x68 + ((n - 1) * 8))
 #define REG_FIFO0CNT		0xE4
+#define REG_FIFO0THR		0xE8
 #define REG_FIFO1THR		0xF4
 #define REG_FIFO0		0x100
 #define REG_FIFO1		0x200
@@ -55,6 +56,7 @@
 #define STPENB_STEPENB		STEPENB(0x7FFF)
 
 /* IRQ enable */
+#define IRQENB_FIFO0THRES	BIT(2)
 #define IRQENB_FIFO1THRES	BIT(5)
 #define IRQENB_PENUP		BIT(9)
 
@@ -277,7 +279,7 @@ static irqreturn_t tscadc_irq(int irq, void *dev)
 	unsigned int fsm;
 
 	status = tscadc_readl(ts_dev, REG_IRQSTATUS);
-	if (status & IRQENB_FIFO1THRES) {
+	if (status & IRQENB_FIFO0THRES) {
 		tscadc_read_coordinates(ts_dev, &x, &y);
 
 		z1 = tscadc_readl(ts_dev, REG_FIFO0) & 0xfff;
@@ -303,7 +305,7 @@ static irqreturn_t tscadc_irq(int irq, void *dev)
 				input_sync(input_dev);
 			}
 		}
-		irqclr |= IRQENB_FIFO1THRES;
+		irqclr |= IRQENB_FIFO0THRES;
 	}
 
 	/*
@@ -446,9 +448,9 @@ static int __devinit tscadc_probe(struct platform_device *pdev)
 	tscadc_writel(ts_dev, REG_CTRL, ctrl);
 
 	tscadc_idle_config(ts_dev);
-	tscadc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO1THRES);
+	tscadc_writel(ts_dev, REG_IRQENABLE, IRQENB_FIFO0THRES);
 	tscadc_step_config(ts_dev);
-	tscadc_writel(ts_dev, REG_FIFO1THR, ts_dev->steps_to_configure);
+	tscadc_writel(ts_dev, REG_FIFO0THR, ts_dev->steps_to_configure);
 
 	ctrl |= CNTRLREG_TSCSSENB;
 	tscadc_writel(ts_dev, REG_CTRL, ctrl);
-- 
1.7.0.4

