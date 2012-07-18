Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab2GRGaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:30:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18705 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2GRGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:30:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 17 Jul 2012 23:30:08 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 3/6] mfd: tps6586x: cache register through regmap
Date: Wed, 18 Jul 2012 11:50:47 +0530
Message-ID: <1342592450-12488-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To cache the interrupt mask register, use the regmap RB_TREE
cache-ing mechanism in place of implementing it locally.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Changes V1 -> V2: 
No change, generated new patch for V2 series.
Changes V2 -> V3: 
No change, generated new patch for V3 series.

 drivers/mfd/tps6586x.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 6f59594..d59bfb7 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -104,7 +104,6 @@ struct tps6586x {
 	struct mutex		irq_lock;
 	int			irq_base;
 	u32			irq_en;
-	u8			mask_cache[5];
 	u8			mask_reg[5];
 };
 
@@ -276,12 +275,11 @@ static void tps6586x_irq_sync_unlock(struct irq_data *data)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tps6586x->mask_reg); i++) {
-		if (tps6586x->mask_reg[i] != tps6586x->mask_cache[i]) {
-			if (!WARN_ON(tps6586x_write(tps6586x->dev,
-						    TPS6586X_INT_MASK1 + i,
-						    tps6586x->mask_reg[i])))
-				tps6586x->mask_cache[i] = tps6586x->mask_reg[i];
-		}
+		int ret;
+		ret = tps6586x_write(tps6586x->dev,
+					    TPS6586X_INT_MASK1 + i,
+					    tps6586x->mask_reg[i]);
+		WARN_ON(ret);
 	}
 
 	mutex_unlock(&tps6586x->irq_lock);
@@ -328,7 +326,6 @@ static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
 
 	mutex_init(&tps6586x->irq_lock);
 	for (i = 0; i < 5; i++) {
-		tps6586x->mask_cache[i] = 0xff;
 		tps6586x->mask_reg[i] = 0xff;
 		tps6586x_write(tps6586x->dev, TPS6586X_INT_MASK1 + i, 0xff);
 	}
@@ -478,10 +475,21 @@ static struct tps6586x_platform_data *tps6586x_parse_dt(struct i2c_client *clien
 }
 #endif
 
+static bool is_volatile_reg(struct device *dev, unsigned int reg)
+{
+	/* Cache all interrupt mask register */
+	if ((reg >= TPS6586X_INT_MASK1) && (reg <= TPS6586X_INT_MASK5))
+		return false;
+
+	return true;
+}
+
 static const struct regmap_config tps6586x_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.max_register = TPS6586X_MAX_REGISTER - 1,
+	.volatile_reg = is_volatile_reg,
+	.cache_type = REGCACHE_RBTREE,
 };
 
 static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
-- 
1.7.1.1

