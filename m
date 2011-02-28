Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1B1VhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:37:03 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42287 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1B1VhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m1mMLhiPWAbRFrkKOpvu+INE0lPdo/ww7PhopJ5nDcN1XXY25DVMPqlAV1A3DC3+PZ
         ViuDRTosPHYSSOV+EIvSDBh+0GwCavs6c/ov2z2UE6a8Q5fUlHs0fO44OF1WhjRMXp1E
         yl9QCH5r/nxtuX0afFFdgWi1zYK3zBOQyd4L0=
From: aliaksei.katovich@gmail.com
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>
Subject: [PATCH 1/2] mfd: bq2415x charger driver
Date: Mon, 28 Feb 2011 23:36:14 +0200
Message-Id: <50f271ac79cb73c6068aa51e214a0044b8bdfd68.1298918741.git.aliaksei.katovich@nokia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <"cover.1298918741.git.aliaksei.katovich@nokia.com">
References: <"cover.1298918741.git.aliaksei.katovich@nokia.com">
In-Reply-To: <cover.1298918741.git.aliaksei.katovich@nokia.com>
References: <cover.1298918741.git.aliaksei.katovich@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aliaksei Katovich <aliaksei.katovich@nokia.com>

Added driver to support TI bq24153/6 one-cell Li-Ion chargers.

Signed-off-by: Aliaksei Katovich <aliaksei.katovich@nokia.com>
---
 drivers/mfd/bq2415x.c       |  780 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/bq2415x.h |   88 +++++
 2 files changed, 868 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/bq2415x.c
 create mode 100644 include/linux/mfd/bq2415x.h

