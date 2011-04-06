Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1DFNbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:31:53 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:10218
	"EHLO CH1EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755870Ab1DFNbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:31:51 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2cK936eK9370Jc8kzz1202hzz8275bh84d07hz32i2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Wed, 6 Apr 2011 19:01:34 +0530
Subject: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
Thread-Index: Acv0XvK1OKmvhxUWSZG+OHbi1oLHuw==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC245@KCINPUNHJCMS01.kpit.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p36DW51t001103

Hi Mark,

MFD Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. read and write operation moved into MFD
. implemented gen irq

Some additional information of this patch:
. This patch is thoroughly tested with the Samsung 6410 board using I2C connectivity.
. Determination of I2C and SPI connectivity is done at runtime.

Linux Kernel Version: 2.6.37

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur orig_linux-2.6.37/drivers/mfd/da9052-core.c linux-2.6.37/drivers/mfd/da9052-core.c
--- orig_linux-2.6.37/drivers/mfd/da9052-core.c 1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/mfd/da9052-core.c      2011-03-31 22:17:07.000000000 +0500
@@ -0,0 +1,505 @@
+/*
+ * da9052-core.c  --  Device access for Dialog DA9052 PMICs
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/irq.h>
+#include <linux/mfd/da9052/pdata.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/hwmon.h>
+
+#define DA9052_SUBDEV(_name, _pdata, _pdata_sz, _res, _res_sz) \
+       {                                       \
+               .name = "da9052-"#_name,        \
+               .platform_data = _pdata,        \
+               .data_size = _pdata_sz,         \
+               .num_resources = _res_sz,               \
+               .resources = _res,              \
+       }
+
+int da9052_adc_manual_read(struct da9052 *da9052,
+                       unsigned char channel)
+{
+       unsigned char timeout_cnt = 8;
+       unsigned short calc_data;
+       int ret;
+       u16 data = 0;
+       u8 mux_sel = 0;
+
+       switch (channel) {
+       case DA9052_ADC_VDDOUT:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_VDDOUT;
+               break;
+       case DA9052_ADC_ICH:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_ICH;
+               break;
+       case DA9052_ADC_TBAT:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_TBAT;
+               break;
+        case DA9052_ADC_VBAT:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_VBAT;
+               break;
+       case DA9052_ADC_IN4:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_AD4;
+               break;
+       case DA9052_ADC_IN5:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_AD5;
+               break;
+       case DA9052_ADC_IN6:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_AD6;
+               break;
+       case DA9052_ADC_VBBAT:
+               mux_sel = DA9052_ADC_MAN_MUXSEL_VBBAT;
+               break;
+       default:
+               return -EINVAL;
+       }
+
+       mux_sel |= DA9052_ADC_MAN_MAN_CONV;
+
+       ret = da9052_reg_write(da9052, DA9052_ADC_MAN_REG,
+                                       mux_sel);
+               if (ret < 0)
+                       return ret;
+
+       do {
+               msleep(10);
+
+               ret = da9052_reg_read(da9052, DA9052_ADC_MAN_REG);
+               if (ret < 0)
+                       return ret;
+
+               timeout_cnt--;
+               if (timeout_cnt == 1) {
+                       if (!(ret & DA9052_ADC_MAN_MAN_CONV))
+                               break;
+                       else
+                               return -EIO;
+               }
+       } while (ret & DA9052_ADC_MAN_MAN_CONV);
+
+       ret = 0;
+       ret = da9052_reg_read(da9052, DA9052_ADC_RES_H_REG);
+       if (ret < 0)
+               return ret;
+
+       calc_data = (unsigned short)ret;
+       data = (calc_data << 2);
+
+       ret = 0;
+       ret = da9052_reg_read(da9052, DA9052_ADC_RES_L_REG);
+       if (ret < 0)
+               return ret;
+
+       calc_data = (unsigned short)ret & DA9052_ADC_RES_LSB;
+       data |= calc_data;
+
+       return data;
+
+}
+EXPORT_SYMBOL(da9052_adc_manual_read);
+
+int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
+{
+       unsigned char val;
+
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->read_dev == NULL ) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->read_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return val;
+}
+EXPORT_SYMBOL_GPL(da9052_reg_read);
+
+int da9052_reg_write( struct da9052 *da9052, unsigned char reg,
+                     unsigned char val)
+{
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->write_dev == NULL ) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->write_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_reg_write);
+
+int da9052_group_read(struct da9052 *da9052, unsigned char reg,
+                     unsigned reg_cnt, unsigned char *val)
+{
+
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->read_dev == NULL ) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->read_dev(da9052, reg, reg_cnt, val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_group_read);
+
+int da9052_group_write( struct da9052 *da9052, unsigned char reg,
+                      unsigned reg_cnt, unsigned char *val )
+{
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->write_dev == NULL ) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->write_dev(da9052, reg, reg_cnt, val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_group_write);
+
+int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
+                    unsigned char bit_mask, unsigned char reg_val)
+{
+
+       unsigned char val;
+
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->read_dev == NULL || da9052->write_dev == NULL) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->read_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       val &= ~bit_mask;
+       val |= reg_val;
+
+       if ( da9052->write_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_reg_update);
+
+int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
+                    unsigned char bit_mask)
+{
+
+       unsigned char val;
+
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->read_dev == NULL || da9052->write_dev == NULL) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->read_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       val |= bit_mask;
+
+       if ( da9052->write_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_set_bits);
+
+int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
+                   unsigned char bit_mask)
+{
+       unsigned char val;
+
+       if( reg > DA9052_MAX_REG_CNT ) {
+               dev_err(da9052->dev, "invalid reg %x\n", reg);
+               return -EINVAL;
+       }
+
+       mutex_lock(&da9052->io_lock);
+
+       if ( da9052->read_dev == NULL || da9052->write_dev == NULL) {
+               mutex_unlock(&da9052->io_lock);
+               return -ENODEV;
+       }
+
+       if ( da9052->read_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       val &= ~bit_mask;
+
+       if ( da9052->write_dev(da9052, reg, 1, &val) ) {
+               mutex_unlock(&da9052->io_lock);
+               return -EIO;
+       }
+
+       mutex_unlock(&da9052->io_lock);
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_clear_bits);
+
+int da9052_read_events(struct da9052 *da9052, unsigned char reg ,
+                             unsigned int *events)
+{
+       uint8_t v[4] = {0, 0, 0, 0};
+       int ret;
+
+       ret = da9052_group_read(da9052, reg, 4, v);
+       if (ret < 0)
+               return ret;
+
+       *events = (v[3] << 24) | (v[2] << 16) | (v[1] << 8) | v[0];
+
+       return 0;
+}
+EXPORT_SYMBOL_GPL(da9052_read_events);
+
+int da9052_unmask_events(struct da9052 *da9052, unsigned int events)
+{
+       uint8_t v[4];
+
+       da9052->events_mask &= ~events;
+
+       v[0] = (da9052->events_mask & 0xff);
+       v[1] = (da9052->events_mask >> 8) & 0xff;
+       v[2] = (da9052->events_mask >> 16) & 0xff;
+       v[3] = (da9052->events_mask >> 24) & 0xff;
+
+       return da9052_group_write(da9052, DA9052_IRQ_MASK_A_REG, 4, v);
+}
+
+int da9052_mask_events(struct da9052 *da9052, unsigned int events)
+{
+       uint8_t v[4];
+
+       da9052->events_mask |= events;
+
+       v[0] = (da9052->events_mask & 0xff);
+       v[1] = (da9052->events_mask >> 8) & 0xff;
+       v[2] = (da9052->events_mask >> 16) & 0xff;
+       v[3] = (da9052->events_mask >> 24) & 0xff;
+
+       return da9052_group_write(da9052, DA9052_IRQ_MASK_A_REG, 4, v);
+}
+
+static struct resource da9052_rtc_resource = {
+       .name = "ALM",
+       .start = DA9052_IRQ_ALARM,
+       .end   = DA9052_IRQ_ALARM,
+       .flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9052_onkey_resource = {
+       .name = "ONKEY",
+       .start = DA9052_IRQ_NONKEY,
+       .end   = DA9052_IRQ_NONKEY,
+       .flags = IORESOURCE_IRQ,
+};
+
+static struct resource da9052_power_resources[] = {
+       {
+               .name = "CHGEND",
+               .start = DA9052_IRQ_CHGEND,
+               .end   = DA9052_IRQ_CHGEND,
+               .flags = IORESOURCE_IRQ,
+       },
+       {
+               .name = "TBAT",
+               .start = DA9052_IRQ_TBAT,
+               .end   = DA9052_IRQ_TBAT,
+               .flags = IORESOURCE_IRQ,
+       },
+};
+
+static struct resource da9052_tsi_resources[] = {
+       {
+               .name = "PENDWN",
+               .start = DA9052_IRQ_PENDOWN,
+               .end   = DA9052_IRQ_PENDOWN,
+               .flags = IORESOURCE_IRQ,
+       },
+       {
+               .name = "TSIRDY",
+               .start = DA9052_IRQ_TSIREADY,
+               .end   = DA9052_IRQ_TSIREADY,
+               .flags = IORESOURCE_IRQ,
+       },
+};
+
+static void da9052_remove_subdevs(struct da9052 *da9052)
+{
+       mfd_remove_devices(da9052->dev);
+
+}
+
+static int da9052_add_subdevs(struct da9052 *da9052)
+{
+       struct da9052_pdata *pdata = da9052->dev->platform_data;
+
+       struct mfd_cell da9052_subdev_info[] = {
+               DA9052_SUBDEV(onkey, NULL, 0, &da9052_onkey_resource, 1),
+               DA9052_SUBDEV(rtc, NULL, 0, &da9052_rtc_resource, 1),
+               DA9052_SUBDEV(gpio, NULL, 0, NULL, 0),
+               DA9052_SUBDEV(hwmon, NULL, 0, NULL, 0),
+               DA9052_SUBDEV(leds, pdata->pled,
+                                       sizeof(struct gpio_led_platform_data),
+                                       NULL, 0),
+               DA9052_SUBDEV(WLED1, NULL, 0, NULL, 0),
+               DA9052_SUBDEV(WLED2, NULL, 0, NULL, 0),
+               DA9052_SUBDEV(WLED3, NULL, 0, NULL, 0),
+               DA9052_SUBDEV(tsi, pdata->ptsi, sizeof(struct da9052_tsi_platform_data),
+                                         da9052_tsi_resources, ARRAY_SIZE(da9052_tsi_resources)),
+               DA9052_SUBDEV(bat, NULL, 0, da9052_power_resources,
+                                         ARRAY_SIZE(da9052_power_resources)),
+       };
+       int ret = 0;
+
+       ret = mfd_add_devices(da9052->dev, -1, da9052_subdev_info,
+                             ARRAY_SIZE(da9052_subdev_info), NULL, 0);
+       if( ret ) {
+               dev_err(da9052->dev,"Failed to add DA9052 MFD devices, %d\n", ret);
+               goto err;
+       }
+
+       return 0;
+
+err:
+       da9052_remove_subdevs(da9052);
+       return ret;
+
+}
+
+int da9052_device_init(struct da9052 *da9052)
+{
+       struct da9052_pdata *pdata = da9052->dev->platform_data;
+       u32 events;
+       int ret = 0;
+
+       mutex_init(&da9052->io_lock);
+       pdata->init(da9052);
+
+       da9052_read_events(da9052, DA9052_IRQ_MASK_A_REG, &events);
+       da9052->events_mask = events;
+
+       ret  = da9052_add_subdevs(da9052);
+       if (ret != 0)
+               goto err_mfd_device;
+
+       ret = da9052_irq_init( da9052, pdata);
+       if( ret != 0 )
+               goto err_irq;
+
+       return 0;
+
+err_irq:
+       da9052_remove_subdevs(da9052);
+err_mfd_device:
+       mutex_destroy(&da9052->io_lock);
+       return ret;
+}
+
+void da9052_device_exit(struct da9052 *da9052)
+{
+       free_irq(da9052->chip_irq, NULL);
+       da9052_remove_subdevs(da9052);
+       mutex_destroy(&da9052->io_lock);
+
+       return;
+}
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("DA9052 MFD Core");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9052_SSC_DEVICE_NAME);
diff -Naur orig_linux-2.6.37/drivers/mfd/da9052-i2c.c linux-2.6.37/drivers/mfd/da9052-i2c.c
--- orig_linux-2.6.37/drivers/mfd/da9052-i2c.c  1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/mfd/da9052-i2c.c       2011-03-31 22:17:14.000000000 +0500
@@ -0,0 +1,189 @@
+/*
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * da9052-i2c.c: I2C SSC (Synchronous Serial Communication) driver for DA9052
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_I2C_INTERFACE   0x81
+
+int da9052_i2c_write_device(struct da9052 *da9052, unsigned char reg,
+                           unsigned count, unsigned char *val)
+{
+       unsigned char msg[count+1];
+       int ret = 0;
+
+       msg[0] = reg;
+       memcpy(&msg[1], val, count);
+
+       ret = i2c_master_send(da9052->i2c_client, msg, count + 1);
+       if (ret < 0)
+               return ret;
+       if (ret != count +1)
+                       return -EIO;
+
+       return 0;
+}
+
+int da9052_i2c_read_device(struct da9052 *da9052, unsigned char reg,
+                          unsigned count, unsigned char *val)
+{
+       int ret;
+
+       ret = i2c_master_send(da9052->i2c_client, &reg, 1);
+       if (ret < 0)
+               return ret;
+
+       ret = i2c_master_recv(da9052->i2c_client, val, count);
+       if (ret < 0)
+               return ret;
+       if (ret != count)
+                       return -EIO;
+
+       return 0;
+
+}
+
+static void da9052_i2c_enable_multiwrite(struct da9052 *da9052)
+{
+       u8 reg_val;
+
+       da9052_i2c_read_device(da9052, DA9052_CONTROL_B_REG, 1, &reg_val);
+
+       if( reg_val & DA9052_CONTROL_B_WRITEMODE) {
+               reg_val = ~DA9052_CONTROL_B_WRITEMODE;
+               da9052_i2c_write_device(da9052, DA9052_CONTROL_B_REG, 1, &reg_val);
+       }
+
+}
+
+static int da9052_i2c_connected(struct da9052 *da9052)
+{
+
+       u8 val = 0;
+       s16 ret;
+
+       ret = da9052_i2c_read_device(da9052, DA9052_INTERFACE_REG, 1, &val);
+       if ( ret < 0 ) {
+               pr_err("Failed to read DA9052 I2C device, %d \n", ret);
+               return ret;
+       }
+       else if ( DA9052_I2C_INTERFACE != val ){
+               pr_err("Failed to connect DA9052 I2C device, %d \n",val);
+               return -EIO;
+       }
+
+       return 0;
+}
+
+static int __devinit da9052_i2c_probe(struct i2c_client *client,
+       const struct i2c_device_id *id)
+{
+       struct i2c_adapter *adapter;
+       struct da9052 *da9052_i2c;
+       int ret;
+
+       da9052_i2c = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+       if (!da9052_i2c)
+               return -ENOMEM;
+
+       /* Get the bus driver handler */
+       adapter = to_i2c_adapter(client->dev.parent);
+
+       /* Check i2c bus driver supports byte data transfer */
+       if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
+               dev_info(&client->dev,\
+               "Error in %s:i2c_check_functionality\n", __func__);
+               return -ENODEV;;
+       }
+
+       /* Store handle to i2c client */
+       da9052_i2c->i2c_client = client;
+
+       da9052_i2c->dev = &client->dev;
+
+       /* Store the i2c client data */
+       i2c_set_clientdata(client, da9052_i2c);
+
+        /* Validate I2C connectivity */
+       ret = da9052_i2c_connected(da9052_i2c);
+       if ( ret == 0 ) {
+               /* I2C is connected */
+               da9052_i2c->write_dev = da9052_i2c_write_device;
+               da9052_i2c->read_dev = da9052_i2c_read_device;
+               da9052_i2c_enable_multiwrite(da9052_i2c);
+               if( 0 != da9052_device_init(da9052_i2c) ) {
+                       ret = -ENODEV;
+                       goto err_mem;
+               }
+       }
+       else
+               goto err_mem;
+
+
+       return 0;
+
+err_mem:
+       kfree(da9052_i2c);
+       return ret;
+}
+
+static int da9052_i2c_remove(struct i2c_client *client)
+{
+
+       struct da9052 *da9052 = i2c_get_clientdata(client);
+
+       da9052_device_exit(da9052);
+       kfree(da9052);
+
+       return 0;
+}
+
+static struct i2c_device_id da9052_i2c_id[] = {
+       { "da9052_i2c", 0},
+       {}
+};
+
+static struct i2c_driver da9052_i2c_driver =  {
+       .driver.name = "da9052_i2c",
+       .driver.owner = THIS_MODULE,
+       .probe  = da9052_i2c_probe,
+       .remove = da9052_i2c_remove,
+       .id_table       = da9052_i2c_id,
+};
+
+
+static int __init da9052_i2c_init(void)
+{
+       int ret = 0;
+
+       ret = i2c_add_driver(&da9052_i2c_driver);
+       if (ret != 0) {
+               pr_err("DA9052 I2C registration failed %d\n", ret);
+               return ret;
+       }
+       return 0;
+}
+subsys_initcall(da9052_i2c_init);
+
+static void  __exit da9052_i2c_exit(void)
+{
+       i2c_del_driver(&da9052_i2c_driver);
+}
+module_exit(da9052_i2c_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("I2C driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052_i2c");
diff -Naur orig_linux-2.6.37/drivers/mfd/da9052-irq.c linux-2.6.37/drivers/mfd/da9052-irq.c
--- orig_linux-2.6.37/drivers/mfd/da9052-irq.c  1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/mfd/da9052-irq.c       2011-03-31 22:17:27.000000000 +0500
@@ -0,0 +1,285 @@
+/*
+ * da9052-irq.c  --  Interrupt controller support for Dilaog DA9052 PMICs
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/spi/spi.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+
+#include <linux/mfd/da9052/irq.h>
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/pdata.h>
+
+struct da9052_irq_data {
+       int mask;
+       int event;
+};
+
+#define DA9052_FIXME() { udelay(50);}
+
+static struct da9052_irq_data da9052_irqs[] = {
+       [DA9052_IRQ_DCIN] = {
+               .mask = DA9052_IRQMASK_A_M_DCIN_VLD,
+               .event = DA9052_EVENT_A_E_DCIN_DET,
+       },
+       [DA9052_IRQ_VBUS] = {
+               .mask = DA9052_IRQMASK_A_M_VBUS_VLD,
+               .event = DA9052_EVENT_A_E_VBUS_DET,
+       },
+       [DA9052_IRQ_DCINREM] = {
+               .mask = DA9052_IRQMASK_A_M_DCIN_REM,
+               .event = DA9052_EVENT_A_E_DCIN_REM,
+       },
+       [DA9052_IRQ_VBUSREM] = {
+               .mask = DA9052_IRQMASK_A_M_VBUS_REM,
+               .event = DA9052_EVENT_A_E_VBUS_REM,
+       },
+       [DA9052_IRQ_VDDLOW] = {
+               .mask = DA9052_IRQMASK_A_M_VDD_LOW,
+               .event = DA9052_EVENT_A_E_VDD_LOW,
+       },
+       [DA9052_IRQ_ALARM] = {
+               .mask = DA9052_IRQMASK_A_M_ALARM,
+               .event = DA9052_EVENT_A_E_ALARM,
+       },
+       [DA9052_IRQ_SEQRDY] = {
+               .mask = DA9052_IRQMASK_A_M_SEQRDY,
+               .event = DA9052_EVENT_A_E_SEQRDY,
+       },
+       [DA9052_IRQ_COMP1V2] = {
+               .mask = DA9052_IRQMASK_A_M_COMP1V2,
+               .event = DA9052_EVENT_A_E_COMP1V2,
+       },
+       [DA9052_IRQ_NONKEY] = {
+               .mask = DA9052_IRQMASK_B_M_NONKEY,
+               .event = DA9052_EVENT_B_E_NONKEY,
+       },
+       [DA9052_IRQ_IDFLOAT] = {
+               .mask = DA9052_IRQMASK_B_M_ID_FLOAT,
+               .event = DA9052_EVENT_B_E_ID_FLOAT,
+       },
+       [DA9052_IRQ_IDGND] = {
+               .mask = DA9052_IRQMASK_B_M_ID_GND,
+               .event = DA9052_EVENT_B_E_ID_GND,
+       },
+       [DA9052_IRQ_CHGEND] = {
+               .mask = DA9052_IRQMASK_B_M_CHG_END,
+               .event = DA9052_EVENT_B_E_CHG_END,
+       },
+       [DA9052_IRQ_TBAT] = {
+               .mask = DA9052_IRQMASK_B_M_TBAT,
+               .event = DA9052_EVENT_B_E_TBAT,
+       },
+       [DA9052_IRQ_ADCEOM] = {
+               .mask = DA9052_IRQMASK_B_M_ADC_EOM,
+               .event = DA9052_EVENT_B_E_ADC_EOM,
+       },
+       [DA9052_IRQ_PENDOWN] = {
+               .mask = DA9052_IRQMASK_B_M_PEN_DOWN,
+               .event = DA9052_EVENT_B_E_PEN_DOWN,
+       },
+       [DA9052_IRQ_TSIREADY] = {
+               .mask = DA9052_IRQMASK_B_M_TSI_READY,
+               .event = DA9052_EVENT_B_E_TSI_READY,
+       },
+       [DA9052_IRQ_GPI0] = {
+               .mask = DA9052_IRQMASK_C_M_GPI0,
+               .event = DA9052_EVENT_C_E_GPI0,
+       },
+       [DA9052_IRQ_GPI1] = {
+               .mask = DA9052_IRQMASK_C_M_GPI1,
+               .event = DA9052_EVENT_C_E_GPI1,
+       },
+       [DA9052_IRQ_GPI2] = {
+               .mask = DA9052_IRQMASK_C_M_GPI2,
+               .event = DA9052_EVENT_C_E_GPI2,
+       },
+       [DA9052_IRQ_GPI3] = {
+               .mask = DA9052_IRQMASK_C_M_GPI3,
+               .event = DA9052_EVENT_C_E_GPI3,
+       },
+       [DA9052_IRQ_GPI4] = {
+               .mask = DA9052_IRQMASK_C_M_GPI4,
+               .event = DA9052_EVENT_C_E_GPI4,
+       },
+       [DA9052_IRQ_GPI5] = {
+               .mask = DA9052_IRQMASK_C_M_GPI5,
+               .event = DA9052_EVENT_C_E_GPI5,
+       },
+       [DA9052_IRQ_GPI6] = {
+               .mask = DA9052_IRQMASK_C_M_GPI6,
+               .event = DA9052_EVENT_C_E_GPI6,
+       },
+       [DA9052_IRQ_GPI7] = {
+               .mask = DA9052_IRQMASK_C_M_GPI7,
+               .event = DA9052_EVENT_C_E_GPI7,
+       },
+       [DA9052_IRQ_GPI8] = {
+               .mask = DA9052_IRQMASK_D_M_GPI8,
+               .event = DA9052_EVENT_D_E_GPI8,
+       },
+       [DA9052_IRQ_GPI9] = {
+               .mask = DA9052_IRQMASK_D_M_GPI9,
+               .event = DA9052_EVENT_D_E_GPI9,
+       },
+       [DA9052_IRQ_GPI10] = {
+               .mask = DA9052_IRQMASK_D_M_GPI10,
+               .event = DA9052_EVENT_D_E_GPI10,
+       },
+       [DA9052_IRQ_GPI11] = {
+               .mask = DA9052_IRQMASK_D_M_GPI11,
+               .event = DA9052_EVENT_D_E_GPI11,
+       },
+       [DA9052_IRQ_GPI12] = {
+               .mask = DA9052_IRQMASK_D_M_GPI12,
+               .event = DA9052_EVENT_D_E_GPI12,
+       },
+       [DA9052_IRQ_GPI13] = {
+               .mask = DA9052_IRQMASK_D_M_GPI13,
+               .event = DA9052_EVENT_D_E_GPI13,
+       },
+       [DA9052_IRQ_GPI14] = {
+               .mask = DA9052_IRQMASK_D_M_GPI14,
+               .event = DA9052_EVENT_D_E_GPI14,
+       },
+       [DA9052_IRQ_GPI15] = {
+               .mask = DA9052_IRQMASK_D_M_GPI15,
+               .event = DA9052_EVENT_D_E_GPI15,
+       },
+};
+
+static inline struct da9052_irq_data *irq_to_da9052_irq(struct da9052 *da9052,
+                                                       int irq)
+{
+       return &da9052_irqs[irq - da9052->irq_base];
+}
+
+static void da9052_irq_lock(unsigned int irq)
+{
+       struct da9052 *da9052 = get_irq_chip_data(irq);
+
+       mutex_lock(&da9052->irq_lock);
+}
+
+static void da9052_irq_sync_unlock(unsigned int irq)
+{
+       struct da9052 *da9052 = get_irq_chip_data(irq);
+
+       mutex_unlock(&da9052->irq_lock);
+}
+
+static void da9052_irq_mask(unsigned int irq)
+{
+       struct da9052 *da9052 = get_irq_chip_data(irq);
+
+       da9052_mask_events(da9052,  da9052_irqs[irq].event);
+}
+
+static void da9052_irq_unmask(unsigned int irq)
+{
+       struct da9052 *da9052 = get_irq_chip_data(irq);
+
+    da9052_unmask_events(da9052, da9052_irqs[irq].event);
+}
+
+static irqreturn_t da9052_irq_thread(int irq, void *data)
+{
+       struct da9052 *da9052 = data;
+       uint8_t v[4] = {0xFF,0xFF,0xFF,0xFF};
+       unsigned int i;
+       unsigned int events;
+
+       if (da9052_read_events(da9052, DA9052_EVENT_A_REG, &events))
+               goto err;
+
+       events &= ~da9052->events_mask;
+       if (events == 0)
+               goto err;
+
+       for (i = 0; i < ARRAY_SIZE(da9052_irqs); i++) {
+
+               /* Report it if it isn't masked, or forget the status. */
+               if (events &  ( 1 << i ) )
+                       handle_nested_irq(da9052->irq_base + i);
+
+       }
+
+       /* Clear Event Register */
+       da9052_group_write(da9052, DA9052_EVENT_A_REG, 4, v);
+
+       DA9052_FIXME();
+err:
+       return IRQ_HANDLED;
+}
+
+struct irq_chip da9052_irq_chip = {
+       .name = "da9052",
+       .bus_lock = da9052_irq_lock,
+       .bus_sync_unlock = da9052_irq_sync_unlock,
+       .mask = da9052_irq_mask,
+       .unmask = da9052_irq_unmask,
+};
+
+int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata)
+{
+       int cur_irq, ret;
+
+       da9052->chip_irq = pdata->irq;
+       da9052->irq_base = pdata->irq_base;
+
+       if (!da9052->chip_irq) {
+           dev_err(da9052->dev, "No IRQ configured \n");
+           return -EINVAL;
+       }
+
+       mutex_init(&da9052->irq_lock);
+
+       /* Register them with genirq */
+       for (cur_irq = da9052->irq_base;
+            cur_irq < ARRAY_SIZE(da9052_irqs) + da9052->irq_base;
+            cur_irq++) {
+               set_irq_chip_data(cur_irq, da9052);
+               set_irq_chip_and_handler(cur_irq, &da9052_irq_chip,
+                                        handle_simple_irq);
+               set_irq_nested_thread(cur_irq, 1);
+
+               /* ARM needs us to explicitly flag the IRQ as valid
+                * and will set them noprobe when we do so. */
+#ifdef CONFIG_ARM
+               set_irq_flags(cur_irq, IRQF_VALID);
+#else
+               set_irq_noprobe(cur_irq);
+#endif
+       }
+       ret = request_threaded_irq(da9052->chip_irq, NULL, da9052_irq_thread,
+                                  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+                                  "da9052", da9052);
+       if (ret != 0) {
+               dev_err(da9052->dev, "Failed to request IRQ %d: %d\n",
+                       da9052->chip_irq, ret);
+               return ret;
+       }
+       return ret;
+}
+
+void da9052_irq_exit(struct da9052 *da9052)
+{
+       free_irq(da9052->chip_irq, da9052);
+       return;
+}
diff -Naur orig_linux-2.6.37/drivers/mfd/da9052-spi.c linux-2.6.37/drivers/mfd/da9052-spi.c
--- orig_linux-2.6.37/drivers/mfd/da9052-spi.c  1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/drivers/mfd/da9052-spi.c       2011-03-31 22:17:21.000000000 +0500
@@ -0,0 +1,227 @@
+/*
+ * da9052-spi.c  --  SPI access for Dialog DA9052 PMICs
+ *
+ * Author: Dajun Chen <dchen@diasemi.com>
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/mfd/core.h>
+#include <linux/spi/spi.h>
+
+#include <linux/mfd/da9052/da9052.h>
+#include <linux/mfd/da9052/reg.h>
+
+#define DA9052_SPI_INTERFACE   0x88
+
+int da9052_spi_write_device(struct da9052 *da9052, unsigned char reg,
+                           unsigned bytes, unsigned char *val)
+{
+
+       struct spi_message message;
+       struct spi_transfer xfer;
+       int raddr;
+
+       for( raddr= reg ; raddr < reg + bytes; raddr++) {
+
+               /* We need to reset 0th bit for write operation */
+               raddr = (raddr << 1);
+
+               /* Build our spi message */
+               spi_message_init(&message);
+               memset(&xfer, 0, sizeof(xfer));
+
+               xfer.len = 2;
+               xfer.tx_buf = da9052->spi_tx_buf;
+               xfer.rx_buf = da9052->spi_rx_buf;
+
+               da9052->spi_tx_buf[0] = raddr;
+               da9052->spi_tx_buf[1] = *val++;
+
+               spi_message_add_tail(&xfer, &message);
+
+               /* Now, do the i/o */
+               spi_sync(da9052->spi_dev, &message);
+       }
+
+       return 0;
+}
+
+int da9052_spi_read_device(struct da9052 *da9052, unsigned char reg,
+                          unsigned bytes, unsigned char *val)
+{
+
+       struct spi_message message;
+       struct spi_transfer xfer;
+       int ret, raddr;
+
+       for( raddr= reg ; raddr < reg + bytes; raddr++) {
+
+               /* We need to set 0th bit for read operation */
+               reg = ((raddr << 1) | da9052->rw_pol);
+
+               /* Build our spi message */
+               spi_message_init(&message);
+               memset(&xfer, 0, sizeof(xfer));
+
+               xfer.len = 2;
+               xfer.tx_buf = da9052->spi_tx_buf;
+               xfer.rx_buf = da9052->spi_rx_buf;
+
+               da9052->spi_tx_buf[0] = raddr;
+               da9052->spi_tx_buf[1] = 0xff;
+
+               da9052->spi_rx_buf[0] = 0;
+               da9052->spi_rx_buf[1] = 0;
+
+               spi_message_add_tail(&xfer, &message);
+
+               /* Now, do the i/o */
+               ret = spi_sync(da9052->spi_dev, &message);
+
+               if (ret == 0) {
+                       /* Update read value in callers copy */
+                       *val = da9052->spi_rx_buf[1];
+                       val++;
+                       return 0;
+               } else {
+                       return ret;
+               }
+       }
+
+
+       return 0;
+}
+
+static int da9052_spi_connected(struct da9052 *da9052)
+{
+
+       int ret;
+       unsigned char val;
+
+       ret = da9052_spi_read_device(da9052, DA9052_INTERFACE_REG, 1, &val);
+       if ( ret != 0 ) {
+               pr_err("Failed to read DA9052 SPI device, %d \n", ret);
+               return ret;
+       }
+       else if( DA9052_SPI_INTERFACE != val ){
+               pr_err("Failed to connect DA9052 SPI device, %d \n",val);
+               return -EIO;
+       }
+
+       return 0;
+
+}
+
+static int da9052_spi_probe(struct spi_device *spi)
+{
+
+       int ret;
+       struct da9052 *da9052_spi = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+
+       if (!da9052_spi)
+               return -ENOMEM;
+
+       spi->mode = SPI_MODE_0 | SPI_CPOL;
+       spi->bits_per_word = 8;
+       spi_setup(spi);
+
+       da9052_spi->dev = &spi->dev;
+       da9052_spi->spi_dev = spi;
+
+       /*
+        * Allocate memory for RX/TX bufferes used in single register read/write
+        */
+       da9052_spi->spi_rx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+       if (!da9052_spi->spi_rx_buf) {
+               ret = -ENOMEM;
+               goto err_mem;
+       }
+
+       da9052_spi->spi_tx_buf = kmalloc(2, GFP_KERNEL | GFP_DMA);
+       if (!da9052_spi->spi_tx_buf) {
+               ret = -ENOMEM;
+               goto err_spi_rx_buf;
+       }
+
+       da9052_spi->rw_pol = 1;
+
+       dev_set_drvdata(&spi->dev, da9052_spi);
+
+       /* Check SPI connectivity */
+       ret = da9052_spi_connected(da9052_spi);
+    if ( ret == 0 ) {
+                               /* SPI connected */
+                       da9052_spi->write_dev = da9052_spi_write_device;
+                       da9052_spi->read_dev = da9052_spi_read_device;
+            if( 0 != da9052_device_init(da9052_spi) ) {
+                               ret = -ENODEV;
+                               goto err_spi_tx_buf;
+                       }
+       }
+       else
+                               goto err_spi_tx_buf;
+
+
+       return 0;
+
+err_spi_tx_buf:
+       kfree(da9052_spi->spi_tx_buf);
+err_spi_rx_buf:
+       kfree(da9052_spi->spi_rx_buf);
+err_mem:
+       kfree(da9052_spi);
+       return ret;
+}
+
+static int da9052_spi_remove(struct spi_device *spi)
+{
+       struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
+
+       da9052_device_exit(da9052);
+       kfree(da9052->spi_rx_buf);
+       kfree(da9052->spi_tx_buf);
+       kfree(da9052);
+
+       return 0;
+}
+
+static struct spi_driver da9052_spi_driver = {
+       .driver.name    = "da9052_spi",
+       .driver.bus     = &spi_bus_type,
+       .driver.owner   = THIS_MODULE,
+       .probe          = da9052_spi_probe,
+       .remove         = __devexit_p(da9052_spi_remove),
+};
+
+static int __init da9052_spi_init(void)
+{
+       int ret;
+
+       ret = spi_register_driver(&da9052_spi_driver);
+       if ( ret != 0 ) {
+               pr_err("Failed to register DA9052 SPI driver, %d\n", ret );
+               return ret;
+       }
+        return 0;
+}
+module_init(da9052_spi_init);
+
+static void __exit da9052_spi_exit(void)
+{
+       spi_unregister_driver(&da9052_spi_driver);
+}
+
+module_exit(da9052_spi_exit);
+
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_DESCRIPTION("SPI driver for Dialog DA9052 PMIC");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9052_spi");
diff -Naur orig_linux-2.6.37/drivers/mfd/Kconfig linux-2.6.37/drivers/mfd/Kconfig
--- orig_linux-2.6.37/drivers/mfd/Kconfig       2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/mfd/Kconfig    2011-03-31 22:16:52.000000000 +0500
@@ -606,6 +606,16 @@
          VIA VX855/VX875 south bridge. You will need to enable the vx855_spi
          and/or vx855_gpio drivers for this to do anything useful.

