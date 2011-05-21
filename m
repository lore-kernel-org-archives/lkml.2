Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1EUMzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 08:55:16 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44586 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750822Ab1EUMzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 08:55:13 -0400
Date: Sat, 21 May 2011 14:55:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: cbou@mail.ru, dwmw2@infradead.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: spitz pm: add power monitoring driver
Message-ID: <20110521125511.GA10653@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds battery/charge monitoring driver for spitz. 

This is still not 100% done; spitz.c parts need small cleanups to fit
with the rest of code, and "limit" interface needs to be done.

Question is... who merges this when its done? Would it be ok to go
through PXA tree?

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 01c5769..5bf7f0e 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -921,6 +921,15 @@ static inline void spitz_i2c_init(void) {}
 #endif
 
 /******************************************************************************
+ * Battery
+ ******************************************************************************/
+
+static struct platform_device spitz_battery_device = {
+	.name	= "spitz-battery",
+	.id	= -1,
+};
+
+/******************************************************************************
  * Machine init
  ******************************************************************************/
 static void spitz_poweroff(void)
@@ -968,6 +977,7 @@ static void __init spitz_init(void)
 	spitz_nor_init();
 	spitz_nand_init();
 	spitz_i2c_init();
+	platform_device_register(&spitz_battery_device);
 }
 
 static void __init spitz_fixup(struct machine_desc *desc,
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 52a462f..df54d70 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -102,6 +102,12 @@ config BATTERY_COLLIE
 	  Say Y to enable support for the battery on the Sharp Zaurus
 	  SL-5500 (collie) models.
 
+config BATTERY_SPITZ
+	tristate "Sharp SL-3000C (spitz) battery"
+	help
+	  Say Y to enable support for the battery on the Sharp Zaurus
+	  SL-3000C (spitz) models.
+
 config BATTERY_WM97XX
 	bool "WM97xx generic battery driver"
 	depends on TOUCHSCREEN_WM97XX=y
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 8385bfa..7a82c1e 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_COLLIE)	+= collie_battery.o
+obj-$(CONFIG_BATTERY_SPITZ)	+= spitz_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
 obj-$(CONFIG_BATTERY_BQ20Z75)	+= bq20z75.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
