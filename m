Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458Ab2J3UFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:05:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42738 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933850Ab2J3UFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:05:04 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: [PATCH] New Nokia RX-51 power supply battery driver
Date: Tue, 30 Oct 2012 21:04:55 +0100
Message-ID: <19040462.WFXWijAIDd@pali>
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2929056.8OJZsVoRIi"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2929056.8OJZsVoRIi
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello,

I'm sending new power_supply driver which export battery design
capacity, battery temperature and voltage on Nokia N900. All
these properties are read from battery pins throw twl madc channels.

I'm working on full BME replacement for Nokia N900. BME is Nokia
proprietary buggy userspace software which charging battery. It
has a lot of bugs and is blocker for USB host mode. Charging is
done by bq24150a chip and some battery properties can be read from
bq27200 chip. But battery design capacity and battery temperature
must be read directly from battery (via twl madc channels). So this
is reason for another power_supply driver on Nokia N900.

Except Nokia RX-51 Schematics there is no available documentation
about battery, charging and madc channels (for n900), so all
information was RE.

Big problem was converting RAW values from channels to standard
which kernel report (uAh, uV, 1/100 C). There is no information
about RAW unit. So conversation formula for capacity and voltage
was taken from maemo binary bsi-read. Temperature formula was
somehow computed.

But what is important is that proprietary SW BME can report
current temperature (in K) and design capacity (in mAh) and
also reporting corresponding RAW values. We tested this kernel
driver and BME and both reported same battery capacity and
temperature (+/- 1C). So data from this driver should be correct
(if BME is correct).

Driver is only for Nokia N900. It is needed for open source project
which will replace BME: https://gitorious.org/rx51-bme-replacement

Because twl4030_madc_conversion can be called only from kernel and
there is battery interface in power supply it make sense me to write
battery driver instead creating some method for exporting function
twl4030_madc_conversion to user space (which is done on patched maemo
kernel to allow BME calling twl4030_madc_conversion).

Thanks to Joerg Reisenweber and Ivaylo Dimitrov for collecting needed
data, help with some problems and fixing errors!

