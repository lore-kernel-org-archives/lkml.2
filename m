Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0GaGSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 02:18:46 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:39899 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754909Ab0GaGSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 02:18:44 -0400
Date: Sat, 31 Jul 2010 08:18:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marek Vasut <marek.vasut@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: zaurus battery patches
Message-ID: <20100731061816.GC4945@ucw.cz>
References: <201007301456.17464.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <201007301456.17464.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

...they certainly need more work. .7. version is newer but incomplete.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

--IJpNTDwzlM2Ie8A6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="zbattery.5.diff"

--- ./drivers/power.ofic/Makefile	2009-10-06 13:51:29.000000000 +0200
+++ ./drivers/power/Makefile	2009-10-11 16:12:09.000000000 +0200
@@ -24,6 +24,7 @@
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
+obj-m	+= spitz_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
diff -ur ./drivers/power.ofic/power_supply_sysfs.c ./drivers/power/power_supply_sysfs.c
--- ./drivers/power.ofic/power_supply_sysfs.c	2009-10-06 13:51:29.000000000 +0200
+++ ./drivers/power/power_supply_sysfs.c	2009-10-15 05:45:46.000000000 +0200
@@ -39,7 +39,8 @@
 
 static ssize_t power_supply_show_property(struct device *dev,
 					  struct device_attribute *attr,
-					  char *buf) {
+					  char *buf)
+{
 	static char *status_text[] = {
 		"Unknown", "Charging", "Discharging", "Not charging", "Full"
 	};
@@ -135,7 +136,8 @@
 
 static ssize_t power_supply_show_static_attrs(struct device *dev,
 					      struct device_attribute *attr,
-					      char *buf) {
+					      char *buf)
+{
 	static char *type_text[] = { "Battery", "UPS", "Mains", "USB" };
 	struct power_supply *psy = dev_get_drvdata(dev);
 
diff -ur ./drivers/power.ofic/spitz_battery.c ./drivers/power/spitz_battery.c
--- ./drivers/power.ofic/spitz_battery.c	2009-10-11 16:14:11.000000000 +0200
+++ ./drivers/power/spitz_battery.c	2009-10-22 07:27:52.000000000 +0200
@@ -0,0 +1,430 @@
+/*
+ * Battery and Power Management code for the Sharp SL-3000c
+ *
+ * Copyright (c) 2009 Pavel Machek <pavel@ucw.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Li-ion batteries are angry beasts, and they like to explode.
+ * If angry lithium comes your way, the hw was misdesigned.
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
+#include <mach/sharpsl.h>
+#include <mach/sharpsl_pm.h>
+
+#include "../../arch/arm/mach-pxa/sharpsl.h"
+
+extern struct sharpsl_pm_status sharpsl_pm;
+
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
+int basic_current = 125; /* miliAmp */
+int battery_resistance = 422; /* miliOhm */
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
+int battery_current(void)
+{
+	int intensity = sharpsl_pm.machinfo->backlight_get_status ? sharpsl_pm.machinfo->backlight_get_status() : 0;
+
+	return basic_current + backlight_current;
+}
+
+int liion_internal_voltage(int voltage, int current_ma)
+{
+	return voltage + (battery_resistance * current_ma / 1000);
+}
+
+int liion_expected_voltage(int internal_voltage, int current_ma)
+{       
+	return internal_voltage - (battery_resistance * current_ma / 1000);
+}
+
+/* returns mV */
+int liion_voltage(void)
+{
+	/* Thanks to Stanislav B. ADC has 3.3V as reference,
+	   is connected to battery over 47kOhm,
+	   and to ground over 100kOhm. */
+	return (sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT) * 147 * 33)/256;
+}
+
+/* See for example http://www.kokam.com/english/biz/rc.html for
+ * voltage/capacity characteristic. I assume it is going to be
+ * reasonably similar to li-ion used in collie.
+ *
+ */
+
+/*
+ { 420, 100 },
+ { 417, 95 }, means it will report 100% between 418 and 420
+ */
+
+struct battery_thresh battery_levels[] = {
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
+int get_percentage(void)
+{
+	int i = ARRAY_SIZE(battery_levels);
+	struct battery_thresh *thresh;
+	int voltage = liion_internal_voltage(liion_voltage(), battery_current());
+
+	thresh = battery_levels;
+
+	while (i > 0 && (voltage > thresh[i].voltage))
+		i--;
+
+	return thresh[i].percentage;
+}
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
+		val->intval = liion_voltage()*1000;
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
+		/* 121: battery finished charging in 22C room */
+		/* 141: outside at 6C */
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
+		val->intval = get_percentage();
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		val->intval = liion_internal_voltage(liion_voltage(), battery_current())*1000;
+		return 0;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = battery_current() * 1000;
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
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
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
+
+static DEVICE_ATTR(limit, S_IRUGO | S_IWUSR, spitz_bat_limit_show, spitz_bat_limit_store);
+#if 0
+static struct device_attribute dev_attr_limit = {
+        .attr = { .name = "limit", .mode = 0644 },
+        .show = spitz_bat_limit_show,
+        .store = spitz_bat_limit_store,
+};
+#endif
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
+	device_create_file(&dev->dev, &dev_attr_limit);
+
+	return 0;
+}
+
+static int __devexit spitz_bat_remove(struct platform_device *dev)
+{
+	int i;
+
+	device_remove_file(&dev->dev, &dev_attr_limit);
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
diff -ur ./drivers/video/backlight.ofic/corgi_lcd.c ./drivers/video/backlight/corgi_lcd.c
--- ./drivers/video/backlight.ofic/corgi_lcd.c	2009-10-18 18:11:36.000000000 +0200
+++ ./drivers/video/backlight/corgi_lcd.c	2009-10-18 18:37:09.000000000 +0200
@@ -388,17 +388,33 @@
 	.set_mode	= corgi_lcd_set_mode,
 };
 
-static int corgi_bl_get_intensity(struct backlight_device *bd)
+int corgi_bl_get_intensity(struct backlight_device *bd)
 {
 	struct corgi_lcd *lcd = dev_get_drvdata(&bd->dev);
 
 	return lcd->intensity;
 }
+EXPORT_SYMBOL(corgi_bl_get_intensity);
+
+int backlight_current;
+EXPORT_SYMBOL(backlight_current);
 
 static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
 {
 	int cont;
 
+	backlight_current = 0;
+	if (intensity > 0)
+		backlight_current = 55;
+	if (intensity > 10)
+		backlight_current = 115;
+	if (intensity > 20)
+		backlight_current = 140;
+	if (intensity > 30)
+		backlight_current = 180;
+	if (intensity > 45)
+		backlight_current = 245;
+
 	if (intensity > 0x10)
 		intensity += 0x10;
 
@@ -433,8 +449,9 @@
 
 	if (corgibl_flags & CORGIBL_SUSPENDED)
 		intensity = 0;
-	if (corgibl_flags & CORGIBL_BATTLOW)
-		intensity &= lcd->limit_mask;
+
+	if ((corgibl_flags & CORGIBL_BATTLOW) && intensity > lcd->limit_mask)
+		intensity = lcd->limit_mask;
 
 	return corgi_bl_set_intensity(lcd, intensity);
 }
diff -ur ./arch/arm.ofic/mach-pxa/corgi_pm.c ./arch/arm/mach-pxa/corgi_pm.c
--- ./arch/arm.ofic/mach-pxa/corgi_pm.c	2009-09-10 00:13:59.000000000 +0200
+++ ./arch/arm/mach-pxa/corgi_pm.c	2009-10-22 19:19:02.000000000 +0200
@@ -35,6 +35,92 @@
 #define SHARPSL_FATAL_ACIN_VOLT        182   /* 3.45V */
 #define SHARPSL_FATAL_NOACIN_VOLT      170   /* 3.40V */
 
+static const struct battery_thresh corgi_battery_levels_acin[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 192,  45},
+	{ 191,  43},
+	{ 191,  40},
+	{ 190,  38},
+	{ 190,  35},
+	{ 189,  33},
+	{ 188,  30},
+	{ 187,  28},
+	{ 186,  25},
+	{ 185,  23},
+	{ 184,  20},
+	{ 183,  18},
+	{ 182,  15},
+	{ 181,  13},
+	{ 180,  10},
+	{ 179,   8},
+	{ 178,   5},
+	{   0,   0},
+};
+
+static const struct battery_thresh  corgi_battery_levels_noac[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 191,  45},
+	{ 190,  43},
+	{ 189,  40},
+	{ 188,  38},
+	{ 187,  35},
+	{ 186,  33},
+	{ 185,  30},
+	{ 184,  28},
+	{ 183,  25},
+	{ 182,  23},
+	{ 181,  20},
+	{ 180,  18},
+	{ 179,  15},
+	{ 178,  13},
+	{ 177,  10},
+	{ 176,   8},
+	{ 175,   5},
+	{   0,   0},
+};
+
 static void corgi_charger_init(void)
 {
 	pxa_gpio_mode(CORGI_GPIO_ADC_TEMP_ON | GPIO_OUT);
@@ -214,8 +300,8 @@
 	.fatal_acin_volt  = SHARPSL_FATAL_ACIN_VOLT,
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
-	.bat_levels_noac  = spitz_battery_levels_noac,
-	.bat_levels_acin  = spitz_battery_levels_acin,
+	.bat_levels_noac  = corgi_battery_levels_noac,
+	.bat_levels_acin  = corgi_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,
diff -ur ./arch/arm.ofic/mach-pxa/sharpsl.h ./arch/arm/mach-pxa/sharpsl.h
--- ./arch/arm.ofic/mach-pxa/sharpsl.h	2009-09-10 00:13:59.000000000 +0200
+++ ./arch/arm/mach-pxa/sharpsl.h	2009-10-14 12:12:13.000000000 +0200
@@ -42,8 +42,23 @@
 #define MAX1111_BATT_TEMP   2u
 #define MAX1111_ACIN_VOLT   6u
 
-extern struct battery_thresh spitz_battery_levels_acin[];
-extern struct battery_thresh spitz_battery_levels_noac[];
 int sharpsl_pm_pxa_read_max1111(int channel);
 
 
+/*
+ * Constants
+ */
+#define SHARPSL_CHARGE_ON_TIME_INTERVAL        (msecs_to_jiffies(1*60*1000))  /* 1 min */
+#define SHARPSL_CHARGE_FINISH_TIME             (msecs_to_jiffies(10*60*1000)) /* 10 min */
+#define SHARPSL_BATCHK_TIME                    (msecs_to_jiffies(15*1000))    /* 15 sec */
+#define SHARPSL_BATCHK_TIME_SUSPEND            (60*10)                        /* 10 min */
+
+#define SHARPSL_WAIT_CO_TIME                   15  /* 15 sec */
+#define SHARPSL_WAIT_DISCHARGE_ON              100 /* 100 msec */
+#define SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP   10  /* 10 msec */
+#define SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT   10  /* 10 msec */
+#define SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN   10  /* 10 msec */
+#define SHARPSL_CHARGE_WAIT_TIME               15  /* 15 msec */
+#define SHARPSL_CHARGE_CO_CHECK_TIME           5   /* 5 msec */
+#define SHARPSL_CHARGE_RETRY_CNT               1   /* eqv. 10 min */
+
Only in ./arch/arm/mach-pxa: sharpsl.h~
diff -ur ./arch/arm.ofic/mach-pxa/sharpsl_pm.c ./arch/arm/mach-pxa/sharpsl_pm.c
--- ./arch/arm.ofic/mach-pxa/sharpsl_pm.c	2009-10-06 13:48:07.000000000 +0200
+++ ./arch/arm/mach-pxa/sharpsl_pm.c	2009-10-14 12:12:05.000000000 +0200
@@ -32,25 +32,10 @@
 #include <mach/regs-rtc.h>
 #include <mach/sharpsl.h>
 #include <mach/sharpsl_pm.h>
+#include <mach/spitz.h>
 
 #include "sharpsl.h"
 
-/*
- * Constants
- */
-#define SHARPSL_CHARGE_ON_TIME_INTERVAL        (msecs_to_jiffies(1*60*1000))  /* 1 min */
-#define SHARPSL_CHARGE_FINISH_TIME             (msecs_to_jiffies(10*60*1000)) /* 10 min */
-#define SHARPSL_BATCHK_TIME                    (msecs_to_jiffies(15*1000))    /* 15 sec */
-#define SHARPSL_BATCHK_TIME_SUSPEND            (60*10)                        /* 10 min */
-
-#define SHARPSL_WAIT_CO_TIME                   15  /* 15 sec */
-#define SHARPSL_WAIT_DISCHARGE_ON              100 /* 100 msec */
-#define SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP   10  /* 10 msec */
-#define SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT   10  /* 10 msec */
-#define SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN   10  /* 10 msec */
-#define SHARPSL_CHARGE_WAIT_TIME               15  /* 15 msec */
-#define SHARPSL_CHARGE_CO_CHECK_TIME           5   /* 5 msec */
-#define SHARPSL_CHARGE_RETRY_CNT               1   /* eqv. 10 min */
 
 /*
  * Prototypes
@@ -72,112 +57,28 @@
  * Variables
  */
 struct sharpsl_pm_status sharpsl_pm;
+EXPORT_SYMBOL(sharpsl_pm);
 static DECLARE_DELAYED_WORK(toggle_charger, sharpsl_charge_toggle);
 static DECLARE_DELAYED_WORK(sharpsl_bat, sharpsl_battery_thread);
 DEFINE_LED_TRIGGER(sharpsl_charge_led_trigger);
 
 
 
-struct battery_thresh spitz_battery_levels_acin[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 192,  45},
-	{ 191,  43},
-	{ 191,  40},
-	{ 190,  38},
-	{ 190,  35},
-	{ 189,  33},
-	{ 188,  30},
-	{ 187,  28},
-	{ 186,  25},
-	{ 185,  23},
-	{ 184,  20},
-	{ 183,  18},
-	{ 182,  15},
-	{ 181,  13},
-	{ 180,  10},
-	{ 179,   8},
-	{ 178,   5},
-	{   0,   0},
-};
-
-struct battery_thresh  spitz_battery_levels_noac[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 191,  45},
-	{ 190,  43},
-	{ 189,  40},
-	{ 188,  38},
-	{ 187,  35},
-	{ 186,  33},
-	{ 185,  30},
-	{ 184,  28},
-	{ 183,  25},
-	{ 182,  23},
-	{ 181,  20},
-	{ 180,  18},
-	{ 179,  15},
-	{ 178,  13},
-	{ 177,  10},
-	{ 176,   8},
-	{ 175,   5},
-	{   0,   0},
-};
-
 /* MAX1111 Commands */
