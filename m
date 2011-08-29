Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1H2RHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:07:07 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:41747 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754443Ab1H2RHD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:07:03 -0400
From: Philip Rakity <prakity@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "adharmap@codeaurora.org" <adharmap@codeaurora.org>,
        "cbou@mail.ru" <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 29 Aug 2011 10:04:02 -0700
Subject: [PATCH 2/3] power: support intersil isl9519q charger driver
Thread-Topic: [PATCH 2/3] power: support intersil isl9519q charger driver
Thread-Index: AcxmbaZhraBf3VJTQ8KqLK6WWF3xow==
Message-ID: <F5DE826D-A9B1-40C0-9293-7A9BBAB94D23@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This code is based on the original work of Abhijeet
Dharmapurikar <adharmap@codeaurora.org>.

The basic driver has been extended to support the
supplied_to and num_supplicants selectors.  These
fields allow the core power infrastructure to signal
to the driver listed in the supplied_to field that
a power change has taken place when that driver
implements the external_power_changed call back.

The isl9519q has been extended to implement this
callback allowing a driver that detects ac on/off
to signal the change to the isl9519q.

In the 9519q the supplied_to field is used to tell
the 9519q what battery device it is supplying power to.
It queries the battery using the properties
CHARGE_TO_USE and VOLTAGE_TO_USE to set the correct
voltage and charge.

In our implementation we have set up the max8925 to
signal ac on/off to the intersil 9519q.  The 9519q
will then use the supplied_to field to query the
battery for power information.

Signed-off-by: Philip Rakity <prakity@marvell.com>
---
 drivers/power/Kconfig                  |    7 +
 drivers/power/Makefile                 |    1 +
 drivers/power/isl9519q.c               |  493 ++++++++++++++++++++++++++++++++
 include/linux/i2c/isl9519.h            |   52 ++++
 include/linux/power/isl9519q_charger.h |   13 +
 5 files changed, 566 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/isl9519q.c
 create mode 100644 include/linux/i2c/isl9519.h
 create mode 100644 include/linux/power/isl9519q_charger.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 57de051..c6fa490 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -249,4 +249,11 @@ config CHARGER_MAX8998
          Say Y to enable support for the battery charger control sysfs and
          platform data of MAX8998/LP3974 PMICs.

+config CHARGER_ISL9519
+       tristate "Intersil ISL9519q battery charger driver"
+       depends on I2C
+       default n
+       help
+         Say Y here to enable support for ISL9519q Battery Charger.ß
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b4af13d..ab86e66 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_CHARGER_TWL4030) += twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)     += gpio-charger.o
 obj-$(CONFIG_CHARGER_MAX8997)  += max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)  += max8998_charger.o
