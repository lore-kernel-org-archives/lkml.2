Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab2DBBQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:16:14 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49131 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2DBBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:16:13 -0400
Message-ID: <1333329368.8048.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: Add missing n_voltages setting for max8925
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 02 Apr 2012 09:16:08 +0800
In-Reply-To: <1333329268.8048.1.camel@phoenix>
References: <1333329268.8048.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The n_voltages are the same for all regulators: (max - min / step) + 1 == 64.
The vol_shift is always 0, and the vol_nbits is always the same as n_voltages
setting. Thus we can remove vol_shitf and vol_nbits fields from struct
max8925_regulator_info.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8925-regulator.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index ad8b093..a62f3b5 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -42,8 +42,6 @@ struct max8925_regulator_info {
 	int	max_uV;
 	int	step_uV;
 	int	vol_reg;
-	int	vol_shift;
-	int	vol_nbits;
 	int	enable_reg;
 };
 
@@ -75,8 +73,7 @@ static int max8925_set_voltage(struct regulator_dev *rdev,
 	}
 	data = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
 	*selector = data;
-	data <<= info->vol_shift;
-	mask = ((1 << info->vol_nbits) - 1) << info->vol_shift;
+	mask = rdev->desc->n_voltages - 1;
 
 	return max8925_set_bits(info->i2c, info->vol_reg, mask, data);
 }
@@ -90,8 +87,8 @@ static int max8925_get_voltage(struct regulator_dev *rdev)
 	ret = max8925_reg_read(info->i2c, info->vol_reg);
 	if (ret < 0)
 		return ret;
-	mask = ((1 << info->vol_nbits) - 1) << info->vol_shift;
-	data = (ret & mask) >> info->vol_shift;
+	mask = rdev->desc->n_voltages - 1;
+	data = ret & mask;
 
 	return max8925_list_voltage(rdev, data);
 }
@@ -191,13 +188,12 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 		.type	= REGULATOR_VOLTAGE,			\
 		.id	= MAX8925_ID_SD##_id,			\
 		.owner	= THIS_MODULE,				\
+		.n_voltages = 64,				\
 	},							\
 	.min_uV		= min * 1000,				\
 	.max_uV		= max * 1000,				\
 	.step_uV	= step * 1000,				\
 	.vol_reg	= MAX8925_SDV##_id,			\
-	.vol_shift	= 0,					\
-	.vol_nbits	= 6,					\
 	.enable_reg	= MAX8925_SDCTL##_id,			\
 }
 
@@ -209,13 +205,12 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 		.type	= REGULATOR_VOLTAGE,			\
 		.id	= MAX8925_ID_LDO##_id,			\
 		.owner	= THIS_MODULE,				\
+		.n_voltages = 64,				\
 	},							\
 	.min_uV		= min * 1000,				\
 	.max_uV		= max * 1000,				\
 	.step_uV	= step * 1000,				\
 	.vol_reg	= MAX8925_LDOVOUT##_id,			\
-	.vol_shift	= 0,					\
-	.vol_nbits	= 6,					\
 	.enable_reg	= MAX8925_LDOCTL##_id,			\
 }
 
-- 
1.7.5.4