-#define MAXCTRL_PD0      1u << 0
-#define MAXCTRL_PD1      1u << 1
-#define MAXCTRL_SGL      1u << 2
-#define MAXCTRL_UNI      1u << 3
+#define MAXCTRL_PD0      (1u << 0)
+#define MAXCTRL_PD1      (1u << 1)
+#define MAXCTRL_SGL      (1u << 2)
+#define MAXCTRL_UNI      (1u << 3)
 #define MAXCTRL_SEL_SH   4
-#define MAXCTRL_STR      1u << 7
+#define MAXCTRL_STR      (1u << 7)
 
 /*
  * Read MAX1111 ADC
  */
 int sharpsl_pm_pxa_read_max1111(int channel)
 {
-	if (machine_is_tosa()) // Ugly, better move this function into another module
+	/* Ugly, better move this function into another module */
+	if (machine_is_tosa())
 	    return 0;
 
 #ifdef CONFIG_CORGI_SSP_DEPRECATED
@@ -193,7 +94,7 @@
 #endif
 }
 
-static int get_percentage(int voltage)
+int get_percentage(int voltage)
 {
 	int i = sharpsl_pm.machinfo->bat_levels - 1;
 	int bl_status = sharpsl_pm.machinfo->backlight_get_status ? sharpsl_pm.machinfo->backlight_get_status() : 0;
@@ -209,6 +110,7 @@
 
 	return thresh[i].percentage;
 }
