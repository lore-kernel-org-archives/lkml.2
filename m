Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1IAJDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:03:10 -0400
Received: from mail2.nsc.com ([12.238.8.132]:55771 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756497Ab1IAJDF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:03:05 -0400
X-Greylist: delayed 1096 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Sep 2011 05:03:05 EDT
X-WSS-ID: 0LQU5MI-0A-5T3-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@nsc.com>
To: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cbou@mail.ru" <cbou@mail.ru>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Date: Thu, 1 Sep 2011 01:44:32 -0700
Subject: [PATCH] power_supply: Add LP8727 charger driver
Thread-Topic: [PATCH] power_supply: Add LP8727 charger driver
Thread-Index: Acxofvecfs/0jOLoTxWKdTEC+CQe5gAAjBHw
Message-ID: <B567DBAB974C0544994013492B949F8E380F520DE9@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 62419A791LS6212822-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Anton Vorontsov

This patch supports the LP8727 charger driver.

* General features
National Semiconductor LP8727 is the battery charger with Micro/Mini USB interface.
This IC includes below functions
- I2C interface for accessing user registers
- Single input Li-Ion battery charger
- Charger input ID detection from Micro/Mini USB
- Multiplexing switches on USB, UART

* Driver Description
1) Interrupt
        When the charger events occur(attached/detached), the LP8727 generates the interrupt.
        Then the host will read 2 interrupt registers and do ID detection, multiplexing switches and updating power supplies.
        It takes few debounce time (about 270ms) to get updated status.

2) ID detection
        LP8727 detects the charger and the device ID is updated in register area.
        Available device ID : TA(Travel Adaptor), Dedicated charger, USB charger and USB downstream

3) Power supplies
        Three power supplies are registered when LP8727 driver is detected.
        - AC : adapter
        - USB : USB charger
        - Battery : Li-On battery

        AC and USB are supplied to the battery.
        Charging parameters can be set as changed charger type.
        For this function, 'external_power_changed()' and 'supplied_to' are used.

4) Platform data for lp8727
        There are two reason for providing lp8727 platform data.

        a) Supporting limited power supply properties
        LP8727 doesn't support the fuel gauging and no way to check whether battery exists or not.
        So below properties can't be read from the LP8727 registers
        - POWER_SUPPLY_PROP_PRESENT
        - POWER_SUPPLY_PROP_VOLTAGE_NOW
        - POWER_SUPPLY_PROP_CAPACITY
        - POWER_SUPPLY_PROP_TEMP

        If the system has fuel gauging and battery detection,
        then I would recommend mapping functions in the platform data when adding i2c device.

        Ex) static struct lp8727_platform_data lp8727_chg_pdata = {
                .get_batt_present = dummy_get_batt_present,
                .get_batt_level = dummy_get_batt_level;
                .get_batt_capacity = dummy_get_batt_capacity,
                .get_batt_temp = dummy_get_batt_temp,
                ...
        };

        When user-space gets battery properties, the mapping function is called.

        Ex) static int lp8727_battery_get_property(struct power_supply *psy,
                                                                enum power_supply_property psp,
                                                                union power_supply_propval *val)
        {
                struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);

                ...

                // dummy_get_batt_level() will be called
                case POWER_SUPPLY_PROP_VOLTAGE_NOW:
                        if(pchg->pdata->get_batt_level)
                                val->intval = pchg->pdata->get_batt_level();
                break;

                ...
        }

        b) Supporting platform specific charging parameters
        The values of EOC(End of Charge) and charging current depend on the charger type.(ac or usb)
        For example, during charging battery with ac adaptor, eoc level is 10% of Vterm and charging current is 400mA.
        (Vterm : charging termination voltage)
        But with USB charger, charging current is set to 500mA.
        This value is platform specific data.

        Ex) static struct lp8727_platform_data lp8727_chg_pdata = {
                ...

                .ac = {
                        .eoc_level = EOC_10P,
                        .ichg = ICHG_400mA,
                },
                .usb = {
                        .eoc_level = EOC_10P,
                        .ichg = ICHG_500mA,
                },
        };

        Then this value will be updated after power_supply_changed() is called.

        Ex) static void lp8727_charger_changed(struct power_supply *psy)
        {
                ...
                eoc_level = pchg->chg_parm->eoc_level;
                ichg = pchg->chg_parm->ichg;
                val = (ichg << 4) | eoc_level;
                 (void)lp8727_i2c_write(pchg, CHGCTRL2, &val, 1);
                ...
        }

