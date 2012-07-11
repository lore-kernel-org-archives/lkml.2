Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab2GKNox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:44:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59057 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab2GKNou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:44:50 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] mfd: add tps65910 32-kHz-crystal-input init
Date: Wed, 11 Jul 2012 15:44:33 +0200
Message-Id: <1342014273-31665-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20120705152334.GH18200@sortiz-mobl>
References: <20120705152334.GH18200@sortiz-mobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace tps65910_misc_init with a dedicated init function for the
32-kHz-crystal input.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---

Hi Samuel,

How about something like this? My thought with misc_init was that it could be
extended should more simple initialisation like for the ck32k_xtal need to be
done, but perhaps it's cleaner to stick with dedicated init functions
through-out. At least for now.

Thanks,
Johan


 drivers/mfd/tps65910.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 3f27ea1..1c56379 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -68,20 +68,19 @@ static const struct regmap_config tps65910_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int __devinit tps65910_misc_init(struct tps65910 *tps65910,
+static int __devinit tps65910_ck32k_init(struct tps65910 *tps65910,
 					struct tps65910_board *pmic_pdata)
 {
-	struct device *dev = tps65910->dev;
 	int ret;
 
-	if (pmic_pdata->en_ck32k_xtal) {
-		ret = tps65910_reg_clear_bits(tps65910,
-						TPS65910_DEVCTRL,
+	if (!pmic_pdata->en_ck32k_xtal)
+		return 0;
+
+	ret = tps65910_reg_clear_bits(tps65910, TPS65910_DEVCTRL,
 						DEVCTRL_CK32K_CTRL_MASK);
-		if (ret < 0) {
-			dev_err(dev, "clear ck32k_ctrl failed: %d\n", ret);
-			return ret;
-		}
+	if (ret < 0) {
+		dev_err(tps65910->dev, "clear ck32k_ctrl failed: %d\n", ret);
+		return ret;
 	}
 
 	return 0;
@@ -265,7 +264,7 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	init_data->irq_base = pmic_plat_data->irq_base;
 
 	tps65910_irq_init(tps65910, init_data->irq, init_data);
-	tps65910_misc_init(tps65910, pmic_plat_data);
+	tps65910_ck32k_init(tps65910, pmic_plat_data);
 	tps65910_sleepinit(tps65910, pmic_plat_data);
 
 	return ret;
-- 
1.7.8.6

