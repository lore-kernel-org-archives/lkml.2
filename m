Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2KBTSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:18:23 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54746 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab2KBTSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:18:17 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Sebastian Reichel <sre@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        David Woodhouse <dwmw2@infradead.org>,
        Aliaksei Katovich <aliaksei.katovich@gmail.com>
Subject: [PATCH] bq2415x charger driver
Date: Fri, 02 Nov 2012 20:18:11 +0100
Message-ID: <1391088.VOCN5mxOBg@pali>
User-Agent: KMail/4.9.2 (Linux/3.5.0-18-generic; KDE/4.9.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart7439548.TvAAzhPPP6"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart7439548.TvAAzhPPP6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hello,

I'm sending new version of bq2415x charger driver which is needed
for example on Nokia N900 for charging battery. Driver is part of
open source project to replace proprietary battery management.
Driver is based on old RFC version which I sent months ago.

power_supply: Add bq2415x charger driver

This patch implements driver for bq2415x charging chips.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>

--- /dev/null
+++ linux/drivers/power/bq2415x_charger.c
@@ -0,0 +1,1644 @@
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
+#include <linux/kernel.h>
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
+#include <linux/power/bq2415x_charger.h>
+
+/* timeout for resetting chip timer */
+#define BQ2415X_TIMER_TIMEOUT=09=0910
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
+#define BQ2415X_MASK_VO=09=09(BIT(2)|BIT(3)|BIT(4)|BIT(5)|BIT(6)|BIT(7=
))
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
+#define BQ2415X_MASK_RESET=09=09BIT(7)
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
+=09BQ2415X_CHARGE_TERMINATION_STATUS,
+=09BQ2415X_CHARGE_TERMINATION_ENABLE,
+=09BQ2415X_CHARGE_TERMINATION_DISABLE,
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
+struct bq2415x_device {
+=09struct device *dev;
+=09struct bq2415x_platform_data init_data;
+=09struct power_supply charger;
+=09struct delayed_work work;
+=09enum bq2415x_mode reported_mode;/* mode reported by hook function *=
/
+=09enum bq2415x_mode mode;=09=09/* current configured mode */
+=09enum bq2415x_chip chip;
+=09const char *timer_error;
+=09char *model;
+=09char *name;
+=09int autotimer;=09/* 1 - if driver automatically reset timer, 0 - no=
t */
+=09int automode;=09/* 1 - enabled, 0 - disabled; -1 - not supported */=

+=09int id;
+};
+
+/* each registered chip must have unique id */
+static DEFINE_IDR(bq2415x_id);
+
+static DEFINE_MUTEX(bq2415x_id_mutex);
+static DEFINE_MUTEX(bq2415x_timer_mutex);
+static DEFINE_MUTEX(bq2415x_i2c_mutex);
+
+/**** i2c read functions ****/
+
+/* read value from register */
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
+/* read value from register, apply mask and right shift it */
+static int bq2415x_i2c_read_mask(struct bq2415x_device *bq, u8 reg,
+=09=09=09=09u8 mask, u8 shift)
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
+/* read value from register and return one specified bit */
+static int bq2415x_i2c_read_bit(struct bq2415x_device *bq, u8 reg, u8 =
bit)
+{
+=09if (bit > 8)
+=09=09return -EINVAL;
+=09else
+=09=09return bq2415x_i2c_read_mask(bq, reg, BIT(bit), bit);
+}
+
+/**** i2c write functions ****/
+
+/* write value to register */
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
+/* read value from register, change it with mask left shifted and writ=
e back */
+static int bq2415x_i2c_write_mask(struct bq2415x_device *bq, u8 reg, u=
8 val,
+=09=09=09=09u8 mask, u8 shift)
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
+/* change only one bit in register */
+static int bq2415x_i2c_write_bit(struct bq2415x_device *bq, u8 reg,
+=09=09=09=09bool val, u8 bit)
+{
+=09if (bit > 8)
+=09=09return -EINVAL;
+=09else
+=09=09return bq2415x_i2c_write_mask(bq, reg, val, BIT(bit), bit);
+}
+
+/**** global functions ****/
+
+/* exec command function */
+static int bq2415x_exec_command(struct bq2415x_device *bq,
+=09=09=09=09enum bq2415x_command command)
+{
+=09int ret;
+=09switch (command) {
+=09case BQ2415X_TIMER_RESET:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_STATUS,
+=09=09=09=091, BQ2415X_BIT_TMR_RST);
+=09case BQ2415X_OTG_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_STATUS,
+=09=09=09=09BQ2415X_BIT_OTG);
+=09case BQ2415X_STAT_PIN_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_STATUS,
+=09=09=09=09BQ2415X_BIT_EN_STAT);
+=09case BQ2415X_STAT_PIN_ENABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_STATUS, 1,
+=09=09=09=09BQ2415X_BIT_EN_STAT);
+=09case BQ2415X_STAT_PIN_DISABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_STATUS, 0,
+=09=09=09=09BQ2415X_BIT_EN_STAT);
+=09case BQ2415X_CHARGE_STATUS:
+=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_STATUS,
+=09=09=09=09BQ2415X_MASK_STAT, BQ2415X_SHIFT_STAT);
+=09case BQ2415X_BOOST_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_STATUS,
+=09=09=09=09BQ2415X_BIT_BOOST);
+=09case BQ2415X_FAULT_STATUS:
+=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_STATUS,
+=09=09=09BQ2415X_MASK_FAULT, BQ2415X_SHIFT_FAULT);
+
+=09case BQ2415X_CHARGE_TERMINATION_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=09BQ2415X_BIT_TE);
+=09case BQ2415X_CHARGE_TERMINATION_ENABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=091, BQ2415X_BIT_TE);
+=09case BQ2415X_CHARGE_TERMINATION_DISABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=090, BQ2415X_BIT_TE);
+=09case BQ2415X_CHARGER_STATUS:
+=09=09ret =3D bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09BQ2415X_BIT_CE);
+=09=09if (ret < 0)
+=09=09=09return ret;
+=09=09else
+=09=09=09return ret > 0 ? 0 : 1;
+=09case BQ2415X_CHARGER_ENABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=090, BQ2415X_BIT_CE);
+=09case BQ2415X_CHARGER_DISABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=091, BQ2415X_BIT_CE);
+=09case BQ2415X_HIGH_IMPEDANCE_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=09BQ2415X_BIT_HZ_MODE);
+=09case BQ2415X_HIGH_IMPEDANCE_ENABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=091, BQ2415X_BIT_HZ_MODE);
+=09case BQ2415X_HIGH_IMPEDANCE_DISABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=090, BQ2415X_BIT_HZ_MODE);
+=09case BQ2415X_BOOST_MODE_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=09BQ2415X_BIT_OPA_MODE);
+=09case BQ2415X_BOOST_MODE_ENABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=091, BQ2415X_BIT_OPA_MODE);
+=09case BQ2415X_BOOST_MODE_DISABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL,
+=09=09=09=090, BQ2415X_BIT_OPA_MODE);
+
+=09case BQ2415X_OTG_LEVEL:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09=09BQ2415X_BIT_OTG_PL);
+=09case BQ2415X_OTG_ACTIVATE_HIGH:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09=091, BQ2415X_BIT_OTG_PL);
+=09case BQ2415X_OTG_ACTIVATE_LOW:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09=090, BQ2415X_BIT_OTG_PL);
+=09case BQ2415X_OTG_PIN_STATUS:
+=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09=09BQ2415X_BIT_OTG_EN);
+=09case BQ2415X_OTG_PIN_ENABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09=091, BQ2415X_BIT_OTG_EN);
+=09case BQ2415X_OTG_PIN_DISABLE:
+=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09=090, BQ2415X_BIT_OTG_EN);
+
+=09case BQ2415X_VENDER_CODE:
+=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_VENDER,
+=09=09=09BQ2415X_MASK_VENDER, BQ2415X_SHIFT_VENDER);
+=09case BQ2415X_PART_NUMBER:
+=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_VENDER,
+=09=09=09=09BQ2415X_MASK_PN, BQ2415X_SHIFT_PN);
+=09case BQ2415X_REVISION:
+=09=09return bq2415x_i2c_read_mask(bq, BQ2415X_REG_VENDER,
+=09=09=09BQ2415X_MASK_REVISION, BQ2415X_SHIFT_REVISION);
+
+=09default:
+=09=09return -EINVAL;
+=09}
+}
+
+/* detect chip type */
+static enum bq2415x_chip bq2415x_detect_chip(struct bq2415x_device *bq=
)
+{
+=09struct i2c_client *client =3D to_i2c_client(bq->dev);
+=09int ret =3D bq2415x_exec_command(bq, BQ2415X_PART_NUMBER);
+
+=09if (ret < 0)
+=09=09return ret;
+
+=09switch (client->addr) {
+=09case 0x6b:
+=09=09switch (ret) {
+=09=09case 0:
+=09=09=09if (bq->chip =3D=3D BQ24151A)
+=09=09=09=09return bq->chip;
+=09=09=09else
+=09=09=09=09return BQ24151;
+=09=09case 1:
+=09=09=09if (bq->chip =3D=3D BQ24150A ||
+=09=09=09=09bq->chip =3D=3D BQ24152 ||
+=09=09=09=09bq->chip =3D=3D BQ24155)
+=09=09=09=09return bq->chip;
+=09=09=09else
+=09=09=09=09return BQ24150;
+=09=09case 2:
+=09=09=09if (bq->chip =3D=3D BQ24153A)
+=09=09=09=09return bq->chip;
+=09=09=09else
+=09=09=09=09return BQ24153;
+=09=09default:
+=09=09=09return BQUNKNOWN;
+=09=09}
+=09=09break;
+
+=09case 0x6a:
+=09=09switch (ret) {
+=09=09case 0:
+=09=09=09if (bq->chip =3D=3D BQ24156A)
+=09=09=09=09return bq->chip;
+=09=09=09else
+=09=09=09=09return BQ24156;
+=09=09case 2:
+=09=09=09return BQ24158;
+=09=09default:
+=09=09=09return BQUNKNOWN;
+=09=09}
+=09=09break;
+=09}
+
+=09return BQUNKNOWN;
+}
+
+/* detect chip revision */
+static int bq2415x_detect_revision(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_exec_command(bq, BQ2415X_REVISION);
+=09int chip =3D bq2415x_detect_chip(bq);
+=09if (ret < 0 || chip < 0)
+=09=09return -1;
+
+=09switch (chip) {
+=09case BQ24150:
+=09case BQ24150A:
+=09case BQ24151:
+=09case BQ24151A:
+=09case BQ24152:
+=09=09if (ret >=3D 0 && ret <=3D 3)
+=09=09=09return ret;
+=09=09else
+=09=09=09return -1;
+
+=09case BQ24153:
+=09case BQ24153A:
+=09case BQ24156:
+=09case BQ24156A:
+=09case BQ24158:
+=09=09if (ret =3D=3D 3)
+=09=09=09return 0;
+=09=09else if (ret =3D=3D 1)
+=09=09=09return 1;
+=09=09else
+=09=09=09return -1;
+
+=09case BQ24155:
+=09=09if (ret =3D=3D 3)
+=09=09=09return 3;
+=09=09else
+=09=09=09return -1;
+
+=09case BQUNKNOWN:
+=09=09return -1;
+=09}
+
+=09return -1;
+}
+
+/* return chip vender code */
+static int bq2415x_get_vender_code(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_exec_command(bq, BQ2415X_VENDER_CODE);
+=09if (ret < 0)
+=09=09return 0;
+=09else /* convert to binary */
+=09=09return (ret & 0x1) +
+=09=09=09((ret >> 1) & 0x1) * 10 +
+=09=09=09((ret >> 2) & 0x1) * 100;
+}
+
+/* reset all chip registers to default state */
+static void bq2415x_reset_chip(struct bq2415x_device *bq)
+{
+=09bq2415x_i2c_write(bq, BQ2415X_REG_CURRENT, BQ2415X_RESET_CURRENT);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_VOLTAGE, BQ2415X_RESET_VOLTAGE);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_CONTROL, BQ2415X_RESET_CONTROL);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_STATUS, BQ2415X_RESET_STATUS);
+=09bq->timer_error =3D NULL;
+}
+
+/**** properties functions ****/
+
+/* set current limit in mA */
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
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CONTROL, val,
+=09=09=09BQ2415X_MASK_LIMIT, BQ2415X_SHIFT_LIMIT);
+}
+
+/* get current limit in mA */
+static int bq2415x_get_current_limit(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CONTROL,
+=09=09=09BQ2415X_MASK_LIMIT, BQ2415X_SHIFT_LIMIT);
+=09if (ret < 0)
+=09=09return ret;
+=09else if (ret =3D=3D 0)
+=09=09return 100;
+=09else if (ret =3D=3D 1)
+=09=09return 500;
+=09else if (ret =3D=3D 2)
+=09=09return 800;
+=09else if (ret =3D=3D 3)
+=09=09return 1800;
+=09else
+=09=09return -EINVAL;
+}
+
+/* set weak battery voltage in mV */
+static int bq2415x_set_weak_battery_voltage(struct bq2415x_device *bq,=
 int mV)
