Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab1FBLpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:45:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46079 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab1FBLpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:45:08 -0400
Date: Thu, 2 Jun 2011 13:45:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110602114502.GO23771@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:43:32 up 7 days,  4:45, 20 users,  load average: 1.79, 2.54, 3.38
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows boards to leave the irq_base field unitialized and
prevents them having to reserve irqs in the platform.
pdata can be optional for irq support now. Without pdata the
driver allocates some free irq range. With pdata and irq_base > 0
the driver allocates exactly the specified irq.
Without pdata the irq defaults to IRQF_TRIGGER_LOW.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/mfd/wm8350-irq.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index ed4b22a..8a1fafd 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -473,17 +473,13 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 {
 	int ret, cur_irq, i;
 	int flags = IRQF_ONESHOT;
+	int irq_base = -1;
 
 	if (!irq) {
 		dev_warn(wm8350->dev, "No interrupt support, no core IRQ\n");
 		return 0;
 	}
 
-	if (!pdata || !pdata->irq_base) {
-		dev_warn(wm8350->dev, "No interrupt support, no IRQ base\n");
-		return 0;
-	}
-
 	/* Mask top level interrupts */
 	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0xFFFF);
 
@@ -502,7 +498,17 @@ int wm8350_irq_init(struct wm8350 *wm8350, int irq,
 	wm8350->chip_irq = irq;
 	wm8350->irq_base = pdata->irq_base;
 
-	if (pdata->irq_high) {
+	if (pdata && pdata->irq_base > 0)
+		irq_base = pdata->irq_base;
+
+	wm8350->irq_base = irq_alloc_descs(irq_base, 0, ARRAY_SIZE(wm8350_irqs), 0);
+	if (wm8350->irq_base < 0) {
+		dev_warn(wm8350->dev, "Allocating irqs failed with %d\n",
+			wm8350->irq_base);
+		return 0;
+	}
+
+	if (pdata && pdata->irq_high) {
 		flags |= IRQF_TRIGGER_HIGH;
 
 		wm8350_set_bits(wm8350, WM8350_SYSTEM_CONTROL_1,
-- 
1.7.5.3

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