diff --git a/drivers/power/spitz_battery.c b/drivers/power/spitz_battery.c
new file mode 100644
index 0000000..a612ff8
--- /dev/null
+++ b/drivers/power/spitz_battery.c
@@ -0,0 +1,318 @@
+/*
+ * Battery and Power Management code for the Sharp SL-3000c
+ *
+ * Copyright (c) 2009 Pavel Machek <pavel@ucw.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/platform_device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/power_supply.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+
+#include <asm/mach-types.h>
+#include <mach/spitz.h>
+#include <mach/sharpsl_pm.h>
+
+extern struct sharpsl_pm_status sharpsl_pm;
+
+struct spitz_bat {
+	struct power_supply psy;
+
+	bool (*is_present)(struct spitz_bat *bat);
+};
+
+static struct spitz_bat spitz_bat_main, spitz_ac;
+
+extern int sharpsl_pm_pxa_read_max1111(int channel);
+
+
+static int spitz_bat_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	int ret = 0;
+	struct spitz_bat *bat = container_of(psy, struct spitz_bat, psy);
+
+	val->intval = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_HEALTH:
+		/* POWER_SUPPLY_HEALTH_OVERHEAT , POWER_SUPPLY_HEALTH_COLD,
+		   POWER_SUPPLY_HEALTH_OVERVOLTAGE, POWER_SUPPLY_HEALTH_UNSPEC_FAILURE, POWER_SUPPLY_HEALTH_GOOD
+		 */
+		return 0;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		val->intval = POWER_SUPPLY_CHARGE_TYPE_NONE;
+	  	if (gpio_get_value(SPITZ_GPIO_CHRG_ON) == 0) {
+			if (gpio_get_value(SPITZ_GPIO_JK_B) == 1)
+				val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
+			else
+				val->intval = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		}
+		return 0;
+	case POWER_SUPPLY_PROP_STATUS:
+	  {
+		int status = 0;
+
+	  	if (gpio_get_value(SPITZ_GPIO_CHRG_ON) == 0)
+			printk("Chrg bit on. ");
+	  	if (gpio_get_value(SPITZ_GPIO_JK_B) == 0)
+			printk("Slow charge bit on. ");
+
+		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+
+		if (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN))
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else {
+			if (gpio_get_value(SPITZ_GPIO_CHRG_ON) == 0)
+				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+			if (sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_CHRGFULL))
+				val->intval = POWER_SUPPLY_STATUS_FULL;
+		}
+
+		printk("ACIN: %d ", sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN));
+		printk("Chrgfull: %d  ", sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_CHRGFULL));
+		printk("Fatal: %d  ", sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_FATAL));
+		printk("ACIN_volt: %d\n", sharpsl_pm.machinfo->read_devdata(SHARPSL_ACIN_VOLT));
+
+		return 0;
+	  }
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		/* Thanks to Stanislav B. ADC has 3.3V as reference,
+		   is connected to battery over 47kOhm,
+		   and to ground over 100kOhm. */
+		val->intval = (sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT) * 1470 * 3300)/256;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = 4200000;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = 3400000;
+		return 0;
+	case POWER_SUPPLY_PROP_TEMP:
+		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
+		sharpsl_pm.machinfo->measure_temp(1);
+		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
+		val->intval = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_TEMP);
+		sharpsl_pm.machinfo->measure_temp(0);
+		return 0;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = "spitz-battery";
+		return 0;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = 1;
+		return 0;
+		/* add these */
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = 2000000;
+		return 0;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = 42; //get_percentage( );
+		return 0;
+	default:
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+
+static int spitz_ac_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	int ret = 0;
+	struct spitz_bat *bat = container_of(psy, struct spitz_bat, psy);
+
+	val->intval = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		/* Thanks to Stanislav B. ADC has 3.3V as reference,
+		   is connected to acin over 2kOhm,
+		   and to ground over 1kOhm. */
+		val->intval = (sharpsl_pm.machinfo->read_devdata(SHARPSL_ACIN_VOLT) * 3000 * 3300)/256;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = 5250000;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = 4750000;
+		return 0;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = "spitz-power-supply";
+		return 0;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+
+static void spitz_bat_external_power_changed(struct power_supply *psy)
+{
+}
+
+
+static enum power_supply_property spitz_bat_main_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+};
+
+static struct spitz_bat spitz_bat_main = {
+	.psy = {
+		.name		= "main-battery",
+		.type		= POWER_SUPPLY_TYPE_BATTERY,
+		.properties	= spitz_bat_main_props,
+		.num_properties	= ARRAY_SIZE(spitz_bat_main_props),
+		.get_property	= spitz_bat_get_property,
+		.external_power_changed = spitz_bat_external_power_changed,
+		.use_for_apm	= 1,
+	},
+};
+
+static enum power_supply_property spitz_ac_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_PRESENT,
+};
+
+static struct spitz_bat spitz_ac = {
+	.psy = {
+		.name		= "ac",
+		.type		= POWER_SUPPLY_TYPE_MAINS,
+		.properties	= spitz_ac_props,
+		.num_properties	= ARRAY_SIZE(spitz_ac_props),
+		.get_property	= spitz_ac_get_property,
+	},
+};
+
+#ifdef CONFIG_PM
+static int spitz_bat_suspend(struct platform_device *dev, pm_message_t state)
+{
+	return 0;
+}
+
+static int spitz_bat_resume(struct platform_device *dev)
+{
+	return 0;
+}
+#else
+#define spitz_bat_suspend NULL
+#define spitz_bat_resume NULL
+#endif
+
+
+static ssize_t spitz_bat_limit_show(struct device *dev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	sprintf(buf, "Hello :-)");
+	return 9;
+}
+
+static ssize_t spitz_bat_limit_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	if (!strncmp(buf, "fastcharge", 10)) {
+		gpio_set_value(SPITZ_GPIO_JK_B, 1);
+		gpio_set_value(SPITZ_GPIO_CHRG_ON, 0);
+		return 10;
+	}
+	if (!strncmp(buf, "slowcharge", 10)) {
+		gpio_set_value(SPITZ_GPIO_JK_B, 0);
+		gpio_set_value(SPITZ_GPIO_CHRG_ON, 0);
+		return 10;
+	}
+	if (!strncmp(buf, "nonecharge", 10)) {
+		gpio_set_value(SPITZ_GPIO_JK_B, 0);
+		gpio_set_value(SPITZ_GPIO_CHRG_ON, 1);
+		return 10;
+	}
+	return -EINVAL;
+}
+
+static struct device_attribute spitz_limit_attr = {
+        .attr = { .name = "limit", .mode = 0644 },
+        .show = spitz_bat_limit_show,
+        .store = spitz_bat_limit_store,
+};
+
+static int __devinit spitz_bat_probe(struct platform_device *dev)
+{
+	int ret;
+	int i;
+
+	if (!machine_is_spitz())
+		return -ENODEV;
+
+	printk("spitz_bat_probe: register\n");
+	power_supply_register(&dev->dev, &spitz_bat_main.psy);
+	power_supply_register(&dev->dev, &spitz_ac.psy);
+	device_create_file(&dev->dev, &spitz_limit_attr);
+
+	return 0;
+}
+
+static int __devexit spitz_bat_remove(struct platform_device *dev)
+{
+	int i;
+
+	device_remove_file(&dev->dev, &spitz_limit_attr);
+	power_supply_unregister(&spitz_bat_main.psy);
+	power_supply_unregister(&spitz_ac.psy);
+	return 0;
+}
+
+
+static struct platform_driver spitz_bat_driver = {
+	.driver.name	= "spitz-battery",
+	.driver.owner	= THIS_MODULE,
+	.probe		= spitz_bat_probe,
+	.remove		= __devexit_p(spitz_bat_remove),
+	.suspend	= spitz_bat_suspend,
+	.resume		= spitz_bat_resume,
+};
+
+static int __init spitz_bat_init(void)
+{
+	return platform_driver_register(&spitz_bat_driver);
+}
+
+static void __exit spitz_bat_exit(void)
+{
+	platform_driver_unregister(&spitz_bat_driver);
+}
+
+module_init(spitz_bat_init);
+module_exit(spitz_bat_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pavel Machek");
+MODULE_DESCRIPTION("Spitz battery driver");
+MODULE_ALIAS("platform:spitz-battery");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
