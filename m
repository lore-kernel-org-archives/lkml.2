Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab2BFPpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 10:45:22 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46955 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab2BFPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 10:45:20 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Add I2C driver for Summit Microelectronics SMB347 Battery
 Charger.
To: cbou@mail.ru, linux-kernel@vger.kernel.org
Date: Mon, 06 Feb 2012 15:59:01 +0000
Message-ID: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce E. Robertson <bruce.e.robertson@intel.com>

Driver support for the Summit I²C battery charger. This is used in some
Intel devices.

Signed-off-by: Bruce E. Robertson <bruce.e.robertson@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/power/Kconfig                |    7 
 drivers/power/Makefile               |    1
 drivers/power/smb347-charger.c       | 1294 ++++++++++++++++++++++++++++++++++
 include/linux/power/smb347-charger.h |  117 +++
 4 files changed, 1420 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/smb347-charger.c
 create mode 100644 include/linux/power/smb347-charger.h


diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 3a8daf8..273c681 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -274,4 +274,11 @@ config CHARGER_MAX8998
 	  Say Y to enable support for the battery charger control sysfs and
 	  platform data of MAX8998/LP3974 PMICs.
 
+config CHARGER_SMB347
+	tristate "Summit Microelectronics SMB347 Battery Charger"
+	depends on I2C
+	help
+	  Say Y to include support for Summit Microelectronics SMB347
+	  Battery Charger.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index e429008..84d9874 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -41,3 +41,4 @@ obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
+obj-$(CONFIG_CHARGER_SMB347)	+= smb347-charger.o
diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
new file mode 100644
index 0000000..ce1694d
--- /dev/null
+++ b/drivers/power/smb347-charger.c
@@ -0,0 +1,1294 @@
+/*
+ * Summit Microelectronics SMB347 Battery Charger Driver
+ *
+ * Copyright (C) 2011, Intel Corporation
+ *
+ * Authors: Bruce E. Robertson <bruce.e.robertson@intel.com>
+ *          Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/gpio.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/power_supply.h>
+#include <linux/power/smb347-charger.h>
+#include <linux/seq_file.h>
+
+/*
+ * Configuration registers. These are mirrored to volatile RAM and can be
+ * written once %CMD_A_ALLOW_WRITE is set in %CMD_A register. They will be
+ * reloaded from non-volatile registers after POR.
+ */
+#define CFG_CHARGE_CURRENT			0x00
+#define CFG_CHARGE_CURRENT_FCC_MASK		0xe0
+#define CFG_CHARGE_CURRENT_FCC_SHIFT		5
+#define CFG_CHARGE_CURRENT_PCC_MASK		0x18
+#define CFG_CHARGE_CURRENT_PCC_SHIFT		3
+#define CFG_CHARGE_CURRENT_TC_MASK		0x07
+#define CFG_CURRENT_LIMIT			0x01
+#define CFG_CURRENT_LIMIT_DC_MASK		0xf0
+#define CFG_CURRENT_LIMIT_DC_SHIFT		4
+#define CFG_CURRENT_LIMIT_USB_MASK		0x0f
+#define CFG_FLOAT_VOLTAGE			0x03
+#define CFG_FLOAT_VOLTAGE_THRESHOLD_MASK	0xc0
+#define CFG_FLOAT_VOLTAGE_THRESHOLD_SHIFT	6
+#define CFG_STAT				0x05
+#define CFG_STAT_DISABLED			BIT(5)
+#define CFG_STAT_ACTIVE_HIGH			BIT(7)
+#define CFG_PIN					0x06
+#define CFG_PIN_EN_CTRL_MASK			0x60
+#define CFG_PIN_EN_CTRL_ACTIVE_HIGH		0x40
+#define CFG_PIN_EN_CTRL_ACTIVE_LOW		0x60
+#define CFG_PIN_EN_APSD_IRQ			BIT(1)
+#define CFG_PIN_EN_CHARGER_ERROR		BIT(2)
+#define CFG_THERM				0x07
+#define CFG_THERM_SOFT_HOT_COMPENSATION_MASK	0x03
+#define CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT	0
+#define CFG_THERM_SOFT_COLD_COMPENSATION_MASK	0x0c
+#define CFG_THERM_SOFT_COLD_COMPENSATION_SHIFT	2
+#define CFG_THERM_MONITOR_DISABLED		BIT(4)
+#define CFG_SYSOK				0x08
+#define CFG_SYSOK_SUSPEND_HARD_LIMIT_DISABLED	BIT(2)
+#define CFG_OTHER				0x09
+#define CFG_OTHER_RID_MASK			0xc0
+#define CFG_OTHER_RID_ENABLED_AUTO_OTG		0xc0
+#define CFG_OTG					0x0a
+#define CFG_OTG_TEMP_THRESHOLD_MASK		0x30
+#define CFG_OTG_TEMP_THRESHOLD_SHIFT		4
+#define CFG_OTG_CC_COMPENSATION_MASK		0xc0
+#define CFG_OTG_CC_COMPENSATION_SHIFT		6
+#define CFG_TEMP_LIMIT				0x0b
+#define CFG_TEMP_LIMIT_SOFT_HOT_MASK		0x03
+#define CFG_TEMP_LIMIT_SOFT_HOT_SHIFT		0
+#define CFG_TEMP_LIMIT_SOFT_COLD_MASK		0x0c
+#define CFG_TEMP_LIMIT_SOFT_COLD_SHIFT		2
+#define CFG_TEMP_LIMIT_HARD_HOT_MASK		0x30
+#define CFG_TEMP_LIMIT_HARD_HOT_SHIFT		4
+#define CFG_TEMP_LIMIT_HARD_COLD_MASK		0xc0
+#define CFG_TEMP_LIMIT_HARD_COLD_SHIFT		6
+#define CFG_FAULT_IRQ				0x0c
+#define CFG_FAULT_IRQ_DCIN_UV			BIT(2)
+#define CFG_STATUS_IRQ				0x0d
+#define CFG_STATUS_IRQ_TERMINATION_OR_TAPER	BIT(4)
+#define CFG_ADDRESS				0x0e
+
+/* Command registers */
+#define CMD_A					0x30
+#define CMD_A_CHG_ENABLED			BIT(1)
+#define CMD_A_SUSPEND_ENABLED			BIT(2)
+#define CMD_A_ALLOW_WRITE			BIT(7)
+#define CMD_B					0x31
+#define CMD_C					0x33
+
+/* Interrupt Status registers */
+#define IRQSTAT_A				0x35
+#define IRQSTAT_C				0x37
+#define IRQSTAT_C_TERMINATION_STAT		BIT(0)
+#define IRQSTAT_C_TERMINATION_IRQ		BIT(1)
+#define IRQSTAT_C_TAPER_IRQ			BIT(3)
+#define IRQSTAT_E				0x39
+#define IRQSTAT_E_USBIN_UV_STAT			BIT(0)
+#define IRQSTAT_E_USBIN_UV_IRQ			BIT(1)
+#define IRQSTAT_E_DCIN_UV_STAT			BIT(4)
+#define IRQSTAT_E_DCIN_UV_IRQ			BIT(5)
+#define IRQSTAT_F				0x3a
+
+/* Status registers */
+#define STAT_A					0x3b
+#define STAT_A_FLOAT_VOLTAGE_MASK		0x3f
+#define STAT_B					0x3c
+#define STAT_C					0x3d
+#define STAT_C_CHG_ENABLED			BIT(0)
+#define STAT_C_CHG_MASK				0x06
+#define STAT_C_CHG_SHIFT			1
+#define STAT_C_CHARGER_ERROR			BIT(6)
+#define STAT_E					0x3f
+
+/**
+ * struct smb347_charger - smb347 charger instance
+ * @lock: protects concurrent access to online variables
+ * @client: pointer to i2c client
+ * @mains: power_supply instance for AC/DC power
+ * @usb: power_supply instance for USB power
+ * @battery: power_supply instance for battery
+ * @mains_online: is AC/DC input connected
+ * @usb_online: is USB input connected
+ * @charging_enabled: is charging enabled
+ * @dentry: for debugfs
+ * @pdata: pointer to platform data
+ */
+struct smb347_charger {
+	struct mutex		lock;
+	struct i2c_client	*client;
+	struct power_supply	mains;
+	struct power_supply	usb;
+	struct power_supply	battery;
+	bool			mains_online;
+	bool			usb_online;
+	bool			charging_enabled;
+	struct dentry		*dentry;
+	const struct smb347_charger_platform_data *pdata;
+};
+
+/* Fast charge current in uA */
+static const unsigned int fcc_tbl[] = {
+	700000,
+	900000,
+	1200000,
+	1500000,
+	1800000,
+	2000000,
+	2200000,
+	2500000,
+};
+
+/* Pre-charge current in uA */
+static const unsigned int pcc_tbl[] = {
+	100000,
+	150000,
+	200000,
+	250000,
+};
+
+/* Termination current in uA */
+static const unsigned int tc_tbl[] = {
+	37500,
+	50000,
+	100000,
+	150000,
+	200000,
+	250000,
+	500000,
+	600000,
+};
+
+/* Input current limit in uA */
+static const unsigned int icl_tbl[] = {
+	300000,
+	500000,
+	700000,
+	900000,
+	1200000,
+	1500000,
+	1800000,
+	2000000,
+	2200000,
+	2500000,
+};
+
+/* Charge current compensation in uA */
+static const unsigned int ccc_tbl[] = {
+	250000,
+	700000,
+	900000,
+	1200000,
+};
+
+/* Convert register value to current using lookup table */
+static int hw_to_current(const unsigned int *tbl, size_t size, unsigned int val)
+{
+	if (val >= size)
+		return -EINVAL;
+	return tbl[val];
+}
+
+/* Convert current to register value using lookup table */
+static int current_to_hw(const unsigned int *tbl, size_t size, unsigned int val)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++)
+		if (val < tbl[i])
+			break;
+	return i > 0 ? i - 1 : -EINVAL;
+}
+
+static int smb347_read(struct smb347_charger *smb, u8 reg)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(smb->client, reg);
+	if (ret < 0)
+		dev_warn(&smb->client->dev, "failed to read reg 0x%x: %d\n",
+			 reg, ret);
+	return ret;
+}
+
+static int smb347_write(struct smb347_charger *smb, u8 reg, u8 val)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(smb->client, reg, val);
+	if (ret < 0)
+		dev_warn(&smb->client->dev, "failed to write reg 0x%x: %d\n",
+			 reg, ret);
+	return ret;
+}
+
+/**
+ * smb347_update_status - updates the charging status
+ * @smb: pointer to smb347 charger instance
+ *
+ * Function checks status of the charging and updates internal state
+ * accordingly. Returns %0 if there is no change in status, %1 if the
+ * status has changed and negative errno in case of failure.
+ */
+static int smb347_update_status(struct smb347_charger *smb)
+{
+	bool usb = false;
+	bool dc = false;
+	int ret;
+
+	ret = smb347_read(smb, IRQSTAT_E);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Dc and usb are set depending on whether they are enabled in
+	 * platform data _and_ whether corresponding undervoltage is set.
+	 */
+	if (smb->pdata->use_mains)
+		dc = !(ret & IRQSTAT_E_DCIN_UV_STAT);
+	if (smb->pdata->use_usb)
+		usb = !(ret & IRQSTAT_E_USBIN_UV_STAT);
+
+	mutex_lock(&smb->lock);
+	ret = smb->mains_online != dc || smb->usb_online != usb;
+	smb->mains_online = dc;
+	smb->usb_online = usb;
+	mutex_unlock(&smb->lock);
+
+	return ret;
+}
+
+/*
+ * smb347_is_online - returns whether input power source is connected
+ * @smb: pointer to smb347 charger instance
+ *
+ * Returns %true if input power source is connected. Note that this is
+ * dependent on what platform has configured for usable power sources. For
+ * example if USB is disabled, this will return %false even if the USB
+ * cable is connected.
+ */
+static bool smb347_is_online(struct smb347_charger *smb)
+{
+	bool ret;
+
+	mutex_lock(&smb->lock);
+	ret = smb->usb_online || smb->mains_online;
+	mutex_unlock(&smb->lock);
+
+	return ret;
+}
+
+/**
+ * smb347_charging_status - returns status of charging
+ * @smb: pointer to smb347 charger instance
+ *
+ * Function returns charging status. %0 means no charging is in progress,
+ * %1 means pre-charging, %2 fast-charging and %3 taper-charging.
+ */
+static int smb347_charging_status(struct smb347_charger *smb)
+{
+	int ret;
+
+	if (!smb347_is_online(smb))
+		return 0;
+
+	ret = smb347_read(smb, STAT_C);
+	if (ret < 0)
+		return 0;
+
+	return (ret & STAT_C_CHG_MASK) >> STAT_C_CHG_SHIFT;
+}
+
+static int smb347_charging_set(struct smb347_charger *smb, bool enable)
+{
+	int ret = 0;
+
+	if (smb->pdata->enable_control != SMB347_CHG_ENABLE_SW) {
+		dev_dbg(&smb->client->dev,
+			"charging enable/disable in SW disabled\n");
+		return 0;
+	}
+
+	mutex_lock(&smb->lock);
+	if (smb->charging_enabled != enable) {
+		ret = smb347_read(smb, CMD_A);
+		if (ret < 0)
+			goto out;
+
+		smb->charging_enabled = enable;
+
+		if (enable)
+			ret |= CMD_A_CHG_ENABLED;
+		else
+			ret &= ~CMD_A_CHG_ENABLED;
+
+		ret = smb347_write(smb, CMD_A, ret);
+	}
+out:
+	mutex_unlock(&smb->lock);
+	return ret;
+}
+
+static inline int smb347_charging_enable(struct smb347_charger *smb)
+{
+	return smb347_charging_set(smb, true);
+}
+
+static inline int smb347_charging_disable(struct smb347_charger *smb)
+{
+	return smb347_charging_set(smb, false);
+}
+
+static int smb347_update_online(struct smb347_charger *smb)
+{
+	int ret;
+
+	/*
+	 * Depending on whether valid power source is connected or not, we
+	 * disable or enable the charging. We do it manually because it
+	 * depends on how the platform has configured the valid inputs.
+	 */
+	if (smb347_is_online(smb)) {
+		ret = smb347_charging_enable(smb);
+		if (ret < 0)
+			dev_err(&smb->client->dev,
+				"failed to enable charging\n");
+	} else {
+		ret = smb347_charging_disable(smb);
+		if (ret < 0)
+			dev_err(&smb->client->dev,
+				"failed to disable charging\n");
+	}
+
+	return ret;
+}
+
+static int smb347_set_charge_current(struct smb347_charger *smb)
+{
+	int ret, val;
+
+	ret = smb347_read(smb, CFG_CHARGE_CURRENT);
+	if (ret < 0)
+		return ret;
+
+	if (smb->pdata->max_charge_current) {
+		val = current_to_hw(fcc_tbl, ARRAY_SIZE(fcc_tbl),
+				    smb->pdata->max_charge_current);
+		if (val < 0)
+			return val;
+
+		ret &= ~CFG_CHARGE_CURRENT_FCC_MASK;
+		ret |= val << CFG_CHARGE_CURRENT_FCC_SHIFT;
+	}
+
+	if (smb->pdata->pre_charge_current) {
+		val = current_to_hw(pcc_tbl, ARRAY_SIZE(pcc_tbl),
+				    smb->pdata->pre_charge_current);
+		if (val < 0)
+			return val;
+
+		ret &= ~CFG_CHARGE_CURRENT_PCC_MASK;
+		ret |= val << CFG_CHARGE_CURRENT_PCC_SHIFT;
+	}
+
+	if (smb->pdata->termination_current) {
+		val = current_to_hw(tc_tbl, ARRAY_SIZE(tc_tbl),
+				    smb->pdata->termination_current);
+		if (val < 0)
+			return val;
+
+		ret &= ~CFG_CHARGE_CURRENT_TC_MASK;
+		ret |= val;
+	}
+
+	return smb347_write(smb, CFG_CHARGE_CURRENT, ret);
+}
+
+static int smb347_set_current_limits(struct smb347_charger *smb)
+{
+	int ret, val;
+
+	ret = smb347_read(smb, CFG_CURRENT_LIMIT);
+	if (ret < 0)
+		return ret;
+
+	if (smb->pdata->mains_current_limit) {
+		val = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
+				    smb->pdata->mains_current_limit);
+		if (val < 0)
+			return val;
+
+		ret &= ~CFG_CURRENT_LIMIT_DC_MASK;
+		ret |= val << CFG_CURRENT_LIMIT_DC_SHIFT;
+	}
+
+	if (smb->pdata->usb_hc_current_limit) {
+		val = current_to_hw(icl_tbl, ARRAY_SIZE(icl_tbl),
+				    smb->pdata->usb_hc_current_limit);
+		if (val < 0)
+			return val;
+
+		ret &= ~CFG_CURRENT_LIMIT_USB_MASK;
+		ret |= val;
+	}
+
+	return smb347_write(smb, CFG_CURRENT_LIMIT, ret);
+}
+
+static int smb347_set_voltage_limits(struct smb347_charger *smb)
+{
+	int ret, val;
+
+	ret = smb347_read(smb, CFG_FLOAT_VOLTAGE);
+	if (ret < 0)
+		return ret;
+
+	if (smb->pdata->pre_to_fast_voltage) {
+		val = smb->pdata->pre_to_fast_voltage;
+
+		/* uV */
+		val = clamp_val(val, 2400000, 3000000) - 2400000;
+		val /= 200000;
+
+		ret &= ~CFG_FLOAT_VOLTAGE_THRESHOLD_MASK;
+		ret |= val << CFG_FLOAT_VOLTAGE_THRESHOLD_SHIFT;
+	}
+
+	if (smb->pdata->max_charge_voltage) {
+		val = smb->pdata->max_charge_voltage;
+
+		/* uV */
+		val = clamp_val(val, 3500000, 4500000) - 3500000;
+		val /= 20000;
+
+		ret |= val;
+	}
+
+	return smb347_write(smb, CFG_FLOAT_VOLTAGE, ret);
+}
+
+static int smb347_set_temp_limits(struct smb347_charger *smb)
+{
+	bool enable_therm_monitor = false;
+	int ret, val;
+
+	if (smb->pdata->chip_temp_threshold) {
+		val = smb->pdata->chip_temp_threshold;
+
+		/* degree C */
+		val = clamp_val(val, 100, 130) - 100;
+		val /= 10;
+
+		ret = smb347_read(smb, CFG_OTG);
+		if (ret < 0)
+			return ret;
+
+		ret &= ~CFG_OTG_TEMP_THRESHOLD_MASK;
+		ret |= val << CFG_OTG_TEMP_THRESHOLD_SHIFT;
+
+		ret = smb347_write(smb, CFG_OTG, ret);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = smb347_read(smb, CFG_TEMP_LIMIT);
+	if (ret < 0)
+		return ret;
+
+	if (smb->pdata->soft_cold_temp_limit != SMB347_TEMP_USE_DEFAULT) {
+		val = smb->pdata->soft_cold_temp_limit;
+
+		val = clamp_val(val, 0, 15);
+		val /= 5;
+		/* this goes from higher to lower so invert the value */
+		val = ~val & 0x3;
+
+		ret &= ~CFG_TEMP_LIMIT_SOFT_COLD_MASK;
+		ret |= val << CFG_TEMP_LIMIT_SOFT_COLD_SHIFT;
+
+		enable_therm_monitor = true;
+	}
+
+	if (smb->pdata->soft_hot_temp_limit != SMB347_TEMP_USE_DEFAULT) {
+		val = smb->pdata->soft_hot_temp_limit;
+
+		val = clamp_val(val, 40, 55) - 40;
+		val /= 5;
+
+		ret &= ~CFG_TEMP_LIMIT_SOFT_HOT_MASK;
+		ret |= val << CFG_TEMP_LIMIT_SOFT_HOT_SHIFT;
+
+		enable_therm_monitor = true;
+	}
+
+	if (smb->pdata->hard_cold_temp_limit != SMB347_TEMP_USE_DEFAULT) {
+		val = smb->pdata->hard_cold_temp_limit;
+
+		val = clamp_val(val, -5, 10) + 5;
+		val /= 5;
+		/* this goes from higher to lower so invert the value */
+		val = ~val & 0x3;
+
+		ret &= ~CFG_TEMP_LIMIT_HARD_COLD_MASK;
+		ret |= val << CFG_TEMP_LIMIT_HARD_COLD_SHIFT;
+
+		enable_therm_monitor = true;
+	}
+
+	if (smb->pdata->hard_hot_temp_limit != SMB347_TEMP_USE_DEFAULT) {
+		val = smb->pdata->hard_hot_temp_limit;
+
+		val = clamp_val(val, 50, 65) - 50;
+		val /= 5;
+
+		ret &= ~CFG_TEMP_LIMIT_HARD_HOT_MASK;
+		ret |= val << CFG_TEMP_LIMIT_HARD_HOT_SHIFT;
+
+		enable_therm_monitor = true;
+	}
+
+	ret = smb347_write(smb, CFG_TEMP_LIMIT, ret);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If any of the temperature limits are set, we also enable the
+	 * thermistor monitoring.
+	 *
+	 * When soft limits are hit, the device will start to compensate
+	 * current and/or voltage depending on the configuration.
+	 *
+	 * When hard limit is hit, the device will suspend charging
+	 * depending on the configuration.
+	 */
+	if (enable_therm_monitor) {
+		ret = smb347_read(smb, CFG_THERM);
+		if (ret < 0)
+			return ret;
+
+		ret &= ~CFG_THERM_MONITOR_DISABLED;
+
+		ret = smb347_write(smb, CFG_THERM, ret);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (smb->pdata->suspend_on_hard_temp_limit) {
+		ret = smb347_read(smb, CFG_SYSOK);
+		if (ret < 0)
+			return ret;
+
+		ret &= ~CFG_SYSOK_SUSPEND_HARD_LIMIT_DISABLED;
+
+		ret = smb347_write(smb, CFG_SYSOK, ret);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (smb->pdata->soft_temp_limit_compensation !=
+	    SMB347_SOFT_TEMP_COMPENSATE_DEFAULT) {
+		val = smb->pdata->soft_temp_limit_compensation & 0x3;
+
+		ret = smb347_read(smb, CFG_THERM);
+		if (ret < 0)
+			return ret;
+
+		ret &= ~CFG_THERM_SOFT_HOT_COMPENSATION_MASK;
+		ret |= val << CFG_THERM_SOFT_HOT_COMPENSATION_SHIFT;
+
+		ret &= ~CFG_THERM_SOFT_COLD_COMPENSATION_MASK;
+		ret |= val << CFG_THERM_SOFT_COLD_COMPENSATION_SHIFT;
+
+		ret = smb347_write(smb, CFG_THERM, ret);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (smb->pdata->charge_current_compensation) {
+		val = current_to_hw(ccc_tbl, ARRAY_SIZE(ccc_tbl),
+				    smb->pdata->charge_current_compensation);
+		if (val < 0)
+			return val;
+
+		ret = smb347_read(smb, CFG_OTG);
+		if (ret < 0)
+			return ret;
+
+		ret &= ~CFG_OTG_CC_COMPENSATION_MASK;
+		ret |= (val & 0x3) << CFG_OTG_CC_COMPENSATION_SHIFT;
+
+		ret = smb347_write(smb, CFG_OTG, ret);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
+/*
+ * smb347_set_writable - enables/disables writing to non-volatile registers
+ * @smb: pointer to smb347 charger instance
+ *
+ * You can enable/disable writing to the non-volatile configuration
+ * registers by calling this function.
+ *
+ * Returns %0 on success and negative errno in case of failure.
+ */
+static int smb347_set_writable(struct smb347_charger *smb, bool writable)
+{
+	int ret;
+
+	ret = smb347_read(smb, CMD_A);
+	if (ret < 0)
+		return ret;
+
+	if (writable)
+		ret |= CMD_A_ALLOW_WRITE;
+	else
+		ret &= ~CMD_A_ALLOW_WRITE;
+
+	return smb347_write(smb, CMD_A, ret);
+}
+
+static int smb347_hw_init(struct smb347_charger *smb)
+{
+	int ret;
+
+	ret = smb347_set_writable(smb, true);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Program the platform specific configuration values to the device
+	 * first.
+	 */
+	ret = smb347_set_charge_current(smb);
+	if (ret < 0)
+		goto fail;
+
+	ret = smb347_set_current_limits(smb);
+	if (ret < 0)
+		goto fail;
+
+	ret = smb347_set_voltage_limits(smb);
+	if (ret < 0)
+		goto fail;
+
+	ret = smb347_set_temp_limits(smb);
+	if (ret < 0)
+		goto fail;
+
+	/* If USB charging is disabled we put the USB in suspend mode */
+	if (!smb->pdata->use_usb) {
+		ret = smb347_read(smb, CMD_A);
+		if (ret < 0)
+			goto fail;
+
+		ret |= CMD_A_SUSPEND_ENABLED;
+
+		ret = smb347_write(smb, CMD_A, ret);
+		if (ret < 0)
+			goto fail;
+	}
+
+	ret = smb347_read(smb, CFG_OTHER);
+	if (ret < 0)
+		goto fail;
+
+	/*
+	 * If configured by platform data, we enable hardware Auto-OTG
+	 * support for driving VBUS. Otherwise we disable it.
+	 */
+	ret &= ~CFG_OTHER_RID_MASK;
+	if (smb->pdata->use_usb_otg)
+		ret |= CFG_OTHER_RID_ENABLED_AUTO_OTG;
+
+	ret = smb347_write(smb, CFG_OTHER, ret);
+	if (ret < 0)
+		goto fail;
+
+	ret = smb347_read(smb, CFG_PIN);
+	if (ret < 0)
+		goto fail;
+
+	/*
+	 * Make the charging functionality controllable by a write to the
+	 * command register unless pin control is specified in the platform
+	 * data.
+	 */
+	ret &= ~CFG_PIN_EN_CTRL_MASK;
+
+	switch (smb->pdata->enable_control) {
+	case SMB347_CHG_ENABLE_SW:
+		/* Do nothing, 0 means i2c control */
+		break;
+	case SMB347_CHG_ENABLE_PIN_ACTIVE_LOW:
+		ret |= CFG_PIN_EN_CTRL_ACTIVE_LOW;
+		break;
+	case SMB347_CHG_ENABLE_PIN_ACTIVE_HIGH:
+		ret |= CFG_PIN_EN_CTRL_ACTIVE_HIGH;
+		break;
+	}
+
+	/* Disable Automatic Power Source Detection (APSD) interrupt. */
+	ret &= ~CFG_PIN_EN_APSD_IRQ;
+
+	ret = smb347_write(smb, CFG_PIN, ret);
+	if (ret < 0)
+		goto fail;
+
+	ret = smb347_update_status(smb);
+	if (ret < 0)
+		goto fail;
+
+	ret = smb347_update_online(smb);
+
+fail:
+	smb347_set_writable(smb, false);
+	return ret;
+}
+
+static irqreturn_t smb347_interrupt(int irq, void *data)
+{
+	struct smb347_charger *smb = data;
+	int stat_c, irqstat_e, irqstat_c;
+	irqreturn_t ret = IRQ_NONE;
+
+	stat_c = smb347_read(smb, STAT_C);
+	if (stat_c < 0) {
+		dev_warn(&smb->client->dev, "reading STAT_C failed\n");
+		return IRQ_NONE;
+	}
+
+	irqstat_c = smb347_read(smb, IRQSTAT_C);
+	if (irqstat_c < 0) {
+		dev_warn(&smb->client->dev, "reading IRQSTAT_C failed\n");
+		return IRQ_NONE;
+	}
+
+	irqstat_e = smb347_read(smb, IRQSTAT_E);
+	if (irqstat_e < 0) {
+		dev_warn(&smb->client->dev, "reading IRQSTAT_E failed\n");
+		return IRQ_NONE;
+	}
+
+	/*
+	 * If we get charger error we report the error back to user and
+	 * disable charging.
+	 */
+	if (stat_c & STAT_C_CHARGER_ERROR) {
+		dev_err(&smb->client->dev,
+			"error in charger, disabling charging\n");
+
+		smb347_charging_disable(smb);
+		power_supply_changed(&smb->battery);
+
+		ret = IRQ_HANDLED;
+	}
+
+	/*
+	 * If we reached the termination current the battery is charged and
+	 * we can update the status now. Charging is automatically
+	 * disabled by the hardware.
+	 */
+	if (irqstat_c & (IRQSTAT_C_TERMINATION_IRQ | IRQSTAT_C_TAPER_IRQ)) {
+		if (irqstat_c & IRQSTAT_C_TERMINATION_STAT)
+			power_supply_changed(&smb->battery);
+		ret = IRQ_HANDLED;
+	}
+
+	/*
+	 * If we got an under voltage interrupt it means that AC/USB input
+	 * was connected or disconnected.
+	 */
+	if (irqstat_e & (IRQSTAT_E_USBIN_UV_IRQ | IRQSTAT_E_DCIN_UV_IRQ)) {
+		if (smb347_update_status(smb) > 0) {
+			smb347_update_online(smb);
+			power_supply_changed(&smb->mains);
+			power_supply_changed(&smb->usb);
+		}
+		ret = IRQ_HANDLED;
+	}
+
+	return ret;
+}
+
+static int smb347_irq_set(struct smb347_charger *smb, bool enable)
+{
+	int ret;
+
+	ret = smb347_set_writable(smb, true);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Enable/disable interrupts for:
+	 *	- under voltage
+	 *	- termination current reached
+	 *	- charger error
+	 */
+	if (enable) {
+		ret = smb347_write(smb, CFG_FAULT_IRQ, CFG_FAULT_IRQ_DCIN_UV);
+		if (ret < 0)
+			goto fail;
+
+		ret = smb347_write(smb, CFG_STATUS_IRQ,
+				   CFG_STATUS_IRQ_TERMINATION_OR_TAPER);
+		if (ret < 0)
+			goto fail;
+
+		ret = smb347_read(smb, CFG_PIN);
+		if (ret < 0)
+			goto fail;
+
+		ret |= CFG_PIN_EN_CHARGER_ERROR;
+
+		ret = smb347_write(smb, CFG_PIN, ret);
+	} else {
+		ret = smb347_write(smb, CFG_FAULT_IRQ, 0);
+		if (ret < 0)
+			goto fail;
+
+		ret = smb347_write(smb, CFG_STATUS_IRQ, 0);
+		if (ret < 0)
+			goto fail;
+
+		ret = smb347_read(smb, CFG_PIN);
+		if (ret < 0)
+			goto fail;
+
+		ret &= ~CFG_PIN_EN_CHARGER_ERROR;
+
+		ret = smb347_write(smb, CFG_PIN, ret);
+	}
+
+fail:
+	smb347_set_writable(smb, false);
+	return ret;
+}
+
+static inline int smb347_irq_enable(struct smb347_charger *smb)
+{
+	return smb347_irq_set(smb, true);
+}
+
+static inline int smb347_irq_disable(struct smb347_charger *smb)
+{
+	return smb347_irq_set(smb, false);
+}
+
+static int smb347_irq_init(struct smb347_charger *smb)
+{
+	const struct smb347_charger_platform_data *pdata = smb->pdata;
+	int ret, irq = gpio_to_irq(pdata->irq_gpio);
+
+	ret = gpio_request_one(pdata->irq_gpio, GPIOF_IN, smb->client->name);
+	if (ret < 0)
+		goto fail;
+
+	ret = request_threaded_irq(irq, NULL, smb347_interrupt,
+				   IRQF_TRIGGER_FALLING, smb->client->name,
+				   smb);
+	if (ret < 0)
+		goto fail_gpio;
+
+	ret = smb347_set_writable(smb, true);
+	if (ret < 0)
+		goto fail_irq;
+
+	/*
+	 * Configure the STAT output to be suitable for interrupts: disable
+	 * all other output (except interrupts) and make it active low.
+	 */
+	ret = smb347_read(smb, CFG_STAT);
+	if (ret < 0)
+		goto fail_readonly;
+
+	ret &= ~CFG_STAT_ACTIVE_HIGH;
+	ret |= CFG_STAT_DISABLED;
+
+	ret = smb347_write(smb, CFG_STAT, ret);
+	if (ret < 0)
+		goto fail_readonly;
+
+	ret = smb347_irq_enable(smb);
+	if (ret < 0)
+		goto fail_readonly;
+
+	smb347_set_writable(smb, false);
+	smb->client->irq = irq;
+	return 0;
+
+fail_readonly:
+	smb347_set_writable(smb, false);
+fail_irq:
+	free_irq(irq, smb);
+fail_gpio:
+	gpio_free(pdata->irq_gpio);
+fail:
+	smb->client->irq = 0;
+	return ret;
+}
+
+static int smb347_mains_get_property(struct power_supply *psy,
+				     enum power_supply_property prop,
+				     union power_supply_propval *val)
+{
+	struct smb347_charger *smb =
+		container_of(psy, struct smb347_charger, mains);
+
+	if (prop == POWER_SUPPLY_PROP_ONLINE) {
+		val->intval = smb->mains_online;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static enum power_supply_property smb347_mains_properties[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static int smb347_usb_get_property(struct power_supply *psy,
+				   enum power_supply_property prop,
+				   union power_supply_propval *val)
+{
+	struct smb347_charger *smb =
+		container_of(psy, struct smb347_charger, usb);
+
+	if (prop == POWER_SUPPLY_PROP_ONLINE) {
+		val->intval = smb->usb_online;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static enum power_supply_property smb347_usb_properties[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static int smb347_battery_get_property(struct power_supply *psy,
+				       enum power_supply_property prop,
+				       union power_supply_propval *val)
+{
+	struct smb347_charger *smb =
+			container_of(psy, struct smb347_charger, battery);
+	const struct smb347_charger_platform_data *pdata = smb->pdata;
+	int ret;
+
+	ret = smb347_update_status(smb);
+	if (ret < 0)
+		return ret;
+
+	switch (prop) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (!smb347_is_online(smb)) {
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+			break;
+		}
+		if (smb347_charging_status(smb))
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		if (!smb347_is_online(smb))
+			return -ENODATA;
+
+		/*
+		 * We handle trickle and pre-charging the same, and taper
+		 * and none the same.
+		 */
+		switch (smb347_charging_status(smb)) {
+		case 1:
+			val->intval = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+			break;
+		case 2:
+			val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
+			break;
+		default:
+			val->intval = POWER_SUPPLY_CHARGE_TYPE_NONE;
+			break;
+		}
+		break;
+
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = pdata->battery_info.technology;
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = pdata->battery_info.voltage_min_design;
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = pdata->battery_info.voltage_max_design;
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		if (!smb347_is_online(smb))
+			return -ENODATA;
+		ret = smb347_read(smb, STAT_A);
+		if (ret < 0)
+			return ret;
+
+		ret &= STAT_A_FLOAT_VOLTAGE_MASK;
+		if (ret > 0x3d)
+			ret = 0x3d;
+
+		val->intval = 3500000 + ret * 20000;
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		if (!smb347_is_online(smb))
+			return -ENODATA;
+
+		ret = smb347_read(smb, STAT_B);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * The current value is composition of FCC and PCC values
+		 * and we can detect which table to use from bit 5.
+		 */
+		if (ret & 0x20) {
+			val->intval = hw_to_current(fcc_tbl,
+						    ARRAY_SIZE(fcc_tbl),
+						    ret & 7);
+		} else {
+			ret >>= 3;
+			val->intval = hw_to_current(pcc_tbl,
+						    ARRAY_SIZE(pcc_tbl),
+						    ret & 7);
+		}
+		break;
+
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = pdata->battery_info.charge_full_design;
+		break;
+
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = pdata->battery_info.name;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static enum power_supply_property smb347_battery_properties[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+};
+
+static int smb347_debugfs_show(struct seq_file *s, void *data)
+{
+	struct smb347_charger *smb = s->private;
+	int ret;
+	u8 reg;
+
+	seq_printf(s, "Control registers:\n");
+	seq_printf(s, "==================\n");
+	for (reg = CFG_CHARGE_CURRENT; reg <= CFG_ADDRESS; reg++) {
+		ret = smb347_read(smb, reg);
+		seq_printf(s, "0x%02x:\t0x%02x\n", reg, ret);
+	}
+	seq_printf(s, "\n");
+
+	seq_printf(s, "Command registers:\n");
+	seq_printf(s, "==================\n");
+	ret = smb347_read(smb, CMD_A);
+	seq_printf(s, "0x%02x:\t0x%02x\n", CMD_A, ret);
+	ret = smb347_read(smb, CMD_B);
+	seq_printf(s, "0x%02x:\t0x%02x\n", CMD_B, ret);
+	ret = smb347_read(smb, CMD_C);
+	seq_printf(s, "0x%02x:\t0x%02x\n", CMD_C, ret);
+	seq_printf(s, "\n");
+
+	seq_printf(s, "Interrupt status registers:\n");
+	seq_printf(s, "===========================\n");
+	for (reg = IRQSTAT_A; reg <= IRQSTAT_F; reg++) {
+		ret = smb347_read(smb, reg);
+		seq_printf(s, "0x%02x:\t0x%02x\n", reg, ret);
+	}
+	seq_printf(s, "\n");
+
+	seq_printf(s, "Status registers:\n");
+	seq_printf(s, "=================\n");
+	for (reg = STAT_A; reg <= STAT_E; reg++) {
+		ret = smb347_read(smb, reg);
+		seq_printf(s, "0x%02x:\t0x%02x\n", reg, ret);
+	}
+
+	return 0;
+}
+
+static int smb347_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smb347_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations smb347_debugfs_fops = {
+	.open		= smb347_debugfs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int smb347_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	static char *battery[] = { "smb347-battery" };
+	const struct smb347_charger_platform_data *pdata;
+	struct device *dev = &client->dev;
+	struct smb347_charger *smb;
+	int ret;
+
+	pdata = dev->platform_data;
+	if (!pdata)
+		return -EINVAL;
+
+	if (!pdata->use_mains && !pdata->use_usb)
+		return -EINVAL;
+
+	smb = devm_kzalloc(dev, sizeof(*smb), GFP_KERNEL);
+	if (!smb)
+		return -ENOMEM;
+
+	i2c_set_clientdata(client, smb);
+
+	mutex_init(&smb->lock);
+	smb->client = client;
+	smb->pdata = pdata;
+
+	ret = smb347_hw_init(smb);
+	if (ret < 0)
+		return ret;
+
+	smb->mains.name = "smb347-mains";
+	smb->mains.type = POWER_SUPPLY_TYPE_MAINS;
+	smb->mains.get_property = smb347_mains_get_property;
+	smb->mains.properties = smb347_mains_properties;
+	smb->mains.num_properties = ARRAY_SIZE(smb347_mains_properties);
+	smb->mains.supplied_to = battery;
+	smb->mains.num_supplicants = ARRAY_SIZE(battery);
+
+	smb->usb.name = "smb347-usb";
+	smb->usb.type = POWER_SUPPLY_TYPE_USB;
+	smb->usb.get_property = smb347_usb_get_property;
+	smb->usb.properties = smb347_usb_properties;
+	smb->usb.num_properties = ARRAY_SIZE(smb347_usb_properties);
+	smb->usb.supplied_to = battery;
+	smb->usb.num_supplicants = ARRAY_SIZE(battery);
+
+	smb->battery.name = "smb347-battery";
+	smb->battery.type = POWER_SUPPLY_TYPE_BATTERY;
+	smb->battery.get_property = smb347_battery_get_property;
+	smb->battery.properties = smb347_battery_properties;
+	smb->battery.num_properties = ARRAY_SIZE(smb347_battery_properties);
+
+	ret = power_supply_register(dev, &smb->mains);
+	if (ret < 0)
+		return ret;
+
+	ret = power_supply_register(dev, &smb->usb);
+	if (ret < 0) {
+		power_supply_unregister(&smb->mains);
+		return ret;
+	}
+
+	ret = power_supply_register(dev, &smb->battery);
+	if (ret < 0) {
+		power_supply_unregister(&smb->usb);
+		power_supply_unregister(&smb->mains);
+		return ret;
+	}
+
+	/*
+	 * Interrupt pin is optional. If it is connected, we setup the
+	 * interrupt support here.
+	 */
+	if (pdata->irq_gpio >= 0) {
+		ret = smb347_irq_init(smb);
+		if (ret < 0) {
+			dev_warn(dev, "failed to initialize IRQ: %d\n", ret);
+			dev_warn(dev, "disabling IRQ support\n");
+		}
+	}
+
+	smb->dentry = debugfs_create_file("smb347-regs", S_IRUSR, NULL, smb,
+					  &smb347_debugfs_fops);
+	return 0;
+}
+
+static int smb347_remove(struct i2c_client *client)
+{
+	struct smb347_charger *smb = i2c_get_clientdata(client);
+
+	if (!IS_ERR_OR_NULL(smb->dentry))
+		debugfs_remove(smb->dentry);
+
+	if (client->irq) {
+		smb347_irq_disable(smb);
+		free_irq(client->irq, smb);
+		gpio_free(smb->pdata->irq_gpio);
+	}
+
+	power_supply_unregister(&smb->battery);
+	power_supply_unregister(&smb->usb);
+	power_supply_unregister(&smb->mains);
+	return 0;
+}
+
+static const struct i2c_device_id smb347_id[] = {
+	{ "smb347", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, smb347_id);
+
+static struct i2c_driver smb347_driver = {
+	.driver = {
+		.name = "smb347",
+	},
+	.probe        = smb347_probe,
+	.remove       = __devexit_p(smb347_remove),
+	.id_table     = smb347_id,
+};
+
+static int __init smb347_init(void)
+{
+	return i2c_add_driver(&smb347_driver);
+}
+module_init(smb347_init);
+
+static void __exit smb347_exit(void)
+{
+	i2c_del_driver(&smb347_driver);
+}
+module_exit(smb347_exit);
+
+MODULE_AUTHOR("Bruce E. Robertson <bruce.e.robertson@intel.com>");
+MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
+MODULE_DESCRIPTION("SMB347 battery charger driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("i2c:smb347");
diff --git a/include/linux/power/smb347-charger.h b/include/linux/power/smb347-charger.h
new file mode 100644
index 0000000..b3cb20d
--- /dev/null
+++ b/include/linux/power/smb347-charger.h
@@ -0,0 +1,117 @@
+/*
+ * Summit Microelectronics SMB347 Battery Charger Driver
+ *
+ * Copyright (C) 2011, Intel Corporation
+ *
+ * Authors: Bruce E. Robertson <bruce.e.robertson@intel.com>
+ *          Mika Westerberg <mika.westerberg@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SMB347_CHARGER_H
+#define SMB347_CHARGER_H
+
+#include <linux/types.h>
+#include <linux/power_supply.h>
+
+enum {
+	/* use the default compensation method */
+	SMB347_SOFT_TEMP_COMPENSATE_DEFAULT = -1,
+
+	SMB347_SOFT_TEMP_COMPENSATE_NONE,
+	SMB347_SOFT_TEMP_COMPENSATE_CURRENT,
+	SMB347_SOFT_TEMP_COMPENSATE_VOLTAGE,
+};
+
+/* Use default factory programmed value for hard/soft temperature limit */
+#define SMB347_TEMP_USE_DEFAULT		-273
+
+/*
+ * Charging enable can be controlled by software (via i2c) by
+ * smb347-charger driver or by EN pin (active low/high).
+ */
+enum smb347_chg_enable {
+	SMB347_CHG_ENABLE_SW,
+	SMB347_CHG_ENABLE_PIN_ACTIVE_LOW,
+	SMB347_CHG_ENABLE_PIN_ACTIVE_HIGH,
+};
+
+/**
+ * struct smb347_charger_platform_data - platform data for SMB347 charger
+ * @battery_info: Information about the battery
+ * @max_charge_current: maximum current (in uA) the battery can be charged
+ * @max_charge_voltage: maximum voltage (in uV) the battery can be charged
+ * @pre_charge_current: current (in uA) to use in pre-charging phase
+ * @termination_current: current (in uA) used to determine when the
+ *			 charging cycle terminates
+ * @pre_to_fast_voltage: voltage (in uV) treshold used for transitioning to
+ *			 pre-charge to fast charge mode
+ * @mains_current_limit: maximum input current drawn from AC/DC input (in uA)
+ * @usb_hc_current_limit: maximum input high current (in uA) drawn from USB
+ *			  input
+ * @chip_temp_threshold: die temperature where device starts limiting charge
+ *			 current [%100 - %130] (in degree C)
+ * @soft_cold_temp_limit: soft cold temperature limit [%0 - %15] (in degree C),
+ *			  granularity is 5 deg C.
+ * @soft_hot_temp_limit: soft hot temperature limit [%40 - %55] (in degree  C),
+ *			 granularity is 5 deg C.
+ * @hard_cold_temp_limit: hard cold temperature limit [%-5 - %10] (in degree C),
+ *			  granularity is 5 deg C.
+ * @hard_hot_temp_limit: hard hot temperature limit [%50 - %65] (in degree C),
+ *			 granularity is 5 deg C.
+ * @suspend_on_hard_temp_limit: suspend charging when hard limit is hit
+ * @soft_temp_limit_compensation: compensation method when soft temperature
+ *				  limit is hit
+ * @charge_current_compensation: current (in uA) for charging compensation
+ *				 current when temperature hits soft limits
+ * @use_mains: AC/DC input can be used
+ * @use_usb: USB input can be used
+ * @use_usb_otg: USB OTG output can be used (not implemented yet)
+ * @irq_gpio: GPIO number used for interrupts (%-1 if not used)
+ * @enable_control: how charging enable/disable is controlled
+ *		    (driver/pin controls)
+ *
+ * @use_main, @use_usb, and @use_usb_otg are means to enable/disable
+ * hardware support for these. This is useful when we want to have for
+ * example OTG charging controlled via OTG transceiver driver and not by
+ * the SMB347 hardware.
+ *
+ * Hard and soft temperature limit values are given as described in the
+ * device data sheet and assuming NTC beta value is %3750. Even if this is
+ * not the case, these values should be used. They can be mapped to the
+ * corresponding NTC beta values with the help of table %2 in the data
+ * sheet. So for example if NTC beta is %3375 and we want to program hard
+ * hot limit to be %53 deg C, @hard_hot_temp_limit should be set to %50.
+ *
+ * If zero value is given in any of the current and voltage values, the
+ * factory programmed default will be used. For soft/hard temperature
+ * values, pass in %SMB347_TEMP_USE_DEFAULT instead.
+ */
+struct smb347_charger_platform_data {
+	struct power_supply_info battery_info;
+	unsigned int	max_charge_current;
+	unsigned int	max_charge_voltage;
+	unsigned int	pre_charge_current;
+	unsigned int	termination_current;
+	unsigned int	pre_to_fast_voltage;
+	unsigned int	mains_current_limit;
+	unsigned int	usb_hc_current_limit;
+	unsigned int	chip_temp_threshold;
+	int		soft_cold_temp_limit;
+	int		soft_hot_temp_limit;
+	int		hard_cold_temp_limit;
+	int		hard_hot_temp_limit;
+	bool		suspend_on_hard_temp_limit;
+	unsigned int	soft_temp_limit_compensation;
+	unsigned int	charge_current_compensation;
+	bool		use_mains;
+	bool		use_usb;
+	bool		use_usb_otg;
+	int		irq_gpio;
+	enum smb347_chg_enable enable_control;
+};
+
+#endif /* SMB347_CHARGER_H */

