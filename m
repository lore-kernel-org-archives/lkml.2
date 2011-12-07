Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab1LGVka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 16:40:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55559 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab1LGVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 16:40:28 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Aliaksei Katovich <aliaksei.katovich@nokia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Joerg Reisenweber <joerg@openmoko.org>
Subject: Re: RFC: bq2415x_charger driver
Date: Wed, 07 Dec 2011 22:40:22 +0100
Message-ID: <1387371.3L69rcsRl6@pali-elitebook>
User-Agent: KMail/4.7.3 (Linux/3.2.0-3-generic; KDE/4.7.3; x86_64; ; )
In-Reply-To: <4EDFD9B8.1050300@mleia.com>
References: <1323124541-7590-1-git-send-email-felipe.contreras@nokia.com> <1677656.4d3iQHNZjX@pali-elitebook> <4EDFD9B8.1050300@mleia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4786174.Fk5ZdovDLt"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart4786174.Fk5ZdovDLt
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Wednesday 07 December 2011 23:25:12 Vladimir Zapolskiy wrote:
> Hi Pali,
>=20
> On 07.12.2011 23:03, Pali Roh=E1r wrote:
> > Hello,
> >=20
> > I'm sending preview of my implementation of bq2415x charger driver.=
 Now
> > all code is in one kernel module bq2415x_charger which has more
> > interfaces (power_supply, sysfs, regulator). It is still unfinished=
,
> > missing more bq2415x configuration like sysfs entires for boost,
> > voltages or platform hooks (e.g. rx51 isp1704). This driver will ha=
ve
> > similar sysfs interface as in Joerg Reisenweber spec
> > http://maemo.cloud-7.de/bq24150-sysnode.spec.txt . Driver should be=

> > replacemnt for Nokia N900 proprietary charging program BME. I was
> > inspirated by driver bq27x00_battery and other bq2415x implementato=
n by
> > Aliaksei Katovich and Felipe Contreras.
> >=20
> > Please comment implementation and write what should be added or mod=
ified
> > in driver (it is still not complete).
>=20
> There are well defined policies regarding patch review in the Linux
> kernel mailing lists. I encourage you to take a look at
> http://felipec.wordpress.com/2009/10/25/git-send-email-tricks/