* Tested on OMAP3530 board

Signed-off-by: Woogyom Kim <milo.kim@nsc.com>

>From 5cd83ea3e0051ef2c2ce86189e9f1cd6bbb1577f Mon Sep 17 00:00:00 2001
From: Woogyom Kim <milo.kim@nsc.com>
Date: Thu, 1 Sep 2011 17:05:42 +0900
Subject: [PATCH] Add National LP8727 charger driver

LP8727 is the battery charger with Micro/Mini USB interface.
This IC includes below functions
 - I2c interface for accessing user registers
 - Single input Li-Ion battery charger
 - Charger input ID detection from Micro/Mini USB
 - multiplexing switches on USB, UART
---
 drivers/power/Kconfig          |    6 +
 drivers/power/Makefile         |    1 +
 drivers/power/lp8727_charger.c |  478 ++++++++++++++++++++++++++++++++++++++++
 include/linux/lp8727.h         |   54 +++++
 4 files changed, 539 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/lp8727_charger.c
 create mode 100644 include/linux/lp8727.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 57de051..51cb302 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -249,4 +249,10 @@ config CHARGER_MAX8998
          Say Y to enable support for the battery charger control sysfs and
          platform data of MAX8998/LP3974 PMICs.

+config CHARGER_LP8727
+       tristate "National Semiconductor LP8727 charger driver"
+       depends on I2C
+       help
+         Say Y here to enable support for LP8727 Charger Driver.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b4af13d..aed6098 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -38,3 +38,4 @@ obj-$(CONFIG_CHARGER_TWL4030) += twl4030_charger.o
 obj-$(CONFIG_CHARGER_GPIO)     += gpio-charger.o
 obj-$(CONFIG_CHARGER_MAX8997)  += max8997_charger.o
 obj-$(CONFIG_CHARGER_MAX8998)  += max8998_charger.o
