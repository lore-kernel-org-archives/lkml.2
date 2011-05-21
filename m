Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1EURBd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 13:01:33 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53339 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752006Ab1EURBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 13:01:31 -0400
Date: Sat, 21 May 2011 19:01:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: cbou@mail.ru, dwmw2@infradead.org, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [Zaurus-devel] spitz pm: add power monitoring driver
Message-ID: <20110521170128.GA3017@elf.ucw.cz>
References: <20110521125511.GA10653@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521125511.GA10653@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds battery/charge monitoring driver for spitz.
  
This is version I'd like to see merged.
  
Is it ok for Marek to merge this?
  
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 785880f..513588c 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -68,6 +51,7 @@ static void sharpsl_battery_thread(struct work_struct *private_);
  * Variables
  */
 struct sharpsl_pm_status sharpsl_pm;
+EXPORT_SYMBOL(sharpsl_pm);
 static DECLARE_DELAYED_WORK(toggle_charger, sharpsl_charge_toggle);
 static DECLARE_DELAYED_WORK(sharpsl_bat, sharpsl_battery_thread);
 DEFINE_LED_TRIGGER(sharpsl_charge_led_trigger);
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index 01c5769..ddb1b24 100644
--- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -920,6 +920,25 @@ static void __init spitz_i2c_init(void)
 static inline void spitz_i2c_init(void) {}
 #endif
 
+
+/******************************************************************************
+ * Battery
+ ******************************************************************************/
+
+#if defined(CONFIG_BATTERY_SPITZ) || defined(CONFIG_BATTERY_SPITZ_MODULE)
+static struct platform_device spitz_battery_device = {
+	.name	= "spitz-battery",
+	.id	= -1,
+};
+
+static void __init spitz_battery_init(void)
+{
+	platform_device_register(&spitz_battery_device);	
+}
+#else
+static void __init spitz_battery_init(void) {}
+#endif
+
 /******************************************************************************
  * Machine init
  ******************************************************************************/
@@ -968,6 +987,7 @@ static void __init spitz_init(void)
 	spitz_nor_init();
 	spitz_nand_init();
 	spitz_i2c_init();
+	spitz_battery_init();
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
index 0000000..5981f58
--- /dev/null
+++ b/drivers/power/spitz_battery.c
@@ -0,0 +1,355 @@
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
+struct battery_thresh sharpsl_battery_levels[] = {
+	{ 3980, 100 },
+	{ 3900, 95 },
+	{ 3860, 90 },
+	{ 3800, 85 },
+	{ 3760, 80 },
+	{ 3720, 74 },
+	{ 3680, 69 },
+	{ 3620, 65 },
+	{ 3570, 59 },
+	{ 3560, 55 },
+	{ 3550, 48 },
+	{ 3530, 45 },
+	{ 3510, 39 },
+	{ 3490, 33 },
+	{ 3470, 29 },
+	{ 3450, 23 },
+	{ 3410, 16 },
+	{    0, 0 },
+};
+
+static struct spitz_bat spitz_bat_main, spitz_ac;
+
+extern int sharpsl_pm_pxa_read_max1111(int channel);
+
+typedef int milliamp_t;
+typedef int milliohm_t;
+typedef int millivolt_t;
+typedef int microvolt_t;
+
+milliamp_t basic_current = 125;
+milliohm_t battery_resistance = 100;
+
+/* 422 seems to be suitable for very old, 1Ah battery.
+   2Ah battery probably has better resistance */
+
+/* Unfortunately, resistance depends on state of charge, current
+ * direction and temperature.
+ *
+ * Ouch, and dependency is actually _not_ too simple. It is lowest
+ * at 3.55V, very slowly rises at 4V (approximately linear dependency),
+ * and quickly rises towards 3.2V (in something exponential-looking).
+ *
+ * It is about same at 25Celsius and 40Celsius, and about 2.5x the value
+ * on 0Celsius, rising _very_ sharply.
+ *
+ * Li-ion should only be charged between 0 and 45 Celsius, and discharged
+ * between -20 and 60 celsius.
+ */
+
+extern int backlight_current;
+
+/* Positive values: current drawn from battery */
+milliamp_t battery_current(void)
+{
+	int bl_status = sharpsl_pm.machinfo->backlight_get_status ? sharpsl_pm.machinfo->backlight_get_status() : 0;
+
+	printk("bl_status: %d\n", bl_status);
+
+	if (sharpsl_pm.charge_mode == CHRG_ON)
+		return 0;
+
+	/* FIXME: take backlight into account */
+	return basic_current;
+}
+
+millivolt_t liion_internal_voltage(millivolt_t voltage, milliamp_t current_ma)
+{
+	return voltage + (battery_resistance * current_ma / 1000);
+}
+
+
+static microvolt_t get_battery(void)
+{
+	/* Thanks to Stanislav B. ADC has 3.3V as reference,
+	   is connected to battery over 47kOhm,
+	   and to ground over 100kOhm. */
+	int adc = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
+	return (adc * 1470 * 3300)/256;
+}
+
+static int get_percentage(void)
+{
+	int i = sharpsl_pm.machinfo->bat_levels - 1;
+	struct battery_thresh *thresh;
+	millivolt_t voltage = get_battery()/1000;
+
+	thresh = sharpsl_battery_levels;
+
+	while (i > 0 && (voltage > thresh[i].voltage))
+		i--;
+
+	return thresh[i].percentage;
+}
+
+static int get_status(union power_supply_propval *val)
+{
+	if (gpio_get_value(SPITZ_GPIO_CHRG_ON) == 0)
+		printk("Charge on. ");
+	if (gpio_get_value(SPITZ_GPIO_JK_B) == 0)
+		printk("Slow charge. ");
+
+	val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
+
+	if (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN))
+		val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+	else {
+		if (gpio_get_value(SPITZ_GPIO_CHRG_ON) == 0)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		if (sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_CHRGFULL))
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+	}
+
+	printk("ACIN: %d ", !!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN));
+	printk("Full: %d ", !!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_CHRGFULL));
+	printk("Fatal: %d ", !!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_FATAL));
+	printk("Percent: %d\n", get_percentage());
+
+	return 0;
+}
+
+static int spitz_bat_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
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
+		return get_status(val);
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = get_battery();
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
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval = 2000000;
+		return 0;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = get_percentage();
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
+
+static int __devinit spitz_bat_probe(struct platform_device *dev)
+{
+	if (!machine_is_spitz())
+		return -ENODEV;
+
+	printk("spitz_bat_probe: register\n");
+	power_supply_register(&dev->dev, &spitz_bat_main.psy);
+	power_supply_register(&dev->dev, &spitz_ac.psy);
+	return 0;
+}
+
+static int __devexit spitz_bat_remove(struct platform_device *dev)
+{
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