+{
+=09/* round to 100mV */
+=09int val;
+=09if (mV <=3D 3400 + 50)
+=09=09val =3D 0;
+=09else if (mV <=3D 3500 + 50)
+=09=09val =3D 1;
+=09else if (mV <=3D 3600 + 50)
+=09=09val =3D 2;
+=09else
+=09=09val =3D 3;
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CONTROL, val,
+=09=09=09BQ2415X_MASK_VLOWV, BQ2415X_SHIFT_VLOWV);
+}
+
+/* get weak battery voltage in mV */
+static int bq2415x_get_weak_battery_voltage(struct bq2415x_device *bq)=

+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CONTROL,
+=09=09=09BQ2415X_MASK_VLOWV, BQ2415X_SHIFT_VLOWV);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 100 * (34 + ret);
+}
+
+/* set battery regulation voltage in mV */
+static int bq2415x_set_battery_regulation_voltage(struct bq2415x_devic=
e *bq,
+=09=09=09=09=09=09int mV)
+{
+=09int val =3D (mV/10 - 350) / 2;
+
+=09if (val < 0)
+=09=09val =3D 0;
+=09else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max value ? */
+=09=09return -EINVAL;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,
+=09=09=09BQ2415X_MASK_VO, BQ2415X_SHIFT_VO);
+}
+
+/* get battery regulation voltage in mV */
+static int bq2415x_get_battery_regulation_voltage(struct bq2415x_devic=
e *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_VOLTAGE,
+=09=09=09BQ2415X_MASK_VO, BQ2415X_SHIFT_VO);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 10 * (350 + 2*ret);
+}
+
+/* set charge current in mA (platform data must provide resistor sense=
) */
+static int bq2415x_set_charge_current(struct bq2415x_device *bq, int m=
A)
+{
+=09int val;
+=09if (bq->init_data.resistor_sense <=3D 0)
+=09=09return -ENOSYS;
+
+=09val =3D (mA * bq->init_data.resistor_sense - 37400) / 6800;
+
+=09if (val < 0)
+=09=09val =3D 0;
+=09else if (val > 7)
+=09=09val =3D 7;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CURRENT, val,
+=09=09=09BQ2415X_MASK_VI_CHRG | BQ2415X_MASK_RESET,
+=09=09=09BQ2415X_SHIFT_VI_CHRG);
+}
+
+/* get charge current in mA (platform data must provide resistor sense=
) */
+static int bq2415x_get_charge_current(struct bq2415x_device *bq)
+{
+=09int ret;
+=09if (bq->init_data.resistor_sense <=3D 0)
+=09=09return -ENOSYS;
+
+=09ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CURRENT,
+=09=09=09BQ2415X_MASK_VI_CHRG, BQ2415X_SHIFT_VI_CHRG);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return (37400 + 6800*ret) / bq->init_data.resistor_sense;
+}
+
+/* set termination current in mA (platform data must provide resistor =
sense) */
+static int bq2415x_set_termination_current(struct bq2415x_device *bq, =
int mA)
+{
+=09int val;
+=09if (bq->init_data.resistor_sense <=3D 0)
+=09=09return -ENOSYS;
+
+=09val =3D (mA * bq->init_data.resistor_sense - 3400) / 3400;
+
+=09if (val < 0)
+=09=09val =3D 0;
+=09else if (val > 7)
+=09=09val =3D 7;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CURRENT, val,
+=09=09=09BQ2415X_MASK_VI_TERM | BQ2415X_MASK_RESET,
+=09=09=09BQ2415X_SHIFT_VI_TERM);
+}
+
+/* get termination current in mA (platform data must provide resistor =
sense) */
+static int bq2415x_get_termination_current(struct bq2415x_device *bq)
+{
+=09int ret;
+=09if (bq->init_data.resistor_sense <=3D 0)
+=09=09return -ENOSYS;
+
+=09ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CURRENT,
+=09=09=09BQ2415X_MASK_VI_TERM, BQ2415X_SHIFT_VI_TERM);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return (3400 + 3400*ret) / bq->init_data.resistor_sense;
+}
+
+/* set default value of property */
+#define bq2415x_set_default_value(bq, prop) \
+=09do { \
+=09=09int ret =3D 0; \
+=09=09if (bq->init_data.prop !=3D -1) \
+=09=09=09ret =3D bq2415x_set_##prop(bq, bq->init_data.prop); \
+=09=09if (ret < 0) \
+=09=09=09return ret; \
+=09} while (0)
+
+/* set default values of all properties */
+static int bq2415x_set_defaults(struct bq2415x_device *bq)
+{
+=09bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_DISABLE);
+=09bq2415x_exec_command(bq, BQ2415X_CHARGER_DISABLE);
+=09bq2415x_exec_command(bq, BQ2415X_CHARGE_TERMINATION_DISABLE);
+=09bq2415x_set_default_value(bq, current_limit);
+=09bq2415x_set_default_value(bq, weak_battery_voltage);
+=09bq2415x_set_default_value(bq, battery_regulation_voltage);
+=09if (bq->init_data.resistor_sense > 0) {
+=09=09bq2415x_set_default_value(bq, charge_current);
+=09=09bq2415x_set_default_value(bq, termination_current);
+=09=09bq2415x_exec_command(bq, BQ2415X_CHARGE_TERMINATION_ENABLE);
+=09}
+=09bq2415x_exec_command(bq, BQ2415X_CHARGER_ENABLE);
+=09return 0;
+}
+
+/**** charger mode functions ****/
+
+/* set charger mode */
+static int bq2415x_set_mode(struct bq2415x_device *bq, enum bq2415x_mo=
de mode)
+{
+=09int ret =3D 0;
+=09int charger =3D 0;
+=09int boost =3D 0;
+
+=09if (mode =3D=3D BQ2415X_MODE_HOST_CHARGER ||
+=09=09mode =3D=3D BQ2415X_MODE_DEDICATED_CHARGER)
+=09=09=09charger =3D 1;
+
+=09if (mode =3D=3D BQ2415X_MODE_BOOST)
+=09=09boost =3D 1;
+
+=09if (!charger)
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_CHARGER_DISABLE);
+
+=09if (!boost)
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_DISABLE);
+
+=09if (ret < 0)
+=09=09return ret;
+
+=09switch (mode) {
+=09case BQ2415X_MODE_NONE:
+=09=09dev_dbg(bq->dev, "changing mode to: N/A\n");
+=09=09ret =3D bq2415x_set_current_limit(bq, 100);
+=09=09break;
+=09case BQ2415X_MODE_HOST_CHARGER:
+=09=09dev_dbg(bq->dev, "changing mode to: Host/HUB charger\n");
+=09=09ret =3D bq2415x_set_current_limit(bq, 500);
+=09=09break;
+=09case BQ2415X_MODE_DEDICATED_CHARGER:
+=09=09dev_dbg(bq->dev, "changing mode to: Dedicated charger\n");
+=09=09ret =3D bq2415x_set_current_limit(bq, 1800);
+=09=09break;
+=09case BQ2415X_MODE_BOOST: /* Boost mode */
+=09=09dev_dbg(bq->dev, "changing mode to: Boost\n");
+=09=09ret =3D bq2415x_set_current_limit(bq, 100);
+=09=09break;
+=09}
+
+=09if (ret < 0)
+=09=09return ret;
+
+=09if (charger)
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_CHARGER_ENABLE);
+=09else if (boost)
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_ENABLE);
+
+=09if (ret < 0)
+=09=09return ret;
+
+=09bq2415x_set_default_value(bq, weak_battery_voltage);
+=09bq2415x_set_default_value(bq, battery_regulation_voltage);
+
+=09bq->mode =3D mode;
+=09sysfs_notify(&bq->charger.dev->kobj, NULL, "mode");
+
+=09return 0;
+
+}
+
+/* hook function called by other driver which set reported mode */
+static void bq2415x_hook_function(enum bq2415x_mode mode, void *data)
+{
+=09struct bq2415x_device *bq =3D data;
+
+=09if (!bq)
+=09=09return;
+
+=09dev_dbg(bq->dev, "hook function was called\n");
+=09bq->reported_mode =3D mode;
+
+=09/* if automode is not enabled do not tell about reported_mode */
+=09if (bq->automode < 1)
+=09=09return;
+
+=09sysfs_notify(&bq->charger.dev->kobj, NULL, "reported_mode");
+=09bq2415x_set_mode(bq, bq->reported_mode);
+
+}
+
+/**** timer functions ****/
+
+/* enable/disable auto resetting chip timer */
+static void bq2415x_set_autotimer(struct bq2415x_device *bq, int state=
)
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
+=09=09bq->timer_error =3D NULL;
+=09} else {
+=09=09cancel_delayed_work_sync(&bq->work);
+=09}
+
+=09mutex_unlock(&bq2415x_timer_mutex);
+}
+
+/* called by bq2415x_timer_work on timer error */
+static void bq2415x_timer_error(struct bq2415x_device *bq, const char =
*msg)
+{
+=09bq->timer_error =3D msg;
+=09sysfs_notify(&bq->charger.dev->kobj, NULL, "timer");
+=09dev_err(bq->dev, "%s\n", msg);
+=09if (bq->automode > 0)
+=09=09bq->automode =3D 0;
+=09bq2415x_set_mode(bq, BQ2415X_MODE_NONE);
+=09bq2415x_set_autotimer(bq, 0);
+}
+
+/* delayed work function for auto resetting chip timer */
+static void bq2415x_timer_work(struct work_struct *work)
+{
+=09struct bq2415x_device *bq =3D container_of(work, struct bq2415x_dev=
ice,
+=09=09=09=09=09=09work.work);
+=09int ret, error, boost;
+
+=09if (!bq->autotimer)
+=09=09return;
+
+=09ret =3D bq2415x_exec_command(bq, BQ2415X_TIMER_RESET);
+=09if (ret < 0) {
+=09=09bq2415x_timer_error(bq, "Resetting timer failed");
+=09=09return;
+=09}
+
+=09boost =3D bq2415x_exec_command(bq, BQ2415X_BOOST_MODE_STATUS);
+=09if (boost < 0) {
+=09=09bq2415x_timer_error(bq, "Unknown error");
+=09=09return;
+=09}
+
+=09error =3D bq2415x_exec_command(bq, BQ2415X_FAULT_STATUS);
+=09if (error < 0) {
+=09=09bq2415x_timer_error(bq, "Unknown error");
+=09=09return;
+=09}
+
+=09if (boost) {
+=09=09switch (error) {
+=09=09/* Non fatal errors, chip is OK */
+=09=09case 0: /* No error */
+=09=09=09break;
+=09=09case 6: /* Timer expired */
+=09=09=09dev_err(bq->dev, "Timer expired\n");
+=09=09=09break;
+=09=09case 3: /* Battery voltage too low */
+=09=09=09dev_err(bq->dev, "Battery voltage to low\n");
+=09=09=09break;
+
+=09=09/* Fatal errors, disable and reset chip */
+=09=09case 1: /* Overvoltage protection (chip fried) */
+=09=09=09bq2415x_timer_error(bq,
+=09=09=09=09"Overvoltage protection (chip fried)");
+=09=09=09return;
+=09=09case 2: /* Overload */
+=09=09=09bq2415x_timer_error(bq, "Overload");
+=09=09=09return;
+=09=09case 4: /* Battery overvoltage protection */
+=09=09=09bq2415x_timer_error(bq,
+=09=09=09=09"Battery overvoltage protection");
+=09=09=09return;
+=09=09case 5: /* Thermal shutdown (too hot) */
+=09=09=09bq2415x_timer_error(bq,
+=09=09=09=09=09"Thermal shutdown (too hot)");
+=09=09=09return;
+=09=09case 7: /* N/A */
+=09=09=09bq2415x_timer_error(bq, "Unknown error");
+=09=09=09return;
+=09=09}
+=09} else {
+=09=09switch (error) {
+=09=09/* Non fatal errors, chip is OK */
+=09=09case 0: /* No error */
+=09=09=09break;
+=09=09case 2: /* Sleep mode */
+=09=09=09dev_err(bq->dev, "Sleep mode\n");
+=09=09=09break;
+=09=09case 3: /* Poor input source */
+=09=09=09dev_err(bq->dev, "Poor input source\n");
+=09=09=09break;
+=09=09case 6: /* Timer expired */
+=09=09=09dev_err(bq->dev, "Timer expired\n");
+=09=09=09break;
+=09=09case 7: /* No battery */
+=09=09=09dev_err(bq->dev, "No battery\n");
+=09=09=09break;
+
+=09=09/* Fatal errors, disable and reset chip */
+=09=09case 1: /* Overvoltage protection (chip fried) */
+=09=09=09bq2415x_timer_error(bq,
+=09=09=09=09"Overvoltage protection (chip fried)");
+=09=09=09return;
+=09=09case 4: /* Battery overvoltage protection */
+=09=09=09bq2415x_timer_error(bq,
+=09=09=09=09"Battery overvoltage protection");
+=09=09=09return;
+=09=09case 5: /* Thermal shutdown (too hot) */
+=09=09=09bq2415x_timer_error(bq,
+=09=09=09=09"Thermal shutdown (too hot)");
+=09=09=09return;
+=09=09}
+=09}
+
+=09schedule_delayed_work(&bq->work, BQ2415X_TIMER_TIMEOUT * HZ);
+}
+
+/**** power supply interface code ****/
+
+static enum power_supply_property bq2415x_power_supply_props[] =3D {
+=09/* TODO: maybe add more power supply properties */
+=09POWER_SUPPLY_PROP_STATUS,
+=09POWER_SUPPLY_PROP_MODEL_NAME,
+};
+
+static int bq2415x_power_supply_get_property(struct power_supply *psy,=

+=09enum power_supply_property psp, union power_supply_propval *val)
+{
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09int ret;
+
+=09switch (psp) {
+=09case POWER_SUPPLY_PROP_STATUS:
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_CHARGE_STATUS);
+=09=09if (ret < 0)
+=09=09=09return ret;
+=09=09else if (ret =3D=3D 0) /* Ready */
+=09=09=09val->intval =3D POWER_SUPPLY_STATUS_NOT_CHARGING;
+=09=09else if (ret =3D=3D 1) /* Charge in progress */
+=09=09=09val->intval =3D POWER_SUPPLY_STATUS_CHARGING;
+=09=09else if (ret =3D=3D 2) /* Charge done */
+=09=09=09val->intval =3D POWER_SUPPLY_STATUS_FULL;
+=09=09else
+=09=09=09val->intval =3D POWER_SUPPLY_STATUS_UNKNOWN;
+=09=09break;
+=09case POWER_SUPPLY_PROP_MODEL_NAME:
+=09=09val->strval =3D bq->model;
+=09=09break;
+=09default:
+=09=09return -EINVAL;
+=09}
+=09return 0;
+}
+
+static int bq2415x_power_supply_init(struct bq2415x_device *bq)
+{
+=09int ret;
+=09int chip;
+=09char revstr[8];
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
+=09=09chip =3D BQUNKNOWN;
+=09else
+=09=09chip =3D ret;
+
+=09ret =3D bq2415x_detect_revision(bq);
+=09if (ret < 0)
+=09=09strcpy(revstr, "unknown");
+=09else
+=09=09sprintf(revstr, "1.%d", ret);
+
+=09bq->model =3D kasprintf(GFP_KERNEL,
+=09=09=09=09"chip %s, revision %s, vender code %.3d",
+=09=09=09=09bq2415x_chip_name[chip], revstr,
+=09=09=09=09bq2415x_get_vender_code(bq));
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
+=09return 0;
+}
+
+static void bq2415x_power_supply_exit(struct bq2415x_device *bq)
+{
+=09bq->autotimer =3D 0;
+=09if (bq->automode > 0)
+=09=09bq->automode =3D 0;
+=09cancel_delayed_work_sync(&bq->work);
+=09power_supply_unregister(&bq->charger);
+=09kfree(bq->model);
+}
+
+/**** additional sysfs entries for power supply interface ****/
+
+/* show *_status entries */
+static ssize_t bq2415x_sysfs_show_status(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
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
+/* set timer entry:
+     auto - enable auto mode
+     off - disable auto mode
+     (other values) - reset chip timer
+*/
+static ssize_t bq2415x_sysfs_set_timer(struct device *dev,
+=09=09struct device_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09int ret =3D 0;
+
+=09if (strncmp(buf, "auto", 4) =3D=3D 0)
+=09=09bq2415x_set_autotimer(bq, 1);
+=09else if (strncmp(buf, "off", 3) =3D=3D 0)
+=09=09bq2415x_set_autotimer(bq, 0);
+=09else
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_TIMER_RESET);
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+/* show timer entry (auto or off) */
+static ssize_t bq2415x_sysfs_show_timer(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+
+=09if (bq->timer_error)
+=09=09return sprintf(buf, "%s\n", bq->timer_error);
+
+=09if (bq->autotimer)
+=09=09return sprintf(buf, "auto\n");
+=09else
+=09=09return sprintf(buf, "off\n");
+}
+
+/* set mode entry:
+     auto - if automode is supported, enable it and set mode to report=
ed
+     none - disable charger and boost mode
+     host - charging mode for host/hub chargers (current limit 500mA)
+     dedicated - charging mode for dedicated chargers (unlimited curre=
nt limit)
+     boost - disable charger and enable boost mode
+*/
+static ssize_t bq2415x_sysfs_set_mode(struct device *dev,
+=09=09struct device_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09enum bq2415x_mode mode;
+=09int ret =3D 0;
+
+=09if (strncmp(buf, "auto", 4) =3D=3D 0) {
+=09=09if (bq->automode < 0)
+=09=09=09return -ENOSYS;
+=09=09bq->automode =3D 1;
+=09=09mode =3D bq->reported_mode;
+=09} else if (strncmp(buf, "none", 4) =3D=3D 0) {
+=09=09if (bq->automode > 0)
+=09=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_NONE;
+=09} else if (strncmp(buf, "host", 4) =3D=3D 0) {
+=09=09if (bq->automode > 0)
+=09=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_HOST_CHARGER;
+=09} else if (strncmp(buf, "dedicated", 9) =3D=3D 0) {
+=09=09if (bq->automode > 0)
+=09=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_DEDICATED_CHARGER;
+=09} else if (strncmp(buf, "boost", 5) =3D=3D 0) {
+=09=09if (bq->automode > 0)
+=09=09=09bq->automode =3D 0;
+=09=09mode =3D BQ2415X_MODE_BOOST;
+=09} else if (strncmp(buf, "reset", 5) =3D=3D 0) {
+=09=09bq2415x_reset_chip(bq);
+=09=09bq2415x_set_defaults(bq);
+=09=09if (bq->automode <=3D 0)
+=09=09=09return count;
+=09=09bq->automode =3D 1;
+=09=09mode =3D bq->reported_mode;
+=09} else
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_set_mode(bq, mode);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+/* show mode entry (auto, none, host, dedicated or boost) */
+static ssize_t bq2415x_sysfs_show_mode(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09ssize_t ret =3D 0;
+
+=09if (bq->automode > 0)
+=09=09ret +=3D sprintf(buf+ret, "auto (");
+
+=09switch (bq->mode) {
+=09case BQ2415X_MODE_NONE:
+=09=09ret +=3D sprintf(buf+ret, "none");
+=09=09break;
+=09case BQ2415X_MODE_HOST_CHARGER:
+=09=09ret +=3D sprintf(buf+ret, "host");
+=09=09break;
+=09case BQ2415X_MODE_DEDICATED_CHARGER:
+=09=09ret +=3D sprintf(buf+ret, "dedicated");
+=09=09break;
+=09case BQ2415X_MODE_BOOST:
+=09=09ret +=3D sprintf(buf+ret, "boost");
+=09=09break;
+=09}
+
+=09if (bq->automode > 0)
+=09=09ret +=3D sprintf(buf+ret, ")");
+
+=09ret +=3D sprintf(buf+ret, "\n");
+=09return ret;
+}
+
+/* show reported_mode entry (none, host, dedicated or boost) */
+static ssize_t bq2415x_sysfs_show_reported_mode(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+
+=09if (bq->automode < 0)
+=09=09return -EINVAL;
+
+=09switch (bq->reported_mode) {
+=09case BQ2415X_MODE_NONE:
+=09=09return sprintf(buf, "none\n");
+=09case BQ2415X_MODE_HOST_CHARGER:
+=09=09return sprintf(buf, "host\n");
+=09case BQ2415X_MODE_DEDICATED_CHARGER:
+=09=09return sprintf(buf, "dedicated\n");
+=09case BQ2415X_MODE_BOOST:
+=09=09return sprintf(buf, "boost\n");
+=09}
+
+=09return -EINVAL;
+}
+
+/* directly set raw value to chip register, format: 'register value' *=
/
+static ssize_t bq2415x_sysfs_set_registers(struct device *dev,
+=09=09struct device_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09ssize_t ret =3D 0;
+=09unsigned int reg;
+=09unsigned int val;
+
+=09if (sscanf(buf, "%x %x", &reg, &val) !=3D 2)
+=09=09return -EINVAL;
+
+=09if (reg > 4 || val > 255)
+=09=09return -EINVAL;
+
+=09ret =3D bq2415x_i2c_write(bq, reg, val);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+/* print value of chip register, format: 'register=3Dvalue' */
+static ssize_t bq2415x_sysfs_print_reg(struct bq2415x_device *bq,
+=09=09=09=09=09u8 reg, char *buf)
+{
+=09int ret =3D bq2415x_i2c_read(bq, reg);
+=09if (ret < 0)
+=09=09return sprintf(buf, "%#.2x=3Derror %d\n", reg, ret);
+=09else
+=09=09return sprintf(buf, "%#.2x=3D%#.2x\n", reg, ret);
+}
+
+/* show all raw values of chip register, format per line: 'register=3D=
value' */
+static ssize_t bq2415x_sysfs_show_registers(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
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
+/* set current and voltage limit entries (in mA or mV) */
+static ssize_t bq2415x_sysfs_set_limit(struct device *dev,
+=09=09struct device_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09long val;
+=09int ret;
+
+=09if (kstrtol(buf, 10, &val) < 0)
+=09=09return -EINVAL;
+
+=09if (strcmp(attr->attr.name, "current_limit") =3D=3D 0)
+=09=09ret =3D bq2415x_set_current_limit(bq, val);
+=09else if (strcmp(attr->attr.name, "weak_battery_voltage") =3D=3D 0)
+=09=09ret =3D bq2415x_set_weak_battery_voltage(bq, val);
+=09else if (strcmp(attr->attr.name, "battery_regulation_voltage") =3D=3D=
 0)
+=09=09ret =3D bq2415x_set_battery_regulation_voltage(bq, val);
+=09else if (strcmp(attr->attr.name, "charge_current") =3D=3D 0)
+=09=09ret =3D bq2415x_set_charge_current(bq, val);
+=09else if (strcmp(attr->attr.name, "termination_current") =3D=3D 0)
+=09=09ret =3D bq2415x_set_termination_current(bq, val);
+=09else
+=09=09return -EINVAL;
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+/* show current and voltage limit entries (in mA or mV) */
+static ssize_t bq2415x_sysfs_show_limit(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09int ret;
+
+=09if (strcmp(attr->attr.name, "current_limit") =3D=3D 0)
+=09=09ret =3D bq2415x_get_current_limit(bq);
+=09else if (strcmp(attr->attr.name, "weak_battery_voltage") =3D=3D 0)
+=09=09ret =3D bq2415x_get_weak_battery_voltage(bq);
+=09else if (strcmp(attr->attr.name, "battery_regulation_voltage") =3D=3D=
 0)
+=09=09ret =3D bq2415x_get_battery_regulation_voltage(bq);
+=09else if (strcmp(attr->attr.name, "charge_current") =3D=3D 0)
+=09=09ret =3D bq2415x_get_charge_current(bq);
+=09else if (strcmp(attr->attr.name, "termination_current") =3D=3D 0)
+=09=09ret =3D bq2415x_get_termination_current(bq);
+=09else
+=09=09return -EINVAL;
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return sprintf(buf, "%d\n", ret);
+}
+
+/* set *_enable entries */
+static ssize_t bq2415x_sysfs_set_enable(struct device *dev,
+=09=09struct device_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09enum bq2415x_command command;
+=09long val;
+=09int ret;
+
+=09if (kstrtol(buf, 10, &val) < 0)
+=09=09return -EINVAL;
+
+=09if (strcmp(attr->attr.name, "charge_termination_enable") =3D=3D 0)
+=09=09command =3D val ? BQ2415X_CHARGE_TERMINATION_ENABLE :
+=09=09=09BQ2415X_CHARGE_TERMINATION_DISABLE;
+=09else if (strcmp(attr->attr.name, "high_impedance_enable") =3D=3D 0)=

+=09=09command =3D val ? BQ2415X_HIGH_IMPEDANCE_ENABLE :
+=09=09=09BQ2415X_HIGH_IMPEDANCE_DISABLE;
+=09else if (strcmp(attr->attr.name, "otg_pin_enable") =3D=3D 0)
+=09=09command =3D val ? BQ2415X_OTG_PIN_ENABLE :
+=09=09=09BQ2415X_OTG_PIN_DISABLE;
+=09else if (strcmp(attr->attr.name, "stat_pin_enable") =3D=3D 0)
+=09=09command =3D val ? BQ2415X_STAT_PIN_ENABLE :
+=09=09=09BQ2415X_STAT_PIN_DISABLE;
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
+/* show *_enable entries */
+static ssize_t bq2415x_sysfs_show_enable(struct device *dev,
+=09=09struct device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce,
+=09=09=09=09=09=09charger);
+=09enum bq2415x_command command;
+=09int ret;
+
+=09if (strcmp(attr->attr.name, "charge_termination_enable") =3D=3D 0)
+=09=09command =3D BQ2415X_CHARGE_TERMINATION_STATUS;
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
+static DEVICE_ATTR(current_limit, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(weak_battery_voltage, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(battery_regulation_voltage, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(charge_current, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+static DEVICE_ATTR(termination_current, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_limit, bq2415x_sysfs_set_limit);
+
+static DEVICE_ATTR(charge_termination_enable, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_enable, bq2415x_sysfs_set_enable);
+static DEVICE_ATTR(high_impedance_enable, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_enable, bq2415x_sysfs_set_enable);
+static DEVICE_ATTR(otg_pin_enable, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_enable, bq2415x_sysfs_set_enable);
+static DEVICE_ATTR(stat_pin_enable, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_enable, bq2415x_sysfs_set_enable);
+
+static DEVICE_ATTR(reported_mode, S_IRUGO,
+=09=09bq2415x_sysfs_show_reported_mode, NULL);
+static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_mode, bq2415x_sysfs_set_mode);
+static DEVICE_ATTR(timer, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_timer, bq2415x_sysfs_set_timer);
+
+static DEVICE_ATTR(registers, S_IWUSR | S_IRUGO,
+=09=09bq2415x_sysfs_show_registers, bq2415x_sysfs_set_registers);
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
+=09&dev_attr_charge_current.attr,
+=09&dev_attr_termination_current.attr,
+
+=09&dev_attr_charge_termination_enable.attr,
+=09&dev_attr_high_impedance_enable.attr,
+=09&dev_attr_otg_pin_enable.attr,
+=09&dev_attr_stat_pin_enable.attr,
+
+=09&dev_attr_reported_mode.attr,
+=09&dev_attr_mode.attr,
+=09&dev_attr_timer.attr,
+
+=09&dev_attr_registers.attr,
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
+=09return sysfs_create_group(&bq->charger.dev->kobj,
+=09=09=09&bq2415x_sysfs_attr_group);
+}
+
+static void bq2415x_sysfs_exit(struct bq2415x_device *bq)
+{
+=09sysfs_remove_group(&bq->charger.dev->kobj, &bq2415x_sysfs_attr_grou=
p);
+}
+
+/* main bq2415x probe function */
+static int bq2415x_probe(struct i2c_client *client,
+=09=09const struct i2c_device_id *id)
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
+=09bq->mode =3D BQ2415X_MODE_NONE;
+=09bq->reported_mode =3D BQ2415X_MODE_NONE;
+=09bq->autotimer =3D 0;
+=09bq->automode =3D 0;
+
+=09memcpy(&bq->init_data, client->dev.platform_data,
+=09=09=09sizeof(bq->init_data));
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
+=09if (bq->init_data.set_mode_hook) {
+=09=09if (bq->init_data.set_mode_hook(
+=09=09=09=09bq2415x_hook_function, bq)) {
+=09=09=09bq->automode =3D 1;
+=09=09=09bq2415x_set_mode(bq, bq->reported_mode);
+=09=09=09dev_info(bq->dev, "automode enabled\n");
+=09=09} else {
+=09=09=09bq->automode =3D -1;
+=09=09=09dev_info(bq->dev, "automode failed\n");
+=09=09}
+=09} else {
+=09=09bq->automode =3D -1;
+=09=09dev_info(bq->dev, "automode not supported\n");
+=09}
+
+=09INIT_DELAYED_WORK(&bq->work, bq2415x_timer_work);
+=09bq2415x_set_autotimer(bq, 1);
+
+=09dev_info(bq->dev, "driver registered\n");
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
+/* main bq2415x remove function */
+
+static int bq2415x_remove(struct i2c_client *client)
+{
+=09struct bq2415x_device *bq =3D i2c_get_clientdata(client);
+
+=09if (bq->init_data.set_mode_hook)
+=09=09bq->init_data.set_mode_hook(NULL, NULL);
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
+=09dev_info(bq->dev, "driver unregistered\n");
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
+static int __init bq2415x_init(void)
+{
+=09return i2c_add_driver(&bq2415x_driver);
+}
+module_init(bq2415x_init);
+
+static void __exit bq2415x_exit(void)
+{
+=09i2c_del_driver(&bq2415x_driver);
+}
+module_exit(bq2415x_exit);
+
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_DESCRIPTION("bq2415x charger driver");
+MODULE_LICENSE("GPL");
--- /dev/null
+++ linux/include/linux/power/bq2415x_charger.h
@@ -0,0 +1,90 @@
+/*
+    bq2415x_charger.h - bq2415x charger driver
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
+#ifndef BQ2415X_CHARGER_H
+#define BQ2415X_CHARGER_H
+
+/*
+  This is platform data for bq2415x chip. It contains default board vo=
ltages
+  and currents which can be also later configured via sysfs. If value =
is -1
+  then default chip value (specified in datasheet) will be used.
+
+  Value resistor_sense is needed for for configuring charge and termin=
ation
+  current. It it is less or equal to zero, configuring charge and term=
ination
+  current will not be possible.
+
+  Function set_mode_hook is needed for automode (setting correct curre=
nt limit
+  when charger is connected/disconnected or setting boost mode). When =
is NULL,
+  automode function is disabled. When is not NULL, it must have this p=
rototype:
+
+    int (*set_mode_hook)(
+      void (*hook)(enum bq2415x_mode mode, void *data),
+      void *data)
+
+  hook is hook function (see below) and data is pointer to driver priv=
ate data
+
+  bq2415x driver will call it as:
+
+    platform_data->set_mode_hook(bq2415x_hook_function, bq2415x_device=
);
+
+  Board/platform function set_mode_hook return non zero value when hoo=
k
+  function was successful registered. Platform code should call that h=
ook
+  function (which get from pointer, with data) every time when charger=
 was
+  connected/disconnected or require to enable boost mode. bq2415x driv=
er then
+  will set correct current limit, enable/disable charger or boost mode=
.
+
+  Hook function has this prototype:
+
+    void hook(enum bq2415x_mode mode, void *data);
+
+  mode is bq2415x mode (charger or boost)
+  data is pointer to driver private data (which get from set_charger_t=
ype_hook)
+
+  When bq driver is being unloaded, it call function:
+
+    platform_data->set_mode_hook(NULL, NULL);
+
+  (hook function and driver private data are NULL)
+
+  After that board/platform code must not call driver hook function! I=
t is
+  possible that pointer to hook function will not be valid and calling=
 will
+  cause undefined result.
+
+*/
+
+/* Supported modes with maximal current limit */
+enum bq2415x_mode {
+=09BQ2415X_MODE_NONE,=09=09/* unknown or no charger (100mA) */
+=09BQ2415X_MODE_HOST_CHARGER,=09/* usb host/hub charger (500mA) */
+=09BQ2415X_MODE_DEDICATED_CHARGER, /* dedicated charger (unlimited) */=

+=09BQ2415X_MODE_BOOST,=09=09/* boost mode (charging disabled) */
+};
+
+struct bq2415x_platform_data {
+=09int current_limit;=09=09/* mA */
+=09int weak_battery_voltage;=09/* mV */
+=09int battery_regulation_voltage;=09/* mV */
+=09int charge_current;=09=09/* mA */
+=09int termination_current;=09/* mA */
+=09int resistor_sense;=09=09/* m ohm */
+=09int (*set_mode_hook)(void (*hook)(enum bq2415x_mode mode, void *dat=
a),
+=09=09=09     void *data);
+};
+
+#endif

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--nextPart7439548.TvAAzhPPP6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCUHHMACgkQi/DJPQPkQ1JU6QCeLT/oLTUR74qn1jronsfP3nfC
ahUAn2BmI/O8dHdnEz9R0jj8cPa85bpj
=IElO
-----END PGP SIGNATURE-----

--nextPart7439548.TvAAzhPPP6--