+obj-$(CONFIG_CHARGER_LP8727)   += lp8727_charger.o
diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
new file mode 100644
index 0000000..a4b504c
--- /dev/null
+++ b/drivers/power/lp8727_charger.c
@@ -0,0 +1,478 @@
+/*
+ * Driver for LP8727 Micro/Mini USB IC with intergrated charger
+ *
+ *                     Copyright (C) 2011 National Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/power_supply.h>
+#include <linux/lp8727.h>
+
+#define DEBOUNCE_MSEC  270
+
+/* Registers */
+#define CTRL1          0x1
+#define CTRL2          0x2
+#define SWCTRL         0x3
+#define INT1           0x4
+#define INT2           0x5
+#define STATUS1        0x6
+#define STATUS2        0x7
+#define CHGCTRL2       0x9
+
+/* CTRL1 register */
+#define CP_EN          (1 << 0)
+#define ADC_EN         (1 << 1)
+#define ID200_EN       (1 << 4)
+
+/* CTRL2 register */
+#define CHGDET_EN      (1 << 1)
+#define INT_EN         (1 << 6)
+
+/* SWCTRL register */
+#define SW_DM1_DM      (0x0 << 0)
+#define SW_DM1_U1      (0x1 << 0)
+#define SW_DM1_HiZ     (0x7 << 0)
+#define SW_DP2_DP      (0x0 << 3)
+#define SW_DP2_U2      (0x1 << 3)
+#define SW_DP2_HiZ     (0x7 << 3)
+
+/* INT1 register */
+#define IDNO           (0xF << 0)
+#define VBUS           (1 << 4)
+
+/* STATUS1 register */
+#define CHGSTAT        (3 << 4)
+#define CHPORT         (1 << 6)
+#define DCPORT         (1 << 7)
+
+/* STATUS2 register */
+#define TEMP_STAT      (3 << 5)
+
+enum lp8727_dev_id {
+       ID_NONE,
+       ID_TA,
+       ID_DEDICATED_CHG,
+       ID_USB_CHG,
+       ID_USB_DS,
+       ID_MAX,
+};
+
+enum lp8727_chg_stat {
+       PRECHG,
+       CC,
+       CV,
+       EOC,
+};
+
+struct lp8727_psy {
+       struct power_supply ac;
+       struct power_supply usb;
+       struct power_supply batt;
+};
+
+struct lp8727_chg {
+       struct device   *dev;
+       struct i2c_client       *client;
+       struct mutex    xfer_lock;
+       struct delayed_work     work;
+       struct workqueue_struct *irqthread;
+       struct lp8727_platform_data     *pdata;
+       struct lp8727_psy       *psy;
+       struct lp8727_chg_param *chg_parm;
+       enum lp8727_dev_id      devid;
+};
+
+static int lp8727_i2c_read(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
+{
+       s32 ret;
+
+       mutex_lock(&pchg->xfer_lock);
+       ret = i2c_smbus_read_i2c_block_data(pchg->client, reg, len, data);
+       mutex_unlock(&pchg->xfer_lock);
+
+       return (ret != len) ? -EIO : 0;
+}
+
+static int lp8727_i2c_write(struct lp8727_chg *pchg, u8 reg, u8 *data, u8 len)
+{
+       s32 ret;
+
+       mutex_lock(&pchg->xfer_lock);
+       ret = i2c_smbus_write_i2c_block_data(pchg->client, reg, len, data);
+       mutex_unlock(&pchg->xfer_lock);
+
+       return ret;
+}
+
+static int lp8727_is_charger_attached(const char *name, int id)
+{
+       if(name) {
+               if(!strcmp(name, "ac"))
+                       return (id == ID_TA || id == ID_DEDICATED_CHG) ? 1 : 0;
+               else if(!strcmp(name, "usb"))
+                       return (id == ID_USB_CHG) ? 1 : 0;
+       }
+
+       return (id >= ID_TA && id <= ID_USB_CHG) ? 1 : 0;
+}
+
+static void lp8727_init_device(struct lp8727_chg *pchg)
+{
+       u8 val;
+
+       val = ID200_EN | ADC_EN | CP_EN;
+       if(lp8727_i2c_write(pchg, CTRL1, &val, 1))
+               dev_err(pchg->dev, "i2c write err : addr=0x%.2x\n", CTRL1);
+
+       val = INT_EN | CHGDET_EN;
+       if(lp8727_i2c_write(pchg, CTRL2, &val, 1))
+               dev_err(pchg->dev, "i2c write err : addr=0x%.2x\n", CTRL2);
+}
+
+static int lp8727_is_dedicated_charger(struct lp8727_chg *pchg)
+{
+       u8 val;
+       (void)lp8727_i2c_read(pchg, STATUS1, &val, 1);
+       return (val & DCPORT);
+}
+
+static int lp8727_is_usb_charger(struct lp8727_chg *pchg)
+{
+       u8 val;
+       (void)lp8727_i2c_read(pchg, STATUS1, &val, 1);
+       return (val & CHPORT);
+}
+
+static void lp8727_ctrl_switch(struct lp8727_chg *pchg, u8 sw)
+{
+       u8 val = sw;
+       (void)lp8727_i2c_write(pchg, SWCTRL, &val, 1);
+}
+
+static void lp8727_id_detection(struct lp8727_chg *pchg, u8 id, int vbusin)
+{
+       u8 devid = ID_NONE;
+       u8 swctrl = SW_DM1_HiZ | SW_DP2_HiZ;
+
+       switch(id) {
+       case 0x5:
+               devid = ID_TA;
+               pchg->chg_parm = &pchg->pdata->ac;
+               break;
+       case 0xB:
+               if(lp8727_is_dedicated_charger(pchg)) {
+                       pchg->chg_parm = &pchg->pdata->ac;
+                       devid = ID_DEDICATED_CHG;
+               } else if(lp8727_is_usb_charger(pchg)) {
+                       pchg->chg_parm = &pchg->pdata->usb;
+                       devid = ID_USB_CHG;
+                       swctrl = SW_DM1_DM | SW_DP2_DP;
+               } else if(vbusin) {
+                       devid = ID_USB_DS;
+                       swctrl = SW_DM1_DM | SW_DP2_DP;
+               }
+               break;
+       default:
+               devid = ID_NONE;
+               pchg->chg_parm = NULL;
+               break;
+       }
+
+       pchg->devid = devid;
+       lp8727_ctrl_switch(pchg, swctrl);
+}
+
+static void lp8727_enable_chgdet(struct lp8727_chg *pchg)
+{
+       u8 val;
+
+       (void)lp8727_i2c_read(pchg, CTRL2, &val, 1);
+       val |= CHGDET_EN;
+       (void)lp8727_i2c_write(pchg, CTRL2, &val, 1);
+}
+
+static void lp8727_delayed_func(struct work_struct *_work)
+{
+       u8 intstat[2];
+       u8 idno;
+       u8 vbus;
+       struct lp8727_chg *pchg =
+               container_of(_work, struct lp8727_chg, work.work);
+
+       lp8727_i2c_read(pchg, INT1, intstat, 2);
+
+       idno = intstat[0] & IDNO;
+       vbus = intstat[0] & VBUS;
+
+       lp8727_id_detection(pchg, idno, vbus);
+       lp8727_enable_chgdet(pchg);
+
+       power_supply_changed(&pchg->psy->ac);
+       power_supply_changed(&pchg->psy->usb);
+       power_supply_changed(&pchg->psy->batt);
+}
+
+static irqreturn_t lp8727_isr_func(int irq, void *ptr)
+{
+       struct lp8727_chg *pchg = ptr;
+       unsigned long delay = msecs_to_jiffies(DEBOUNCE_MSEC);
+
+       queue_delayed_work(pchg->irqthread, &pchg->work, delay);
+
+       return IRQ_HANDLED;
+}
+
+static void lp8727_intr_config(struct lp8727_chg *pchg)
+{
+       INIT_DELAYED_WORK(&pchg->work, lp8727_delayed_func);
+       pchg->irqthread = create_singlethread_workqueue("lp8727-irqthd");
+
+       if(!pchg->irqthread)
+               dev_err(pchg->dev, "can not create thread for lp8727\n");
+
+       if(request_threaded_irq(pchg->client->irq,
+                               NULL,
+                               lp8727_isr_func,
+                               IRQF_TRIGGER_FALLING,
+                               "lp8727_irq",
+                               pchg)) {
+               dev_err(pchg->dev, "lp8727 irq can not be registered\n");
+       }
+}
+
+static enum power_supply_property lp8727_charger_prop[] = {
+       POWER_SUPPLY_PROP_ONLINE,
+};
+
+static enum power_supply_property lp8727_battery_prop[] = {
+       POWER_SUPPLY_PROP_STATUS,
+       POWER_SUPPLY_PROP_HEALTH,
+       POWER_SUPPLY_PROP_PRESENT,
+       POWER_SUPPLY_PROP_VOLTAGE_NOW,
+       POWER_SUPPLY_PROP_CAPACITY,
+       POWER_SUPPLY_PROP_TEMP,
+};
+
+static char *battery_supplied_to[] = {
+       "main_batt",
+};
+
+static int lp8727_charger_get_property(struct power_supply *psy,
+                                       enum power_supply_property psp,
+                                       union power_supply_propval *val)
+{
+       struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
+
+       if(psp == POWER_SUPPLY_PROP_ONLINE) {
+               val->intval = lp8727_is_charger_attached(psy->name,
+                                                       pchg->devid);
+       }
+
+       return 0;
+}
+
+static int lp8727_battery_get_property(struct power_supply *psy,
+                                       enum power_supply_property psp,
+                                       union power_supply_propval *val)
+{
+       struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
+       u8 read;
+
+       switch(psp) {
+       case POWER_SUPPLY_PROP_STATUS:
+               if(lp8727_is_charger_attached(psy->name, pchg->devid)) {
+                       (void)lp8727_i2c_read(pchg, STATUS1, &read, 1);
+                       if(((read & CHGSTAT) >> 4) == EOC)
+                               val->intval = POWER_SUPPLY_STATUS_FULL;
+                       else
+                               val->intval = POWER_SUPPLY_STATUS_CHARGING;
+               } else {
+                       val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+               }
+               break;
+       case POWER_SUPPLY_PROP_HEALTH:
+               (void)lp8727_i2c_read(pchg, STATUS2, &read, 1);
+               read = (read & TEMP_STAT) >> 5;
+               if(read >= 0x1 && read <= 0x3)
+                       val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+               else
+                       val->intval = POWER_SUPPLY_HEALTH_GOOD;
+               break;
+       case POWER_SUPPLY_PROP_PRESENT:
+               if(pchg->pdata->get_batt_present)
+                       val->intval = pchg->pdata->get_batt_present();
+               break;
+       case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+               if(pchg->pdata->get_batt_level)
+                       val->intval = pchg->pdata->get_batt_level();
+               break;
+       case POWER_SUPPLY_PROP_CAPACITY:
+               if(pchg->pdata->get_batt_capacity)
+                       val->intval = pchg->pdata->get_batt_capacity();
+               break;
+       case POWER_SUPPLY_PROP_TEMP:
+               if(pchg->pdata->get_batt_temp)
+                       val->intval = pchg->pdata->get_batt_temp();
+               break;
+       default:
+               break;
+       }
+
+       return 0;
+}
+
+static void lp8727_charger_changed(struct power_supply *psy)
+{
+       struct lp8727_chg *pchg = dev_get_drvdata(psy->dev->parent);
+       u8 val;
+       u8 eoc_level, ichg;
+
+       if(lp8727_is_charger_attached(psy->name, pchg->devid)) {
+               if(pchg->chg_parm) {
+                       eoc_level = pchg->chg_parm->eoc_level;
+                       ichg = pchg->chg_parm->ichg;
+                       val = (ichg << 4) | eoc_level;
+                       (void)lp8727_i2c_write(pchg, CHGCTRL2, &val, 1);
+               }
+       }
+}
+
+static int lp8727_register_psy(struct lp8727_chg *pchg)
+{
+       struct lp8727_psy *psy;
+
+       psy = kzalloc(sizeof(*psy), GFP_KERNEL);
+       if(!psy)
+               goto err_mem;
+
+       pchg->psy = psy;
+
+       psy->ac.name = "ac";
+       psy->ac.type = POWER_SUPPLY_TYPE_MAINS;
+       psy->ac.properties = lp8727_charger_prop;
+       psy->ac.num_properties = ARRAY_SIZE(lp8727_charger_prop);
+       psy->ac.get_property = lp8727_charger_get_property;
+       psy->ac.supplied_to = battery_supplied_to;
+       psy->ac.num_supplicants = ARRAY_SIZE(battery_supplied_to);
+
+       if(power_supply_register(pchg->dev, &psy->ac))
+               goto err_psy;
+
+       psy->usb.name = "usb";
+       psy->usb.type = POWER_SUPPLY_TYPE_USB;
+       psy->usb.properties = lp8727_charger_prop;
+       psy->usb.num_properties = ARRAY_SIZE(lp8727_charger_prop);
+       psy->usb.get_property = lp8727_charger_get_property;
+       psy->usb.supplied_to = battery_supplied_to;
+       psy->usb.num_supplicants = ARRAY_SIZE(battery_supplied_to);
+
+       if(power_supply_register(pchg->dev, &psy->usb))
+               goto err_psy;
+
+       psy->batt.name = "main_batt";
+       psy->batt.type = POWER_SUPPLY_TYPE_BATTERY;
+       psy->batt.properties = lp8727_battery_prop;
+       psy->batt.num_properties = ARRAY_SIZE(lp8727_battery_prop);
+       psy->batt.get_property = lp8727_battery_get_property;
+       psy->batt.external_power_changed = lp8727_charger_changed;
+
+       if(power_supply_register(pchg->dev, &psy->batt))
+               goto err_psy;
+
+       return 0;
+
+err_mem:
+       return -ENOMEM;
+err_psy:
+       kfree(psy);
+       return -EPERM;
+}
+
+static void lp8727_unregister_psy(struct lp8727_chg *pchg)
+{
+       struct lp8727_psy *psy = pchg->psy;
+
+       if(psy) {
+               power_supply_unregister(&psy->ac);
+               power_supply_unregister(&psy->usb);
+               power_supply_unregister(&psy->batt);
+               kfree(psy);
+       }
+}
+
+static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+       struct lp8727_chg *pchg;
+       int ret;
+
+       pchg = kzalloc(sizeof(*pchg), GFP_KERNEL);
+       if(!pchg)
+               return -ENOMEM;
+
+       pchg->client = cl;
+       pchg->dev = &cl->dev;
+       pchg->pdata = cl->dev.platform_data;
+       i2c_set_clientdata(cl, pchg);
+       mutex_init(&pchg->xfer_lock);
+
+       lp8727_init_device(pchg);
+       lp8727_intr_config(pchg);
+
+       ret = lp8727_register_psy(pchg);
+       if(ret) {
+               dev_err(pchg->dev,
+                       "can not register power supplies. err=%d", ret);
+       }
+
+       return 0;
+}
+
+static int __devexit lp8727_remove(struct i2c_client *cl)
+{
+       struct lp8727_chg *pchg = i2c_get_clientdata(cl);
+
+       lp8727_unregister_psy(pchg);
+       free_irq(pchg->client->irq, pchg);
+       flush_workqueue(pchg->irqthread);
+       destroy_workqueue(pchg->irqthread);
+       kfree(pchg);
+       return 0;
+}
+
+static const struct i2c_device_id lp8727_ids[] = {
+       {"lp8727", 0},
+};
+
+static struct i2c_driver lp8727_driver = {
+       .driver = {
+               .name = "lp8727",
+       },
+       .probe = lp8727_probe,
+       .remove = __devexit_p(lp8727_remove),
+       .id_table = lp8727_ids,
+};
+
+static int __init lp8727_init(void)
+{
+       return i2c_add_driver(&lp8727_driver);
+}
+module_init(lp8727_init);
+
+static void __exit lp8727_chg_exit(void)
+{
+       i2c_del_driver(&lp8727_driver);
+}
+module_exit(lp8727_chg_exit);
+
+MODULE_DESCRIPTION("National Semiconductor LP8727 charger driver");
+MODULE_AUTHOR("Woogyom Kim <milo.kim@nsc.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
new file mode 100644
index 0000000..b779d0d
--- /dev/null
+++ b/include/linux/lp8727.h
@@ -0,0 +1,54 @@
+/*
+ * lp8727.h - Driver for LP8727 Micro/Mini USB IC with intergrated charger
+ *
+ *                     Copyright (C) 2011 National Semiconductor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LP8727_H
+#define _LP8727_H
+
+enum lp8727_eoc_level {
+       EOC_5P,
+       EOC_10P,
+       EOC_16P,
+       EOC_20P,
+       EOC_25P,
+       EOC_33P,
+       EOC_50P,
+};
+
+enum lp8727_ichg {
+       ICHG_90mA,
+       ICHG_100mA,
+       ICHG_400mA,
+       ICHG_450mA,
+       ICHG_500mA,
+       ICHG_600mA,
+       ICHG_700mA,
+       ICHG_800mA,
+       ICHG_900mA,
+       ICHG_1000mA,
+};
+
+struct lp8727_chg_param {
+       /* end of charge level setting */
+       enum lp8727_eoc_level eoc_level;
+       /* charging current */
+       enum lp8727_ichg ichg;
+};
+
+struct lp8727_platform_data {
+       u8      (*get_batt_present)(void);
+       u16     (*get_batt_level)(void);
+       u8      (*get_batt_capacity)(void);
+       u8      (*get_batt_temp)(void);
+       struct lp8727_chg_param ac;
+       struct lp8727_chg_param usb;
+};
+
+#endif
--
1.7.1

Thank you for your help.

Best Regards
Woogyom Kim
milo.kim@nsc.com


