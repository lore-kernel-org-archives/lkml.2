Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2IVGk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 02:40:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64965 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IVGkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 02:40:25 -0400
Message-ID: <1348296014.12906.2.camel@phoenix>
Subject: [PATCH] leds: lm3642: Use regmap_update_bits() in lm3642_chip_init()
From: Axel Lin <axel.lin@ingics.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: "G.Shark Jeong" <gshark.jeong@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 22 Sep 2012 14:40:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use regmap_update_bits() to replace regmap_read() + regmap_write().
With this patch, we only show the error message when regmap_update_bits()
fails.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/leds/leds-lm3642.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-lm3642.c b/drivers/leds/leds-lm3642.c
index 924853b..3285006 100644
--- a/drivers/leds/leds-lm3642.c
+++ b/drivers/leds/leds-lm3642.c
@@ -95,23 +95,14 @@ struct lm3642_chip_data {
 /* chip initialize */
 static int __devinit lm3642_chip_init(struct lm3642_chip_data *chip)
 {
-	unsigned int reg_val;
 	int ret;
 	struct lm3642_platform_data *pdata = chip->pdata;
 
 	/* set enable register */
-	ret = regmap_read(chip->regmap, REG_ENABLE, &reg_val);
+	ret = regmap_update_bits(chip->regmap, REG_ENABLE, EX_PIN_ENABLE_MASK,
+				 pdata->tx_pin);
 	if (ret < 0)
-		goto out;
-
-	reg_val &= (~EX_PIN_ENABLE_MASK);
-	reg_val |= pdata->tx_pin;
-	ret = regmap_write(chip->regmap, REG_ENABLE, reg_val);
-	if (ret < 0)
-		goto out;
-
-out:
-	dev_err(chip->dev, "Failed to read REG_ENABLE Register\n");
+		dev_err(chip->dev, "Failed to update REG_ENABLE Register\n");
 	return ret;
 }
 
-- 
1.7.9.5



