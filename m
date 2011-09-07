Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1IGQkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:40:46 -0400
Received: from maillog.nuvoton.com ([202.39.227.15]:41970 "EHLO
	maillog.nuvoton.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1IGQkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:40:43 -0400
From: <Dan.Morav@nuvoton.com>
To: <linux-kernel@vger.kernel.org>
CC: <debora@linux.vnet.ibm.com>, <srajiv@linux.vnet.ibm.com>,
        <m.selhorst@sirrix.com>
Date: Wed, 7 Sep 2011 10:25:14 +0300
Subject: [PATCH] TPM Nuvoton I2C driver, kernel 3.0
Thread-Topic: [PATCH] TPM Nuvoton I2C driver, kernel 3.0
Thread-Index: AcsjL1RqPrwKgd0VSSCyWVc0xyLCKwUZVV8ARKiINbAEojOzgAP0vk+Q
Message-ID: <8F2A7B0931C16B4C99DDA3B283A4363087421989@ntilml01.nuvoton.com>
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
 <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com>
 <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
 <8F2A7B0931C16B4C99DDA3B283A436305988915E@ntilml01.nuvoton.com>
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A436305988915E@ntilml01.nuvoton.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87GfJDe021042

Hi,

Below are the additions for WPCT301/NPCT501 Nuvoton Technology TPM with I2C interface device driver.
This driver uses Linux I2C bus driver to interface with the I2C bus and Linux TPM driver (tpm.ko), to export the standard Linux TPM interface.
This driver requires an I2C bus driver and TPM driver (tpm.ko) to be loaded prior to its loading.
This driver tested on Linux kernel version 3.0-rc7 on an x86 based platform.

Regards,
Dan.

Signed-off-by: Dan Morav <dmorav@nuvoton.com>

diff -uprN linux-3.0-rc7/drivers/char/tpm/Kconfig linux/drivers/char/tpm/Kconfig
--- linux-3.0-rc7/drivers/char/tpm/Kconfig      2011-07-12 02:51:52.000000000 +0300
+++ linux/drivers/char/tpm/Kconfig      2011-08-17 13:15:28.062485000 +0300
@@ -60,4 +60,13 @@ config TCG_INFINEON
          Further information on this driver and the supported hardware
          can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/

+config TCG_NUVOTON_I2C
+       tristate "Nuvoton Technology Corp. TPM 1.2 I2C Interface"
+       depends on I2C
+       ---help---
+         If you have a TPM security chip with I2C interface from
+         Nuvoton Technology Corp. say Yes and it will be accessible
+         from within Linux.  To compile this driver as a module, choose
+         M here; the module will be called tpm_nuvoton_i2c.
+
 endif # TCG_TPM
diff -uprN linux-3.0-rc7/drivers/char/tpm/Makefile linux/drivers/char/tpm/Makefile
--- linux-3.0-rc7/drivers/char/tpm/Makefile     2011-07-12 02:51:52.000000000 +0300
+++ linux/drivers/char/tpm/Makefile     2011-05-02 10:15:28.000000000 +0300
@@ -9,3 +9,4 @@ obj-$(CONFIG_TCG_TIS) += tpm_tis.o
 obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
 obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
 obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
+obj-$(CONFIG_TCG_NUVOTON_I2C) += tpm_nuvoton_i2c.o
diff -uprN linux-3.0-rc7/drivers/char/tpm/tpm_nuvoton_i2c.c linux/drivers/char/tpm/tpm_nuvoton_i2c.c
--- linux-3.0-rc7/drivers/char/tpm/tpm_nuvoton_i2c.c    1970-01-01 02:00:00.000000000 +0200
+++ linux/drivers/char/tpm/tpm_nuvoton_i2c.c    2011-09-07 10:03:33.384833000 +0300
@@ -0,0 +1,719 @@
+/******************************************************************************
+ * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
+ * based on the TCG TPM Interface Spec version 1.2.
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * Copyright (C) 2011, Nuvoton Technology Corporation.
+ * dan.morav@nuvoton.com
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see http://www.gnu.org/licenses/>.
+ *
+ * Nuvoton contact information: APC.Support@nuvoton.com
+ *****************************************************************************/
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/i2c.h>
+#include "tpm.h"
+
+/* I2C interface offsets */
+#define TPM_STS                0x00
+#define TPM_BURST_COUNT        0x01
+#define TPM_DATA_FIFO_W        0x20
+#define TPM_DATA_FIFO_R        0x40
+#define TPM_VID_DID_RID        0x60
+/* TPM command header size */
+#define TPM_HEADER_SIZE        10
+#define TPM_RETRY      5
+/*
+ * I2C bus device maximum buffer size w/o counting I2C address or command
+ * i.e. max size required for I2C write is 34 = addr, command, 32 bytes data
+ */
+#define TPM_I2C_MAX_BUF_SIZE           32
+#define TPM_I2C_RETRY_COUNT            32
+#define TPM_I2C_BUS_DELAY              1       /* msec */
+#define TPM_I2C_RETRY_DELAY_SHORT      2       /* msec */
+#define TPM_I2C_RETRY_DELAY_LONG       10      /* msec */
+
+static inline void debug_hex_dump(const char *prefix_str, const void *buf,
+                                 size_t size)
+{
+#ifdef DEBUG
+       print_hex_dump(KERN_DEBUG, prefix_str, DUMP_PREFIX_NONE, 16, 1, buf,
+                      size, false);
+#endif
+}
+
+static s32 tpm_i2c_read_buf(struct i2c_client *client, u8 offset, u8 size,
+                           u8 *data)
+{
+       s32 status;
+
+       status = i2c_smbus_read_i2c_block_data(client, offset, size, data);
+       if (status > 0) {
+               dev_dbg(&(client->dev),
+                       "%s(%0x)-> sts=%d:", __func__, offset, status);
+               debug_hex_dump("data: ", data, size);
+       }
+
+       return status;
+}
+
+static s32 tpm_i2c_write_buf(struct i2c_client *client, u8 offset, u8 size,
+                            u8 *data)
+{
+       s32 status;
+
+       status = i2c_smbus_write_i2c_block_data(client, offset, size, data);
+       if (status >= 0) {
+               dev_dbg(&(client->dev),
+                       "%s(offset=%0x, size=%0x)-> sts=%d:", __func__, offset,
+                       size, status);
+               debug_hex_dump("data: ", data, size);
+       }
+
+       return status;
+}
+
+#define TPM_STS_VALID          0x80
+#define TPM_STS_COMMAND_READY  0x40
+#define TPM_STS_GO             0x20
+#define TPM_STS_DATA_AVAIL     0x10
+#define TPM_STS_EXPECT         0x08
+#define TPM_STS_RESPONSE_RETRY 0x02
+#define TPM_STS_ERR_VAL                0x07    /* bit2...bit0 reads always 0 */
+
+#define TPM_I2C_SHORT_TIMEOUT  750     /* ms */
+#define TPM_I2C_LONG_TIMEOUT   2000    /* 2 sec */
+
+/* read TPM_STS register */
+static u8 tpm_i2c_read_status(struct tpm_chip *chip)
+{
+       struct i2c_client *tpm_i2c_client = to_i2c_client(chip->dev);
+       s32 status;
+       u8 data;
+
+       status = tpm_i2c_read_buf(tpm_i2c_client, TPM_STS, 1, &data);
+       if (status <= 0) {
+               dev_err(chip->dev, "%s() error return %#02x\n", __func__,
+                       status);
+               data = TPM_STS_ERR_VAL;
+       }
+
+       return data;
+}
+
+/* write byte to TPM_STS register */
+static s32 tpm_i2c_write_status(struct i2c_client *tpm_i2c_client, u8 data)
+{
+       s32 status;
+       int i;
+
+       /* this causes the current command to be aborted */
+       for (i = 0, status = -1; i < TPM_I2C_RETRY_COUNT && status < 0; i++) {
+               status = tpm_i2c_write_buf(tpm_i2c_client, TPM_STS, 1, &data);
+               msleep(TPM_I2C_BUS_DELAY);
+       }
+       return status;
+}
+
+/* write commandReady to TPM_STS register */
+static void tpm_i2c_ready(struct tpm_chip *chip)
+{
+       struct i2c_client *tpm_i2c_client = to_i2c_client(chip->dev);
+       s32 status;
+
+       /* this causes the current command to be aborted */
+       status = tpm_i2c_write_status(tpm_i2c_client, TPM_STS_COMMAND_READY);
+       if (status < 0)
+               dev_err(chip->dev,
+                       "%s() fail to write TPM_STS.commandReady\n", __func__);
+}
+
+/* read burstCount field from TPM_STS register */
+/* return -1 on fail to read */
+static int tpm_i2c_get_burstcount(struct i2c_client *tpm_i2c_client,
+                                 struct tpm_chip *chip)
+{
+       unsigned long stop = jiffies + chip->vendor.timeout_d;
+       s32 status;
+       int burst_count = -1;
+       u8 data;
+
+       /* wait for burstcount to be non-zero */
+       do {
+               /* in I2C burstCount is 1 byte */
+               status = tpm_i2c_read_buf(tpm_i2c_client, TPM_BURST_COUNT, 1,
+                                         &data);
+               if (status > 0 && data > 0) {
+                       burst_count = min_t(u8, TPM_I2C_MAX_BUF_SIZE, data);
+                       break;
+               }
+               msleep(TPM_I2C_BUS_DELAY);
+       } while (time_before(jiffies, stop));
+
+       return burst_count;
+}
+
+/*
+ * WPCT301/NPCT501 SINT# supports only dataAvail
+ * any call to this function which is not waiting for dataAvail will
+ * set queue to NULL to avoid waiting for interrupt
+ */
+static bool tpm_i2c_check_status(struct tpm_chip *chip, u8 mask, u8 value)
+{
+       u8 status = tpm_i2c_read_status(chip);
+       return (status != TPM_STS_ERR_VAL) && ((status & mask) == value);
+}
+
+static int tpm_i2c_wait_for_stat(struct tpm_chip *chip, u8 mask, u8 value,
+                                u32 timeout, wait_queue_head_t *queue)
+{
+       unsigned long ten_msec, stop;
+       bool status_valid;
+       s32 rc;
+
+       /* check current status */
+       status_valid = tpm_i2c_check_status(chip, mask, value);
+       if (status_valid)
+               return 0;
+       if (chip->vendor.irq && !queue) {
+               /* use interrupt to wait for the event */
+               rc = wait_event_interruptible_timeout(*queue,
+                                               tpm_i2c_check_status(chip,
+                                                                       mask,
+                                                                       value),
+                                               timeout);
+               if (rc > 0)
+                       return 0;
+       } else {
+               /* use polling to wait for the event */
+               ten_msec = jiffies + msecs_to_jiffies(TPM_I2C_RETRY_DELAY_LONG);
+               stop = jiffies + timeout;
+               do {
+                       if (time_before(jiffies, ten_msec))
+                               msleep(TPM_I2C_RETRY_DELAY_SHORT);
+                       else
+                               msleep(TPM_I2C_RETRY_DELAY_LONG);
+                       status_valid = tpm_i2c_check_status(chip, mask, value);
+                       if (status_valid)
+                               return 0;
+               } while (time_before(jiffies, stop));
+       }
+       dev_err(chip->dev, "%s(%02x, %02x) -> timeout\n", __func__, mask,
+               value);
+       return -ETIMEDOUT;
+}
+
+/* wait for dataAvail field to be set in the TPM_STS register */
+static int tpm_i2c_wait_for_data_avail(struct tpm_chip *chip, u32 timeout,
+                                      wait_queue_head_t *queue)
+{
+       return tpm_i2c_wait_for_stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                                    TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                                    timeout, queue);
+}
+
+/* Read @count bytes into @buf from TPM_RD_FIFO register */
+static int tpm_i2c_recv_data(struct i2c_client *tpm_i2c_client,
+                            struct tpm_chip *chip, u8 * buf, size_t count)
+{
+       s32 rc;
+       int burst_count, bytes2read, size = 0;
+
+       while (size < count && tpm_i2c_wait_for_data_avail(chip,
+                                                       chip->vendor.timeout_c,
+                                                       NULL) == 0) {
+               burst_count = tpm_i2c_get_burstcount(tpm_i2c_client, chip);
+               if (burst_count < 0) {
+                       dev_err(chip->dev,
+                               "%s() fail to read burstCount=%d\n", __func__,
+                               burst_count);
+                       return -EIO;
+               }
+               bytes2read = min_t(size_t, burst_count, count - size);
+               rc = tpm_i2c_read_buf(tpm_i2c_client, TPM_DATA_FIFO_R,
+                                     bytes2read, &buf[size]);
+               if (rc < 0) {
+                       dev_err(chip->dev,
+                               "%s() fail on tpm_i2c_read_buf()=%d\n",
+                               __func__, rc);
+                       return -EIO;
+               }
+               dev_dbg(chip->dev, "%s(%d):", __func__, bytes2read);
+               size += bytes2read;
+       }
+
+       return size;
+}
+
+/* Read TPM command results */
+static int tpm_i2c_recv(struct tpm_chip *chip, u8 * buf, size_t count)
+{
+       struct device *dev = chip->dev;
+       struct i2c_client *tpm_i2c_client = to_i2c_client(dev);
+       s32 rc;
+       int expected, status, burst_count, retries, size = 0;
+
+       if (count < TPM_HEADER_SIZE) {
+               tpm_i2c_ready(chip);    /* return to idle */
+               dev_err(dev, "%s() count < header size\n", __func__);
+               return -EIO;
+       }
+       for (retries = 0; retries < TPM_RETRY; retries++) {
+               if (retries > 0) {
+                       /* if this is not the first trial, set responseRetry */
+                       tpm_i2c_write_status(tpm_i2c_client,
+                                            TPM_STS_RESPONSE_RETRY);
+               }
+               /*
+                * read first available (> 10 bytes), including:
+                * tag, paramsize, and result
+                */
+               status = tpm_i2c_wait_for_data_avail(chip,
+                                                    chip->vendor.timeout_c,
+                                                    &chip->vendor.read_queue);
+               if (status != 0) {
+                       dev_err(dev, "%s() timeout on dataAvail\n", __func__);
+                       size = -ETIMEDOUT;
+                       continue;
+               }
+               burst_count = tpm_i2c_get_burstcount(tpm_i2c_client, chip);
+               if (burst_count < 0) {
+                       dev_err(dev, "%s() fail to get burstCount\n", __func__);
+                       size = -EIO;
+                       continue;
+               }
+               size = tpm_i2c_recv_data(tpm_i2c_client, chip, buf,
+                                        burst_count);
+               if (size < TPM_HEADER_SIZE) {
+                       dev_err(dev, "%s() fail to read header\n", __func__);
+                       size = -EIO;
+                       continue;
+               }
+               /*
+                * convert number of expected bytes field from big endian 32 bit
+                * to machine native
+                */
+               expected = be32_to_cpu(*(__be32 *) (buf + 2));
+               if (expected > count) {
+                       dev_err(dev, "%s() expected > count\n", __func__);
+                       size = -EIO;
+                       continue;
+               }
+               rc = tpm_i2c_recv_data(tpm_i2c_client, chip, &buf[size],
+                                      expected - size);
+               size += rc;
+               if (rc < 0 || size < expected) {
+                       dev_err(dev, "%s() fail to read remainder of result\n",
+                               __func__);
+                       size = -EIO;
+                       continue;
+               }
+               if (tpm_i2c_wait_for_stat(chip,
+                                         TPM_STS_VALID | TPM_STS_DATA_AVAIL,
+                                         TPM_STS_VALID, chip->vendor.timeout_c,
+                                         NULL)) {
+                       dev_err(dev, "%s() error left over data\n", __func__);
+                       size = -ETIMEDOUT;
+                       continue;
+               }
+               break;
+       }
+       tpm_i2c_ready(chip);
+       dev_dbg(chip->dev, "%s() -> %d\n", __func__, size);
+       return size;
+}
+
+/*
+ * Send TPM command.
+ *
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+static int tpm_i2c_send(struct tpm_chip *chip, u8 * buf, size_t len)
+{
+       struct device *dev = chip->dev;
+       struct i2c_client *tpm_i2c_client = to_i2c_client(dev);
+       u32 ordinal;
+       size_t count = 0;
+       int burst_count, bytes2write, retries, rc = -EIO;
+
+       for (retries = 0; retries < TPM_RETRY; retries++) {
+               tpm_i2c_ready(chip);
+               if (tpm_i2c_wait_for_stat(chip, TPM_STS_COMMAND_READY,
+                                         TPM_STS_COMMAND_READY,
+                                         chip->vendor.timeout_b, NULL)) {
+                       dev_err(dev, "%s() timeout on commandReady\n",
+                               __func__);
+                       rc = -EIO;
+                       continue;
+               }
+               rc = 0;
+               while (count < len - 1) {
+                       burst_count = tpm_i2c_get_burstcount(tpm_i2c_client,
+                                                            chip);
+                       if (burst_count < 0) {
+                               dev_err(dev, "%s() fail get burstCount\n",
+                                       __func__);
+                               rc = -EIO;
+                               break;
+                       }
+                       bytes2write = min_t(size_t, burst_count,
+                                           len - 1 - count);
+                       rc = tpm_i2c_write_buf(tpm_i2c_client, TPM_DATA_FIFO_W,
+                                              bytes2write, &buf[count]);
+                       if (rc < 0) {
+                               dev_err(dev, "%s() fail i2cWriteBuf\n",
+                                       __func__);
+                               break;
+                       }
+                       dev_dbg(dev, "%s(%d):", __func__, bytes2write);
+                       count += bytes2write;
+                       rc = tpm_i2c_wait_for_stat(chip,
+                                                  TPM_STS_VALID |
+                                                  TPM_STS_EXPECT,
+                                                  TPM_STS_VALID |
+                                                  TPM_STS_EXPECT,
+                                                  chip->vendor.timeout_c,
+                                                  NULL);
+                       if (rc < 0) {
+                               dev_err(dev, "%s() timeout on Expect\n",
+                                       __func__);
+                               rc = -ETIMEDOUT;
+                               break;
+                       }
+               }
+               if (rc < 0)
+                       continue;
+
+               /* write last byte */
+               rc = tpm_i2c_write_buf(tpm_i2c_client, TPM_DATA_FIFO_W, 1,
+                                      &buf[count]);
+               if (rc < 0) {
+                       dev_err(dev, "%s() fail to write last byte\n",
+                               __func__);
+                       rc = -EIO;
+                       continue;
+               }
+               dev_dbg(dev, "%s(last): %02x", __func__, buf[count]);
+               rc = tpm_i2c_wait_for_stat(chip, TPM_STS_VALID | TPM_STS_EXPECT,
+                                          TPM_STS_VALID,
+                                          chip->vendor.timeout_c, NULL);
+               if (rc) {
+                       dev_err(dev, "%s() timeout on Expect to clear\n",
+                               __func__);
+                       rc = -ETIMEDOUT;
+                       continue;
+               }
+               break;
+       }
+       if (rc < 0) {
+               /* retries == TPM_RETRY */
+               tpm_i2c_ready(chip);
+               return rc;
+       }
+       /* execute the TPM command */
+       rc = tpm_i2c_write_status(tpm_i2c_client, TPM_STS_GO);
+       if (rc < 0) {
+               dev_err(dev, "%s() fail to write Go\n", __func__);
+               tpm_i2c_ready(chip);
+               return rc;
+       }
+       ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+       rc = tpm_i2c_wait_for_data_avail(chip,
+                                        tpm_calc_ordinal_duration(chip,
+                                                                  ordinal),
+                                        &chip->vendor.read_queue);
+       if (rc) {
+               dev_err(dev, "%s() timeout command duration\n", __func__);
+               tpm_i2c_ready(chip);
+               return rc;
+       }
+
+       dev_dbg(dev, "%s() -> %d\n", __func__, len);
+       return len;
+}
+
+static const struct file_operations tpm_i2c_ops = {
+       .owner = THIS_MODULE,
+       .llseek = no_llseek,
+       .open = tpm_open,
+       .read = tpm_read,
+       .write = tpm_write,
+       .release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+
+static struct attribute *tpm_i2c_attrs[] = {
+       &dev_attr_pubek.attr,
+       &dev_attr_pcrs.attr,
+       &dev_attr_enabled.attr,
+       &dev_attr_active.attr,
+       &dev_attr_owned.attr,
+       &dev_attr_temp_deactivated.attr,
+       &dev_attr_caps.attr,
+       &dev_attr_cancel.attr,
+       NULL,
+};
+
+static struct attribute_group tpm_i2c_attr_grp = {
+       .attrs = tpm_i2c_attrs
+};
+
+static struct tpm_vendor_specific tpm_i2c = {
+       .status = tpm_i2c_read_status,
+       .recv = tpm_i2c_recv,
+       .send = tpm_i2c_send,
+       .cancel = tpm_i2c_ready,
+       .req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+       .req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+       .req_canceled = TPM_STS_COMMAND_READY,
+       .attr_group = &tpm_i2c_attr_grp,
+       .miscdev = {
+                   .fops = &tpm_i2c_ops,
+                   },
+};
+
+static irqreturn_t tpm_i2c_int_handler(int dummy, void *dev_id)
+{
+       struct tpm_chip *chip = dev_id;
+
+       /* in I2C interrupt is triggeted only on dataAvail */
+       wake_up_interruptible(&chip->vendor.read_queue);
+
+       /*
+        * consider disabling the interrupt in the host
+        * in case of interrupt storm as TPM SINT# is level interrupt
+        * which is cleared only when dataAvail is cleared
+        */
+       return IRQ_HANDLED;
+}
+
+static const u8 vid_did_rid_value[] = { 0x50, 0x10, 0xfe };
+
+static int tpm_i2c_detect(struct i2c_client *client,
+                         struct i2c_board_info *info)
+{
+       struct i2c_adapter *adapter = client->adapter;
+       struct device *dev = &(client->dev);
+       u32 temp;
+       s32 rc;
+
+       if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+               return -ENODEV;
+       rc = tpm_i2c_read_buf(client, TPM_VID_DID_RID, 4, (u8 *)&temp);
+       if (rc < 0) {
+               dev_err(dev, "%s() fail read VID/DID/RID => %d\n", __func__,
+                       rc);
+               return -ENODEV;
+       }
+       dev_dbg(dev, "%s() VID: %04X DID: %02X RID: %02X\n", __func__,
+               (u16) temp, (u8) (temp >> 16), (u8) (temp >> 24));
+       /* check WPCT301 values - ignore RID */
+       if (memcmp(&temp, vid_did_rid_value, sizeof(vid_did_rid_value))) {
+               /*
+                * f/w rev 2.81 has an issue where the VID_DID_RID is not
+                * reporting the right value. so give it another chance at
+                * offset 0x20 (FIFO_W).
+                */
+               rc = tpm_i2c_read_buf(client, TPM_DATA_FIFO_W, 4,
+                                     (u8 *) (&temp));
+               if (rc < 0) {
+                       dev_err(dev, "%s() fail to read VID/DID/RID. "
+                               "status=%d\n", __func__, rc);
+                       return -ENODEV;
+               }
+               dev_dbg(dev, "%s() VID: %04X DID: %02X RID: %02X\n", __func__,
+                       (u16) temp, (u8) (temp >> 16), (u8) (temp >> 24));
+
+               /* check WPCT301 values - ignore RID */
+               if (memcmp(&temp, vid_did_rid_value,
+                       sizeof(vid_did_rid_value))) {
+                       dev_err(dev, "%s() WPCT301/NPCT501 not found\n",
+                               __func__);
+                       return -ENODEV;
+               }
+       }
+
+       strlcpy(info->type, "tpm_i2c", I2C_NAME_SIZE);
+       dev_info(dev, "tpm_i2c VID: %04X DID: %02X RID: %02X\n", (u16) temp,
+                (u8) (temp >> 16), (u8) (temp >> 24));
+
+       return 0;
+}
+
+static int tpm_i2c_probe(struct i2c_client *client,
+                        const struct i2c_device_id *id)
+{
+       int rc;
+       struct tpm_chip *chip;
+       struct device *dev = &client->dev;
+       void (*release) (struct device *dev) = dev->release;
+
+       chip = tpm_register_hardware(dev, &tpm_i2c);
+       if (!chip) {
+               dev_err(dev, "%s() error in tpm_register_hardware\n", __func__);
+               return -ENODEV;
+       }
+       /*
+        * restore dev->release function as it is modified by tpm_register_dev.
+        * save the assigned release function in chip->release for backup.
+        */
+       chip->release = dev->release;
+       dev->release = release;
+
+       /* Default timeouts */
+       chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+       chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
+       chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+       chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
+
+       /*
+        * I2C intfcaps (interrupt capabilitieis) are hard coded to:
+        *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
+        */
+
+       /* INTERRUPT Setup */
+       init_waitqueue_head(&chip->vendor.read_queue);
+       init_waitqueue_head(&chip->vendor.int_queue);
+
+       /* I2C intmask is hard coded to TPM_INTF_DATA_AVAIL_INT */
+       if (chip->vendor.irq) {
+               dev_dbg(dev, "%s() chip-vendor.irq\n", __func__);
+               rc = request_irq(chip->vendor.irq, tpm_i2c_int_handler,
+                                IRQF_PROBE_SHARED, chip->vendor.miscdev.name,
+                                chip);
+               if (rc) {
+                       dev_err(dev, "%s() Unable to request irq: %d for use\n",
+                               __func__, chip->vendor.irq);
+                       chip->vendor.irq = 0;
+               } else {
+                       /* Clear any pending interrupt */
+                       tpm_i2c_ready(chip);
+                       /* - wait for TPM_STS==0xA0 (stsValid, commandReady) */
+                       rc = tpm_i2c_wait_for_stat(chip, TPM_STS_COMMAND_READY,
+                                                  TPM_STS_COMMAND_READY,
+                                                  chip->vendor.timeout_b,
+                                                  NULL);
+                       if (rc == 0) {
+                               /*
+                                * TIS is in ready state
+                                * write dummy byte to enter reception state
+                                * TPM_DATA_FIFO_W <- rc (0)
+                                */
+                               rc = tpm_i2c_write_buf(client, TPM_DATA_FIFO_W,
+                                                      1, (u8 *) (&rc));
+                               if (rc < 0)
+                                       goto out_err;
+                               /* TPM_STS <- 0x40 (commandReady) */
+                               tpm_i2c_ready(chip);
+                       } else {
+                               /*
+                                * timeout_b reached - command was
+                                * aborted. TIS should now be in idle state -
+                                * only TPM_STS_VALID should be set
+                                */
+                               if (tpm_i2c_read_status(chip) !=
+                                       TPM_STS_VALID) {
+                                       rc = -EIO;
+                                       goto out_err;
+                               }
+                       }
+               }
+       }
+
+       tpm_get_timeouts(chip);
+       tpm_continue_selftest(chip);
+
+       return 0;
+
+out_err:
+       tpm_remove_hardware(chip->dev);
+       return rc;
+}
+
+static int tpm_i2c_remove(struct i2c_client *client)
+{
+       struct device *dev = &(client->dev);
+       struct tpm_chip *chip = dev_get_drvdata(dev);
+
+       if (chip) {
+               tpm_dev_vendor_release(chip);
+               if (chip->vendor.irq)
+                       free_irq(chip->vendor.irq, chip);
+       }
+       tpm_remove_hardware(dev);
+       kfree(chip);
+       return 0;
+}
+
+static int tpm_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+       return tpm_pm_suspend(&client->dev, mesg);
+}
+
+static int tpm_i2c_resume(struct i2c_client *client)
+{
+       return tpm_pm_resume(&client->dev);
+}
+
+static const struct i2c_device_id tpm_i2c_id[] = { {"tpm_i2c", 0}, {} };
+
+/* I2C Addresses to scan */
+static const u16 normal_i2c[] = { 0x17, 0x57, I2C_CLIENT_END };
+
+static struct i2c_driver tpm_i2c_driver = {
+       .driver = {
+                  .name = "tpm_i2c",
+                  },
+       .probe = tpm_i2c_probe,
+       .remove = tpm_i2c_remove,
+       .id_table = tpm_i2c_id,
+       .detect = tpm_i2c_detect,
+       .address_list = normal_i2c,
+       .suspend = tpm_i2c_suspend,
+       .resume = tpm_i2c_resume,
+       .class = UINT_MAX,
+};
+
+static int __init tpm_i2c_init(void)
+{
+       return i2c_add_driver(&tpm_i2c_driver);
+}
+
+static void __exit tpm_i2c_exit(void)
+{
+       i2c_del_driver(&tpm_i2c_driver);
+}
+
+module_init(tpm_i2c_init);
+module_exit(tpm_i2c_exit);
+
+MODULE_AUTHOR("Dan Morav (dan.morav@nuvoton.com)");
+MODULE_DESCRIPTION("Nuvoton TPM I2C Driver");
+MODULE_LICENSE("GPL");

===========================================================================================
The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
