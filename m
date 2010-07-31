Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0GaNsc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 09:48:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59947 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab0GaNsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 09:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:message-id;
        b=L9bWDRbElUSJqWybgR7XiIh/hRGwWM6lJcNq9paENDNQ+1Vf9AvybYpCbiH6DFboL/
         pgtjZzNEwRRCcxGWJXcxu8mHubcp6P2dq+Z5+Wl4aKfMStq0ntNOmeaVfi0OoQIPCrZU
         6F6ZuT9xcUU2SQtBkTXHtOyCq8ifTor1JCoFI=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: zaurus battery patches
Date: Sat, 31 Jul 2010 15:48:09 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org
References: <201007301456.17464.marek.vasut@gmail.com> <20100731061816.GC4945@ucw.cz>
In-Reply-To: <20100731061816.GC4945@ucw.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ZmCVMM/TLc671KC"
Message-Id: <201007311548.09523.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_ZmCVMM/TLc671KC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Dne So 31. =C4=8Dervence 2010 08:18:17 Pavel Machek napsal(a):
> Hi!
>=20
> ...they certainly need more work. .7. version is newer but incomplete.

use at your own risk ... its not too tested and contains lots of debuging g=
oo.

--Boundary-00=_ZmCVMM/TLc671KC
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-PXA-Reworked-spitz-battery.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-PXA-Reworked-spitz-battery.patch"

=46rom 195c27ead448a9a6a5ae3958dc2c2a11450f84c7 Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Sat, 31 Jul 2010 13:15:24 +0200
Subject: [PATCH] PXA: Reworked spitz-battery

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 arch/arm/mach-pxa/Makefile    |    2 +-
 arch/arm/mach-pxa/spitz.c     |   23 ++
 drivers/power/Kconfig         |    7 +
 drivers/power/Makefile        |    1 +
 drivers/power/spitz_battery.c |  680 +++++++++++++++++++++++++++++++++++++=
++++
 5 files changed, 712 insertions(+), 1 deletions(-)
 create mode 100644 drivers/power/spitz_battery.c

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 85c7fb3..704fb31 100644
=2D-- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -82,7 +82,7 @@ obj-$(CONFIG_MACH_PALMZ72)	+=3D palmz72.o
 obj-$(CONFIG_MACH_PALMLD)	+=3D palmld.o
 obj-$(CONFIG_PALM_TREO)		+=3D palmtreo.o
 obj-$(CONFIG_PXA_SHARP_C7xx)	+=3D corgi.o sharpsl_pm.o corgi_pm.o
=2Dobj-$(CONFIG_PXA_SHARP_Cxx00)	+=3D spitz.o sharpsl_pm.o spitz_pm.o
+obj-$(CONFIG_PXA_SHARP_Cxx00)	+=3D spitz.o
 obj-$(CONFIG_MACH_POODLE)	+=3D poodle.o
 obj-$(CONFIG_MACH_TOSA)		+=3D tosa.o
 obj-$(CONFIG_MACH_ICONTROL)     +=3D icontrol.o mxm8x10.o
diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
index a8d4e3a..6cee4aa 100644
=2D-- a/arch/arm/mach-pxa/spitz.c
+++ b/arch/arm/mach-pxa/spitz.c
@@ -683,6 +683,28 @@ static inline void spitz_irda_init(void) {}
 #endif
=20
 /*************************************************************************=
*****
+ * Battery
+ *************************************************************************=
*****/
+//#if defined(CONFIG_PXA_FICP) || defined(CONFIG_PXA_FICP_MODULE)
+static struct platform_device spitz_batt_device =3D {
+	.name	=3D "spitz-battery",
+	.id	=3D -1,
+//	.dev	=3D {
+//		.platform_data	=3D &spitz_gpio_keys_platform_data,
+//	},
+};
+
+static void __init spitz_batt_init(void)
+{
+	printk("%s[%i]\n", __FUNCTION__, __LINE__);
+	platform_device_register(&spitz_batt_device);=09
+	printk("%s[%i]\n", __FUNCTION__, __LINE__);
+}
+//#else
+//static inline void spitz_batt_init(void) {}
+//#endif
+
+/*************************************************************************=
*****
  * Framebuffer
  *************************************************************************=
*****/
 #if defined(CONFIG_FB_PXA) || defined(CONFIG_FB_PXA_MODULE)
