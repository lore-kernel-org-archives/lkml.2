Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2GREde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:33:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56749 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2GREdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:33:25 -0400
Message-ID: <1342586000.28942.7.camel@phoenix>
Subject: [RFT][PATCH 4/5] regulator: palmas: Fix palmas_probe error handling
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 18 Jul 2012 12:33:20 +0800
In-Reply-To: <1342585811.28942.3.camel@phoenix>
References: <1342585811.28942.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below error handling cases:

1. If reading PALMAS_SMPS_CTRL fails, simply returns ret rather than goto
   err_unregister_regulator because we have not call regulator_register().
2. If palmas_ldo_init() fails, we need to call regulator_unregister() for the
   regulator we just successfully registered in this for loop iteration.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index de68347..46c7e88 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -633,7 +633,7 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 
 	ret = palmas_smps_read(palmas, PALMAS_SMPS_CTRL, &reg);
 	if (ret)
-		goto err_unregister_regulator;
+		return ret;
 
 	if (reg & PALMAS_SMPS_CTRL_SMPS12_SMPS123_EN)
 		pmic->smps123 = 1;
@@ -783,8 +783,10 @@ static __devinit int palmas_probe(struct platform_device *pdev)
 			reg_init = pdata->reg_init[id];
 			if (reg_init) {
 				ret = palmas_ldo_init(palmas, id, reg_init);
-				if (ret)
+				if (ret) {
+					regulator_unregister(pmic->rdev[id]);
 					goto err_unregister_regulator;
+				}
 			}
 		}
 	}
-- 
1.7.9.5



