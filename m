Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab2BXJP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:15:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51626 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2BXJPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:15:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.224.133 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330074945.8642.1.camel@phoenix>
Subject: [PATCH RFC] regulator: Convert ab8500 to use get_voltage_sel()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>,
        Sundar R Iyer <sundar.iyer@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Fri, 24 Feb 2012 17:15:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is required to make ab8500_regulator_get_voltage_sel work.
The regulator core will call set_voltage_time_sel only when get_voltage_sel is
implemented.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi,
I don't have this hardware, I'd appreciate if someone can test this patch.

Axel
 drivers/regulator/ab8500.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index c9b9253..c7ee4c1 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -201,7 +201,7 @@ static int ab8500_list_voltage(struct regulator_dev *rdev, unsigned selector)
 	return info->voltages[selector];
 }
 
-static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
+static int ab8500_regulator_get_voltage_sel(struct regulator_dev *rdev)
 {
 	int ret, val;
 	struct ab8500_regulator_info *info = rdev_get_drvdata(rdev);
@@ -229,11 +229,9 @@ static int ab8500_regulator_get_voltage(struct regulator_dev *rdev)
 	/* vintcore has a different layout */
 	val = regval & info->voltage_mask;
 	if (info->desc.id == AB8500_LDO_INTCORE)
-		ret = info->voltages[val >> 0x3];
+		return val >> 0x3;
 	else
-		ret = info->voltages[val];
-
-	return ret;
+		return val;
 }
 
 static int ab8500_get_best_voltage_index(struct regulator_dev *rdev,
@@ -320,7 +318,7 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.enable		= ab8500_regulator_enable,
 	.disable	= ab8500_regulator_disable,
 	.is_enabled	= ab8500_regulator_is_enabled,
-	.get_voltage	= ab8500_regulator_get_voltage,
+	.get_voltage_sel = ab8500_regulator_get_voltage_sel,
 	.set_voltage	= ab8500_regulator_set_voltage,
 	.list_voltage	= ab8500_list_voltage,
 	.enable_time	= ab8500_regulator_enable_time,
-- 
1.7.5.4



