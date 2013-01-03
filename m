Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3ACO2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:28:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42907 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab3ACO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:28:01 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: irq: Factor register read out of the IRQ parsing loop
Date: Thu,  3 Jan 2013 14:27:54 +0000
Message-Id: <1357223275-31441-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for adding back support for block reads.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 9129493..329be98 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -170,13 +170,6 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 		}
 	}
 
-	/*
-	 * Ignore masked IRQs and ack if we need to; we ack early so
-	 * there is no race between handling and acknowleding the
-	 * interrupt.  We assume that typically few of the interrupts
-	 * will fire simultaneously so don't worry about overhead from
-	 * doing a write per register.
-	 */
 	for (i = 0; i < data->chip->num_regs; i++) {
 		ret = regmap_read(map, chip->status_base + (i * map->reg_stride
 				   * data->irq_reg_stride),
@@ -189,7 +182,16 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
 				pm_runtime_put(map->dev);
 			return IRQ_NONE;
 		}
+	}
 
+	/*
+	 * Ignore masked IRQs and ack if we need to; we ack early so
+	 * there is no race between handling and acknowleding the
+	 * interrupt.  We assume that typically few of the interrupts
+	 * will fire simultaneously so don't worry about overhead from
+	 * doing a write per register.
+	 */
+	for (i = 0; i < data->chip->num_regs; i++) {
 		data->status_buf[i] &= ~data->mask_buf[i];
 
 		if (data->status_buf[i] && chip->ack_base) {
-- 
1.7.10.4