diff --git a/drivers/mfd/bq2415x.c b/drivers/mfd/bq2415x.c
new file mode 100644
index 0000000..4d57cb4
--- /dev/null
+++ b/drivers/mfd/bq2415x.c
@@ -0,0 +1,780 @@
+/*
+ * bq2415x.c - TI BQ24153/6 one-cell Li-Ion charger driver
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Aliaksei Katovich <aliaksei.katovich@nokia.com>
+ *
+ * This software is distributed under the terms of the GNU General
+ * Public License ("GPL") as published by the Free Software Foundation,
+ * version 2 of that License.
+ */
+
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/kernel.h>
+#include <linux/regulator/driver.h>
+#include <linux/mfd/bq2415x.h>
+
+#define BQ2415X_RESET_MASK		0x80
+
+#define BQ2415X_IIN_LIMIT_500_MASK	0x40
+#define	BQ2415X_IIN_LIMIT_800_MASK	0x80
+#define	BQ2415X_IIN_LIMIT_UNLIM_MASK	0xc0
+
+static DEFINE_MUTEX(bq2415x_dev_list_mutex);
+static LIST_HEAD(bq2415x_dev_list);
+
+static struct i2c_client *bq2415x_cli;
+
+struct bq2415x_regulator {
+	struct i2c_client		*cli;
+	u8				reg;	/* associated register */
+	u8				val_summ; /* value summand */
+	u8				msk_summ; /* bit mask summand */
+	u8				msk_mult; /* bit mask multiplier */
+	u8				min_mask;
+	u8				max_mask; /* read bitmask */
+	struct regulator_init_data	init;
+	struct regulator_desc		desc;
+};
+
+struct bq2415x_device {
+	struct i2c_client		*cli;
+	struct regulator_dev		*rdev[BQ2415X_MAX_REG];
+	struct list_head		list;
+};
+
+/* i2c operations */
+
+static inline int bq2415x_i2c_read(struct i2c_client *cli, u8 reg)
+{
+	return i2c_smbus_read_byte_data(cli, reg);
+}
+
+static inline int bq2415x_i2c_write(struct i2c_client *cli, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(cli, reg, val);
+}
+
+static inline int bq2415x_enable_charger(bool flag)
+{
+	int res;
+
+	res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_GEN_CTL);
+	if (unlikely(res < 0))
+		return res;
+
+	if (flag)
+		res &= ~(BQ2415X_CE | BQ2415X_HZ_MODE);
+	else
+		res |= (BQ2415X_CE | BQ2415X_HZ_MODE);
+
+	return bq2415x_i2c_write(bq2415x_cli, BQ2415X_GEN_CTL, res);
+}
+
+static inline int bq2415x_enable_stat(bool flag)
+{
+	int res;
+
+	res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_STS_CTL);
+	if (unlikely(res < 0))
+		return res;
+
+	if (flag)
+		res |= BQ2415X_EN_STAT;
+	else
+		res &= ~BQ2415X_EN_STAT;
+
+	return bq2415x_i2c_write(bq2415x_cli, BQ2415X_STS_CTL, res);
+}
+
+static inline int bq2415x_enable_otg(bool flag)
+{
+	int res;
+
+	res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_BAT_CTL);
+	if (unlikely(res < 0))
+		return res;
+
+	if (flag)
+		res |= BQ2415X_OTG_EN;
+	else
+		res &= ~BQ2415X_OTG_EN;
+
+	return bq2415x_i2c_write(bq2415x_cli, BQ2415X_STS_CTL, res);
+}
+
+static inline int bq2415x_otg_high(bool flag)
+{
+	int res;
+
+	res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_BAT_CTL);
+	if (unlikely(res < 0))
+		return res;
+
+	if (flag)
+		res |= BQ2415X_OTG_PL;
+	else
+		res &= ~BQ2415X_OTG_PL;
+
+	return bq2415x_i2c_write(bq2415x_cli, BQ2415X_STS_CTL, res);
+}
+
+static inline int bq2415x_chg_low(bool flag)
+{
+	int res;
+
+	res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_SPC_CTL);
+	if (unlikely(res < 0))
+		return res;
+
+	if (flag)
+		res |= BQ2415X_LOW_CHG;
+	else
+		res &= ~BQ2415X_LOW_CHG;
+
+	return bq2415x_i2c_write(bq2415x_cli, BQ2415X_SPC_CTL, res);
+}
+
+/**
+ * bq2415x_exec - execute charger specific command
+ *
+ * Returns result of command execution upon success or negative otherwise
+ */
+int bq2415x_exec(enum bq2415x_cmd cmd)
+{
+	int res;
+
+	if (!bq2415x_cli)
+		return -ENODEV;
+
+	switch (cmd) {
+	case BQ2415X_ENABLE_CHARGER:
+		res = bq2415x_enable_charger(true);
+		break;
+	case BQ2415X_DISABLE_CHARGER:
+		res = bq2415x_enable_charger(false);
+		break;
+	case BQ2415X_READ_STATUS:
+		res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_STS_CTL);
+		break;
+	case BQ2415X_RESET_CHARGER:
+		res = bq2415x_i2c_write(bq2415x_cli, BQ2415X_CHG_CTL,
+					BQ2415X_RESET_MASK);
+		break;
+	case BQ2415X_RESET_WATCHDOG:
+		res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_STS_CTL);
+		if (unlikely(res < 0))
+			break;
+
+		res |= BQ2415X_TMR_RST;
+		res = bq2415x_i2c_write(bq2415x_cli, BQ2415X_STS_CTL, res);
+		break;
+	case BQ2415X_ENABLE_STAT:
+		res = bq2415x_enable_stat(true);
+		break;
+	case BQ2415X_DISABLE_STAT:
+		res = bq2415x_enable_stat(false);
+		break;
+	case BQ2415X_ENABLE_OTG:
+		res = bq2415x_enable_otg(true);
+		break;
+	case BQ2415X_DISABLE_OTG:
+		res = bq2415x_enable_otg(false);
+		break;
+	case BQ2415X_OTG_HIGH:
+		res = bq2415x_otg_high(true);
+		break;
+	case BQ2415X_OTG_LOW:
+		res = bq2415x_otg_high(false);
+		break;
+	case BQ2415X_CHG_LOW:
+		res = bq2415x_chg_low(true);
+		break;
+	case BQ2415X_CHG_NORM:
+		res = bq2415x_chg_low(false);
+		break;
+	case BQ2415X_READ_DPM:
+		res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_SPC_CTL);
+		if (res & BQ2415X_DPM_STATUS)
+			res = 1; /* DPM mode is active */
+		else
+			res = 0;
+		break;
+	case BQ2415X_READ_CD:
+		res = bq2415x_i2c_read(bq2415x_cli, BQ2415X_SPC_CTL);
+		if (res & BQ2415X_CD_STATUS)
+			res = 1; /* CD ping at HIGH level */
+		else
+			res = 0;
+		break;
+	default:
+		res = -ENOSYS;
+	}
+
+	return res;
+}
+EXPORT_SYMBOL(bq2415x_exec);
+
+static inline int bq2415x_vmap_index(unsigned val, unsigned div)
+{
+	return (val / div) - 1;
+}
+
+static inline int bq2415x_vmap_calc(unsigned i, unsigned summ, unsigned mult)
+{
+	return (i + summ) * mult;
+}
+
+/* regulator operations */
+
+static int bq2415x_list_voltage(struct regulator_dev *rdev, unsigned i)
+{
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	if (i >= r->desc.n_voltages)
+		return 0;
+
+	return bq2415x_vmap_calc(i, r->val_summ, r->init.constraints.min_uV);
+}
+
+static int
+bq2415x_set_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
+{
+	int i, res;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	i = bq2415x_vmap_index(max_uV, r->init.constraints.min_uV);
+	if (i >= r->desc.n_voltages)
+		return -EINVAL;
+
+	res = bq2415x_i2c_read(r->cli, r->reg);
+	if (res < 0)
+		return res;
+
+	res |= bq2415x_vmap_calc(i, r->msk_summ, r->msk_mult);
+	return bq2415x_i2c_write(r->cli, r->reg, res);
+}
+
+static int bq2415x_get_voltage(struct regulator_dev *rdev)
+{
+	int i, ret;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	ret = bq2415x_i2c_read(r->cli, r->reg);
+	if (ret < 0)
+		return ret;
+
+	i = bq2415x_vmap_index(ret & r->max_mask, r->min_mask);
+	if (i >= r->desc.n_voltages)
+		return -EINVAL;
+
+	return bq2415x_vmap_calc(i, r->val_summ, r->init.constraints.min_uV);
+}
+
+static int
+bq2415x_set_current_limit(struct regulator_dev *rdev, int min_uA, int max_uA)
+{
+	int res;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	res = bq2415x_i2c_read(r->cli, r->reg);
+	if (res < 0)
+		return res;
+
+	if (BQ2415X_IIN_LIMIT_100 <= min_uA && max_uA < BQ2415X_IIN_LIMIT_500)
+		res &= ~BQ2415X_IIN_LIMIT_UNLIM_MASK;
+	else if (BQ2415X_IIN_LIMIT_500 <= min_uA &&
+			max_uA < BQ2415X_IIN_LIMIT_800)
+		res |= BQ2415X_IIN_LIMIT_500_MASK;
+	else if (BQ2415X_IIN_LIMIT_800 <= min_uA &&
+			max_uA < BQ2415X_IIN_LIMIT_UNLIM)
+		res |= BQ2415X_IIN_LIMIT_800_MASK;
+	else if (BQ2415X_IIN_LIMIT_UNLIM <= min_uA)
+		res |= BQ2415X_IIN_LIMIT_UNLIM_MASK;
+	else
+		return -EINVAL;
+
+	return bq2415x_i2c_write(r->cli, r->reg, res);
+}
+
+static int bq2415x_get_current_limit(struct regulator_dev *rdev)
+{
+	int ret;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	ret = bq2415x_i2c_read(r->cli, r->reg);
+	if (ret < 0)
+		return ret;
+
+	ret &= BQ2415X_IIN_LIMIT_UNLIM_MASK;
+	if (ret == BQ2415X_IIN_LIMIT_UNLIM_MASK)
+		ret = BQ2415X_IIN_LIMIT_UNLIM;
+	else if (ret == BQ2415X_IIN_LIMIT_500_MASK)
+		ret = BQ2415X_IIN_LIMIT_500;
+	else if (ret == BQ2415X_IIN_LIMIT_800_MASK)
+		ret = BQ2415X_IIN_LIMIT_800;
+	else
+		ret = BQ2415X_IIN_LIMIT_100;
+
+	return ret;
+}
+
+static int bq2415x_v_iterm_enable(struct regulator_dev *rdev)
+{
+	int val;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	val = bq2415x_i2c_read(r->cli, BQ2415X_GEN_CTL);
+	if (val < 0)
+		return val;
+
+	val |= BQ2415X_TE;
+	return bq2415x_i2c_write(r->cli, BQ2415X_GEN_CTL, val);
+}
+
+static int bq2415x_v_iterm_disable(struct regulator_dev *rdev)
+{
+	int val;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	val = bq2415x_i2c_read(r->cli, BQ2415X_GEN_CTL);
+	if (val < 0)
+		return val;
+
+	val &= ~BQ2415X_TE;
+	return bq2415x_i2c_write(r->cli, BQ2415X_GEN_CTL, val);
+}
+
+static int bq2415x_v_iterm_is_enabled(struct regulator_dev *rdev)
+{
+	int val;
+	struct bq2415x_regulator *r = rdev_get_drvdata(rdev);
+
+	val = bq2415x_i2c_read(r->cli, BQ2415X_GEN_CTL);
+	if (val < 0)
+		return val;
+
+	return val & BQ2415X_TE;
+}
+
+/* regulator initialization */
+
+static struct regulator_ops bq2415x_c_basic_ops = {
+	.set_current_limit	= bq2415x_set_current_limit,
+	.get_current_limit	= bq2415x_get_current_limit,
+};
+
+static struct regulator_ops bq2415x_v_basic_ops = {
+	.list_voltage		= bq2415x_list_voltage,
+	.set_voltage		= bq2415x_set_voltage,
+	.get_voltage		= bq2415x_get_voltage,
+};
+
+static struct regulator_ops bq2415x_v_iterm_ops = {
+	.list_voltage		= bq2415x_list_voltage,
+	.set_voltage		= bq2415x_set_voltage,
+	.get_voltage		= bq2415x_get_voltage,
+	.enable			= bq2415x_v_iterm_enable,
+	.disable		= bq2415x_v_iterm_disable,
+	.is_enabled		= bq2415x_v_iterm_is_enabled,
+};
+
+static struct bq2415x_regulator bq2415x_regulator[] = {
+	[BQ2415X_V_LOWV] = { /* weak battery voltage */
+		.reg		= BQ2415X_GEN_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 16,
+		.min_mask	= 0x10,
+		.max_mask	= 0x30,
+		.init.constraints = {
+			.name			= "V_LOWV",
+			.min_uV			= 100000,
+			.max_uV			= 300000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_LOWV",
+			.id		= BQ2415X_V_LOWV,
+			.n_voltages     = 3,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_OREG] = { /* battery regulation */
+		.reg		= BQ2415X_BAT_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 4,
+		.min_mask	= 0x04,
+		.max_mask	= 0xfc,
+		.init.constraints = {
+			.name			= "V_OREG",
+			.min_uV			= 20000,
+			.max_uV			= 1260000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_OREG",
+			.id		= BQ2415X_V_OREG,
+			.n_voltages     = 63,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_ICHRG_VAC] = { /* charge current sense (USB) */
+		.reg		= BQ2415X_CHG_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 8,
+		.min_mask	= 0x08,
+		.max_mask	= 0x78,
+		.init.constraints = {
+			.name			= "V_ICHRG_VAC",
+			.min_uV			= 6800,
+			.max_uV			= 102000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_ICHRG_VAC",
+			.id		= BQ2415X_V_ICHRG_VAC,
+			.n_voltages     = 15,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_ICHRG_USB] = { /* charge current sense (VAC) */
+		.reg		= BQ2415X_CHG_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 2,
+		.msk_mult	= 8,
+		.min_mask	= 0x10,
+		.max_mask	= 0x40,
+		.init.constraints = {
+			.name			= "V_ICHRG_USB",
+			.min_uV			= 6800,
+			.max_uV			= 47600,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_ICHRG_USB",
+			.id		= BQ2415X_V_ICHRG_USB,
+			.n_voltages     = 7,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_ITERM] = { /* termination current sense */
+		.reg		= BQ2415X_CHG_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 1,
+		.min_mask	= 0x01,
+		.max_mask	= 0x07,
+		.init.constraints = {
+			.name			= "V_ITERM",
+			.min_uV			= 3400,
+			.max_uV			= 23800,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE |
+						  REGULATOR_CHANGE_STATUS,
+			.always_on		= 0,
+			.boot_on		= 0,
+		},
+		.desc = {
+			.name		= "V_ITERM",
+			.id		= BQ2415X_V_ITERM,
+			.n_voltages     = 7,
+			.ops		= &bq2415x_v_iterm_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_SREG] = { /* special charger */
+		.reg		= BQ2415X_SPC_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 1,
+		.min_mask	= 0x01,
+		.max_mask	= 0x07,
+		.init.constraints = {
+			.name			= "V_SREG",
+			.min_uV			= 80000,
+			.max_uV			= 560000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_SREG",
+			.id		= BQ2415X_V_SREG,
+			.n_voltages     = 7,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_MCHRG] = { /* maximum charge current */
+		.reg		= BQ2415X_SFT_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 16,
+		.min_mask	= 0x10,
+		.max_mask	= 0xf0,
+		.init.constraints = {
+			.name			= "V_MCHRG",
+			.min_uV			= 6800,
+			.max_uV			= 102000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_MCHRG",
+			.id		= BQ2415X_V_MCHRG,
+			.n_voltages     = 15,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_V_MREG] = { /* maximum battery regulation */
+		.reg		= BQ2415X_SFT_CTL,
+		.val_summ	= 1,
+		.msk_summ	= 1,
+		.msk_mult	= 1,
+		.min_mask	= 0x01,
+		.max_mask	= 0x0f,
+		.init.constraints = {
+			.name			= "V_MREG",
+			.min_uV			= 20000,
+			.max_uV			= 300000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_VOLTAGE,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "V_MREG",
+			.id		= BQ2415X_V_MREG,
+			.n_voltages     = 15,
+			.ops		= &bq2415x_v_basic_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.owner		= THIS_MODULE,
+		},
+	},
+	[BQ2415X_I_INLIMIT] = {	/* input current limit */
+		.reg		= BQ2415X_GEN_CTL,
+		.init.constraints = {
+			.name			= "I_INLIMIT",
+			.min_uA			= 100000,
+			.max_uA			= 1500000,
+			.valid_modes_mask	= REGULATOR_MODE_NORMAL,
+			.valid_ops_mask		= REGULATOR_CHANGE_CURRENT,
+			.always_on		= 1,
+			.boot_on		= 1,
+		},
+		.desc = {
+			.name		= "I_INLIMIT",
+			.id		= BQ2415X_I_INLIMIT,
+			.n_voltages     = 4,
+			.ops		= &bq2415x_c_basic_ops,
+			.type		= REGULATOR_CURRENT,
+			.owner		= THIS_MODULE,
+		},
+	},
+};
+
+static void __init bq2415x_add_consumers(struct bq2415x_regulator *r,
+					 struct regulator_init_data *init)
+{
+	int i, j, n;
+	struct regulator_consumer_supply *cons;
+
+	/* count my consumers */
+	for (i = 0, n = 0; i < init->num_consumer_supplies; i++) {
+		if (strcmp(init->consumer_supplies[i].supply,
+			   r->init.constraints.name) == 0)
+			n++;
+	}
+
+	cons = kzalloc(sizeof(*cons) * n, GFP_KERNEL);
+	if (!cons)
+		return;
+
+	/* populate my consumers table */
+	for (i = 0, j = 0; i < init->num_consumer_supplies && j < n; i++) {
+		if (!init->consumer_supplies[i].supply)
+			continue;
+		if (strcmp(init->consumer_supplies[i].supply,
+			   r->init.constraints.name) != 0)
+			continue;
+
+		cons[j].supply = init->consumer_supplies[i].supply;
+
+		if (init->consumer_supplies[i].dev)
+			cons[j].dev = init->consumer_supplies[i].dev;
+		if (init->consumer_supplies[i].dev_name)
+			cons[j].dev_name = init->consumer_supplies[i].dev_name;
+
+		j++;
+	}
+
+	r->init.num_consumer_supplies = n;
+	r->init.consumer_supplies = cons;
+}
+
+static int __devinit bq2415x_regulator_init(struct bq2415x_device *bq)
+{
+	int i;
+	struct device *dev = &bq->cli->dev;
+	struct bq2415x_regulator *r;
+	struct regulator_dev *rdev;
+	struct regulator_init_data *init = dev->platform_data;
+
+	for (i = 0; i < ARRAY_SIZE(bq2415x_regulator); i++) {
+		r = &bq2415x_regulator[i];
+		r->cli = bq->cli;
+
+		if (init)
+			bq2415x_add_consumers(r, init);
+
+		rdev = regulator_register(&r->desc, dev, &r->init, r);
+		if (IS_ERR(rdev))
+			return PTR_ERR(rdev);
+
+		bq->rdev[i] = rdev;
+	}
+
+	return 0;
+}
+
+/* driver initialization */
+
+static struct bq2415x_device *bq2415x_getdev(struct i2c_client *cli)
+{
+	struct bq2415x_device *pos, *dev = 0;
+
+	mutex_lock(&bq2415x_dev_list_mutex);
+	list_for_each_entry(pos, &bq2415x_dev_list, list) {
+		if (pos->cli == cli ||
+				(pos->cli->addr == cli->addr &&
+				pos->cli->adapter == cli->adapter)) {
+			dev = pos;
+			break;
+		}
+	}
+	mutex_unlock(&bq2415x_dev_list_mutex);
+	return dev;
+}
+
+static int bq2415x_remove(struct i2c_client *cli)
+{
+	int i;
+	struct bq2415x_device *dev = bq2415x_getdev(cli);
+
+	if (dev) {
+		for (i = 0; i < ARRAY_SIZE(dev->rdev); i++) {
+			if (dev->rdev[i])
+				regulator_unregister(dev->rdev[i]);
+		}
+
+		mutex_lock(&bq2415x_dev_list_mutex);
+		list_del(&dev->list);
+		mutex_unlock(&bq2415x_dev_list_mutex);
+		kfree(dev);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(bq2415x_regulator); i++)
+		kfree(bq2415x_regulator[i].init.consumer_supplies);
+
+	return 0;
+}
+
+static int __devinit
+bq2415x_probe(struct i2c_client *cli, const struct i2c_device_id *id)
+{
+	int rc = 0;
+	struct bq2415x_device *dev;
+
+	bq2415x_cli = cli;
+
+	if (i2c_check_functionality(cli->adapter, I2C_FUNC_I2C) == 0) {
+		dev_dbg(&cli->dev, "i2c is not supported\n");
+		return -EIO;
+	}
+
+	dev = bq2415x_getdev(cli);
+	if (dev)
+		return -EBUSY;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->cli = cli;
+	rc = bq2415x_regulator_init(dev);
+	if (rc < 0) {
+		bq2415x_remove(cli);
+	} else {
+		mutex_lock(&bq2415x_dev_list_mutex);
+		list_add(&dev->list, &bq2415x_dev_list);
+		mutex_unlock(&bq2415x_dev_list_mutex);
+	}
+
+	return rc;
+}
+
+static const struct i2c_device_id bq2415x_id[] = {
+	{ "bq24156", 0 },	/* VAC charger */
+	{ "bq24153", 0 },	/* USB charger */
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, bq2415x_id);
+
+static struct i2c_driver bq2415x_driver = {
+	.driver = {
+		.name   = "bq2415x",
+		.owner  = THIS_MODULE,
+	},
+	.id_table	= bq2415x_id,
+	.probe		= bq2415x_probe,
+	.remove		= bq2415x_remove,
+};
+
+static int __init bq2415x_init(void)
+{
+	return i2c_add_driver(&bq2415x_driver);
+}
+module_init(bq2415x_init);
+
+static void __exit bq2415x_exit(void)
+{
+	i2c_del_driver(&bq2415x_driver);
+}
+module_exit(bq2415x_exit);
+
+MODULE_AUTHOR("Aliaksei Katovich <aliaksei.katovich@nokia.com>");
+MODULE_DESCRIPTION("TI BQ24153/6 one-cell Li-Ion charger driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/bq2415x.h b/include/linux/mfd/bq2415x.h
new file mode 100644
index 0000000..fb9ecb5
--- /dev/null
+++ b/include/linux/mfd/bq2415x.h
@@ -0,0 +1,88 @@
+/*
+ * bq2415x.h - header of TI BQ24153/6 one-cell Li-Ion Charger Driver
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contact: Aliaksei Katovich <aliaksei.katovich@nokia.com>
+ *
+ * This software is distributed under the terms of the GNU General
+ * Public License ("GPL") as published by the Free Software Foundation,
+ * version 2 of that License.
+ */
+
+#ifndef __BQ2415X_H_
+#define __BQ2415X_H_
+
+#include <linux/i2c.h>
+#include <linux/regulator/machine.h>
+
+#define BQ24156_ADDR		0x6a
+#define BQ24153_ADDR		0x6b
+
+#define BQ2415X_STS_CTL		0x00	/* status/control (rw) */
+#define BQ2415X_TMR_RST		BIT(7)
+#define BQ2415X_EN_STAT		BIT(6)
+#define BQ2415X_STAT2		BIT(5)
+#define BQ2415X_STAT1		BIT(4)
+
+#define BQ2415X_GEN_CTL		0x01	/* generic control (rw) */
+#define BQ2415X_TE		BIT(3)
+#define BQ2415X_CE		BIT(2)
+#define BQ2415X_HZ_MODE		BIT(1)
+
+#define BQ2415X_BAT_CTL		0x02	/* control/battery voltage (rw) */
+#define BQ2415X_OTG_PL		BIT(1)
+#define BQ2415X_OTG_EN		BIT(0)
+
+#define BQ2415X_REV_STS		0x03	/* vender/part/revision (ro) */
+#define BQ2415X_CHG_CTL		0x04	/* battery termination/fast charge
+					 * current (rw) */
+#define BQ2415X_SPC_CTL		0x05	/* special charger voltage/enable pin
+					 * status (rw) */
+#define BQ2415X_LOW_CHG		BIT(5)
+#define BQ2415X_DPM_STATUS	BIT(4)
+#define BQ2415X_CD_STATUS	BIT(3)
+
+#define BQ2415X_SFT_CTL		0x06	/* safety limit (rw, write-once after
+					 * reset!)*/
+
+/* pre-defined input current limits, uA */
+#define BQ2415X_IIN_LIMIT_100	100000
+#define BQ2415X_IIN_LIMIT_500	500000
+#define BQ2415X_IIN_LIMIT_800	800000
+#define BQ2415X_IIN_LIMIT_UNLIM	1500000
+
+enum { /* regulator id */
+	BQ2415X_V_LOWV = 0,
+	BQ2415X_V_OREG,
+	BQ2415X_V_ICHRG_VAC,
+	BQ2415X_V_ICHRG_USB,
+	BQ2415X_V_ITERM,
+	BQ2415X_V_SREG,
+	BQ2415X_V_MCHRG,
+	BQ2415X_V_MREG,
+	BQ2415X_I_INLIMIT,
+	BQ2415X_MAX_REG,
+};
+
+enum bq2415x_cmd {
+	BQ2415X_ENABLE_CHARGER = 1,
+	BQ2415X_DISABLE_CHARGER,
+	BQ2415X_READ_STATUS,
+	BQ2415X_RESET_CHARGER,
+	BQ2415X_RESET_WATCHDOG,
+	BQ2415X_ENABLE_STAT,
+	BQ2415X_DISABLE_STAT,
+	BQ2415X_ENABLE_OTG,
+	BQ2415X_DISABLE_OTG,
+	BQ2415X_OTG_HIGH,
+	BQ2415X_OTG_LOW,
+	BQ2415X_CHG_LOW,	/* LOW_CHG bit */
+	BQ2415X_CHG_NORM,	/* LOW_CHG bit */
+	BQ2415X_READ_DPM,
+	BQ2415X_READ_CD,
+};
+
+int bq2415x_exec(enum bq2415x_cmd cmd);
+
+#endif /* __BQ2415X_H_ */
-- 
1.7.0.4

