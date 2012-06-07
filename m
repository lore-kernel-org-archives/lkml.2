Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107Ab2FGIiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:38:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab2FGIiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:38:18 -0400
Message-ID: <1339058289.5274.0.camel@phoenix>
Subject: [PATCH] regulator: rc5t583: Simplify rc5t583_set_voltage_time_sel
 implementation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 07 Jun 2012 16:38:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For linear mappings, we can use below equation to get the voltage difference
between new_selector and old_selector:

abs(new_selector - old_selector) * rdev->desc->uV_step

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 1d34e64..332eae8 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -70,18 +70,10 @@ static int rc5t583_set_voltage_time_sel(struct regulator_dev *rdev,
 		unsigned int old_selector, unsigned int new_selector)
 {
 	struct rc5t583_regulator *reg = rdev_get_drvdata(rdev);
-	int old_uV, new_uV;
-	old_uV = regulator_list_voltage_linear(rdev, old_selector);
 
-	if (old_uV < 0)
-		return old_uV;
-
-	new_uV = regulator_list_voltage_linear(rdev, new_selector);
-	if (new_uV < 0)
-		return new_uV;
-
-	return DIV_ROUND_UP(abs(old_uV - new_uV),
-				reg->reg_info->change_uv_per_us);
+	return DIV_ROUND_UP(abs(new_selector - old_selector) *
+			    rdev->desc->uV_step,
+			    reg->reg_info->change_uv_per_us);
 }
 
 
-- 
1.7.9.5



