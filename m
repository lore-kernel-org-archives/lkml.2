Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030486Ab2CAB0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:26:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43881 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030457Ab2CAB0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:26:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.130.72 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330565187.5373.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: Kill max8997_get_rid function
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 01 Mar 2012 09:26:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use rdev_get_id() directly.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8997.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index bb7cd9d..9657929 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -130,15 +130,10 @@ static const struct voltage_map_desc *reg_voltage_map[] = {
 	[MAX8997_CHARGER_TOPOFF] = &topoff_current_map_desc,
 };
 
-static inline int max8997_get_rid(struct regulator_dev *rdev)
-{
-	return rdev_get_id(rdev);
-}
-
 static int max8997_list_voltage_safeout(struct regulator_dev *rdev,
 		unsigned int selector)
 {
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 
 	if (rid == MAX8997_ESAFEOUT1 || rid == MAX8997_ESAFEOUT2) {
 		switch (selector) {
@@ -161,7 +156,7 @@ static int max8997_list_voltage_safeout(struct regulator_dev *rdev,
 static int max8997_list_voltage_charger_cv(struct regulator_dev *rdev,
 		unsigned int selector)
 {
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 
 	if (rid != MAX8997_CHARGER_CV)
 		goto err;
@@ -184,7 +179,7 @@ static int max8997_list_voltage(struct regulator_dev *rdev,
 		unsigned int selector)
 {
 	const struct voltage_map_desc *desc;
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	int val;
 
 	if (rid >= ARRAY_SIZE(reg_voltage_map) ||
@@ -205,7 +200,7 @@ static int max8997_list_voltage(struct regulator_dev *rdev,
 static int max8997_get_enable_register(struct regulator_dev *rdev,
 		int *reg, int *mask, int *pattern)
 {
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 
 	switch (rid) {
 	case MAX8997_LDO1 ... MAX8997_LDO21:
@@ -325,7 +320,7 @@ static int max8997_reg_disable(struct regulator_dev *rdev)
 static int max8997_get_voltage_register(struct regulator_dev *rdev,
 		int *_reg, int *_shift, int *_mask)
 {
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask = 0x3f;
 
 	switch (rid) {
@@ -386,7 +381,7 @@ static int max8997_get_voltage(struct regulator_dev *rdev)
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
 	int reg, shift, mask, ret;
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	u8 val;
 
 	ret = max8997_get_voltage_register(rdev, &reg, &shift, &mask);
@@ -446,7 +441,7 @@ static int max8997_set_voltage_charger_cv(struct regulator_dev *rdev,
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	int lb, ub;
 	int reg, shift = 0, mask, ret = 0;
 	u8 val = 0x0;
@@ -503,7 +498,7 @@ static int max8997_set_voltage_ldobuck(struct regulator_dev *rdev,
 	struct i2c_client *i2c = max8997->iodev->i2c;
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	const struct voltage_map_desc *desc;
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
 	int i;
 	u8 org;
@@ -564,7 +559,7 @@ static int max8997_assess_side_effect(struct regulator_dev *rdev,
 		u8 new_val, int *best)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	u8 *buckx_val[3];
 	bool buckx_gpiodvs[3];
 	int side_effect[8];
@@ -641,7 +636,7 @@ static int max8997_set_voltage_buck(struct regulator_dev *rdev,
 		int min_uV, int max_uV, unsigned *selector)
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	const struct voltage_map_desc *desc;
 	int new_val, new_idx, damage, tmp_val, tmp_idx, tmp_dmg;
 	bool gpio_dvs_mode = false;
@@ -724,7 +719,7 @@ static int max8997_set_voltage_safeout(struct regulator_dev *rdev,
 {
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 	int reg, shift = 0, mask, ret;
 	int i = 0;
 	u8 val;
@@ -766,7 +761,7 @@ static int max8997_reg_disable_suspend(struct regulator_dev *rdev)
 	struct max8997_data *max8997 = rdev_get_drvdata(rdev);
 	struct i2c_client *i2c = max8997->iodev->i2c;
 	int ret, reg, mask, pattern;
-	int rid = max8997_get_rid(rdev);
+	int rid = rdev_get_id(rdev);
 
 	ret = max8997_get_enable_register(rdev, &reg, &mask, &pattern);
 	if (ret)
-- 
1.7.5.4



