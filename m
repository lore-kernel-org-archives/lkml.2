Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab2LMPWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:22:24 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab2LMPWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 10:22:18 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Michel JAOUEN <michel.jaouen@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>
Subject: [PATCH 14/18] power: pm2301: Add pm2301 charger
Date: Thu, 13 Dec 2012 15:21:37 +0000
Message-Id: <1355412102-14265-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
References: <1355412102-14265-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michel JAOUEN <michel.jaouen@stericsson.com>

PM2301 AC charger driver based on 9540 platform.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
Reviewed-by: Michel JAOUEN <michel.jaouen@stericsson.com>
Tested-by: Michel JAOUEN <michel.jaouen@stericsson.com>
---
 drivers/power/Kconfig          |   15 +
 drivers/power/Makefile         |    1 +
 drivers/power/ab8500_charger.c |    8 +-
 drivers/power/pm2301_charger.c | 1599 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pm2301_charger.h |   60 ++
 5 files changed, 1681 insertions(+), 2 deletions(-)
 create mode 100644 drivers/power/pm2301_charger.c
 create mode 100644 include/linux/pm2301_charger.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 263499f..0830779 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -346,6 +346,21 @@ config AB8500_BM
 	help
 	  Say Y to include support for AB8500 battery management.
 
+config CHARGER_PM2301
+        bool "PM2301 Battery Charger Driver"
+        depends on AB8500_BM
+        help
+          Say Y to include support for PM2301 charger driver.
+
+config PM2XXX_DEEP_DEBUG
+        bool "PM2XXX Deep Debug"
+        depends on DEEP_DEBUG && CHARGER_PM2301
+        default n
+        help
+          Deep Debug interface provides an access to all registers.
+          It allows to read or write directly a register.
+          Say Y to include support for Deep Debug.
+          If unsure, say N.
 endif # POWER_SUPPLY
 
 source "drivers/power/avs/Kconfig"
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 070c73d..8130786 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_CHARGER_LP8727)	+= lp8727_charger.o
 obj-$(CONFIG_CHARGER_LP8788)	+= lp8788-charger.o
 obj-$(CONFIG_CHARGER_GPIO)	+= gpio-charger.o
 obj-$(CONFIG_CHARGER_MANAGER)	+= charger-manager.o
+obj-$(CONFIG_CHARGER_PM2301)	+= pm2301_charger.o
 obj-$(CONFIG_CHARGER_MAX8997)	+= max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)	+= max8998_charger.o
 obj-$(CONFIG_CHARGER_BQ2415X)	+= bq2415x_charger.o
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 7ecbd33..7bfb02e 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2798,7 +2798,9 @@ static int __devexit ab8500_charger_remove(struct platform_device *pdev)
 
 	flush_scheduled_work();
 	power_supply_unregister(&di->usb_chg.psy);
+#if !defined(CONFIG_CHARGER_PM2301)
 	power_supply_unregister(&di->ac_chg.psy);
+#endif
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
@@ -2957,14 +2959,14 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		dev_err(di->dev, "failed to initialize ABB registers\n");
 		goto free_regulator;
 	}
-
+#if !defined(CONFIG_CHARGER_PM2301)
 	/* Register AC charger class */
 	ret = power_supply_register(di->dev, &di->ac_chg.psy);
 	if (ret) {
 		dev_err(di->dev, "failed to register AC charger\n");
 		goto free_regulator;
 	}
