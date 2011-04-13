Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1DMMHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:07:35 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:54347 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1DMMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:07:34 -0400
X-SpamScore: 1
X-BigFish: VPS1(zz936eKc8kzz1202hzz8275bh84d07hz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "dtor@mail.ru" <dtor@mail.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Apr 2011 17:37:20 +0530
Subject: [PATCHv1 8/11] Touch: Touch screen module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 8/11] Touch: Touch screen module of DA9052 PMIC driver
Thread-Index: Acv501bzNx+iUpxFReeNkAgQet2rmA==
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B619737@KCINPUNHJCMS01.kpit.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3DC7lAL011242

Hi Randy,

Touch Screen Driver for Dialog Semiconductor DA9052 PMICs.

Changes made since last submission:
. Ported the driver to Linux kernel 2.6.38.2

Linux Kernel Version: 2.6.38.2

Signed-off-by: D. Chen <dchen@diasemi.com>
---
diff -Naur linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi.c wrk_linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi.c
--- linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi.c       1970-01-01 05:00:00.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi.c   2011-04-13 15:28:20.000000000 +0500
@@ -0,0 +1,474 @@
+/*
+ * TSI driver for Dialog DA9052
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
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+
+#include <linux/mfd/da9052/reg.h>
+#include <linux/mfd/da9052/tsi.h>
+#include <linux/mfd/da9052/gpio.h>
+#include <linux/mfd/da9052/pdata.h>
+
+ssize_t tsi_process_thread(void *ptr);
+
+int da9052_fifo_lengthToEnd(struct da9052_tsi_fifo *fifo, long op)
+{
+       if (op == idRead)
+               return TSI_FIFO_SIZE - fifo->m_read;
+       else
+               return TSI_FIFO_SIZE - fifo->m_write;
+}
+
+inline void da9052_fifo_incpos(struct da9052_tsi_fifo *fifo, int inc, int op)
+{
+       int *pos;
+
+       if (inc < 0 || inc > TSI_FIFO_SIZE)
+               return;
+
+       pos = &fifo->m_write;
+       if (op == idRead)
+               pos = &fifo->m_read;
+
+       if (*pos < TSI_FIFO_SIZE - 1)
+               *pos += inc;
+       else
+               *pos = 0;
+
+       if (fifo->m_read == fifo->m_write) {
+               fifo->m_wrapType = idWriteWrap;
+               if (op == idRead)
+                       fifo->m_wrapType = idReadWrap;
+       } else
+               fifo->m_wrapType = idNoWrap;
+
+       return;
+}
+
+void da9052_fifo_getcount(int *count, long op,
+                       struct da9052_tsi_fifo *fifo)
+{
+       int write = fifo->m_write;
+       int read  = fifo->m_read;
+
+       *count = 0;
+       if (write == read)
+               *count = 0;
+       else if (write > read)
+               *count = (TSI_FIFO_SIZE - write) + read;
+       else
+               *count = read - write;
+
+       if (op == idRead && fifo->m_wrapType != idReadWrap)
+               *count = TSI_FIFO_SIZE - *count;
+
+       return;
+}
+
+inline void da9052_fifo_put(struct da9052_tsi_fifo *fifo,
+                       struct da9052_tsi_reg temp)
+{
+       memcpy(&fifo->fifo[fifo->m_write], &temp,
+                       sizeof(struct da9052_tsi_reg));
+       da9052_fifo_incpos(fifo, 1, idWrite);
+}
+
+struct da9052_tsi_reg da9052_fifo_get(struct da9052_tsi_fifo *fifo)
+{
+       struct da9052_tsi_reg temp;
+       long lenToEnd = da9052_fifo_lengthToEnd(fifo, idRead);
+
+       if (lenToEnd > 0)
+               memcpy(&temp, &fifo->fifo[fifo->m_read],
+                       sizeof(struct da9052_tsi_reg));
+       else
+               memcpy(&temp, &fifo->fifo[0],
+                       sizeof(struct da9052_tsi_reg));
+
+       da9052_fifo_incpos(fifo, 1, idRead);
+
+       return temp;
+}
+
+static inline int start_tsi(struct da9052_tsi *tsi)
+{
+       return da9052_reg_update(tsi->da9052, DA9052_TSICONT_A_REG,
+                               1 << 0, 1 << 0);
+}
+
+static inline int stop_tsi(struct da9052_tsi *tsi)
+{
+       return da9052_clear_bits(tsi->da9052, DA9052_TSICONT_A_REG, 1 << 0);
+}
+
+static irqreturn_t da9052_tsi_pendwn(int irq, void *data)
+{
+       struct da9052_tsi *tsi = (struct da9052_tsi *)data;
+       int ret = 0;
+
+       ret = da9052_mask_events(tsi->da9052, DA9052_E_PEN_DOWN);
+       if (ret < 0) {
+               dev_err(tsi->da9052->dev, "Failed to mask pen down event, %d\n", ret);
+               return IRQ_NONE;
+       }
+
+       ret = da9052_unmask_events(tsi->da9052, DA9052_E_TSI_READY);
+       if (ret < 0) {
+               dev_err(tsi->da9052->dev, "Failed to mask tsi ready event, %d\n", ret);
+               return IRQ_NONE;
+       }
+
+       start_tsi(tsi);
+
+       tsi->pen_state = DA9052_PEN_DOWN;
+
+       return IRQ_HANDLED;
+}
+
+static int read_tsi(struct da9052_tsi *tsi)
+{
+       struct da9052_tsi_reg co_ord = {0, 0};
+       int ret;
+       uint8_t _x, _y, _v;
+
+       ret = da9052_reg_read(tsi->da9052, DA9052_TSIXMSB_REG);
+       if (ret < 0)
+               return ret;
+       _x = (uint8_t) ret;
+
+       ret = da9052_reg_read(tsi->da9052, DA9052_TSIYMSB_REG);
+       if (ret < 0)
+               return ret;
+
+       _y = (uint8_t) ret;
+
+       ret = da9052_reg_read(tsi->da9052, DA9052_TSILSB_REG);
+       if (ret < 0)
+               return ret;
+
+       _v = (uint8_t) ret;
+
+       co_ord.x = ((_x << 2) & 0x3fc) | (_v & 0x3);
+       co_ord.y = ((_y << 2) & 0x3fc) | ((_v & 0xc) >> 2);
+
+       da9052_fifo_put(&tsi->tsi_fifo, co_ord);
+
+       tsi->adc_cnt++;
+
+       return 0;
+}
+
+
+static irqreturn_t da9052_tsi_datardy(int irq, void *data)
+{
+       struct da9052_tsi *tsi = (struct da9052_tsi *)data;
+       int ret = 0;
+
+       ret = read_tsi(tsi);
+       if (ret) {
+                       dev_err(tsi->da9052->dev,
+                               "Failed to read TSI co-ordinate, %d\n", ret);
+                       return IRQ_NONE;
+       }
+
+       return IRQ_HANDLED;
+}
+
+void da9052_tsi_process_reg_data(struct da9052_tsi *tsi)
+{
+       struct da9052_tsi_reg tmp_raw_data;
+       u32 reg_data_cnt;
+
+       da9052_fifo_getcount(&reg_data_cnt, idRead, &tsi->tsi_fifo);
+
+       while (reg_data_cnt-- > 0) {
+               tmp_raw_data =  da9052_fifo_get(&tsi->tsi_fifo);
+               da9052_fifo_put(&tsi->tsi_fifo_buf, tmp_raw_data);
+       }
+       return;
+}
+
+static void da9052_report_penup(struct da9052_tsi *tsi)
+{
+
+       struct input_dev *ip_dev = tsi->dev;
+       ssize_t ret = 0;
+
+       ret = stop_tsi(tsi);
+       if (ret < 0)
+               return;
+
+       ret = da9052_mask_events(tsi->da9052, DA9052_E_TSI_READY);
+       if (ret < 0)
+               return;
+
+       ret = da9052_unmask_events(tsi->da9052, DA9052_E_PEN_DOWN);
+       if (ret < 0)
+               return;
+
+       input_report_abs(ip_dev, BTN_TOUCH, 0);
+       input_sync(ip_dev);
+
+       tsi->zero_data_cnt = 0;
+       tsi->adc_cnt = 0;
+       tsi->filter_cnt = 0;
+
+}
+
+static ssize_t monitor_pen_state(void *data)
+{
+       struct da9052_tsi *tsi = (struct da9052_tsi *) data;
+       u32 data_cnt;
+
+       set_freezable();
+
+       while (tsi->tsi_pen_state_thread.state == DA9052_ACTIVE) {
+               try_to_freeze();
+
+               set_current_state(TASK_INTERRUPTIBLE);
+               schedule_timeout(msecs_to_jiffies(10));
+
+               if (tsi->pen_state != DA9052_PEN_DOWN)
+                       continue;
+
+               da9052_fifo_getcount(&data_cnt, idRead, &tsi->tsi_fifo);
+               da9052_tsi_process_reg_data(tsi);
+
+               if (data_cnt)
+                       tsi->zero_data_cnt = 0;
+               else {
+                       if ((++(tsi->zero_data_cnt)) >
+                                                    tsi->valid_penup_count) {
+                               tsi->pen_state = DA9052_PEN_UP;
+                               da9052_report_penup(tsi);
+                       }
+               }
+       }
+
+       complete_and_exit(&tsi->tsi_pen_state_thread.notifier, 0);
+       return 0;
+}
+
+static ssize_t da9052_configure_gpio(struct da9052 *da9052)
+{
+       ssize_t ret = 0;
+
+       ret = da9052_clear_bits(da9052, DA9052_GPIO_2_3_REG, 0x30);
+       if (ret < 0)
+               return -EIO;
+
+       return ret;
+}
+
+
+static ssize_t __init da9052_tsi_enable_device(struct da9052_tsi *tsi)
+{
+
+       ssize_t ret = 0;
+
+       ret = da9052_configure_gpio(tsi->da9052);
+       if (ret < 0)
+               return ret;
+
+       ret = da9052_reg_update(tsi->da9052, DA9052_TSICONT_A_REG, 0xFC, 0xC0);
+       if (ret < 0)
+               return ret;
+
+       tsi->valid_penup_count = 5;
+
+       init_completion(&tsi->tsi_pen_state_thread.notifier);
+       tsi->tsi_pen_state_thread.state = DA9052_ACTIVE;
+       tsi->tsi_pen_state_thread.pid =
+                               kernel_thread(monitor_pen_state,
+                                       tsi, CLONE_KERNEL | SIGCHLD);
+
+       init_completion(&tsi->tsi_filter_thread.notifier);
+       tsi->tsi_filter_thread.state = DA9052_ACTIVE;
+       tsi->tsi_filter_thread.pid =
+                               kernel_thread(tsi_process_thread,
+                                       tsi, CLONE_KERNEL | SIGCHLD);
+
+       tsi->zero_data_cnt = 0;
+       tsi->adc_cnt = 0;
+       tsi->filter_cnt = 0;
+
+       ret = da9052_reg_update(tsi->da9052, DA9052_ADC_CONT_REG,
+                               1 << 6, 1 << 6);
+       if (ret < 0)
+               return ret;
+
+       ret = da9052_reg_update(tsi->da9052, DA9052_TSICONT_A_REG,
+                               1 << 1, 1 << 1);
+       if (ret < 0)
+               return ret;
+
+       ret = da9052_mask_events(tsi->da9052, DA9052_E_TSI_READY);
+       if (ret < 0)
+                       return ret;
+
+       ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x59);
+
+       return ret;
+}
+
+static s32 __devinit da9052_tsi_probe(struct platform_device *pdev)
+{
+
+       struct da9052_tsi *tsi;
+       struct input_dev *input_dev;
+       struct da9052_pdata  *pdata;
+       struct da9052 *da9052;
+       struct da9052_tsi_platform_data *ptsi;
+       int ret;
+
+       da9052 = dev_get_drvdata(pdev->dev.parent);
+       pdata = da9052->dev->platform_data;
+       ptsi = pdata->ptsi;
+
+       tsi = kzalloc(sizeof(struct da9052_tsi), GFP_KERNEL);
+       if (!tsi)
+               return -ENOMEM;
+
+       input_dev = input_allocate_device();
+       if (!input_dev) {
+               dev_err(tsi->da9052->dev,
+                               "failed to allocate input device\n");
+               ret = -ENOMEM;
+               goto err_mem;
+       }
+
+       tsi->da9052 = dev_get_drvdata(pdev->dev.parent);
+       tsi->pen_up_detect_interval = ptsi->pen_up_detect_interval;
+       platform_set_drvdata(pdev, tsi);
+
+       input_dev->id.version = 0x0101;
+       input_dev->id.vendor = 0x15B6;
+       input_dev->id.product = 0x9052;
+       input_dev->id.bustype = BUS_RS232;
+       input_dev->name = "Dialog DA9052 TouchScreen Driver";
+       input_dev->dev.parent   = &pdev->dev;
+       __set_bit(EV_ABS, input_dev->evbit);
+       __set_bit(EV_KEY, input_dev->evbit);
+       __set_bit(BTN_TOUCH, input_dev->keybit);
+       __set_bit(ABS_X, input_dev->absbit);
+       __set_bit(ABS_Y, input_dev->absbit);
+
+       input_set_abs_params(input_dev, ABS_X, 0, 1023, 0, 0);
+       input_set_abs_params(input_dev, ABS_Y, 0, 1023, 0, 0);
+       input_set_abs_params(input_dev, ABS_PRESSURE, 0, 1023, 0, 0);
+
+       tsi->dev = input_dev;
+       input_set_drvdata(input_dev, tsi);
+       ret = input_register_device(tsi->dev);
+       if (ret)
+               goto err_mem;
+
+       tsi->irq_pendwn = platform_get_irq_byname(pdev, "PENDWN");
+       ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_pendwn,
+                               NULL, da9052_tsi_pendwn,
+                               IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+                               "PENDWN", tsi);
+       if (ret < 0) {
+               dev_err(tsi->da9052->dev, "Failed to register %s IRQ %d, error = %d \n", "PENDWN",
+                       tsi->da9052->irq_base + tsi->irq_pendwn, ret);
+               goto err_mem;
+       }
+
+       tsi->irq_datardy = platform_get_irq_byname(pdev, "TSIRDY");
+       ret = request_threaded_irq(tsi->da9052->irq_base + tsi->irq_datardy,
+                               NULL, da9052_tsi_datardy,
+                               IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+                               "TSIRDY", tsi);
+       if (ret < 0) {
+               dev_err(tsi->da9052->dev, "Failed to register %s IRQ %d, error = %d \n", "TSIRDY",
+                       tsi->da9052->irq_base + tsi->irq_datardy,
+                       ret);
+               goto err_mem;
+       }
+
+       ret = da9052_tsi_enable_device(tsi);
+       if (ret < 0)
+               goto err_input;
+
+       tsi->adc_cnt = 0;
+       tsi->filter_cnt = 0;
+
+       return 0;
+
+err_input:
+       input_free_device(input_dev);
+err_mem:
+       kfree(tsi);
+       return ret;
+}
+
+static int __devexit da9052_tsi_remove(struct platform_device *pdev)
+{
+       struct da9052_tsi *tsi = platform_get_drvdata(pdev);
+       s32 ret = 0;
+
+       ret = da9052_clear_bits(tsi->da9052, DA9052_TSICONT_A_REG, 1 << 0);
+       if (ret < 0)
+               return ret;
+
+       ret = da9052_reg_write(tsi->da9052, DA9052_LDO9_REG, 0x19);
+       if (ret < 0)
+               return ret;
+
+       free_irq(tsi->da9052->irq_base + tsi->irq_pendwn, NULL);
+       free_irq(tsi->da9052->irq_base + tsi->irq_datardy, NULL);
+
+       tsi->tsi_pen_state_thread.state = DA9052_INACTIVE;
+       wait_for_completion(&tsi->tsi_pen_state_thread.notifier);
+
+       tsi->tsi_filter_thread.state = DA9052_INACTIVE;
+       wait_for_completion(&tsi->tsi_filter_thread.notifier);
+
+       input_unregister_device(tsi->dev);
+
+       platform_set_drvdata(pdev, NULL);
+
+       kfree(tsi);
+
+       return 0;
+}
+
+static struct platform_driver da9052_tsi_driver = {
+       .driver.name    = "da9052-tsi",
+       .driver.owner   = THIS_MODULE,
+       .probe          = da9052_tsi_probe,
+       .remove         = __devexit_p(da9052_tsi_remove),
+
+};
+
+static int __init da9052_tsi_init(void)
+{
+       return platform_driver_register(&da9052_tsi_driver);
+}
+module_init(da9052_tsi_init);
+
+static void __exit da9052_tsi_exit(void)
+{
+       platform_driver_unregister(&da9052_tsi_driver);
+
+}
+module_exit(da9052_tsi_exit);
+
+MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor DA9052");
+MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+
diff -Naur linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi_filter.c wrk_linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi_filter.c
--- linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi_filter.c        1970-01-01 05:00:00.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/input/touchscreen/da9052_tsi_filter.c    2011-04-13 15:27:09.000000000 +0500
@@ -0,0 +1,87 @@
+/*
+ * da9052_tsi_filter.c  --  TSI filter driver for Dialog DA9052
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
+#include <linux/input.h>
+#include <linux/freezer.h>
+#include <linux/mfd/da9052/tsi.h>
+
+#define DEFAULT_AVERAGE_FILTER_SIZE            3
+
+#if ENABLE_AVERAGE_FILTER
+static void da9052_tsi_avrg_filter(struct da9052_tsi *tsi,
+                                       struct da9052_tsi_reg *tsi_avg_data)
+{
+       u8 cnt;
+       struct da9052_tsi_reg temp;
+
+       *tsi_avg_data = da9052_fifo_get(&tsi->tsi_fifo_buf);
+
+       for (cnt = 2; cnt <= TSI_AVERAGE_FILTER_SIZE; cnt++) {
+
+               temp = da9052_fifo_get(&tsi->tsi_fifo_buf);
+               tsi_avg_data->x += temp.x;
+               tsi_avg_data->y += temp.y;
+
+       }
+
+
+       tsi_avg_data->x /= TSI_AVERAGE_FILTER_SIZE;
+       tsi_avg_data->y /= TSI_AVERAGE_FILTER_SIZE;
+
+       tsi->filter_cnt++;
+
+       return;
+}
+#endif
+
+ssize_t tsi_process_thread(void *ptr)
+{
+       struct da9052_tsi_reg coord;
+       int cnt = 0;
+       struct da9052_tsi *tsi = (struct da9052_tsi *)ptr;
+
+       set_freezable();
+
+       while (tsi->tsi_filter_thread.state == DA9052_ACTIVE) {
+
+               try_to_freeze();
+
+               set_current_state(TASK_INTERRUPTIBLE);
+               schedule_timeout(msecs_to_jiffies(10));
+               da9052_fifo_getcount(&cnt, idRead, &tsi->tsi_fifo_buf);
+
+               if (cnt == 0)
+                       continue;
+
+#if ENABLE_AVERAGE_FILTER
+               if (cnt < TSI_AVERAGE_FILTER_SIZE)
+                       continue;
+               da9052_tsi_avrg_filter(tsi, &coord);
+#else
+               coord =  da9052_fifo_get(&tsi->tsi_fifo_buf);
+#endif
+               input_report_abs(tsi->dev, BTN_TOUCH, 1);
+               input_report_abs(tsi->dev, ABS_X, coord.x);
+               input_report_abs(tsi->dev, ABS_Y, coord.y);
+               input_sync(tsi->dev);
+
+       }
+
+       tsi->tsi_filter_thread.thread_task = NULL;
+       complete_and_exit(&tsi->tsi_filter_thread.notifier, 0);
+
+       return 0;
+
+}
+
diff -Naur linux-2.6.38.2/drivers/input/touchscreen/Kconfig wrk_linux-2.6.38.2/drivers/input/touchscreen/Kconfig
--- linux-2.6.38.2/drivers/input/touchscreen/Kconfig    2011-03-27 23:37:20.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/input/touchscreen/Kconfig        2011-04-13 15:27:23.000000000 +0500
@@ -132,6 +132,13 @@
          Say Y here to enable the support for the touchscreen found
          on Dialog Semiconductor DA9034 PMIC.

+config TOUCHSCREEN_DA9052
+        tristate "Dialog DA9052 TSI"
+        depends on PMIC_DA9052
+        help
+          Say y here to support the touchscreen found on
+          Dialog Semiconductor DA9052 PMIC
+
 config TOUCHSCREEN_DYNAPRO
        tristate "Dynapro serial touchscreen"
        select SERIO
diff -Naur linux-2.6.38.2/drivers/input/touchscreen/Makefile wrk_linux-2.6.38.2/drivers/input/touchscreen/Makefile
--- linux-2.6.38.2/drivers/input/touchscreen/Makefile   2011-03-27 23:37:20.000000000 +0500
+++ wrk_linux-2.6.38.2/drivers/input/touchscreen/Makefile       2011-04-13 15:27:17.000000000 +0500
@@ -17,6 +17,8 @@
 obj-$(CONFIG_TOUCHSCREEN_BU21013)       += bu21013_ts.o
 obj-$(CONFIG_TOUCHSCREEN_CY8CTMG110)   += cy8ctmg110_ts.o
 obj-$(CONFIG_TOUCHSCREEN_DA9034)       += da9034-ts.o
+da9052-tsi-objs                                := da9052_tsi.o da9052_tsi_filter.o
+obj-$(CONFIG_TOUCHSCREEN_DA9052)               += da9052-tsi.o
 obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)      += dynapro.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)    += hampshire.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)                += gunze.o
diff -Naur linux-2.6.38.2/include/linux/mfd/da9052/tsi.h wrk_linux-2.6.38.2/include/linux/mfd/da9052/tsi.h
--- linux-2.6.38.2/include/linux/mfd/da9052/tsi.h       1970-01-01 05:00:00.000000000 +0500
+++ wrk_linux-2.6.38.2/include/linux/mfd/da9052/tsi.h   2011-04-13 15:27:55.000000000 +0500
@@ -0,0 +1,102 @@
+/*
+ * da9052 TSI module declarations.
+  *
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
+#ifndef __LINUX_MFD_DA9052_TSI_H
+#define __LINUX_MFD_DA9052_TSI_H
+
+#include <linux/mfd/da9052/da9052.h>
+
+#define TSI_FIFO_SIZE                  16
+#define ENABLE_AVERAGE_FILTER  1
+
+#define TSI_AVERAGE_FILTER_SIZE        3
+#define DA9052_ACTIVE                  1
+#define DA9052_INACTIVE                0
+
+enum {
+       DA9052_PEN_IDLE,
+       DA9052_PEN_DOWN,
+       DA9052_PEN_UP
+};
+
+
+
+enum {
+       idRead,
+       idWrite
+};
+
+enum {
+       idNoWrap,
+       idReadWrap,
+       idWriteWrap
+};
+
+struct da9052_tsi_reg {
+       u16     x;
+       u16     y;
+};
+
+struct da9052_tsi_fifo {
+       int m_write;
+       int m_read;
+       int m_wrapType;
+       struct da9052_tsi_reg fifo[TSI_FIFO_SIZE];
+
+};
+
+struct da9052_tsi_platform_data {
+       u8 pen_up_detect_interval;
+};
+
+struct tsi_thread_type {
+       u8              pid;
+       u8              state;
+       struct completion       notifier;
+       struct task_struct      *thread_task;
+} ;
+
+
+struct da9052_tsi {
+       struct da9052   *da9052;
+       struct input_dev *dev;
+       struct tsi_thread_type  tsi_pen_state_thread;
+       struct tsi_thread_type  tsi_filter_thread;
+       struct da9052_tsi_fifo tsi_fifo;
+       struct da9052_tsi_fifo tsi_fifo_buf;
+       struct da9052_tsi_reg read_buf[TSI_AVERAGE_FILTER_SIZE];
+       u32 pen_up_detect_interval;
+       u32 zero_data_cnt;
+       u32 valid_penup_count;
+       u8 pen_state;
+       int adc_cnt;
+       int filter_cnt;
+       int irq_pendwn;
+       int irq_datardy;
+};
+
+struct da9052_tsi_reg da9052_fifo_get(struct da9052_tsi_fifo *fifo);
+void da9052_fifo_put(struct da9052_tsi_fifo *fifo, struct da9052_tsi_reg temp);
+void da9052_fifo_getcount(int *count, long op, struct da9052_tsi_fifo *fifo);
+void da9052_fifo_incpos(struct da9052_tsi_fifo *fifo, int inc, int op);
+int da9052_fifo_lengthToEnd(struct da9052_tsi_fifo *fifo, long op);
+
+#endif /* __LINUX_MFD_DA9052_TSI_H */

Regards,
Ashish J


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
