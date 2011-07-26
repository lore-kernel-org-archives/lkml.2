Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab1GZAvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:51:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38905 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZAvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:51:07 -0400
Message-ID: <4E2E0F6F.5030800@gmail.com>
Date: Tue, 26 Jul 2011 10:50:55 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan.Morav@nuvoton.com
CC: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        Leonid.Azriel@nuvoton.com, Guy.Pavlov@nuvoton.com
Subject: Re: [PATCH] TPM Nuvoton I2C driver, kernel 3.0
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com> <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A4363059782006@ntilml01.nuvoton.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/11 17:25, Dan.Morav@nuvoton.com wrote:
> Hi,
>
> Below are the additions for WPCT301/NPCT501 Nuvoton Technology TPM with I2C interface device driver.
> This driver uses Linux I2C bus driver to interface with the I2C bus and Linux TPM driver (tpm.ko), to export the standard Linux TPM interface.
> This driver requires an I2C bus driver and TPM driver (tpm.ko) to be loaded prior to its loading.
> This driver tested on Linux kernel version 3.0-rc6 on an x86 based platform and Linux kernel version 2.6.36.3 on an ARM platform.
>

Hi Dan,

There are lots of style problems with this patch. You should run it 
through scripts/checkpatch.pl which should point most of them out. Some 
more comments inline below (mostly issues pointed out occur several times).

~Ryan

> diff -uN linux-3.0-rc6/drivers/char/tpm/Kconfig linux/drivers/char/tpm/Kconfig
> --- linux-3.0-rc6/drivers/char/tpm/Kconfig      2011-07-25 10:07:31.519844000 +0300
> +++ linux/drivers/char/tpm/Kconfig      2011-07-25 10:07:46.999567000 +0300
> @@ -60,4 +60,13 @@
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
> diff -uN linux-3.0-rc6/drivers/char/tpm/Makefile linux/drivers/char/tpm/Makefile
> --- linux-3.0-rc6/drivers/char/tpm/Makefile     2011-07-25 10:07:31.533850000 +0300
> +++ linux/drivers/char/tpm/Makefile     2011-07-25 10:07:47.018567000 +0300
> @@ -9,3 +9,4 @@
>   obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
>   obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
>   obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> +obj-$(CONFIG_TCG_NUVOTON_I2C) += tpm_nuvoton_i2c.o
> diff -uN linux-3.0-rc6/drivers/char/tpm/tpm_nuvoton_i2c.c linux/drivers/char/tpm/tpm_nuvoton_i2c.c
> --- linux-3.0-rc6/drivers/char/tpm/tpm_nuvoton_i2c.c    1970-01-01 02:00:00.000000000 +0200
> +++ linux/drivers/char/tpm/tpm_nuvoton_i2c.c    2011-07-25 10:07:47.198570000 +0300
> @@ -0,0 +1,914 @@
> +/******************************************************************************
> + * Nuvoton TPM I2C Device Driver Interface for WPCT301,
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
> +
> +/*
> + * #define DEBUG       1
> + * #define TI2C_DBG    1
> + */

Remove this comment. Also, you just need to define them, they don't need 
a value.

> +
> +#include<linux/init.h>
> +#include<linux/module.h>
> +#include<linux/moduleparam.h>
> +#include<linux/slab.h>
> +#include<linux/interrupt.h>
> +#include<linux/wait.h>
> +#include<linux/i2c.h>
> +#include<linux/version.h>
> +#include "tpm.h"
> +
> +/* I2C interface defintions */
> +#define TPM_I2C_ADDR 0x57
> +/* I2C interface offsets */
> +#define TPM_STS         0x00
> +#define TPM_DATA_FIFO_W 0x20
> +#define TPM_DATA_FIFO_R 0x40
> +#define TPM_VID_DID_RID 0x60
> +/* I2C class required */
> +#define I2C_CLASS_ALL (I2C_CLASS_HWMON | I2C_CLASS_SPD)
> +/* TPM command header size */
> +#define TPM_HEADER_SIZE 10
> +#define TPM_RETRY       5
> +/*
> + * I2C bus device maximum buffer size
> + * w/o counting I2C address or command
> + * i.e. max size required for I2C write is 34
> + *      = I2C addr, command, 32 bytes data
> + */
> +#define I2C_MAX_BUF_SIZE        32
> +#define I2C_RETRY_COUNT         32
> +#define I2C_BUS_DELAY           1   /* msec */
> +#define I2C_RETRY_DELAY_SHORT   2   /* msec */
> +#define I2C_RETRY_DELAY_LONG    10  /* msec */
> +
> +#define TPM_STS_ERR_VAL         0x07    // bit2...bit0 reads always 0

/* */ Style comments please.

> +/* I2C Addresses to scan */
> +static const unsigned short normal_i2c[] = { TPM_I2C_ADDR, I2C_CLIENT_END };
> +#if LINUX_VERSION_CODE<= KERNEL_VERSION(2,6,32)
> +I2C_CLIENT_INSMOD_1(NuvotonTPM);
> +#endif

