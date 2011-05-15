Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1EOXiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:38:52 -0400
Received: from mail.df.lth.se ([194.47.250.12]:10293 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab1EOXiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:38:50 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 13/13] mach-ux500: voltage domain regulators for DB8500
Date: Mon, 16 May 2011 01:38:47 +0200
Message-Id: <1305502727-367-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>

The DB8500 has ePOD:s (electronic power domains) which are possible
to switch on/off to deactivate silicon blocks on the DB8500 SoC
by cutting their power without retention. We model these as simple
regulators with one bit on/off settings.

Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Signed-off-by: Sundar Iyer <sundar.iyer@stericsson.com>
Signed-off-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Signed-off-by: Martin Persson <martin.persson@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/Kconfig            |    1 +
 drivers/mfd/db8500-prcmu.c             |  179 ++++++++++
 drivers/regulator/Kconfig              |    7 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/db8500-prcmu.c       |  560 ++++++++++++++++++++++++++++++++
 include/linux/regulator/db8500-prcmu.h |   45 +++
 6 files changed, 793 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/db8500-prcmu.c
 create mode 100644 include/linux/regulator/db8500-prcmu.h

diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index 365c4c3..54429d0 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -17,6 +17,7 @@ config UX500_SOC_DB5500
 config UX500_SOC_DB8500
 	bool "DB8500"
 	select MFD_DB8500_PRCMU
+	select REGULATOR_DB8500_PRCMU
 
 endmenu
 
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index c44725b..e637821 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -28,6 +28,8 @@
 #include <linux/uaccess.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/db8500-prcmu.h>
+#include <linux/regulator/db8500-prcmu.h>
+#include <linux/regulator/machine.h>
 #include <mach/hardware.h>
 #include <mach/irqs.h>
 #include <mach/db8500-regs.h>
@@ -1824,9 +1826,186 @@ void __init prcmu_early_init(void)
 	}
 }
 