-
+#endif
 	/* Register USB charger class */
 	ret = power_supply_register(di->dev, &di->usb_chg.psy);
 	if (ret) {
@@ -3051,7 +3053,9 @@ put_usb_phy:
 free_usb:
 	power_supply_unregister(&di->usb_chg.psy);
 free_ac:
+#if !defined(CONFIG_CHARGER_PM2301)
 	power_supply_unregister(&di->ac_chg.psy);
+#endif
 free_regulator:
 	regulator_put(di->regu);
 free_charger_wq:
diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
new file mode 100644
index 0000000..b579e4d
--- /dev/null
+++ b/drivers/power/pm2301_charger.c
@@ -0,0 +1,1599 @@
+/*
+ * Power supply driver for ST Ericsson pm2xxx_charger charger
+ *
+ * Copyright 2012 ST Ericsson.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/completion.h>
+#include <linux/regulator/consumer.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/kobject.h>
+#include <linux/mfd/ab8500.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500-bm.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
+#include <linux/mfd/abx500/ux500_chargalg.h>
+#include <linux/pm2301_charger.h>
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+#include <linux/debugfs.h>
+#include <linux/ux500_deepdebug.h>
+#endif
+
+#define MAIN_WDOG_ENA			0x01
+#define MAIN_WDOG_KICK			0x02
+#define MAIN_WDOG_DIS			0x00
+#define CHARG_WD_KICK			0x01
+#define MAIN_CH_ENA			0x01
+#define MAIN_CH_NO_OVERSHOOT_ENA_N	0x02
+#define MAIN_CH_DET			0x01
+#define MAIN_CH_CV_ON			0x04
+#define OTP_ENABLE_WD			0x01
+
+#define MAIN_CH_INPUT_CURR_SHIFT	4
+
+#define LED_INDICATOR_PWM_ENA		0x01
+#define LED_INDICATOR_PWM_DIS		0x00
+#define LED_IND_CUR_5MA			0x04
+#define LED_INDICATOR_PWM_DUTY_252_256	0xBF
+
+/* HW failure constants */
+#define MAIN_CH_TH_PROT			0x02
+#define MAIN_CH_NOK			0x01
+
+/* Watchdog timeout constant */
+#define WD_TIMER			0x30 /* 4min */
+#define WD_KICK_INTERVAL		(60 * HZ)
+
+/* Lowest charger voltage is 3.39V -> 0x4E */
+#define LOW_VOLT_REG			0x4E
+
+#define PM2XXX_BATT_CTRL_REG1		0x00
+#define PM2XXX_BATT_CTRL_REG2		0x01
+#define PM2XXX_BATT_CTRL_REG3		0x02
+#define PM2XXX_BATT_CTRL_REG4		0x03
+#define PM2XXX_BATT_CTRL_REG5		0x04
+#define PM2XXX_BATT_CTRL_REG6		0x05
+#define PM2XXX_BATT_CTRL_REG7		0x06
+#define PM2XXX_BATT_CTRL_REG8		0x07
+#define PM2XXX_NTC_CTRL_REG1		0x08
+#define PM2XXX_NTC_CTRL_REG2		0x09
+#define PM2XXX_BATT_CTRL_REG9		0x0A
+#define PM2XXX_BATT_STAT_REG1		0x0B
+#define PM2XXX_INP_VOLT_VPWR2		0x11
+#define PM2XXX_INP_DROP_VPWR2		0x13
+#define PM2XXX_INP_VOLT_VPWR1		0x15
+#define PM2XXX_INP_DROP_VPWR1		0x17
+#define PM2XXX_INP_MODE_VPWR		0x18
+#define PM2XXX_BATT_WD_KICK		0x70
+#define PM2XXX_DEV_VER_STAT		0x0C
+#define PM2XXX_THERM_WARN_CTRL_REG	0x20
+#define PM2XXX_BATT_DISC_REG		0x21
+#define PM2XXX_BATT_LOW_LEV_COMP_REG	0x22
+#define PM2XXX_BATT_LOW_LEV_VAL_REG	0x23
+#define PM2XXX_I2C_PAD_CTRL_REG		0x24
+#define PM2XXX_SW_CTRL_REG		0x26
+#define PM2XXX_LED_CTRL_REG		0x28
+
+#define PM2XXX_REG_INT1		0x40
+#define PM2XXX_MASK_REG_INT1	0x50
+#define PM2XXX_SRCE_REG_INT1	0x60
+#define PM2XXX_REG_INT2		0x41
+#define PM2XXX_MASK_REG_INT2	0x51
+#define PM2XXX_SRCE_REG_INT2	0x61
+#define PM2XXX_REG_INT3		0x42
+#define PM2XXX_MASK_REG_INT3	0x52
+#define PM2XXX_SRCE_REG_INT3	0x62
+#define PM2XXX_REG_INT4		0x43
+#define PM2XXX_MASK_REG_INT4	0x53
+#define PM2XXX_SRCE_REG_INT4	0x63
+#define PM2XXX_REG_INT5		0x44
+#define PM2XXX_MASK_REG_INT5	0x54
+#define PM2XXX_SRCE_REG_INT5	0x64
+#define PM2XXX_REG_INT6		0x45
+#define PM2XXX_MASK_REG_INT6	0x55
+#define PM2XXX_SRCE_REG_INT6	0x65
+
+#define VPWR_OVV 0x0
+#define VSYSTEM_OVV 0x1
+
+/* control Reg 1 */
+#define PM2XXX_CH_RESUME_EN	     0x1
+#define PM2XXX_CH_RESUME_DIS		0x0
+
+/* control Reg 2 */
+#define PM2XXX_CH_AUTO_RESUME_EN	0X2
+#define PM2XXX_CH_AUTO_RESUME_DIS	0X0
+#define PM2XXX_CHARGER_ENA		0x4
+#define PM2XXX_CHARGER_DIS		0x0
+
+/* control Reg 3 */
+#define PM2XXX_CH_WD_CC_PHASE_OFF	0x0
+#define PM2XXX_CH_WD_CC_PHASE_5MIN	0x1
+#define PM2XXX_CH_WD_CC_PHASE_10MIN	0x2
+#define PM2XXX_CH_WD_CC_PHASE_30MIN	0x3
+#define PM2XXX_CH_WD_CC_PHASE_60MIN	0x4
+#define PM2XXX_CH_WD_CC_PHASE_120MIN	0x5
+#define PM2XXX_CH_WD_CC_PHASE_240MIN	0x6
+#define PM2XXX_CH_WD_CC_PHASE_360MIN	0x7
+
+#define PM2XXX_CH_WD_CV_PHASE_OFF	(0x0<<3)
+#define PM2XXX_CH_WD_CV_PHASE_5MIN	(0x1<<3)
+#define PM2XXX_CH_WD_CV_PHASE_10MIN	(0x2<<3)
+#define PM2XXX_CH_WD_CV_PHASE_30MIN	(0x3<<3)
+#define PM2XXX_CH_WD_CV_PHASE_60MIN	(0x4<<3)
+#define PM2XXX_CH_WD_CV_PHASE_120MIN	(0x5<<3)
+#define PM2XXX_CH_WD_CV_PHASE_240MIN	(0x6<<3)
+#define PM2XXX_CH_WD_CV_PHASE_360MIN	(0x7<<3)
+
+/* control Reg 4 */
+#define PM2XXX_CH_WD_PRECH_PHASE_OFF	0x0
+#define PM2XXX_CH_WD_PRECH_PHASE_1MIN	0x1
+#define PM2XXX_CH_WD_PRECH_PHASE_5MIN	0x2
+#define PM2XXX_CH_WD_PRECH_PHASE_10MIN	0x3
+#define PM2XXX_CH_WD_PRECH_PHASE_30MIN	0x4
+#define PM2XXX_CH_WD_PRECH_PHASE_60MIN	0x5
+#define PM2XXX_CH_WD_PRECH_PHASE_120MIN	0x6
+#define PM2XXX_CH_WD_PRECH_PHASE_240MIN	0x7
+
+/* control Reg 5 */
+#define PM2XXX_CH_WD_AUTO_TIMEOUT_NONE	0x0
+#define PM2XXX_CH_WD_AUTO_TIMEOUT_20MIN	0x1
+
+/* control Reg 6 */
+#define PM2XXX_DIR_CH_CC_CURRENT_200MA	0x0
+#define PM2XXX_DIR_CH_CC_CURRENT_400MA	0x2
+#define PM2XXX_DIR_CH_CC_CURRENT_600MA	0x3
+#define PM2XXX_DIR_CH_CC_CURRENT_800MA	0x4
+#define PM2XXX_DIR_CH_CC_CURRENT_1000MA	0x5
+#define PM2XXX_DIR_CH_CC_CURRENT_1200MA	0x6
+#define PM2XXX_DIR_CH_CC_CURRENT_1400MA	0x7
+#define PM2XXX_DIR_CH_CC_CURRENT_1600MA	0x8
+#define PM2XXX_DIR_CH_CC_CURRENT_1800MA	0x9
+#define PM2XXX_DIR_CH_CC_CURRENT_2000MA	0xA
+#define PM2XXX_DIR_CH_CC_CURRENT_2200MA	0xB
+#define PM2XXX_DIR_CH_CC_CURRENT_2400MA	0xC
+#define PM2XXX_DIR_CH_CC_CURRENT_2600MA	0xD
+#define PM2XXX_DIR_CH_CC_CURRENT_2800MA	0xE
+#define PM2XXX_DIR_CH_CC_CURRENT_3000MA	0xF
+
+#define PM2XXX_CH_PRECH_CURRENT_25MA	(0x0<<4)
+#define PM2XXX_CH_PRECH_CURRENT_50MA	(0x1<<4)
+#define PM2XXX_CH_PRECH_CURRENT_75MA	(0x2<<4)
+#define PM2XXX_CH_PRECH_CURRENT_100MA	(0x3<<4)
+
+#define PM2XXX_CH_EOC_CURRENT_100MA	(0x0<<6)
+#define PM2XXX_CH_EOC_CURRENT_150MA	(0x1<<6)
+#define PM2XXX_CH_EOC_CURRENT_300MA	(0x2<<6)
+#define PM2XXX_CH_EOC_CURRENT_400MA	(0x3<<6)
+
+/* control Reg 7 */
+#define PM2XXX_CH_PRECH_VOL_2_5		0x0
+#define PM2XXX_CH_PRECH_VOL_2_7		0x1
+#define PM2XXX_CH_PRECH_VOL_2_9		0x2
+#define PM2XXX_CH_PRECH_VOL_3_1		0x3
+
+#define PM2XXX_CH_VRESUME_VOL_3_2	(0x0<<2)
+#define PM2XXX_CH_VRESUME_VOL_3_4	(0x1<<2)
+#define PM2XXX_CH_VRESUME_VOL_3_6	(0x2<<2)
+#define PM2XXX_CH_VRESUME_VOL_3_8	(0x3<<2)
+
+/* control Reg 8 */
+#define PM2XXX_CH_VOLT_3_5		0x0
+#define PM2XXX_CH_VOLT_3_5225		0x1
+#define PM2XXX_CH_VOLT_3_6		0x4
+#define PM2XXX_CH_VOLT_3_7		0x8
+#define PM2XXX_CH_VOLT_4_0		0x14
+#define PM2XXX_CH_VOLT_4_175		0x1B
+#define PM2XXX_CH_VOLT_4_2		0x1C
+#define PM2XXX_CH_VOLT_4_275		0x1F
+#define PM2XXX_CH_VOLT_4_3		0x20
+
+/*NTC control register 1*/
+#define PM2XXX_BTEMP_HIGH_TH_45		0x0
+#define PM2XXX_BTEMP_HIGH_TH_50		0x1
+#define PM2XXX_BTEMP_HIGH_TH_55		0x2
+#define PM2XXX_BTEMP_HIGH_TH_60		0x3
+#define PM2XXX_BTEMP_HIGH_TH_65		0x4
+
+#define PM2XXX_BTEMP_LOW_TH_N5		(0x0<<3)
+#define PM2XXX_BTEMP_LOW_TH_0		(0x1<<3)
+#define PM2XXX_BTEMP_LOW_TH_5		(0x2<<3)
+#define PM2XXX_BTEMP_LOW_TH_10		(0x3<<3)
+
+/*NTC control register 2*/
+#define PM2XXX_NTC_BETA_COEFF_3477	0x0
+#define PM2XXX_NTC_BETA_COEFF_3964	0x1
+
+#define PM2XXX_NTC_RES_10K		(0x0<<2)
+#define PM2XXX_NTC_RES_47K		(0x1<<2)
+#define PM2XXX_NTC_RES_100K		(0x2<<2)
+#define PM2XXX_NTC_RES_NO_NTC		(0x3<<2)
+
+/* control Reg 9 */
+#define PM2XXX_CH_CC_MODEDROP_EN	1
+#define PM2XXX_CH_CC_MODEDROP_DIS	0
+
+#define PM2XXX_CH_CC_REDUCED_CURRENT_100MA	(0x0<<1)
+#define PM2XXX_CH_CC_REDUCED_CURRENT_200MA	(0x1<<1)
+#define PM2XXX_CH_CC_REDUCED_CURRENT_400MA	(0x2<<1)
+#define PM2XXX_CH_CC_REDUCED_CURRENT_IDENT	(0x3<<1)
+
+#define PM2XXX_CHARCHING_INFO_DIS	(0<<3)
+#define PM2XXX_CHARCHING_INFO_EN	(1<<3)
+
+#define PM2XXX_CH_150MV_DROP_300MV	(0<<4)
+#define PM2XXX_CH_150MV_DROP_150MV	(1<<4)
+
+
+/* charger status register */
+#define PM2XXX_CHG_STATUS_OFF		0x0
+#define PM2XXX_CHG_STATUS_ON		0x1
+#define PM2XXX_CHG_STATUS_FULL		0x2
+#define PM2XXX_CHG_STATUS_ERR		0x3
+#define PM2XXX_CHG_STATUS_WAIT		0x4
+#define PM2XXX_CHG_STATUS_NOBAT		0x5
+
+/* Input charger voltage VPWR2 */
+#define PM2XXX_VPWR2_OVV_6_0		0x0
+#define PM2XXX_VPWR2_OVV_6_3		0x1
+#define PM2XXX_VPWR2_OVV_10		0x2
+#define PM2XXX_VPWR2_OVV_NONE		0x3
+
+/* Input charger voltage VPWR1 */
+#define PM2XXX_VPWR1_OVV_6_0		0x0
+#define PM2XXX_VPWR1_OVV_6_3		0x1
+#define PM2XXX_VPWR1_OVV_10		0x2
+#define PM2XXX_VPWR1_OVV_NONE		0x3
+
+/* Battery low level comparator control register */
+#define PM2XXX_VBAT_LOW_MONITORING_DIS	0x0
+#define PM2XXX_VBAT_LOW_MONITORING_ENA	0x1
+
+/* Battery low level value control register */
+#define PM2XXX_VBAT_LOW_LEVEL_2_3	0x0
+#define PM2XXX_VBAT_LOW_LEVEL_2_4	0x1
+#define PM2XXX_VBAT_LOW_LEVEL_2_5	0x2
+#define PM2XXX_VBAT_LOW_LEVEL_2_6	0x3
+#define PM2XXX_VBAT_LOW_LEVEL_2_7	0x4
+#define PM2XXX_VBAT_LOW_LEVEL_2_8	0x5
+#define PM2XXX_VBAT_LOW_LEVEL_2_9	0x6
+#define PM2XXX_VBAT_LOW_LEVEL_3_0	0x7
+#define PM2XXX_VBAT_LOW_LEVEL_3_1	0x8
+#define PM2XXX_VBAT_LOW_LEVEL_3_2	0x9
+#define PM2XXX_VBAT_LOW_LEVEL_3_3	0xA
+#define PM2XXX_VBAT_LOW_LEVEL_3_4	0xB
+#define PM2XXX_VBAT_LOW_LEVEL_3_5	0xC
+#define PM2XXX_VBAT_LOW_LEVEL_3_6	0xD
+#define PM2XXX_VBAT_LOW_LEVEL_3_7	0xE
+#define PM2XXX_VBAT_LOW_LEVEL_3_8	0xF
+#define PM2XXX_VBAT_LOW_LEVEL_3_9	0x10
+#define PM2XXX_VBAT_LOW_LEVEL_4_0	0x11
+#define PM2XXX_VBAT_LOW_LEVEL_4_1	0x12
+#define PM2XXX_VBAT_LOW_LEVEL_4_2	0x13
+
+/* SW CTRL */
+#define PM2XXX_SWCTRL_HW		0x0
+#define PM2XXX_SWCTRL_SW		0x1
+
+
+/* LED Driver Control */
+#define PM2XXX_LED_CURRENT_2_5MA	(0X0<<2)
+#define PM2XXX_LED_CURRENT_1MA		(0X1<<2)
+#define PM2XXX_LED_CURRENT_5MA		(0X2<<2)
+#define PM2XXX_LED_CURRENT_10MA		(0X3<<2)
+
+#define PM2XXX_LED_SELECT_EN		(0X0<<1)
+#define PM2XXX_LED_SELECT_DIS		(0X1<<1)
+
+#define PM2XXX_ANTI_OVERSHOOT_DIS	0X0
+#define PM2XXX_ANTI_OVERSHOOT_EN	0X1
+
+#define to_pm2xxx_charger_ac_device_info(x) container_of((x), \
+		struct pm2xxx_charger, ac_chg)
+
+static int pm2xxx_interrupt_registers[] = {
+	PM2XXX_REG_INT1 ,
+	PM2XXX_REG_INT2 ,
+	PM2XXX_REG_INT3 ,
+	PM2XXX_REG_INT4 ,
+	PM2XXX_REG_INT5 ,
+	PM2XXX_REG_INT6 ,
+};
+
+enum pm2xxx_reg_int1 {
+	PM2XXX_INT1_ITVBATDISCONNECT	= 0x02,
+	PM2XXX_INT1_ITVBATLOWR		= 0x04,
+	PM2XXX_INT1_ITVBATLOWF		= 0x08,
+};
+
+enum pm2xxx_mask_reg_int1 {
+	PM2XXX_INT1_M_ITVBATDISCONNECT	= 0x02,
+	PM2XXX_INT1_M_ITVBATLOWR	= 0x04,
+	PM2XXX_INT1_M_ITVBATLOWF	= 0x08,
+};
+
+enum pm2xxx_source_reg_int1 {
+	PM2XXX_INT1_S_ITVBATDISCONNECT	= 0x02,
+	PM2XXX_INT1_S_ITVBATLOWR	= 0x04,
+	PM2XXX_INT1_S_ITVBATLOWF	= 0x08,
+};
+
+enum pm2xxx_reg_int2 {
+	PM2XXX_INT2_ITVPWR2PLUG		= 0x01,
+	PM2XXX_INT2_ITVPWR2UNPLUG	= 0x02,
+	PM2XXX_INT2_ITVPWR1PLUG		= 0x04,
+	PM2XXX_INT2_ITVPWR1UNPLUG	= 0x08,
+};
+
+enum pm2xxx_mask_reg_int2 {
+	PM2XXX_INT2_M_ITVPWR2PLUG	= 0x01,
+	PM2XXX_INT2_M_ITVPWR2UNPLUG	= 0x02,
+	PM2XXX_INT2_M_ITVPWR1PLUG	= 0x04,
+	PM2XXX_INT2_M_ITVPWR1UNPLUG	= 0x08,
+};
+
+enum pm2xxx_source_reg_int2 {
+	PM2XXX_INT2_S_ITVPWR2PLUG	= 0x03,
+	PM2XXX_INT2_S_ITVPWR1PLUG	= 0x0c,
+};
+
+enum pm2xxx_reg_int3 {
+	PM2XXX_INT3_ITCHPRECHARGEWD	= 0x01,
+	PM2XXX_INT3_ITCHCCWD		= 0x02,
+	PM2XXX_INT3_ITCHCVWD		= 0x04,
+	PM2XXX_INT3_ITAUTOTIMEOUTWD	= 0x08,
+};
+
+enum pm2xxx_mask_reg_int3 {
+	PM2XXX_INT3_M_ITCHPRECHARGEWD	= 0x01,
+	PM2XXX_INT3_M_ITCHCCWD		= 0x02,
+	PM2XXX_INT3_M_ITCHCVWD		= 0x04,
+	PM2XXX_INT3_M_ITAUTOTIMEOUTWD	= 0x08,
+};
+
+enum pm2xxx_source_reg_int3 {
+	PM2XXX_INT3_S_ITCHPRECHARGEWD	= 0x01,
+	PM2XXX_INT3_S_ITCHCCWD		= 0x02,
+	PM2XXX_INT3_S_ITCHCVWD		= 0x04,
+	PM2XXX_INT3_S_ITAUTOTIMEOUTWD	= 0x08,
+};
+
+enum pm2xxx_reg_int4 {
+	PM2XXX_INT4_ITBATTEMPCOLD	= 0x01,
+	PM2XXX_INT4_ITBATTEMPHOT	= 0x02,
+	PM2XXX_INT4_ITVPWR2OVV		= 0x04,
+	PM2XXX_INT4_ITVPWR1OVV		= 0x08,
+	PM2XXX_INT4_ITCHARGINGON	= 0x10,
+	PM2XXX_INT4_ITVRESUME		= 0x20,
+	PM2XXX_INT4_ITBATTFULL		= 0x40,
+	PM2XXX_INT4_ITCVPHASE		= 0x80,
+};
+
+enum pm2xxx_mask_reg_int4 {
+	PM2XXX_INT4_M_ITBATTEMPCOLD	= 0x01,
+	PM2XXX_INT4_M_ITBATTEMPHOT	= 0x02,
+	PM2XXX_INT4_M_ITVPWR2OVV	= 0x04,
+	PM2XXX_INT4_M_ITVPWR1OVV	= 0x08,
+	PM2XXX_INT4_M_ITCHARGINGON	= 0x10,
+	PM2XXX_INT4_M_ITVRESUME		= 0x20,
+	PM2XXX_INT4_M_ITBATTFULL	= 0x40,
+	PM2XXX_INT4_M_ITCVPHASE		= 0x80,
+};
+
+enum pm2xxx_source_reg_int4 {
+	PM2XXX_INT4_S_ITBATTEMPCOLD	= 0x01,
+	PM2XXX_INT4_S_ITBATTEMPHOT	= 0x02,
+	PM2XXX_INT4_S_ITVPWR2OVV	= 0x04,
+	PM2XXX_INT4_S_ITVPWR1OVV	= 0x08,
+	PM2XXX_INT4_S_ITCHARGINGON	= 0x10,
+	PM2XXX_INT4_S_ITVRESUME		= 0x20,
+	PM2XXX_INT4_S_ITBATTFULL	= 0x40,
+	PM2XXX_INT4_S_ITCVPHASE		= 0x80,
+};
+
+enum pm2xxx_reg_int5 {
+	PM2XXX_INT5_ITTHERMALSHUTDOWNRISE	= 0x01,
+	PM2XXX_INT5_ITTHERMALSHUTDOWNFALL	= 0x02,
+	PM2XXX_INT5_ITTHERMALWARNINGRISE	= 0x04,
+	PM2XXX_INT5_ITTHERMALWARNINGFALL	= 0x08,
+	PM2XXX_INT5_ITVSYSTEMOVV		= 0x10,
+};
+
+enum pm2xxx_mask_reg_int5 {
+	PM2XXX_INT5_M_ITTHERMALSHUTDOWNRISE	= 0x01,
+	PM2XXX_INT5_M_ITTHERMALSHUTDOWNFALL	= 0x02,
+	PM2XXX_INT5_M_ITTHERMALWARNINGRISE	= 0x04,
+	PM2XXX_INT5_M_ITTHERMALWARNINGFALL	= 0x08,
+	PM2XXX_INT5_M_ITVSYSTEMOVV		= 0x10,
+};
+
+enum pm2xxx_source_reg_int5 {
+	PM2XXX_INT5_S_ITTHERMALSHUTDOWNRISE	= 0x01,
+	PM2XXX_INT5_S_ITTHERMALSHUTDOWNFALL	= 0x02,
+	PM2XXX_INT5_S_ITTHERMALWARNINGRISE	= 0x04,
+	PM2XXX_INT5_S_ITTHERMALWARNINGFALL	= 0x08,
+	PM2XXX_INT5_S_ITVSYSTEMOVV		= 0x10,
+};
+
+enum pm2xxx_reg_int6 {
+	PM2XXX_INT6_ITVPWR2DROP		= 0x01,
+	PM2XXX_INT6_ITVPWR1DROP		= 0x02,
+	PM2XXX_INT6_ITVPWR2VALIDRISE	= 0x04,
+	PM2XXX_INT6_ITVPWR2VALIDFALL	= 0x08,
+	PM2XXX_INT6_ITVPWR1VALIDRISE	= 0x10,
+	PM2XXX_INT6_ITVPWR1VALIDFALL	= 0x20,
+};
+
+enum pm2xxx_mask_reg_int6 {
+	PM2XXX_INT6_M_ITVPWR2DROP	= 0x01,
+	PM2XXX_INT6_M_ITVPWR1DROP	= 0x02,
+	PM2XXX_INT6_M_ITVPWR2VALIDRISE	= 0x04,
+	PM2XXX_INT6_M_ITVPWR2VALIDFALL	= 0x08,
+	PM2XXX_INT6_M_ITVPWR1VALIDRISE	= 0x10,
+	PM2XXX_INT6_M_ITVPWR1VALIDFALL	= 0x20,
+};
+
+enum pm2xxx_source_reg_int6 {
+	PM2XXX_INT6_S_ITVPWR2DROP	= 0x01,
+	PM2XXX_INT6_S_ITVPWR1DROP	= 0x02,
+	PM2XXX_INT6_S_ITVPWR2VALIDRISE	= 0x04,
+	PM2XXX_INT6_S_ITVPWR2VALIDFALL	= 0x08,
+	PM2XXX_INT6_S_ITVPWR1VALIDRISE	= 0x10,
+	PM2XXX_INT6_S_ITVPWR1VALIDFALL	= 0x20,
+};
+
+static enum power_supply_property pm2xxx_charger_ac_props[] = {
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+};
+
+static int pm2xxx_charger_voltage_map[] = {
+	3500 ,
+	3525 ,
+	3550 ,
+	3575 ,
+	3600 ,
+	3625 ,
+	3650 ,
+	3675 ,
+	3700 ,
+	3725 ,
+	3750 ,
+	3775 ,
+	3800 ,
+	3825 ,
+	3850 ,
+	3875 ,
+	3900 ,
+	3925 ,
+	3950 ,
+	3975 ,
+	4000 ,
+	4025 ,
+	4050 ,
+	4075 ,
+	4100 ,
+	4125 ,
+	4150 ,
+	4175 ,
+	4200 ,
+	4225 ,
+	4250 ,
+	4275 ,
+	4300 ,
+};
+
+static int pm2xxx_charger_current_map[] = {
+	200 ,
+	200 ,
+	400 ,
+	600 ,
+	800 ,
+	1000 ,
+	1200 ,
+	1400 ,
+	1600 ,
+	1800 ,
+	2000 ,
+	2200 ,
+	2400 ,
+	2600 ,
+	2800 ,
+	3000 ,
+};
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+/* PM2XXX registers list */
+static struct ddbg_register ddbg_pm2xxx_registers[] = {
+	DDBG_REG("PM2XXX_BATT_CTRL_REG1", PM2XXX_BATT_CTRL_REG1, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG2", PM2XXX_BATT_CTRL_REG2, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG3", PM2XXX_BATT_CTRL_REG3, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG4", PM2XXX_BATT_CTRL_REG4, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG5", PM2XXX_BATT_CTRL_REG5, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG6", PM2XXX_BATT_CTRL_REG6, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG7", PM2XXX_BATT_CTRL_REG7, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG8", PM2XXX_BATT_CTRL_REG8, DDBG_RW),
+	DDBG_REG("PM2XXX_NTC_CTRL_REG1", PM2XXX_NTC_CTRL_REG1, DDBG_RW),
+	DDBG_REG("PM2XXX_NTC_CTRL_REG2", PM2XXX_NTC_CTRL_REG2, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_CTRL_REG9", PM2XXX_BATT_CTRL_REG9, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_STAT_REG1", PM2XXX_BATT_STAT_REG1, DDBG_RO),
+	DDBG_REG("PM2XXX_INP_VOLT_VPWR2", PM2XXX_INP_VOLT_VPWR2, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_DROP_VPWR2", PM2XXX_INP_DROP_VPWR2, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_VOLT_VPWR1", PM2XXX_INP_VOLT_VPWR1, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_DROP_VPWR1", PM2XXX_INP_DROP_VPWR1, DDBG_RW),
+	DDBG_REG("PM2XXX_INP_MODE_VPWR", PM2XXX_INP_MODE_VPWR, DDBG_RW),
+	DDBG_REG("PM2XXX_BATT_WD_KICK", PM2XXX_BATT_WD_KICK, DDBG_RW),
+	DDBG_REG("PM2XXX_DEV_VER_STAT", PM2XXX_DEV_VER_STAT, DDBG_RO),
+	DDBG_REG("PM2XXX_THERM_WARN_CTRL", PM2XXX_THERM_WARN_CTRL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_BAT_DISC_REG", PM2XXX_BATT_DISC_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_BAT_LWLEV_CMP", PM2XXX_BATT_LOW_LEV_COMP_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_BAT_LWLEV_VAL", PM2XXX_BATT_LOW_LEV_VAL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_I2C_PAD_CTRL_REG", PM2XXX_I2C_PAD_CTRL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_SW_CTRL_REG", PM2XXX_SW_CTRL_REG, DDBG_RW),
+	DDBG_REG("PM2XXX_LED_CTRL_REG", PM2XXX_LED_CTRL_REG, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT1", PM2XXX_REG_INT1, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT1", PM2XXX_MASK_REG_INT1, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT1", PM2XXX_SRCE_REG_INT1, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT2", PM2XXX_REG_INT2, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT2", PM2XXX_MASK_REG_INT2, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT2", PM2XXX_SRCE_REG_INT2, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT3", PM2XXX_REG_INT3, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT3", PM2XXX_MASK_REG_INT3, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT3", PM2XXX_SRCE_REG_INT3, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT4", PM2XXX_REG_INT4, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT4", PM2XXX_MASK_REG_INT4, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT4", PM2XXX_SRCE_REG_INT4, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT5", PM2XXX_REG_INT5, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT5", PM2XXX_MASK_REG_INT5, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT5", PM2XXX_SRCE_REG_INT5, DDBG_RO),
+	DDBG_REG("PM2XXX_REG_INT6", PM2XXX_REG_INT6, DDBG_RO),
+	DDBG_REG("PM2XXX_MASK_REG_INT6", PM2XXX_MASK_REG_INT6, DDBG_RW),
+	DDBG_REG("PM2XXX_SRCE_REG_INT6", PM2XXX_SRCE_REG_INT6, DDBG_RO),
+	DDBG_REG_NULL,
+};
+
+static struct pm2xxx_charger *pm2xxx_ddbg;
+#endif
+
+struct pm2xxx_irq {
+	char *name;
+	irqreturn_t (*isr)(int irq, void *data);
+};
+
+struct pm2xxx_charger_info {
+	int charger_connected;
+	int charger_online;
+	int charger_voltage;
+	int cv_active;
+	bool wd_expired;
+};
+
+struct pm2xxx_charger_event_flags {
+	bool mainextchnotok;
+	bool main_thermal_prot;
+	bool ovv;
+	bool chgwdexp;
+};
+
+struct pm2xxx_config {
+	struct i2c_client *pm2xxx_i2c;
+	struct i2c_device_id *pm2xxx_id;
+};
+
+struct pm2xxx_charger {
+	struct device *dev;
+	u8 chip_id;
+	bool vddadc_en_ac;
+	struct pm2xxx_config config;
+	bool ac_conn;
+	unsigned int gpio_irq;
+	int vbat;
+	int old_vbat;
+	int failure_case;
+	int failure_input_ovv;
+	int pm2_int[6];
+	struct ab8500_gpadc *gpadc;
+	struct regulator *regu;
+	struct pm2xxx_bm_data *bat;
+	struct mutex lock;
+	struct ab8500 *parent;
+	struct pm2xxx_charger_info ac;
+	struct pm2xxx_charger_platform_data *pdata;
+	struct workqueue_struct *charger_wq;
+	struct delayed_work check_vbat_work;
+	struct work_struct ac_work;
+	struct work_struct check_main_thermal_prot_work;
+	struct ux500_charger ac_chg;
+	struct pm2xxx_charger_event_flags flags;
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+	struct dentry *ddbg_dir_pm2xxx;
+#endif
+};
+
+static const struct i2c_device_id pm2xxx_ident[] = {
+	{ "pm2301", 0 },
+	{ }
+};
+
+static int __pm2xxx_read(struct pm2xxx_charger *pm2, int reg, int num, u8 *data)
+{
+	int ret;
+
+	ret = i2c_smbus_read_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
+				num, (u8 *)data);
+	if (ret < 0)
+		dev_err(pm2->dev, "Error reading %d regs at %d\n", num, reg);
+
+	return ret;
+}
+
+static int __pm2xxx_write(struct pm2xxx_charger *pm2, int reg, int num, u8 data)
+{
+	int ret;
+
+	ret = i2c_smbus_write_i2c_block_data(pm2->config.pm2xxx_i2c, reg,
+				num, &data);
+	if (ret < 0)
+		dev_err(pm2->dev, "Error writing %d regs at %d\n", num, reg);
+
+	return ret;
+
+}
+
+static int pm2xxx_reg_read(struct pm2xxx_charger *pm2, int reg)
+{
+	u8 val;
+
+	__pm2xxx_read(pm2, reg, 1, &val);
+
+	return val;
+}
+
+static int pm2xxx_reg_write(struct pm2xxx_charger *pm2, int reg, u8 val)
+{
+	int ret;
+
+	ret = __pm2xxx_write(pm2, reg, 1, val);
+
+	return ret;
+}
+
+int pm2xxx_charging_enable_mngt(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+       /* Enable charging */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG2,
+		(PM2XXX_CH_AUTO_RESUME_EN | PM2XXX_CHARGER_ENA));
+
+	return ret;
+}
+
+int pm2xxx_charging_disable_mngt(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+       /* Disable charging */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG2,
+		(PM2XXX_CH_AUTO_RESUME_DIS | PM2XXX_CHARGER_DIS));
+
+	return ret;
+}
+
+int pm2xxx_charger_batt_therm_mngt(struct pm2xxx_charger *pm2, int val)
+{
+	queue_work(pm2->charger_wq, &pm2->check_main_thermal_prot_work);
+
+	return 0;
+}
+
+
+int pm2xxx_charger_die_therm_mngt(struct pm2xxx_charger *pm2, int val)
+{
+	queue_work(pm2->charger_wq, &pm2->check_main_thermal_prot_work);
+
+	return 0;
+}
+
+int pm2xxx_charger_ovv_mngt(struct pm2xxx_charger *pm2, int val)
+{
+	int ret = 0;
+
+	pm2->failure_input_ovv++;
+	if (pm2->failure_input_ovv < 4) {
+		ret = pm2xxx_charging_enable_mngt(pm2);
+		goto out;
+	} else {
+		pm2->failure_input_ovv = 0;
+		dev_err(pm2->dev, "Overvoltage detected\n");
+		pm2->flags.ovv = true;
+		power_supply_changed(&pm2->ac_chg.psy);
+	}
+
+out:
+	return ret;
+}
+
+int pm2xxx_charger_wd_exp_mngt(struct pm2xxx_charger *pm2, int val)
+{
+	dev_dbg(pm2->dev , "20 minutes watchdog occured\n");
+
+	pm2->ac.wd_expired = true;
+	power_supply_changed(&pm2->ac_chg.psy);
+
+	return 0;
+}
+
+int pm2xxx_charger_vbat_lsig_mngt(struct pm2xxx_charger *pm2, int val)
+{
+	switch (val) {
+	case PM2XXX_INT1_ITVBATLOWR:
+		dev_dbg(pm2->dev, "VBAT grows above VBAT_LOW level\n");
+		/* TODO: Handle this */
+		break;
+
+	case PM2XXX_INT1_ITVBATLOWF:
+		dev_dbg(pm2->dev, "VBAT drops below VBAT_LOW level\n");
+		/* TODO: Handle this */
+		break;
+
+	default:
+		dev_err(pm2->dev, "Unknown VBAT level\n");
+	}
+
+	return 0;
+}
+
+int pm2xxx_charger_bat_disc_mngt(struct pm2xxx_charger *pm2, int val)
+{
+	int ret;
+
+	dev_dbg(pm2->dev, "battery disconnected\n");
+
+	/* TODO: Update charging status */
+	ret = pm2xxx_charging_disable_mngt(pm2);
+
+	return ret;
+}
+
+static int pm2xxx_charger_detection(struct pm2xxx_charger *pm2)
+{
+	int ret = 0;
+
+	ret = pm2xxx_reg_read(pm2, PM2XXX_SRCE_REG_INT2);
+
+	if (ret < 0) {
+		dev_err(pm2->dev, "Charger detection failed\n");
+		return ret;
+	}
+
+	ret &= (PM2XXX_INT2_S_ITVPWR1PLUG | PM2XXX_INT2_S_ITVPWR2PLUG);
+
+	return ret;
+}
+
+static int pm2xxx_charger_itv_pwr_plug_mngt(struct pm2xxx_charger *pm2, int val)
+{
+
+	int ret;
+
+	/*
+	 * Since we can't be sure that the events are received
+	 * synchronously, we have the check if the main charger is
+	 * connected by reading the interrupt source register.
+	 */
+	ret = pm2xxx_charger_detection(pm2);
+
+	if (ret > 0) {
+		pm2->ac.charger_connected = 1;
+		pm2->ac_conn = true;
+
+		queue_work(pm2->charger_wq, &pm2->ac_work);
+	}
+
+
+	return ret;
+}
+
+static int pm2xxx_charger_itv_pwr_unplug_mngt(struct pm2xxx_charger *pm2,
+								int val)
+{
+	pm2->ac.charger_connected = 0;
+	queue_work(pm2->charger_wq, &pm2->ac_work);
+
+	return 0;
+}
+
+static int pm2_int_reg0(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+	if (pm2->pm2_int[0] &
+			(PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF)) {
+		ret = pm2xxx_charger_vbat_lsig_mngt(pm2, pm2->pm2_int[0] &
+			(PM2XXX_INT1_ITVBATLOWR | PM2XXX_INT1_ITVBATLOWF));
+	}
+
+	if (pm2->pm2_int[0] & PM2XXX_INT1_ITVBATDISCONNECT) {
+		ret = pm2xxx_charger_bat_disc_mngt(pm2,
+				PM2XXX_INT1_ITVBATDISCONNECT);
+	}
+
+	return ret;
+}
+
+static int pm2_int_reg1(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+	if (pm2->pm2_int[1] &
+		(PM2XXX_INT2_ITVPWR1PLUG | PM2XXX_INT2_ITVPWR2PLUG)) {
+		dev_dbg(pm2->dev , "Main charger plugged\n");
+		ret = pm2xxx_charger_itv_pwr_plug_mngt(pm2, pm2->pm2_int[1] &
+			(PM2XXX_INT2_ITVPWR1PLUG | PM2XXX_INT2_ITVPWR2PLUG));
+	}
+
+	if (pm2->pm2_int[1] &
+		(PM2XXX_INT2_ITVPWR1UNPLUG | PM2XXX_INT2_ITVPWR2UNPLUG)) {
+		dev_dbg(pm2->dev , "Main charger unplugged\n");
+		ret = pm2xxx_charger_itv_pwr_unplug_mngt(pm2, pm2->pm2_int[1] &
+						(PM2XXX_INT2_ITVPWR1UNPLUG |
+						PM2XXX_INT2_ITVPWR2UNPLUG));
+	}
+
+
+	return ret;
+}
+
+static int pm2_int_reg2(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+	if (pm2->pm2_int[2] & PM2XXX_INT3_ITAUTOTIMEOUTWD)
+		ret = pm2xxx_charger_wd_exp_mngt(pm2, pm2->pm2_int[2]);
+
+	if (pm2->pm2_int[2] & (PM2XXX_INT3_ITCHPRECHARGEWD |
+				PM2XXX_INT3_ITCHCCWD | PM2XXX_INT3_ITCHCVWD)) {
+		dev_dbg(pm2->dev,
+			"Watchdog occured for precharge, CC and CV charge\n");
+
+		/*TODO: handle watchdog expired */
+	}
+
+	return ret;
+}
+
+static int pm2_int_reg3(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITCHARGINGON)) {
+		dev_dbg(pm2->dev ,
+			"chargind operation has started\n");
+
+		/* TODO: Handle charging started */
+	}
+
+	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITVRESUME)) {
+
+		dev_dbg(pm2->dev,
+			"battery discharged down to VResume threshold\n");
+
+		/* TODO: Handle recharging */
+	}
+
+	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITBATTFULL)) {
+
+		dev_dbg(pm2->dev , "battery fully detected\n");
+
+		/* TODO: Handle battery full */
+	}
+
+	if (pm2->pm2_int[3] & (PM2XXX_INT4_ITCVPHASE)) {
+
+		dev_dbg(pm2->dev, "CV phase enter with 0.5C charging\n");
+
+		/* TODO: Handle CC to CV transition */
+	}
+
+	if (pm2->pm2_int[3] &
+			(PM2XXX_INT4_ITVPWR2OVV | PM2XXX_INT4_ITVPWR1OVV)) {
+		pm2->failure_case = VPWR_OVV;
+		ret = pm2xxx_charger_ovv_mngt(pm2, pm2->pm2_int[3] &
+			(PM2XXX_INT4_ITVPWR2OVV | PM2XXX_INT4_ITVPWR1OVV));
+		dev_dbg(pm2->dev, "VPWR/VSYSTEM overvoltage detected\n");
+	}
+
+	if (pm2->pm2_int[3] & (PM2XXX_INT4_S_ITBATTEMPCOLD |
+				PM2XXX_INT4_S_ITBATTEMPHOT)) {
+
+		pm2xxx_charger_batt_therm_mngt(pm2,
+			pm2->pm2_int[3] & (PM2XXX_INT4_S_ITBATTEMPCOLD |
+					PM2XXX_INT4_S_ITBATTEMPHOT));
+		dev_dbg(pm2->dev, "BTEMP is too Low/High\n");
+	}
+
+	return ret;
+}
+
+static int pm2_int_reg4(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+	if (pm2->pm2_int[4] & PM2XXX_INT5_ITVSYSTEMOVV) {
+		pm2->failure_case = VSYSTEM_OVV;
+		ret = pm2xxx_charger_ovv_mngt(pm2, pm2->pm2_int[4] &
+						PM2XXX_INT5_ITVSYSTEMOVV);
+		dev_dbg(pm2->dev, "VSYSTEM overvoltage detected\n");
+	}
+
+	if (pm2->pm2_int[4] & (PM2XXX_INT5_ITTHERMALWARNINGFALL |
+				PM2XXX_INT5_ITTHERMALWARNINGRISE |
+				PM2XXX_INT5_ITTHERMALSHUTDOWNFALL |
+				PM2XXX_INT5_ITTHERMALSHUTDOWNRISE)) {
+		dev_dbg(pm2->dev, "BTEMP die temperature is too Low/High\n");
+		ret = pm2xxx_charger_die_therm_mngt(pm2, pm2->pm2_int[4] &
+			(PM2XXX_INT5_ITTHERMALWARNINGFALL |
+			PM2XXX_INT5_ITTHERMALWARNINGRISE |
+			PM2XXX_INT5_ITTHERMALSHUTDOWNFALL |
+			PM2XXX_INT5_ITTHERMALSHUTDOWNRISE));
+	}
+
+	return ret;
+}
+
+static int pm2_int_reg5(struct pm2xxx_charger *pm2)
+{
+
+	if (pm2->pm2_int[5]
+		& (PM2XXX_INT6_ITVPWR2DROP | PM2XXX_INT6_ITVPWR1DROP)) {
+		dev_dbg(pm2->dev, "VMPWR drop to VBAT level\n");
+
+		/* TODO: handle this */
+	}
+
+	if (pm2->pm2_int[5] & (PM2XXX_INT6_ITVPWR2VALIDRISE |
+				PM2XXX_INT6_ITVPWR1VALIDRISE |
+				PM2XXX_INT6_ITVPWR2VALIDFALL |
+				PM2XXX_INT6_ITVPWR1VALIDFALL)) {
+		dev_dbg(pm2->dev, "Falling/Rising edge on WPWR1/2\n");
+
+		/* TODO: handle this */
+	}
+
+	return 0;
+}
+
+static irqreturn_t  pm2xxx_irq_int(int irq, void *data)
+{
+	struct pm2xxx_charger *pm2 = data;
+	int ret, i;
+
+	for (i = 0; i < ARRAY_SIZE(pm2->pm2_int); i++) {
+		ret = pm2xxx_reg_read(pm2, pm2xxx_interrupt_registers[i]);
+		pm2->pm2_int[i] = ret;
+	}
+
+	pm2_int_reg0(pm2);
+	pm2_int_reg1(pm2);
+	pm2_int_reg2(pm2);
+	pm2_int_reg3(pm2);
+	pm2_int_reg4(pm2);
+	pm2_int_reg5(pm2);
+
+	return IRQ_HANDLED;
+}
+
+int pm2xxx_charger_led_en(struct pm2xxx_charger *pm2, int on)
+{
+	return 0;
+}
+
+static int pm2xxx_charger_get_ac_voltage(struct pm2xxx_charger *pm2)
+{
+	int vch = 0;
+
+	if (pm2->ac.charger_connected) {
+		vch = ab8500_gpadc_convert(pm2->gpadc, MAIN_CHARGER_V);
+		if (vch < 0)
+			dev_err(pm2->dev, "%s gpadc conv failed,\n", __func__);
+	}
+
+	return vch;
+}
+
+static int pm2xxx_charger_ac_cv(struct pm2xxx_charger *pm2)
+{
+	int ret = 0;
+
+	if (pm2->ac.charger_connected && pm2->ac.charger_online) {
+
+		ret = pm2xxx_reg_read(pm2, PM2XXX_SRCE_REG_INT4);
+		if (ret < 0) {
+			dev_err(pm2->dev, "%s pm2xxx read failed\n", __func__);
+			return 0;
+		}
+
+		if (ret & PM2XXX_INT4_S_ITCVPHASE)
+			ret = 1;
+		else
+			ret = 0;
+	}
+
+	return ret;
+}
+
+static int pm2xxx_charger_get_ac_current(struct pm2xxx_charger *pm2)
+{
+	int ich = 0;
+
+	if (pm2->ac.charger_online) {
+		ich = ab8500_gpadc_convert(pm2->gpadc, MAIN_CHARGER_C);
+		if (ich < 0)
+			dev_err(pm2->dev, "%s gpadc conv failed\n", __func__);
+	}
+
+	return ich;
+}
+
+static int pm2xxx_current_to_regval(int curr)
+{
+	int i;
+
+	if (curr < pm2xxx_charger_current_map[0])
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(pm2xxx_charger_current_map); i++) {
+		if (curr < pm2xxx_charger_current_map[i])
+			return i - 1;
+	}
+
+	i = ARRAY_SIZE(pm2xxx_charger_current_map) - 1;
+	if (curr == pm2xxx_charger_current_map[i])
+		return i;
+	else
+		return -1;
+}
+
+static int pm2xxx_voltage_to_regval(int curr)
+{
+	int i;
+
+	if (curr < pm2xxx_charger_voltage_map[0])
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(pm2xxx_charger_voltage_map); i++) {
+		if (curr < pm2xxx_charger_voltage_map[i])
+			return i - 1;
+	}
+
+	i = ARRAY_SIZE(pm2xxx_charger_voltage_map) - 1;
+	if (curr == pm2xxx_charger_voltage_map[i])
+		return i;
+	else
+		return -1;
+}
+
+static int pm2xxx_charger_update_charger_current(struct ux500_charger *charger,
+		int ich_out)
+{
+	int ret;
+	int curr_index;
+	struct pm2xxx_charger *pm2;
+
+	if (charger->psy.type == POWER_SUPPLY_TYPE_MAINS)
+		pm2 = to_pm2xxx_charger_ac_device_info(charger);
+	else
+		return -ENXIO;
+
+	curr_index = pm2xxx_current_to_regval(ich_out);
+	if (curr_index < 0) {
+		dev_err(pm2->dev,
+			"Charger current too high, "
+			"charging not started\n");
+		return -ENXIO;
+	}
+
+	ret = pm2xxx_reg_read(pm2, PM2XXX_BATT_CTRL_REG6);
+	if (ret >= 0) {
+		ret &= ~0xf;
+		ret |= curr_index;
+		ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG6, ret);
+		if (ret < 0) {
+			dev_err(pm2->dev,
+				"%s write failed\n", __func__);
+			}
+		}
+
+	return ret;
+}
+
+static int pm2xxx_charger_ac_get_property(struct power_supply *psy,
+	enum power_supply_property psp,
+	union power_supply_propval *val)
+{
+	struct pm2xxx_charger *pm2;
+
+	pm2 = to_pm2xxx_charger_ac_device_info(psy_to_ux500_charger(psy));
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_HEALTH:
+		if (pm2->flags.mainextchnotok)
+			val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		else if (pm2->ac.wd_expired)
+			val->intval = POWER_SUPPLY_HEALTH_DEAD;
+		else if (pm2->flags.main_thermal_prot)
+			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		else
+			val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = pm2->ac.charger_online;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = pm2->ac.charger_connected;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		pm2->ac.charger_voltage = pm2xxx_charger_get_ac_voltage(pm2);
+		val->intval = pm2->ac.charger_voltage * 1000;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		pm2->ac.cv_active = pm2xxx_charger_ac_cv(pm2);
+		val->intval = pm2->ac.cv_active;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = pm2xxx_charger_get_ac_current(pm2) * 1000;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int pm2xxx_charging_init(struct pm2xxx_charger *pm2)
+{
+	int ret;
+
+	/*  enable CC and CV watchdog */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG3,
+		(PM2XXX_CH_WD_CV_PHASE_60MIN | PM2XXX_CH_WD_CC_PHASE_60MIN));
+
+	/*  enable precharge watchdog */
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG4,
+					PM2XXX_CH_WD_PRECH_PHASE_60MIN);
+
+	return ret;
+}
+
+static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
+	int enable, int vset, int iset)
+{
+	int ret;
+	int volt_index;
+	int curr_index;
+
+	struct pm2xxx_charger *pm2 = to_pm2xxx_charger_ac_device_info(charger);
+
+	if (enable) {
+		if (!pm2->ac.charger_connected) {
+			dev_dbg(pm2->dev, "AC charger not connected\n");
+			return -ENXIO;
+		}
+
+		dev_dbg(pm2->dev, "Enable AC: %dmV %dmA\n", vset, iset);
+		if (!pm2->vddadc_en_ac) {
+			regulator_enable(pm2->regu);
+			pm2->vddadc_en_ac = true;
+		}
+
+		pm2xxx_charging_init(pm2);
+
+		volt_index = pm2xxx_voltage_to_regval(vset);
+		curr_index = pm2xxx_current_to_regval(iset);
+
+		if (volt_index < 0 || curr_index < 0) {
+			dev_err(pm2->dev,
+				"Charger voltage or current too high, "
+				"charging not started\n");
+			return -ENXIO;
+		}
+
+		ret = pm2xxx_reg_read(pm2, PM2XXX_BATT_CTRL_REG8);
+		if (ret >= 0) {
+			ret &= ~0x3F;
+			ret |= volt_index;
+			ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG8, ret);
+
+			if (ret < 0) {
+				dev_err(pm2->dev,
+					"%s write failed\n", __func__);
+				goto error_occured;
+			}
+		}
+
+		ret = pm2xxx_reg_read(pm2, PM2XXX_BATT_CTRL_REG6);
+		if (ret >= 0) {
+			ret &= ~0xf;
+			ret |= curr_index;
+			ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_CTRL_REG6, ret);
+			if (ret < 0) {
+				dev_err(pm2->dev,
+					"%s write failed\n", __func__);
+				goto error_occured;
+			}
+		}
+
+		if (!pm2->bat->enable_overshoot) {
+			ret = pm2xxx_reg_read(pm2, PM2XXX_LED_CTRL_REG);
+			if (ret >= 0) {
+				ret |= 0x01;
+				ret = pm2xxx_reg_write(pm2, PM2XXX_LED_CTRL_REG,
+							ret);
+				if (ret < 0)
+					goto error_occured;
+			}
+		}
+
+		ret = pm2xxx_charging_enable_mngt(pm2);
+		if (ret) {
+			dev_err(pm2->dev, "%s write failed\n", __func__);
+			return ret;
+		}
+
+		/*TODO: Add pm2301 Enable LED code */
+
+		pm2->ac.charger_online = 1;
+	} else {
+		/* TODO: add correct LED disable code */
+
+		pm2->ac.charger_online = 0;
+		pm2->ac.wd_expired = false;
+
+		/* Disable regulator if enabled */
+		if (pm2->vddadc_en_ac) {
+			regulator_disable(pm2->regu);
+			pm2->vddadc_en_ac = false;
+		}
+
+		ret = pm2xxx_charging_disable_mngt(pm2);
+		if (ret) {
+			dev_err(pm2->dev, "%s write failed\n", __func__);
+			return ret;
+		}
+
+		dev_dbg(pm2->dev, "PM2301: " "Disabled AC charging\n");
+	}
+	power_supply_changed(&pm2->ac_chg.psy);
+
+error_occured:
+	return ret;
+}
+
+static int pm2xxx_charger_watchdog_kick(struct ux500_charger *charger)
+{
+	int ret;
+	struct pm2xxx_charger *pm2;
+
+	if (charger->psy.type == POWER_SUPPLY_TYPE_MAINS)
+		pm2 = to_pm2xxx_charger_ac_device_info(charger);
+	else
+		return -ENXIO;
+
+	ret = pm2xxx_reg_write(pm2, PM2XXX_BATT_WD_KICK, WD_TIMER);
+	if (ret)
+		dev_err(pm2->dev, "Failed to kick WD!\n");
+
+	return ret;
+}
+
+static void pm2xxx_charger_ac_work(struct work_struct *work)
+{
+	struct pm2xxx_charger *pm2 = container_of(work,
+		struct pm2xxx_charger, ac_work);
+
+
+	power_supply_changed(&pm2->ac_chg.psy);
+	sysfs_notify(&pm2->ac_chg.psy.dev->kobj, NULL, "present");
+};
+
+/* TODO: how thermal protection is handled in pm2301 */
+static void pm2xxx_charger_check_main_thermal_prot_work(
+	struct work_struct *work)
+{
+
+	/* TODO: check the thermal and die thermal protection */
+};
+
+static struct pm2xxx_irq pm2xxx_charger_irq[] = {
+	{"PM2XXX_IRQ_INT", pm2xxx_irq_int},
+};
+
+static int pm2xxx_wall_charger_resume(struct i2c_client *i2c_client)
+{
+	return 0;
+}
+
+static int pm2xxx_wall_charger_suspend(struct i2c_client *i2c_client,
+	pm_message_t state)
+{
+	return 0;
+}
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+static int pm2xxx_ddbg_write(u32 addr, u32 val)
+{
+	int err;
+
+	err = pm2xxx_reg_write(pm2xxx_ddbg, addr, val);
+
+	if (err < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int pm2xxx_ddbg_read(u32 addr, u32 *val)
+{
+	*val = pm2xxx_reg_read(pm2xxx_ddbg, addr);
+
+	if (val < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static struct ddbg_target ddbg_pm2xxx = {
+	.phyaddr = 0,
+	.reg = ddbg_pm2xxx_registers,
+	.read_reg = pm2xxx_ddbg_read,
+	.write_reg = pm2xxx_ddbg_write,
+};
+#endif
+
+static int __devinit pm2xxx_wall_charger_probe(struct i2c_client *i2c_client,
+		const struct i2c_device_id *id)
+{
+	struct pm2xxx_platform_data *pl_data = i2c_client->dev.platform_data;
+	struct pm2xxx_charger *pm2;
+	int ret = 0;
+
+	pm2 = kzalloc(sizeof(struct pm2xxx_charger), GFP_KERNEL);
+	if (!pm2)
+		return -ENOMEM;
+
+	/* get parent data */
+	pm2->dev = &i2c_client->dev;
+	pm2->gpadc = ab8500_gpadc_get();
+
+	/* get charger spcific platform data */
+	if (!pl_data->wall_charger) {
+		dev_err(pm2->dev, "no charger platform data supplied\n");
+		ret = -EINVAL;
+		goto free_device_info;
+	}
+
+	pm2->pdata = pl_data->wall_charger;
+
+	/* get battery specific platform data */
+	if (!pl_data->battery) {
+		dev_err(pm2->dev, "no battery platform data supplied\n");
+		ret = -EINVAL;
+		goto free_device_info;
+	}
+
+	pm2->bat = pl_data->battery;
+
+	if (!i2c_check_functionality(i2c_client->adapter,
+			I2C_FUNC_SMBUS_BYTE_DATA |
+			I2C_FUNC_SMBUS_READ_WORD_DATA)) {
+		ret = -ENODEV;
+		dev_info(pm2->dev, "pm2301 i2c_check_functionality failed\n");
+		goto free_device_info;
+	}
+
+	pm2->config.pm2xxx_i2c = i2c_client;
+	pm2->config.pm2xxx_id = (struct i2c_device_id *) id;
+	i2c_set_clientdata(i2c_client, pm2);
+
+	/* AC supply */
+	/* power_supply base class */
+	pm2->ac_chg.psy.name = pm2->pdata->label;
+	pm2->ac_chg.psy.type = POWER_SUPPLY_TYPE_MAINS;
+	pm2->ac_chg.psy.properties = pm2xxx_charger_ac_props;
+	pm2->ac_chg.psy.num_properties = ARRAY_SIZE(pm2xxx_charger_ac_props);
+	pm2->ac_chg.psy.get_property = pm2xxx_charger_ac_get_property;
+	pm2->ac_chg.psy.supplied_to = pm2->pdata->supplied_to;
+	pm2->ac_chg.psy.num_supplicants = pm2->pdata->num_supplicants;
+	/* pm2xxx_charger sub-class */
+	pm2->ac_chg.ops.enable = &pm2xxx_charger_ac_en;
+	pm2->ac_chg.ops.kick_wd = &pm2xxx_charger_watchdog_kick;
+	pm2->ac_chg.ops.update_curr = &pm2xxx_charger_update_charger_current;
+	pm2->ac_chg.max_out_volt = pm2xxx_charger_voltage_map[
+		ARRAY_SIZE(pm2xxx_charger_voltage_map) - 1];
+	pm2->ac_chg.max_out_curr = pm2xxx_charger_current_map[
+		ARRAY_SIZE(pm2xxx_charger_current_map) - 1];
+
+	/* Create a work queue for the charger */
+	pm2->charger_wq =
+		create_singlethread_workqueue("pm2xxx_charger_wq");
+	if (pm2->charger_wq == NULL) {
+		dev_err(pm2->dev, "failed to create work queue\n");
+		goto free_device_info;
+	}
+
+	/* Init work for charger detection */
+	INIT_WORK(&pm2->ac_work, pm2xxx_charger_ac_work);
+
+	/* Init work for checking HW status */
+	INIT_WORK(&pm2->check_main_thermal_prot_work,
+		pm2xxx_charger_check_main_thermal_prot_work);
+
+	/*
+	 * VDD ADC supply needs to be enabled from this driver when there
+	 * is a charger connected to avoid erroneous BTEMP_HIGH/LOW
+	 * interrupts during charging
+	 */
+	pm2->regu = regulator_get(pm2->dev, "vddadc");
+	if (IS_ERR(pm2->regu)) {
+		ret = PTR_ERR(pm2->regu);
+		dev_err(pm2->dev, "failed to get vddadc regulator\n");
+		goto free_charger_wq;
+	}
+
+	/* Register AC charger class */
+	ret = power_supply_register(pm2->dev, &pm2->ac_chg.psy);
+	if (ret) {
+		dev_err(pm2->dev, "failed to register AC charger\n");
+		goto free_regulator;
+	}
+
+	/* Register interrupts */
+	ret = request_threaded_irq(pm2->pdata->irq_number, NULL,
+				pm2xxx_charger_irq[0].isr,
+				pm2->pdata->irq_type,
+				pm2xxx_charger_irq[0].name, pm2);
+
+	if (ret != 0) {
+		dev_err(pm2->dev, "failed to request %s IRQ %d: %d\n"
+		, pm2xxx_charger_irq[0].name, pm2->pdata->irq_number, ret);
+		goto unregister_pm2xxx_charger;
+	}
+
+	/* TODO: I2C Read/Write will fail, if AC adaptor is not connected.
+	 * fix the charger detection mechanism.
+	 */
+	ret = pm2xxx_charger_detection(pm2);
+
+	if (ret > 0) {
+		pm2->ac.charger_connected = 1;
+		pm2->ac_conn = true;
+		power_supply_changed(&pm2->ac_chg.psy);
+		sysfs_notify(&pm2->ac_chg.psy.dev->kobj, NULL, "present");
+	}
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+	pm2xxx_ddbg = pm2;
+	pm2->ddbg_dir_pm2xxx = debugfs_create_dir("pm2xxx", NULL);
+	if (pm2->ddbg_dir_pm2xxx == NULL) {
+		ret = -ENOMEM;
+		goto err_deep_debug;
+	}
+	ret = deep_debug_register(&ddbg_pm2xxx, pm2->ddbg_dir_pm2xxx);
+	if (ret)
+		goto err_deep_debug;
+#endif
+
+	return 0;
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+err_deep_debug:
+	if (pm2->ddbg_dir_pm2xxx) {
+		debugfs_remove_recursive(pm2->ddbg_dir_pm2xxx);
+		pm2->ddbg_dir_pm2xxx = NULL;
+	}
+	dev_err(pm2->dev, "failed to create debugfs entries.\n");
+
+	/* disable interrupt */
+	free_irq(pm2->pdata->irq_number, pm2);
+#endif
+
+unregister_pm2xxx_charger:
+	/* unregister power supply */
+	power_supply_unregister(&pm2->ac_chg.psy);
+free_regulator:
+	/* disable the regulator */
+	regulator_put(pm2->regu);
+free_charger_wq:
+	destroy_workqueue(pm2->charger_wq);
+free_device_info:
+	kfree(pm2);
+	return ret;
+}
+
+static int __devexit pm2xxx_wall_charger_remove(struct i2c_client *i2c_client)
+{
+	struct pm2xxx_charger *pm2 = i2c_get_clientdata(i2c_client);
+
+	/* Disable AC charging */
+	pm2xxx_charger_ac_en(&pm2->ac_chg, false, 0, 0);
+
+	/* Disable interrupts */
+	free_irq(pm2->pdata->irq_number, pm2);
+
+	/* Delete the work queue */
+	destroy_workqueue(pm2->charger_wq);
+
+#ifdef CONFIG_PM2XXX_DEEP_DEBUG
+	deep_debug_unregister(&ddbg_pm2xxx);
+	if (pm2->ddbg_dir_pm2xxx)
+		debugfs_remove_recursive(pm2->ddbg_dir_pm2xxx);
+#endif
+
+	flush_scheduled_work();
+
+	/* disable the regulator */
+	regulator_put(pm2->regu);
+
+	power_supply_unregister(&pm2->ac_chg.psy);
+
+	kfree(pm2);
+
+	return 0;
+}
+
+static const struct i2c_device_id pm2xxx_id[] = {
+	{ "pm2301", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, pm2xxx_id);
+
+static struct i2c_driver pm2xxx_charger_driver = {
+	.probe = pm2xxx_wall_charger_probe,
+	.remove = __devexit_p(pm2xxx_wall_charger_remove),
+	.suspend = pm2xxx_wall_charger_suspend,
+	.resume = pm2xxx_wall_charger_resume,
+	.driver = {
+		.name = "pm2xxx-wall_charger",
+		.owner = THIS_MODULE,
+	},
+	.id_table = pm2xxx_id,
+};
+
+static int __init pm2xxx_charger_init(void)
+{
+	return i2c_add_driver(&pm2xxx_charger_driver);
+}
+
+static void __exit pm2xxx_charger_exit(void)
+{
+	i2c_del_driver(&pm2xxx_charger_driver);
+}
+
+subsys_initcall_sync(pm2xxx_charger_init);
+module_exit(pm2xxx_charger_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Rajkumar kasirajan, Olivier Launay");
+MODULE_ALIAS("platform:pm2xxx-charger");
+MODULE_DESCRIPTION("PM2xxx charger management driver");
+
diff --git a/include/linux/pm2301_charger.h b/include/linux/pm2301_charger.h
new file mode 100644
index 0000000..16bb1d3
--- /dev/null
+++ b/include/linux/pm2301_charger.h
@@ -0,0 +1,60 @@
+/*
+ * PM2301 charger driver.
+ *
+ * Copyright (C) 2012 ST Ericsson Corporation
+ *
+ * Contact: Olivier LAUNAY (olivier.launay@stericsson.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_PM2301_H
+#define __LINUX_PM2301_H
+
+/**
+ * struct pm2xxx_bm_charger_parameters - Charger specific parameters
+ * @ac_volt_max:	maximum allowed AC charger voltage in mV
+ * @ac_curr_max:	maximum allowed AC charger current in mA
+ */
+struct pm2xxx_bm_charger_parameters {
+	int ac_volt_max;
+	int ac_curr_max;
+};
+
+/**
+ * struct pm2xxx_bm_data - pm2xxx battery management data
+ * @enable_overshoot    flag to enable VBAT overshoot control
+ * @chg_params	  charger parameters
+ */
+struct pm2xxx_bm_data {
+	bool enable_overshoot;
+	const struct pm2xxx_bm_charger_parameters *chg_params;
+};
+
+struct pm2xxx_charger_platform_data {
+	char **supplied_to;
+	size_t num_supplicants;
+	int i2c_bus;
+	const char *label;
+	int irq_number;
+	int irq_type;
+};
+
+struct pm2xxx_platform_data {
+	struct pm2xxx_charger_platform_data *wall_charger;
+	struct pm2xxx_bm_data *battery;
+};
+
+#endif /* __LINUX_PM2301_H */
-- 
1.7.9.5