Don't use LINUX_VERSION_CODE tests in mainline code. This is no longer 
the correct way to register I2C devices. Please see how other mainline 
i2c drivers work.

> +
> +static struct tpm_chip  *chip = NULL;
> +static struct i2c_client *ti2c_i2c_client = NULL;
> +
> +static s32 i2cReadBuf(u8 offset, u8 size, u8 *data)
Don't use camel case names. These functions should also be passed a 
struct i2c_client * pointer rather than using a global.

> +{
> +    s32 status;

Tabs, not spaces for indentation.

> +    int busyRetry = I2C_RETRY_COUNT;
> +    int nackRetry = I2C_RETRY_COUNT;
> +    int unknRetry = I2C_RETRY_COUNT;
> +#ifdef TI2C_DBG
> +    int i;
> +    char str[I2C_MAX_BUF_SIZE*4];
> +#endif
> +
> +    if (ti2c_i2c_client == NULL) {
> +        dev_err(chip->dev, "i2cReadBuf() ti2c_i2c_client is NULL\n");
> +        return -ENODEV;
> +    }

Don't think you need this test. If the probe fails then the device won't 
get registered.

> +
> +    do {
> +        status = i2c_smbus_read_i2c_block_data(
> +                    ti2c_i2c_client,
> +                    offset,
> +                    size,
> +                    data);
> +        if (status == -EBUSY) {
> +            if (busyRetry--<  0) {
> +                dev_err(chip->dev, "i2cReadBuf() bus is BUSY\n");
> +                break;
> +            }
> +            msleep(I2C_BUS_DELAY);
> +        } else if (status == -ETIME) {
> +            if (nackRetry--<  0) {
> +                dev_err(chip->dev, "i2cReadBuf() NACK from TPM\n");
> +                break;
> +            }
> +            msleep(I2C_BUS_DELAY);
> +        } else if (status<  0) {
> +            if (unknRetry--<  0) {
> +                dev_err(
> +                    chip->dev,
> +                    "i2cReadBuf() unexpected error. status=%d\n",
> +                    status);
> +                break;
> +            }
> +            msleep(I2C_BUS_DELAY);
> +        }
> +    } while (status<  0);

I don't think you need all this retry stuff. The i2c core will handle 
this for you. Just call
i2c_smbus_read_i2c_block_data and return the error code if it fails.

> +#ifdef TI2C_DBG
> +    if (status>= 0) {
> +        for (i = 0; i<  size; i++)
> +            sprintf(str +i*3, "%02x ", data[i]);
> +        dev_dbg(chip->dev,
> +             "i2cReadBuf(%0x)->  sts=%d\n\t%s\n", offset, status, str);
> +    }
> +#endif

Is this really needed? You should also look at the print_hex_dump 
functions, which can probably wrap this into a single function call with 
KERN_DEBUG level.

> +    return status;
> +}
> +
> +static s32 i2cWriteBuf(u8 offset, u8 size, u8 *data)
> +{
> +    s32 status;
> +    int busyRetry = I2C_RETRY_COUNT;
> +    int nackRetry = I2C_RETRY_COUNT;
> +    int unknRetry = I2C_RETRY_COUNT;
> +#ifdef TI2C_DBG
> +    int i;
> +    char str[I2C_MAX_BUF_SIZE*4];
> +#endif
> +
> +    if (ti2c_i2c_client == NULL)
> +    {
> +        dev_err(chip->dev, "i2cWriteBuf() ti2c_i2c_client is NULL\n");
> +        return -ENODEV;
> +    }
> +    do {
> +        status = i2c_smbus_write_i2c_block_data(
> +                    ti2c_i2c_client,
> +                    offset,
> +                    size,
> +                    data);
> +        if (status == -EBUSY) {
> +            if (busyRetry--<  0) {
> +                dev_err(chip->dev, "i2cWriteBuf() bus is BUSY\n");
> +                break;
> +            }
> +            msleep(I2C_BUS_DELAY);
> +        } else if (status == -ETIME) {
> +            if (nackRetry--<  0) {
> +                dev_err(chip->dev, "i2cWriteBuf() NACK from TPM\n");
> +                break;
> +            }
> +            msleep(I2C_BUS_DELAY);
> +        } else if (status<  0) {
> +            if (unknRetry--<  0) {
> +                dev_err(
> +                    chip->dev,
> +                    "i2cReadBuf() unexpected error. status=%d\n",
> +                    status);
> +                break;
> +            }
> +            msleep(I2C_BUS_DELAY);
> +        }
> +    } while (status<  0);
> +#ifdef TI2C_DBG
> +    if (status>= 0) {
> +        for (i = 0; i<  size; i++)
> +            sprintf(str +i*3, "%02x ", data[i]);
> +        dev_dbg(chip->dev,
> +                "i2cWriteBuf(offset=%0x, size=%0x)->  sts=%d\n\t%s\n",
> +                offset, size, status, str);
> +    }
> +#endif
> +    return status;
> +}
> +
> +static int ti2c_detect(
> +                struct i2c_client *client,
> +#if LINUX_VERSION_CODE<= KERNEL_VERSION(2,6,32)
> +                int kind,
> +#endif
> +                struct i2c_board_info *info)
> +{
> +    struct i2c_adapter *adapter = client->adapter;
> +
> +    dev_dbg(chip->dev, "ti2c_detect() In detect function\n");
> +    if (client->addr != TPM_I2C_ADDR)
> +    {
> +        dev_err(chip->dev, "ti2c_detect() Wrong I2C addr %x\n", client->addr);
> +        return -ENODEV;
> +    }
> +
> +    if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +        return -ENODEV;
> +
> +    strlcpy(info->type, "ti2c", I2C_NAME_SIZE);
> +    dev_dbg(chip->dev, "ti2c_detect() End detect function\n");
> +
> +    return 0;
> +}
> +
> +static const u8 ti2c_VidDidRidValue[] = {0x50, 0x10, 0xfe, 0x00};
> +
> +static int ti2c_i2c_prob(struct i2c_client *client,
> +                           const struct i2c_device_id *id)

