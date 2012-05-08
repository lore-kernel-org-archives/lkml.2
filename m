Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2EHLqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 07:46:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49089 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2EHLqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 07:46:19 -0400
Message-ID: <1336477570.13339.4.camel@phoenix>
Subject: [PATCH RFT 1/2] regulator: da903x: Fix list voltage for da9030 ldo14
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Mike Rapoport <mike@compulab.co.il>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 08 May 2012 19:46:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da903x_list_voltage does not return correct voltage for da9030 ldo14.
Implement da9030_list_ldo14_voltage to return correct voltage for da9030 ldo14.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da903x.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 682bdb3..a9c4590 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -267,6 +267,24 @@ static int da9030_get_ldo14_voltage(struct regulator_dev *rdev)
 			info->step_uV * (val & ~0x4);
 }
 
+static int da9030_list_ldo14_voltage(struct regulator_dev *rdev,
+				     unsigned selector)
+{
+	struct da903x_regulator_info *info = rdev_get_drvdata(rdev);
+	int volt;
+
+	if (selector & 0x4)
+		volt = info->min_uV + info->step_uV * (3 - (selector & ~0x4));
+	else
+		volt = (info->max_uV + info->min_uV) / 2 +
+		       info->step_uV * (selector & ~0x4);
+
+	if (volt > info->max_uV)
+		return -EINVAL;
+
+	return volt;
+}
+
 /* DA9034 specific operations */
 static int da9034_set_dvc_voltage(struct regulator_dev *rdev,
 				  int min_uV, int max_uV, unsigned *selector)
@@ -357,7 +375,7 @@ static struct regulator_ops da903x_regulator_ldo_ops = {
 static struct regulator_ops da9030_regulator_ldo14_ops = {
 	.set_voltage	= da9030_set_ldo14_voltage,
 	.get_voltage	= da9030_get_ldo14_voltage,
-	.list_voltage	= da903x_list_voltage,
+	.list_voltage	= da9030_list_ldo14_voltage,
 	.enable		= da903x_enable,
 	.disable	= da903x_disable,
 	.is_enabled	= da903x_is_enabled,
-- 
1.7.5.4



