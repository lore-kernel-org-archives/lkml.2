Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab2HAT3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:29:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41359 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121Ab2HAT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:29:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: irq: Only update mask bits when doing initial mask
Date: Wed,  1 Aug 2012 20:29:37 +0100
Message-Id: <1343849377-24030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't write the full register, it's possible there's bits other than the
masks in the same register which we shouldn't be changing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-irq.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 51b3cb1..c3ac97c 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -328,9 +328,11 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	/* Mask all the interrupts by default */
 	for (i = 0; i < chip->num_regs; i++) {
 		d->mask_buf[i] = d->mask_buf_def[i];
-		ret = regmap_write(map, chip->mask_base + (i * map->reg_stride
-				   * d->irq_reg_stride),
-				   d->mask_buf[i]);
+		ret = regmap_update_bits(map, chip->mask_base +
+						(i * map->reg_stride *
+						 d->irq_reg_stride),
+					 d->mask_buf[i],
+					 d->mask_buf[i]);
 		if (ret != 0) {
 			dev_err(map->dev, "Failed to set masks in 0x%x: %d\n",
 				chip->mask_base + (i * map->reg_stride), ret);
-- 
1.7.10.4

