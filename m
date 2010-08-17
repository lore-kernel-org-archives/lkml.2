Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0HQPD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:03:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38164 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0HQPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:03:27 -0400
Date: Tue, 17 Aug 2010 17:03:23 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dan.Morav@nuvoton.com
Cc: linux-kernel@vger.kernel.org, debora@linux.vnet.ibm.com,
        srajiv@linux.vnet.ibm.com, m.selhorst@sirrix.com,
        Michal.Schramm@nuvoton.com
Subject: Re: [PATCH] TPM Nuvoton I2C driver, kernel 2.6.35
Message-ID: <20100817150323.GC2707@pengutronix.de>
References: <8F2A7B0931C16B4C99DDA3B283A436301401CFB6@ntilml01.nuvoton.com>
 <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <8F2A7B0931C16B4C99DDA3B283A43630215E501F@ntilml01.nuvoton.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Dan,

On Mon, Aug 09, 2010 at 12:24:01PM +0300, Dan.Morav@nuvoton.com wrote:
> Hi,
>=20
> Below are the additions for WPCT301 Nuvoton Technology TPM with I2C inter=
face device driver.
> This driver uses Linux I2C bus driver to interface with the I2C bus and L=
inux TPM driver (tpm.ko), to export the standard Linux TPM interface.
> This driver requires an I2C bus driver and TPM driver (tpm.ko) to be load=
ed prior to its loading.
> This driver tested on Linux kernel version 2.6.31, on an x86 platform. Ad=
ded the required I2C API changes applied in 2.6.33 to enable compilation.

If you want to have it included in the mainline kernel, it should be
tested against a recent kernel, optimum would be 2.6.36-rc1.

>=20
> Regards,
> Dan.
> _________________________
> Dan Morav
> Advanced PC
> Nuvoton Technology Israel Ltd.
> Office +972.9.970.2388
> eMail: dan.morav@nuvoton.com
>=20
> diff -uN linux-2.6.35/drivers/char/tpm/Kconfig linux/drivers/char/tpm/Kco=
nfig
> --- linux-2.6.35/drivers/char/tpm/Kconfig       2010-08-02 01:11:14.00000=
0000 +0300
> +++ linux/drivers/char/tpm/Kconfig      2010-08-08 23:08:32.017438534 +03=
00
> @@ -33,6 +33,15 @@
>           from within Linux.  To compile this driver as a module, choose
>           M here; the module will be called tpm_tis.
>=20
> +config TCG_NUVOTON_I2C
> +       tristate "Nuvoton Technology Corp. TPM 1.2 I2C Interface"
> +       depends on I2C
> +       ---help---
> +         If you have a TPM security chip with I2C interface from
> +         Nuvoton Technology Corp. say Yes and it will be accessible
> +         from within Linux.  To compile this driver as a module, choose
> +         M here; the module will be called tpm_nuvoton_i2c.
> +
>  config TCG_NSC
>         tristate "National Semiconductor TPM Interface"
>         ---help---
> diff -uN linux-2.6.35/drivers/char/tpm/Makefile linux/drivers/char/tpm/Ma=
kefile
> --- linux-2.6.35/drivers/char/tpm/Makefile      2010-08-02 01:11:14.00000=
0000 +0300
> +++ linux/drivers/char/tpm/Makefile     2010-08-08 11:56:30.721438699 +03=
00
> @@ -9,3 +9,4 @@
>  obj-$(CONFIG_TCG_NSC) +=3D tpm_nsc.o
>  obj-$(CONFIG_TCG_ATMEL) +=3D tpm_atmel.o
>  obj-$(CONFIG_TCG_INFINEON) +=3D tpm_infineon.o
> +obj-$(CONFIG_TCG_NUVOTON_I2C) +=3D tpm_nuvoton_i2c.o
> diff -uN linux-2.6.35/drivers/char/tpm/tpm_nuvoton_i2c.c linux/drivers/ch=
ar/tpm/tpm_nuvoton_i2c.c
> --- linux-2.6.35/drivers/char/tpm/tpm_nuvoton_i2c.c     1970-01-01 02:00:=
00.000000000 +0200
> +++ linux/drivers/char/tpm/tpm_nuvoton_i2c.c    2010-08-08 20:29:24.46943=
8926 +0300
> @@ -0,0 +1,748 @@
> +/***********************************************************************=
*******
> + * Nuvoton TPM I2C Device Driver Interface for WPCT301,
> + * based on the TCG TPM Interface Spec version 1.2.
> + * Specifications at www.trustedcomputinggroup.org
> + *
> + * Copyright (C) 2010, Nuvoton Technology Corporation.
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
> + ***********************************************************************=
******/
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/wait.h>
> +#include <linux/i2c.h>
> +#include <linux/version.h>
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
> +/*
> + * I2C bus device maximum buffer size
> + * w/o counting I2C address or command
> + * i.e. max size required for I2C write is 34
> + *      =3D I2C addr, command, 32 bytes data
> + */
> +#define I2C_MAX_BUF 32
> +
> +/* I2C Addresses to scan */
> +static const unsigned short normal_i2c[] =3D { TPM_I2C_ADDR, I2C_CLIENT_=
END };
> +#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,6,32)
> +I2C_CLIENT_INSMOD_1(NuvotonTPM);
> +#endif

