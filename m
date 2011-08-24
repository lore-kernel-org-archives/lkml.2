Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab1HXCUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:20:53 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36757 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab1HXCUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:20:47 -0400
Message-ID: <4E545FF7.5070608@gmail.com>
Date: Wed, 24 Aug 2011 12:20:39 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dan.Morav@nuvoton.com
CC: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com
Subject: Re: [PATCH] TPM Nuvoton I2C driver, kernel 3.0
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A436305988915E@ntilml01.nuvoton.com>
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A436305988915E@ntilml01.nuvoton.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/08/11 21:11, Dan.Morav@nuvoton.com wrote:
> Hi,
>
> Below are the additions for WPCT301/NPCT501 Nuvoton Technology TPM with I2C interface device driver.
> This driver uses Linux I2C bus driver to interface with the I2C bus and Linux TPM driver (tpm.ko), to export the standard Linux TPM interface.
> This driver requires an I2C bus driver and TPM driver (tpm.ko) to be loaded prior to its loading.
> This driver tested on Linux kernel version 3.0-rc7 on an x86 based platform.
>
> Regards,
> Dan.

Hi Dan,

A few comments below.

~Ryan

> Signed-off-by: Dan Morav<dmorav@nuvoton.com>
>
> --- linux-3.0-rc7/drivers/char/tpm/Kconfig      2011-07-12 02:51:52.000000000 +0300
> +++ linux-3.0/drivers/char/tpm/Kconfig  2011-08-17 13:15:28.062485000 +0300
> @@ -60,4 +60,13 @@ config TCG_INFINEON
>            Further information on this driver and the supported hardware
>            can be found at http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/
>
> +config TCG_NUVOTON_I2C
> +       tristate "Nuvoton Technology Corp. TPM 1.2 I2C Interface"
> +       depends on I2C
> +       ---help---
> +         If you have a TPM security chip with I2C interface from
> +         Nuvoton Technology Corp. say Yes and it will be accessible
> +         from within Linux.  To compile this driver as a module, choose
> +         M here; the module will be called tpm_nuvoton_i2c.
> +
>   endif # TCG_TPM
> --- linux-3.0-rc7/drivers/char/tpm/Makefile     2011-07-12 02:51:52.000000000 +0300
> +++ linux-3.0/drivers/char/tpm/Makefile 2011-05-02 10:15:28.000000000 +0300
> @@ -9,3 +9,4 @@ obj-$(CONFIG_TCG_TIS) += tpm_tis.o
>   obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
>   obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
>   obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> +obj-$(CONFIG_TCG_NUVOTON_I2C) += tpm_nuvoton_i2c.o
> --- linux-3.0-rc7/drivers/char/tpm/tpm_nuvoton_i2c.c    1970-01-01 02:00:00.000000000 +0200
> +++ linux-3.0/drivers/char/tpm/tpm_nuvoton_i2c.c        2011-08-17 12:12:05.351045000 +0300
> @@ -0,0 +1,733 @@
> +/******************************************************************************
> + * Nuvoton TPM I2C Device Driver Interface for WPCT301/NPCT501,
> + * based on the TCG TPM Interface Spec version 1.2.
> + * Specifications at www.trustedcomputinggroup.org
> + *
> + * Copyright (C) 2011, Nuvoton Technology Corporation.
> + * dan.morav@nuvoton.com
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see http://www.gnu.org/licenses/>.
> + *
> + * Nuvoton contact information: APC.Support@nuvoton.com
> + *****************************************************************************/
Nitpick: Blank line between header comment and first include.