+EXPORT_SYMBOL(get_percentage);
 
 static int get_apm_status(int voltage)
 {
@@ -238,7 +140,7 @@
 
 static void sharpsl_battery_thread(struct work_struct *private_)
 {
-	int voltage, percent, apm_status, i = 0;
+	int voltage, percent, apm_status, i;
 
 	if (!sharpsl_pm.machinfo)
 		return;
@@ -250,15 +152,14 @@
 			&& time_after(jiffies, sharpsl_pm.charge_start_time +  SHARPSL_CHARGE_ON_TIME_INTERVAL))
 		schedule_delayed_work(&toggle_charger, 0);
 
-	while(1) {
+	for (i = 0; i < 5; i++) {
 		voltage = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
-
-		if (voltage > 0) break;
-		if (i++ > 5) {
-			voltage = sharpsl_pm.machinfo->bat_levels_noac[0].voltage;
-			dev_warn(sharpsl_pm.dev, "Warning: Cannot read main battery!\n");
+		if (voltage > 0)
 			break;
-		}
+	}
+	if (voltage <= 0) {
+		voltage = sharpsl_pm.machinfo->bat_levels_noac[0].voltage;
+		dev_warn(sharpsl_pm.dev, "Warning: Cannot read main battery!\n");
 	}
 
 	voltage = sharpsl_average_value(voltage);
@@ -266,8 +167,10 @@
 	percent = get_percentage(voltage);
 
 	/* At low battery voltages, the voltage has a tendency to start
-           creeping back up so we try to avoid this here */
-	if ((sharpsl_pm.battstat.ac_status == APM_AC_ONLINE) || (apm_status == APM_BATTERY_STATUS_HIGH) ||  percent <= sharpsl_pm.battstat.mainbat_percent) {
+	   creeping back up so we try to avoid this here */
+	if ((sharpsl_pm.battstat.ac_status == APM_AC_ONLINE)
+	    || (apm_status == APM_BATTERY_STATUS_HIGH)
+	    || percent <= sharpsl_pm.battstat.mainbat_percent) {
 		sharpsl_pm.battstat.mainbat_voltage = voltage;
 		sharpsl_pm.battstat.mainbat_status = apm_status;
 		sharpsl_pm.battstat.mainbat_percent = percent;
@@ -279,8 +182,8 @@
 #ifdef CONFIG_BACKLIGHT_CORGI
 	/* If battery is low. limit backlight intensity to save power. */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
-			&& ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW) ||
-			(sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL))) {
+	    && ((sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_LOW)
+	    || (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL))) {
 		if (!(sharpsl_pm.flags & SHARPSL_BL_LIMIT)) {
 			sharpsl_pm.machinfo->backlight_limit(1);
 			sharpsl_pm.flags |= SHARPSL_BL_LIMIT;
@@ -293,8 +196,8 @@
 
 	/* Suspend if critical battery level */
 	if ((sharpsl_pm.battstat.ac_status != APM_AC_ONLINE)
-			&& (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL)
-			&& !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
+	     && (sharpsl_pm.battstat.mainbat_status == APM_BATTERY_STATUS_CRITICAL)
+	     && !(sharpsl_pm.flags & SHARPSL_APM_QUEUED)) {
 		sharpsl_pm.flags |= SHARPSL_APM_QUEUED;
 		dev_err(sharpsl_pm.dev, "Fatal Off\n");
 		apm_queue_event(APM_CRITICAL_SUSPEND);
@@ -339,6 +242,8 @@
 
 static void sharpsl_charge_error(void)
 {
+	dev_warn(sharpsl_pm.dev, "Charger Error\n");
+
 	sharpsl_pm_led(SHARPSL_LED_ERROR);
 	sharpsl_pm.machinfo->charge(0);
 	sharpsl_pm.charge_mode = CHRG_ERROR;
@@ -346,7 +251,7 @@
 
 static void sharpsl_charge_toggle(struct work_struct *private_)
 {
-	dev_dbg(sharpsl_pm.dev, "Toogling Charger at time: %lx\n", jiffies);
+	dev_dbg(sharpsl_pm.dev, "Toggling Charger at time: %lx\n", jiffies);
 
 	if (!sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN)) {
 		sharpsl_charge_off();
@@ -368,7 +273,7 @@
 {
 	int acin = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
 
-	dev_dbg(sharpsl_pm.dev, "AC Status: %d\n",acin);
+	dev_dbg(sharpsl_pm.dev, "AC Status: %d\n", acin);
 
 	sharpsl_average_clear();
 	if (acin && (sharpsl_pm.charge_mode != CHRG_ON))
@@ -472,14 +377,14 @@
 	sharpsl_ad[sharpsl_ad_index] = ad;
 	sharpsl_ad_index++;
 	if (sharpsl_ad_index >= SHARPSL_CNV_VALUE_NUM) {
-		for (i=0; i < (SHARPSL_CNV_VALUE_NUM-1); i++)
+		for (i = 0; i < (SHARPSL_CNV_VALUE_NUM-1); i++)
 			sharpsl_ad[i] = sharpsl_ad[i+1];
 		sharpsl_ad_index = SHARPSL_CNV_VALUE_NUM - 1;
 	}
-	for (i=0; i < sharpsl_ad_index; i++)
+	for (i = 0; i < sharpsl_ad_index; i++)
 		ad_val += sharpsl_ad[i];
 
-	return (ad_val / sharpsl_ad_index);
+	return ad_val / sharpsl_ad_index;
 }
 
 /*
@@ -492,8 +397,8 @@
 
 	/* Find MAX val */
 	temp = val[0];
-	j=0;
-	for (i=1; i<5; i++) {
+	j = 0;
+	for (i = 1; i < 5; i++) {
 		if (temp < val[i]) {
 			temp = val[i];
 			j = i;
@@ -502,21 +407,21 @@
 
 	/* Find MIN val */
 	temp = val[4];
-	k=4;
-	for (i=3; i>=0; i--) {
+	k = 4;
+	for (i = 3; i >= 0; i--) {
 		if (temp > val[i]) {
 			temp = val[i];
 			k = i;
 		}
 	}
 
-	for (i=0; i<5; i++)
-		if (i != j && i != k )
+	for (i = 0; i < 5; i++)
+		if (i != j && i != k)
 			sum += val[i];
 
 	dev_dbg(sharpsl_pm.dev, "Average: %d from values: %d, %d, %d, %d, %d\n", sum/3, val[0], val[1], val[2], val[3], val[4]);
 
-	return (sum/3);
+	return sum/3;
 }
 
 static int sharpsl_check_battery_temp(void)
@@ -524,7 +429,7 @@
 	int val, i, buff[5];
 
 	/* Check battery temperature */
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
 		sharpsl_pm.machinfo->measure_temp(1);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
@@ -535,8 +440,10 @@
 	val = get_select_val(buff);
 
 	dev_dbg(sharpsl_pm.dev, "Temperature: %d\n", val);
-	if (val > sharpsl_pm.machinfo->charge_on_temp) {
-		printk(KERN_WARNING "Not charging: temperature out of limits.\n");
+	/* FIXME: this should catch battery read errors, but we should
+	   probably avoid charging in <0C temperatures, too. */
+	if ((val < 0) || (val > sharpsl_pm.machinfo->charge_on_temp)) {
+		dev_warn(sharpsl_pm.dev, "Not charging: temperature %d out of limits.\n", val);
 		return -1;
 	}
 
@@ -557,7 +464,7 @@
 		sharpsl_pm.machinfo->discharge1(1);
 
 	/* Check battery voltage */
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
 	}
@@ -581,16 +488,16 @@
 {
 	int temp, i, buff[5];
 
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_ACIN_VOLT);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN);
 	}
 
 	temp = get_select_val(buff);
-	dev_dbg(sharpsl_pm.dev, "AC Voltage: %d\n",temp);
+	dev_dbg(sharpsl_pm.dev, "AC Voltage: %d\n", temp);
 
 	if ((temp > sharpsl_pm.machinfo->charge_acin_high) || (temp < sharpsl_pm.machinfo->charge_acin_low)) {
-		dev_err(sharpsl_pm.dev, "Error: AC check failed.\n");
+		dev_err(sharpsl_pm.dev, "Error: AC check failed: voltage %d.\n", temp);
 		return -1;
 	}
 
@@ -624,9 +531,9 @@
 
 static void corgi_goto_sleep(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
-	dev_dbg(sharpsl_pm.dev, "Time is: %08x\n",RCNR);
+	dev_dbg(sharpsl_pm.dev, "Time is: %08x\n", RCNR);
 
-	dev_dbg(sharpsl_pm.dev, "Offline Charge Activate = %d\n",sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG);
+	dev_dbg(sharpsl_pm.dev, "Offline Charge Activate = %d\n", sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG);
 	/* not charging and AC-IN! */
 
 	if ((sharpsl_pm.flags & SHARPSL_DO_OFFLINE_CHRG) && (sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN))) {
@@ -644,12 +551,12 @@
 	if ((sharpsl_pm.charge_mode == CHRG_ON) && ((alarm_enable && ((alarm_time - RCNR) > (SHARPSL_BATCHK_TIME_SUSPEND + 30))) || !alarm_enable)) {
 		RTSR &= RTSR_ALE;
 		RTAR = RCNR + SHARPSL_BATCHK_TIME_SUSPEND;
-		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n",RTAR);
+		dev_dbg(sharpsl_pm.dev, "Charging alarm at: %08x\n", RTAR);
 		sharpsl_pm.flags |= SHARPSL_ALARM_ACTIVE;
 	} else if (alarm_enable) {
 		RTSR &= RTSR_ALE;
 		RTAR = alarm_time;
-		dev_dbg(sharpsl_pm.dev, "User alarm at: %08x\n",RTAR);
+		dev_dbg(sharpsl_pm.dev, "User alarm at: %08x\n", RTAR);
 	} else {
 		dev_dbg(sharpsl_pm.dev, "No alarms set.\n");
 	}
@@ -658,19 +565,20 @@
 
 	sharpsl_pm.machinfo->postsuspend();
 
-	dev_dbg(sharpsl_pm.dev, "Corgi woken up from suspend: %08x\n",PEDR);
+
+	dev_dbg(sharpsl_pm.dev, "Corgi woken up from suspend: %08x\n", PEDR);
 }
 
 static int corgi_enter_suspend(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
-	if (!sharpsl_pm.machinfo->should_wakeup(!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE) && alarm_enable) )
-	{
+  return 0;
+	if (!sharpsl_pm.machinfo->should_wakeup(!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE) && alarm_enable)) {
 		if (!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE)) {
 			dev_dbg(sharpsl_pm.dev, "No user triggered wakeup events and not charging. Strange. Suspend.\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
 		}
-		if(sharpsl_off_charge_battery()) {
+		if (sharpsl_off_charge_battery()) {
 			dev_dbg(sharpsl_pm.dev, "Charging. Suspend...\n");
 			corgi_goto_sleep(alarm_time, alarm_enable, state);
 			return 1;
@@ -697,7 +605,7 @@
 
 	corgi_goto_sleep(alarm_time, alarm_status, state);
 
-	while (corgi_enter_suspend(alarm_time,alarm_status,state))
+	while (corgi_enter_suspend(alarm_time, alarm_status, state))
 		{}
 
 	if (sharpsl_pm.machinfo->earlyresume)
@@ -732,7 +640,7 @@
 		sharpsl_pm.machinfo->discharge1(1);
 
 	/* Check battery : check inserting battery ? */
-	for (i=0; i<5; i++) {
+	for (i = 0; i < 5; i++) {
 		buff[i] = sharpsl_pm.machinfo->read_devdata(SHARPSL_BATT_VOLT);
 		mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
 	}
@@ -812,7 +720,7 @@
 		mdelay(SHARPSL_CHARGE_CO_CHECK_TIME);
 
 		time = RCNR;
-		while(1) {
+		while (1) {
 			/* Check if any wakeup event had occurred */
 			if (sharpsl_pm.machinfo->charger_wakeup() != 0)
 				return 0;
@@ -835,9 +743,9 @@
 	mdelay(SHARPSL_CHARGE_CO_CHECK_TIME);
 
 	time = RCNR;
-	while(1) {
+	while (1) {
 		/* Check if any wakeup event had occurred */
-		if (sharpsl_pm.machinfo->charger_wakeup() != 0)
+		if (sharpsl_pm.machinfo->charger_wakeup())
 			return 0;
 		/* Check for timeout */
 		if ((RCNR-time) > SHARPSL_WAIT_CO_TIME) {
@@ -864,12 +772,12 @@
 
 static ssize_t battery_percentage_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",sharpsl_pm.battstat.mainbat_percent);
+	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_percent);
 }
 
 static ssize_t battery_voltage_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n",sharpsl_pm.battstat.mainbat_voltage);
+	return sprintf(buf, "%d\n", sharpsl_pm.battstat.mainbat_voltage);
 }
 
 static DEVICE_ATTR(battery_percentage, 0444, battery_percentage_show, NULL);
@@ -943,7 +851,6 @@
 		}
 	}
 
-	if (sharpsl_pm.machinfo->batfull_irq)
-	{
+	if (sharpsl_pm.machinfo->batfull_irq) {
 		/* Register interrupt handler. */
 		if (request_irq(IRQ_GPIO(sharpsl_pm.machinfo->gpio_batfull), sharpsl_chrg_full_isr, IRQF_DISABLED | IRQF_TRIGGER_RISING, "CO", sharpsl_chrg_full_isr)) {
diff -ur ./arch/arm.ofic/mach-pxa/spitz.c ./arch/arm/mach-pxa/spitz.c
--- ./arch/arm.ofic/mach-pxa/spitz.c	2009-10-06 13:48:07.000000000 +0200
+++ ./arch/arm/mach-pxa/spitz.c	2009-10-14 11:01:36.000000000 +0200
@@ -686,12 +733,19 @@
 	.dev.platform_data = &sharpsl_rom_data,
 };
 
+static struct platform_device spitz_battery_device = {
+	.name	= "spitz-battery",
+	.id	= -1,
+};
+
+
 static struct platform_device *devices[] __initdata = {
 	&spitzscoop_device,
 	&spitzkbd_device,
 	&spitzled_device,
 	&sharpsl_nand_device,
 	&sharpsl_rom_device,
+	&spitz_battery_device,
 };
 
 static void spitz_poweroff(void)
--- ./arch/arm.ofic/mach-pxa/spitz_pm.c	2009-09-10 00:13:59.000000000 +0200
+++ ./arch/arm/mach-pxa/spitz_pm.c	2009-10-19 07:28:42.000000000 +0200
@@ -37,6 +37,93 @@
 
 static int spitz_last_ac_status;
 
+static const struct battery_thresh spitz_battery_levels_acin[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 192,  45},
+	{ 191,  43},
+	{ 191,  40},
+	{ 190,  38},
+	{ 190,  35},
+	{ 189,  33},
+	{ 188,  30},
+	{ 187,  28},
+	{ 186,  25},
+	{ 185,  23},
+	{ 184,  20},
+	{ 183,  18},
+	{ 182,  15},
+	{ 181,  13},
+	{ 180,  10},
+	{ 179,   8},
+	{ 178,   5},
+	{   0,   0},
+};
+
+static const struct battery_thresh  spitz_battery_levels_noac[] = {
+	{ 213, 100},
+	{ 212,  98},
+	{ 211,  95},
+	{ 210,  93},
+	{ 209,  90},
+	{ 208,  88},
+	{ 207,  85},
+	{ 206,  83},
+	{ 205,  80},
+	{ 204,  78},
+	{ 203,  75},
+	{ 202,  73},
+	{ 201,  70},
+	{ 200,  68},
+	{ 199,  65},
+	{ 198,  63},
+	{ 197,  60},
+	{ 196,  58},
+	{ 195,  55},
+	{ 194,  53},
+	{ 193,  50},
+	{ 192,  48},
+	{ 191,  45},
+	{ 190,  43},
+	{ 189,  40},
+	{ 188,  38},
+	{ 187,  35},
+	{ 186,  33},
+	{ 185,  30},
+	{ 184,  28},
+	{ 183,  25},
+	{ 182,  23},
+	{ 181,  20},
+	{ 180,  18},
+	{ 179,  15},
+	{ 178,  13},
+	{ 177,  10},
+	{ 176,   8},
+	{ 175,   5},
+	{   0,   0},
+};
+
+
 static void spitz_charger_init(void)
 {
 	pxa_gpio_mode(SPITZ_GPIO_KEY_INT | GPIO_IN);
@@ -103,7 +190,7 @@
 	PFER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET);
 	PWER = GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET) | PWER_RTC;
 	PKWR = GPIO_bit(SPITZ_GPIO_SYNC) | GPIO_bit(SPITZ_GPIO_KEY_INT) | GPIO_bit(SPITZ_GPIO_RESET);
-	PKSR = 0xffffffff; // clear
+	PKSR = 0xffffffff; /* clear */
 
 	/* nRESET_OUT Disable */
 	PSLR |= PSLR_SL_ROD;
@@ -149,7 +236,7 @@
 	if (resume_on_alarm && (PEDR & PWER_RTC))
 		is_resume |= PWER_RTC;
 
-	dev_dbg(sharpsl_pm.dev, "is_resume: %x\n",is_resume);
+	dev_dbg(sharpsl_pm.dev, "is_resume: %x\n", is_resume);
 	return is_resume;
 }
 
@@ -160,15 +247,15 @@
 
 unsigned long spitzpm_read_devdata(int type)
 {
-	switch(type) {
+	switch (type) {
 	case SHARPSL_STATUS_ACIN:
 		return (((~GPLR(SPITZ_GPIO_AC_IN)) & GPIO_bit(SPITZ_GPIO_AC_IN)) != 0);
 	case SHARPSL_STATUS_LOCK:
-		return READ_GPIO_BIT(sharpsl_pm.machinfo->gpio_batlock);
+		return !!READ_GPIO_BIT(sharpsl_pm.machinfo->gpio_batlock);
 	case SHARPSL_STATUS_CHRGFULL:
-		return READ_GPIO_BIT(sharpsl_pm.machinfo->gpio_batfull);
+		return !!READ_GPIO_BIT(sharpsl_pm.machinfo->gpio_batfull);
 	case SHARPSL_STATUS_FATAL:
-		return READ_GPIO_BIT(sharpsl_pm.machinfo->gpio_fatal);
+		return !!READ_GPIO_BIT(sharpsl_pm.machinfo->gpio_fatal);
 	case SHARPSL_ACIN_VOLT:
 		return sharpsl_pm_pxa_read_max1111(MAX1111_ACIN_VOLT);
 	case SHARPSL_BATT_TEMP:
@@ -179,6 +266,11 @@
 	}
 }
 
+int backlight_get_status(void)
+{
+	return 0;
+}
+
 struct sharpsl_charger_machinfo spitz_pm_machinfo = {
 	.init             = spitz_charger_init,
 	.exit             = NULL,
@@ -199,8 +291,9 @@
 #if defined(CONFIG_LCD_CORGI)
 	.backlight_limit = corgi_lcd_limit_intensity,
 #elif defined(CONFIG_BACKLIGHT_CORGI)
-        .backlight_limit  = corgibl_limit_intensity,
+	.backlight_limit  = corgibl_limit_intensity,
 #endif
+//	.backlight_get_status = backlight_get_status,
 	.charge_on_volt	  = SHARPSL_CHARGE_ON_VOLT,
 	.charge_on_temp	  = SHARPSL_CHARGE_ON_TEMP,
 	.charge_acin_high = SHARPSL_CHARGE_ON_ACIN_HIGH,
@@ -241,7 +334,7 @@
 
 static void spitzpm_exit(void)
 {
- 	platform_device_unregister(spitzpm_device);
+	platform_device_unregister(spitzpm_device);
 }
 
 module_init(spitzpm_init);

--IJpNTDwzlM2Ie8A6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="zbattery.7.diff"

diff -ur ./arch/arm.ofic/mach-pxa/corgi_pm.c ./arch/arm/mach-pxa/corgi_pm.c
--- ./arch/arm.ofic/mach-pxa/corgi_pm.c	2009-11-23 20:48:26.000000000 +0100
+++ ./arch/arm/mach-pxa/corgi_pm.c	2009-11-23 06:45:45.000000000 +0100
@@ -215,7 +215,6 @@
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
 	.bat_levels_noac  = sharpsl_battery_levels_noac,
-	.bat_levels_acin  = sharpsl_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,
diff -ur ./arch/arm.ofic/mach-pxa/sharpsl_pm.c ./arch/arm/mach-pxa/sharpsl_pm.c
--- ./arch/arm.ofic/mach-pxa/sharpsl_pm.c	2009-11-23 20:48:26.000000000 +0100
+++ ./arch/arm/mach-pxa/sharpsl_pm.c	2009-11-29 09:56:57.000000000 +0100
@@ -78,90 +78,25 @@
 
 
 
-struct battery_thresh sharpsl_battery_levels_acin[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 192,  45},
-	{ 191,  43},
-	{ 191,  40},
-	{ 190,  38},
-	{ 190,  35},
-	{ 189,  33},
-	{ 188,  30},
-	{ 187,  28},
-	{ 186,  25},
-	{ 185,  23},
-	{ 184,  20},
-	{ 183,  18},
-	{ 182,  15},
-	{ 181,  13},
-	{ 180,  10},
-	{ 179,   8},
-	{ 178,   5},
-	{   0,   0},
-};
-
 struct battery_thresh sharpsl_battery_levels_noac[] = {
-	{ 213, 100},
-	{ 212,  98},
-	{ 211,  95},
-	{ 210,  93},
-	{ 209,  90},
-	{ 208,  88},
-	{ 207,  85},
-	{ 206,  83},
-	{ 205,  80},
-	{ 204,  78},
-	{ 203,  75},
-	{ 202,  73},
-	{ 201,  70},
-	{ 200,  68},
-	{ 199,  65},
-	{ 198,  63},
-	{ 197,  60},
-	{ 196,  58},
-	{ 195,  55},
-	{ 194,  53},
-	{ 193,  50},
-	{ 192,  48},
-	{ 191,  45},
-	{ 190,  43},
-	{ 189,  40},
-	{ 188,  38},
-	{ 187,  35},
-	{ 186,  33},
-	{ 185,  30},
-	{ 184,  28},
-	{ 183,  25},
-	{ 182,  23},
-	{ 181,  20},
-	{ 180,  18},
-	{ 179,  15},
-	{ 178,  13},
-	{ 177,  10},
-	{ 176,   8},
-	{ 175,   5},
-	{   0,   0},
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
 };
 
 /* MAX1111 Commands */
@@ -194,16 +129,64 @@
 #endif
 }
 
-static int get_percentage(int voltage)
+
+typedef int milliamp_t;
+typedef int milliohm_t;
+typedef int millivolt_t;
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
+	if (sharpsl_pm.charge_mode == CHRG_ON)
+		return 0;
+
+	return basic_current;
+}
+
+millivolt_t liion_internal_voltage(millivolt_t voltage, milliamp_t current_ma)
+{
+	return voltage + (battery_resistance * current_ma / 1000);
+}
+
+/* returns mV */
+millivolt_t liion_voltage(int adc)
+{
+	/* Thanks to Stanislav B. ADC has 3.3V as reference,
+	   is connected to battery over 47kOhm,
+	   and to ground over 100kOhm. */
+	return (adc * 147 * 33)/256;
+}
+
+static int get_percentage(int voltage_adc)
 {
 	int i = sharpsl_pm.machinfo->bat_levels - 1;
 	int bl_status = sharpsl_pm.machinfo->backlight_get_status ? sharpsl_pm.machinfo->backlight_get_status() : 0;
 	struct battery_thresh *thresh;
+	millivolt_t voltage = liion_voltage(voltage_adc);
 
-	if (sharpsl_pm.charge_mode == CHRG_ON)
-		thresh = bl_status ? sharpsl_pm.machinfo->bat_levels_acin_bl : sharpsl_pm.machinfo->bat_levels_acin;
-	else
-		thresh = bl_status ? sharpsl_pm.machinfo->bat_levels_noac_bl : sharpsl_pm.machinfo->bat_levels_noac;
+	thresh = sharpsl_pm.machinfo->bat_levels_noac;
 
 	while (i > 0 && (voltage > thresh[i].voltage))
 		i--;
diff -ur ./arch/arm.ofic/mach-pxa/spitz_pm.c ./arch/arm/mach-pxa/spitz_pm.c
--- ./arch/arm.ofic/mach-pxa/spitz_pm.c	2009-11-23 20:48:26.000000000 +0100
+++ ./arch/arm/mach-pxa/spitz_pm.c	2009-11-23 06:45:25.000000000 +0100
@@ -209,7 +209,6 @@
 	.fatal_noacin_volt= SHARPSL_FATAL_NOACIN_VOLT,
 	.bat_levels       = 40,
 	.bat_levels_noac  = sharpsl_battery_levels_noac,
-	.bat_levels_acin  = sharpsl_battery_levels_acin,
 	.status_high_acin = 188,
 	.status_low_acin  = 178,
 	.status_high_noac = 185,

--IJpNTDwzlM2Ie8A6--