No workarounds for older kernels in upstream drivers, please.

> +
> +static struct tpm_chip  *chip =3D NULL;
> +static struct i2c_client *ti2c_i2c_client =3D NULL;

static? so you can have only one instance?

> +
> +static u8 i2cRead8(u8 offset)

the function name does not match the others in style, should be more
like 'i2c_read8'

> +{
> +    s32 status;

indentation is wrong. should be one tab.

please make sure you used the checkpatch-script. and please read
CodingStyle and SubmittingPatches in the Documentation/ -folder

> +    u8  result;
> +
> +    /* dev_info(chip->dev, "in i2cRead8(%0x)\n", offset); */

those need to go, also all later occurences

> +    if (ti2c_i2c_client =3D=3D NULL) {
> +        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
> +        return 0xff;
> +    }
> +    status =3D i2c_smbus_read_i2c_block_data(
> +                ti2c_i2c_client,
> +                offset,
> +                1,
> +                &result);

This could be in one or two lines, also all similar occurences

> +    /*
> +     * dev_info(
> +     *     chip->dev,
> +     *     "i2cRead8(%0x)=3D%0x, sts=3D%d\n", offset, result, status);
> +     */
> +
> +    return result;
> +}
> +
> +static u32 i2cRead32(u8 offset)
> +{
> +    s32 status;
> +    u32 result;
> +
> +    /* dev_info(chip->dev, "in i2cRead32(%0x)\n", offset); */
> +    if (ti2c_i2c_client =3D=3D NULL) {
> +        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
> +        return 0xffffffff;
> +    }
> +    status =3D i2c_smbus_read_i2c_block_data(
> +                ti2c_i2c_client,
> +                offset,
> +                4,
> +                (u8*)&result);
> +    /*
> +     * dev_info(
> +     *     chip->dev,
> +     *     "i2cRead32(%0x)=3D%04x, sts=3D%d\n", offset, result, status);
> +     */
> +
> +    return result;
> +}
> +
> +static void i2cReadBuf(u8 offset, u8 size, u8 *data)
> +{
> +    s32 status;
> +
> +    /* dev_info(chip->dev, "in i2cReadBuf(%0x, %0x)\n", offset, size); */
> +    if (ti2c_i2c_client =3D=3D NULL) {
> +        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
> +        return;
> +    }
> +    status =3D i2c_smbus_read_i2c_block_data(
> +                ti2c_i2c_client,
> +                offset,
> +                size,
> +                data);
> +    /*
> +     * dev_info(
> +     *     chip->dev,
> +     *     "i2cRead32(%0x)=3D%04x, sts=3D%d\n", offset, result, status);
> +     */
> +
> +    return;

You can drop plain 'return' at the end of a function.

> +}
> +
> +static void i2cWrite8(u8 data, u8 offset)
> +{
> +    s32 status;
> +
> +    /*
> +     * dev_info(
> +     *      chip->dev,
> +     *       "in i2cWrite8(data=3D%0x, offset=3D%0x)\n", data, offset);
> +     */
> +    if (ti2c_i2c_client =3D=3D NULL)
> +    {
> +        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
> +        return;
> +    }
> +    status =3D i2c_smbus_write_i2c_block_data(
> +                ti2c_i2c_client,
> +                offset,
> +                1,
> +                &data);
> +    /*
> +     * dev_info(
> +     *     chip->dev,
> +     *     "i2cWrite8(%0x, %0x), sts=3D%d\n", data, offset, status);
> +     */
> +}
> +
> +static void i2cWriteBuf(u8 offset, u8 size, u8 *data)
> +{
> +    s32 status;
> +
> +    /*
> +     * dev_info(
> +     *      chip->dev,
> +     *      "in i2cWriteBuf(offset=3D%0x, size=3D%0x)\n", offset, size);
> +     */
> +    if (ti2c_i2c_client =3D=3D NULL)
> +    {
> +        dev_err(chip->dev, "ti2c_i2c_client is NULL\n");
> +        return;
> +    }
> +    status =3D i2c_smbus_write_i2c_block_data(
> +                ti2c_i2c_client,
> +                offset,
> +                size,
> +                data);
> +    /*
> +     * dev_info(
> +     *     chip->dev,
> +     *     "i2cWriteBuf(offset=3D%0x, size=3D%0x), sts=3D%d\n", offset, =
size, status);
> +     */
> +}
> +
> +static int ti2c_detect(
> +                struct i2c_client *client,
> +#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,6,32)
> +                int kind,
> +#endif

drop this again...

> +                struct i2c_board_info *info)
> +{
> +    struct i2c_adapter *adapter =3D client->adapter;
> +
> +    dev_info(chip->dev, "In detect function\n");
> +    if (client->addr !=3D TPM_I2C_ADDR)
> +    {
> +        dev_err(chip->dev, "Wrong I2C addr %x\n", client->addr);
> +        return -ENODEV;
> +    }
> +
> +    if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +        return -ENODEV;
> +
> +    strlcpy(info->type, "ti2c", I2C_NAME_SIZE);
> +    dev_info(chip->dev, "End detect function\n");
> +
> +    return 0;
> +}
> +
> +static const u8 ti2c_VidDidRidValue[] =3D {0x50, 0x10, 0xfe, 0x00};
> +
> +static int ti2c_i2c_prob(struct i2c_client *client,
> +                         const struct i2c_device_id *id)
> +{
> +    u32 vidDidRid;
> +
> +    dev_info(chip->dev, "in ti2c_i2c_prob\n");
> +
> +    if (client->addr !=3D  TPM_I2C_ADDR)
> +    {
> +        return -1; /* Error */

-ESOMETHING?

Well, I'll stop here. Please read the documentation I mentioned above
and adjust the driver accordingly. Once it matches most of the formal
requirements, reviewing the internal workings of the driver will be much
easier.

Of course, thank you for contributing this driver in the first place!

Regards,

   Wolfram

> +    }
> +
> +    ti2c_i2c_client =3D client;  /* Save a pointer to the i2c client str=
uct
> +                                * we need it during the interrupt */
> +
> +    vidDidRid =3D i2cRead32(TPM_VID_DID_RID);
> +    dev_info(chip->dev, "VID: %04X DID: %02X RID: %02X\n",
> +             (u16)vidDidRid, (u8)(vidDidRid>>16), (u8)(vidDidRid>>24));
> +
> +    /* check WPCT301 values */
> +    if (memcmp((void*)&vidDidRid, ti2c_VidDidRidValue, sizeof(u32)))
> +    {
> +        /*
> +         * f/w rev 2.81 has an issue where the VID_DID_RID is not report=
ing
> +         * the right value. so give it another chance at offset 0x20 (FI=
FO_W)
> +         */
> +        vidDidRid =3D i2cRead32(TPM_DATA_FIFO_W);
> +        dev_info(chip->dev, "VID: %04X DID: %02X RID: %02X\n",
> +                 (u16)vidDidRid, (u8)(vidDidRid>>16), (u8)(vidDidRid>>24=
));
> +
> +        /* check WPCT301 values */
> +        if (memcmp((void*)&vidDidRid, ti2c_VidDidRidValue, sizeof(u32)))
> +        {
> +            ti2c_i2c_client =3D NULL;
> +            dev_err(chip->dev, "WPCT301 not found\n");
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
> +static const struct i2c_device_id ti2c_i2c_id[] =3D { { "ti2c", 0 }, {} =
};
> +
> +static struct i2c_driver ti2c_driver =3D {
> +    .driver =3D {
> +        .name=3D "ti2c",
> +    },
> +    .probe  =3D ti2c_i2c_prob,
> +    .remove =3D ti2c_i2c_remove,
> +    .id_table =3D ti2c_i2c_id,
> +    .class     =3D I2C_CLASS_ALL,
> +    .detect    =3D ti2c_detect,
> +#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,6,32)
> +    .address_data =3D &addr_data,
> +#else
> +    .address_list =3D normal_i2c,
> +#endif
> +};
> +
> +enum ti2c_status {
> +    TPM_STS_VALID =3D 0x80,
> +    TPM_STS_COMMAND_READY =3D 0x40,
> +    TPM_STS_GO =3D 0x20,
> +    TPM_STS_DATA_AVAIL =3D 0x10,
> +    TPM_STS_DATA_EXPECT =3D 0x08,
> +};
> +
> +enum ti2c_defaults {
> +    TI2C_MEM_BASE =3D 0xAE,
> +    TI2C_MEM_LEN =3D 0x0100,
> +    TI2C_SHORT_TIMEOUT =3D 750,    /* ms */
> +    TI2C_LONG_TIMEOUT =3D 2000,    /* 2 sec */
> +};
> +
> +static u8 tpm_ti2c_status(struct tpm_chip *chip)
> +{
> +    return i2cRead8(TPM_STS);
> +}
> +
> +static void tpm_ti2c_ready(struct tpm_chip *chip)
> +{
> +    /* this causes the current command to be aborted */
> +    i2cWrite8(TPM_STS_COMMAND_READY, TPM_STS);
> +}
> +
> +static int get_burstcount(struct tpm_chip *chip)
> +{
> +    unsigned long stop;
> +    int burstcnt;
> +
> +    /* wait for burstcount */
> +    /* which timeout value, spec has 2 answers (c & d) */
> +    stop =3D jiffies + chip->vendor.timeout_d;
> +    do { /* in I2C burstCount is 1 byte */
> +        burstcnt =3D i2cRead8(TPM_STS + 1);
> +        if (burstcnt)
> +            return burstcnt > I2C_MAX_BUF ? I2C_MAX_BUF : burstcnt;
> +        msleep(TPM_TIMEOUT);
> +    } while (time_before(jiffies, stop));
> +    return -EBUSY;
> +}
> +
> +/*
> + * WPCT301 SINT# supports only dataAvail
> + * any call to this function which is not waiting for dataAvail will
> + * set queue to NULL to avoid waiting for interrupt
> + */
> +static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long t=
imeout,
> +             wait_queue_head_t *queue)
> +{
> +    unsigned long stop;
> +    long rc;
> +    u8 status;
> +
> +    /* check current status */
> +    status =3D tpm_ti2c_status(chip);
> +    if ((status & mask) =3D=3D mask)
> +        return 0;
> +
> +    if ((chip->vendor.irq) && (queue !=3D NULL)) {
> +        rc =3D wait_event_interruptible_timeout(*queue,
> +                ((tpm_ti2c_status(chip) & mask) =3D=3D mask),
> +                timeout);
> +        if (rc > 0)
> +            return 0;
> +    } else {
> +        stop =3D jiffies + timeout;
> +        do {
> +            msleep(TPM_TIMEOUT);
> +            status =3D tpm_ti2c_status(chip);
> +            if ((status & mask) =3D=3D mask)
> +                return 0;
> +        } while (time_before(jiffies, stop));
> +    }
> +    return -ETIME;
> +}
> +
> +static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +    int size =3D 0, burstcnt, bytes2read;
> +
> +    while ((size < count) &&
> +           wait_for_stat(
> +                chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                chip->vendor.timeout_c,
> +                &chip->vendor.read_queue) =3D=3D 0)
> +    {
> +        burstcnt =3D get_burstcount(chip);
> +        /*
> +         * for (; burstcnt > 0 && size < count; burstcnt--)
> +         *     buf[size++] =3D i2cRead8(TPM_DATA_FIFO_R);
> +         */
> +        bytes2read =3D burstcnt < (count - size) ? burstcnt : (count - s=
ize);
> +        i2cReadBuf(TPM_DATA_FIFO_R, bytes2read, &buf[size]);
> +        size +=3D bytes2read;
> +    }
> +    return size;
> +}
> +
> +static int tpm_ti2c_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +    int size =3D 0;
> +    int expected, status;
> +
> +    if (count < TPM_HEADER_SIZE) {
> +        size =3D -EIO;
> +        goto out;
> +    }
> +
> +    /* read first available (> 10 bytes), including:
> +     *      tag, paramsize, and result */
> +    status =3D wait_for_stat(
> +                chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                chip->vendor.timeout_c,
> +                &chip->vendor.read_queue);
> +    if (status !=3D 0) {
> +        size =3D -EIO;
> +        goto out;
> +    }
> +    size =3D get_burstcount(chip);
> +    if ((size =3D recv_data(chip, buf, size)) < TPM_HEADER_SIZE) {
> +        dev_err(chip->dev, "Unable to read header\n");
> +        goto out;
> +    }
> +
> +    expected =3D be32_to_cpu(*(__be32 *) (buf + 2));
> +    if (expected > count) {
> +        size =3D -EIO;
> +        goto out;
> +    }
> +
> +    if ((size +=3D recv_data(chip, &buf[size], expected - size)) < expec=
ted) {
> +        dev_err(chip->dev, "Unable to read remainder of result\n");
> +        size =3D -ETIME;
> +        goto out;
> +    }
> +
> +    /* for WPCT301 both stsValid and dataAvail set at the same time */
> +    wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, NULL);
> +    status =3D tpm_ti2c_status(chip);
> +    if (status & TPM_STS_DATA_AVAIL) {    /* retry? */
> +        dev_err(chip->dev, "Error left over data\n");
> +        size =3D -EIO;
> +        goto out;
> +    }
> +
> +out:
> +    tpm_ti2c_ready(chip);
> +    return size;
> +}
> +
> +/*
> + * If interrupts are used (signaled by an irq set in the vendor structur=
e)
> + * tpm.c can skip polling for the data to be available as the interrupt =
is
> + * waited for here
> + */
> +static int tpm_ti2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
> +{
> +    int rc, status, burstcnt, bytes2write;
> +    size_t count =3D 0;
> +    u32 ordinal;
> +
> +    status =3D tpm_ti2c_status(chip);
> +    if ((status & TPM_STS_COMMAND_READY) =3D=3D 0) {
> +        tpm_ti2c_ready(chip);
> +         rc =3D wait_for_stat(
> +                 chip,
> +                 TPM_STS_COMMAND_READY,
> +                 chip->vendor.timeout_b,
> +                 NULL);
> +         if (rc =3D=3D -ETIME)
> +            goto out_err;
> +    }
> +
> +    while (count < len - 1) {
> +        burstcnt =3D get_burstcount(chip);
> +        /*
> +         * for (; burstcnt > 0 && count < len - 1; burstcnt--) {
> +         *     i2cWrite8(buf[count], TPM_DATA_FIFO_W);
> +         *     count++;
> +         * }
> +         */
> +        bytes2write =3D (len -1 -count) < burstcnt ? (len -1 -count) : b=
urstcnt;
> +        i2cWriteBuf(TPM_DATA_FIFO_W, bytes2write, &buf[count]);
> +        count +=3D bytes2write;
> +
> +        wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, NULL);
> +        status =3D tpm_ti2c_status(chip);
> +        if ((status & TPM_STS_DATA_EXPECT) =3D=3D 0) {
> +            rc =3D -EIO;
> +            goto out_err;
> +        }
> +    }
> +
> +    /* write last byte */
> +    i2cWrite8(buf[count], TPM_DATA_FIFO_W);
> +    wait_for_stat(chip, TPM_STS_VALID, chip->vendor.timeout_c, NULL);
> +    status =3D tpm_ti2c_status(chip);
> +    if ((status & TPM_STS_DATA_EXPECT) !=3D 0) {
> +        rc =3D -EIO;
> +        goto out_err;
> +    }
> +
> +    /* go and do it */
> +    i2cWrite8(TPM_STS_GO, TPM_STS);
> +
> +    ordinal =3D be32_to_cpu(*((__be32 *) (buf + 6)));
> +    rc =3D wait_for_stat(
> +                chip,
> +                TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +                tpm_calc_ordinal_duration(chip, ordinal),
> +                &chip->vendor.read_queue);
> +    if (rc =3D=3D -ETIME)
> +        goto out_err;
> +
> +    return len;
> +
> +out_err:
> +    tpm_ti2c_ready(chip);
> +    return rc;
> +}
> +
> +static struct file_operations ti2c_ops =3D {
> +    .owner =3D THIS_MODULE,
> +    .llseek =3D no_llseek,
> +    .open =3D tpm_open,
> +    .read =3D tpm_read,
> +    .write =3D tpm_write,
> +    .release =3D tpm_release,
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
> +
> +static struct attribute *ti2c_attrs[] =3D {
> +    &dev_attr_pubek.attr,
> +    &dev_attr_pcrs.attr,
> +    &dev_attr_enabled.attr,
> +    &dev_attr_active.attr,
> +    &dev_attr_owned.attr,
> +    &dev_attr_temp_deactivated.attr,
> +    &dev_attr_caps.attr,
> +    &dev_attr_cancel.attr, NULL,
> +};
> +
> +static struct attribute_group ti2c_attr_grp =3D {
> +    .attrs =3D ti2c_attrs
> +};
> +
> +static struct tpm_vendor_specific tpm_ti2c =3D {
> +    .status =3D tpm_ti2c_status,
> +    .recv =3D tpm_ti2c_recv,
> +    .send =3D tpm_ti2c_send,
> +    .cancel =3D tpm_ti2c_ready,
> +    .req_complete_mask =3D TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +    .req_complete_val =3D TPM_STS_DATA_AVAIL | TPM_STS_VALID,
> +    .req_canceled =3D TPM_STS_COMMAND_READY,
> +    .attr_group =3D &ti2c_attr_grp,
> +    .miscdev =3D {
> +            .fops =3D &ti2c_ops,},
> +};
> +
> +static irqreturn_t ti2c_int_handler(int dummy, void *dev_id)
> +{
> +       struct tpm_chip *chip =3D dev_id;
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
> +static int tpm_ti2c_init(struct device *dev, unsigned long start,
> +            unsigned long len)
> +{
> +    u32 vendor;
> +    int rc;
> +
> +    dev_info(dev, "in tpm_ti2c_init\n");
> +    if (!start)
> +        start =3D TI2C_MEM_BASE;
> +    if (!len)
> +        len =3D TI2C_MEM_LEN;
> +
> +    chip =3D tpm_register_hardware(dev, &tpm_ti2c);
> +    if (chip =3D=3D NULL)
> +    {
> +        dev_err(dev, "error in tpm_register_hardware\n");
> +        return -ENODEV;
> +    }
> +
> +    rc =3D i2c_add_driver(&ti2c_driver);
> +    if (rc !=3D 0)
> +    {
> +        dev_err(dev, "error registering i2c\n");
> +        goto out_err;
> +    }
> +
> +    if (ti2c_i2c_client =3D=3D NULL)
> +    {
> +        dev_err(dev, "error allocating i2c\n");
> +        rc =3D -ENODEV;
> +        goto out_err1;
> +    }
> +
> +    /* Default timeouts */
> +    chip->vendor.timeout_a =3D msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
> +    chip->vendor.timeout_b =3D msecs_to_jiffies(TI2C_LONG_TIMEOUT);
> +    chip->vendor.timeout_c =3D msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
> +    chip->vendor.timeout_d =3D msecs_to_jiffies(TI2C_SHORT_TIMEOUT);
> +
> +    vendor =3D i2cRead32(TPM_VID_DID_RID);
> +    dev_info(dev,
> +             "1.2 TPM (device-id 0x%X, rev-id %d)\n",
> +             vendor >> 16, (u16)vendor);
> +
> +    /*
> +     * Figure out the capabilities
> +     * I2C hard coded:
> +     * intfcaps =3D TPM_INTF_INT_LEVEL_LOW | TPM_INTF_DATA_AVAIL_INT;
> +     */
> +    dev_dbg(dev, "TPM interface capabilities:\n");
> +    dev_dbg(dev, "\tInterrupt Level Low\n");
> +    dev_dbg(dev, "\tData Avail Int Support\n");
> +
> +    /* INTERRUPT Setup */
> +    init_waitqueue_head(&chip->vendor.read_queue);
> +    init_waitqueue_head(&chip->vendor.int_queue);
> +
> +    /*
> +     * I2C hard coded:
> +     * intmask =3D TPM_INTF_DATA_AVAIL_INT;
> +     */
> +    if (chip->vendor.irq) {
> +        if (request_irq(
> +                chip->vendor.irq,
> +                ti2c_int_handler,
> +                IRQF_PROBE_SHARED,
> +                chip->vendor.miscdev.name,
> +                chip) !=3D 0)
> +        {
> +            dev_info(dev,
> +                     "Unable to request irq: %d for use\n", chip->vendor=
=2Eirq);
> +            chip->vendor.irq =3D 0;
> +        } else {
> +            /*
> +             * Clear all existing
> +             * consider adding code that will make sure TIS is in idle s=
tate
> +             * and that dataAvail is off in the TPM_STS:
> +             * - TPM_STS <- 0x40 (commandReady)
> +             */
> +            tpm_ti2c_ready(chip);
> +            /* - wait for TPM_STS =3D=3D 0xA0 (stsValid, commandReady) */
> +            rc =3D wait_for_stat(
> +                    chip,
> +                    TPM_STS_COMMAND_READY,
> +                    chip->vendor.timeout_b,
> +                    NULL);
> +            if (rc =3D=3D 0)
> +            {
> +                /*
> +                 * TIS is in ready state
> +                 * write dummy byte to enter reception state
> +                 * TPM_DATA_FIFO_W <- 0x00
> +                 */
> +                i2cWrite8(0x00, TPM_DATA_FIFO_W);
> +                /* TPM_STS <- 0x40 (commandReady) */
> +                tpm_ti2c_ready(chip);
> +            } else {
> +                /*
> +                 * if timeout_b is reached then command was aborted,
> +                 * TIS in idle state
> +                 */
> +                if (tpm_ti2c_status(chip) !=3D TPM_STS_VALID) {
> +                    rc =3D -EIO;
> +                    goto out_err1;
> +                }
> +            }
> +        }
> +    }
> +
> +    /* uncomment in case BIOS does not send TPM_StartUp(ST_CLEAR) comman=
d */
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
> +static int tpm_ti2c_suspend(struct platform_device *dev, pm_message_t ms=
g)
> +{
> +       return tpm_pm_suspend(&dev->dev, msg);
> +}
> +
> +static int tpm_ti2c_resume(struct platform_device *dev)
> +{
> +       return tpm_pm_resume(&dev->dev);
> +}
> +
> +static struct platform_driver ti2c_drv =3D {
> +       .driver =3D {
> +               .name =3D "tpm_ti2c",
> +               .owner =3D THIS_MODULE,
> +       },
> +    .suspend =3D tpm_ti2c_suspend,
> +    .resume =3D tpm_ti2c_resume,
> +};
> +
> +static struct platform_device *pdev;
> +
> +static int __init init_ti2c(void)
> +{
> +    int rc;
> +
> +    rc =3D platform_driver_register(&ti2c_drv);
> +    if (rc < 0)
> +        return rc;
> +
> +    pdev =3D platform_device_register_simple("tpm_ti2c", -1, NULL, 0);
> +    if (IS_ERR(pdev))
> +        return PTR_ERR(pdev);
> +
> +    rc =3D tpm_ti2c_init(&pdev->dev, 0, 0);
> +    if(rc !=3D 0) {
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
> +
> +module_init(init_ti2c);
> +module_exit(cleanup_ti2c);
> +MODULE_AUTHOR("Dan Morav (dan.morav@nuvoton.com)");
> +MODULE_DESCRIPTION("Nuvton TPM I2C Driver");
> +MODULE_VERSION("0.9.2");
> +MODULE_LICENSE("GPL");
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The privileged confidential information contained in this email is intend=
ed for use only by the addressees as indicated by the original sender of th=
is email. If you are not the addressee indicated in this email or are not r=
esponsible for delivery of the email to such a person, please kindly reply =
to the sender indicating this fact and delete all copies of it from your co=
mputer and network server immediately. Your cooperation is highly appreciat=
ed. It is advised that any unauthorized use of confidential information of =
Nuvoton is strictly prohibited; and any information in this email irrelevan=
t to the official business of Nuvoton shall be deemed as neither given nor =
endorsed by Nuvoton.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> The privileged confidential information contained in this email is intend=
ed for use only by the addressees as indicated by the original sender of th=
is email. If you are not the addressee indicated in this email or are not r=
esponsible for delivery of the email to such a person, please kindly reply =
to the sender indicating this fact and delete all copies of it from your co=
mputer and network server immediately. Your cooperation is highly appreciat=
ed. It is advised that any unauthorized use of confidential information of =
Nuvoton is strictly prohibited; and any information in this email irrelevan=
t to the official business of Nuvoton shall be deemed as neither given nor =
endorsed by Nuvoton.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxqpLsACgkQD27XaX1/VRucOwCfRfJUcHCFlA5aJIp9jTmXul6h
3kAAnR2/tzXiOmqh8+Cu7m29z8W8JVPw
=a7n7
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