> +#include<linux/init.h>
> +#include<linux/module.h>
> +#include<linux/moduleparam.h>
> +#include<linux/slab.h>
> +#include<linux/interrupt.h>
> +#include<linux/wait.h>
> +#include<linux/i2c.h>
> +#include "tpm.h"
> +
> +/* I2C interface offsets */
> +#define TPM_STS                0x00
> +#define TPM_BURST_COUNT        0x01
> +#define TPM_DATA_FIFO_W        0x20
> +#define TPM_DATA_FIFO_R        0x40
> +#define TPM_VID_DID_RID        0x60
> + /* TPM command header size */
> +#define TPM_HEADER_SIZE        10
> +#define TPM_RETRY      5
> +/*
> + * I2C bus device maximum buffer size w/o counting I2C address or command
> + * i.e. max size required for I2C write is 34 = addr, command, 32 bytes data
> + */
> +#define TPM_I2C_MAX_BUF_SIZE           32
> +#define TPM_I2C_RETRY_COUNT            32
> +#define TPM_I2C_BUS_DELAY              1   /* msec */
> +#define TPM_I2C_RETRY_DELAY_SHORT      2   /* msec */
> +#define TPM_I2C_RETRY_DELAY_LONG       10  /* msec */
> +
> +#ifdef DEBUG
> +#define TPM_I2C_PRINT_BUF(string, buf, size) \
> +       print_hex_dump(KERN_DEBUG, (string), DUMP_PREFIX_NONE, 16, 1, (buf), \
> +                       (size), false);
> +#else
> +#define TPM_I2C_PRINT_BUF(string, buf, size)
> +#endif

This can be a static inline and should have a name which reflects that 
it is a debug function. The name should also be lower case. I had 
thought there was already a debug version of print_hex_dump, but maybe I 
am wrong.

> +
> +static s32 tpm_i2c_read_buf(struct i2c_client *client, u8 offset, u8 size,
> +                               u8 *data)
> +{
> +       s32 status;
> +
> +       status = i2c_smbus_read_i2c_block_data(client, offset, size, data);
> +
> +       if (status>  0) {

Nitpick: No blank line between an assignment and the if check.

> +               dev_dbg(&(client->dev),
> +                       "tpm_i2c_read_buf(%0x)->  sts=%d:", offset, status);
> +               TPM_I2C_PRINT_BUF("data: ", data, size);
> +       }
> +
> +       return status;
> +}
> +
> +static s32 tpm_i2c_write_buf(struct i2c_client *client, u8 offset, u8 size,
> +                               u8 *data)
> +{
> +       s32 status;
> +
> +       status = i2c_smbus_write_i2c_block_data(client, offset, size, data);
> +
> +       if (status>= 0) {
> +               dev_dbg(&(client->dev),
> +                       "tpm_i2c_write_buf(offset=%0x, size=%0x)->  sts=%d:",
> +                       offset, size, status);
> +               TPM_I2C_PRINT_BUF("data: ", data, size);
> +       }
> +
> +       return status;
> +}
> +
> +#define TPM_STS_VALID          0x80
> +#define TPM_STS_COMMAND_READY  0x40
> +#define TPM_STS_GO             0x20
> +#define TPM_STS_DATA_AVAIL     0x10
> +#define TPM_STS_EXPECT         0x08
> +#define TPM_STS_RESPONSE_RETRY 0x02
> +#define TPM_STS_ERR_VAL                0x07    /* bit2...bit0 reads always 0 */
> +
> +#define TPM_I2C_SHORT_TIMEOUT  750     /* ms */
> +#define TPM_I2C_LONG_TIMEOUT   2000    /* 2 sec */
> +
> +/* read TPM_STS register */
> +static u8 tpm_i2c_status(struct tpm_chip *chip)
> +{
> +       struct i2c_client *tpm_i2c_client = to_i2c_client(chip->dev);
> +       s32 status;
> +       u8 data;
> +
> +       status = tpm_i2c_read_buf(tpm_i2c_client, TPM_STS, 1,&data);
> +       if (status<= 0) {
> +               dev_err(chip->dev, "tpm_i2c_status() error return %#02x\n",
> +                       status);
> +               data = TPM_STS_ERR_VAL;
> +       }
> +
> +       return data;
> +}
> +
> +/* write byte to TPM_STS register */
> +static s32 tpm_i2c_write_status(struct i2c_client *tpm_i2c_client, u8 data)
> +{
> +       s32 status;
> +       int i;
> +
> +       /* this causes the current command to be aborted */
> +       for (i = 0, status = -1; i<  TPM_I2C_RETRY_COUNT&&  status<  0; i++) {
> +               status = tpm_i2c_write_buf(tpm_i2c_client, TPM_STS, 1,&data);
> +               msleep(TPM_I2C_BUS_DELAY);

If the hardware is broken/not responding this could potentially loop 
forever.

> +       }
> +       return status;
> +}
> +
> +/* write commandReady to TPM_STS register */
> +static void tpm_i2c_ready(struct tpm_chip *chip)
> +{
> +       struct i2c_client *tpm_i2c_client = to_i2c_client(chip->dev);
> +       s32 status;
> +
> +       /* this causes the current command to be aborted */
> +       status = tpm_i2c_write_status(tpm_i2c_client, TPM_STS_COMMAND_READY);
> +       if (status<  0)
> +               dev_err(chip->dev,
> +                       "tpm_i2c_ready() fail to write TPM_STS.commandReady\n");
> +}
> +
> +/* read burstCount field from TPM_STS register */
> +/* return -1 on fail to read */
> +static int tpm_i2c_get_burstcount(struct i2c_client *tpm_i2c_client,
> +                                       struct tpm_chip *chip)
> +{
> +       unsigned long stop = jiffies + chip->vendor.timeout_d;
> +       s32 status;
> +       int burst_count = -1;
> +       u8 data;
> +
> +       /* wait for burstcount to be non-zero */
> +       do { /* in I2C burstCount is 1 byte */
Nitpick: Move this comment onto a newline.

> +               status = tpm_i2c_read_buf(tpm_i2c_client, TPM_BURST_COUNT, 1,
> +&data);
> +               if (status>  0&&  data>  0) {
> +                       burst_count = min((u8)TPM_I2C_MAX_BUF_SIZE, data);

Use min_t instead of casting.

> +                       break;
> +               }
> +               msleep(TPM_I2C_BUS_DELAY);
> +       } while (time_before(jiffies, stop));
> +
> +       return burst_count;
> +}
> +
> +/*
> + * WPCT301/NPCT501 SINT# supports only dataAvail
> + * any call to this function which is not waiting for dataAvail will
> + * set queue to NULL to avoid waiting for interrupt
> + */
> +static bool tpm_i2c_check_status(struct tpm_chip *chip, u8 mask, u8 value)
> +{
> +       u8 status = tpm_i2c_status(chip);
> +       return status != TPM_STS_ERR_VAL&&  (status&  mask) == (value);

Don't need the parens around value. Would maybe rewrite as:

     return (status != TPM_STS_ERR_VAL) && ((status & mask) == value);

To make it a bit more readable.

> +}
> +
> +static int tpm_i2c_wait4stat(struct tpm_chip *chip, u8 mask, u8 value,
> +                               u32 timeout, wait_queue_head_t *queue)

