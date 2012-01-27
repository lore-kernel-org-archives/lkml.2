Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab2A0Ckw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:40:52 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46485 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2A0Cku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:40:50 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>,
        Sebastian Reichel <sre@debian.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Subject: RFC 2: bq2415x_charger driver
Date: Fri, 27 Jan 2012 03:40:43 +0100
Message-ID: <3531484.T8K8kTguQQ@pali>
User-Agent: KMail/4.8.0 (Linux/3.2.0-10-generic; KDE/4.8.0; x86_64; ; )
In-Reply-To: <1677656.4d3iQHNZjX@pali-elitebook>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <1677656.4d3iQHNZjX@pali-elitebook>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2224598.Ja3zkPYUcS"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2224598.Ja3zkPYUcS
Content-Type: multipart/mixed; boundary="nextPart3522216.fjNTXqfEpy"
Content-Transfer-Encoding: 7Bit


--nextPart3522216.fjNTXqfEpy
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hello,

I'm sending second RFC kernel driver which can charge battery in Nokia =
N900.=20
Now all code for bq2415x chip is in one kernel driver bq2415x_charger. =
This=20
version working fine on Nokia N900 with kernel 2.6.28 (but should work =
with=20
new versions too). I tested only charging (but boost mode is implemente=
d too).

Driver has power_supply interface (without new charger interface - due =
to=20
compatibility with n900 kernel 2.6.28) and additional sysfs entires for=
=20
configuring bq chip.

I created this sysfs files integrated into power_supply subdir:

(rw) battery_regulation_voltage (int)
(r)  boost_status (int)
(rw) current_limit (int)
(r)  fault_status (int)
(rw) high_impedance_enable (int)
(rw) charge_current_sense_voltage (int)
(rw) charge_current_termination_enable (int)
(r)  charge_status (int)
(rw) mode (string)
(rw) otg_pin_enable (int)
(r)  otg_status (int)
(r)  regdump (string)
(rw) stat_pin_enable (int)
(rw) termination_current_sense_voltage (int)
(rw) timer (string)
(rw) weak_battery_voltage (int)

most important sysfs entry is mode:
it will configure mode (charge or boost) and current_limit. possible va=
lues:
* auto
* none (100mA)
* host (USB Host/HUB charger - 500mA)
* dedicated (USB Dedicated charger - unlimited mA)
* boost (boost mode for usb host mode - charging disabled)

auto mode depends on external platform data (now not working) - in futu=
re can=20
be configured with isp1704_charger driver, which support autodetection =
of=20
connected charger.

how to use this module on n900 to charge battery:
1. Turn off BME
2. load module
3. connect charger and set correct charger type:
 $ echo host > /sys/class/power_supply/bq24150-0/mode
 or
 $ echo dedicated > /sys/class/power_supply/bq24150-0/mode

This RFC driver has not implemented sysfs entries for configuring charg=
e=20
current sense voltage and termination current sense voltage.

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart3522216.fjNTXqfEpy
Content-Disposition: attachment; filename="bq2415x_charger.patch"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; charset="UTF-8"; name="bq2415x_charger.patch"

--- /dev/null=092012-01-26 12:32:59.572022923 +0100
+++ bq2415x_charger.c=092012-01-27 02:58:56.026089998 +0100
@@ -0,0 +1,1438 @@
+/*
+    bq2415x_charger.c - bq2415x charger driver
+    Copyright (C) 2011-2012  Pali Roh=C3=A1r <pali.rohar@gmail.com>
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
+/*
+  Datasheets:
+  http://www.ti.com/product/bq24150
+  http://www.ti.com/product/bq24150a
+  http://www.ti.com/product/bq24152
+  http://www.ti.com/product/bq24153
+  http://www.ti.com/product/bq24153a
+  http://www.ti.com/product/bq24155
+*/
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/err.h>
+#include <linux/workqueue.h>
+#include <linux/sysfs.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/idr.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+
+/*#include "isp1704_charger.h"*/
+#include "bq2415x_charger.h"
+
+#define BQ2415X_TIMER_TIMEOUT=0910
+
+#define BQ2415X_REG_STATUS=09=090x00
+#define BQ2415X_REG_CONTROL=09=090x01
+#define BQ2415X_REG_VOLTAGE=09=090x02
+#define BQ2415X_REG_VENDER=09=090x03
+#define BQ2415X_REG_CURRENT=09=090x04
+
+/* reset state for all registers */
+#define BQ2415X_RESET_STATUS=09=09BIT(6)
+#define BQ2415X_RESET_CONTROL=09=09(BIT(4)|BIT(5))
+#define BQ2415X_RESET_VOLTAGE=09=09(BIT(1)|BIT(3))
+#define BQ2415X_RESET_CURRENT=09=09(BIT(0)|BIT(3)|BIT(7))
+
+/* status register */
+#define BQ2415X_BIT_TMR_RST=09=097
+#define BQ2415X_BIT_OTG=09=09=097
+#define BQ2415X_BIT_EN_STAT=09=096
+#define BQ2415X_MASK_STAT=09=09(BIT(4)|BIT(5))
+#define BQ2415X_SHIFT_STAT=09=094
+#define BQ2415X_BIT_BOOST=09=093
+#define BQ2415X_MASK_FAULT=09=09(BIT(0)|BIT(1)|BIT(2))
+#define BQ2415X_SHIFT_FAULT=09=090
+
+/* control register */
+#define BQ2415X_MASK_LIMIT=09=09(BIT(6)|BIT(7))
+#define BQ2415X_SHIFT_LIMIT=09=096
+#define BQ2415X_MASK_VLOWV=09=09(BIT(4)|BIT(5))
+#define BQ2415X_SHIFT_VLOWV=09=094
+#define BQ2415X_BIT_TE=09=09=093
+#define BQ2415X_BIT_CE=09=09=092
+#define BQ2415X_BIT_HZ_MODE=09=091
+#define BQ2415X_BIT_OPA_MODE=09=090
+
+/* voltage register */
+#define BQ2415X_MASK_VO=09=09=09(BIT(2)|BIT(3)|BIT(4)|BIT(5)|BIT(6)|BI=
T(7))
+#define BQ2415X_SHIFT_VO=09=092
+#define BQ2415X_BIT_OTG_PL=09=091
+#define BQ2415X_BIT_OTG_EN=09=090
+
+/* vender register */
+#define BQ2415X_MASK_VENDER=09=09(BIT(5)|BIT(6)|BIT(7))
+#define BQ2415X_SHIFT_VENDER=09=095
+#define BQ2415X_MASK_PN=09=09=09(BIT(3)|BIT(4))
+#define BQ2415X_SHIFT_PN=09=093
+#define BQ2415X_MASK_REVISION=09=09(BIT(0)|BIT(1)|BIT(2))
+#define BQ2415X_SHIFT_REVISION=09=090
+
+/* current register */
+/* RESET=09=09=09=09BIT(7) */
+#define BQ2415X_MASK_VI_CHRG=09=09(BIT(4)|BIT(5)|BIT(6))
+#define BQ2415X_SHIFT_VI_CHRG=09=094
+/* N/A=09=09=09=09=09BIT(3) */
+#define BQ2415X_MASK_VI_TERM=09=09(BIT(0)|BIT(1)|BIT(2))
+#define BQ2415X_SHIFT_VI_TERM=09=090
+
+
+enum bq2415x_command {
+=09BQ2415X_TIMER_RESET,
+=09BQ2415X_OTG_STATUS,
+=09BQ2415X_STAT_PIN_STATUS,
+=09BQ2415X_STAT_PIN_ENABLE,
+=09BQ2415X_STAT_PIN_DISABLE,
+=09BQ2415X_CHARGE_STATUS,
+=09BQ2415X_BOOST_STATUS,
+=09BQ2415X_FAULT_STATUS,
+
+=09BQ2415X_CHARGE_CURRENT_TERMINATION_STATUS,
+=09BQ2415X_CHARGE_CURRENT_TERMINATION_ENABLE,
+=09BQ2415X_CHARGE_CURRENT_TERMINATION_DISABLE,
+=09BQ2415X_CHARGER_STATUS,
+=09BQ2415X_CHARGER_ENABLE,
+=09BQ2415X_CHARGER_DISABLE,
+=09BQ2415X_HIGH_IMPEDANCE_STATUS,
+=09BQ2415X_HIGH_IMPEDANCE_ENABLE,
+=09BQ2415X_HIGH_IMPEDANCE_DISABLE,
+=09BQ2415X_BOOST_MODE_STATUS,
+=09BQ2415X_BOOST_MODE_ENABLE,
+=09BQ2415X_BOOST_MODE_DISABLE,
+
+=09BQ2415X_OTG_LEVEL,
+=09BQ2415X_OTG_ACTIVATE_HIGH,
+=09BQ2415X_OTG_ACTIVATE_LOW,
+=09BQ2415X_OTG_PIN_STATUS,
+=09BQ2415X_OTG_PIN_ENABLE,
+=09BQ2415X_OTG_PIN_DISABLE,
+
+=09BQ2415X_VENDER_CODE,
+=09BQ2415X_PART_NUMBER,
+=09BQ2415X_REVISION,
+};
+
+enum bq2415x_chip {
+=09BQUNKNOWN,
+=09BQ24150,
+=09BQ24150A,
+=09BQ24151,
+=09BQ24151A,
+=09BQ24152,
+=09BQ24153,
+=09BQ24153A,
+=09BQ24155,
+=09BQ24156,
+=09BQ24156A,
+=09BQ24158,
+};
+
+enum bq2415x_mode {
+=09BQ2415X_MODE_NONE,
+=09BQ2415X_MODE_HOST_CHARGER,
+=09BQ2415X_MODE_DEDICATED_CHARGER,
+=09BQ2415X_MODE_BOOST,
+};
+
+static char *bq2415x_chip_name[] =3D {
+=09"unknown",
+=09"bq24150",
+=09"bq24150a",
+=09"bq24151",
+=09"bq24151a",
+=09"bq24152",
+=09"bq24153",
+=09"bq24153a",
+=09"bq24155",
+=09"bq24156",
+=09"bq24156a",
+=09"bq24158",
+};
+
+static char *bq2415x_rev_name[] =3D {
+=09"1.0",
+=09"1.1",
+=09"1.2",
+=09"1.3",
+=09"1.4",
+=09"1.5",
+=09"1.6",
+=09"1.7",
+=09"unknown",
+};
+
+struct bq2415x_device {
+=09struct device *dev;
+=09struct bq2415x_platform_data *platform_data;
+=09struct power_supply charger;
+=09struct delayed_work work;
+=09enum bq2415x_mode charger_mode;
+=09enum bq2415x_mode mode;
+=09enum bq2415x_chip chip;
+=09char *model;
+=09char *name;
+=09int autotimer;
+=09int automode;
+=09int id;
+};
+
+static DEFINE_IDR(bq2415x_id);
+
+static DEFINE_MUTEX(bq2415x_id_mutex);
+static DEFINE_MUTEX(bq2415x_timer_mutex);
+static DEFINE_MUTEX(bq2415x_type_mutex);
+static DEFINE_MUTEX(bq2415x_i2c_mutex);
+
+/* i2c read functions */
+
+static int bq2415x_i2c_read(struct bq2415x_device *bq, u8 reg)
+{
+=09struct i2c_client *client =3D to_i2c_client(bq->dev);
+=09struct i2c_msg msg[2];
+=09u8 val;
+=09int ret;
+
+=09if (!client->adapter)
+=09=09return -ENODEV;
+
+=09msg[0].addr =3D client->addr;
+=09msg[0].flags =3D 0;
+=09msg[0].buf =3D &reg;
+=09msg[0].len =3D sizeof(reg);
+=09msg[1].addr =3D client->addr;
+=09msg[1].flags =3D I2C_M_RD;
+=09msg[1].buf =3D &val;
+=09msg[1].len =3D sizeof(val);
+
+=09mutex_lock(&bq2415x_i2c_mutex);
+=09ret =3D i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
+=09mutex_unlock(&bq2415x_i2c_mutex);
+
+=09if (ret < 0)
+=09=09return ret;
+
+=09return val;
+}
+
+static int bq2415x_i2c_read_mask(struct bq2415x_device *bq, u8 reg, u8=
 mask, u8 shift)
