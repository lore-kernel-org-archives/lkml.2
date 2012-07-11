Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2GKCGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 22:06:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46385 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab2GKCGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 22:06:41 -0400
Message-ID: <1341972394.25495.3.camel@phoenix>
Subject: [PATCH] mfd: Remove unneeded io_mutex from struct twl6040
From: Axel Lin <axel.lin@gmail.com>
To: SamuelOrtiz <sameo@linux.intel.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 10:06:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has been converted to use regmap APIs, the io_mutex is not needed.
Thus remove the io_mutex.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/twl6040-core.c  |   23 +++--------------------
 include/linux/mfd/twl6040.h |    1 -
 2 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 4ded9e7..5f620ae 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -64,19 +64,15 @@ int twl6040_reg_read(struct twl6040 *twl6040, unsigned int reg)
 	int ret;
 	unsigned int val;
 
-	mutex_lock(&twl6040->io_mutex);
 	/* Vibra control registers from cache */
 	if (unlikely(reg == TWL6040_REG_VIBCTLL ||
 		     reg == TWL6040_REG_VIBCTLR)) {
 		val = twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)];
 	} else {
 		ret = regmap_read(twl6040->regmap, reg, &val);
-		if (ret < 0) {
-			mutex_unlock(&twl6040->io_mutex);
+		if (ret < 0)
 			return ret;
-		}
 	}
-	mutex_unlock(&twl6040->io_mutex);
 
 	return val;
 }
@@ -86,12 +82,10 @@ int twl6040_reg_write(struct twl6040 *twl6040, unsigned int reg, u8 val)
 {
 	int ret;
 
-	mutex_lock(&twl6040->io_mutex);
 	ret = regmap_write(twl6040->regmap, reg, val);
 	/* Cache the vibra control registers */
 	if (reg == TWL6040_REG_VIBCTLL || reg == TWL6040_REG_VIBCTLR)
 		twl6040->vibra_ctrl_cache[VIBRACTRL_MEMBER(reg)] = val;
-	mutex_unlock(&twl6040->io_mutex);
 
 	return ret;
 }
@@ -99,23 +93,13 @@ EXPORT_SYMBOL(twl6040_reg_write);
 
 int twl6040_set_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 {
-	int ret;
-
-	mutex_lock(&twl6040->io_mutex);
-	ret = regmap_update_bits(twl6040->regmap, reg, mask, mask);
-	mutex_unlock(&twl6040->io_mutex);
-	return ret;
+	return regmap_update_bits(twl6040->regmap, reg, mask, mask);
 }
 EXPORT_SYMBOL(twl6040_set_bits);
 
 int twl6040_clear_bits(struct twl6040 *twl6040, unsigned int reg, u8 mask)
 {
-	int ret;
-
-	mutex_lock(&twl6040->io_mutex);
-	ret = regmap_update_bits(twl6040->regmap, reg, mask, 0);
-	mutex_unlock(&twl6040->io_mutex);
-	return ret;
+	return regmap_update_bits(twl6040->regmap, reg, mask, 0);
 }
 EXPORT_SYMBOL(twl6040_clear_bits);
 
@@ -573,7 +557,6 @@ static int __devinit twl6040_probe(struct i2c_client *client,
 	twl6040->irq = client->irq;
 
 	mutex_init(&twl6040->mutex);
-	mutex_init(&twl6040->io_mutex);
 	init_completion(&twl6040->ready);
 
 	twl6040->rev = twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
diff --git a/include/linux/mfd/twl6040.h b/include/linux/mfd/twl6040.h
index 6659487..dcc0e12 100644
--- a/include/linux/mfd/twl6040.h
+++ b/include/linux/mfd/twl6040.h
@@ -206,7 +206,6 @@ struct twl6040 {
 	struct regmap *regmap;
 	struct regulator_bulk_data supplies[2]; /* supplies for vio, v2v1 */
 	struct mutex mutex;
-	struct mutex io_mutex;
 	struct mutex irq_mutex;
 	struct mfd_cell cells[TWL6040_CELLS];
 	struct completion ready;
-- 
1.7.9.5