wait_for_stat.

> +{
> +       unsigned long ten_msec;
> +       unsigned long stop;
> +       bool status_valid;
> +       s32 rc;
> +
> +       /* check current status */
> +       status_valid = tpm_i2c_check_status(chip, mask, value);
> +       if (status_valid)
> +               return 0;
> +
> +       if (chip->vendor.irq&&  !queue) {
> +               /* use interrupt to wait for the event */
> +               rc = wait_event_interruptible_timeout(*queue,
> +                               tpm_i2c_check_status(chip, mask, value),
> +                               timeout);
> +               if (rc>  0)
> +                       return 0;
> +       } else {
> +               /* use polling to wait for the event */
> +               ten_msec = jiffies + msecs_to_jiffies(TPM_I2C_RETRY_DELAY_LONG);
> +               stop = jiffies + timeout;
> +               do {
> +                       if (time_before(jiffies, ten_msec))
> +                               msleep(TPM_I2C_RETRY_DELAY_SHORT);
> +                       else
> +                               msleep(TPM_I2C_RETRY_DELAY_LONG);

Why two different delays?

> +                       status_valid = tpm_i2c_check_status(chip, mask, value);
> +                       if (status_valid)
> +                               return 0;
> +               } while (time_before(jiffies, stop));
> +       }
> +       dev_err(chip->dev, "tpm_i2c_wait4stat(%02x, %02x) ->  timeout\n", mask,
> +               value);

You should use __func__ if you want to print out function names.

> +       return -ETIME;

ETIMEDOUT appears to be more common.

> +}
> +
> +/* wait for dataAvail field to be set in the TPM_STS register */
> +static int tpm_i2c_wait4data_avail(struct tpm_chip *chip, u32 timeout,
> +                                       wait_queue_head_t *queue)
> +{
> +       return tpm_i2c_wait4stat(chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                               TPM_STS_DATA_AVAIL | TPM_STS_VALID, timeout,
> +                               queue);
> +}
> +
> +/* Read @count bytes into @buf from TPM_RD_FIFO register */
> +static int recv_data(struct i2c_client *tpm_i2c_client, struct tpm_chip *chip,
> +                       u8 *buf, size_t count)
> +{
> +       s32 rc;
> +       int size = 0;
> +       int burst_count;
> +       int bytes2read;

Nitpick: Put variables with a common type on the same line.

> +
> +       while ((size<  count)&&  (tpm_i2c_wait4data_avail(chip,
> +                                       chip->vendor.timeout_c, NULL) == 0)) {

Here you don't need the parens around the individual clauses.

> +               burst_count = tpm_i2c_get_burstcount(tpm_i2c_client, chip);
> +               if (burst_count<  0) {
> +                       dev_err(chip->dev,
> +                               "recv_data() fail to read burstCount=%d\n",
> +                               burst_count);
> +                       return -EIO;
> +               }
> +               bytes2read = min((size_t)burst_count, count - size);

min_t

> +               rc = tpm_i2c_read_buf(tpm_i2c_client, TPM_DATA_FIFO_R,
> +                                       bytes2read,&buf[size]);
> +               if (rc<  0) {
> +                       dev_err(chip->dev,
> +                               "recv_data() fail on tpm_i2c_read_buf()=%d\n",
> +                               rc);
> +                       return -EIO;
> +               }
> +               dev_dbg(chip->dev, "recv_data(%d):", bytes2read);
> +               size += bytes2read;
> +       }
> +
> +       return size;
> +}
> +
> +/* Read TPM command results */
> +static int tpm_i2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +       struct device *dev = chip->dev;
> +       struct i2c_client *tpm_i2c_client = to_i2c_client(dev);
> +       s32 rc;
> +       int size = 0;
> +       int expected;
> +       int status;
> +       int burst_count;
> +       int retries = TPM_RETRY;
> +
> +       if (count<  TPM_HEADER_SIZE) {
> +               tpm_i2c_ready(chip); /* return to idle */
> +               dev_err(dev, "tpm_i2c_recv() count<  header size\n");
> +               return -EIO;
> +       }
> +
> +       do {

for (retries = 0; retries < TPM_RETRY; retries++)

?

> +               if (retries<  TPM_RETRY) {
> +                       /* if this is not the first trial, set responseRetry */
> +                       tpm_i2c_write_status(tpm_i2c_client,
> +                                               TPM_STS_RESPONSE_RETRY);
> +               }
> +               /*
> +                * read first available (>  10 bytes), including:
> +                * tag, paramsize, and result
> +                */
> +               status = tpm_i2c_wait4data_avail(chip, chip->vendor.timeout_c,
> +&chip->vendor.read_queue);
> +               if (status != 0) {
> +                       dev_err(dev, "tpm_i2c_recv() timeout on dataAvail\n");
> +                       size = -ETIME;
> +                       retries--;
> +                       continue;
> +               }
> +               burst_count = tpm_i2c_get_burstcount(tpm_i2c_client, chip);
> +               if (burst_count<  0) {
> +                       dev_err(dev, "tpm_i2c_recv() fail to get burstCount\n");
> +                       size = -EIO;
> +                       retries--;
> +                       continue;
> +               }
> +               size = recv_data(tpm_i2c_client, chip, buf, burst_count);
> +               if (size<  TPM_HEADER_SIZE) {
> +                       dev_err(dev, "tpm_i2c_recv() fail to read header\n");
> +                       size = -EIO;
> +                       retries--;
> +                       continue;
> +               }
> +               /*
> +                * convert number of expected bytes field from big endian 32 bit
> +                * to machine native
> +                */
> +               expected = be32_to_cpu(*(__be32 *)(buf + 2));
> +               if (expected>  count) {
> +                       dev_err(dev, "tpm_i2c_recv() expected>  count\n");
> +                       size = -EIO;
> +                       retries--;
> +                       continue;
> +               }
> +               rc = recv_data(tpm_i2c_client, chip,&buf[size], expected-size);
> +               size += rc;
> +               if ((rc<  0) || (size<  expected)) {

Don't need the internal parens.

> +                       dev_err(dev, "tpm_i2c_recv() fail to read remainder"
> +                               "of result\n");
> +                       size = -EIO;
> +                       retries--;
> +                       continue;
> +               }
> +               if (tpm_i2c_wait4stat(chip, TPM_STS_VALID | TPM_STS_DATA_AVAIL,
> +                                       TPM_STS_VALID, chip->vendor.timeout_c,
> +                                       NULL)) {
> +                       dev_err(dev, "tpm_i2c_recv() error left over data\n");
> +                       size = -ETIME;
> +                       retries--;
> +                       continue;
> +               }
> +               break;
> +       } while (retries>  0);
> +       tpm_i2c_ready(chip);
> +       dev_dbg(chip->dev, "tpm_i2c_recv() ->  %d\n", size);
> +       return size;
> +}
> +
> +/*
> + * Send TPM command.
> + *
> + * If interrupts are used (signaled by an irq set in the vendor structure)
> + * tpm.c can skip polling for the data to be available as the interrupt is
> + * waited for here
> + */
> +static int tpm_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
> +{
> +       struct device *dev = chip->dev;
> +       struct i2c_client *tpm_i2c_client = to_i2c_client(dev);
> +       int rc = -EIO;
> +       int burst_count;
> +       int bytes2write;
> +       int retries = TPM_RETRY;
> +       size_t count = 0;
> +       u32 ordinal;
> +
> +       do {

Same here, just do a for loop for the retries?

> +               tpm_i2c_ready(chip);
> +               if (tpm_i2c_wait4stat(chip, TPM_STS_COMMAND_READY,
> +                                       TPM_STS_COMMAND_READY,
> +                                       chip->vendor.timeout_b, NULL)) {
> +                       dev_err(dev,
> +                               "tpm_i2c_send() timeout on commandReady\n");
> +                       retries--;
> +                       rc = -EIO;
> +                       continue;
> +               }
> +               rc = 0;
> +               while (count<  len - 1) {
> +                       burst_count = tpm_i2c_get_burstcount(tpm_i2c_client,
> +                                                               chip);
> +                       if (burst_count<  0) {
> +                               dev_err(dev,
> +                                       "tpm_i2c_send() fail get burstCount\n");
> +                               rc = -EIO;
> +                               break;
> +                       }
> +                       bytes2write = min((size_t)burst_count, len - 1 - count);
> +                       rc = tpm_i2c_write_buf(tpm_i2c_client, TPM_DATA_FIFO_W,
> +                                               bytes2write,&buf[count]);
> +                       if (rc<  0) {
> +                               dev_err(dev,
> +                                       "tpm_i2c_send() fail i2cWriteBuf\n");
> +                               break;
> +                       }
> +                       dev_dbg(dev, "tpm_i2c_send(%d):", bytes2write);
> +                       count += bytes2write;
> +                       rc = tpm_i2c_wait4stat(chip,
> +                                               TPM_STS_VALID | TPM_STS_EXPECT,
> +                                               TPM_STS_VALID | TPM_STS_EXPECT,
> +                                               chip->vendor.timeout_c, NULL);
> +                       if (rc<  0) {
> +                               dev_err(dev,
> +                                       "tpm_i2c_send() timeout on Expect\n");
> +                               rc = -ETIME;
> +                               break;
> +                       }
> +               }
> +               if (rc<  0) {
> +                       retries--;
> +                       continue;
> +               }
> +
> +               /* write last byte */
> +               rc = tpm_i2c_write_buf(tpm_i2c_client, TPM_DATA_FIFO_W, 1,
> +&buf[count]);
> +               if (rc<  0) {
> +                       dev_err(dev, "tpm_i2c_send() fail to write last byte\n");
> +                       rc = -EIO;
> +                       retries--;
> +                       continue;
> +               }
> +               dev_dbg(dev, "tpm_i2c_send(last): %02x", buf[count]);
> +               rc = tpm_i2c_wait4stat(chip, TPM_STS_VALID | TPM_STS_EXPECT,
> +                                       TPM_STS_VALID, chip->vendor.timeout_c,
> +                                       NULL);
> +               if (rc) {
> +                       dev_err(dev,
> +                               "tpm_i2c_send() timeout on Expect to clear\n");
> +                       rc = -ETIME;
> +                       retries--;
> +                       continue;
> +               }
> +               break;
> +       } while (retries>  0);
> +       if (rc<  0) { /* retries == 0 */

Comment on newline.

> +               tpm_i2c_ready(chip);
> +               return rc;
> +       }
> +       /* go and do it */

Go and do what? :-)