+obj-$(CONFIG_CHARGER_ISL9519)  += isl9519q.o
diff --git a/drivers/power/isl9519q.c b/drivers/power/isl9519q.c
new file mode 100644
index 0000000..685a5aa
--- /dev/null
+++ b/drivers/power/isl9519q.c
@@ -0,0 +1,493 @@
+/* Copyright (c) 2010 Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/i2c/isl9519.h>
+#include <linux/power_supply.h>
+#include <linux/power/isl9519q_charger.h>
+
+#define CHG_CURRENT_REG                0x14
+#define MAX_SYS_VOLTAGE_REG    0x15
+#define CONTROL_REG            0x3D
+#define MIN_SYS_VOLTAGE_REG    0x3E
+#define INPUT_CURRENT_REG      0x3F
+#define MANUFACTURER_ID_REG    0xFE
+#define DEVICE_ID_REG          0xFF
+
+#define TRCKL_CHG_STATUS_BIT   0x80
+#define CONTROL_REG_AC_OK      (1<<6)
+#define ISL9519_CHG_PERIOD     ((HZ) * 150)
+
+struct charger_struct {
+       struct i2c_client *client;
+       struct power_supply     psy;
+       struct delayed_work charge_work;
+
+       int present;
+       int batt_present;
+       bool charging;
+       int chgcurrent;
+       int chgvoltage;
+       int term_current;
+       int max_system_voltage;
+       int min_system_voltage;
+       bool online;
+};
+
+static int isl9519q_read_reg(struct i2c_client *client, int reg, u16 *val)
+{
+       int ret;
+
+       ret = i2c_smbus_read_word_data(client, reg);
+
+       if (ret < 0) {
+               dev_err(&client->dev,
+                       "i2c read fail: can't read from %02x: %d\n", reg, ret);
+               return -EAGAIN;
+       } else
+               *val = ret;
+
+       return 0;
+}
+
+static int isl9519q_write_reg(struct i2c_client *client, int reg,
+       u16 val)
+{
+       int ret;
+       struct charger_struct *isl_chg;
+
+       isl_chg = i2c_get_clientdata(client);
+       ret = i2c_smbus_write_word_data(isl_chg->client, reg, val);
+
+       if (ret < 0) {
+               dev_err(&isl_chg->client->dev,
+                       "i2c write fail: can't write %02x to %02x: %d\n",
+                       val, reg, ret);
+               return -EAGAIN;
+       }
+       return 0;
+}
+
+
+static int isl9519q_start_charging(struct charger_struct *isl_chg)
+{
+       int ret = 0;
+       u16 old_voltage;
+       u16 old_current;
+
+       dev_dbg(&isl_chg->client->dev, "%s\n", __func__);
+
+       ret = isl9519q_read_reg(isl_chg->client, MAX_SYS_VOLTAGE_REG,
+                       &old_voltage);
+
+       ret = isl9519q_read_reg(isl_chg->client, CHG_CURRENT_REG,
+                       &old_current);
+
+       ret = isl9519q_write_reg(isl_chg->client, MAX_SYS_VOLTAGE_REG,
+                       isl_chg->chgvoltage);
+
+       if (ret) {
+               dev_err(&isl_chg->client->dev,
+                       "%s coulnt write to MAX_SYS_VOLTAGE_REG\n", __func__);
+               goto out;
+       }
+       ret = isl9519q_write_reg(isl_chg->client, CHG_CURRENT_REG,
+                               isl_chg->chgcurrent);
+       if (ret) {
+               dev_err(&isl_chg->client->dev,
+                       "%s coulnt write to CHG_CURRENT_REG\n", __func__);
+               goto out;
+       }
+
+       ret = isl9519q_read_reg(isl_chg->client, MAX_SYS_VOLTAGE_REG,
+                       &old_voltage);
+
+       ret = isl9519q_read_reg(isl_chg->client, CHG_CURRENT_REG,
+                       &old_current);
+
+       isl_chg->charging = true;
+
+out:
+       return ret;
+}
+
+static int isl9519q_stop_charging(struct charger_struct *isl_chg)
+{
+       int ret = 0;
+
+       if (!(isl_chg->charging))
+               /* we arent charging */
+               return 0;
+
+       dev_dbg(&isl_chg->client->dev, "%s\n", __func__);
+
+       ret = isl9519q_write_reg(isl_chg->client, CHG_CURRENT_REG, 0);
+       if (ret) {
+               dev_err(&isl_chg->client->dev,
+                       "%s coulnt write to current_reg\n", __func__);
+               goto out;
+       }
+out:
+       return ret;
+}
+
+static void isl9519q_charge(struct work_struct *isl9519_work)
+{
+       struct charger_struct *isl_chg;
+       struct power_supply *psy;
+       union power_supply_propval ret = {0,};
+       int voltage = 0;
+       int charge = 0;
+       int i;
+
+       isl_chg = container_of(isl9519_work, struct charger_struct,
+                       charge_work.work);
+
+       dev_dbg(&isl_chg->client->dev, "%s\n", __func__);
+
+       if (isl_chg->charging) {
+               for (i = 0; i < isl_chg->psy.num_supplicants; i++) {
+                       psy = power_supply_get_by_name
+                               (isl_chg->psy.supplied_to[i]);
+                       if (psy != NULL) {
+                               if (psy->get_property(psy,
+                                       POWER_SUPPLY_PROP_CHARGE_TO_USE, &ret)
+                                               == 0)
+                                       charge = ret.intval;
+
+                               if (psy->get_property(psy,
+                                       POWER_SUPPLY_PROP_VOLTAGE_TO_USE, &ret)
+                                               == 0)
+                                       voltage = ret.intval;
+
+                               if (isl_chg->charging) {
+                                       isl_chg->chgvoltage
+                                               = (voltage / 1000); /* mV */
+                                       isl_chg->chgcurrent
+                                               = (charge / 1000); /* mA */
+                                       isl9519q_start_charging(isl_chg);
+                               }
+                       }
+               }
+               schedule_delayed_work(&isl_chg->charge_work,
+                       ISL9519_CHG_PERIOD);
+       } else
+               isl9519q_stop_charging(isl_chg);
+
+}
+
+static void isl9519q_external_power_changed(struct power_supply *pst)
+{
+       struct charger_struct *isl_chg =
+               container_of(pst, struct charger_struct, psy);
+       u16 temp;
+
+       if (isl9519q_read_reg(isl_chg->client, CONTROL_REG, &temp) < 0) {
+               isl_chg->online = 0;
+               isl_chg->charging = 0;
+       } else {
+               isl_chg->online = 1;
+               if (temp & CONTROL_REG_AC_OK)
+                       isl_chg->charging = 1;
+               else
+                       isl_chg->charging = 0;
+       }
+       if (isl_chg->charging)
+               schedule_delayed_work(&isl_chg->charge_work,
+                       ISL9519_CHG_PERIOD);
+       else
+               cancel_delayed_work(&isl_chg->charge_work);
+
+       power_supply_changed(pst);
+}
+
+
+static int isl9519q_charger_get_property(struct power_supply *psy,
+                               enum power_supply_property psp,
+                               union power_supply_propval *val)
+{
+       struct charger_struct *isl_chg =
+               container_of(psy, struct charger_struct, psy);
+       u16 temp;
+       int ret;
+
+       switch (psp) {
+       case POWER_SUPPLY_PROP_PRESENT:
+               ret = isl9519q_read_reg(isl_chg->client, DEVICE_ID_REG,
+                               &temp);
+
+               isl_chg->present = ret ? 0 : 1;
+               val->intval = isl_chg->present;
+               break;
+       case POWER_SUPPLY_PROP_ONLINE:
+               val->intval = isl_chg->online;
+               break;
+       case POWER_SUPPLY_PROP_VOLTAGE_MAX:
+               ret = isl9519q_read_reg(isl_chg->client, MAX_SYS_VOLTAGE_REG,
+                               &temp);
+               if (ret) {
+                       dev_err(&isl_chg->client->dev,
+                               "%s could not read to MAX_SYS_VOLTAGE_REG"
+                               " ret=%d\n",
+                               __func__, ret);
+                       return -EINVAL;
+               }
+               isl_chg->max_system_voltage = temp;
+               val->intval = temp * 1000; /* convert to uV */
+               break;
+       case POWER_SUPPLY_PROP_VOLTAGE_MIN:
+               ret = isl9519q_read_reg(isl_chg->client, MIN_SYS_VOLTAGE_REG,
+                               &temp);
+               if (ret) {
+                       dev_err(&isl_chg->client->dev,
+                               "%s couldnt read to MIN_SYS_VOLTAGE_REG"
+                               "  ret=%d\n",
+                               __func__, ret);
+                       return -EINVAL;
+               }
+               temp &= 0x2F00;
+               isl_chg->min_system_voltage = temp;
+               val->intval = temp * 1000; /* convert to uV */
+               break;
+       case POWER_SUPPLY_PROP_CHARGE_FULL:
+               val->intval = !isl_chg->charging;
+               break;
+       case POWER_SUPPLY_PROP_MANUFACTURER:
+               val->strval = "Intersil";
+               break;
+       default:
+               return -EINVAL;
+       }
+       return 0;
+}
+
+static enum power_supply_property power_props[] = {
+       POWER_SUPPLY_PROP_PRESENT,
+       POWER_SUPPLY_PROP_ONLINE,
+       POWER_SUPPLY_PROP_VOLTAGE_MAX,
+       POWER_SUPPLY_PROP_VOLTAGE_MIN,
+       POWER_SUPPLY_PROP_CHARGE_FULL,
+       POWER_SUPPLY_PROP_MANUFACTURER,
+};
+
+#define MAX_VOLTAGE_REG_MASK  0x3FF0
+#define MIN_VOLTAGE_REG_MASK  0x3F00
+#define DEFAULT_MAX_VOLTAGE_REG_VALUE  0x1070
+#define DEFAULT_MIN_VOLTAGE_REG_VALUE  0x0D00
+
+static int isl9519q_init_chip(struct i2c_client *client,
+                                   struct charger_struct *isl_chg)
+{
+       int ret;
+       u16 temp;
+
+       isl_chg->max_system_voltage &= MAX_VOLTAGE_REG_MASK;
+       isl_chg->min_system_voltage &= MIN_VOLTAGE_REG_MASK;
+
+       if (isl_chg->max_system_voltage == 0)
+               isl_chg->max_system_voltage = DEFAULT_MAX_VOLTAGE_REG_VALUE;
+       if (isl_chg->min_system_voltage == 0)
+               isl_chg->min_system_voltage = DEFAULT_MIN_VOLTAGE_REG_VALUE;
+
+       ret = isl9519q_write_reg(isl_chg->client, MAX_SYS_VOLTAGE_REG,
+                       isl_chg->max_system_voltage);
+       if (ret) {
+               dev_err(&client->dev,
+                       "%s couldnt write to MAX_SYS_VOLTAGE_REG ret=%d\n",
+                       __func__, ret);
+               goto exit;
+       }
+
+       ret = isl9519q_write_reg(isl_chg->client, MIN_SYS_VOLTAGE_REG,
+                       isl_chg->min_system_voltage);
+       if (ret) {
+               dev_err(&client->dev,
+                       "%s couldnt write to MIN_SYS_VOLTAGE_REG ret=%d\n",
+                       __func__, ret);
+               goto exit;
+       }
+
+       ret = isl9519q_read_reg(isl_chg->client, CONTROL_REG,
+                       &temp);
+       if (temp & CONTROL_REG_AC_OK)
+               isl_chg->charging = 1;
+       else
+               isl_chg->charging = 0;
+exit:
+       return ret;
+}
+
+static int __devinit isl9519q_probe(struct i2c_client *client,
+                                   const struct i2c_device_id *id)
+{
+       struct isl9519q_platform_data *pdata;
+       struct charger_struct *isl_chg;
+       int ret;
+
+       ret = 0;
+       pdata = client->dev.platform_data;
+
+       if (pdata == NULL) {
+               dev_err(&client->dev, "%s no platform data\n", __func__);
+               ret = -EINVAL;
+               goto out;
+       }
+
+       if (!i2c_check_functionality(client->adapter,
+                               I2C_FUNC_SMBUS_WORD_DATA)) {
+               ret = -EIO;
+               goto out;
+       }
+
+       isl_chg = kzalloc(sizeof(*isl_chg), GFP_KERNEL);
+       if (!isl_chg) {
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       INIT_DELAYED_WORK(&isl_chg->charge_work, isl9519q_charge);
+       isl_chg->client = client;
+       isl_chg->chgcurrent = pdata->chgcurrent;
+       isl_chg->term_current = pdata->term_current;
+       isl_chg->max_system_voltage = pdata->max_system_voltage;
+       isl_chg->min_system_voltage = pdata->min_system_voltage;
+
+       /* h/w ignores lower 7 bits of charging current */
+       isl_chg->chgcurrent &= ~0x7F;
+
+       isl_chg->psy.name = "isl-adapter";
+       isl_chg->psy.type = POWER_SUPPLY_TYPE_MAINS;
+       isl_chg->psy.properties = power_props;
+       isl_chg->psy.num_properties = ARRAY_SIZE(power_props);
+       isl_chg->psy.get_property = isl9519q_charger_get_property;
+       isl_chg->psy.supplied_to = pdata->supplied_to;
+       isl_chg->psy.num_supplicants = pdata->num_supplicants;
+       isl_chg->psy.external_power_changed = isl9519q_external_power_changed;
+
+       i2c_set_clientdata(client, isl_chg);
+       ret = isl9519q_init_chip(client, isl_chg);
+       if (ret)
+               goto free_isl_chg;
+       ret = power_supply_register(&client->dev, &isl_chg->psy);
+       if (ret)
+               goto free_isl_chg;
+
+       if (pdata->chg_detection_config) {
+               ret = pdata->chg_detection_config();
+               if (ret) {
+                       dev_err(&client->dev, "%s valid config failed ret=%d\n",
+                               __func__, ret);
+                       goto free_isl_chg;
+               }
+       }
+       schedule_delayed_work(&isl_chg->charge_work,
+               ISL9519_CHG_PERIOD);
+       return 0;
+
+free_isl_chg:
+       kfree(isl_chg);
+out:
+       return ret;
+}
+
+static int __devexit isl9519q_remove(struct i2c_client *client)
+{
+       struct isl9519q_platform_data *pdata;
+       struct charger_struct *isl_chg = i2c_get_clientdata(client);
+       kfree(isl_chg);
+       pdata = client->dev.platform_data;
+       return 0;
+}
+
+static const struct i2c_device_id isl9519q_id[] = {
+       {"isl9519q", 0},
+       {},
+};
+
+#ifdef CONFIG_PM
+static int isl9519q_suspend(struct i2c_client *client,
+               pm_message_t state)
+{
+       struct charger_struct *isl_chg = i2c_get_clientdata(client);
+
+       dev_dbg(&isl_chg->client->dev, "%s\n", __func__);
+       return 0;
+}
+
+static int isl9519q_resume(struct i2c_client *client)
+{
+       struct charger_struct *isl_chg = i2c_get_clientdata(client);
+       u16 temp;
+       int ret;
+
+       dev_dbg(&isl_chg->client->dev, "%s\n", __func__);
+
+       ret = isl9519q_read_reg(isl_chg->client, CONTROL_REG,
+                       &temp);
+       if (!ret && (temp & CONTROL_REG_AC_OK)) {
+                       isl_chg->charging = 1;
+                       schedule_delayed_work(&isl_chg->charge_work,
+                               ISL9519_CHG_PERIOD);
+       } else {
+               isl_chg->charging = 0;
+               isl9519q_stop_charging(isl_chg);
+               cancel_delayed_work(&isl_chg->charge_work);
+       }
+       return 0;
+}
+#endif
+
+static struct i2c_driver isl9519q_driver = {
+       .driver = {
+                  .name = "isl9519q",
+                  .owner = THIS_MODULE,
+       },
+       .probe          = isl9519q_probe,
+#ifdef CONFIG_PM
+       .suspend        = isl9519q_suspend,
+       .resume         = isl9519q_resume,
+#endif
+       .remove = __devexit_p(isl9519q_remove),
+       .id_table = isl9519q_id,
+};
+
+static int __init isl9519q_init(void)
+{
+       return i2c_add_driver(&isl9519q_driver);
+}
+
+module_init(isl9519q_init);
+
+static void __exit isl9519q_exit(void)
+{
+       return i2c_del_driver(&isl9519q_driver);
+}
+
+module_exit(isl9519q_exit);
+
+MODULE_AUTHOR("Abhijeet Dharmapurikar <adharmap@codeaurora.org>");
+MODULE_DESCRIPTION("Driver for ISL9519Q Charger chip");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/i2c/isl9519.h b/include/linux/i2c/isl9519.h
new file mode 100644
index 0000000..6814ef0
--- /dev/null
+++ b/include/linux/i2c/isl9519.h
@@ -0,0 +1,52 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above
+ *       copyright notice, this list of conditions and the following
+ *       disclaimer in the documentation and/or other materials provided
+ *       with the distribution.
+ *     * Neither the name of Code Aurora Forum, Inc. nor the names of its
+ *       contributors may be used to endorse or promote products derived
+ *       from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+#ifndef __ISL9519_H__
+#define __ISL9519_H__
+
+/**
+ * struct isl_platform_data
+ * @chgcurrent max current the islchip can draw
+ * @valid_irq                  interrupt for insertion/removal notification
+ * @valid_n_gpio               gpio to debounce insertion/removal
+ * @valid_config               machine specific func to configure gpio line
+ * @max_system_voltage         the max voltage isl should charge battery to
+ * @min_system_voltage         the min voltage isl should trkl charge the
+ *                             battery
+ * @term_current               the battery current when isl charging should stop
+ */
+struct isl_platform_data {
+       int chgcurrent;
+       int valid_n_gpio;
+       int (*chg_detection_config) (void);
+       int max_system_voltage;
+       int min_system_voltage;
+       int term_current;
+};
+
+#endif
diff --git a/include/linux/power/isl9519q_charger.h b/include/linux/power/isl9519q_charger.h
new file mode 100644
index 0000000..dccf1f2
--- /dev/null
+++ b/include/linux/power/isl9519q_charger.h
@@ -0,0 +1,13 @@
+#ifndef __ISL9519Q_CHARGER_H_
+#define __ISL9519Q_CHARGER_H_
+
+struct isl9519q_platform_data {
+       char **supplied_to;
+       int num_supplicants;
+       u16 chgcurrent;
+       u16 term_current;
+       u16 max_system_voltage;
+       u16 min_system_voltage;
+       int (*chg_detection_config) (void);
+};
+#endif
--
1.7.6