Ok, I do not know where to put this driver, so I only send files. Here =
is diff

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_ch=
arger.c
new file mode 100644
index 0000000..eb9957a
--- /dev/null
+++ b/drivers/power/bq2415x_charger.c
@@ -0,0 +1,1115 @@
+/*
+    bq2415x_charger.c - bq2415x charger driver
+    Copyright (C) 2011  Pali Roh=E1r <pali.rohar@gmail.com>
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
+#include <linux/regulator/driver.h>
+#include <linux/power_supply.h>
+#include <linux/idr.h>
+#include <linux/leds.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+
+#include "bq2415x_charger.h"
+
+#define BQ2415X_WATCHDOG_TIMEOUT=0910
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
+#define BQ2415X_SHIFT_PN=09=094
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
+struct bq2415x_regulator {
+=09struct regulator_ops ops;
+=09struct regulator_desc desc;
+=09struct regulator_dev *dev;
+};
+
+struct bq2415x_device {
+=09struct device *dev;
+=09struct bq2415x_platform_data *platform_data;
+=09struct bq2415x_regulator current_limit;
+=09struct bq2415x_regulator weak_battery_voltage;
+=09struct bq2415x_regulator battery_regulation_voltage;
+=09struct bq2415x_regulator charge_current_sense_voltage;
+=09struct bq2415x_regulator termination_current_sense_voltage;
+=09struct led_classdev led;
+=09struct power_supply charger;
+=09struct delayed_work work;
+=09int watchdog;
+=09enum bq2415x_chip chip;
+=09char *name;
+=09int id;
+};
+
+static DEFINE_IDR(bq2415x_id);
+static DEFINE_MUTEX(bq2415x_mutex);
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
+=09dev_info(bq->dev, "bq2415x_i2c_read reg=3D%#x\n", reg);
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
+=09mutex_lock(&bq2415x_mutex);
+=09ret =3D i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
+=09mutex_unlock(&bq2415x_mutex);
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
+=09dev_info(bq->dev, "bq2415x_i2c_read_mask reg=3D%#x mask=3D%#x shift=
=3D%#x\n", reg, mask, shift);
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
+=09dev_info(bq->dev, "bq2415x_i2c_write reg=3D%#x val=3D%#x\n", reg, v=
al);
+
+=09data[0] =3D reg;
+=09data[1] =3D val;
+
+=09msg[0].addr =3D client->addr;
+=09msg[0].flags =3D 0;
+=09msg[0].buf =3D data;
+=09msg[0].len =3D ARRAY_SIZE(data);
+
+=09mutex_lock(&bq2415x_mutex);
+=09ret =3D i2c_transfer(client->adapter, msg, ARRAY_SIZE(msg));
+=09mutex_unlock(&bq2415x_mutex);
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
+=09dev_info(bq->dev, "bq2415x_i2c_write_mask reg=3D%#x val=3D%#x mask=3D=
%#x shift=3D%#x\n", reg, val, mask, shift);
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
+/* global detect chip */
+
+enum bq2415x_chip bq2415x_detect_chip(struct bq2415x_device *bq)
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
+EXPORT_SYMBOL_GPL(bq2415x_detect_chip);
+
+/* global exec command function */
+
+int bq2415x_exec_command(struct bq2415x_device *bq, enum bq2415x_comma=
nd command)
+{
+=09switch(command)
+=09{
+=09=09case BQ2415X_WATCHDOG_RESET:
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
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL, BQ2415X_=
BIT_CE);
+=09=09case BQ2415X_CHARGER_ENABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ24=
15X_BIT_CE);
+=09=09case BQ2415X_CHARGER_DISABLE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 0, BQ24=
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
+=09=09case BQ2415X_MODE:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_CONTROL, BQ2415X_=
BIT_OPA_MODE);
+=09=09case BQ2415X_SET_BOOST_MODE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 1, BQ24=
15X_BIT_OPA_MODE);
+=09=09case BQ2415X_SET_CHARGER_MODE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_CONTROL, 0, BQ24=
15X_BIT_OPA_MODE);
+
+=09=09case BQ2415X_OTG_HIGH_STATUS:
+=09=09=09return bq2415x_i2c_read_bit(bq, BQ2415X_REG_VOLTAGE, BQ2415X_=
BIT_OTG_PL);
+=09=09case BQ2415X_OTG_HIGH_ACTIVATE:
+=09=09=09return bq2415x_i2c_write_bit(bq, BQ2415X_REG_VOLTAGE, 1, BQ24=
15X_BIT_OTG_PL);
+=09=09case BQ2415X_OTG_LOW_ACTIVATE:
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
+EXPORT_SYMBOL_GPL(bq2415x_exec_command);
+
+/* global other functions */
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
+int bq2415x_set_defaults(struct bq2415x_device *bq)
+{
+=09bq2415x_exec_command(bq, BQ2415X_CHARGER_DISABLE);
+=09bq2415x_set_default_value(bq, current_limit);
+=09bq2415x_set_default_value(bq, weak_battery_voltage);
+=09bq2415x_set_default_value(bq, battery_regulation_voltage);
+=09bq2415x_set_default_value(bq, charge_current_sense_voltage);
+=09bq2415x_set_default_value(bq, termination_current_sense_voltage);
+=09bq2415x_exec_command(bq, BQ2415X_CHARGER_ENABLE);
+=09return 0;
+}
+EXPORT_SYMBOL_GPL(bq2415x_set_defaults);
+
+#undef bq2415x_set_default_value
+
+void bq2415x_reset_chip(struct bq2415x_device *bq)
+{
+=09bq2415x_i2c_write(bq, BQ2415X_REG_CURRENT, BQ2415X_RESET_CURRENT);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_VOLTAGE, BQ2415X_RESET_VOLTAGE);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_CONTROL, BQ2415X_RESET_CONTROL);
+=09bq2415x_i2c_write(bq, BQ2415X_REG_STATUS, BQ2415X_RESET_STATUS);
+}
+EXPORT_SYMBOL_GPL(bq2415x_reset_chip);
+
+int bq2415x_set_current_limit(struct bq2415x_device *bq, int mA)
+{
+=09int val =3D (mA/100 + (mA%100 > 0 ? 1 : 0) - 1) / 4;
+
+=09if (val < 0)
+=09=09val =3D 0;
+
+=09if (val > 3)
+=09=09val =3D 3;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CONTROL, val, BQ2415X=
_MASK_LIMIT, BQ2415X_SHIFT_LIMIT);
+}
+EXPORT_SYMBOL_GPL(bq2415x_set_current_limit);
+
+int bq2415x_get_current_limit(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CONTROL, BQ2415X_=
MASK_LIMIT, BQ2415X_SHIFT_LIMIT);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 100 * (1 + 4*ret);
+}
+EXPORT_SYMBOL_GPL(bq2415x_get_current_limit);
+
+int bq2415x_set_weak_battery_voltage(struct bq2415x_device *bq, int mV=
)
+{
+=09int val =3D mV/100 + (mV%100 > 0 ? 1 : 0) - 34;
+
+=09if (val < 0)
+=09=09val =3D 0;
+
+=09if (val > 3)
+=09=09return -EINVAL;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_CONTROL, val, BQ2415X=
_MASK_VLOWV, BQ2415X_SHIFT_VLOWV);
+}
+EXPORT_SYMBOL_GPL(bq2415x_set_weak_battery_voltage);
+
+int bq2415x_get_weak_battery_voltage(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_CONTROL, BQ2415X_=
MASK_VLOWV, BQ2415X_SHIFT_VLOWV);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 100 * (34 + ret);
+}
+EXPORT_SYMBOL_GPL(bq2415x_get_weak_battery_voltage);
+
+int bq2415x_set_battery_regulation_voltage(struct bq2415x_device *bq, =
int mV)
+{
+=09int val =3D mV/10 + (mV%10 > 0 ? 1 : 0) - 350;
+
+=09if (val < 0)
+=09=09val =3D 0;
+
+=09if (val > 94) /* FIXME: Max is 94 or 122 ? */
+=09=09return -EINVAL;
+
+=09return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val, BQ2415X=
_MASK_VO, BQ2415X_SHIFT_VO);
+}
+EXPORT_SYMBOL_GPL(bq2415x_set_battery_regulation_voltage);
+
+int bq2415x_get_battery_regulation_voltage(struct bq2415x_device *bq)
+{
+=09int ret =3D bq2415x_i2c_read_mask(bq, BQ2415X_REG_VOLTAGE, BQ2415X_=
MASK_VO, BQ2415X_SHIFT_VO);
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return 10 * (350 + ret);
+}
+EXPORT_SYMBOL_GPL(bq2415x_get_battery_regulation_voltage);
+
+int bq2415x_set_charge_current_sense_voltage(struct bq2415x_device *bq=
, int mV)
+{
+=09/* TODO */
+=09return -1;
+}
+EXPORT_SYMBOL_GPL(bq2415x_set_charge_current_sense_voltage);
+
+int bq2415x_get_charge_current_sense_voltage(struct bq2415x_device *bq=
)
+{
+=09/* TODO */
+=09return -1;
+}
+EXPORT_SYMBOL_GPL(bq2415x_get_charge_current_sense_voltage);
+
+int bq2415x_set_termination_current_sense_voltage(struct bq2415x_devic=
e *bq, int mV)
+{
+=09/* TODO */
+=09return -1;
+}
+EXPORT_SYMBOL_GPL(bq2415x_set_termination_current_sense_voltage);
+
+int bq2415x_get_termination_current_sense_voltage(struct bq2415x_devic=
e *bq)
+{
+=09/* TODO */
+=09return -1;
+}
+EXPORT_SYMBOL_GPL(bq2415x_get_termination_current_sense_voltage);
+
+/* current limit regulator */
+
+static int bq2415x_regulator_set_current_limit(struct regulator_dev *r=
dev, int min_uA, int max_uA)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_set_current_limit(bq, min_uA / 1000);
+}
+
+static int bq2415x_regulator_get_current_limit(struct regulator_dev *r=
dev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_get_current_limit(bq) * 1000;
+}
+
+struct regulator_ops bq2415x_regulator_current_limit =3D {
+=09.set_current_limit =3D bq2415x_regulator_set_current_limit,
+=09.get_current_limit =3D bq2415x_regulator_get_current_limit,
+};
+
+/* weak battery voltage regulator */
+
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+static int bq2415x_regulator_list_weak_battery_voltage(struct regulato=
r_dev *rdev, unsigned selector)
+{
+=09if (selector > 3)
+=09=09return 0;
+=09else
+=09=09return 100000 * (34 + selector);
+}
+#endif
+
+static int bq2415x_regulator_set_weak_battery_voltage(struct regulator=
_dev *rdev, int min_uV, int max_uV
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09=09, unsigned *selector
+#endif
+=09=09)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_set_weak_battery_voltage(bq, min_uV / 1000);
+}
+
+static int bq2415x_regulator_get_weak_battery_voltage(struct regulator=
_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_get_weak_battery_voltage(bq) * 1000;
+}
+
+static struct regulator_ops bq2415x_regulator_weak_battery_voltage =3D=
 {
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09.list_voltage =3D bq2415x_regulator_list_weak_battery_voltage,
+#endif
+=09.set_voltage =3D bq2415x_regulator_set_weak_battery_voltage,
+=09.get_voltage =3D bq2415x_regulator_get_weak_battery_voltage,
+};
+
+/* battery regulation voltage regulator */
+
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+static int bq2415x_regulator_list_battery_regulation_voltage(struct re=
gulator_dev *rdev, unsigned selector)
+{
+=09if (selector > 94) /* FIXME: Max is 94 or 122 ? */
+=09=09return 0;
+=09else
+=09=09return 10000 * (350 + selector);
+}
+#endif
+
+static int bq2415x_regulator_set_battery_regulation_voltage(struct reg=
ulator_dev *rdev, int min_uV, int max_uV
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09=09, unsigned *selector
+#endif
+=09=09)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_set_battery_regulation_voltage(bq, min_uV / 1000);
+}
+
+static int bq2415x_regulator_get_battery_regulation_voltage(struct reg=
ulator_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_get_battery_regulation_voltage(bq) * 1000;
+}
+
+static struct regulator_ops bq2415x_regulator_battery_regulation_volta=
ge =3D {
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09.list_voltage =3D bq2415x_regulator_list_battery_regulation_voltage=
,
+#endif
+=09.set_voltage =3D bq2415x_regulator_set_battery_regulation_voltage,
+=09.get_voltage =3D bq2415x_regulator_get_battery_regulation_voltage,
+};
+
+/* charge current sense voltage regulator */
+
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+static int bq2415x_regulator_list_charge_current_sense_voltage(struct =
regulator_dev *rdev, unsigned selector)
+{
+=09/* TODO */
+=09return 0;
+}
+#endif
+
+static int bq2415x_regulator_set_charge_current_sense_voltage(struct r=
egulator_dev *rdev, int min_uV, int max_uV
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09=09, unsigned *selector
+#endif
+=09=09)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_set_charge_current_sense_voltage(bq, min_uV / 1000);=