ti2c_i2c_probe.

> +{
> +    u32 vidDidRid;
> +    s32 rc;
> +
> +    dev_dbg(chip->dev, "ti2c_i2c_prob() in ti2c_i2c_prob\n");
> +
> +    if (client->addr !=  TPM_I2C_ADDR)
> +    {

Braces go on the same lines as the if.

> +        dev_err(chip->dev, "ti2c_i2c_prob() client->  addr != TPM_I2C_ADDR\n");
> +        return -1; /* Error */

Use proper errno codes. -1 is EPERM.

> +    }
> +
> +    ti2c_i2c_client = client;  /* Save a pointer to the i2c client struct
> +                                * we need it during the interrupt */

Typically i2c drivers allocate some custom chip structure and then do:

     i2c_set_clientdata(client, chip);

Which means that you don't need a global pointer for the device, which 
in turn means you can have more than one of them.

> +
> +    rc = i2cReadBuf(TPM_VID_DID_RID, 4, (u8 *)(&vidDidRid));
> +    if (rc<  0) {
> +        dev_err(chip->dev,
> +                "ti2c_i2c_prob() fail to read VID/DID/RID. status=%d\n",
> +                rc);
> +        return -1;

Proper errno code.

> +    }
> +    dev_dbg(chip->dev, "ti2c_i2c_prob() VID: %04X DID: %02X RID: %02X\n",
> +             (u16)vidDidRid, (u8)(vidDidRid>>16), (u8)(vidDidRid>>24));

Don't think all the casting is necessary.

> +
> +    /* check WPCT301/NPCT350/NPCT550 values - ignore RID */
> +    if (memcmp((void*)&vidDidRid,
> +                ti2c_VidDidRidValue,
> +                sizeof(ti2c_VidDidRidValue)-1))

Drop the void * cast.

> +    {
> +        /*
> +         * f/w rev 2.81 has an issue where the VID_DID_RID is not reporting
> +         * the right value. so give it another chance at offset 0x20 (FIFO_W)
> +         */
> +        rc = i2cReadBuf(TPM_DATA_FIFO_W, 4, (u8 *)(&vidDidRid));
> +        if (rc<  0) {
> +            dev_err(chip->dev,
> +                    "ti2c_i2c_prob() fail to read VID/DID/RID. status=%d\n",
> +                    rc);
> +            return -1;
> +        }
> +        dev_dbg(chip->dev, "ti2c_i2c_prob() VID: %04X DID: %02X RID: %02X\n",
> +                 (u16)vidDidRid, (u8)(vidDidRid>>16), (u8)(vidDidRid>>24));
> +
> +        /* check WPCT301/NPCT350/NPCT550 values - ignore RID*/
> +        if (memcmp((void*)&vidDidRid,
> +                    ti2c_VidDidRidValue,
> +                    sizeof(ti2c_VidDidRidValue)-1))
> +        {
> +            ti2c_i2c_client = NULL;
> +            dev_err(chip->dev, "ti2c_i2c_prob() WPCT301/NPCT501 not found\n");
> +            return -1;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
> +static int ti2c_i2c_remove(struct i2c_client *client)
> +{
> +    dev_info(chip->dev, "in ti2c_i2c_remove\n");
> +    kfree(i2c_get_clientdata(client));
> +    return 0;
> +}
> +
> +static const struct i2c_device_id ti2c_i2c_id[] = { { "ti2c", 0 }, {} };
> +
> +static struct i2c_driver ti2c_driver = {
> +    .driver = {
> +        .name= "ti2c",
> +    },
> +    .probe  = ti2c_i2c_prob,
> +    .remove = ti2c_i2c_remove,
> +    .id_table = ti2c_i2c_id,
> +    .class     = I2C_CLASS_ALL,
> +    .detect    = ti2c_detect,
> +#if LINUX_VERSION_CODE<= KERNEL_VERSION(2,6,32)
> +    .address_data =&addr_data,
> +#else
> +    .address_list = normal_i2c,
> +#endif
> +};
> +
> +enum ti2c_status {
> +    TPM_STS_VALID = 0x80,
> +    TPM_STS_COMMAND_READY = 0x40,
> +    TPM_STS_GO = 0x20,
> +    TPM_STS_DATA_AVAIL = 0x10,
> +    TPM_STS_EXPECT = 0x08,
> +    TPM_STS_RESPONSE_RETRY = 0x02,
> +};
> +
> +enum ti2c_defaults {
> +    TI2C_MEM_BASE = 0xAE,
> +    TI2C_MEM_LEN = 0x0100,
> +    TI2C_SHORT_TIMEOUT = 750,    /* ms */
> +    TI2C_LONG_TIMEOUT = 2000,    /* 2 sec */
> +};

This should not be an enum.

> +
> +static u8 tpm_ti2c_status(struct tpm_chip *chip)
> +{
> +    s32 status;
> +    u8 data;
> +
> +    status = i2cReadBuf(TPM_STS, 1,&data);
> +    if (status<  0) {
> +        dev_err(chip->dev,
> +                "tpm_ti2c_status() error return %#02x \n",
> +                status);
> +        data = TPM_STS_ERR_VAL;
> +    }
> +
> +    return data;
> +}
> +
> +static void tpm_ti2c_ready(struct tpm_chip *chip)
> +{

This should return an error so the caller can determine if the chip is 
ready.

> +    s32 status;
> +    u8 data = TPM_STS_COMMAND_READY;
> +
> +    status = i2cWriteBuf(TPM_STS, 1,&data);
> +    if (status<  0) {
> +        dev_err(chip->dev,
> +                "tpm_ti2c_ready() fail on i2cWriteBuf() status=%d\n",
> +                status);
> +    }
> +}
> +
> +static int get_burstcount(struct tpm_chip *chip)
> +{
> +    s32             status;
> +    unsigned long   stop;
> +    int             burstcnt = -1;
> +    u8              data;
> +
> +    /* wait for burstcount */
> +    /* which timeout value, spec has 2 answers (c&  d) */
This comment is no particularly helpful. What are c & d?

> +    stop = jiffies + chip->vendor.timeout_d;
> +    do { /* in I2C burstCount is 1 byte */
> +        status = i2cReadBuf(TPM_STS +1, 1,&data);
Why TPM_STS + 1?

> +        if (status<  0) {
> +            dev_err(chip->dev, "get_burstcount() error. \n");
> +            break;
> +        } else if (data>  0) {
> +            burstcnt = data>  I2C_MAX_BUF_SIZE ? I2C_MAX_BUF_SIZE : data;

burstcnt = max(I2C_MAX_BUF_SIZE, data);

> +            break;
> +        }
> +        msleep(I2C_BUS_DELAY);
> +    } while (time_before(jiffies, stop));
> +    dev_dbg(chip->dev, "get_burstcount() ->  timeout\n");

This will always print?

> +
> +    return burstcnt;
> +}
> +
> +/*
> + * WPCT301/NPCT501 SINT# supports only dataAvail
> + * any call to this function which is not waiting for dataAvail will
> + * set queue to NULL to avoid waiting for interrupt
> + */
> +static int wait_for_stat(
> +                struct tpm_chip *chip,
> +                u8 mask,
> +                u8 value,
> +                unsigned long timeout,
> +                wait_queue_head_t *queue)
> +{
> +    unsigned long tenMsec, stop;
> +    long rc;
> +    u8 status;
> +
> +    /* check current status */
> +    status = tpm_ti2c_status(chip);
> +    if ((status != TPM_STS_ERR_VAL)&&  ((status&  mask) == value)) {

You don't need the inner parens around each clause.

> +        return 0;
> +    }
> +
> +    if ((chip->vendor.irq)&&  (queue != NULL)) {

!queue is preferable to queue != NULL. Also drop the inner parens.

> +        /* use interrupt to wait for the event */
> +        rc = wait_event_interruptible_timeout(
> +                *queue,
> +                ((status = tpm_ti2c_status(chip)) != TPM_STS_ERR_VAL)&&

Don't assign things inside the arguments to a function. It's really hard 
to see, especially when its multiline line like this.

> +                 ((status&  mask) == value),
> +                timeout);
> +        if (rc>  0) {
> +            return 0;
> +        }
> +    } else {
> +        /* use polling to wait for the event */
> +        tenMsec = jiffies + msecs_to_jiffies(I2C_RETRY_DELAY_LONG);
> +        stop = jiffies + timeout;
> +        do {
> +            if (time_before(jiffies, tenMsec)) {
> +                msleep(I2C_RETRY_DELAY_SHORT);
> +            } else {
> +                msleep(I2C_RETRY_DELAY_LONG);
> +            }
> +            status = tpm_ti2c_status(chip);
> +            if ((status != TPM_STS_ERR_VAL)&&  ((status&  mask) == value)) {
> +                return 0;
> +            }
> +        } while (time_before(jiffies, stop));
> +    }
> +    dev_err(chip->dev, "wait_for_stat(%02x, %02x) ->  timeout\n", mask, value);
> +    return -ETIME;
> +}
> +
> +static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +    s32 rc;
> +    int size = 0, burstcnt, bytes2read;
> +#ifdef DEBUG
> +    int i;
> +    char str[I2C_MAX_BUF_SIZE*4];
> +#endif
> +    while ((size<  count)&&
> +           (wait_for_stat(
> +                chip,
> +                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                chip->vendor.timeout_c,
> +                NULL) == 0))
> +    {
> +        burstcnt = get_burstcount(chip);
> +        if (burstcnt<  0) {
> +            dev_err(chip->dev,
> +                    "recv_data() fail to read burstCount=%d\n",
> +                    burstcnt);
> +            return -EIO;
> +        }
> +        /*
> +         * for (; burstcnt>  0&&  size<  count; burstcnt--)
> +         *     buf[size++] = i2cRead8(TPM_DATA_FIFO_R);
> +         */

Why is this commented out? Fix it or remove it.

> +        bytes2read = burstcnt<  (count - size) ? burstcnt : (count - size);

bytes2read = min(burst_count, count - size); ?

> +        rc = i2cReadBuf(TPM_DATA_FIFO_R, bytes2read,&buf[size]);
> +        if (rc<  0) {
> +            dev_err(chip->dev, "recv_data() fail on i2cReadBuf=%d\n", rc);
> +            return -EIO;
> +        }
> +#ifdef DEBUG
> +        for (i = 0; i<  bytes2read; i++)
> +            sprintf(str +i*3, "%02x ", buf[size+i]);
> +        dev_dbg(chip->dev, "recv_data(%d):\n\t%s\n", bytes2read, str);
> +#endif
> +        size += bytes2read;
> +    }
> +    return size;
> +}
> +
> +static int tpm_ti2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +    s32 rc;
> +    int size = 0;
> +    int expected, status, burstcnt;
> +    int retries = TPM_RETRY;
> +    u8  data = TPM_STS_RESPONSE_RETRY;
> +
> +    if (count<  TPM_HEADER_SIZE) {
> +        tpm_ti2c_ready(chip); /* return to idle */
> +        dev_err(chip->dev, "tpm_ti2c_recv() count<  header size\n");
> +        return -EIO;
> +    }
> +
> +    do {
> +        if (retries<  TPM_RETRY) {
> +            /* if this is not the first trial, set responseRetry */
> +            i2cWriteBuf(TPM_STS, 1,&data);
> +        }
> +        /* read first available (>  10 bytes), including:
> +         *      tag, paramsize, and result */
> +        status = wait_for_stat(
> +                    chip,
> +                    TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                    TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                    chip->vendor.timeout_c,
> +&chip->vendor.read_queue);
> +        if (status != 0) {
> +            dev_err(chip->dev, "tpm_ti2c_recv() wait for dataAvail\n");
> +            size = -ETIME;
> +            retries--;
> +            continue;
> +        }
> +        burstcnt = get_burstcount(chip);
> +        if (burstcnt<  0) {
> +            dev_err(chip->dev, "tpm_ti2c_recv() Unable to get burstCount\n");
> +            size = -EIO;
> +            retries --;
> +            continue;
> +        }
> +        if ((size = recv_data(chip, buf, burstcnt))<  TPM_HEADER_SIZE) {
> +            dev_err(chip->dev, "tpm_ti2c_recv() Unable to read header\n");
> +            size = -EIO;
> +            retries--;
> +            continue;
> +        }
> +        expected = be32_to_cpu(*(__be32 *) (buf + 2));
> +        if (expected>  count) {
> +            dev_err(chip->dev, "tpm_ti2c_recv() expected>  count\n");
> +            size = -EIO;
> +            retries--;
> +            continue;
> +        }
> +        rc = recv_data(chip,&buf[size], expected - size);
> +        if ((rc<  0) || ((size += rc)<  expected)) {
> +            dev_err(chip->dev,
> +                    "tpm_ti2c_recv() Unable to read remainder of result\n");
> +            size = -EIO;
> +            retries--;
> +            continue;
> +        }
> +        if (wait_for_stat(
> +                chip,
> +                TPM_STS_VALID | TPM_STS_DATA_AVAIL,
> +                TPM_STS_VALID,
> +                chip->vendor.timeout_c,
> +                NULL)) {    /* retry? */
> +            dev_err(chip->dev, "tpm_ti2c_recv() Error left over data\n");
> +            size = -ETIME;
> +            retries--;
> +            continue;
> +        }
> +        break;
> +    }while (retries>  0);

Again, get rid of all the retry stuff.

> +    tpm_ti2c_ready(chip);

Should probably return an error if it is not ready? Also, would it be 
better to do the ready tests at the beginning of each operation rather 
than the end? That way if the device is not ready you can return an 
appropriate error, and you will probably spend less time waiting since 
the waits will happen between operations.

> +    dev_dbg(chip->dev, "tpm_ti2c_recv() ->  %d\n", size);
> +    return size;
> +}
> +
> +/*
> + * If interrupts are used (signaled by an irq set in the vendor structure)
> + * tpm.c can skip polling for the data to be available as the interrupt is
> + * waited for here
> + */
> +static int tpm_ti2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
> +{
> +    int rc, burstcnt, bytes2write, retries = TPM_RETRY;
> +    size_t count = 0;
> +    u32 ordinal;
> +    u8 data;
> +#ifdef DEBUG
> +    int i;
> +    char str[I2C_MAX_BUF_SIZE*4];
> +#endif
> +
> +    do {
> +        tpm_ti2c_ready(chip);
> +        if (wait_for_stat(
> +                chip,
> +                TPM_STS_COMMAND_READY,
> +                TPM_STS_COMMAND_READY,
> +                chip->vendor.timeout_b,
> +                NULL)) {
> +            dev_err(chip->dev, "tpm_ti2c_send() timeout on commandReady\n");
> +            return -ETIME;
> +        }
> +        rc = 0;
> +        while (count<  len - 1)
> +        {
> +            burstcnt = get_burstcount(chip);
> +            if (burstcnt<  0) {
> +                dev_err(chip->dev, "tpm_ti2c_send() fail to get burstCount\n");
> +                rc = -EIO;
> +                break;
> +            }
> +            /*
> +             * for (; burstcnt>  0&&  count<  len - 1; burstcnt--) {
> +             *     i2cWrite8(buf[count], TPM_DATA_FIFO_W);
> +             *     count++;
> +             * }
> +             */

Remove this.

> +            bytes2write =
> +                (len -1 -count)<  burstcnt ? (len -1 -count) : burstcnt;
> +            rc = i2cWriteBuf(TPM_DATA_FIFO_W, bytes2write,&buf[count]);
> +            if (rc<  0) {
> +                dev_err(chip->dev, "tpm_ti2c_send() fail on i2cWriteBug\n");
> +                break;
> +            }
> +    #ifdef DEBUG
> +            for (i = 0; i<  bytes2write; i++)
> +                sprintf(str +i*3, "%02x ", buf[count+i]);
> +            dev_dbg(chip->dev, "tpm_ti2c_send(%d):\n\t%s\n", bytes2write, str);
> +    #endif
> +            count += bytes2write;
> +            if (wait_for_stat(
> +                    chip,
> +                    TPM_STS_VALID | TPM_STS_EXPECT,
> +                    TPM_STS_VALID | TPM_STS_EXPECT,
> +                    chip->vendor.timeout_c,
> +                    NULL)<  0) {
> +                dev_err(chip->dev, "tpm_ti2c_send() timeout on Expect\n");
> +                rc = -ETIME;
> +                break;
> +            }
> +        }
> +        if (rc<  0) {
> +            retries--;
> +            continue;
> +        }
> +
> +        /* write last byte */
> +        rc = i2cWriteBuf(TPM_DATA_FIFO_W, 1,&buf[count]);
> +        if (rc<  0) {
> +            dev_err(chip->dev, "tpm_ti2c_send() fail to write last byte\n");
> +            rc = -EIO;
> +            retries--;
> +            continue;
> +        }
> +        dev_dbg(chip->dev, "tpm_ti2c_send(last):\n\t%02x\n", buf[count]);
> +        if (wait_for_stat(
> +                chip,
> +                TPM_STS_VALID | TPM_STS_EXPECT,
> +                TPM_STS_VALID,
> +                chip->vendor.timeout_c,
> +                NULL)) {
> +            dev_err(chip->dev, "tpm_ti2c_send() timeout on Expect to clear\n");
> +            rc = -ETIME;
> +            retries--;
> +            continue;
> +        }
> +        break;
> +    }while (retries>  0);
> +    if (rc<  0) { /* retries == 0 */
> +        tpm_ti2c_ready(chip);
> +        return rc;
> +    }
> +    /* go and do it */
> +    data = TPM_STS_GO;
> +    rc = i2cWriteBuf(TPM_STS, 1,&data);
> +    if (rc<  0) {
> +        dev_err(chip->dev, "tpm_ti2c_send() fail to write Go\n");
> +        tpm_ti2c_ready(chip);
> +        return rc;
> +    }
> +    ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));