+{
+=09int ret;
+
+=09if (shift > 8)
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_i2c_read(bq, reg);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return (ret & mask) >> shift;
+}
+
+static int bq2415x_i2c_read_bit(struct bq2415x_device *bq, u8 reg, u8 =
bit)
+{
+=09if (bit > 8)
+=09=09return -EINVAL;
+=09else
+=09=09return bq2415x_i2c_read_mask(bq, reg, BIT(bit), bit);
+}
+
+/* i2c write functions */
+
+static int bq2415x_i2c_write(struct bq2415x_device *bq, u8 reg, u8 val=
)
+{
+=09struct i2c_client *client =3D to_i2c_client(bq->dev);
+=09struct i2c_msg msg[1];
+=09u8 data[2];
+=09int ret;
+
+=09data[0] =3D reg;
+=09data[1] =3D val;
+
+=09msg[0].addr =3D client->addr;
+=09msg[0].flags =3D 0;
+=09msg[0].buf =3D data;
+=09msg[0].len =3D ARRAY_SIZE(data);
+
+=09mutex_lock(&bq2415x_i2c_mutex);
+=09ret =3D i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
+=09mutex_unlock(&bq2415x_i2c_mutex);
+
+=09/* i2c_transfer returns number of messages transferred */
+=09if (ret < 0)
+=09=09return ret;
+=09else if (ret !=3D 1)
+=09=09return -EIO;
+
+=09return 0;
+}
+
+static int bq2415x_i2c_write_mask(struct bq2415x_device *bq, u8 reg, u=
8 val, u8 mask, u8 shift)
+{
+=09int ret;
+
+=09if (shift > 8)
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_i2c_read(bq, reg);
+=09if (ret < 0)
+=09=09return ret;
+
+=09ret &=3D ~mask;
+=09ret |=3D val << shift;
+
+=09return bq2415x_i2c_write(bq, reg, ret);
+}
+
+static int bq2415x_i2c_write_bit(struct bq2415x_device *bq, u8 reg, bo=
ol val, u8 bit)
+{
+=09if (bit > 8)
+=09=09return -EINVAL;
+=09else
+=09=09return bq2415x_i2c_write_mask(bq, reg, val, BIT(bit), bit);
+}
+
+/* global exec command function */
+
+static int bq2415x_exec_command(struct bq2415x_device *bq, enum bq2415=
x_command command)
+{
+=09int ret;
+=09switch(command)
+=09{
+=09=09case BQ2415X_TIMER_RESET:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_STATUS, 1, BQ241=
5X_BIT_TMR_RST);
+=09=09case BQ2415X_OTG_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_STATUS, BQ2415X_B=
IT_OTG);
+=09=09case BQ2415X_STAT_PIN_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_STATUS, BQ2415X_B=
IT_EN_STAT);
+=09=09case BQ2415X_STAT_PIN_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_STATUS, 1, BQ241=
5X_BIT_EN_STAT);
+=09=09case BQ2415X_STAT_PIN_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_STATUS, 0, BQ241=
5X_BIT_EN_STAT);
+=09=09case BQ2415X_CHARGE_STATUS:
+=09=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_STATUS, BQ2415X_=
MASK_STAT, BQ2415X_SHIFT_STAT);
+=09=09case BQ2415X_BOOST_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_STATUS, BQ2415X_B=
IT_BOOST);
+=09=09case BQ2415X_FAULT_STATUS:
+=09=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_STATUS, BQ2415X_=
MASK_FAULT, BQ2415X_SHIFT_FAULT);
+
+=09=09case BQ2415X_CHARGE_CURRENT_TERMINATION_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL, BQ2415X_=
BIT_TE);
+=09=09case BQ2415X_CHARGE_CURRENT_TERMINATION_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ24=
15X_BIT_TE);
+=09=09case BQ2415X_CHARGE_CURRENT_TERMINATION_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 0, BQ24=
15X_BIT_TE);
+=09=09case BQ2415X_CHARGER_STATUS:
+=09=09=09ret =3D bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL, BQ2415X=
_BIT_CE);
+=09=09=09if (ret < 0)
+=09=09=09=09return ret;
+=09=09=09else
+=09=09=09=09return ret > 0 ? 0 : 1;
+=09=09case BQ2415X_CHARGER_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 0, BQ24=
15X_BIT_CE);
+=09=09case BQ2415X_CHARGER_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ24=
15X_BIT_CE);
+=09=09case BQ2415X_HIGH_IMPEDANCE_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL, BQ2415X_=
BIT_HZ_MODE);
+=09=09case BQ2415X_HIGH_IMPEDANCE_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ24=
15X_BIT_HZ_MODE);
+=09=09case BQ2415X_HIGH_IMPEDANCE_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 0, BQ24=
15X_BIT_HZ_MODE);
+=09=09case BQ2415X_BOOST_MODE_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL, BQ2415X_=
BIT_OPA_MODE);
+=09=09case BQ2415X_BOOST_MODE_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ24=
15X_BIT_OPA_MODE);
+=09=09case BQ2415X_BOOST_MODE_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 0, BQ24=
15X_BIT_OPA_MODE);
+
+=09=09case BQ2415X_OTG_LEVEL:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_VOLTAGE, BQ2415X_=
BIT_OTG_PL);
+=09=09case BQ2415X_OTG_ACTIVATE_HIGH:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE, 1, BQ24=
15X_BIT_OTG_PL);
+=09=09case BQ2415X_OTG_ACTIVATE_LOW:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE, 0, BQ24=
15X_BIT_OTG_PL);
+=09=09case BQ2415X_OTG_PIN_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_VOLTAGE, BQ2415X_=
BIT_OTG_EN);
+=09=09case BQ2415X_OTG_PIN_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE, 1, BQ24=
15X_BIT_OTG_EN);
+=09=09case BQ2415X_OTG_PIN_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE, 0, BQ24=
15X_BIT_OTG_EN);
+
+=09=09case BQ2415X_VENDER_CODE:
+=09=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_VENDER, BQ2415X_=
MASK_VENDER, BQ2415X_SHIFT_VENDER);
+=09=09case BQ2415X_PART_NUMBER:
+=09=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_VENDER, BQ2415X_=
MASK_PN, BQ2415X_SHIFT_PN);
+=09=09case BQ2415X_REVISION:
+=09=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_VENDER, BQ2415X_=
MASK_REVISION, BQ2415X_SHIFT_REVISION);
+
+=09=09default:
+=09=09=09return -EINVAL;
+=09}
+}
+
+/* global detect chip */
+
+static enum bq2415x_chip bq2415x_detect_chip(struct bq2415x_device *bq=
)
+{
+=09struct i2c_client *client =3D to_i2c_client(bq->dev);
+=09int ret =3D bq2415x_exec_command(bq, BQ2415X_PART_NUMBER);
+=09if (ret < 0)
+=09=09return ret;
+=09if (client->addr =3D=3D 0x6b) {
+=09=09switch (ret) {
+=09=09=09case 0:
+=09=09=09=09if (bq->chip =3D=3D BQ24151A)
+=09=09=09=09=09return bq->chip;
+=09=09=09=09else
+=09=09=09=09=09return BQ24151;
+=09=09=09case 1:
+=09=09=09=09if (bq->chip =3D=3D BQ24150A || bq->chip =3D=3D BQ24152 ||=
 bq->chip =3D=3D BQ24155)
+=09=09=09=09=09return bq->chip;
+=09=09=09=09else
+=09=09=09=09=09return BQ24150;
+=09=09=09case 2:
+=09=09=09=09if (bq->chip =3D=3D BQ24153A)
+=09=09=09=09=09return bq->chip;
+=09=09=09=09else
+=09=09=09=09=09return BQ24153;
+=09=09=09default:
+=09=09=09=09return BQUNKNOWN;
+=09=09}
+=09} else if (client->addr =3D=3D 0x6a) {
+=09=09switch (ret) {
+=09=09=09case 0:
+=09=09=09=09if (bq->chip =3D=3D BQ24156A)
+=09=09=09=09=09return bq->chip;
+=09=09=09=09else
+=09=09=09=09=09return BQ24156;
+=09=09=09case 2:
+=09=09=09=09return BQ24158;
+=09=09=09default:
+=09=09=09=09return BQUNKNOWN;
+=09=09}
+=09}
+=09return BQUNKNOWN;
+}
+
+static char * bq2415x_detect_revision(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_exec_command(bq, BQ2415X_REVISION);
+=09int chip =3D bq2415x_detect_chip(bq);
+=09if (ret < 0 || chip < 0)
+=09=09return bq2415x_rev_name[8];
+
+=09switch (chip) {
+=09=09case BQUNKNOWN:
+=09=09=09return bq2415x_rev_name[8];
+
+=09=09case BQ24150:
+=09=09case BQ24150A:
+=09=09case BQ24151:
+=09=09case BQ24151A:
+=09=09case BQ24152:
+=09=09=09if (ret >=3D 0 && ret <=3D 3)
+=09=09=09=09return bq2415x_rev_name[ret];
+=09=09=09else
+=09=09=09=09return bq2415x_rev_name[8];
+
+=09=09case BQ24153:
+=09=09case BQ24153A:
+=09=09case BQ24156:
+=09=09case BQ24156A:
+=09=09case BQ24158:
+=09=09=09if (ret =3D=3D 3)
+=09=09=09=09return bq2415x_rev_name[0];
+=09=09=09else if (ret =3D=3D 1)
+=09=09=09=09return bq2415x_rev_name[1];
+=09=09=09else
+=09=09=09=09return bq2415x_rev_name[8];
+
+=09=09case BQ24155:
+=09=09=09if (ret =3D=3D 3)
+=09=09=09=09return bq2415x_rev_name[3];
+=09=09=09else
+=09=09=09=09return bq2415x_rev_name[8];
+=09}
+
+=09return bq2415x_rev_name[8];
+}
+
+static int bq2415x_vender_code(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_exec_command(bq, BQ2415X_VENDER_CODE);
+=09if (ret < 0)
+=09=09return 0;
+=09else /* convert to binary */
+=09=09return (ret & 0x1) + ((ret >> 1) & 0x1) * 10 + ((ret >> 2) & 0x1=
) * 100;
+}
+
+/* global other functions */
+
+static void bq2415x_reset_chip(struct bq2415x_device *bq)
+{
+=09bq2415x_i2c_write(bq, BQ2415X_REG_CURRENT, BQ2415X_RESET_CURRENT);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_VOLTAGE, BQ2415X_RESET_VOLTAGE);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_CONTROL, BQ2415X_RESET_CONTROL);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_STATUS, BQ2415X_RESET_STATUS);
+}
+
+static int bq2415x_set_current_limit(struct bq2415x_device *bq, int mA=
)
+{
+=09int val;
+=09if (mA <=3D 100)
+=09=09val =3D 0;
+=09else if (mA <=3D 500)
+=09=09val =3D 1;
+=09else if (mA <=3D 800)
+=09=09val =3D 2;
+=09else
+=09=09val =3D 3;
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CONTROL, val, BQ2415X=
_MASK_LIMIT, BQ2415X_SHIFT_LIMIT);
+}
+
+static int bq2415x_get_current_limit(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CONTROL, BQ2415X_=
MASK_LIMIT, BQ2415X_SHIFT_LIMIT);
+=09if (ret < 0)
+=09=09return ret;
+=09else if (ret =3D=3D 0)
+=09=09return 100;
+=09else if (ret =3D=3D 1)
+=09=09return 500;
+=09else if (ret =3D=3D 2)
+=09=09return 800;
+=09else
+=09=09return 1800;
+}
+
+static int bq2415x_set_weak_battery_voltage(struct bq2415x_device *bq,=
 int mV)
