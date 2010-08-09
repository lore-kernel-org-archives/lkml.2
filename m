Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab0HIJ0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:26:44 -0400
Received: from maillog.nuvoton.com ([202.39.227.15]:52474 "EHLO
	maillog.nuvoton.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0HIJ0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:26:42 -0400
From: <Dan.Morav@nuvoton.com>
To: <linux-kernel@vger.kernel.org>
CC: <debora@linux.vnet.ibm.com>, <srajiv@linux.vnet.ibm.co>,
        <m.selhorst@sirrix.com>, <Michal.Schramm@nuvoton.com>
Date: Mon, 9 Aug 2010 12:24:01 +0300
Subject: [PATCH] TPM Nuvoton I2C driver, kernel 2.6.35
Thread-Topic: [PATCH] TPM Nuvoton I2C driver, kernel 2.6.35
Thread-Index: AcsjL1RqPrwKgd0VSSCyWVc0xyLCKwUZVV8A
Message-ID: <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com>
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.1285-6.500.1024-17558.006
x-tm-as-result: No--28.855800-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below are the additions for WPCT301 Nuvoton Technology TPM with I2C interface device driver.
This driver uses Linux I2C bus driver to interface with the I2C bus and Linux TPM driver (tpm.ko), to export the standard Linux TPM interface.
This driver requires an I2C bus driver and TPM driver (tpm.ko) to be loaded prior to its loading.
This driver tested on Linux kernel version 2.6.31, on an x86 platform. Added the required I2C API changes applied in 2.6.33 to enable compilation.

Regards,
Dan.
_________________________
Dan Morav
Advanced PC
Nuvoton Technology Israel Ltd.
Office +972.9.970.2388
eMail: dan.morav@nuvoton.com

diff -uN linux-2.6.35/drivers/char/tpm/Kconfig linux/drivers/char/tpm/Kconfig
--- linux-2.6.35/drivers/char/tpm/Kconfig       2010-08-02 01:11:14.000000000 +0300
+++ linux/drivers/char/tpm/Kconfig      2010-08-08 23:08:32.017438534 +0300
@@ -33,6 +33,15 @@
          from within Linux.  To compile this driver as a module, choose
          M here; the module will be called tpm_tis.

+config TCG_NUVOTON_I2C
+       tristate "Nuvoton Technology Corp. TPM 1.2 I2C Interface"
+       depends on I2C
+       ---help---
+         If you have a TPM security chip with I2C interface from
+         Nuvoton Technology Corp. say Yes and it will be accessible
+         from within Linux.  To compile this driver as a module, choose
+         M here; the module will be called tpm_nuvoton_i2c.
+
 config TCG_NSC
        tristate "National Semiconductor TPM Interface"
        ---help---
diff -uN linux-2.6.35/drivers/char/tpm/Makefile linux/drivers/char/tpm/Makefile
--- linux-2.6.35/drivers/char/tpm/Makefile      2010-08-02 01:11:14.000000000 +0300
+++ linux/drivers/char/tpm/Makefile     2010-08-08 11:56:30.721438699 +0300
@@ -9,3 +9,4 @@
 obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
 obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
 obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
+obj-$(CONFIG_TCG_NUVOTON_I2C) += tpm_nuvoton_i2c.o
diff -uN linux-2.6.35/drivers/char/tpm/tpm_nuvoton_i2c.c linux/drivers/char/tpm/tpm_nuvoton_i2c.c
--- linux-2.6.35/drivers/char/tpm/tpm_nuvoton_i2c.c     1970-01-01 02:00:00.000000000 +0200
+++ linux/drivers/char/tpm/tpm_nuvoton_i2c.c    2010-08-08 20:29:24.469438926 +0300
@@ -0,0 +1,748 @@
+/******************************************************************************
+ * Nuvoton TPM I2C Device Driver Interface for WPCT301,
+ * based on the TCG TPM Interface Spec version 1.2.
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * Copyright (C) 2010, Nuvoton Technology Corporation.
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
+#include <linux/version.h>
+#include "tpm.h"
+
+/* I2C interface defintions */
+#define TPM_I2C_ADDR 0x57
+/* I2C interface offsets */
+#define TPM_STS         0x00
+#define TPM_DATA_FIFO_W 0x20
+#define TPM_DATA_FIFO_R 0x40
+#define TPM_VID_DID_RID 0x60
+/* I2C class required */
+#define I2C_CLASS_ALL (I2C_CLASS_HWMON | I2C_CLASS_SPD)
+/* TPM command header size */
+#define TPM_HEADER_SIZE 10
+/*
+ * I2C bus device maximum buffer size
+ * w/o counting I2C address or command
+ * i.e. max size required for I2C write is 34
+ *      = I2C addr, command, 32 bytes data
+ */
+#define I2C_MAX_BUF 32
+
+/* I2C Addresses to scan */
+static const unsigned short normal_i2c[] = { TPM_I2C_ADDR, I2C_CLIENT_END };
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,32)
+I2C_CLIENT_INSMOD_1(NuvotonTPM);
+#endif
+
+static struct tpm_chip  *chip = NULL;
+static struct i2c_client *ti2c_i2c_client = NULL;
+
+static u8 i2cRead8(u8 offset)
+{
+    s32 status;
+    u8  result;
+
+    /* dev_info(chip->dev, "in i2cRead8(%0x)\n", offset); */
+    if (ti2c_i2c_client == NULL) {
+        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
+        return 0xff;
+    }
+    status = i2c_smbus_read_i2c_block_data(
+                ti2c_i2c_client,
+                offset,
+                1,
+                &result);
+    /*
+     * dev_info(
+     *     chip->dev,
+     *     "i2cRead8(%0x)=%0x, sts=%d\n", offset, result, status);
+     */
+
+    return result;
+}
+
+static u32 i2cRead32(u8 offset)
+{
+    s32 status;
+    u32 result;
+
+    /* dev_info(chip->dev, "in i2cRead32(%0x)\n", offset); */
+    if (ti2c_i2c_client == NULL) {
+        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
+        return 0xffffffff;
+    }
+    status = i2c_smbus_read_i2c_block_data(
+                ti2c_i2c_client,
+                offset,
+                4,
+                (u8*)&result);
+    /*
+     * dev_info(
+     *     chip->dev,
+     *     "i2cRead32(%0x)=%04x, sts=%d\n", offset, result, status);
+     */
+
+    return result;
+}
+
+static void i2cReadBuf(u8 offset, u8 size, u8 *data)
+{
+    s32 status;
+
+    /* dev_info(chip->dev, "in i2cReadBuf(%0x, %0x)\n", offset, size); */
+    if (ti2c_i2c_client == NULL) {
+        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
+        return;
+    }
+    status = i2c_smbus_read_i2c_block_data(
+                ti2c_i2c_client,
+                offset,
+                size,
+                data);
+    /*
+     * dev_info(
+     *     chip->dev,
+     *     "i2cRead32(%0x)=%04x, sts=%d\n", offset, result, status);
+     */
+
+    return;
+}
+
+static void i2cWrite8(u8 data, u8 offset)
+{
+    s32 status;
+
+    /*
+     * dev_info(
+     *      chip->dev,
+     *       "in i2cWrite8(data=%0x, offset=%0x)\n", data, offset);
+     */
+    if (ti2c_i2c_client == NULL)
+    {
+        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
+        return;
+    }
+    status = i2c_smbus_write_i2c_block_data(
+                ti2c_i2c_client,
+                offset,
+                1,
+                &data);
+    /*
+     * dev_info(
+     *     chip->dev,
+     *     "i2cWrite8(%0x, %0x), sts=%d\n", data, offset, status);
+     */
+}
+
+static void i2cWriteBuf(u8 offset, u8 size, u8 *data)
+{
+    s32 status;
+
+    /*
+     * dev_info(
+     *      chip->dev,
+     *      "in i2cWriteBuf(offset=%0x, size=%0x)\n", offset, size);
+     */
+    if (ti2c_i2c_client == NULL)
+    {
+        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
+        return;
+    }
+    status = i2c_smbus_write_i2c_block_data(
+                ti2c_i2c_client,
+                offset,
+                size,
+                data);
+    /*
+     * dev_info(
+     *     chip->dev,
+     *     "i2cWriteBuf(offset=%0x, size=%0x), sts=%d\n", offset, size, status);
+     */
+}
+
+static int ti2c_detect(
+                struct i2c_client *client,
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,32)
+                int kind,
+#endif
+                struct i2c_board_info *info)
+{
+    struct i2c_adapter *adapter = client->adapter;
+
+    dev_info(chip->dev, "In detect function\n");
+    if (client->addr != TPM_I2C_ADDR)
+    {
+        dev_err(chip->dev, "Wrong I2C addr %x\n", client->addr);
+        return -ENODEV;
+    }
+
+    if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+        return -ENODEV;
+
+    strlcpy(info->type, "ti2c", I2C_NAME_SIZE);
+    dev_info(chip->dev, "End detect function\n");
+
+    return 0;
+}
+
+static const u8 ti2c_VidDidRidValue[] = {0x50, 0x10, 0xfe, 0x00};
+
+static int ti2c_i2c_prob(struct i2c_client *client,
+                         const struct i2c_device_id *id)
+{
+    u32 vidDidRid;
+
+    dev_info(chip->dev, "in ti2c_i2c_prob\n");
+
+    if (client->addr !=  TPM_I2C_ADDR)
+    {
+        return -1; /* Error */
+    }
+
+    ti2c_i2c_client = client;  /* Save a pointer to the i2c client struct
+                                * we need it during the interrupt */
+
+    vidDidRid = i2cRead32(TPM_VID_DID_RID);
+    dev_info(chip->dev, "VID: %04X DID: %02X RID: %02X\n",
+             (u16)vidDidRid, (u8)(vidDidRid>>16), (u8)(vidDidRid>>24));
+
+    /* check WPCT301 values */
+    if (memcmp((void*)&vidDidRid, ti2c_VidDidRidValue, sizeof(u32)))
+    {
+        /*
+         * f/w rev 2.81 has an issue where the VID_DID_RID is not reporting
+         * the right value. so give it another chance at offset 0x20 (FIFO_W)
+         */
+        vidDidRid = i2cRead32(TPM_DATA_FIFO_W);
+        dev_info(chip->dev, "VID: %04X DID: %02X RID: %02X\n",
+                 (u16)vidDidRid, (u8)(vidDidRid>>16), (u8)(vidDidRid>>24));
+
+        /* check WPCT301 values */
+        if (memcmp((void*)&vidDidRid, ti2c_VidDidRidValue, sizeof(u32)))
+        {
+            ti2c_i2c_client = NULL;
+            dev_err(chip->dev, "WPCT301 not found\n");
+            return -1;
+        }
+    }
+
+    return 0;
+}
+
+static int ti2c_i2c_remove(struct i2c_client *client)
+{
+    dev_info(chip->dev, "in ti2c_i2c_remove\n");
+    kfree(i2c_get_clientdata(client));
+    return 0;
+}
+
+static const struct i2c_device_id ti2c_i2c_id[] = { { "ti2c", 0 }, {} };
+
+static struct i2c_driver ti2c_driver = {
+    .driver = {
+        .name= "ti2c",
+    },
+    .probe  = ti2c_i2c_prob,
+    .remove = ti2c_i2c_remove,
+    .id_table = ti2c_i2c_id,
+    .class     = I2C_CLASS_ALL,
+    .detect    = ti2c_detect,
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,32)
+    .address_data = &addr_data,
+#else
+    .address_list = normal_i2c,
+#endif
+};
+
+enum ti2c_status {
+    TPM_STS_VALID = 0x80,
+    TPM_STS_COMMAND_READY = 0x40,
+    TPM_STS_GO = 0x20,
+    TPM_STS_DATA_AVAIL = 0x10,
+    TPM_STS_DATA_EXPECT = 0x08,
+};
+
+enum ti2c_defaults {
+    TI2C_MEM_BASE = 0xAE,
+    TI2C_MEM_LEN = 0x0100,
+    TI2C_SHORT_TIMEOUT = 750,    /* ms */
+    TI2C_LONG_TIMEOUT = 2000,    /* 2 sec */
+};
+
+static u8 tpm_ti2c_status(struct tpm_chip *chip)
+{
+    return i2cRead8(TPM_STS);
+}
+
+static void tpm_ti2c_ready(struct tpm_chip *chip)
+{
+    /* this causes the current command to be aborted */
+    i2cWrite8(TPM_STS_COMMAND_READY, TPM_STS);
+}
+
+static int get_burstcount(struct tpm_chip *chip)
+{
+    unsigned long stop;
+    int burstcnt;
+
+    /* wait for burstcount */
+    /* which timeout value, spec has 2 answers (c & d) */
+    stop = jiffies + chip->vendor.timeout_d;
+    do { /* in I2C burstCount is 1 byte */
+        burstcnt = i2cRead8(TPM_STS + 1);
+        if (burstcnt)
+            return burstcnt > I2C_MAX_BUF ? I2C_MAX_BUF : burstcnt;
+        msleep(TPM_TIMEOUT);
+    } while (time_before(jiffies, stop));
+    return -EBUSY;
+}
+
+/*
+ * WPCT301 SINT# supports only dataAvail
+ * any call to this function which is not waiting for dataAvail will
+ * set queue to NULL to avoid waiting for interrupt
+ */
+static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
+             wait_queue_head_t *queue)
+{
+    unsigned long stop;
+    long rc;
+    u8 status;
+
+    /* check current status */
+    status = tpm_ti2c_status(chip);
+    if ((status & mask) == mask)
+        return 0;
+
+    if ((chip->vendor.irq) && (queue != NULL)) {
+        rc = wait_event_interruptible_timeout(*queue,
+                ((tpm_ti2c_status(chip) & mask) == mask),
+                timeout);
+        if (rc > 0)
+            return 0;
+    } else {
+        stop = jiffies + timeout;
+        do {
+            msleep(TPM_TIMEOUT);
+            status = tpm_ti2c_status(chip);
+            if ((status & mask) == mask)
+                return 0;
+        } while (time_before(jiffies, stop));
+    }
+    return -ETIME;
+}
+
+static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+    int size = 0, burstcnt, bytes2read;
+
+    while ((size < count) &&
+           wait_for_stat(
+                chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                chip->vendor.timeout_c,
+                &chip->vendor.read_queue) == 0)
+    {
+        burstcnt = get_burstcount(chip);
+        /*
+         * for (; burstcnt > 0 && size < count; burstcnt--)
+         *     buf[size++] = i2cRead8(TPM_DATA_FIFO_R);
+         */
+        bytes2read = burstcnt < (count - size) ? burstcnt : (count - size);
+        i2cReadBuf(TPM_DATA_FIFO_R, bytes2read, &buf[size]);
+        size += bytes2read;
+    }
+    return size;
+}
+
+static int tpm_ti2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+    int size = 0;
+    int expected, status;
+
+    if (count < TPM_HEADER_SIZE) {
+        size = -EIO;
+        goto out;
+    }
+
+    /* read first available (> 10 bytes), including:
+     *      tag, paramsize, and result */
+    status = wait_for_stat(
+                chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                chip->vendor.timeout_c,
+                &chip->vendor.read_queue);
+    if (status != 0) {
+        size = -EIO;
+        goto out;
+    }
+    size = get_burstcount(chip);
+    if ((size = recv_data(chip, buf, size)) < TPM_HEADER_SIZE) {
+        dev_err(chip->dev, "Unable to read header\n");
+        goto out;
+    }
+
+    expected = be32_to_cpu(*(__be32 *) (buf + 2));
+    if (expected > count) {
+        size = -EIO;
+        goto out;
+    }
+
+    if ((size += recv_data(chip, &buf[size], expected - size)) < expected) {
+        dev_err(chip->dev, "Unable to read remainder of result\n");
+        size = -ETIME;
+        goto out;
+    }
+
+    /* for WPCT301 both stsValid and dataAvail set at the same time */
+    wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, NULL);
+    status = tpm_ti2c_status(chip);
+    if (status & TPM_STS_DATA_AVAIL) {    /* retry? */
+        dev_err(chip->dev, "Error left over data\n");
+        size = -EIO;
+        goto out;
+    }
+
+out:
+    tpm_ti2c_ready(chip);
+    return size;
+}
+
+/*
+ * If interrupts are used (signaled by an irq set in the vendor structure)
+ * tpm.c can skip polling for the data to be available as the interrupt is
+ * waited for here
+ */
+static int tpm_ti2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+    int rc, status, burstcnt, bytes2write;
+    size_t count = 0;
+    u32 ordinal;
+
+    status = tpm_ti2c_status(chip);
+    if ((status & TPM_STS_COMMAND_READY) == 0) {
+        tpm_ti2c_ready(chip);
+         rc = wait_for_stat(
+                 chip,
+                 TPM_STS_COMMAND_READY,
+                 chip->vendor.timeout_b,
+                 NULL);
+         if (rc == -ETIME)
+            goto out_err;
+    }
+
+    while (count < len - 1) {
+        burstcnt = get_burstcount(chip);
+        /*
+         * for (; burstcnt > 0 && count < len - 1; burstcnt--) {
+         *     i2cWrite8(buf[count], TPM_DATA_FIFO_W);
+         *     count++;
+         * }
+         */
+        bytes2write = (len -1 -count) < burstcnt ? (len -1 -count) : burstcnt;
+        i2cWriteBuf(TPM_DATA_FIFO_W, bytes2write, &buf[count]);
+        count += bytes2write;
+
+        wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, NULL);
+        status = tpm_ti2c_status(chip);
+        if ((status & TPM_STS_DATA_EXPECT) == 0) {
+            rc = -EIO;
+            goto out_err;
+        }
+    }
+
+    /* write last byte */
+    i2cWrite8(buf[count], TPM_DATA_FIFO_W);
+    wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, NULL);
+    status = tpm_ti2c_status(chip);
+    if ((status & TPM_STS_DATA_EXPECT) != 0) {
+        rc = -EIO;
+        goto out_err;
+    }
+
+    /* go and do it */
+    i2cWrite8(TPM_STS_GO, TPM_STS);
+
+    ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+    rc = wait_for_stat(
+                chip,
+                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+                tpm_calc_ordinal_duration(chip, ordinal),
+                &chip->vendor.read_queue);
+    if (rc == -ETIME)
+        goto out_err;
+
+    return len;
+
+out_err:
+    tpm_ti2c_ready(chip);
+    return rc;
+}
+
+static struct file_operations ti2c_ops = {
+    .owner = THIS_MODULE,
+    .llseek = no_llseek,
+    .open = tpm_open,
+    .read = tpm_read,
+    .write = tpm_write,
+    .release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
+           NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+
+static struct attribute *ti2c_attrs[] = {
+    &dev_attr_pubek.attr,
+    &dev_attr_pcrs.attr,
+    &dev_attr_enabled.attr,
+    &dev_attr_active.attr,
+    &dev_attr_owned.attr,
+    &dev_attr_temp_deactivated.attr,
+    &dev_attr_caps.attr,
+    &dev_attr_cancel.attr, NULL,
+};
+
+static struct attribute_group ti2c_attr_grp = {
+    .attrs = ti2c_attrs
+};
+
+static struct tpm_vendor_specific tpm_ti2c = {
+    .status = tpm_ti2c_status,
+    .recv = tpm_ti2c_recv,
+    .send = tpm_ti2c_send,
+    .cancel = tpm_ti2c_ready,
+    .req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+    .req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
+    .req_canceled = TPM_STS_COMMAND_READY,
+    .attr_group = &ti2c_attr_grp,
+    .miscdev = {
+            .fops = &ti2c_ops,},
+};
+
+static irqreturn_t ti2c_int_handler(int dummy, void *dev_id)
+{
+       struct tpm_chip *chip = dev_id;
+
+    /* in I2C interrupt is triggeted only on dataAvail */
+    wake_up_interruptible(&chip->vendor.read_queue);
+
+    /*
+     * consider disabling the interrupt in the host
+     * in case of interrupt storm as TPM SINT# is level interrupt
+     * which is cleared only when dataAvail is cleared
+     */
+
+    return IRQ_HANDLED;
+}
+
+static int tpm_ti2c_init(struct device *dev, unsigned long start,
+            unsigned long len)
+{
+    u32 vendor;
+    int rc;
+
+    dev_info(dev, "in tpm_ti2c_init\n");
+    if (!start)
+        start = TI2C_MEM_BASE;
+    if (!len)
+        len = TI2C_MEM_LEN;
+
+    chip = tpm_register_hardware(dev, &tpm_ti2c);
+    if (chip == NULL)
+    {
+        dev_err(dev, "error in tpm_register_hardware\n");
+        return -ENODEV;
+    }
+
+    rc = i2c_add_driver(&ti2c_driver);
+    if (rc != 0)
+    {
+        dev_err(dev, "error registering i2c\n");
+        goto out_err;
+    }
+
+    if (ti2c_i2c_client == NULL)
+    {
+        dev_err(dev, "error allocating i2c\n");
+        rc = -ENODEV;
+        goto out_err1;
+    }
+
+    /* Default timeouts */
+    chip->vendor.timeout_a = msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
+    chip->vendor.timeout_b = msecs_to_jiffies(TI2C_LONG_TIMEOUT);
+    chip->vendor.timeout_c = msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
+    chip->vendor.timeout_d = msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
+
+    vendor = i2cRead32(TPM_VID_DID_RID);
+    dev_info(dev,
+             "1.2 TPM (device-id 0x%X, rev-id %d)\n",
+             vendor >> 16, (u16)vendor);
+
+    /*
+     * Figure out the capabilities
+     * I2C hard coded:
+     * intfcaps = TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT;
+     */
+    dev_dbg(dev, "TPM interface capabilities:\n");
+    dev_dbg(dev, "\tInterrupt Level Low\n");
+    dev_dbg(dev, "\tData Avail Int Support\n");
+
+    /* INTERRUPT Setup */
+    init_waitqueue_head(&chip->vendor.read_queue);
+    init_waitqueue_head(&chip->vendor.int_queue);
+
+    /*
+     * I2C hard coded:
+     * intmask = TPM_INTF_DATA_AVAIL_INT;
+     */
+    if (chip->vendor.irq) {
+        if (request_irq(
+                chip->vendor.irq,
+                ti2c_int_handler,
+                IRQF_PROBE_SHARED,
+                chip->vendor.miscdev.name,
+                chip) != 0)
+        {
+            dev_info(dev,
+                     "Unable to request irq: %d for use\n", chip->vendor.irq);
+            chip->vendor.irq = 0;
+        } else {
+            /*
+             * Clear all existing
+             * consider adding code that will make sure TIS is in idle state
+             * and that dataAvail is off in the TPM_STS:
+             * - TPM_STS <- 0x40 (commandReady)
+             */
+            tpm_ti2c_ready(chip);
+            /* - wait for TPM_STS == 0xA0 (stsValid, commandReady) */
+            rc = wait_for_stat(
+                    chip,
+                    TPM_STS_COMMAND_READY,
+                    chip->vendor.timeout_b,
+                    NULL);
+            if (rc == 0)
+            {
+                /*
+                 * TIS is in ready state
+                 * write dummy byte to enter reception state
+                 * TPM_DATA_FIFO_W <- 0x00
+                 */
+                i2cWrite8(0x00, TPM_DATA_FIFO_W);
+                /* TPM_STS <- 0x40 (commandReady) */
+                tpm_ti2c_ready(chip);
+            } else {
+                /*
+                 * if timeout_b is reached then command was aborted,
+                 * TIS in idle state
+                 */
+                if (tpm_ti2c_status(chip) != TPM_STS_VALID) {
+                    rc = -EIO;
+                    goto out_err1;
+                }
+            }
+        }
+    }
+
+    /* uncomment in case BIOS does not send TPM_StartUp(ST_CLEAR) command */
+    /* tpm_startup_clear(chip); */
+    tpm_get_timeouts(chip);
+    tpm_continue_selftest(chip);
+
+    return 0;
+
+out_err1:
+    i2c_del_driver(&ti2c_driver);
+out_err:
+    tpm_remove_hardware(chip->dev);
+    return rc;
+}
+
+static int tpm_ti2c_suspend(struct platform_device *dev, pm_message_t msg)
+{
+       return tpm_pm_suspend(&dev->dev, msg);
+}
+
+static int tpm_ti2c_resume(struct platform_device *dev)
+{
+       return tpm_pm_resume(&dev->dev);
+}
+
+static struct platform_driver ti2c_drv = {
+       .driver = {
+               .name = "tpm_ti2c",
+               .owner = THIS_MODULE,
+       },
+    .suspend = tpm_ti2c_suspend,
+    .resume = tpm_ti2c_resume,
+};
+
+static struct platform_device *pdev;
+
+static int __init init_ti2c(void)
+{
+    int rc;
+
+    rc = platform_driver_register(&ti2c_drv);
+    if (rc < 0)
+        return rc;
+
+    pdev = platform_device_register_simple("tpm_ti2c", -1, NULL, 0);
+    if (IS_ERR(pdev))
+        return PTR_ERR(pdev);
+
+    rc = tpm_ti2c_init(&pdev->dev, 0, 0);
+    if(rc != 0) {
+        platform_device_unregister(pdev);
+        platform_driver_unregister(&ti2c_drv);
+    }
+
+    return rc;
+}
+
+static void __exit cleanup_ti2c(void)
+{
+    dev_info(chip->dev,"in cleanup_ti2c\n");
+
+    i2c_del_driver(&ti2c_driver);
+    tpm_remove_hardware(chip->dev);
+    if (chip->vendor.irq)
+        free_irq(chip->vendor.irq, chip);
+    platform_device_unregister(pdev);
+    platform_driver_unregister(&ti2c_drv);
+}
+
+module_init(init_ti2c);
+module_exit(cleanup_ti2c);
+MODULE_AUTHOR("Dan Morav (dan.morav@nuvoton.com)");
+MODULE_DESCRIPTION("Nuvton TPM I2C Driver");
+MODULE_VERSION("0.9.2");
+MODULE_LICENSE("GPL");

===========================================================================================
The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.

===========================================================================================
The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
