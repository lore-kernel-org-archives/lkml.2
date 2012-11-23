Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2KWQu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:50:59 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53543 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2KWQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:50:58 -0500
Message-ID: <1353689452.3260.4.camel@phoenix>
Subject: [PATCH 1/2] regulator: as3711: Fix valid min_uV/max_UV checking in
 as3711_bound_check
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 24 Nov 2012 00:50:52 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below cases are supposed to be valid:

min_uV == max_uV == info->max_uV
min_uV == max_uV == rdev->desc->min_uV

Don't return -EINVAL for above cases.

This patch also includes below cleanups:
- Use rdev_get_drvdata(rdev) instead of rdev->reg_data.
- Remove unnecessary WARN_ON, it looks pointless.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 81578bf..5e813b9 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -69,17 +69,14 @@ static int as3711_list_voltage_dldo(struct regulator_dev *rdev,
 static int as3711_bound_check(struct regulator_dev *rdev,
 			      int *min_uV, int *max_uV)
 {
-	struct as3711_regulator_info *info = container_of(rdev->desc,
-					struct as3711_regulator_info, desc);
-	struct as3711_regulator *reg = rdev->reg_data;
-
-	WARN_ON(reg->reg_info != info);
+	struct as3711_regulator *reg = rdev_get_drvdata(rdev);
+	struct as3711_regulator_info *info = reg->reg_info;
 
 	dev_dbg(&rdev->dev, "%s(), %d, %d, %d\n", __func__,
 		*min_uV, rdev->desc->min_uV, info->max_uV);
 
 	if (*max_uV < *min_uV ||
-	    *min_uV >= info->max_uV || rdev->desc->min_uV >= *max_uV)
+	    *min_uV > info->max_uV || rdev->desc->min_uV > *max_uV)
 		return -EINVAL;
 
 	if (rdev->desc->n_voltages == 1)
-- 
1.7.9.5