+{
+=09int val =3D mV/100 + (mV%100 > 0 ? 1 : 0) - 34;
+
+=09if (val < 0)
+=09=09val =3D 0;
+=09else if (val > 3)
+=09=09val =3D 3;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CONTROL, val, BQ2415X=
_MASK_VLOWV, BQ2415X_SHIFT_VLOWV);
+}
+
+static int bq2415x_get_weak_battery_voltage(struct bq2415x_device *bq)=

+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CONTROL, BQ2415X_=
MASK_VLOWV, BQ2415X_SHIFT_VLOWV);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 100 * (34 + ret);
+}
+
+static int bq2415x_set_battery_regulation_voltage(struct bq2415x_devic=
e *bq, int mV)
+{
+=09int val =3D (mV/10 + (mV%10 > 0 ? 1 : 0) - 350) / 2;
+
+=09if (val < 0)
+=09=09val =3D 0;
+=09else if (val > 94) /* FIXME: Max is 94 or 122 ? */
+=09=09return -EINVAL;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val, BQ2415X=
_MASK_VO, BQ2415X_SHIFT_VO);
+}
+
+static int bq2415x_get_battery_regulation_voltage(struct bq2415x_devic=
e *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_VOLTAGE, BQ2415X_=
MASK_VO, BQ2415X_SHIFT_VO);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 10 * (350 + 2*ret);
+}
+
+static int bq2415x_set_charge_current_sense_voltage(struct bq2415x_dev=
ice *bq, int mV)
+{
+=09/* TODO */
+=09return -ENOSYS;
+}
+
+static int bq2415x_get_charge_current_sense_voltage(struct bq2415x_dev=
ice *bq)
+{
+=09/* TODO */
+=09return -ENOSYS;
+}
+
+static int bq2415x_set_termination_current_sense_voltage(struct bq2415=
x_device *bq, int mV)
+{
+=09/* TODO */
+=09return -ENOSYS;
+}
+
+static int bq2415x_get_termination_current_sense_voltage(struct bq2415=
x_device *bq)
+{
+=09/* TODO */
+=09return -ENOSYS;
+}
+
+#define bq2415x_set_default_value(bq, value) \
+=09do { \
+=09=09int ret =3D 0; \
+=09=09if (bq->platform_data->value !=3D -1) \
+=09=09=09ret =3D bq2415x_set_##value(bq, bq->platform_data->value); \
+=09=09if (ret < 0) \
+=09=09=09return ret; \
+=09} while (0)
+
+static int bq2415x_set_defaults(struct bq2415x_device *bq)
+{
+=09bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_DISABLE);
+=09bq2415x_exec_command(bq, BQ2415X_CHARGER_DISABLE);
+=09bq2415x_set_default_value(bq, current_limit);
+=09bq2415x_set_default_value(bq, weak_battery_voltage);
+=09bq2415x_set_default_value(bq, battery_regulation_voltage);
+=09bq2415x_set_default_value(bq, charge_current_sense_voltage);
+=09bq2415x_set_default_value(bq, termination_current_sense_voltage);
+=09bq2415x_exec_command(bq, BQ2415X_CHARGE_CURRENT_TERMINATION_ENABLE)=
;
+=09bq2415x_exec_command(bq, BQ2415X_CHARGER_ENABLE);
+=09return 0;
+}
+
+#undef bq2415x_set_default_value
+
+/* power supply */
+
+static enum power_supply_property bq2415x_power_supply_props[] =3D {
+=09/* TODO */
+=09POWER_SUPPLY_PROP_STATUS,
+=09POWER_SUPPLY_PROP_MODEL_NAME,
+};
+
+static void bq2415x_power_supply_set_autotimer(struct bq2415x_device *=
bq, int state)
+{
+=09mutex_lock(&bq2415x_timer_mutex);
+
+=09if (bq->autotimer =3D=3D state) {
+=09=09mutex_unlock(&bq2415x_timer_mutex);
+=09=09return;
+=09}
+
+=09bq->autotimer =3D state;
+
+=09if (state) {
+=09=09schedule_delayed_work(&bq->work, BQ2415X_TIMER_TIMEOUT * HZ);
+=09=09bq2415x_exec_command(bq, BQ2415X_TIMER_RESET);
+=09} else {
+=09=09cancel_delayed_work_sync(&bq->work);
+=09}
+
+=09mutex_unlock(&bq2415x_timer_mutex);
+}
+
+static int bq2415x_power_supply_set_mode(struct bq2415x_device *bq, en=
um bq2415x_mode mode)
+{
+=09int ret =3D 0;
+
+=09switch (mode) {
+
+=09=09case BQ2415X_MODE_NONE: /* N/A */
+=09=09case BQ2415X_MODE_HOST_CHARGER: /* Host/HUB charger */
+=09=09case BQ2415X_MODE_DEDICATED_CHARGER: /* Dedicated charger */
+
+=09=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_DISABLE);=

+=09=09=09if (ret < 0)
+=09=09=09=09break;
+
+=09=09=09if (mode =3D=3D BQ2415X_MODE_NONE) {
+=09=09=09=09dev_info(bq->dev, "mode: N/A\n");
+=09=09=09=09ret =3D bq2415x_set_current_limit(bq, 100);
+=09=09=09} else if (mode =3D=3D BQ2415X_MODE_HOST_CHARGER) {
+=09=09=09=09dev_info(bq->dev, "mode: Host/HUB charger\n");
+=09=09=09=09ret =3D bq2415x_set_current_limit(bq, 500);
+=09=09=09} else {
+=09=09=09=09dev_info(bq->dev, "mode: Dedicated charger\n");
+=09=09=09=09ret =3D bq2415x_set_current_limit(bq, 1800);
+=09=09=09}
+
+=09=09=09if (ret < 0)
+=09=09=09=09break;
+
+=09=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_CHARGER_ENABLE);
+=09=09=09if (ret < 0)
+=09=09=09=09break;
+
+=09=09=09break;
+
+=09=09case BQ2415X_MODE_BOOST: /* Boost mode */
+=09=09=09dev_info(bq->dev, "mode: Boost\n");
+
+=09=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_CHARGER_DISABLE);
+=09=09=09if (ret < 0)
+=09=09=09=09break;
+
+=09=09=09ret =3D bq2415x_set_current_limit(bq, 100);
+=09=09=09if (ret < 0)
+=09=09=09=09break;
+
+=09=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_ENABLE);
+=09=09=09if (ret < 0)
+=09=09=09=09break;
+
+=09=09=09break;
+
+=09}
+
+=09if (ret >=3D 0) {
+=09=09bq->mode =3D mode;
+=09=09ret =3D 0;
+=09}
+
+=09return ret;
+
+}
+
+static void bq2415x_power_supply_set_charger_type(int type, void *data=
)
+{
+=09struct bq2415x_device *bq =3D data;
+
+=09if (!bq)
+=09=09return;
+
+=09if (type =3D=3D 0)
+=09=09bq->charger_mode =3D BQ2415X_MODE_NONE;
+=09else if (type =3D=3D 1)
+=09=09bq->charger_mode =3D BQ2415X_MODE_HOST_CHARGER;
+=09else if (type =3D=3D 2)
+=09=09bq->charger_mode =3D BQ2415X_MODE_DEDICATED_CHARGER;
+=09else
+=09=09return;
+
+=09if (!bq->automode)
+=09=09return;
+
+=09/* TODO: Detect USB Host mode */
+
+=09bq2415x_power_supply_set_mode(bq, bq->charger_mode);
+
+}
+
+static void bq2415x_power_supply_error(struct bq2415x_device *bq, cons=
t char *msg)
+{
+=09dev_err(bq->dev, "%s\n", msg);
+=09bq->automode =3D 0;
+=09bq2415x_power_supply_set_mode(bq, BQ2415X_MODE_NONE);
+=09bq2415x_power_supply_set_autotimer(bq, 0);
+}
+
+static void bq2415x_power_supply_work(struct work_struct *work)
+{
+=09struct bq2415x_device *bq =3D container_of(work, struct bq2415x_dev=
ice, work.work);
+=09int ret, error, boost;
+
+=09if (!bq->autotimer)
+=09=09return;
+
+=09ret =3D bq2415x_exec_command(bq, BQ2415X_TIMER_RESET);
+=09if (ret < 0) {
+=09=09bq2415x_power_supply_error(bq, "Reseting timer failed");
+=09=09return;
+=09}
+
+=09boost =3D bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_STATUS);
+=09if (boost < 0) {
+=09=09bq2415x_power_supply_error(bq, "Unknow error");
+=09=09return;
+=09}
+
+=09error =3D bq2415x_exec_command(bq, BQ2415X_FAULT_STATUS);
+=09if (error < 0) {
+=09=09bq2415x_power_supply_error(bq, "Unknow error");
+=09=09return;
+=09}
+
+=09if (boost) {
+
+=09=09switch (error) {
+=09=09=09case 0: /* No error */
+=09=09=09=09break;
+=09=09=09case 6: /* Timer expired */
+=09=09=09=09dev_info(bq->dev, "Timer expired\n");
+=09=09=09=09break;
+=09=09=09case 3: /* Battery voltage too low */
+=09=09=09=09dev_info(bq->dev, "Battery voltage to low\n");
+=09=09=09=09break;
+
+=09=09=09case 1: /* Overvoltage protection (chip fried) */
+=09=09=09=09bq2415x_power_supply_error(bq, "Overvolatge protection (ch=
ip fried)");
+=09=09=09=09return;
+=09=09=09case 2: /* Overload */
+=09=09=09=09bq2415x_power_supply_error(bq, "Overload");
+=09=09=09=09return;
+=09=09=09case 4: /* Battery overvoltage protection */
+=09=09=09=09bq2415x_power_supply_error(bq, "Battery overvoltage protec=
tion");
+=09=09=09=09return;
+=09=09=09case 5: /* Termal shutdown (too hot) */
+=09=09=09=09bq2415x_power_supply_error(bq, "Termal shutdown (too hot)"=
);
+=09=09=09=09return;
+=09=09=09case 7: /* N/A */
+=09=09=09=09bq2415x_power_supply_error(bq, "Unknow error");
+=09=09=09=09return;
+=09=09}
+
+=09} else {
+
+=09=09switch (error) {
+=09=09=09case 0: /* No error */
+=09=09=09=09break;
+=09=09=09case 2: /* Sleep mode */
+=09=09=09=09dev_info(bq->dev, "Sleep mode\n");
+=09=09=09=09break;
+=09=09=09case 3: /* Poor input source */
+=09=09=09=09dev_info(bq->dev, "Poor input source\n");
+=09=09=09=09break;
+=09=09=09case 6: /* Timer expired */
+=09=09=09=09dev_info(bq->dev, "Timer expired\n");
+=09=09=09=09break;
+=09=09=09case 7: /* No battery */
+=09=09=09=09dev_info(bq->dev, "No battery\n");
+=09=09=09=09break;
+
+=09=09=09case 1: /* Overvoltage protection (chip fried) */
+=09=09=09=09bq2415x_power_supply_error(bq, "Overvolatge protection (ch=
ip fried)");
+=09=09=09=09return;
+=09=09=09case 4: /* Battery overvoltage protection */
+=09=09=09=09bq2415x_power_supply_error(bq, "Battery overvoltage protec=
tion");
+=09=09=09=09return;
+=09=09=09case 5: /* Termal shutdown (too hot) */
+=09=09=09=09bq2415x_power_supply_error(bq, "Termal shutdown (too hot)"=
);
+=09=09=09=09return;
+=09=09}
+
+=09}
+
+=09schedule_delayed_work(&bq->work, BQ2415X_TIMER_TIMEOUT * HZ);
+}
+
+static int bq2415x_power_supply_get_property(struct power_supply *psy,=
 enum power_supply_property psp, union power_supply_propval *val)
+{
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09int ret;
+
+=09switch (psp) {
+=09=09case POWER_SUPPLY_PROP_STATUS:
+=09=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_CHARGE_STATUS);
+=09=09=09if (ret < 0)
+=09=09=09=09return ret;
+=09=09=09else if (ret =3D=3D 0) /* Ready */
+=09=09=09=09val->intval =3D POWER_SUPPLY_STATUS_NOT_CHARGING;
+=09=09=09else if (ret =3D=3D 1) /* Charge in progress */
+=09=09=09=09val->intval =3D POWER_SUPPLY_STATUS_CHARGING;
+=09=09=09else if (ret =3D=3D 2) /* Charge done */
+=09=09=09=09val->intval =3D POWER_SUPPLY_STATUS_FULL;
+=09=09=09else
+=09=09=09=09val->intval =3D POWER_SUPPLY_STATUS_UNKNOWN;
+=09=09=09break;
+=09=09case POWER_SUPPLY_PROP_MODEL_NAME:
+=09=09=09val->strval =3D bq->model;
+=09=09=09break;
+=09=09default:
+=09=09=09return -EINVAL;
+=09}
+=09return 0;
+}
+
+static int bq2415x_power_supply_init(struct bq2415x_device *bq)
+{
+=09int ret;
+
+=09bq->charger.name =3D bq->name;
+=09bq->charger.type =3D POWER_SUPPLY_TYPE_USB;
+=09bq->charger.properties =3D bq2415x_power_supply_props;
+=09bq->charger.num_properties =3D ARRAY_SIZE(bq2415x_power_supply_prop=
s);
+=09bq->charger.get_property =3D bq2415x_power_supply_get_property;
+
+=09ret =3D bq2415x_detect_chip(bq);
+=09if (ret < 0)
+=09=09ret =3D BQUNKNOWN;
+
+=09bq->model =3D kasprintf(GFP_KERNEL, "chip %s, revision %s, vender c=
ode %.3d", bq2415x_chip_name[ret], bq2415x_detect_revision(bq), bq2415x=
_vender_code(bq));
+=09if (!bq->model) {
+=09=09dev_err(bq->dev, "failed to allocate model name\n");
+=09=09return -ENOMEM;
+=09}
+
+=09ret =3D power_supply_register(bq->dev, &bq->charger);
+=09if (ret) {
+=09=09kfree(bq->model);
+=09=09return ret;
+=09}
+
+=09INIT_DELAYED_WORK(&bq->work, bq2415x_power_supply_work);
+
+=09bq2415x_power_supply_set_autotimer(bq, 1);
+=09return 0;
+}
+
+static void bq2415x_power_supply_exit(struct bq2415x_device *bq)
+{
+=09bq->autotimer =3D 0;
+=09bq->automode =3D 0;
+=09cancel_delayed_work_sync(&bq->work);
+=09power_supply_unregister(&bq->charger);
+=09kfree(bq->model);
+}
+
+/* sysfs files */
+
+static ssize_t bq2415x_sysfs_show_status(struct device *dev, struct de=
vice_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09enum bq2415x_command command;
+=09int ret;
+
+=09if (strcmp(attr->attr.name, "otg_status") =3D=3D 0)
+=09=09command =3D BQ2415X_OTG_STATUS;
+=09else if (strcmp(attr->attr.name, "charge_status") =3D=3D 0)
+=09=09command =3D BQ2415X_CHARGE_STATUS;
+=09else if (strcmp(attr->attr.name, "boost_status") =3D=3D 0)
+=09=09command =3D BQ2415X_BOOST_STATUS;
+=09else if (strcmp(attr->attr.name, "fault_status") =3D=3D 0)
+=09=09command =3D BQ2415X_FAULT_STATUS;
+=09else
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_exec_command(bq, command);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t bq2415x_sysfs_set_timer(struct device *dev, struct devi=
ce_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09int ret =3D 0;
+
+=09if (strncmp(buf, "auto", 4) =3D=3D 0)
+=09=09bq2415x_power_supply_set_autotimer(bq, 1);
+=09else if (strncmp(buf, "off", 3) =3D=3D 0)
+=09=09bq2415x_power_supply_set_autotimer(bq, 0);
+=09else
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_TIMER_RESET);
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+static ssize_t bq2415x_sysfs_show_timer(struct device *dev, struct dev=
ice_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+
+=09if (bq->autotimer)
+=09=09return sprintf(buf, "auto\n");
+=09else
+=09=09return sprintf(buf, "off\n");
+}
+
+static ssize_t bq2415x_sysfs_set_mode(struct device *dev, struct devic=
e_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09enum bq2415x_mode mode;
+=09int ret =3D 0;
+
+=09dev_info(bq->dev, "Calling sysfs_set_mode: %s\n", buf);
+
+=09if (strncmp(buf, "auto", 4) =3D=3D 0) {
+=09=09bq->automode =3D 1;
+=09=09mode =3D bq->charger_mode;
+=09} else if (strncmp(buf, "none", 4) =3D=3D 0) {
+=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_NONE;
+=09} else if (strncmp(buf, "host", 4) =3D=3D 0) {
+=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_HOST_CHARGER;
+=09} else if (strncmp(buf, "dedicated", 9) =3D=3D 0) {
+=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_DEDICATED_CHARGER;
+=09} else if (strncmp(buf, "boost", 5) =3D=3D 0) {
+=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_BOOST;
+=09} else if (strncmp(buf, "reset", 5) =3D=3D 0) {
+=09=09bq2415x_reset_chip(bq);
+=09=09bq2415x_set_defaults(bq);
+=09=09bq->automode =3D 1;
+=09=09return count;
+=09} else
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_power_supply_set_mode(bq, mode);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+static ssize_t bq2415x_sysfs_show_mode(struct device *dev, struct devi=
ce_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09ssize_t ret =3D 0;
+
+=09if (bq->automode)
+=09=09ret +=3D sprintf(buf+ret, "auto (");
+
+=09switch (bq->mode) {
+=09=09case BQ2415X_MODE_NONE:
+=09=09=09ret +=3D sprintf(buf+ret, "none");
+=09=09=09break;
+=09=09case BQ2415X_MODE_HOST_CHARGER:
+=09=09=09ret +=3D sprintf(buf+ret, "host");
+=09=09=09break;
+=09=09case BQ2415X_MODE_DEDICATED_CHARGER:
+=09=09=09ret +=3D sprintf(buf+ret, "dedicated");
+=09=09=09break;
+=09=09case BQ2415X_MODE_BOOST:
+=09=09=09ret +=3D sprintf(buf+ret, "boost");
+=09=09=09break;
+=09}
+
+=09if (bq->automode)
+=09=09ret +=3D sprintf(buf+ret, ")");
+
+=09ret +=3D sprintf(buf+ret, "\n");
+=09return ret;
+}
+
+static ssize_t bq2415x_sysfs_print_reg(struct bq2415x_device *bq, u8 r=
eg, char *buf)
+{
+=09int ret =3D bq2415x_i2c_read(bq, reg);
+=09if (ret < 0)
+=09=09return sprintf(buf, "%#.2x=3Derror\n", reg);
+=09else
+=09=09return sprintf(buf, "%#.2x=3D%#.2x\n", reg, ret);
+}
+
+static ssize_t bq2415x_sysfs_show_regdump(struct device *dev, struct d=
evice_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09ssize_t ret =3D 0;
+
+=09ret +=3D bq2415x_sysfs_print_reg(bq, BQ2415X_REG_STATUS, buf+ret);
+=09ret +=3D bq2415x_sysfs_print_reg(bq, BQ2415X_REG_CONTROL, buf+ret);=

+=09ret +=3D bq2415x_sysfs_print_reg(bq, BQ2415X_REG_VOLTAGE, buf+ret);=

+=09ret +=3D bq2415x_sysfs_print_reg(bq, BQ2415X_REG_VENDER, buf+ret);
+=09ret +=3D bq2415x_sysfs_print_reg(bq, BQ2415X_REG_CURRENT, buf+ret);=

+=09return ret;
+}
+
+/* Current & Volatage settings */
+
+static ssize_t bq2415x_sysfs_set_limit(struct device *dev, struct devi=
ce_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09int ret;
+=09long val;
+
+=09if (strict_strtol(buf, 10, &val) < 0)
+=09=09return -EINVAL;
+
+=09if (strcmp(attr->attr.name, "current_limit") =3D=3D 0)
+=09=09ret =3D bq2415x_set_current_limit(bq, val);
+=09else if (strcmp(attr->attr.name, "weak_battery_voltage") =3D=3D 0)
+=09=09ret =3D bq2415x_set_weak_battery_voltage(bq, val);
+=09else if (strcmp(attr->attr.name, "battery_regulation_voltage") =3D=3D=
 0)
+=09=09ret =3D bq2415x_set_battery_regulation_voltage(bq, val);
+=09else if (strcmp(attr->attr.name, "charge_current_sense_voltage") =3D=
=3D 0)
+=09=09ret =3D bq2415x_set_charge_current_sense_voltage(bq, val);
+=09else if (strcmp(attr->attr.name, "termination_current_sense_voltage=
") =3D=3D 0)
+=09=09ret =3D bq2415x_set_termination_current_sense_voltage(bq, val);
+=09else
+=09=09return -EINVAL;
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+static ssize_t bq2415x_sysfs_show_limit(struct device *dev, struct dev=
ice_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09int ret;
+
+=09if (strcmp(attr->attr.name, "current_limit") =3D=3D 0)
+=09=09ret =3D bq2415x_get_current_limit(bq);
+=09else if (strcmp(attr->attr.name, "weak_battery_voltage") =3D=3D 0)
+=09=09ret =3D bq2415x_get_weak_battery_voltage(bq);
+=09else if (strcmp(attr->attr.name, "battery_regulation_voltage") =3D=3D=
 0)
+=09=09ret =3D bq2415x_get_battery_regulation_voltage(bq);
+=09else if (strcmp(attr->attr.name, "charge_current_sense_voltage") =3D=
=3D 0)
+=09=09ret =3D bq2415x_get_charge_current_sense_voltage(bq);
+=09else if (strcmp(attr->attr.name, "charge_current_sense_voltage") =3D=
=3D 0)
+=09=09ret =3D bq2415x_get_termination_current_sense_voltage(bq);
+=09else
+=09=09return -EINVAL;
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return sprintf(buf, "%d\n", ret);
+}
+
+static ssize_t bq2415x_sysfs_set_enable(struct device *dev, struct dev=
ice_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09enum bq2415x_command command;
+=09long val;
+=09int ret;
+
+=09if (strict_strtol(buf, 10, &val) < 0)
+=09=09return -EINVAL;
+
+=09if (strcmp(attr->attr.name, "charge_current_termination_enable") =3D=
=3D 0)
+=09=09command =3D val ? BQ2415X_CHARGE_CURRENT_TERMINATION_ENABLE : BQ=
2415X_CHARGE_CURRENT_TERMINATION_DISABLE;
+=09else if (strcmp(attr->attr.name, "high_impedance_enable") =3D=3D 0)=

+=09=09command =3D val ? BQ2415X_HIGH_IMPEDANCE_ENABLE : BQ2415X_HIGH_I=
MPEDANCE_DISABLE;
+=09else if (strcmp(attr->attr.name, "otg_pin_enable") =3D=3D 0)
+=09=09command =3D val ? BQ2415X_OTG_PIN_ENABLE : BQ2415X_OTG_PIN_DISAB=
LE;
+=09else if (strcmp(attr->attr.name, "stat_pin_enable") =3D=3D 0)
+=09=09command =3D val ? BQ2415X_STAT_PIN_ENABLE : BQ2415X_STAT_PIN_DIS=
ABLE;
+=09else
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_exec_command(bq, command);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+static ssize_t bq2415x_sysfs_show_enable(struct device *dev, struct de=
vice_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09enum bq2415x_command command;
+=09int ret;
+
+=09if (strcmp(attr->attr.name, "charge_current_termination_enable") =3D=
=3D 0)
+=09=09command =3D BQ2415X_CHARGE_CURRENT_TERMINATION_STATUS;
+=09else if (strcmp(attr->attr.name, "high_impedance_enable") =3D=3D 0)=

+=09=09command =3D BQ2415X_HIGH_IMPEDANCE_STATUS;
+=09else if (strcmp(attr->attr.name, "otg_pin_enable") =3D=3D 0)
+=09=09command =3D BQ2415X_OTG_PIN_STATUS;
+=09else if (strcmp(attr->attr.name, "stat_pin_enable") =3D=3D 0)
+=09=09command =3D BQ2415X_STAT_PIN_STATUS;
+=09else
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_exec_command(bq, command);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return sprintf(buf, "%d\n", ret);
+}
+
+/* TODO: Add other sysfs entries */
+
+static DEVICE_ATTR(current_limit, S_IWUSR | S_IRUGO, bq2415x_sysfs_sho=
w_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(weak_battery_voltage, S_IWUSR | S_IRUGO, bq2415x_sy=
sfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(battery_regulation_voltage, S_IWUSR | S_IRUGO, bq24=
15x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(charge_current_sense_voltage, S_IWUSR | S_IRUGO, bq=
2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(termination_current_sense_voltage, S_IWUSR | S_IRUG=
O, bq2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+
+static DEVICE_ATTR(charge_current_termination_enable, S_IWUSR | S_IRUG=
O, bq2415x_sysfs_show_enable, bq2415x_sysfs_set_enable);
+static DEVICE_ATTR(high_impedance_enable, S_IWUSR | S_IRUGO, bq2415x_s=
ysfs_show_enable, bq2415x_sysfs_set_enable);
+static DEVICE_ATTR(otg_pin_enable, S_IWUSR | S_IRUGO, bq2415x_sysfs_sh=
ow_enable, bq2415x_sysfs_set_enable);
+static DEVICE_ATTR(stat_pin_enable, S_IWUSR | S_IRUGO, bq2415x_sysfs_s=
how_enable, bq2415x_sysfs_set_enable);
+
+static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, bq2415x_sysfs_show_mode, b=
q2415x_sysfs_set_mode);
+static DEVICE_ATTR(timer, S_IWUSR | S_IRUGO, bq2415x_sysfs_show_timer,=
 bq2415x_sysfs_set_timer);
+
+static DEVICE_ATTR(regdump, S_IRUGO, bq2415x_sysfs_show_regdump, NULL)=
;
+
+static DEVICE_ATTR(otg_status, S_IRUGO, bq2415x_sysfs_show_status, NUL=
L);
+static DEVICE_ATTR(charge_status, S_IRUGO, bq2415x_sysfs_show_status, =
NULL);
+static DEVICE_ATTR(boost_status, S_IRUGO, bq2415x_sysfs_show_status, N=
ULL);
+static DEVICE_ATTR(fault_status, S_IRUGO, bq2415x_sysfs_show_status, N=
ULL);
+
+static struct attribute *bq2415x_sysfs_attributes[] =3D {
+=09&dev_attr_current_limit.attr,
+=09&dev_attr_weak_battery_voltage.attr,
+=09&dev_attr_battery_regulation_voltage.attr,
+=09&dev_attr_charge_current_sense_voltage.attr,
+=09&dev_attr_termination_current_sense_voltage.attr,
+
+=09&dev_attr_charge_current_termination_enable.attr,
+=09&dev_attr_high_impedance_enable.attr,
+=09&dev_attr_otg_pin_enable.attr,
+=09&dev_attr_stat_pin_enable.attr,
+
+=09&dev_attr_mode.attr,
+=09&dev_attr_timer.attr,
+
+=09&dev_attr_regdump.attr,
+
+=09&dev_attr_otg_status.attr,
+=09&dev_attr_charge_status.attr,
+=09&dev_attr_boost_status.attr,
+=09&dev_attr_fault_status.attr,
+=09NULL,
+};
+
+static const struct attribute_group bq2415x_sysfs_attr_group =3D {
+=09.attrs =3D bq2415x_sysfs_attributes,
+};
+
+static int bq2415x_sysfs_init(struct bq2415x_device *bq)
+{
+=09return sysfs_create_group(&bq->charger.dev->kobj, &bq2415x_sysfs_at=
tr_group);
+}
+
+static void bq2415x_sysfs_exit(struct bq2415x_device *bq)
+{
+=09sysfs_remove_group(&bq->charger.dev->kobj, &bq2415x_sysfs_attr_grou=
p);
+}
+
+/* bq2415x register */
+
+static int bq2415x_probe(struct i2c_client *client, const struct i2c_d=
evice_id *id)
+{
+=09int ret;
+=09int num;
+=09char *name;
+=09struct bq2415x_device *bq;
+
+=09if (!client->dev.platform_data) {
+=09=09dev_err(&client->dev, "platform data not set\n");
+=09=09return -ENODEV;
+=09}
+
+=09/* Get new ID for the new device */
+=09ret =3D idr_pre_get(&bq2415x_id, GFP_KERNEL);
+=09if (ret =3D=3D 0)
+=09=09return -ENOMEM;
+
+=09mutex_lock(&bq2415x_id_mutex);
+=09ret =3D idr_get_new(&bq2415x_id, client, &num);
+=09mutex_unlock(&bq2415x_id_mutex);
+
+=09if (ret < 0)
+=09=09return ret;
+
+=09name =3D kasprintf(GFP_KERNEL, "%s-%d", id->name, num);
+=09if (!name) {
+=09=09dev_err(&client->dev, "failed to allocate device name\n");
+=09=09ret =3D -ENOMEM;
+=09=09goto error_1;
+=09}
+
+=09bq =3D kzalloc(sizeof(*bq), GFP_KERNEL);
+=09if (!bq) {
+=09=09dev_err(&client->dev, "failed to allocate device data\n");
+=09=09ret =3D -ENOMEM;
+=09=09goto error_2;
+=09}
+
+=09i2c_set_clientdata(client, bq);
+
+=09bq->id =3D num;
+=09bq->dev =3D &client->dev;
+=09bq->chip =3D id->driver_data;
+=09bq->name =3D name;
+=09bq->platform_data =3D client->dev.platform_data;
+=09bq->mode =3D BQ2415X_MODE_NONE;
+=09bq->charger_mode =3D BQ2415X_MODE_NONE;
+=09bq->autotimer =3D 0;
+=09bq->automode =3D 1;
+
+=09bq2415x_reset_chip(bq);
+
+=09ret =3D bq2415x_power_supply_init(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to register power supply: %d\n", ret);
+=09=09goto error_3;
+=09}
+
+=09ret =3D bq2415x_sysfs_init(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to create sysfs entries: %d\n", ret);
+=09=09goto error_4;
+=09}
+
+=09ret =3D bq2415x_set_defaults(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to set default values: %d\n", ret);
+=09=09goto error_5;
+=09}
+
+=09if (bq->platform_data->set_charger_type_hook)
+=09=09bq->platform_data->set_charger_type_hook(bq2415x_power_supply_se=
t_charger_type, bq);
+=09else
+=09=09bq->automode =3D 0;
+
+=09dev_info(bq->dev, "driver registred\n");
+=09return 0;
+
+error_5:
+=09bq2415x_sysfs_exit(bq);
+error_4:
+=09bq2415x_power_supply_exit(bq);
+error_3:
+=09kfree(bq);
+error_2:
+=09kfree(name);
+error_1:
+=09mutex_lock(&bq2415x_id_mutex);
+=09idr_remove(&bq2415x_id, num);
+=09mutex_unlock(&bq2415x_id_mutex);
+
+=09return ret;
+}
+
+/* bq2415x unregister */
+
+static int bq2415x_remove(struct i2c_client *client)
+{
+=09struct bq2415x_device *bq =3D i2c_get_clientdata(client);
+
+=09if (bq->platform_data->set_charger_type_hook)
+=09=09bq->platform_data->set_charger_type_hook(NULL, NULL);
+
+=09bq2415x_sysfs_exit(bq);
+=09bq2415x_power_supply_exit(bq);
+
+=09bq2415x_reset_chip(bq);
+
+=09mutex_lock(&bq2415x_id_mutex);
+=09idr_remove(&bq2415x_id, bq->id);
+=09mutex_unlock(&bq2415x_id_mutex);
+
+=09dev_info(bq->dev, "driver unregistred\n");
+
+=09kfree(bq->name);
+=09kfree(bq);
+
+=09return 0;
+}
+
+static const struct i2c_device_id bq2415x_i2c_id_table[] =3D {
+=09{ "bq2415x", BQUNKNOWN },
+=09{ "bq24150", BQ24150 },
+=09{ "bq24150a", BQ24150A },
+=09{ "bq24151", BQ24151 },
+=09{ "bq24151a", BQ24151A },
+=09{ "bq24152", BQ24152 },
+=09{ "bq24153", BQ24153 },
+=09{ "bq24153a", BQ24153A },
+=09{ "bq24155", BQ24155 },
+=09{ "bq24156", BQ24156 },
+=09{ "bq24156a", BQ24156A },
+=09{ "bq24158", BQ24158 },
+=09{},
+};
+MODULE_DEVICE_TABLE(i2c, bq2415x_i2c_id_table);
+
+static struct i2c_driver bq2415x_driver =3D {
+=09.driver =3D {
+=09=09.name =3D "bq2415x-charger",
+=09},
+=09.probe =3D bq2415x_probe,
+=09.remove =3D bq2415x_remove,
+=09.id_table =3D bq2415x_i2c_id_table,
+};
+
+/* BEGIN: Temporary RX51 hack TODO: move to board-rx51.c */
+static void *rx51_charger_hook_data =3D NULL;
+static void (*rx51_charger_hook)(int type, void *data) =3D NULL;
+static void rx51_charger_set_hook(void *hook, void *data)
+{
+=09rx51_charger_hook =3D hook;
+=09rx51_charger_hook_data =3D data;
+}
+/*static void rx51_charger_set_power(bool on)
+{*/
+=09/* gpio_set_value(RX51_USB_TRANSCEIVER_RST_GPIO, on); */
+/*}
+static void rx51_charger_set_type(int type)
+{
+=09if (rx51_charger_hook)
+=09=09rx51_charger_hook(type, rx51_charger_hook_data);
+}
+static struct isp1704_charger_data rx51_charger_data =3D {
+=09.set_power=09=3D rx51_charger_set_power,
+=09.set_type=09=3D rx51_charger_set_type,
+};
+static struct platform_device rx51_charger_device =3D {
+=09.name=09=3D "isp1704_charger",
+=09.dev=09=3D {
+=09=09.platform_data =3D &rx51_charger_data,
+=09},
+};*/
+
+static struct bq2415x_platform_data rx51_platform_data =3D {
+=09.current_limit =3D 100, /* mA */
+=09.weak_battery_voltage =3D 3400, /* mV */
+=09.battery_regulation_voltage =3D 4200, /* mV */
+=09.charge_current_sense_voltage =3D -1, /* TODO */
+=09.termination_current_sense_voltage =3D -1, /* TODO */
+=09.set_charger_type_hook =3D &rx51_charger_set_hook,
+};
+static struct i2c_board_info rx51_board_info =3D {
+=09I2C_BOARD_INFO("bq24150", 0x6b),
+=09.platform_data =3D &rx51_platform_data,
+};
+static struct i2c_client *client;
+/* END */
+
+static int __init bq2415x_init(void)
+{
+=09/* BEGIN: Temporary RX51 hack TODO: move to board-rx51.c */
+=09/*platform_device_register(&rx51_charger_device);*/
+=09client =3D i2c_new_device(i2c_get_adapter(2), &rx51_board_info);
+=09/* END */
+
+=09return i2c_add_driver(&bq2415x_driver);
+}
+module_init(bq2415x_init);
+
+static void __exit bq2415x_exit(void)
+{
+=09/* BEGIN: Temporary RX51 hack TODO: move to board-rx51.c */
+=09/*platform_device_unregister(&rx51_charger_device);*/
+=09i2c_unregister_device(client);
+=09/* END */
+
+=09i2c_del_driver(&bq2415x_driver);
+}
+module_exit(bq2415x_exit);
+
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_DESCRIPTION("bq2415x charger driver");
+MODULE_LICENSE("GPL");
--- /dev/null=092012-01-26 12:32:59.572022923 +0100
+++ bq2415x_charger.h=092011-12-09 22:41:06.130971667 +0100
@@ -0,0 +1,32 @@
+/*
+    bq2415x_charger.h - bq2415x charger driver
+    Copyright (C) 2011  Pali Roh=C3=A1r <pali.rohar@gmail.com>
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
+#ifndef BQ2415X_CHARGER_H
+#define BQ2415X_CHARGER_H
+
+struct bq2415x_platform_data {
+=09int current_limit;
+=09int weak_battery_voltage;
+=09int battery_regulation_voltage;
+=09int charge_current_sense_voltage;
+=09int termination_current_sense_voltage;
+=09void (*set_charger_type_hook)(void *hook, void *data);
+};
+
+#endif

--nextPart3522216.fjNTXqfEpy--

--nextPart2224598.Ja3zkPYUcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk8iDqsACgkQi/DJPQPkQ1LOAACgnRMCd7v/xH5HqXs6o4iSOUWj
4YAAoJVPV6B2p375QVXT58iNeIsm16NJ
=g5jL
-----END PGP SIGNATURE-----

--nextPart2224598.Ja3zkPYUcS--

