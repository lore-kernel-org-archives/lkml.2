Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab1FBSV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:21:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36566 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754189Ab1FBSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:20:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 8/9] mfd: Allocate wm835x irq descs dynamically
Date: Thu,  2 Jun 2011 19:18:54 +0100
Message-Id: <1307038735-18788-8-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20110602181808.GA18726@opensource.wolfsonmicro.com>
 <1307038735-18788-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

This allows boards to leave the irq_base field unitialized and
prevents them having to reserve irqs in the platform.
pdata can be optional for irq support now. Without pdata the
driver allocates some free irq range. With pdata and irq_base > 0
the driver allocates exactly the specified irq.
Without pdata the irq defaults to IRQF_TRIGGER_LOW.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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