This line looks a bit magic.

> +    if (wait_for_stat(
> +                chip,
> +                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                tpm_calc_ordinal_duration(chip, ordinal),
> +&chip->vendor.read_queue)) {

This wait_for_stat pattern gets used a few times. Can it wrapped up in a 
helper function to make the call sites a bit simpler?

> +        dev_err(chip->dev, "tpm_ti2c_send() timeout command duration\n");
> +        tpm_ti2c_ready(chip);
> +        return rc;
> +    }
> +
> +    dev_dbg(chip->dev, "tpm_ti2c_send() ->  %d\n", len);
> +    return len;
> +}
> +
> +static struct file_operations ti2c_ops = {
> +    .owner = THIS_MODULE,
> +    .llseek = no_llseek,
> +    .open = tpm_open,
> +    .read = tpm_read,
> +    .write = tpm_write,
> +    .release = tpm_release,
> +};
> +
> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> +static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
> +           NULL);
> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +static struct attribute *ti2c_attrs[] = {
> +&dev_attr_pubek.attr,
> +&dev_attr_pcrs.attr,
> +&dev_attr_enabled.attr,
> +&dev_attr_active.attr,
> +&dev_attr_owned.attr,
> +&dev_attr_temp_deactivated.attr,
> +&dev_attr_caps.attr,
> +&dev_attr_cancel.attr, NULL,
> +};
> +
> +static struct attribute_group ti2c_attr_grp = {
> +    .attrs = ti2c_attrs
> +};
> +
> +static struct tpm_vendor_specific tpm_ti2c = {
> +    .status = tpm_ti2c_status,
> +    .recv = tpm_ti2c_recv,
> +    .send = tpm_ti2c_send,
> +    .cancel = tpm_ti2c_ready,
> +    .req_complete_mask = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +    .req_complete_val = TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +    .req_canceled = TPM_STS_COMMAND_READY,
> +    .attr_group =&ti2c_attr_grp,
> +    .miscdev = {
> +            .fops =&ti2c_ops,},
> +};
> +
> +static irqreturn_t ti2c_int_handler(int dummy, void *dev_id)
> +{
> +       struct tpm_chip *chip = dev_id;
> +
> +    /* in I2C interrupt is triggeted only on dataAvail */
> +    wake_up_interruptible(&chip->vendor.read_queue);
> +
> +    /*
> +     * consider disabling the interrupt in the host
> +     * in case of interrupt storm as TPM SINT# is level interrupt
> +     * which is cleared only when dataAvail is cleared
> +     */
> +
> +    return IRQ_HANDLED;
> +}
> +
> +static int tpm_ti2c_init(
> +                struct device *dev,
> +                unsigned long start,
> +                unsigned long len)
> +{
> +    int rc;
> +
> +    dev_dbg(dev, "tpm_ti2c_init()\n");
> +    if (!start)
> +        start = TI2C_MEM_BASE;
> +    if (!len)
> +        len = TI2C_MEM_LEN;
> +
> +    chip = tpm_register_hardware(dev,&tpm_ti2c);
> +    if (chip == NULL)
> +    {
> +        dev_err(dev, "tpm_ti2c_init() error in tpm_register_hardware\n");
> +        return -ENODEV;
> +    }
> +
> +    rc = i2c_add_driver(&ti2c_driver);
> +    if (rc != 0)
> +    {
> +        dev_err(dev, "tpm_ti2c_init() error registering i2c\n");
> +        goto out_err;
> +    }
> +
> +    if (ti2c_i2c_client == NULL)
> +    {
> +        dev_err(dev, "tpm_ti2c_init() error allocating i2c\n");
> +        rc = -ENODEV;
> +        goto out_err1;
> +    }
> +
> +    /* Default timeouts */
> +    chip->vendor.timeout_a = msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
> +    chip->vendor.timeout_b = msecs_to_jiffies(TI2C_LONG_TIMEOUT);
> +    chip->vendor.timeout_c = msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
> +    chip->vendor.timeout_d = msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
> +
> +    /*
> +     * Figure out the capabilities
> +     * I2C hard coded:
> +     * intfcaps = TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT;
> +     */
> +    dev_dbg(dev, "tpm_ti2c_init() TPM interface capabilities:\n");
> +    dev_dbg(dev, "\tInterrupt Level Low\n");
> +    dev_dbg(dev, "\tData Avail Int Support\n");
> +
> +    /* INTERRUPT Setup */
> +    init_waitqueue_head(&chip->vendor.read_queue);
> +    init_waitqueue_head(&chip->vendor.int_queue);
> +
> +    /*
> +     * I2C hard coded:
> +     * intmask = TPM_INTF_DATA_AVAIL_INT;
> +     */
> +    if (chip->vendor.irq) {
> +       dev_dbg(dev, "tpm_ti2c_init() chip-vendor.irq\n");
> +        if (request_irq(
> +                chip->vendor.irq,
> +                ti2c_int_handler,
> +                IRQF_PROBE_SHARED,
> +                chip->vendor.miscdev.name,
> +                chip) != 0)

You don't need to split each argument onto its own line. This should fit 
in 2 or 3 lines tops. It is preferable to write it like this also:

     rc = request_irq(...);
     if (rc) {
         ...
     }

> +        {
> +            dev_err(
> +                dev,
> +                "tpm_ti2c_init() Unable to request irq: %d for use\n",
> +                chip->vendor.irq);
> +            chip->vendor.irq = 0;
> +        } else {
> +            /*
> +             * Clear all existing
> +             * consider adding code that will make sure TIS is in idle state
> +             * and that dataAvail is off in the TPM_STS:
> +             * - TPM_STS<- 0x40 (commandReady)
> +             */
> +            tpm_ti2c_ready(chip);
> +            /* - wait for TPM_STS == 0xA0 (stsValid, commandReady) */
> +            rc = wait_for_stat(
> +                    chip,
> +                    TPM_STS_COMMAND_READY,
> +                    TPM_STS_COMMAND_READY,
> +                    chip->vendor.timeout_b,
> +                    NULL);
> +            if (rc == 0)
> +            {
> +                /*
> +                 * TIS is in ready state
> +                 * write dummy byte to enter reception state
> +                 * TPM_DATA_FIFO_W<- rc (0)
> +                 */
> +                rc = i2cWriteBuf(TPM_DATA_FIFO_W, 1, (u8*)(&rc));
> +                if (rc<  0) {
> +                    goto out_err1;
> +                }
> +                /* TPM_STS<- 0x40 (commandReady) */
> +                tpm_ti2c_ready(chip);
> +            } else {
> +                /*
> +                 * if timeout_b is reached then command was aborted,
> +                 * TIS in idle state
> +                 */
> +                if (tpm_ti2c_status(chip) != TPM_STS_VALID) {
> +                    rc = -EIO;
> +                    goto out_err1;
> +                }
> +            }
> +        }
> +    }
> +
> +    /* uncomment in case BIOS does not send TPM_StartUp(ST_CLEAR) command */
> +    /* tpm_startup_clear(chip); */
> +    tpm_get_timeouts(chip);
> +    tpm_continue_selftest(chip);
> +
> +    return 0;
> +
> +out_err1:
> +    i2c_del_driver(&ti2c_driver);
> +out_err:
> +    tpm_remove_hardware(chip->dev);
> +    return rc;
> +}
> +
> +static int tpm_ti2c_suspend(struct platform_device *dev, pm_message_t msg)
> +{
> +       return tpm_pm_suspend(&dev->dev, msg);
> +}
> +
> +static int tpm_ti2c_resume(struct platform_device *dev)
> +{
> +       return tpm_pm_resume(&dev->dev);
> +}
> +
> +static struct platform_driver ti2c_drv = {
> +       .driver = {
> +               .name = "tpm_ti2c",
> +               .owner = THIS_MODULE,
> +       },
> +    .suspend = tpm_ti2c_suspend,
> +    .resume = tpm_ti2c_resume,
> +};
> +
> +static struct platform_device *pdev;
> +
> +static int __init init_ti2c(void)
> +{
> +    int rc;
> +
> +    rc = platform_driver_register(&ti2c_drv);
> +    if (rc<  0)
> +        return rc;
> +
> +    pdev = platform_device_register_simple("tpm_ti2c", -1, NULL, 0);
> +    if (IS_ERR(pdev))
> +        return PTR_ERR(pdev);
> +
> +    rc = tpm_ti2c_init(&pdev->dev, 0, 0);

Why does the tpm_ti2c_init function take optional start/len arguments if 
you always pass them as zero?

> +    if(rc != 0) {
> +        platform_device_unregister(pdev);
> +        platform_driver_unregister(&ti2c_drv);
> +    }
> +
> +    return rc;
> +}
> +
> +static void __exit cleanup_ti2c(void)
> +{
> +    dev_info(chip->dev,"in cleanup_ti2c\n");
> +
> +    i2c_del_driver(&ti2c_driver);
> +    tpm_remove_hardware(chip->dev);
> +    if (chip->vendor.irq)
> +        free_irq(chip->vendor.irq, chip);
> +    platform_device_unregister(pdev);
> +    platform_driver_unregister(&ti2c_drv);
> +}

This should be an i2c driver, not a platform driver. It looks like as is 
you will end up with three different devices registered?
> +
> +module_init(init_ti2c);
> +module_exit(cleanup_ti2c);
> +MODULE_AUTHOR("Dan Morav (dan.morav@nuvoton.com)");
> +MODULE_DESCRIPTION("Nuvton TPM I2C Driver");
> +MODULE_VERSION("0.9.5.0");
Do you really need this?

> +MODULE_LICENSE("GPL");

