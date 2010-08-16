Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0HPT0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:26:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57044 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756046Ab0HPT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:26:54 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.36] mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types
Date: Mon, 16 Aug 2010 20:26:51 +0100
Message-Id: <1281986811-2023-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver was originally tested with an additional patch which
made this unneeded but that patch had issuges and got lost on the
way to mainline, causing problems when the errors are reported.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/mfd/wm831x-irq.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index 7dabe4d..294183b 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -394,8 +394,13 @@ static int wm831x_irq_set_type(unsigned int irq, unsigned int type)
 
 	irq = irq - wm831x->irq_base;
 
-	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11)
-		return -EINVAL;
+	if (irq < WM831X_IRQ_GPIO_1 || irq > WM831X_IRQ_GPIO_11) {
+		/* Ignore internal-only IRQs */
+		if (irq >= 0 && irq < WM831X_NUM_IRQS)
+			return 0;
+		else
+			return -EINVAL;
+	}
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:
-- 
1.7.1