+config PMIC_DA9052
+       tristate "Dialog DA9052 with SPI/I2C"
+       depends on SPI_MASTER=y
+       depends on I2C=y
+       select MFD_CORE
+       help
+        SPI/I2C Support for the  Dialog semiconductor DA9052 PMIC.
+         This driver provides common support for accessing  the device,
+         additional drivers must be enabled in order to use the
+         functionality of the device.
 endif # MFD_SUPPORT

 menu "Multimedia Capabilities Port drivers"
diff -Naur orig_linux-2.6.37/drivers/mfd/Makefile linux-2.6.37/drivers/mfd/Makefile
--- orig_linux-2.6.37/drivers/mfd/Makefile      2011-01-05 05:50:19.000000000 +0500
+++ linux-2.6.37/drivers/mfd/Makefile   2011-03-31 22:16:46.000000000 +0500
@@ -58,6 +58,8 @@
 obj-$(CONFIG_UCB1400_CORE)     += ucb1400_core.o

 obj-$(CONFIG_PMIC_DA903X)      += da903x.o
+da9052-objs                    := da9052-spi.o da9052-i2c.o da9052-core.o da9052-irq.o
+obj-$(CONFIG_PMIC_DA9052)      += da9052.o
 max8925-objs                   := max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)      += max8925.o
 obj-$(CONFIG_MFD_MAX8998)      += max8998.o max8998-irq.o
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/da9052.h linux-2.6.37/include/linux/mfd/da9052/da9052.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/da9052.h 1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/da9052.h      2011-03-31 22:15:19.000000000 +0500
@@ -0,0 +1,113 @@
+/*
+ * da9052 declarations.
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __MFD_DA9052_DA9052_H
+#define __MFD_DA9052_DA9052_H
+
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+
+struct da9052_pdata;
+
+struct da9052 {
+       struct mutex io_lock;
+       struct mutex irq_lock;
+
+       struct device *dev;
+       struct spi_device *spi_dev;
+       struct i2c_client *i2c_client;
+
+       int irq_base;
+       u8      rw_pol;
+       u8      *spi_rx_buf;
+       u8      *spi_tx_buf;
+       u32     events_mask;
+
+       int chip_irq;
+       int (*read_dev) (struct da9052 *da9052, unsigned char reg,
+                        unsigned bytes, unsigned char *val);
+       int (*write_dev) (struct da9052 *da9052, unsigned char reg,
+                         unsigned bytes, unsigned char *val);
+};
+
+int da9052_adc_manual_read(struct da9052 *da9052,
+                                       unsigned char channel);
+int da9052_reg_read(struct da9052 *da9052, unsigned char reg);
+int da9052_reg_write( struct da9052 *da9052, unsigned char reg,
+                     unsigned char val);
+int da9052_group_read(struct da9052 *da9052, unsigned char reg,
+                     unsigned bytes, unsigned char *val);
+int da9052_group_write( struct da9052 *da9052, unsigned char reg,
+                      unsigned bytes, unsigned char *val );
+int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
+                    unsigned char bit_mask, unsigned char reg_val);
+int da9052_set_bits(struct da9052 *da9052, unsigned char reg,
+                    unsigned char bit_mask);
+int da9052_clear_bits(struct da9052 *da9052, unsigned char reg,
+                   unsigned char bit_mask);
+int da9052_read_events(struct da9052 *da9052, unsigned char reg ,
+                             unsigned int *events);
+int da9052_unmask_events(struct da9052 *da9052, unsigned int events);
+int da9052_mask_events(struct da9052 *da9052, unsigned int events);
+
+
+int da9052_device_init(struct da9052 *da9052);
+void da9052_device_exit(struct da9052 *da9052);
+
+int da9052_irq_init(struct da9052 *da9052, struct da9052_pdata *pdata);
+void da9052_irq_exit(struct da9052 *da9052);
+
+ /* Helper to save on boilerplate */
+static inline int da9052_request_irq(struct da9052 *da9052, int irq,
+                                      irq_handler_t handler, const char *name,
+                                      void *data)
+ {
+       int ret;
+
+       if (!da9052->irq_base)
+               return -EINVAL;
+
+       ret = request_threaded_irq(da9052->irq_base + irq, NULL, handler,
+                                     IRQF_TRIGGER_LOW | IRQF_ONESHOT, name,
+                                     data);
+       if( ret ) {
+               printk(" Failed to register %s IRQ %d, error = %d \n",
+                               name,da9052->irq_base + irq, ret);
+               dev_err(da9052->dev," Failed to register %s IRQ %d, error = %d \n",
+                               name,da9052->irq_base + irq, ret);
+               return ret;
+       }
+
+       return 0;
+ }
+
+ static inline void da9052_free_irq(struct da9052 *da9052, int irq, void *data)
+ {
+        if (!da9052->irq_base)
+                return;
+
+               free_irq(da9052->irq_base + irq, data);
+ }
+
+
+
+#endif /* __MFD_DA9052_DA9052_H */
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/irq.h linux-2.6.37/include/linux/mfd/da9052/irq.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/irq.h    1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/irq.h 2011-03-31 22:15:41.000000000 +0500
@@ -0,0 +1,121 @@
+/*
+ * include/linux/mfd/da9052/irq.h -- Interrupt controller for DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * Author: Dialog Semiconductor Ltd <dchen@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_DA9052_IRQ_H__
+#define __MFD_DA9052_IRQ_H__
+
+/* Interrupt number assignments within Linux */
+#define DA9052_IRQ_DCIN                0
+#define DA9052_IRQ_VBUS                1
+#define DA9052_IRQ_DCINREM             2
+#define DA9052_IRQ_VBUSREM             3
+#define DA9052_IRQ_VDDLOW              4
+#define DA9052_IRQ_ALARM               5
+#define DA9052_IRQ_SEQRDY              6
+#define DA9052_IRQ_COMP1V2             7
+#define DA9052_IRQ_NONKEY              8
+#define DA9052_IRQ_IDFLOAT             9
+#define DA9052_IRQ_IDGND               10
+#define DA9052_IRQ_CHGEND              11
+#define DA9052_IRQ_TBAT                12
+#define DA9052_IRQ_ADCEOM              13
+#define DA9052_IRQ_PENDOWN             14
+#define DA9052_IRQ_TSIREADY            15
+#define DA9052_IRQ_GPI0                16
+#define DA9052_IRQ_GPI1                17
+#define DA9052_IRQ_GPI2                18
+#define DA9052_IRQ_GPI3                19
+#define DA9052_IRQ_GPI4                20
+#define DA9052_IRQ_GPI5                21
+#define DA9052_IRQ_GPI6                22
+#define DA9052_IRQ_GPI7                23
+#define DA9052_IRQ_GPI8                24
+#define DA9052_IRQ_GPI9                25
+#define DA9052_IRQ_GPI10               26
+#define DA9052_IRQ_GPI11               27
+#define DA9052_IRQ_GPI12               28
+#define DA9052_IRQ_GPI13               29
+#define DA9052_IRQ_GPI14               30
+#define DA9052_IRQ_GPI15               31
+
+
+/* Interrupt mask */
+#define DA9052_IRQMASK_A_M_DCIN_VLD    0x01
+#define DA9052_IRQMASK_A_M_VBUS_VLD    0x02
+#define DA9052_IRQMASK_A_M_DCIN_REM    0x04
+#define DA9052_IRQMASK_A_M_VBUS_REM    0x08
+#define DA9052_IRQMASK_A_M_VDD_LOW             0x10
+#define DA9052_IRQMASK_A_M_ALARM               0x20
+#define DA9052_IRQMASK_A_M_SEQRDY              0x40
+#define DA9052_IRQMASK_A_M_COMP1V2             0x80
+#define DA9052_IRQMASK_B_M_NONKEY              0x0100
+#define DA9052_IRQMASK_B_M_ID_FLOAT    0x0200
+#define DA9052_IRQMASK_B_M_ID_GND              0x0400
+#define DA9052_IRQMASK_B_M_CHG_END             0x0800
+#define DA9052_IRQMASK_B_M_TBAT                0x1000
+#define DA9052_IRQMASK_B_M_ADC_EOM             0x2000
+#define DA9052_IRQMASK_B_M_PEN_DOWN            0x4000
+#define DA9052_IRQMASK_B_M_TSI_READY           0x8000
+#define DA9052_IRQMASK_C_M_GPI0                        0x010000
+#define DA9052_IRQMASK_C_M_GPI1                        0x020000
+#define DA9052_IRQMASK_C_M_GPI2                        0x040000
+#define DA9052_IRQMASK_C_M_GPI3                        0x080000
+#define DA9052_IRQMASK_C_M_GPI4                        0x100000
+#define DA9052_IRQMASK_C_M_GPI5                        0x200000
+#define DA9052_IRQMASK_C_M_GPI6                        0x400000
+#define DA9052_IRQMASK_C_M_GPI7                        0x800000
+#define DA9052_IRQMASK_D_M_GPI8                        0x01000000
+#define DA9052_IRQMASK_D_M_GPI9                        0x02000000
+#define DA9052_IRQMASK_D_M_GPI10               0x04000000
+#define DA9052_IRQMASK_D_M_GPI11               0x08000000
+#define DA9052_IRQMASK_D_M_GPI12               0x10000000
+#define DA9052_IRQMASK_D_M_GPI13               0x20000000
+#define DA9052_IRQMASK_D_M_GPI14               0x40000000
+#define DA9052_IRQMASK_D_M_GPI15               0x80000000
+
+/* Interrupt satus */
+#define DA9052_EVENT_A_E_DCIN_DET              0x01
+#define DA9052_EVENT_A_E_VBUS_DET              0x02
+#define DA9052_EVENT_A_E_DCIN_REM              0x04
+#define DA9052_EVENT_A_E_VBUS_REM              0x08
+#define DA9052_EVENT_A_E_VDD_LOW               0x10
+#define DA9052_EVENT_A_E_ALARM         0x20
+#define DA9052_EVENT_A_E_SEQRDY                0x40
+#define DA9052_EVENT_A_E_COMP1V2               0x80
+#define DA9052_EVENT_B_E_NONKEY                0x0100
+#define DA9052_EVENT_B_E_ID_FLOAT              0x0200
+#define DA9052_EVENT_B_E_ID_GND                0x0400
+#define DA9052_EVENT_B_E_CHG_END               0x0800
+#define DA9052_EVENT_B_E_TBAT          0x1000
+#define DA9052_EVENT_B_E_ADC_EOM               0x2000
+#define DA9052_EVENT_B_E_PEN_DOWN              0x4000
+#define DA9052_EVENT_B_E_TSI_READY             0x8000
+#define DA9052_EVENT_C_E_GPI0                  0x010000
+#define DA9052_EVENT_C_E_GPI1                  0x020000
+#define DA9052_EVENT_C_E_GPI2                  0x040000
+#define DA9052_EVENT_C_E_GPI3                  0x080000
+#define DA9052_EVENT_C_E_GPI4                  0x100000
+#define DA9052_EVENT_C_E_GPI5                  0x200000
+#define DA9052_EVENT_C_E_GPI6                  0x400000
+#define DA9052_EVENT_C_E_GPI7                  0x800000
+#define DA9052_EVENT_D_E_GPI8                  0x01000000
+#define DA9052_EVENT_D_E_GPI9                  0x02000000
+#define DA9052_EVENT_D_E_GPI10                 0x04000000
+#define DA9052_EVENT_D_E_GPI11                 0x08000000
+#define DA9052_EVENT_D_E_GPI12                 0x10000000
+#define DA9052_EVENT_D_E_GPI13                 0x20000000
+#define DA9052_EVENT_D_E_GPI14                 0x40000000
+#define DA9052_EVENT_D_E_GPI15                 0x80000000
+
+#endif
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/pdata.h linux-2.6.37/include/linux/mfd/da9052/pdata.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/pdata.h  1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/pdata.h       2011-03-31 22:16:05.000000000 +0500
@@ -0,0 +1,40 @@
+/*
+ * include/linux/mfd/da9052/pdata.h -- Platform data for DA9052
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __MFD_DA9052_PDATA_H__
+#define __MFD_DA9052_PDATA_H__
+
+#include <linux/leds.h>
+#include <linux/mfd/da9052/tsi.h>
+
+struct da9052;
+
+struct da9052_pdata {
+       struct gpio_led_platform_data *pled;
+       struct da9052_tsi_platform_data *ptsi;
+       int (*init) (struct da9052 *da9052);
+       int irq;
+       int irq_base;
+       int gpio_base;
+       u16 num_gpio;
+};
+
+#endif
diff -Naur orig_linux-2.6.37/include/linux/mfd/da9052/reg.h linux-2.6.37/include/linux/mfd/da9052/reg.h
--- orig_linux-2.6.37/include/linux/mfd/da9052/reg.h    1970-01-01 05:00:00.000000000 +0500
+++ linux-2.6.37/include/linux/mfd/da9052/reg.h 2011-03-31 22:15:56.000000000 +0500
@@ -0,0 +1,822 @@
+/*
+ * da9052 register declarations.
+ *
+ * Copyright(c) 2009 Dialog Semiconductor Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+
+#ifndef __LINUX_MFD_DA9052_REG_H
+#define __LINUX_MFD_DA9052_REG_H
+
+#define DA9052_MAX_REG_CNT                     128
+
+/*STATUS REGISTERS*/
+#define DA9052_STATUS_A_REG                    1
+#define DA9052_STATUS_B_REG                    2
+#define DA9052_STATUS_C_REG                    3
+#define DA9052_STATUS_D_REG                    4
+
+/*EVENT REGISTERS*/
+#define DA9052_EVENT_A_REG                     5
+#define DA9052_EVENT_B_REG                     6
+#define DA9052_EVENTC_REG                      7
+#define DA9052_EVENTD_REG                      8
+#define DA9052_FAULTLOG_REG                    9
+
+/*IRQ REGISTERS*/
+#define DA9052_IRQ_MASK_A_REG          10
+#define DA9052_IRQMASKB_REG                    11
+#define DA9052_IRQMASKC_REG                    12
+#define DA9052_IRQMASKD_REG                    13
+
+/*CONTROL REGISTERS*/
+#define DA9052_CONTROLA_REG                    14
+#define DA9052_CONTROL_B_REG                   15
+#define DA9052_CONTROLC_REG                    16
+#define DA9052_CONTROLD_REG                    17
+
+#define DA9052_PDDIS_REG                       18
+#define DA9052_INTERFACE_REG                   19
+#define DA9052_RESET_REG                       20
+
+/*GPIO REGISTERS*/
+#define DA9052_GPIO_0_1_REG                    21
+#define DA9052_GPIO_2_3_REG                    22
+#define DA9052_GPIO_14_15_REG          28
+
+/*LDO AND BUCK REGISTERS*/
+#define DA9052_BUCKA_REG                       44
+#define DA9052_BUCKB_REG                       45
+#define DA9052_BUCKCORE_REG                    46
+#define DA9052_BUCKPRO_REG                     47
+#define DA9052_BUCKMEM_REG                     48
+#define DA9052_BUCKPERI_REG                    49
+#define DA9052_LDO1_REG                        50
+#define DA9052_LDO2_REG                        51
+#define DA9052_LDO3_REG                        52
+#define DA9052_LDO4_REG                        53
+#define DA9052_LDO5_REG                        54
+#define DA9052_LDO6_REG                        55
+#define DA9052_LDO7_REG                        56
+#define DA9052_LDO8_REG                        57
+#define DA9052_LDO9_REG                        58
+#define DA9052_LDO10_REG                       59
+#define DA9052_SUPPLY_REG                      60
+#define DA9052_PULLDOWN_REG                    61
+#define DA9052_CHGBUCK_REG                     62
+#define DA9052_WAITCONT_REG                    63
+#define DA9052_ISET_REG                        64
+#define DA9052_BATCHG_REG                      65
+
+/*BATTERY CONTROLL REGISTRS*/
+#define DA9052_CHG_CONT_REG                    66
+#define DA9052_INPUT_CONT_REG          67
+#define DA9052_CHGTIME_REG                     68
+#define DA9052_BBATCONT_REG                    69
+
+/*LED CONTROL REGISTERS*/
+#define DA9052_BOOST_REG                       70
+#define DA9052_LED_CONT_REG                    71
+#define DA9052_LEDMIN123_REG                   72
+#define DA9052_LED1_CONF_REG                   73
+#define DA9052_LED2_CONF_REG                   74
+#define DA9052_LED3_CONF_REG                   75
+#define DA9052_LED1CONT_REG                    76
+#define DA9052_LED2CONT_REG                    77
+#define DA9052_LED3CONT_REG                    78
+#define DA9052_LED_CONT_4_REG          79
+#define DA9052_LED_CONT_5_REG          80
+
+/*ADC CONTROL REGISTERS*/
+#define DA9052_ADC_MAN_REG                     81
+#define DA9052_ADC_CONT_REG                    82
+#define DA9052_ADC_RES_L_REG                   83
+#define DA9052_ADC_RES_H_REG                   84
+#define DA9052_VDD_RES_REG                     85
+#define DA9052_VDDMON_REG                      86
+
+/*SM CONTROL REGISTERS*/
+#define DA9052_ICHG_AV_REG                     87
+#define DA9052_ICHGTHD_REG                     88
+#define DA9052_ICHG_END_REG                    89
+#define DA9052_TBAT_RES_REG                    90
+#define DA9052_TBATHIGHP_REG                   91
+#define DA9052_TBATHIGHIN_REG          92
+#define DA9052_TBATLOW_REG                     93
+#define DA9052_T_OFFSET_REG                    94
+
+/*TSI CONTROL REGISTERS*/
+#define DA9052_TJUNC_RES_REG                   104
+#define DA9052_TSICONT_A_REG                   105
+#define DA9052_TSICONTB_REG                    106
+#define DA9052_TSIXMSB_REG                     107
+#define DA9052_TSIYMSB_REG                     108
+#define DA9052_TSILSB_REG                      109
+#define DA9052_TSIZMSB_REG                     110
+
+/*RTC COUNT REGISTERS*/
+#define DA9052_COUNT_S_REG                     111
+#define DA9052_COUNT_MI_REG                    112
+#define DA9052_COUNT_H_REG                     113
+#define DA9052_COUNT_D_REG                     114
+#define DA9052_COUNT_MO_REG                    115
+#define DA9052_COUNT_Y_REG                     116
+
+/*RTC CONTROL REGISTERS*/
+#define DA9052_ALARM_MI_REG                    117
+#define DA9052_ALARM_H_REG                     118
+#define DA9052_ALARM_D_REG                     119
+#define DA9052_ALARM_MO_REG                    120
+#define DA9052_ALARM_Y_REG                     121
+
+
+/* Reg Page Configuration */
+#define DA9052_PAGECON0_REGPAGE                (1<<7)
+
+/* Onkey Event Registers */
+#define DA9052_M_nONKEY                        0x0100
+#define DA9052_E_nONKEY                        0x01
+
+/* TSI Event Registers */
+#define DA9052_E_PEN_DOWN                      0x4000
+#define DA9052_E_TSI_READY                     0x8000
+
+/* PAGE CONFIGURATION 128 REGISTER */
+#define DA9052_PAGECON128_REGPAGE              (1<<7)
+
+/* STATUS REGISTER A */
+#define DA9052_STATUSA_VDATDET         (1<<7)
+#define DA9052_STATUSA_VBUSSEL         (1<<6)
+#define DA9052_STATUSA_DCINSEL         (1<<5)
+#define DA9052_STATUSA_VBUSDET         (1<<4)
+#define DA9052_STATUSA_DCINDET         (1<<3)
+#define DA9052_STATUSA_IDGND                   (1<<2)
+#define DA9052_STATUSA_IDFLOAT         (1<<1)
+#define DA9052_STATUSA_NONKEY          (1<<0)
+
+/* STATUS REGISTER B */
+#define DA9052_STATUSB_COMPDET         (1<<7)
+#define DA9052_STATUSB_SEQUENCING              (1<<6)
+#define DA9052_STATUSB_GPFB2                   (1<<5)
+#define DA9052_STATUSB_CHGTO                   (1<<4)
+#define DA9052_STATUSB_CHGEND          (1<<3)
+#define DA9052_STATUSB_CHGLIM          (1<<2)
+#define DA9052_STATUSB_CHGPRE          (1<<1)
+#define DA9052_STATUSB_CHGATT          (1<<0)
+
+
+/* STATUS REGISTER C */
+#define DA9052_STATUSC_GPI7                    (1<<7)
+#define DA9052_STATUSC_GPI6                    (1<<6)
+#define DA9052_STATUSC_GPI5                    (1<<5)
+#define DA9052_STATUSC_GPI4                    (1<<4)
+#define DA9052_STATUSC_GPI3                    (1<<3)
+#define DA9052_STATUSC_GPI2                    (1<<2)
+#define DA9052_STATUSC_GPI1                    (1<<1)
+#define DA9052_STATUSC_GPI0                    (1<<0)
+
+
+/* STATUS REGISTER D */
+#define DA9052_STATUSD_GPI15                   (1<<7)
+#define DA9052_STATUSD_GPI14                   (1<<6)
+#define DA9052_STATUSD_GPI13                   (1<<5)
+#define DA9052_STATUSD_GPI12                   (1<<4)
+#define DA9052_STATUSD_GPI11                   (1<<3)
+#define DA9052_STATUSD_GPI10                   (1<<2)
+#define DA9052_STATUSD_GPI9                    (1<<1)
+#define DA9052_STATUSD_GPI8                    (1<<0)
+
+
+/* EVENT REGISTER A */
+#define DA9052_EVENTA_ECOMP1V2         (1<<7)
+#define DA9052_EVENTA_ESEQRDY          (1<<6)
+#define DA9052_EVENTA_EALRAM                   (1<<5)
+#define DA9052_EVENTA_EVDDLOW          (1<<4)
+#define DA9052_EVENTA_EVBUSREM         (1<<3)
+#define DA9052_EVENTA_EDCINREM         (1<<2)
+#define DA9052_EVENTA_EVBUSDET         (1<<1)
+#define DA9052_EVENTA_EDCINDET         (1<<0)
+
+/* EVENT REGISTER B */
+#define DA9052_EVENTB_ETSIREADY                (1<<7)
+#define DA9052_EVENTB_EPENDOWN         (1<<6)
+#define DA9052_EVENTB_EADCEOM          (1<<5)
+#define DA9052_EVENTB_ETBAT                    (1<<4)
+#define DA9052_EVENTB_ECHGEND          (1<<3)
+#define DA9052_EVENTB_EIDGND                   (1<<2)
+#define DA9052_EVENTB_EIDFLOAT         (1<<1)
+#define DA9052_EVENTB_ENONKEY          (1<<0)
+
+/* EVENT REGISTER C */
+#define DA9052_EVENTC_EGPI7                    (1<<7)
+#define DA9052_EVENTC_EGPI6                    (1<<6)
+#define DA9052_EVENTC_EGPI5                    (1<<5)
+#define DA9052_EVENTC_EGPI4                    (1<<4)
+#define DA9052_EVENTC_EGPI3                    (1<<3)
+#define DA9052_EVENTC_EGPI2                    (1<<2)
+#define DA9052_EVENTC_EGPI1                    (1<<1)
+#define DA9052_EVENTC_EGPI0                    (1<<0)
+
+/* EVENT REGISTER D */
+#define DA9052_EVENTC_EGPI15                   (1<<7)
+#define DA9052_EVENTC_EGPI14                   (1<<6)
+#define DA9052_EVENTC_EGPI13                   (1<<5)
+#define DA9052_EVENTC_EGPI12                   (1<<4)
+#define DA9052_EVENTC_EGPI11                   (1<<3)
+#define DA9052_EVENTC_EGPI10                   (1<<2)
+#define DA9052_EVENTC_EGPI9                    (1<<1)
+#define DA9052_EVENTC_EGPI8                    (1<<0)
+
+
+/* FAULT LOG REGISTER */
+#define DA9052_FAULTLOG_WAITSET                (1<<7)
+#define DA9052_FAULTLOG_NSDSET         (1<<6)
+#define DA9052_FAULTLOG_KEYSHUT                (1<<5)
+#define DA9052_FAULTLOG_TEMPOVER               (1<<3)
+#define DA9052_FAULTLOG_VDDSTART               (1<<2)
+#define DA9052_FAULTLOG_VDDFAULT               (1<<1)
+#define DA9052_FAULTLOG_TWDERROR               (1<<0)
+
+/* IRQ_MASK REGISTER A */
+#define DA9052_IRQMASKA_MCOMP1V2               (1<<7)
+#define DA9052_IRQMASKA_MSEQRDY                (1<<6)
+#define DA9052_IRQMASKA_MALRAM         (1<<5)
+#define DA9052_IRQMASKA_MVDDLOW                (1<<4)
+#define DA9052_IRQMASKA_MVBUSREM               (1<<3)
+#define DA9052_IRQMASKA_MDCINREM               (1<<2)
+#define DA9052_IRQMASKA_MVBUSVLD               (1<<1)
+#define DA9052_IRQMASKA_MDCINVLD               (1<<0)
+
+/* IRQ_MASK REGISTER B */
+#define DA9052_IRQMASKB_MTSIREADY              (1<<7)
+#define DA9052_IRQMASKB_MPENDOWN               (1<<6)
+#define DA9052_IRQMASKB_MADCEOM                (1<<5)
+#define DA9052_IRQMASKB_MTBAT          (1<<4)
+#define DA9052_IRQMASKB_MCHGEND                (1<<3)
+#define DA9052_IRQMASKB_MIDGND         (1<<2)
+#define DA9052_IRQMASKB_MIDFLOAT               (1<<1)
+#define DA9052_IRQMASKB_MNONKEY                (1<<0)
+
+/* IRQ_MASK REGISTER C */
+#define DA9052_IRQMASKC_MGPI7                  (1<<7)
+#define DA9052_IRQMASKC_MGPI6                  (1<<6)
+#define DA9052_IRQMASKC_MGPI5                  (1<<5)
+#define DA9052_IRQMASKC_MGPI4                  (1<<4)
+#define DA9052_IRQMASKC_MGPI3                  (1<<3)
+#define DA9052_IRQMASKC_MGPI2                  (1<<2)
+#define DA9052_IRQMASKC_MGPI1                  (1<<1)
+#define DA9052_IRQMASKC_MGPI0                  (1<<0)
+
+/* IRQ_MASK REGISTER D */
+#define DA9052_IRQMASKD_MGPI15                 (1<<7)
+#define DA9052_IRQMASKD_MGPI14                 (1<<6)
+#define DA9052_IRQMASKD_MGPI13                 (1<<5)
+#define DA9052_IRQMASKD_MGPI12                 (1<<4)
+#define DA9052_IRQMASKD_MGPI11                 (1<<3)
+#define DA9052_IRQMASKD_MGPI10                 (1<<2)
+#define DA9052_IRQMASKD_MGPI9                  (1<<1)
+#define DA9052_IRQMASKD_MGPI8                  (1<<0)
+
+/* CONTROL REGISTER A */
+#define DA9052_CONTROLA_GPIV                   (1<<7)
+#define DA9052_CONTROLA_PMOTYPE                (1<<5)
+#define DA9052_CONTROLA_PMOV                   (1<<4)
+#define DA9052_CONTROLA_PMIV                   (1<<3)
+#define DA9052_CONTROLA_PMIFV          (1<<3)
+#define DA9052_CONTROLA_PWR1EN         (1<<2)
+#define DA9052_CONTROLA_PWREN          (1<<1)
+#define DA9052_CONTROLA_SYSEN          (1<<0)
+
+/* CONTROL REGISTER B */
+#define DA9052_CONTROLB_SHUTDOWN               (1<<7)
+#define DA9052_CONTROLB_DEEPSLEEP              (1<<6)
+#define DA9052_CONTROL_B_WRITEMODE             (1<<5)
+#define DA9052_CONTROLB_BBATEN         (1<<4)
+#define DA9052_CONTROLB_OTPREADEN              (1<<3)
+#define DA9052_CONTROLB_AUTOBOOT               (1<<2)
+#define DA9052_CONTROLB_ACTDIODE               (1<<1)
+#define DA9052_CONTROLB_BUCKMERGE              (1<<0)
+
+/* CONTROL REGISTER C */
+#define DA9052_CONTROLC_BLINKDUR               (1<<7)
+#define DA9052_CONTROLC_BLINKFRQ               (3<<5)
+#define DA9052_CONTROLC_DEBOUNCING             (7<<2)
+#define DA9052_CONTROLC_PMFB2PIN               (1<<1)
+#define DA9052_CONTROLC_PMFB1PIN               (1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_CONTROLD_WATCHDOG               (1<<7)
+#define DA9052_CONTROLD_ACCDETEN               (1<<6)
+#define DA9052_CONTROLD_GPI1415SD              (1<<5)
+#define DA9052_CONTROLD_NONKEYSD               (1<<4)
+#define DA9052_CONTROLD_KEEPACTEN              (1<<3)
+#define DA9052_CONTROLD_TWDSCALE               (7<<0)
+
+/* POWER DOWN DISABLE REGISTER */
+#define DA9052_PDDIS_PMCONTPD          (1<<7)
+#define DA9052_PDDIS_OUT32KPD          (1<<6)
+#define DA9052_PDDIS_CHGBBATPD         (1<<5)
+#define DA9052_PDDIS_CHGPD                     (1<<4)
+#define DA9052_PDDIS_HS2WIREPD         (1<<3)
+#define DA9052_PDDIS_PMIFPD                    (1<<2)
+#define DA9052_PDDIS_GPADCPD                   (1<<1)
+#define DA9052_PDDIS_GPIOPD                    (1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_INTERFACE_IFBASEADDR    (7<<5)
+#define DA9052_INTERFACE_NCSPOL                (1<<4)
+#define DA9052_INTERFACE_RWPOL         (1<<3)
+#define DA9052_INTERFACE_CPHA          (1<<2)
+#define DA9052_INTERFACE_CPOL          (1<<1)
+#define DA9052_INTERFACE_IFTYPE                (1<<0)
+
+/* CONTROL REGISTER D */
+#define DA9052_RESET_RESETEVENT                (3<<6)
+#define DA9052_RESET_RESETTIMER                (63<<0)
+
+/* GPIO REGISTERS */
+
+/* GPIO control register */
+#define DA9052_GPIO_EVEN_PORT_PIN              (3<<0)
+#define DA9052_GPIO_EVEN_PORT_TYPE             (1<<2)
+#define DA9052_GPIO_EVEN_PORT_MODE             (1<<3)
+
+#define DA9052_GPIO_ODD_PORT_PIN               (3<<4)
+#define DA9052_GPIO_ODD_PORT_TYPE              (1<<6)
+#define DA9052_GPIO_ODD_PORT_MODE              (1<<7)
+
+/*POWER SEQUENCER REGISTER*/
+
+/* SEQ control register for ID 0 and 1 */
+#define DA9052_ID01_LDO1STEP                   (15<<4)
+#define DA9052_ID01_SYSPRE                     (1<<2)
+#define DA9052_ID01_DEFSUPPLY          (1<<1)
+#define DA9052_ID01_nRESMODE                   (1<<0)
+
+/* SEQ control register for ID 2 and 3 */
+#define DA9052_ID23_LDO3STEP                   (15<<4)
+#define DA9052_ID23_LDO2STEP                   (15<<0)
+
+/* SEQ control register for ID 4 and 5 */
+#define DA9052_ID45_LDO5STEP                   (15<<4)
+#define DA9052_ID45_LDO4STEP                   (15<<0)
+
+/* SEQ control register for ID 6 and 7 */
+#define DA9052_ID67_LDO7STEP                   (15<<4)
+#define DA9052_ID67_LDO6STEP                   (15<<0)
+
+/* SEQ control register for ID 8 and 9 */
+#define DA9052_ID89_LDO9STEP                   (15<<4)
+#define DA9052_ID89_LDO8STEP                   (15<<0)
+
+/* SEQ control register for ID 10 and 11 */
+#define DA9052_ID1011_PDDISSTEP                (15<<4)
+#define DA9052_ID1011_LDO10STEP                (15<<0)
+
+/* SEQ control register for ID 12 and 13 */
+#define DA9052_ID1213_VMEMSWSTEP               (15<<4)
+#define DA9052_ID1213_VPERISWSTEP              (15<<0)
+
+/* SEQ control register for ID 14 and 15 */
+#define DA9052_ID1415_BUCKPROSTEP              (15<<4)
+#define DA9052_ID1415_BUCKCORESTEP             (15<<0)
+
+/* SEQ control register for ID 16 and 17 */
+#define DA9052_ID1617_BUCKPERISTEP             (15<<4)
+#define DA9052_ID1617_BUCKMEMSTEP              (15<<0)
+
+/* SEQ control register for ID 18 and 19 */
+#define DA9052_ID1819_GPRISE2STEP              (15<<4)
+#define DA9052_ID1819_GPRISE1STEP              (15<<0)
+
+/* SEQ control register for ID 20 and 21 */
+#define DA9052_ID2021_GPFALL2STEP              (15<<4)
+#define DA9052_ID2021_GPFALL1STEP              (15<<0)
+
+/* Power SEQ Status register */
+#define DA9052_SEQSTATUS_SEQPOINTER    (15<<4)
+#define DA9052_SEQSTATUS_WAITSTEP              (15<<0)
+
+/* Power SEQ A register */
+#define DA9052_SEQA_POWEREND                   (15<<4)
+#define DA9052_SEQA_SYSTEMEND          (15<<0)
+
+/* Power SEQ B register */
+#define DA9052_SEQB_PARTDOWN                   (15<<4)
+#define DA9052_SEQB_MAXCOUNT                   (15<<0)
+
+/* Power SEQ TIMER register */
+#define DA9052_SEQTIMER_SEQDUMMY               (15<<4)
+#define DA9052_SEQTIMER_SEQTIME                (15<<0)
+
+/*POWER SUPPLY CONTROL REGISTER*/
+
+/* BUCK REGISTER A */
+#define DA9052_BUCKA_BPROILIM                  (3<<6)
+#define DA9052_BUCKA_BPROMODE                  (3<<4)
+#define DA9052_BUCKA_BCOREILIM                 (3<<2)
+#define DA9052_BUCKA_BCOREMODE                 (3<<0)
+
+/* BUCK REGISTER B */
+#define DA9052_BUCKB_BERIILIM                  (3<<6)
+#define DA9052_BUCKB_BPERIMODE                 (3<<4)
+#define DA9052_BUCKB_BMEMILIM                  (3<<2)
+#define DA9052_BUCKB_BMEMMODE                  (3<<0)
+
+/* BUCKCORE REGISTER */
+#define DA9052_BUCKCORE_BCORECONF              (1<<7)
+#define DA9052_BUCKCORE_BCOREEN                (1<<6)
+#define DA9052_BUCKCORE_VBCORE         (63<<0)
+
+/* BUCKPRO REGISTER */
+#define DA9052_BUCKPRO_BPROCONF                (1<<7)
+#define DA9052_BUCKPRO_BPROEN          (1<<6)
+#define DA9052_BUCKPRO_VBPRO                   (63<<0)
+
+/* BUCKMEM REGISTER */
+#define DA9052_BUCKMEM_BMEMCONF                (1<<7)
+#define DA9052_BUCKMEM_BMEMEN          (1<<6)
+#define DA9052_BUCKMEM_VBMEM                   (63<<0)
+
+/* BUCKPERI REGISTER */
+#define DA9052_BUCKPERI_BPERICONF              (1<<7)
+#define DA9052_BUCKPERI_BPERIEN                (1<<6)
+#define DA9052_BUCKPERI_BPERIHS                (1<<5)
+#define DA9052_BUCKPERI_VBPERI         (31<<0)
+
+/* LDO1 REGISTER */
+#define DA9052_LDO1_LDO1CONF                   (1<<7)
+#define DA9052_LDO1_LDO1EN                     (1<<6)
+#define DA9052_LDO1_VLDO1                      (31<<0)
+
+/* LDO2 REGISTER */
+#define DA9052_LDO2_LDO2CONF                   (1<<7)
+#define DA9052_LDO2_LDO2EN                     (1<<6)
+#define DA9052_LDO2_VLDO2                      (63<<0)
+
+/* LDO3 REGISTER */
+#define DA9052_LDO3_LDO3CONF                   (1<<7)
+#define DA9052_LDO3_LDO3EN                     (1<<6)
+#define DA9052_LDO3_VLDO3                      (63<<0)
+
+/* LDO4 REGISTER */
+#define DA9052_LDO4_LDO4CONF                   (1<<7)
+#define DA9052_LDO4_LDO4EN                     (1<<6)
+#define DA9052_LDO4_VLDO4                      (63<<0)
+
+/* LDO5 REGISTER */
+#define DA9052_LDO5_LDO5CONF                   (1<<7)
+#define DA9052_LDO5_LDO5EN                     (1<<6)
+#define DA9052_LDO5_VLDO5                      (63<<0)
+
+/* LDO6 REGISTER */
+#define DA9052_LDO6_LDO6CONF                   (1<<7)
+#define DA9052_LDO6_LDO6EN                     (1<<6)
+#define DA9052_LDO6_VLDO6                      (63<<0)
+
+/* LDO7 REGISTER */
+#define DA9052_LDO7_LDO7CONF                   (1<<7)
+#define DA9052_LDO7_LDO7EN                     (1<<6)
+#define DA9052_LDO7_VLDO7                      (63<<0)
+
+/* LDO8 REGISTER */
+#define DA9052_LDO8_LDO8CONF                   (1<<7)
+#define DA9052_LDO8_LDO8EN                     (1<<6)
+#define DA9052_LDO8_VLDO8                      (63<<0)
+
+/* LDO9 REGISTER */
+#define DA9052_LDO9_LDO9CONF                   (1<<7)
+#define DA9052_LDO9_LDO9EN                     (1<<6)
+#define DA9052_LDO9_VLDO9                      (63<<0)
+
+/* LDO10 REGISTER */
+#define DA9052_LDO10_LDO10CONF         (1<<7)
+#define DA9052_LDO10_LDO10EN                   (1<<6)
+#define DA9052_LDO10_VLDO10                    (63<<0)
+
+/* SUPPLY REGISTER */
+#define DA9052_SUPPLY_VLOCK                    (1<<7)
+#define DA9052_SUPPLY_VMEMSWEN         (1<<6)
+#define DA9052_SUPPLY_VPERISWEN                (1<<5)
+#define DA9052_SUPPLY_VLDO3GO          (1<<4)
+#define DA9052_SUPPLY_VLDO2GO          (1<<3)
+#define DA9052_SUPPLY_VBMEMGO          (1<<2)
+#define DA9052_SUPPLY_VBPROGO          (1<<1)
+#define DA9052_SUPPLY_VBCOREGO         (1<<0)
+
+/* PULLDOWN REGISTER */
+#define DA9052_PULLDOWN_LDO5PDDIS              (1<<5)
+#define DA9052_PULLDOWN_LDO2PDDIS              (1<<4)
+#define DA9052_PULLDOWN_LDO1PDDIS              (1<<3)
+#define DA9052_PULLDOWN_MEMPDDIS               (1<<2)
+#define DA9052_PULLDOWN_PROPDDIS               (1<<1)
+#define DA9052_PULLDOWN_COREPDDIS              (1<<0)
+
+/* BAT CHARGER REGISTER */
+
+/* CHARGER BUCK REGISTER */
+#define DA9052_CHGBUCK_CHGTEMP         (1<<7)
+#define DA9052_CHGBUCK_CHGUSBILIM              (1<<6)
+#define DA9052_CHGBUCK_CHGBUCKLP               (1<<5)
+#define DA9052_CHGBUCK_CHGBUCKEN               (1<<4)
+#define DA9052_CHGBUCK_ISETBUCK                (15<<0)
+
+/* WAIT COUNTER REGISTER */
+#define DA9052_WAITCONT_WAITDIR                (1<<7)
+#define DA9052_WAITCONT_RTCCLOCK               (1<<6)
+#define DA9052_WAITCONT_WAITMODE               (1<<5)
+#define DA9052_WAITCONT_EN32KOUT               (1<<4)
+#define DA9052_WAITCONT_DELAYTIME              (15<<0)
+
+/* ISET CONTROL REGISTER */
+#define DA9052_ISET_ISETDCIN                   (15<<4)
+#define DA9052_ISET_ISETVBUS                   (15<<0)
+
+/* BATTERY CHARGER CONTROL REGISTER */
+#define DA9052_BATCHG_ICHGPRE                  (3<<6)
+#define DA9052_BATCHG_ICHGBAT                  (63<<0)
+
+/* CHARGER COUNTER REGISTER */
+#define DA9052_CHG_CONT_VCHG_BAT               (31<<3)
+#define DA9052_CHG_CONT_TCTR                   (7<<0)
+
+/* INPUT CONTROL REGISTER */
+#define DA9052_INPUT_CONT_TCTR_MODE            (1<<7)
+#define DA9052_INPUT_CONT_VBUS_SUSP            (1<<4)
+#define DA9052_INPUT_CONT_DCIN_SUSP            (1<<3)
+
+/* CHARGING TIME REGISTER */
+#define DA9052_CHGTIME_CHGTIME                 (255<<0)
+
+/* BACKUP BATTERY CONTROL REGISTER */
+#define DA9052_BBATCONT_BCHARGERISET           (15<<4)
+#define DA9052_BBATCONT_BCHARGERVSET           (15<<0)
+
+/* LED REGISTERS */
+/* LED BOOST REGISTER */
+#define DA9052_BOOST_EBFAULT                   (1<<7)
+#define DA9052_BOOST_MBFAULT                   (1<<6)
+#define DA9052_BOOST_BOOSTFRQ          (1<<5)
+#define DA9052_BOOST_BOOSTILIM         (1<<4)
+#define DA9052_BOOST_LED3INEN          (1<<3)
+#define DA9052_BOOST_LED2INEN          (1<<2)
+#define DA9052_BOOST_LED1INEN          (1<<1)
+#define DA9052_BOOST_BOOSTEN                   (1<<0)
+
+/* LED COUNT REGISTER */
+#if defined(CONFIG_PMIC_DA9053BA)
+#define DA9052_LEDCONT_SELLEDMODE              (1<<7)
+#endif
+#define DA9052_LEDCONT_LED3ICONT               (1<<6)
+#define DA9052_LEDCONT_LED3RAMP                (1<<5)
+#define DA9052_LEDCONT_LED3EN          (1<<4)
+#define DA9052_LEDCONT_LED2RAMP                (1<<3)
+#define DA9052_LEDCONT_LED2EN          (1<<2)
+#define DA9052_LEDCONT_LED1RAMP                (1<<1)
+#define DA9052_LEDCONT_LED1EN          (1<<0)
+
+/* LEDMIN123  REGISTER */
+#define DA9052_LEDMIN123_LEDMINCURRENT (255<<0)
+
+/* LED1CONF  REGISTER */
+#define DA9052_LED1CONF_LED1CURRENT    (255<<0)
+
+/* LED2CONF  REGISTER */
+#define DA9052_LED2CONF_LED2CURRENT    (255<<0)
+
+/* LED3CONF  REGISTER */
+#define DA9052_LED3CONF_LED3CURRENT    (255<<0)
+
+/* LED COUNT  REGISTER */
+#define DA9052_LED_CONT_DIM                    (1<<7)
+
+/* ADC MAN registers */
+#define DA9052_ADC_MAN_MAN_CONV                (1<<4)
+#define DA9052_ADC_MAN_MUXSEL_VDDOUT   0
+#define DA9052_ADC_MAN_MUXSEL_ICH              (1<<0)
+#define DA9052_ADC_MAN_MUXSEL_TBAT             (1<<1)
+#define DA9052_ADC_MAN_MUXSEL_VBAT             (3<<0)
+#define DA9052_ADC_MAN_MUXSEL_AD4              (1<<2)
+#define DA9052_ADC_MAN_MUXSEL_AD5              (5<<0)
+#define DA9052_ADC_MAN_MUXSEL_AD6              (6<<0)
+#define DA9052_ADC_MAN_MUXSEL_VBBAT    (9<<0)
+
+/* ADC COUNT regsisters */
+#define DA9052_ADCCONT_COMP1V2EN               (1<<7)
+#define DA9052_ADCCONT_ADCMODE         (1<<6)
+#define DA9052_ADCCONT_TBATISRCEN              (1<<5)
+#define DA9052_ADCCONT_AD4ISRCEN               (1<<4)
+#define DA9052_ADCCONT_AUTOAD6EN               (1<<3)
+#define DA9052_ADCCONT_AUTOAD5EN               (1<<2)
+#define DA9052_ADCCONT_AUTOAD4EN               (1<<1)
+//#define DA9052_ADCCONT_AUTOVDDEN             (1<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT LOW register */
+#define DA9052_ADC_RES_LSB                     (3<<0)
+
+/* ADC 10 BIT MANUAL CONVERSION RESULT HIGH register */
+#define DA9052_ADCRESH_ADCRESMSB               (255<<0)
+
+/* VDD RES regsister*/
+#define DA9052_VDDRES_VDDOUTRES                (255<<0)
+
+/* VDD MON regsister*/
+#define DA9052_VDDMON_VDDOUTMON                (255<<0)
+
+/* ICHG_AV regsister*/
+#define DA9052_ICHGAV_ICHGAV                   (255<<0)
+
+/* ICHG_THD regsister*/
+#define DA9052_ICHGTHD_ICHGTHD         (255<<0)
+
+/* ICHG_END regsister*/
+#define DA9052_ICHGEND_ICHGEND         (255<<0)
+
+/* TBAT_RES regsister*/
+#define DA9052_TBATRES_TBATRES         (255<<0)
+
+/* TBAT_HIGHP regsister*/
+#define DA9052_TBATHIGHP_TBATHIGHP             (255<<0)
+
+/* TBAT_HIGHN regsister*/
+#define DA9052_TBATHIGHN_TBATHIGHN             (255<<0)
+
+/* TBAT_LOW regsister*/
+#define DA9052_TBATLOW_TBATLOW         (255<<0)
+
+/* T_OFFSET regsister*/
+#define DA9052_TOFFSET_TOFFSET         (255<<0)
+
+/* ADCIN4_RES regsister*/
+#define DA9052_ADCIN4RES_ADCIN4RES             (255<<0)
+
+/* ADCIN4_HIGH regsister*/
+#define DA9052_AUTO4HIGH_AUTO4HIGH             (255<<0)
+
+/* ADCIN4_LOW regsister*/
+#define DA9052_AUTO4LOW_AUTO4LOW               (255<<0)
+
+/* ADCIN5_RES regsister*/
+#define DA9052_ADCIN5RES_ADCIN5RES             (255<<0)
+
+/* ADCIN5_HIGH regsister*/
+#define DA9052_AUTO5HIGH_AUTOHIGH              (255<<0)
+
+/* ADCIN5_LOW regsister*/
+#define DA9052_AUTO5LOW_AUTO5LOW               (255<<0)
+
+/* ADCIN6_RES regsister*/
+#define DA9052_ADCIN6RES_ADCIN6RES             (255<<0)
+
+/* ADCIN6_HIGH regsister*/
+#define DA9052_AUTO6HIGH_AUTO6HIGH             (255<<0)
+
+/* ADCIN6_LOW regsister*/
+#define DA9052_AUTO6LOW_AUTO6LOW               (255<<0)
+
+/* TJUNC_RES regsister*/
+#define DA9052_TJUNCRES_TJUNCRES               (255<<0)
+
+/* TSI REGISTER */
+
+/* TSI Control Register A */
+#define DA9052_TSICONTA_TSIDELAY               (3<<6)
+#define DA9052_TSICONTA_TSISKIP                (7<<3)
+#define DA9052_TSICONTA_TSIMODE                (1<<2)
+#define DA9052_TSICONTA_PENDETEN               (1<<1)
+#define DA9052_TSICONTA_AUTOTSIEN              (1<<0)
+
+/* TSI Control Register B */
+#define DA9052_TSICONTB_ADCREF         (1<<7)
+#define DA9052_TSICONTB_TSIMAN         (1<<6)
+#define DA9052_TSICONTB_TSIMUX         (3<<4)
+#define DA9052_TSICONTB_TSISEL3                (1<<3)
+#define DA9052_TSICONTB_TSISEL2                (1<<2)
+#define DA9052_TSICONTB_TSISEL1                (1<<1)
+#define DA9052_TSICONTB_TSISEL0                (1<<0)
+
+/* TSI X Co-ordinate MSB Result register */
+#define DA9052_TSIXMSB_TSIXM                   (255<<0)
+
+/* TSI Y Co-ordinate MSB Result register */
+#define DA9052_TSIYMSB_TSIYM                   (255<<0)
+
+/* TSI Co-ordinate LSB Result register */
+#define DA9052_TSILSB_PENDOWN          (1<<6)
+#define DA9052_TSILSB_TSIZL                    (3<<4)
+#define DA9052_TSILSB_TSIYL                    (3<<2)
+#define DA9052_TSILSB_TSIXL                    (3<<0)
+
+/* TSI Z Measurement MSB Result register */
+#define DA9052_TSIZMSB_TSIZM                   (255<<0)
+
+/* RTC REGISTER */
+
+/* RTC TIMER SECONDS REGISTER */
+#define DA9052_COUNTS_MONITOR          (1<<6)
+#define DA9052_RTC_SEC                         (63<<0)
+
+/* RTC TIMER MINUTES REGISTER */
+#define DA9052_RTC_MIN                         (63<<0)
+
+/* RTC TIMER HOUR REGISTER */
+#define DA9052_RTC_HOUR                        (31<<0)
+
+/* RTC TIMER DAYS REGISTER */
+#define DA9052_RTC_DAY                         (31<<0)
+
+/* RTC TIMER MONTHS REGISTER */
+#define DA9052_RTC_MONTH                       (15<<0)
+
+/* RTC TIMER YEARS REGISTER */
+#define DA9052_RTC_YEAR                        (63<<0)
+
+/* RTC ALARM MINUTES REGISTER */
+#define DA9052_ALARMM_I_TICK_TYPE              (1<<7)
+#define DA9052_ALARMMI_ALARMTYPE               (1<<6)
+
+/* RTC ALARM YEARS REGISTER */
+#define DA9052_ALARM_Y_TICK_ON         (1<<7)
+#define DA9052_ALARM_Y_ALARM_ON                (1<<6)
+
+/* RTC SECONDS REGISTER  A*/
+#define DA9052_SECONDA_SECONDSA                (255<<0)
+
+/* RTC SECONDS REGISTER  B*/
+#define DA9052_SECONDB_SECONDSB                (255<<0)
+
+/* RTC SECONDS REGISTER  C*/
+#define DA9052_SECONDC_SECONDSC                (255<<0)
+
+/* RTC SECONDS REGISTER  D*/
+#define DA9052_SECONDD_SECONDSD                (255<<0)
+
+/* OTP REGISTER */
+
+/* CHIP IDENTIFICATION REGISTER */
+#define DA9052_CHIPID_MRC                      (15<<4)
+#define DA9052_CHIPID_TRC                      (15<<0)
+
+/* CONFIGURATION IDENTIFICATION REGISTER */
+#define DA9052_CONFIGID_CUSTOMERID             (31<<3)
+#define DA9052_CONFIGID_CONFID         (7<<0)
+
+/* OTP CONTROL REGISTER */
+#define DA9052_OTPCONT_GPWRITEDIS              (1<<7)
+#define DA9052_OTPCONT_OTPCONFLOCK             (1<<6)
+#define DA9052_OTPCONT_OTPGPLOCK               (1<<5)
+#define DA9052_OTPCONT_OTPCONFG                (1<<3)
+#define DA9052_OTPCONT_OTPGP                   (1<<2)
+#define DA9052_OTPCONT_OTPRP                   (1<<1)
+#define DA9052_OTPCONT_OTPTRANSFER             (1<<0)
+
+/* RTC OSCILLATOR TRIM REGISTER */
+#define DA9052_OSCTRIM_TRIM32K         (255<<0)
+
+/* GP ID REGISTER 0 */
+#define DA9052_GPID0_GP0                       (255<<0)
+
+/* GP ID REGISTER 1 */
+#define DA9052_GPID1_GP1                       (255<<0)
+
+/* GP ID REGISTER 2 */
+#define DA9052_GPID2_GP2                       (255<<0)
+
+/* GP ID REGISTER 3 */
+#define DA9052_GPID3_GP3                       (255<<0)
+
+/* GP ID REGISTER 4 */
+#define DA9052_GPID4_GP4                       (255<<0)
+
+/* GP ID REGISTER 5 */
+#define DA9052_GPID5_GP5                       (255<<0)
+
+/* GP ID REGISTER 6 */
+#define DA9052_GPID6_GP6                       (255<<0)
+
+/* GP ID REGISTER 7 */
+#define DA9052_GPID7_GP7                       (255<<0)
+
+/* GP ID REGISTER 8 */
+#define DA9052_GPID8_GP8                       (255<<0)
+
+/* GP ID REGISTER 9 */
+#define DA9052_GPID9_GP9                       (255<<0)
+
+
+#endif
+/* __LINUX_MFD_DA9052_REG_H */























Regards,
Ashish


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