> +       rc = tpm_i2c_write_status(tpm_i2c_client, TPM_STS_GO);
> +       if (rc<  0) {
> +               dev_err(dev, "tpm_i2c_send() fail to write Go\n");
> +               tpm_i2c_ready(chip);
> +               return rc;
> +       }
> +       /* convert ordinal field from big endian 32 bit to machine native */

The line of code below says exactly the same thing that this comment 
says. Remove the comment.

> +       ordinal = be32_to_cpu(*((__be32 *)(buf + 6)));
> +       rc = tpm_i2c_wait4data_avail(chip,
> +                               tpm_calc_ordinal_duration(chip, ordinal),
> +&chip->vendor.read_queue);
> +       if (rc) {
> +               dev_err(dev, "tpm_i2c_send() timeout command duration\n");
> +               tpm_i2c_ready(chip);
> +               return rc;
> +       }
> +
> +       dev_dbg(dev, "tpm_i2c_send() ->  %d\n", len);
> +       return len;
> +}
> +
> +static const struct file_operations tpm_i2c_ops = {
> +       .owner          = THIS_MODULE,
> +       .llseek         = no_llseek,
> +       .open           = tpm_open,
> +       .read           = tpm_read,
> +       .write          = tpm_write,
> +       .release        = tpm_release,
> +};
> +
> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> +static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +
> +static struct attribute *tpm_i2c_attrs[] = {
> +&dev_attr_pubek.attr,
> +&dev_attr_pcrs.attr,
> +&dev_attr_enabled.attr,
> +&dev_attr_active.attr,
> +&dev_attr_owned.attr,
> +&dev_attr_temp_deactivated.attr,
> +&dev_attr_caps.attr,
> +&dev_attr_cancel.attr,
> +       NULL,
> +};
> +
> +static struct attribute_group tpm_i2c_attr_grp = {
> +       .attrs = tpm_i2c_attrs
> +};
> +
> +static struct tpm_vendor_specific tpm_i2c = {
> +       .status                 = tpm_i2c_status,
> +       .recv                   = tpm_i2c_recv,
> +       .send                   = tpm_i2c_send,
> +       .cancel                 = tpm_i2c_ready,
> +       .req_complete_mask      = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +       .req_complete_val       = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +       .req_canceled           = TPM_STS_COMMAND_READY,
> +       .attr_group             =&tpm_i2c_attr_grp,
> +       .miscdev = {
> +               .fops           =&tpm_i2c_ops,
> +       },
> +};
> +
> +static irqreturn_t tpm_i2c_int_handler(int dummy, void *dev_id)
> +{
> +       struct tpm_chip *chip = dev_id;
> +
> +       /* in I2C interrupt is triggeted only on dataAvail */
> +       wake_up_interruptible(&chip->vendor.read_queue);
> +
> +       /*
> +        * consider disabling the interrupt in the host
> +        * in case of interrupt storm as TPM SINT# is level interrupt
> +        * which is cleared only when dataAvail is cleared
> +        */
> +       return IRQ_HANDLED;
> +}
> +
> +static const u8 vid_did_rid_value[] = { 0x50, 0x10, 0xfe, 0x00 };
> +#define VID_DID_RID_SIZE sizeof(vid_did_rid_value)
> +
> +static int tpm_i2c_detect(struct i2c_client *client,
> +                       struct i2c_board_info *info)
> +{
> +       struct i2c_adapter *adapter = client->adapter;
> +       struct device *dev =&(client->dev);
> +       u32 temp;
> +       s32 rc;
> +
> +       if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +               return -ENODEV;
> +
> +       rc = tpm_i2c_read_buf(client, TPM_VID_DID_RID, 4, (u8 *)(&temp));

Don't need parens around &temp.

> +       if (rc<  0) {
> +               dev_err(dev, "tpm_i2c_detect() fail read VID/DID/RID =>  %d\n",
> +                       rc);
> +               return -ENODEV;
> +       }
> +       dev_dbg(dev, "tpm_i2c_detect() VID: %04X DID: %02X RID: %02X\n", temp,
> +               temp>>16, temp>>24);

Nitpick: space on either side of >> operator.

> +
> +       /* check WPCT301 values - ignore RID */
> +       if (memcmp(&temp, vid_did_rid_value, VID_DID_RID_SIZE-1)) {
Spaces on either side of operators.

Why do you have VID_DID_RID_SIZE - 1 everywhere. Can't you just drop the 
0x00 from the end so it is only three bytes and just do:

     if (memcmp(&temp, vid_did_rid_value, sizeof(vid_did_rid_value)) {

> +               /*
> +                * f/w rev 2.81 has an issue where the VID_DID_RID is not
> +                * reporting the right value. so give it another chance at
> +                * offset 0x20 (FIFO_W).
> +                */
> +               rc = tpm_i2c_read_buf(client, TPM_DATA_FIFO_W, 4,
> +                                       (u8 *)(&temp));
> +               if (rc<  0) {
> +                       dev_err(dev, "tpm_i2c_detect() fail to read"
> +                               "VID/DID/RID. status=%d\n", rc);
> +                       return -ENODEV;
> +               }
> +               dev_dbg(dev,
> +                       "tpm_i2c_detect() VID: %04X DID: %02X RID: %02X\n",
> +                       temp, temp>>16, temp>>24);
> +
> +               /* check WPCT301 values - ignore RID*/
> +               if (memcmp(&temp, vid_did_rid_value, VID_DID_RID_SIZE-1)) {
> +                       dev_err(dev,
> +                               "tpm_i2c_detect() WPCT301/NPCT501 not found\n");
> +                       return -ENODEV;
> +               }
> +       }
> +
> +       strlcpy(info->type, "tpm_i2c", I2C_NAME_SIZE);
> +       dev_info(dev, "tpm_i2c VID: %04X DID: %02X RID: %02X\n", temp, temp>>16,
> +                       temp>>24);
> +
> +       return 0;
> +}
> +
> +static int tpm_i2c_probe(struct i2c_client *client,
> +                               const struct i2c_device_id *id)
> +{
> +       int rc;
> +       struct tpm_chip *chip;
> +       struct device *dev =&(client->dev);

Don't need the parens.

> +       void (*release)(struct device *dev) = dev->release;
> +
> +       chip = tpm_register_hardware(dev,&tpm_i2c);
> +       if (!chip) {
> +               dev_err(dev, "tpm_i2c_probe() error in tpm_register_hardware\n");
> +               return -ENODEV;
> +       }
> +       /*
> +        * restore dev->release function as it is modified by tpm_register_dev.
> +        * save the assigned release function in chip->release for backup.
> +        */
> +        chip->release = dev->release;
> +        dev->release = release;

Indentation got borked here. It also looks like you are using spaces 
instead of tabs for indentation?

Reassigned the dev->release function looks odd. Is this the correct 
thing to do?

> +
> +       /* Default timeouts */
> +       chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
> +       chip->vendor.timeout_b = msecs_to_jiffies(TPM_I2C_LONG_TIMEOUT);
> +       chip->vendor.timeout_c = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
> +       chip->vendor.timeout_d = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
> +
> +       /*
> +        * I2C intfcaps (interrupt capabilitieis) are hard coded to:
> +        *   TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT
> +        */
> +
> +       /* INTERRUPT Setup */
> +       init_waitqueue_head(&chip->vendor.read_queue);
> +       init_waitqueue_head(&chip->vendor.int_queue);

Should this go inside the if (chip->vendor.irq) block if it is related 
to interrupts?

> +
> +       /* I2C intmask is hard coded to TPM_INTF_DATA_AVAIL_INT */
> +       if (chip->vendor.irq) {
> +               dev_dbg(dev, "tpm_i2c_probe() chip-vendor.irq\n");
> +               rc = request_irq(chip->vendor.irq, tpm_i2c_int_handler,
> +                       IRQF_PROBE_SHARED, chip->vendor.miscdev.name, chip);
> +               if (rc) {
> +                       dev_err(dev, "tpm_i2c_probe() Unable to request irq:"
> +                               "%d for use\n", chip->vendor.irq);
> +                       chip->vendor.irq = 0;
> +               } else {
> +                       /* Clear any pending interrupt */

I think you can get an interrupt at this point. Are you ready for it?

> +                       tpm_i2c_ready(chip);
> +                       /* - wait for TPM_STS==0xA0 (stsValid, commandReady) */
> +                       rc = tpm_i2c_wait4stat(chip, TPM_STS_COMMAND_READY,
> +                                               TPM_STS_COMMAND_READY,
> +                                               chip->vendor.timeout_b, NULL);
> +                       if (rc == 0) {
> +                               /*
> +                                * TIS is in ready state
> +                                * write dummy byte to enter reception state
> +                                * TPM_DATA_FIFO_W<- rc (0)
> +                                */
> +                               rc = tpm_i2c_write_buf(client, TPM_DATA_FIFO_W,
> +                                                       1, (u8 *)(&rc));
> +                               if (rc<  0)
> +                                       goto out_err;
> +                               /* TPM_STS<- 0x40 (commandReady) */
> +                               tpm_i2c_ready(chip);
> +                       } else {
> +                               /*
> +                                * timeout_b reached - command was
> +                                * aborted. TIS should now be in idle state -
> +                                * only TPM_STS_VALID should be set
> +                                */
> +                               if (tpm_i2c_status(chip) != TPM_STS_VALID) {
> +                                       rc = -EIO;
> +                                       goto out_err;
> +                               }
> +                       }
> +               }
> +       }
> +
> +       /* uncomment in case BIOS/booter does not send TPM_StartUp command */
> +       /* tpm_startup_clear(chip); */

Is this a common problem? Should it be a command line option to the module?

> +       tpm_get_timeouts(chip);
> +       tpm_continue_selftest(chip);
> +
> +       return 0;
> +
> +out_err:
> +       tpm_remove_hardware(chip->dev);
> +       return rc;
> +}
> +
> +static int tpm_i2c_remove(struct i2c_client *client)
> +{
> +       struct device *dev =&(client->dev);
> +       struct tpm_chip *chip = dev_get_drvdata(dev);
> +
> +       if (chip) {

Can chip be NULL here?

> +               tpm_dev_vendor_release(chip);
> +               if (chip->vendor.irq)
> +                       free_irq(chip->vendor.irq, chip);
> +       }
> +       tpm_remove_hardware(dev);
> +       kfree(chip);
> +       return 0;
> +}
> +
> +static int tpm_i2c_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +       return tpm_pm_suspend(&client->dev, mesg);
> +}
> +
> +static int tpm_i2c_resume(struct i2c_client *client)
> +{
> +       return tpm_pm_resume(&client->dev);
> +}
> +
> +static const struct i2c_device_id tpm_i2c_id[] = { { "tpm_i2c", 0 }, {} };
> +
> +/* I2C Addresses to scan */
> +static const u16 normal_i2c[] = { 0x17, 0x57, I2C_CLIENT_END };

I though this style of i2c registration was deprecated? I could be wrong.

> +
> +
> +#define I2C_CLASS_ANY 0xffff

What is this for?

> +static struct i2c_driver tpm_i2c_driver = {
> +       .driver = {
> +               .name   = "tpm_i2c",
> +       },
> +       .probe          = tpm_i2c_probe,
> +       .remove         = tpm_i2c_remove,
> +       .id_table       = tpm_i2c_id,
> +       .detect         = tpm_i2c_detect,
> +       .address_list   = normal_i2c,
> +       .suspend        = tpm_i2c_suspend,
> +       .resume         = tpm_i2c_resume,
> +       .class          = I2C_CLASS_ANY,
> +};
> +
> +static int __init tpm_i2c_init(void)
> +{
> +       return i2c_add_driver(&tpm_i2c_driver);
> +}
> +
> +static void __exit tpm_i2c_exit(void)
> +{
> +       i2c_del_driver(&tpm_i2c_driver);
> +}
> +
> +module_init(tpm_i2c_init);
> +module_exit(tpm_i2c_exit);
> +
> +MODULE_AUTHOR("Dan Morav (dan.morav@nuvoton.com)");
> +MODULE_DESCRIPTION("Nuvoton TPM I2C Driver");
> +MODULE_LICENSE("GPL");
>
>
> ===========================================================================================
> The privileged confidential information contained in this email is intended for use only by the addressees as indicated by the original sender of this email. If you are not the addressee indicated in this email or are not responsible for delivery of the email to such a person, please kindly reply to the sender indicating this fact and delete all copies of it from your computer and network server immediately. Your cooperation is highly appreciated. It is advised that any unauthorized use of confidential information of Nuvoton is strictly prohibited; and any information in this email irrelevant to the official business of Nuvoton shall be deemed as neither given nor endorsed by Nuvoton.
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{����zX����ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf��^jǫy�m��@A�a���0��h��i