+/*
+ * Power domain switches (ePODs) modeled as regulators for the DB8500 SoC
+ */
+static struct regulator_consumer_supply db8500_vape_consumers[] = {
+	REGULATOR_SUPPLY("v-ape", NULL),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.0"),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.1"),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.2"),
+	REGULATOR_SUPPLY("v-i2c", "nmk-i2c.3"),
+	/* "v-mmc" changed to "vcore" in the mainline kernel */
+	REGULATOR_SUPPLY("vcore", "sdi0"),
+	REGULATOR_SUPPLY("vcore", "sdi1"),
+	REGULATOR_SUPPLY("vcore", "sdi2"),
+	REGULATOR_SUPPLY("vcore", "sdi3"),
+	REGULATOR_SUPPLY("vcore", "sdi4"),
+	REGULATOR_SUPPLY("v-dma", "dma40.0"),
+	REGULATOR_SUPPLY("v-ape", "ab8500-usb.0"),
+	/* "v-uart" changed to "vcore" in the mainline kernel */
+	REGULATOR_SUPPLY("vcore", "uart0"),
+	REGULATOR_SUPPLY("vcore", "uart1"),
+	REGULATOR_SUPPLY("vcore", "uart2"),
+	REGULATOR_SUPPLY("v-ape", "nmk-ske-keypad.0"),
+};
+
+static struct regulator_consumer_supply db8500_vsmps2_consumers[] = {
+	/* CG2900 and CW1200 power to off-chip peripherals */
+	REGULATOR_SUPPLY("gbf_1v8", "cg2900-uart.0"),
+	REGULATOR_SUPPLY("wlan_1v8", "cw1200.0"),
+	REGULATOR_SUPPLY("musb_1v8", "ab8500-usb.0"),
+	/* AV8100 regulator */
+	REGULATOR_SUPPLY("hdmi_1v8", "0-0070"),
+};
+
+static struct regulator_consumer_supply db8500_b2r2_mcde_consumers[] = {
+	REGULATOR_SUPPLY("vsupply", "b2r2.0"),
+	REGULATOR_SUPPLY("vsupply", "mcde.0"),
+};
+
+static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
+	[DB8500_REGULATOR_VAPE] = {
+		.constraints = {
+			.name = "db8500-vape",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.consumer_supplies = db8500_vape_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_vape_consumers),
+	},
+	[DB8500_REGULATOR_VARM] = {
+		.constraints = {
+			.name = "db8500-varm",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_VMODEM] = {
+		.constraints = {
+			.name = "db8500-vmodem",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_VPLL] = {
+		.constraints = {
+			.name = "db8500-vpll",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_VSMPS1] = {
+		.constraints = {
+			.name = "db8500-vsmps1",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_VSMPS2] = {
+		.constraints = {
+			.name = "db8500-vsmps2",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.consumer_supplies = db8500_vsmps2_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_vsmps2_consumers),
+	},
+	[DB8500_REGULATOR_VSMPS3] = {
+		.constraints = {
+			.name = "db8500-vsmps3",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_VRF1] = {
+		.constraints = {
+			.name = "db8500-vrf1",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SVAMMDSP] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-sva-mmdsp",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SVAMMDSPRET] = {
+		.constraints = {
+			/* "ret" means "retention" */
+			.name = "db8500-sva-mmdsp-ret",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SVAPIPE] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-sva-pipe",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SIAMMDSP] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-sia-mmdsp",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SIAMMDSPRET] = {
+		.constraints = {
+			.name = "db8500-sia-mmdsp-ret",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SIAPIPE] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-sia-pipe",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SGA] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-sga",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_B2R2_MCDE] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-b2r2-mcde",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+		.consumer_supplies = db8500_b2r2_mcde_consumers,
+		.num_consumer_supplies = ARRAY_SIZE(db8500_b2r2_mcde_consumers),
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM12] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-esram12",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM12RET] = {
+		.constraints = {
+			.name = "db8500-esram12-ret",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM34] = {
+		.supply_regulator = "db8500-vape",
+		.constraints = {
+			.name = "db8500-esram34",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM34RET] = {
+		.constraints = {
+			.name = "db8500-esram34-ret",
+			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+		},
+	},
+};
+
 static struct mfd_cell db8500_prcmu_devs[] = {
 	{
 		.name = "db8500-prcmu-regulators",
+		.mfd_data = &db8500_regulators,
 	},
 	{
 		.name = "cpufreq-u8500",
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index b9f29e0..f0b13a0 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -274,6 +274,13 @@ config REGULATOR_AB8500
 	  This driver supports the regulators found on the ST-Ericsson mixed
 	  signal AB8500 PMIC
 
+config REGULATOR_DB8500_PRCMU
+	bool "ST-Ericsson DB8500 Voltage Domain Regulators"
+	depends on MFD_DB8500_PRCMU
+	help
+	  This driver supports the voltage domain regulators controlled by the
+	  DB8500 PRCMU
+
 config REGULATOR_TPS6586X
 	tristate "TI TPS6586X Power regulators"
 	depends on MFD_TPS6586X
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d72a427..165ff53 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_REGULATOR_TPS6524X) += tps6524x-regulator.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_ISL6271A) += isl6271a-regulator.o
 obj-$(CONFIG_REGULATOR_AB8500)	+= ab8500.o
+obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 
 ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
new file mode 100644
index 0000000..f3d51a0
--- /dev/null
+++ b/drivers/regulator/db8500-prcmu.c
@@ -0,0 +1,560 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Authors: Sundar Iyer <sundar.iyer@stericsson.com> for ST-Ericsson
+ *          Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * Power domain regulators on DB8500
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/db8500-prcmu.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/db8500-prcmu.h>
+
+/*
+ * power state reference count
+ */
+static int power_state_active_cnt; /* will initialize to zero */
+static DEFINE_SPINLOCK(power_state_active_lock);
+
+static void power_state_active_enable(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	power_state_active_cnt++;
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+}
+
+static int power_state_active_disable(void)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&power_state_active_lock, flags);
+	if (power_state_active_cnt <= 0) {
+		pr_err("power state: unbalanced enable/disable calls\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	power_state_active_cnt--;
+out:
+	spin_unlock_irqrestore(&power_state_active_lock, flags);
+	return ret;
+}
+
+/*
+ * Exported interface for CPUIdle only. This function is called when interrupts
+ * are turned off. Hence, no locking.
+ */
+int power_state_active_is_enabled(void)
+{
+	return (power_state_active_cnt > 0);
+}
+
+/**
+ * struct db8500_regulator_info - db8500 regulator information
+ * @dev: device pointer
+ * @desc: regulator description
+ * @rdev: regulator device pointer
+ * @is_enabled: status of the regulator
+ * @epod_id: id for EPOD (power domain)
+ * @is_ramret: RAM retention switch for EPOD (power domain)
+ * @operating_point: operating point (only for vape, to be removed)
+ *
+ */
+struct db8500_regulator_info {
+	struct device *dev;
+	struct regulator_desc desc;
+	struct regulator_dev *rdev;
+	bool is_enabled;
+	u16 epod_id;
+	bool is_ramret;
+	bool exclude_from_power_state;
+	unsigned int operating_point;
+};
+
+static int db8500_regulator_enable(struct regulator_dev *rdev)
+{
+	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-enable\n",
+		info->desc.name);
+
+	info->is_enabled = true;
+	if (!info->exclude_from_power_state)
+		power_state_active_enable();
+
+	return 0;
+}
+
+static int db8500_regulator_disable(struct regulator_dev *rdev)
+{
+	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret = 0;
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-disable\n",
+		info->desc.name);
+
+	info->is_enabled = false;
+	if (!info->exclude_from_power_state)
+		ret = power_state_active_disable();
+
+	return ret;
+}
+
+static int db8500_regulator_is_enabled(struct regulator_dev *rdev)
+{
+	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-%s-is_enabled (is_enabled):"
+		" %i\n", info->desc.name, info->is_enabled);
+
+	return info->is_enabled;
+}
+
+/* db8500 regulator operations */
+static struct regulator_ops db8500_regulator_ops = {
+	.enable			= db8500_regulator_enable,
+	.disable		= db8500_regulator_disable,
+	.is_enabled		= db8500_regulator_is_enabled,
+};
+
+/*
+ * EPOD control
+ */
+static bool epod_on[NUM_EPOD_ID];
+static bool epod_ramret[NUM_EPOD_ID];
+
+static int enable_epod(u16 epod_id, bool ramret)
+{
+	int ret;
+
+	if (ramret) {
+		if (!epod_on[epod_id]) {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_RAMRET);
+			if (ret < 0)
+				return ret;
+		}
+		epod_ramret[epod_id] = true;
+	} else {
+		ret = prcmu_set_epod(epod_id, EPOD_STATE_ON);
+		if (ret < 0)
+			return ret;
+		epod_on[epod_id] = true;
+	}
+
+	return 0;
+}
+
+static int disable_epod(u16 epod_id, bool ramret)
+{
+	int ret;
+
+	if (ramret) {
+		if (!epod_on[epod_id]) {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_OFF);
+			if (ret < 0)
+				return ret;
+		}
+		epod_ramret[epod_id] = false;
+	} else {
+		if (epod_ramret[epod_id]) {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_RAMRET);
+			if (ret < 0)
+				return ret;
+		} else {
+			ret = prcmu_set_epod(epod_id, EPOD_STATE_OFF);
+			if (ret < 0)
+				return ret;
+		}
+		epod_on[epod_id] = false;
+	}
+
+	return 0;
+}
+
+/*
+ * Regulator switch
+ */
+static int db8500_regulator_switch_enable(struct regulator_dev *rdev)
+{
+	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-switch-%s-enable\n",
+		info->desc.name);
+
+	ret = enable_epod(info->epod_id, info->is_ramret);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"regulator-switch-%s-enable: prcmu call failed\n",
+			info->desc.name);
+		goto out;
+	}
+
+	info->is_enabled = true;
+out:
+	return ret;
+}
+
+static int db8500_regulator_switch_disable(struct regulator_dev *rdev)
+{
+	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev), "regulator-switch-%s-disable\n",
+		info->desc.name);
+
+	ret = disable_epod(info->epod_id, info->is_ramret);
+	if (ret < 0) {
+		dev_err(rdev_get_dev(rdev),
+			"regulator_switch-%s-disable: prcmu call failed\n",
+			info->desc.name);
+		goto out;
+	}
+
+	info->is_enabled = 0;
+out:
+	return ret;
+}
+
+static int db8500_regulator_switch_is_enabled(struct regulator_dev *rdev)
+{
+	struct db8500_regulator_info *info = rdev_get_drvdata(rdev);
+
+	if (info == NULL)
+		return -EINVAL;
+
+	dev_vdbg(rdev_get_dev(rdev),
+		"regulator-switch-%s-is_enabled (is_enabled): %i\n",
+		info->desc.name, info->is_enabled);
+
+	return info->is_enabled;
+}
+
+static struct regulator_ops db8500_regulator_switch_ops = {
+	.enable			= db8500_regulator_switch_enable,
+	.disable		= db8500_regulator_switch_disable,
+	.is_enabled		= db8500_regulator_switch_is_enabled,
+};
+
+/*
+ * Regulator information
+ */
+static struct db8500_regulator_info
+		db8500_regulator_info[DB8500_NUM_REGULATORS] = {
+	[DB8500_REGULATOR_VAPE] = {
+		.desc = {
+			.name	= "db8500-vape",
+			.id	= DB8500_REGULATOR_VAPE,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_VARM] = {
+		.desc = {
+			.name	= "db8500-varm",
+			.id	= DB8500_REGULATOR_VARM,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_VMODEM] = {
+		.desc = {
+			.name	= "db8500-vmodem",
+			.id	= DB8500_REGULATOR_VMODEM,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_VPLL] = {
+		.desc = {
+			.name	= "db8500-vpll",
+			.id	= DB8500_REGULATOR_VPLL,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_VSMPS1] = {
+		.desc = {
+			.name	= "db8500-vsmps1",
+			.id	= DB8500_REGULATOR_VSMPS1,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_VSMPS2] = {
+		.desc = {
+			.name	= "db8500-vsmps2",
+			.id	= DB8500_REGULATOR_VSMPS2,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.exclude_from_power_state = true,
+	},
+	[DB8500_REGULATOR_VSMPS3] = {
+		.desc = {
+			.name	= "db8500-vsmps3",
+			.id	= DB8500_REGULATOR_VSMPS3,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_VRF1] = {
+		.desc = {
+			.name	= "db8500-vrf1",
+			.id	= DB8500_REGULATOR_VRF1,
+			.ops	= &db8500_regulator_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+	},
+	[DB8500_REGULATOR_SWITCH_SVAMMDSP] = {
+		.desc = {
+			.name	= "db8500-sva-mmdsp",
+			.id	= DB8500_REGULATOR_SWITCH_SVAMMDSP,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SVAMMDSP,
+	},
+	[DB8500_REGULATOR_SWITCH_SVAMMDSPRET] = {
+		.desc = {
+			.name	= "db8500-sva-mmdsp-ret",
+			.id	= DB8500_REGULATOR_SWITCH_SVAMMDSPRET,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SVAMMDSP,
+		.is_ramret = true,
+	},
+	[DB8500_REGULATOR_SWITCH_SVAPIPE] = {
+		.desc = {
+			.name	= "db8500-sva-pipe",
+			.id	= DB8500_REGULATOR_SWITCH_SVAPIPE,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SVAPIPE,
+	},
+	[DB8500_REGULATOR_SWITCH_SIAMMDSP] = {
+		.desc = {
+			.name	= "db8500-sia-mmdsp",
+			.id	= DB8500_REGULATOR_SWITCH_SIAMMDSP,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SIAMMDSP,
+	},
+	[DB8500_REGULATOR_SWITCH_SIAMMDSPRET] = {
+		.desc = {
+			.name	= "db8500-sia-mmdsp-ret",
+			.id	= DB8500_REGULATOR_SWITCH_SIAMMDSPRET,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SIAMMDSP,
+		.is_ramret = true,
+	},
+	[DB8500_REGULATOR_SWITCH_SIAPIPE] = {
+		.desc = {
+			.name	= "db8500-sia-pipe",
+			.id	= DB8500_REGULATOR_SWITCH_SIAPIPE,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SIAPIPE,
+	},
+	[DB8500_REGULATOR_SWITCH_SGA] = {
+		.desc = {
+			.name	= "db8500-sga",
+			.id	= DB8500_REGULATOR_SWITCH_SGA,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_SGA,
+	},
+	[DB8500_REGULATOR_SWITCH_B2R2_MCDE] = {
+		.desc = {
+			.name	= "db8500-b2r2-mcde",
+			.id	= DB8500_REGULATOR_SWITCH_B2R2_MCDE,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_B2R2_MCDE,
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM12] = {
+		.desc = {
+			.name	= "db8500-esram12",
+			.id	= DB8500_REGULATOR_SWITCH_ESRAM12,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id	= EPOD_ID_ESRAM12,
+		.is_enabled	= true,
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM12RET] = {
+		.desc = {
+			.name	= "db8500-esram12-ret",
+			.id	= DB8500_REGULATOR_SWITCH_ESRAM12RET,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_ESRAM12,
+		.is_ramret = true,
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM34] = {
+		.desc = {
+			.name	= "db8500-esram34",
+			.id	= DB8500_REGULATOR_SWITCH_ESRAM34,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id	= EPOD_ID_ESRAM34,
+		.is_enabled	= true,
+	},
+	[DB8500_REGULATOR_SWITCH_ESRAM34RET] = {
+		.desc = {
+			.name	= "db8500-esram34-ret",
+			.id	= DB8500_REGULATOR_SWITCH_ESRAM34RET,
+			.ops	= &db8500_regulator_switch_ops,
+			.type	= REGULATOR_VOLTAGE,
+			.owner	= THIS_MODULE,
+		},
+		.epod_id = EPOD_ID_ESRAM34,
+		.is_ramret = true,
+	},
+};
+
+static int __init db8500_regulator_probe(struct platform_device *pdev)
+{
+	struct regulator_init_data *db8500_init_data = mfd_get_data(pdev);
+	int i, err;
+
+	/* register all regulators */
+	for (i = 0; i < ARRAY_SIZE(db8500_regulator_info); i++) {
+		struct db8500_regulator_info *info;
+		struct regulator_init_data *init_data = &db8500_init_data[i];
+
+		/* assign per-regulator data */
+		info = &db8500_regulator_info[i];
+		info->dev = &pdev->dev;
+
+		/* register with the regulator framework */
+		info->rdev = regulator_register(&info->desc, &pdev->dev,
+				init_data, info);
+		if (IS_ERR(info->rdev)) {
+			err = PTR_ERR(info->rdev);
+			dev_err(&pdev->dev, "failed to register %s: err %i\n",
+				info->desc.name, err);
+
+			/* if failing, unregister all earlier regulators */
+			i--;
+			while (i >= 0) {
+				info = &db8500_regulator_info[i];
+				regulator_unregister(info->rdev);
+				i--;
+			}
+			return err;
+		}
+
+		dev_vdbg(rdev_get_dev(info->rdev),
+			"regulator-%s-probed\n", info->desc.name);
+	}
+
+	return 0;
+}
+
+static int __exit db8500_regulator_remove(struct platform_device *pdev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(db8500_regulator_info); i++) {
+		struct db8500_regulator_info *info;
+		info = &db8500_regulator_info[i];
+
+		dev_vdbg(rdev_get_dev(info->rdev),
+			"regulator-%s-remove\n", info->desc.name);
+
+		regulator_unregister(info->rdev);
+	}
+
+	return 0;
+}
+
+static struct platform_driver db8500_regulator_driver = {
+	.driver = {
+		.name = "db8500-regulators",
+		.owner = THIS_MODULE,
+	},
+	.remove = __exit_p(db8500_regulator_remove),
+};
+
+static int __init db8500_regulator_init(void)
+{
+	int ret;
+
+	ret = platform_driver_probe(&db8500_regulator_driver,
+				    db8500_regulator_probe);
+	if (ret < 0) {
+		pr_info("db8500_regulator: platform_driver_register fails\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __exit db8500_regulator_exit(void)
+{
+	platform_driver_unregister(&db8500_regulator_driver);
+}
+
+arch_initcall(db8500_regulator_init);
+module_exit(db8500_regulator_exit);
+
+MODULE_AUTHOR("STMicroelectronics/ST-Ericsson");
+MODULE_DESCRIPTION("DB8500 regulator driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/regulator/db8500-prcmu.h b/include/linux/regulator/db8500-prcmu.h
new file mode 100644
index 0000000..6120623
--- /dev/null
+++ b/include/linux/regulator/db8500-prcmu.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ *
+ * Author: Bengt Jonsson <bengt.g.jonsson@stericsson.com> for ST-Ericsson
+ *
+ * Interface to power domain regulators on DB8500
+ */
+
+#ifndef __REGULATOR_H__
+#define __REGULATOR_H__
+
+/* Number of DB8500 regulators and regulator enumeration */
+enum db8500_regulator_id {
+	DB8500_REGULATOR_VAPE,
+	DB8500_REGULATOR_VARM,
+	DB8500_REGULATOR_VMODEM,
+	DB8500_REGULATOR_VPLL,
+	DB8500_REGULATOR_VSMPS1,
+	DB8500_REGULATOR_VSMPS2,
+	DB8500_REGULATOR_VSMPS3,
+	DB8500_REGULATOR_VRF1,
+	DB8500_REGULATOR_SWITCH_SVAMMDSP,
+	DB8500_REGULATOR_SWITCH_SVAMMDSPRET,
+	DB8500_REGULATOR_SWITCH_SVAPIPE,
+	DB8500_REGULATOR_SWITCH_SIAMMDSP,
+	DB8500_REGULATOR_SWITCH_SIAMMDSPRET,
+	DB8500_REGULATOR_SWITCH_SIAPIPE,
+	DB8500_REGULATOR_SWITCH_SGA,
+	DB8500_REGULATOR_SWITCH_B2R2_MCDE,
+	DB8500_REGULATOR_SWITCH_ESRAM12,
+	DB8500_REGULATOR_SWITCH_ESRAM12RET,
+	DB8500_REGULATOR_SWITCH_ESRAM34,
+	DB8500_REGULATOR_SWITCH_ESRAM34RET,
+	DB8500_NUM_REGULATORS
+};
+
+/*
+ * Exported interface for CPUIdle only. This function is called with all
+ * interrupts turned off.
+ */
+int power_state_active_is_enabled(void);
+
+#endif
-- 
1.7.4.4