--- /dev/null
+++ kernel-power/drivers/power/rx51_battery.c
@@ -0,0 +1,257 @@
+/*
+    rx51_battery.c - Nokia RX-51 battery driver
+    Copyright (C) 2012  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+
+    This program is free software; you can redistribute it and/or modi=
fy
+    it under the terms of the GNU General Public License as published =
by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License =
along
+    with this program; if not, write to the Free Software Foundation, =
Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+*/
+
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/slab.h>
+#include <linux/i2c/twl4030-madc.h>
+
+struct rx51_device_info {
+=09struct device *dev;
+=09struct power_supply bat;
+};
+
+/*
+   Read ADCIN channel value, code copied from maemo kernel
+ */
+static int rx51_battery_read_adc(int channel)
+{
+=09struct twl4030_madc_request req;
+
+=09req.channels =3D (1 << channel);
+=09req.do_avg =3D 1;
+=09req.method =3D TWL4030_MADC_SW1;
+=09req.func_cb =3D NULL;
+=09req.type =3D TWL4030_MADC_WAIT;
+
+=09if (twl4030_madc_conversion(&req) > 0)
+=09=09return req.rbuf[channel];
+=09else
+=09=09return -ENODATA;
+}
+
+/*
+   Read ADCIN channel 12 (voltage) and convert RAW value to micro volt=
age
+   This conversion formula was extracted from maemo program bsi-read
+ */
+static int rx51_battery_read_voltage(struct rx51_device_info *di)
+{
+=09int voltage =3D rx51_battery_read_adc(12);
+=09if (voltage < 0)
+=09=09return voltage;
+=09return 1000 * (10000 * voltage / 1705);
+}
+
+/*
+   Temperature look-up tables
+   TEMP =3D (1/(t1 + 1/298) - 273.15)
+   Where t1 =3D (1/B) * ln((RAW_ADC_U * 2.5)/(R * I * 255))
+   Formula is based on experimental data, RX-51 CAL data, maemo progra=
m bme
+   and formula from da9052 driver with values R =3D 100, B =3D 3380, I=
 =3D 0.00671
+ */
+
+/*
+   Table1 (temperature for first 25 RAW values)
+   Usage: TEMP =3D rx51_temp_table1[RAW]
+     RAW is between 1 and 24
+     TEMP is between 201 C and 55 C
+ */
+static u8 rx51_temp_table1[] =3D {
+=09255, 201, 159, 138, 124, 114, 106,  99,  94,  89,  85,  82,  78,  7=
5,
+=09 73,  70,  68,  66,  64,  62,  61,  59,  57,  56,  55
+};
+
+/*
+   Table2 (lowest RAW value for temperature)
+   Usage: RAW =3D rx51_temp_table2[TEMP-rx51_temp_table2_first]
+     TEMP is between 53 C and -32 C
+     RAW is between 25 and 993
+ */
+#define rx51_temp_table2_first 53
+static u16 rx51_temp_table2[] =3D {
+=09 25,  26,  27,  28,  29,  30,  31,  32,  33,  34,  35,  36,  37,  3=
9,
+=09 40,  41,  43,  44,  46,  48,  49,  51,  53,  55,  57,  59,  61,  6=
4,
+=09 66,  69,  71,  74,  77,  80,  83,  86,  90,  94,  97, 101, 106, 11=
0,
+=09115, 119, 125, 130, 136, 141, 148, 154, 161, 168, 176, 184, 202, 21=
1,
+=09221, 231, 242, 254, 266, 279, 293, 308, 323, 340, 357, 375, 395, 41=
5,
+=09437, 460, 485, 511, 539, 568, 600, 633, 669, 706, 747, 790, 836, 88=
5,
+=09937, 993, 1024
+};
+
+/*
+   Read ADCIN channel 0 (battery temp) and convert value to tenths of =
Celsius
+   Use Temperature look-up tables for conversation
+ */
+static int rx51_battery_read_temperature(struct rx51_device_info *di)
+{
+=09int min =3D 0;
+=09int max =3D ARRAY_SIZE(rx51_temp_table2)-1;
+=09int raw =3D rx51_battery_read_adc(0);
+
+=09/* Zero and negative values are undefined */
+=09if (raw <=3D 0)
+=09=09return INT_MAX;
+
+=09/* ADC channels are 10 bit, higher value are undefined */
+=09if (raw >=3D (1 << 10))
+=09=09return INT_MIN;
+
+=09/* First check for temperature in first direct table */
+=09if (raw < ARRAY_SIZE(rx51_temp_table1))
+=09=09return rx51_temp_table1[raw] * 100;
+
+=09/* Binary search RAW value in second inverse table */
+=09while (max-min > 1) {
+=09=09int mid =3D (max+min)/2;
+=09=09if (rx51_temp_table2[mid] <=3D raw)
+=09=09=09min =3D mid;
+=09=09else if (rx51_temp_table2[mid] > raw)
+=09=09=09max =3D mid;
+=09=09if (rx51_temp_table2[mid] =3D=3D raw)
+=09=09=09break;
+=09}
+
+=09return (rx51_temp_table2_first - min) * 100;
+}
+
+/*
+   Read ADCIN channel 4 (BSI) and convert RAW value to micro Ah
+   This conversion formula was extracted from maemo program bsi-read
+ */
+static int rx51_battery_read_capacity(struct rx51_device_info *di)
+{
+=09int capacity =3D rx51_battery_read_adc(4);
+=09if (capacity < 0)
+=09=09return capacity;
+=09return 1280 * (1200 * capacity)/(1024 - capacity);
+}
+
+/*
+   Return power_supply property
+ */
+static int rx51_battery_get_property(struct power_supply *psy,
+=09=09=09=09=09enum power_supply_property psp,
+=09=09=09=09=09union power_supply_propval *val)
+{
+=09struct rx51_device_info *di =3D container_of((psy),
+=09=09=09=09struct rx51_device_info, bat);
+
+=09switch (psp) {
+=09case POWER_SUPPLY_PROP_TECHNOLOGY:
+=09=09val->intval =3D POWER_SUPPLY_TECHNOLOGY_LION;
+=09=09break;
+=09case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+=09=09val->intval =3D 4200000;
+=09=09break;
+=09case POWER_SUPPLY_PROP_PRESENT:
+=09=09val->intval =3D rx51_battery_read_voltage(di) ? 1 : 0;
+=09=09break;
+=09case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+=09=09val->intval =3D rx51_battery_read_voltage(di);
+=09=09break;
+=09case POWER_SUPPLY_PROP_TEMP:
+=09=09val->intval =3D rx51_battery_read_temperature(di);
+=09=09break;
+=09case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
+=09=09val->intval =3D rx51_battery_read_capacity(di);
+=09=09break;
+=09default:
+=09=09return -EINVAL;
+=09}
+
+=09if (val->intval =3D=3D INT_MAX || val->intval =3D=3D INT_MIN)
+=09=09return -EINVAL;
+
+=09return 0;
+}
+
+static enum power_supply_property rx51_battery_props[] =3D {
+=09POWER_SUPPLY_PROP_TECHNOLOGY,
+=09POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+=09POWER_SUPPLY_PROP_PRESENT,
+=09POWER_SUPPLY_PROP_VOLTAGE_NOW,
+=09POWER_SUPPLY_PROP_TEMP,
+=09POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
+};
+
+static int __devinit rx51_battery_probe(struct platform_device *pdev)
+{
+=09struct rx51_device_info *di;
+=09int ret;
+
+=09di =3D kzalloc(sizeof(*di), GFP_KERNEL);
+=09if (!di)
+=09=09return -ENOMEM;
+
+=09platform_set_drvdata(pdev, di);
+
+=09di->bat.name =3D dev_name(&pdev->dev);
+=09di->bat.type =3D POWER_SUPPLY_TYPE_BATTERY;
+=09di->bat.properties =3D rx51_battery_props;
+=09di->bat.num_properties =3D ARRAY_SIZE(rx51_battery_props);
+=09di->bat.get_property =3D rx51_battery_get_property;
+
+=09ret =3D power_supply_register(di->dev, &di->bat);
+=09if (ret) {
+=09=09platform_set_drvdata(pdev, NULL);
+=09=09kfree(di);
+=09=09return ret;
+=09}
+
+=09return 0;
+}
+
+static int __devexit rx51_battery_remove(struct platform_device *pdev)=

