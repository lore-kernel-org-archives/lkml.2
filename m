Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab2DDLws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:52:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:39958 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab2DDLwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:52:46 -0400
Message-ID: <1333540355.5672.1.camel@phoenix>
Subject: [PATCH] regulator: Fix rc5t583_regulator_probe error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 04 Apr 2012 19:52:35 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. regulator_register returns ERR_PTR on error, thus use IS_ERR to check the
   return value.
2. Fix off-by-one for unregistering the registered regulator.
   Current code does not unregister regs[0].rdev in clean_exit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/rc5t583-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/rc5t583-regulator.c b/drivers/regulator/rc5t583-regulator.c
index 37732f7..cac8a2a 100644
--- a/drivers/regulator/rc5t583-regulator.c
+++ b/drivers/regulator/rc5t583-regulator.c
@@ -312,7 +312,7 @@ static int __devinit rc5t583_regulator_probe(struct platform_device *pdev)
 skip_ext_pwr_config:
 		rdev = regulator_register(&ri->desc, &pdev->dev,
 					reg_data, reg, NULL);
-		if (IS_ERR_OR_NULL(rdev)) {
+		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev, "Failed to register regulator %s\n",
 						ri->desc.name);
 			ret = PTR_ERR(rdev);
@@ -324,7 +324,7 @@ skip_ext_pwr_config:
 	return 0;
 
 clean_exit:
-	while (--id > 0)
+	while (--id >= 0)
 		regulator_unregister(regs[id].rdev);
 
 	return ret;
-- 
1.7.5.4



