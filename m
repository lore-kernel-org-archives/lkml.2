Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2DCPVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:21:52 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:55436 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2DCPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:21:51 -0400
Message-ID: <1333466504.4720.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: max8998: Use simple equation to get selector
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 03 Apr 2012 23:21:44 +0800
In-Reply-To: <1333466400.4720.1.camel@phoenix>
References: <1333466400.4720.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's more efficient to get the best selector by simple equation.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8998.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 5890265..90b3193 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -306,8 +306,7 @@ static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
 	int ldo = rdev_get_id(rdev);
-	int reg, shift = 0, mask, ret;
-	int i = 0;
+	int reg, shift = 0, mask, ret, i;
 
 	if (ldo >= ARRAY_SIZE(ldo_voltage_map))
 		return -EINVAL;
@@ -319,9 +318,10 @@ static int max8998_set_voltage_ldo(struct regulator_dev *rdev,
 	if (max_vol < desc->min || min_vol > desc->max)
 		return -EINVAL;
 
-	while (desc->min + desc->step*i < min_vol &&
-	       desc->min + desc->step*i < desc->max)
-		i++;
+	if (min_vol < desc->min)
+		min_vol = desc->min;
+
+	i = DIV_ROUND_UP(min_vol - desc->min, desc->step);
 
 	if (desc->min + desc->step*i > max_vol)
 		return -EINVAL;
@@ -359,7 +359,7 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	const struct voltage_map_desc *desc;
 	int buck = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
-	int difference = 0, i = 0, j = 0, previous_vol = 0;
+	int difference = 0, i, j = 0, previous_vol = 0;
 	u8 val = 0;
 	static u8 buck1_last_val;
 
@@ -374,9 +374,10 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 	if (max_vol < desc->min || min_vol > desc->max)
 		return -EINVAL;
 
-	while (desc->min + desc->step*i < min_vol &&
-	       desc->min + desc->step*i < desc->max)
-		i++;
+	if (min_vol < desc->min)
+		min_vol = desc->min;
+
+	i = DIV_ROUND_UP(min_vol - desc->min, desc->step);
 
 	if (desc->min + desc->step*i > max_vol)
 		return -EINVAL;
-- 
1.7.5.4



