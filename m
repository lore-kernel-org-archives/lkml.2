Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2FHGfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 02:35:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64888 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab2FHGfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 02:35:42 -0400
Message-ID: <1339137332.16616.0.camel@phoenix>
Subject: [PATCH] regulator: tps62360: Simplify tps62360_set_voltage_time_sel
 implementation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 14:35:32 +0800
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
 drivers/regulator/tps62360-regulator.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index e534269..d044a58 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -179,17 +179,10 @@ static int tps62360_set_voltage_time_sel(struct regulator_dev *rdev,
 		unsigned int old_selector, unsigned int new_selector)
 {
 	struct tps62360_chip *tps = rdev_get_drvdata(rdev);
-	int old_uV, new_uV;
 
-	old_uV = regulator_list_voltage_linear(rdev, old_selector);
-	if (old_uV < 0)
-		return old_uV;
-
-	new_uV = regulator_list_voltage_linear(rdev, new_selector);
-	if (new_uV < 0)
-		return new_uV;
-
-	return DIV_ROUND_UP(abs(old_uV - new_uV), tps->change_uv_per_us);
+	return DIV_ROUND_UP(abs(new_selector - old_selector) *
+			    rdev->desc->uV_step,
+			    tps->change_uv_per_us);
 }
 
 static int tps62360_set_mode(struct regulator_dev *rdev, unsigned int mode)
-- 
1.7.9.5