@@ -966,6 +988,7 @@ static void __init spitz_init(void)
 	spitz_nor_init();
 	spitz_nand_init();
 	spitz_i2c_init();
+	spitz_batt_init();
 }
=20
 static void __init spitz_fixup(struct machine_desc *desc,
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 8e9ba17..e4c538c 100644
=2D-- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -136,6 +136,13 @@ config BATTERY_Z2
 	help
 	  Say Y to include support for the battery on the Zipit Z2.
=20
+config BATTERY_SPITZ
+	tristate "Sharp Spitz/Akita/Borzoi battery driver"
+	depends on SENSORS_MAX1111 && (MACH_AKITA || MACH_SPITZ || MACH_BORZOI)
+	help
+	  Say Y to include support for the battery in the
+	  Sharp Spitz/Akita/Borzoi.
+
 config CHARGER_PCF50633
 	tristate "NXP PCF50633 MBC"
 	depends on MFD_PCF50633
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 0005080..3d282be 100644
=2D-- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -33,4 +33,5 @@ obj-$(CONFIG_BATTERY_BQ27x00)	+=3D bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+=3D da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+=3D max17040_battery.o
 obj-$(CONFIG_BATTERY_Z2)	+=3D z2_battery.o
+obj-$(CONFIG_BATTERY_SPITZ)	+=3D spitz_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+=3D pcf50633-charger.o
diff --git a/drivers/power/spitz_battery.c b/drivers/power/spitz_battery.c
new file mode 100644
index 0000000..46b07f1
=2D-- /dev/null
+++ b/drivers/power/spitz_battery.c
@@ -0,0 +1,680 @@
+/*
+ * Battery and Power Management code for the Sharp SL-Cxxxx
+ *
+ * Copyright (c) 2009 Pavel Machek <pavel@ucw.cz>
+ * Copyright (c) 2010 Marek Vasut <marek.vasut@gmail.com>
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
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
+#include <asm/mach-types.h>
+#include <mach/spitz.h>
+//#include <mach/sharpsl.h>
+//#include <mach/sharpsl_pm.h>
+
+//#include "../../arch/arm/mach-pxa/sharpsl.h"
+#define	SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP	10	/* 10 msec */
+#define	SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT	10	/* 10 msec */
+#define	SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN	10	/* 10 msec */
+
+#define	SHARPSL_WAIT_DISCHARGE_ON		100	/* 100 msec */
+
+#define	SHARPSL_BATT_VOLT	1
+#define	SHARPSL_BATT_TEMP	2
+#define	SHARPSL_ACIN_VOLT	3
+#define	SHARPSL_STATUS_ACIN	4
+#define	SHARPSL_STATUS_LOCK	5
+#define	SHARPSL_STATUS_CHRGFULL	6
+#define	SHARPSL_STATUS_FATAL	7
+
+static int spitz_bat_status =3D POWER_SUPPLY_STATUS_UNKNOWN;
+static int spitz_bat_charge =3D POWER_SUPPLY_CHARGE_TYPE_UNKNOWN;
+static int spitz_bat_temp =3D -1;
+static int spitz_bat_volt =3D -1;
+static int spitz_ac_volt =3D -1;
+
+static DEFINE_MUTEX(bat_lock);
+static DECLARE_WAIT_QUEUE_HEAD(bat_wait);
+static struct task_struct *bat_thread;
+static int bat_restart;
+
+extern int max1111_read_channel(int);
+
+int basic_current =3D 125; /* miliAmp */
+int battery_resistance =3D 422; /* miliOhm */
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
+/*
+extern int backlight_current;
+
+int battery_current(void)
+{
+	int intensity =3D sharpsl_pm.machinfo->backlight_get_status ? sharpsl_pm.=
machinfo->backlight_get_status() : 0;
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
+{      =20
+	return internal_voltage - (battery_resistance * current_ma / 1000);
+}
+*/
+=09
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
+/*
+struct battery_thresh battery_levels[] =3D {
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
+	int i =3D ARRAY_SIZE(battery_levels);
+	struct battery_thresh *thresh;
+	int voltage =3D liion_internal_voltage(spitz_bat_volt, battery_current());
+
+	thresh =3D battery_levels;
+
+	while (i > 0 && (voltage > thresh[i].voltage))
+		i--;
+
+	return thresh[i].percentage;
+}
+*/
+static int spitz_bat_get_property(struct power_supply *psy,
+			    enum power_supply_property psp,
+			    union power_supply_propval *val)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		mutex_lock(&bat_lock);
+		val->intval =3D spitz_bat_charge;
+		mutex_unlock(&bat_lock);
+		return 0;
+	case POWER_SUPPLY_PROP_STATUS:
+		mutex_lock(&bat_lock);
+		val->intval =3D spitz_bat_status;
+		mutex_unlock(&bat_lock);
+		return 0;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval =3D POWER_SUPPLY_TECHNOLOGY_LION;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		if (spitz_bat_volt >=3D 0) {
+			mutex_lock(&bat_lock);
+			val->intval =3D spitz_bat_volt;
+			mutex_unlock(&bat_lock);
+			return 0;
+		} else
+			return -EINVAL;
+/*	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		val->intval =3D liion_internal_voltage(liion_voltage(), battery_current(=
))*1000;
+		return 0;*/
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval =3D 4200000;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval =3D 3400000;
+		return 0;
+	case POWER_SUPPLY_PROP_TEMP:
+		if (spitz_bat_temp >=3D 0) {
+			mutex_lock(&bat_lock);
+			val->intval =3D spitz_bat_temp;
+			mutex_unlock(&bat_lock);
+			return 0;
+		} else
+			return -EINVAL;
+/*	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval =3D "spitz-battery";
+		return 0;*/
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval =3D 1;
+		return 0;
+	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+		val->intval =3D 2000000;
+		return 0;
+/*	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval =3D get_percentage();
+		return 0;
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval =3D battery_current() * 1000;
+		return 0;*/
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
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		mutex_lock(&bat_lock);
+		val->intval =3D spitz_bat_status;
+		mutex_unlock(&bat_lock);
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		mutex_lock(&bat_lock);
+		val->intval =3D spitz_ac_volt;
+		mutex_unlock(&bat_lock);
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval =3D 5250000;
+		return 0;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval =3D 4750000;
+		return 0;
+//	case POWER_SUPPLY_PROP_MODEL_NAME:
+//		val->strval =3D "spitz-power-supply";
+//		return 0;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval =3D !gpio_get_value(SPITZ_GPIO_AC_IN);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+
+static void spitz_bat_external_power_changed(struct power_supply *bat_ps)
+{
+	printk("%s[%i]\n", __FUNCTION__, __LINE__);
+}
+
+static enum power_supply_property spitz_bat_main_props[] =3D {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+//	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,//?
+//	POWER_SUPPLY_PROP_HEALTH,//?
+	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,//?
+//	POWER_SUPPLY_PROP_CURRENT_NOW,
+//	POWER_SUPPLY_PROP_CAPACITY,
+};
+
+static struct power_supply spitz_bat_main =3D {
+	.name			=3D "main-battery",
+	.type			=3D POWER_SUPPLY_TYPE_BATTERY,
+	.properties		=3D spitz_bat_main_props,
+	.num_properties		=3D ARRAY_SIZE(spitz_bat_main_props),
+	.get_property		=3D spitz_bat_get_property,
+	.external_power_changed	=3D spitz_bat_external_power_changed,
+	.use_for_apm		=3D 1,
+};
+
+static enum power_supply_property spitz_ac_props[] =3D {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_PRESENT,
+};
+
+static struct power_supply spitz_ac =3D {
+	.name		=3D "ac",
+	.type		=3D POWER_SUPPLY_TYPE_MAINS,
+	.properties	=3D spitz_ac_props,
+	.num_properties	=3D ARRAY_SIZE(spitz_ac_props),
+	.get_property	=3D spitz_ac_get_property,
+};
+
+static void spitz_bat_set_chrg(int type, int update)
+{
+/* If something fails here ...
+ *
+ *         ..,:*:"*:~"*;'*'..
+ *       .::*;;*~*:*;~:`::"'':;.
+ *      ,'*":*';~*":*";*'''":'":.
+ *      :;.'*.',;*~,;*';,*;*,*;;*
+ *      ';*:*';):"=3D*.~.,'(*,;*';
+ *        '*~"` :"*';.*;. `~=3D*`
+ *             (":*:*'*;')
+ *              :"':' ';:
+ *             .. "  ""';.    ..
+ *   .        :; '";;": *::  //
+ *__/..""".._....,..,.,.,.,.//;:;,.,..::.
+ *               BOOM!!
+ */
+printk("%s[%i] %i\n", __FUNCTION__, __LINE__, type);
+	spitz_bat_charge =3D type;
+	switch (type) {
+		case POWER_SUPPLY_CHARGE_TYPE_NONE:
+			gpio_set_value(SPITZ_GPIO_JK_B, 0);
+			gpio_set_value(SPITZ_GPIO_CHRG_ON, 1);
+			break;
+		case POWER_SUPPLY_CHARGE_TYPE_TRICKLE:
+			gpio_set_value(SPITZ_GPIO_JK_B, 0);
+			gpio_set_value(SPITZ_GPIO_CHRG_ON, 0);
+			break;
+		case POWER_SUPPLY_CHARGE_TYPE_FAST:
+			gpio_set_value(SPITZ_GPIO_JK_B, 1);
+			gpio_set_value(SPITZ_GPIO_CHRG_ON, 0);
+			break;
+		default:
+			spitz_bat_charge =3D POWER_SUPPLY_CHARGE_TYPE_UNKNOWN;
+			break;
+
+	}
+	if (update) {
+		power_supply_changed(&spitz_ac);
+		power_supply_changed(&spitz_bat_main);
+	}
+}
+
+/*
+ * max1111 accepts channels from 0-3, however,
+ * it is encoded from 0-7 here in the code.
+ */
+
+static int spitz_bat_max_sample(int channel, int delay)
+{
+	int i;
+	int ret =3D 0;
+
+	for (i =3D 0; i < 5; i++) {
+		ret +=3D max1111_read_channel(channel);
+		mdelay(delay);
+	}
+
+	return ret / 5;
+}
+static int spitz_bat_get_temp(void)
+{
+	/*
+	 * SHARPSL_BATT_TEMP returns:
+	 * 121: battery finished charging in 22C room
+	 * 141: outside at 6C
+	 */
+	int ret;
+
+	mdelay(SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
+	gpio_set_value(SPITZ_GPIO_ADC_TEMP_ON, 1);
+	ret =3D spitz_bat_max_sample(SHARPSL_BATT_TEMP,
+		SHARPSL_CHECK_BATTERY_WAIT_TIME_TEMP);
+	gpio_set_value(SPITZ_GPIO_ADC_TEMP_ON, 0);
+	return ret;
+}
+
+static inline int spitz_bat_get_volt(void)
+{
+	int ret;
+	int charge =3D spitz_bat_charge;
+
+//	spitz_bat_set_chrg(POWER_SUPPLY_CHARGE_TYPE_NONE, 0);
+
+//	gpio_set_value(SPITZ_GPIO_JK_A, 1);
+//	mdelay(SHARPSL_WAIT_DISCHARGE_ON);
+	/* XXX missing -- toggle green led by some standard mean */
+
+	ret =3D spitz_bat_max_sample(SHARPSL_BATT_VOLT,
+		SHARPSL_CHECK_BATTERY_WAIT_TIME_VOLT);
+
+//	gpio_set_value(SPITZ_GPIO_JK_A, 0);
+	/* XXX missing -- toggle green led by some standard mean */
+
+//	spitz_bat_set_chrg(charge, 0);
+
+	return ret;
+}
+
+static inline int spitz_bat_get_acin_volt(void)
+{
+	return spitz_bat_max_sample(SHARPSL_ACIN_VOLT,
+			SHARPSL_CHECK_BATTERY_WAIT_TIME_ACIN);
+}
+
+static int spitz_bat_thread(void *null)
+{
+	int ac_in, chrg_full, fatal_bat;
+
+	set_freezable();
+
+	do {
+	ac_in =3D !gpio_get_value(SPITZ_GPIO_AC_IN);
+	chrg_full =3D gpio_get_value(SPITZ_GPIO_CHRG_FULL);
+	fatal_bat =3D !gpio_get_value(SPITZ_GPIO_FATAL_BAT);
+
+	bat_restart =3D 0;
+
+	printk("%s[%i] AC:%i CH:%i FB:%i\n", __FUNCTION__, __LINE__, !!ac_in, !!c=
hrg_full, !!fatal_bat);
+
+	mutex_lock(&bat_lock);
+
+	if (fatal_bat) {
+		spitz_bat_set_chrg(POWER_SUPPLY_CHARGE_TYPE_NONE, 1);
+		spitz_bat_status =3D POWER_SUPPLY_STATUS_UNKNOWN;
+		printk("XXX\n");
+		goto end;
+	}
+
+	if (ac_in) {
+		if (chrg_full) {
+			if (spitz_bat_status !=3D POWER_SUPPLY_STATUS_FULL) {
+			spitz_bat_set_chrg(POWER_SUPPLY_CHARGE_TYPE_TRICKLE, 1);
+			spitz_bat_status =3D POWER_SUPPLY_STATUS_FULL;
+			}
+		} else {
+			if (spitz_bat_status !=3D POWER_SUPPLY_STATUS_CHARGING) {
+			spitz_bat_set_chrg(POWER_SUPPLY_CHARGE_TYPE_FAST, 1);
+			spitz_bat_status =3D POWER_SUPPLY_STATUS_CHARGING;
+			}
+		}
+	} else {
+		if (spitz_bat_status !=3D POWER_SUPPLY_STATUS_DISCHARGING) {
+		spitz_bat_set_chrg(POWER_SUPPLY_CHARGE_TYPE_NONE, 1);
+		spitz_bat_status =3D POWER_SUPPLY_STATUS_DISCHARGING;
+		}
+	}
+
+	spitz_bat_temp =3D spitz_bat_get_temp();
+	/*
+	 * Thanks to Stanislav B. ADC has 3.3V as reference,
+	 * is connected to battery over 47kOhm, and to ground over 100kOhm.
+	 */
+	spitz_bat_volt =3D (spitz_bat_get_volt());// * 1000 * 147 * 33) / 256;
+	printk("SBV: %i\n", spitz_bat_volt);
+	spitz_bat_volt =3D (spitz_bat_volt * 10000 * 147 * 33) / 256;
+	/*
+	 * Thanks to Stanislav B. ADC has 3.3V as reference,
+	 * is connected to acin over 2kOhm, and to ground over 1kOhm.
+	 */
+	spitz_ac_volt =3D (spitz_bat_get_acin_volt());// * 3000 * 3300) / 256
+	printk("SAV: %i\n", spitz_ac_volt);
+	spitz_ac_volt =3D (spitz_ac_volt * 3000 * 3300) / 256;
+
+end:
+	mutex_unlock(&bat_lock);
+
+	wait_event_freezable_timeout(bat_wait, bat_restart || kthread_should_stop=
(), msecs_to_jiffies(1000));
+
+	printk("%s[%i] AC:%i CH:%i FB:%i [BT:%i BV:%i AV:%i\n", __FUNCTION__, __L=
INE__, !!ac_in, !!chrg_full, !!fatal_bat, spitz_bat_temp, spitz_bat_volt, s=
pitz_ac_volt);
+	} while (!kthread_should_stop());
+
+	printk("%s[%i]\n", __FUNCTION__, __LINE__);
+	bat_thread =3D NULL;
+
+	return 0;
+}
+
+static irqreturn_t spitz_bat_ac_in_irq(int irq, void *data)
+{
+	printk("%s[%i] %i\n", __FUNCTION__, __LINE__, !!gpio_get_value(SPITZ_GPIO=
_AC_IN));
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t spitz_bat_chrg_full_irq(int irq, void *data)
+{
+//	printk("%s[%i] %i\n", __FUNCTION__, __LINE__, !!gpio_get_value(SPITZ_GP=
IO_CHRG_FULL));
+//	schedule_work(&bat_work);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t spitz_bat_fatal_bat_irq(int irq, void *data)
+{
+	printk("%s[%i] %i\n", __FUNCTION__, __LINE__, !!gpio_get_value(SPITZ_GPIO=
_FATAL_BAT));
+	pr_err("Fatal battery error!\n");
+	spitz_bat_set_chrg(POWER_SUPPLY_CHARGE_TYPE_NONE, 1);
+	return IRQ_HANDLED;
+}
+
+static int __devinit spitz_bat_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	if (!(machine_is_spitz() || machine_is_akita()
+		|| machine_is_borzoi())) {
+		dev_err(&pdev->dev,
+			"This driver only supports Akita, Spitz and Borzoi!");
+		return -ENODEV;
+	}
+
+	if (pdev->id !=3D -1) {
+		dev_err(&pdev->dev,
+			"Can't register multiple instances of this driver!");
+		return -EINVAL;
+	}
+
+	ret =3D gpio_request(SPITZ_GPIO_AC_IN, "AC IN");
+	if (ret)
+		goto err;
+	ret =3D gpio_direction_input(SPITZ_GPIO_AC_IN);
+	if (ret)
+		goto err2;
+	ret =3D request_irq(gpio_to_irq(SPITZ_GPIO_AC_IN),
+			spitz_bat_ac_in_irq, IRQF_TRIGGER_RISING |
+			IRQF_TRIGGER_FALLING, "AC Detect", pdev);
+	if (ret)
+		goto err2;
+
+	ret =3D gpio_request(SPITZ_GPIO_CHRG_FULL, "CHRG FULL");
+	if (ret)
+		goto err3;
+	ret =3D gpio_direction_input(SPITZ_GPIO_CHRG_FULL);
+	if (ret)
+		goto err4;
+	ret =3D request_irq(gpio_to_irq(SPITZ_GPIO_CHRG_FULL),
+			spitz_bat_chrg_full_irq, IRQF_TRIGGER_RISING |
+			IRQF_TRIGGER_FALLING, "Charging complete", pdev);
+	if (ret)
+		goto err4;
+
+	ret =3D gpio_request(SPITZ_GPIO_FATAL_BAT, "FATAL BAT");
+	if (ret)
+		goto err5;
+	ret =3D gpio_direction_input(SPITZ_GPIO_FATAL_BAT);
+	if (ret)
+		goto err6;
+	ret =3D request_irq(gpio_to_irq(SPITZ_GPIO_FATAL_BAT),
+			spitz_bat_fatal_bat_irq, IRQF_TRIGGER_RISING |
+			IRQF_TRIGGER_FALLING, "Battery error", pdev);
+	if (ret)
+		goto err6;
+
+	ret =3D gpio_request(SPITZ_GPIO_JK_A, "JK A");
+	if (ret)
+		goto err7;
+	ret =3D gpio_direction_output(SPITZ_GPIO_JK_A, 0);
+	if (ret)
+		goto err8;
+	gpio_set_value(SPITZ_GPIO_JK_A, 0);
+
+	ret =3D gpio_request(SPITZ_GPIO_JK_B, "JK B");
+	if (ret)
+		goto err8;
+	ret =3D gpio_direction_output(SPITZ_GPIO_JK_B, 0);
+	if (ret)
+		goto err9;
+
+	ret =3D gpio_request(SPITZ_GPIO_CHRG_ON, "CHRG ON");
+	if (ret)
+		goto err9;
+	ret =3D gpio_direction_output(SPITZ_GPIO_CHRG_ON, 1);
+	if (ret)
+		goto err10;
+
+	ret =3D gpio_request(SPITZ_GPIO_ADC_TEMP_ON, "TEMP MSMT");
+	if (ret)
+		goto err10;
+	ret =3D gpio_direction_output(SPITZ_GPIO_ADC_TEMP_ON, 0);
+	if (ret)
+		goto err11;
+
+	mutex_init(&bat_lock);
+
+	printk("%s[%i]\n", __FUNCTION__, __LINE__);
+	ret =3D power_supply_register(&pdev->dev, &spitz_bat_main);
+	if (ret)
+		goto err11;
+
+	ret =3D power_supply_register(&pdev->dev, &spitz_ac);
+	if (ret)
+		goto err12;
+
+	bat_restart =3D 0;
+	init_waitqueue_head(&bat_wait);
+	bat_thread =3D kthread_run(spitz_bat_thread, NULL, "spitz-bat");
+
+	printk("%s[%i]\n", __FUNCTION__, __LINE__);
+
+	return 0;
+
+err12:
+	power_supply_unregister(&spitz_bat_main);
+err11:
+	gpio_free(SPITZ_GPIO_ADC_TEMP_ON);
+err10:
+	gpio_free(SPITZ_GPIO_CHRG_ON);
+err9:
+	gpio_free(SPITZ_GPIO_JK_B);
+err8:
+	gpio_free(SPITZ_GPIO_JK_A);
+err7:
+	free_irq(gpio_to_irq(SPITZ_GPIO_FATAL_BAT), pdev);
+err6:
+	gpio_free(SPITZ_GPIO_FATAL_BAT);
+err5:
+	free_irq(gpio_to_irq(SPITZ_GPIO_CHRG_FULL), pdev);
+err4:
+	gpio_free(SPITZ_GPIO_CHRG_FULL);
+err3:
+	free_irq(gpio_to_irq(SPITZ_GPIO_AC_IN), pdev);
+err2:
+	gpio_free(SPITZ_GPIO_AC_IN);
+err:
+	return ret;
+}
+
+static int __devexit spitz_bat_remove(struct platform_device *pdev)
+{
+	kthread_stop(bat_thread);
+	power_supply_unregister(&spitz_ac);
+	power_supply_unregister(&spitz_bat_main);
+	gpio_free(SPITZ_GPIO_ADC_TEMP_ON);
+	gpio_free(SPITZ_GPIO_CHRG_ON);
+	gpio_free(SPITZ_GPIO_JK_B);
+	gpio_free(SPITZ_GPIO_JK_A);
+	free_irq(gpio_to_irq(SPITZ_GPIO_FATAL_BAT), pdev);
+	gpio_free(SPITZ_GPIO_FATAL_BAT);
+	free_irq(gpio_to_irq(SPITZ_GPIO_CHRG_FULL), pdev);
+	gpio_free(SPITZ_GPIO_CHRG_FULL);
+	free_irq(gpio_to_irq(SPITZ_GPIO_AC_IN), pdev);
+	gpio_free(SPITZ_GPIO_AC_IN);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int spitz_bat_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int spitz_bat_resume(struct device *dev)
+{
+	wake_up(&bat_wait);
+	return 0;
+}
+
+static const struct dev_pm_ops spitz_bat_pm_ops =3D {
+	.suspend	=3D spitz_bat_suspend,
+	.resume		=3D spitz_bat_resume,
+};
+#endif
+
+static struct platform_driver spitz_bat_driver =3D {
+	.driver	=3D {
+		.name	=3D "spitz-battery",
+		.owner	=3D THIS_MODULE,
+#ifdef	CONFIG_PM
+		.pm	=3D &spitz_bat_pm_ops,
+#endif
+	},
+	.probe		=3D spitz_bat_probe,
+	.remove		=3D __devexit_p(spitz_bat_remove),
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
=2D-=20
1.7.1


--Boundary-00=_ZmCVMM/TLc671KC--