+}
+
+static int bq2415x_regulator_get_charge_current_sense_voltage(struct r=
egulator_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_get_charge_current_sense_voltage(bq) * 1000;
+}
+
+static struct regulator_ops bq2415x_regulator_charge_current_sense_vol=
tage =3D {
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09.list_voltage =3D bq2415x_regulator_list_charge_current_sense_volta=
ge,
+#endif
+=09.set_voltage =3D bq2415x_regulator_set_charge_current_sense_voltage=
,
+=09.get_voltage =3D bq2415x_regulator_get_charge_current_sense_voltage=
,
+};
+
+/* termination current sense voltage regulator */
+
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+static int bq2415x_regulator_list_termination_current_sense_voltage(st=
ruct regulator_dev *rdev, unsigned selector)
+{
+=09/* TODO */
+=09return 0;
+}
+#endif
+
+static int bq2415x_regulator_set_termination_current_sense_voltage(str=
uct regulator_dev *rdev, int min_uV, int max_uV
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09=09, unsigned *selector
+#endif
+=09=09)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_set_termination_current_sense_voltage(bq, min_uV / 1=
000);
+}
+
+static int bq2415x_regulator_get_termination_current_sense_voltage(str=
uct regulator_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_get_termination_current_sense_voltage(bq) * 1000;
+}
+
+static int bq2415x_regulator_enable_termination_current_sense_voltage(=
struct regulator_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_exec_command(bq, BQ2415X_CHARGE_CURRENT_TERMINATION_=
ENABLE);
+}
+
+static int bq2415x_regulator_disable_termination_current_sense_voltage=
(struct regulator_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_exec_command(bq, BQ2415X_CHARGE_CURRENT_TERMINATION_=
DISABLE);
+}
+
+static int bq2415x_regulator_is_enabled_termination_current_sense_volt=
age(struct regulator_dev *rdev)
+{
+=09struct bq2415x_device *bq =3D rdev_get_drvdata(rdev);
+=09return bq2415x_exec_command(bq, BQ2415X_CHARGE_CURRENT_TERMINATION_=
STATUS);
+}
+
+static struct regulator_ops bq2415x_regulator_termination_current_sens=
e_voltage =3D {
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+=09.list_voltage =3D bq2415x_regulator_list_termination_current_sense_=
voltage,
+#endif
+=09.set_voltage =3D bq2415x_regulator_set_termination_current_sense_vo=
ltage,
+=09.get_voltage =3D bq2415x_regulator_get_termination_current_sense_vo=
ltage,
+=09.enable =3D bq2415x_regulator_enable_termination_current_sense_volt=
age,
+=09.disable =3D bq2415x_regulator_disable_termination_current_sense_vo=
ltage,
+=09.is_enabled =3D bq2415x_regulator_is_enabled_termination_current_se=
nse_voltage,
+};
+
+#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,32)
+#define regulator_register2(desc, dev, init, data) regulator_register(=
desc, dev, init, data)
+#else
+#define regulator_register2(desc, dev, init, data) regulator_register(=
desc, dev, data)
+#endif
+
+#define bq2415x_regulator_register(bq, rname, rid, rtype) \
+=09do { \
+=09=09bq->rname.desc.name =3D __stringify(rname); \
+=09=09bq->rname.desc.id =3D rid; \
+=09=09bq->rname.desc.type =3D rtype; \
+=09=09bq->rname.desc.owner =3D THIS_MODULE; \
+=09=09bq->rname.desc.ops =3D &bq2415x_regulator_##rname; \
+=09=09bq->rname.dev =3D regulator_register2(&bq->rname.desc, bq->dev, =
NULL, bq); \
+=09=09if (IS_ERR(bq->rname.dev)) \
+=09=09=09return PTR_ERR(bq->rname.dev); \
+=09} while (0)
+
+#define bq2415x_regulator_unregister(bq, rname) regulator_unregister(b=
q->rname.dev)
+
+static int bq2415x_regulator_init(struct bq2415x_device *bq)
+{
+/*=09bq2415x_regulator_register(bq, current_limit, 0, REGULATOR_CURREN=
T);
+=09bq2415x_regulator_register(bq, weak_battery_voltage, 1, REGULATOR_V=
OLTAGE);
+=09bq2415x_regulator_register(bq, battery_regulation_voltage, 2, REGUL=
ATOR_VOLTAGE);
+=09bq2415x_regulator_register(bq, charge_current_sense_voltage, 3, REG=
ULATOR_VOLTAGE);
+=09bq2415x_regulator_register(bq, ermination_current_sense_voltage, 4,=
 REGULATOR_VOLTAGE);*/
+=09return 0;
+}
+
+static void bq2415x_regulator_exit(struct bq2415x_device *bq)
+{
+/*=09bq2415x_regulator_unregister(bq, current_limit);
+=09bq2415x_regulator_unregister(bq, weak_battery_voltage);
+=09bq2415x_regulator_unregister(bq, battery_regulation_voltage);
+=09bq2415x_regulator_unregister(bq, charge_current_sense_voltage);
+=09bq2415x_regulator_unregister(bq, termination_current_sense_voltage)=
;*/
+}
+
+#undef bq2415x_regulator_register
+#undef bq2415x_regulator_unregister
+
+/* power supply */
+
+static enum power_supply_property bq2415x_power_supply_props[] =3D {
+=09/* TODO */
+=09POWER_SUPPLY_PROP_STATUS,
+};
+
+static void bq2415x_power_supply_work(struct work_struct *work)
+{
+=09struct bq2415x_device *bq =3D container_of(work, struct bq2415x_dev=
ice, work.work);
+=09int ret;
+
+=09dev_info(bq->dev, "bq2415x_power_supply_work\n");
+
+=09if (bq->watchdog !=3D 1)
+=09=09return;
+
+=09ret =3D bq2415x_exec_command(bq, BQ2415X_WATCHDOG_RESET);
+=09if (ret < 0)
+=09=09bq->watchdog =3D ret;
+
+=09if (bq->watchdog !=3D 1)
+=09=09return;
+
+=09/* TODO charge */
+
+=09schedule_delayed_work(&bq->work, BQ2415X_WATCHDOG_TIMEOUT * HZ);
+}
+
+static void bq2415x_power_supply_update_watchdog(struct bq2415x_device=
 *bq, int auto_enable)
