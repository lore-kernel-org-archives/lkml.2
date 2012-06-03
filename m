Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2FCMhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:37:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33945 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606Ab2FCMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:37:46 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: wm8350: Rely on regmap cache in interrupt controller
Date: Sun,  3 Jun 2012 13:37:23 +0100
Message-Id: <1338727044-23960-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1338727044-23960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1338727044-23960-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can just use regmap_update_bits() to achieve the same effect - it will
do the read/modify/update cycle for us.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-irq.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index 9fd01bf..624ff90 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -432,11 +432,9 @@ static void wm8350_irq_sync_unlock(struct irq_data *data)
 	for (i = 0; i < ARRAY_SIZE(wm8350->irq_masks); i++) {
 		/* If there's been a change in the mask write it back
 		 * to the hardware. */
-		if (wm8350->irq_masks[i] !=
-		    wm8350->reg_cache[WM8350_INT_STATUS_1_MASK + i])
-			WARN_ON(wm8350_reg_write(wm8350,
-					 WM8350_INT_STATUS_1_MASK + i,
-						 wm8350->irq_masks[i]));
+		WARN_ON(regmap_update_bits(wm8350->regmap,
+					   WM8350_INT_STATUS_1_MASK + i,
+					   0xffff, wm8350->irq_masks[i]));
 	}
 
 	mutex_unlock(&wm8350->irq_lock);
-- 
1.7.10