+{
+=09struct rx51_device_info *di =3D platform_get_drvdata(pdev);
+
+=09power_supply_unregister(&di->bat);
+=09platform_set_drvdata(pdev, NULL);
+=09kfree(di);
+
+=09return 0;
+}
+
+static struct platform_driver rx51_battery_driver =3D {
+=09.probe =3D rx51_battery_probe,
+=09.remove =3D __devexit_p(rx51_battery_remove),
+=09.driver =3D {
+=09=09.name =3D "rx51-battery",
+=09=09.owner =3D THIS_MODULE,
+=09},
+};
+
+static int __init rx51_battery_init(void)
+{
+=09return platform_driver_register(&rx51_battery_driver);
+}
+module_init(rx51_battery_init);
+
+static void __exit rx51_battery_exit(void)
+{
+=09platform_driver_unregister(&rx51_battery_driver);
+}
+module_exit(rx51_battery_exit);
+
+MODULE_ALIAS("platform:rx51-battery");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_DESCRIPTION("Nokia RX-51 battery driver");
+MODULE_LICENSE("GPL");

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--nextPart2929056.8OJZsVoRIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCQMugACgkQi/DJPQPkQ1I6CQCbBBMxmphFOPjUpG0v/MVFXTV6
ZGwAn3kXRE9R4uybcKT6260ihcMks/Fb
=J1US
-----END PGP SIGNATURE-----

--nextPart2929056.8OJZsVoRIi--