+{
+=09if (auto_enable && bq->watchdog =3D=3D 1)
+=09=09return;
+
+=09if (!auto_enable && bq->watchdog =3D=3D 0)
+=09=09return;
+
+=09if (auto_enable) {
+=09=09bq->watchdog =3D 1;
+=09=09schedule_delayed_work(&bq->work, BQ2415X_WATCHDOG_TIMEOUT * HZ);=

+=09=09bq2415x_exec_command(bq, BQ2415X_WATCHDOG_RESET);
+=09} else {
+=09=09bq->watchdog =3D 0;
+=09=09cancel_delayed_work_sync(&bq->work);
+=09}
+}
+
+static int bq2415x_power_supply_get_property(struct power_supply *psy,=
 enum power_supply_property psp, union power_supply_propval *val)
+{
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09/* TODO */
+=09return -EINVAL;
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
+=09ret =3D power_supply_register(bq->dev, &bq->charger);
+=09if (ret)
+=09=09return ret;
+
+=09INIT_DELAYED_WORK(&bq->work, bq2415x_power_supply_work);
+
+=09bq2415x_power_supply_update_watchdog(bq, 1);
+=09return ret;
+}
+
+static void bq2415x_power_supply_exit(struct bq2415x_device *bq)
+{
+=09bq->watchdog =3D 0;
+=09cancel_delayed_work_sync(&bq->work);
+=09power_supply_unregister(&bq->charger);
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
+static ssize_t bq2415x_sysfs_set_watchdog(struct device *dev, struct d=
evice_attribute *attr, const char *buf, size_t count)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+=09int ret =3D 0;
+
+=09if (strncmp(buf, "auto", 4) =3D=3D 0)
+=09=09bq2415x_power_supply_update_watchdog(bq, 1);
+=09else if (strncmp(buf, "off", 3) =3D=3D 0)
+=09=09bq2415x_power_supply_update_watchdog(bq, 0);
+=09else
+=09=09ret =3D bq2415x_exec_command(bq, BQ2415X_WATCHDOG_RESET);
+
+=09if (ret < 0)
+=09=09return ret;
+=09else
+=09=09return count;
+}
+
+static ssize_t bq2415x_sysfs_show_watchdog(struct device *dev, struct =
device_attribute *attr, char *buf)
+{
+=09struct power_supply *psy =3D dev_get_drvdata(dev);
+=09struct bq2415x_device *bq =3D container_of(psy, struct bq2415x_devi=
ce, charger);
+
+=09switch (bq->watchdog) {
+=09=09case 1: return sprintf(buf, "auto\n");
+=09=09case 0: return sprintf(buf, "off\n");
+=09=09default: return sprintf(buf, "error %d\n", bq->watchdog);
+=09}
+}
+
+/* TODO: Add other sysfs entries */
+
+static DEVICE_ATTR(watchdog, S_IWUSR | S_IRUGO, bq2415x_sysfs_show_wat=
chdog, bq2415x_sysfs_set_watchdog);
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
+=09&dev_attr_watchdog.attr,
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
+/* charger led device on STAT_PIN */
+
+static void bq2415x_led_set(struct led_classdev *led_cdev, enum led_br=
ightness value)
+{
+=09struct i2c_client *client =3D to_i2c_client(led_cdev->dev->parent);=

+=09struct bq2415x_device *bq =3D i2c_get_clientdata(client);
+
+=09if (value)
+=09=09bq2415x_exec_command(bq, BQ2415X_STAT_PIN_ENABLE);
+=09else
+=09=09bq2415x_exec_command(bq, BQ2415X_STAT_PIN_DISABLE);
+}
+
+static enum led_brightness bq2415x_led_get(struct led_classdev *led_cd=
ev)
+{
+=09struct i2c_client *client =3D to_i2c_client(led_cdev->dev->parent);=

+=09struct bq2415x_device *bq =3D i2c_get_clientdata(client);
+
+=09if (bq2415x_exec_command(bq, BQ2415X_STAT_PIN_STATUS) > 0)
+=09=09return LED_FULL;
+=09else
+=09=09return LED_OFF;
+}
+
+static int bq2415x_led_init(struct bq2415x_device *bq)
+{
+=09bq->led.name =3D bq->name;
+=09bq->led.brightness_set =3D bq2415x_led_set;
+=09bq->led.brightness_get =3D bq2415x_led_get;
+=09return led_classdev_register(bq->dev, &bq->led);
+}
+
+static void bq2415x_led_exit(struct bq2415x_device *bq)
+{
+=09led_classdev_unregister(&bq->led);
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
+=09mutex_lock(&bq2415x_mutex);
+=09ret =3D idr_get_new(&bq2415x_id, client, &num);
+=09mutex_unlock(&bq2415x_mutex);
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
+=09bq->watchdog =3D 0;
+
+=09bq2415x_reset_chip(bq);
+
+=09ret =3D bq2415x_regulator_init(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to register regulators: %d\n", ret);
+=09=09goto error_3;
+=09}
+
+=09ret =3D bq2415x_led_init(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to register led device: %d\n", ret);
+=09=09goto error_4;
+=09}
+
+=09ret =3D bq2415x_power_supply_init(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to register power supply: %d\n", ret);
+=09=09goto error_5;
+=09}
+
+=09ret =3D bq2415x_sysfs_init(bq);
+=09if (ret) {
+=09=09dev_err(bq->dev, "failed to create sysfs entries: %d\n", ret);
+=09=09goto error_6;
+=09}
+
+=09bq2415x_set_defaults(bq);
+
+=09dev_info(bq->dev, "driver registred\n");
+=09return 0;
+
+/*error_7:*/
+=09bq2415x_sysfs_exit(bq);
+error_6:
+=09bq2415x_power_supply_exit(bq);
+error_5:
+=09bq2415x_led_exit(bq);
+error_4:
+=09bq2415x_regulator_exit(bq);
+error_3:
+=09kfree(bq);
+error_2:
+=09kfree(name);
+error_1:
+=09mutex_lock(&bq2415x_mutex);
+=09idr_remove(&bq2415x_id, num);
+=09mutex_unlock(&bq2415x_mutex);
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
+=09bq2415x_sysfs_exit(bq);
+=09bq2415x_power_supply_exit(bq);
+=09bq2415x_led_exit(bq);
+=09bq2415x_regulator_exit(bq);
+
+=09bq2415x_reset_chip(bq);
+
+=09mutex_lock(&bq2415x_mutex);
+=09idr_remove(&bq2415x_id, bq->id);
+=09mutex_unlock(&bq2415x_mutex);
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
+static struct bq2415x_platform_data rx51_platform_data =3D {
+=09.current_limit =3D 100, /* mA */
+=09.weak_battery_voltage =3D 3400, /* mV */
+=09.battery_regulation_voltage =3D 4200, /* mV */
+=09.charge_current_sense_voltage =3D -1, /* TODO */
+=09.termination_current_sense_voltage =3D -1, /* TODO */
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
+=09i2c_unregister_device(client);
+=09/* END */
+
+=09i2c_del_driver(&bq2415x_driver);
+}
+module_exit(bq2415x_exit);
+
+MODULE_AUTHOR("Pali Roh=E1r <pali.rohar@gmail.com>");
+MODULE_DESCRIPTION("bq2415x charger driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/power/bq2415x_charger.h b/drivers/power/bq2415x_ch=
arger.h
new file mode 100644
index 0000000..de0ec02
--- /dev/null
+++ b/drivers/power/bq2415x_charger.h
@@ -0,0 +1,97 @@
+/*
+    bq2415x_charger.h - bq2415x charger driver
+    Copyright (C) 2011  Pali Roh=E1r <pali.rohar@gmail.com>
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
+struct bq2415x_device;
+
+struct bq2415x_platform_data {
+=09int current_limit;
+=09int weak_battery_voltage;
+=09int battery_regulation_voltage;
+=09int charge_current_sense_voltage;
+=09int termination_current_sense_voltage;
+};
+
+enum bq2415x_command {
+=09BQ2415X_WATCHDOG_RESET,
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
+=09BQ2415X_MODE,
+=09BQ2415X_SET_BOOST_MODE,
+=09BQ2415X_SET_CHARGER_MODE,
+
+=09BQ2415X_OTG_HIGH_STATUS,
+=09BQ2415X_OTG_HIGH_ACTIVATE,
+=09BQ2415X_OTG_LOW_ACTIVATE,
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
+enum bq2415x_chip bq2415x_detect_chip(struct bq2415x_device *bq);
+int bq2415x_exec_command(struct bq2415x_device *bq, enum bq2415x_comma=
nd command);
+int bq2415x_set_defaults(struct bq2415x_device *bq);
+int bq2415x_set_current_limit(struct bq2415x_device *bq, int uA);
+int bq2415x_get_current_limit(struct bq2415x_device *bq);
+int bq2415x_set_weak_battery_voltage(struct bq2415x_device *bq, int mV=
);
+int bq2415x_get_weak_battery_voltage(struct bq2415x_device *bq);
+int bq2415x_set_battery_regulation_voltage(struct bq2415x_device *bq, =
int mV);
+int bq2415x_get_battery_regulation_voltage(struct bq2415x_device *bq);=

+int bq2415x_set_charge_current_sense_voltage(struct bq2415x_device *bq=
, int mV);
+int bq2415x_get_charge_current_sense_voltage(struct bq2415x_device *bq=
);
+int bq2415x_set_termination_current_sense_voltage(struct bq2415x_devic=
e *bq, int mV);
+int bq2415x_get_termination_current_sense_voltage(struct bq2415x_devic=
e *bq);
+
+#endif


--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart4786174.Fk5ZdovDLt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7f3UYACgkQi/DJPQPkQ1IDWACcCU+K+YeNLM+m6T2p+wS8stKa
mnwAoMIAiUktq1B7KSKBIuOMtsklfrN8
=DMCu
-----END PGP SIGNATURE-----

--nextPart4786174.Fk5ZdovDLt--

