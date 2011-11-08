Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1KHOhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:37:07 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:49777 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932645Ab1KHOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:37:04 -0500
Date: Tue, 8 Nov 2011 16:36:59 +0200
From: Felipe Balbi <balbi@ti.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        nicolas.ferre@atmel.com, rmallon@gmail.com, balbi@ti.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V3 1/4] drivers/i2c/busses/i2c-at91.c: remove broken
 driver
Message-ID: <20111108143658.GG20728@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320753142.git.n.voss@weinmann.de>
 <458dd879d1fcdfc093e038426a581d86d30ecd5e.1320753142.git.n.voss@weinmann.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
Content-Disposition: inline
In-Reply-To: <458dd879d1fcdfc093e038426a581d86d30ecd5e.1320753142.git.n.voss@weinmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 08, 2011 at 11:49:24AM +0100, Nikolaus Voss wrote:
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
> ---
>  drivers/i2c/busses/i2c-at91.c |  327 -----------------------------------=
------
>  1 files changed, 0 insertions(+), 327 deletions(-)
>  delete mode 100644 drivers/i2c/busses/i2c-at91.c
>=20
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> deleted file mode 100644
> index 305c075..0000000
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ /dev/null
> @@ -1,327 +0,0 @@
> -/*
> -    i2c Support for Atmel's AT91 Two-Wire Interface (TWI)
> -
> -    Copyright (C) 2004 Rick Bronson
> -    Converted to 2.6 by Andrew Victor <andrew@sanpeople.com>
> -
> -    Borrowed heavily from original work by:
> -    Copyright (C) 2000 Philip Edelbrock <phil@stimpy.netroedge.com>
> -
> -    This program is free software; you can redistribute it and/or modify
> -    it under the terms of the GNU General Public License as published by
> -    the Free Software Foundation; either version 2 of the License, or
> -    (at your option) any later version.
> -*/
> -
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> -#include <linux/err.h>
> -#include <linux/slab.h>
> -#include <linux/types.h>
> -#include <linux/delay.h>
> -#include <linux/i2c.h>
> -#include <linux/init.h>
> -#include <linux/clk.h>
> -#include <linux/platform_device.h>
> -#include <linux/io.h>
> -
> -#include <mach/at91_twi.h>
> -#include <mach/board.h>
> -#include <mach/cpu.h>
> -
> -#define TWI_CLOCK		100000		/* Hz. max 400 Kbits/sec */
> -
> -
> -static struct clk *twi_clk;
> -static void __iomem *twi_base;
> -
> -#define at91_twi_read(reg)		__raw_readl(twi_base + (reg))
> -#define at91_twi_write(reg, val)	__raw_writel((val), twi_base + (reg))
> -
> -
> -/*
> - * Initialize the TWI hardware registers.
> - */
> -static void __devinit at91_twi_hwinit(void)
> -{
> -	unsigned long cdiv, ckdiv;
> -
> -	at91_twi_write(AT91_TWI_IDR, 0xffffffff);	/* Disable all interrupts */
> -	at91_twi_write(AT91_TWI_CR, AT91_TWI_SWRST);	/* Reset peripheral */
> -	at91_twi_write(AT91_TWI_CR, AT91_TWI_MSEN);	/* Set Master mode */
> -
> -	/* Calcuate clock dividers */
> -	cdiv =3D (clk_get_rate(twi_clk) / (2 * TWI_CLOCK)) - 3;
> -	cdiv =3D cdiv + 1;	/* round up */
> -	ckdiv =3D 0;
> -	while (cdiv > 255) {
> -		ckdiv++;
> -		cdiv =3D cdiv >> 1;
> -	}
> -
> -	if (cpu_is_at91rm9200()) {			/* AT91RM9200 Errata #22 */
> -		if (ckdiv > 5) {
> -			printk(KERN_ERR "AT91 I2C: Invalid TWI_CLOCK value!\n");
> -			ckdiv =3D 5;
> -		}
> -	}
> -
> -	at91_twi_write(AT91_TWI_CWGR, (ckdiv << 16) | (cdiv << 8) | cdiv);
> -}
> -
> -/*
> - * Poll the i2c status register until the specified bit is set.
> - * Returns 0 if timed out (100 msec).
> - */
> -static short at91_poll_status(unsigned long bit)
> -{
> -	int loop_cntr =3D 10000;
> -
> -	do {
> -		udelay(10);
> -	} while (!(at91_twi_read(AT91_TWI_SR) & bit) && (--loop_cntr > 0));
> -
> -	return (loop_cntr > 0);
> -}
> -
> -static int xfer_read(struct i2c_adapter *adap, unsigned char *buf, int l=
ength)
> -{
> -	/* Send Start */
> -	at91_twi_write(AT91_TWI_CR, AT91_TWI_START);
> -
> -	/* Read data */
> -	while (length--) {
> -		if (!length)	/* need to send Stop before reading last byte */
> -			at91_twi_write(AT91_TWI_CR, AT91_TWI_STOP);
> -		if (!at91_poll_status(AT91_TWI_RXRDY)) {
> -			dev_dbg(&adap->dev, "RXRDY timeout\n");
> -			return -ETIMEDOUT;
> -		}
> -		*buf++ =3D (at91_twi_read(AT91_TWI_RHR) & 0xff);
> -	}
> -
> -	return 0;
> -}
> -
> -static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int =
length)
> -{
> -	/* Load first byte into transmitter */
> -	at91_twi_write(AT91_TWI_THR, *buf++);
> -
> -	/* Send Start */
> -	at91_twi_write(AT91_TWI_CR, AT91_TWI_START);
> -
> -	do {
> -		if (!at91_poll_status(AT91_TWI_TXRDY)) {
> -			dev_dbg(&adap->dev, "TXRDY timeout\n");
> -			return -ETIMEDOUT;
> -		}
> -
> -		length--;	/* byte was transmitted */
> -
> -		if (length > 0)		/* more data to send? */
> -			at91_twi_write(AT91_TWI_THR, *buf++);
> -	} while (length);
> -
> -	/* Send Stop */
> -	at91_twi_write(AT91_TWI_CR, AT91_TWI_STOP);
> -
> -	return 0;
> -}
> -
> -/*
> - * Generic i2c master transfer entrypoint.
> - *
> - * Note: We do not use Atmel's feature of storing the "internal device a=
ddress".
> - * Instead the "internal device address" has to be written using a separ=
ate
> - * i2c message.
> - * http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2004-Septemb=
er/024411.html
> - */
> -static int at91_xfer(struct i2c_adapter *adap, struct i2c_msg *pmsg, int=
 num)
> -{
> -	int i, ret;
> -
> -	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
> -
> -	for (i =3D 0; i < num; i++) {
> -		dev_dbg(&adap->dev, " #%d: %sing %d byte%s %s 0x%02x\n", i,
> -			pmsg->flags & I2C_M_RD ? "read" : "writ",
> -			pmsg->len, pmsg->len > 1 ? "s" : "",
> -			pmsg->flags & I2C_M_RD ? "from" : "to",	pmsg->addr);
> -
> -		at91_twi_write(AT91_TWI_MMR, (pmsg->addr << 16)
> -			| ((pmsg->flags & I2C_M_RD) ? AT91_TWI_MREAD : 0));
> -
> -		if (pmsg->len && pmsg->buf) {	/* sanity check */
> -			if (pmsg->flags & I2C_M_RD)
> -				ret =3D xfer_read(adap, pmsg->buf, pmsg->len);
> -			else
> -				ret =3D xfer_write(adap, pmsg->buf, pmsg->len);
> -
> -			if (ret)
> -				return ret;
> -
> -			/* Wait until transfer is finished */
> -			if (!at91_poll_status(AT91_TWI_TXCOMP)) {
> -				dev_dbg(&adap->dev, "TXCOMP timeout\n");
> -				return -ETIMEDOUT;
> -			}
> -		}
> -		dev_dbg(&adap->dev, "transfer complete\n");
> -		pmsg++;		/* next message */
> -	}
> -	return i;
> -}
> -
> -/*
> - * Return list of supported functionality.
> - */
> -static u32 at91_func(struct i2c_adapter *adapter)
> -{
> -	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> -}
> -
> -static struct i2c_algorithm at91_algorithm =3D {
> -	.master_xfer	=3D at91_xfer,
> -	.functionality	=3D at91_func,
> -};
> -
> -/*
> - * Main initialization routine.
> - */
> -static int __devinit at91_i2c_probe(struct platform_device *pdev)
> -{
> -	struct i2c_adapter *adapter;
> -	struct resource *res;
> -	int rc;
> -
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENXIO;
> -
> -	if (!request_mem_region(res->start, resource_size(res), "at91_i2c"))
> -		return -EBUSY;
> -
> -	twi_base =3D ioremap(res->start, resource_size(res));
> -	if (!twi_base) {
> -		rc =3D -ENOMEM;
> -		goto fail0;
> -	}
> -
> -	twi_clk =3D clk_get(NULL, "twi_clk");
> -	if (IS_ERR(twi_clk)) {
> -		dev_err(&pdev->dev, "no clock defined\n");
> -		rc =3D -ENODEV;
> -		goto fail1;
> -	}
> -
> -	adapter =3D kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
> -	if (adapter =3D=3D NULL) {
> -		dev_err(&pdev->dev, "can't allocate inteface!\n");
> -		rc =3D -ENOMEM;
> -		goto fail2;
> -	}
> -	snprintf(adapter->name, sizeof(adapter->name), "AT91");
> -	adapter->algo =3D &at91_algorithm;
> -	adapter->class =3D I2C_CLASS_HWMON;
> -	adapter->dev.parent =3D &pdev->dev;
> -	/* adapter->id =3D=3D 0 ... only one TWI controller for now */
> -
> -	platform_set_drvdata(pdev, adapter);
> -
> -	clk_enable(twi_clk);		/* enable peripheral clock */
> -	at91_twi_hwinit();		/* initialize TWI controller */
> -
> -	rc =3D i2c_add_numbered_adapter(adapter);
> -	if (rc) {
> -		dev_err(&pdev->dev, "Adapter %s registration failed\n",
> -				adapter->name);
> -		goto fail3;
> -	}
> -
> -	dev_info(&pdev->dev, "AT91 i2c bus driver.\n");
> -	return 0;
> -
> -fail3:
> -	platform_set_drvdata(pdev, NULL);
> -	kfree(adapter);
> -	clk_disable(twi_clk);
> -fail2:
> -	clk_put(twi_clk);
> -fail1:
> -	iounmap(twi_base);
> -fail0:
> -	release_mem_region(res->start, resource_size(res));
> -
> -	return rc;
> -}
> -
> -static int __devexit at91_i2c_remove(struct platform_device *pdev)
> -{
> -	struct i2c_adapter *adapter =3D platform_get_drvdata(pdev);
> -	struct resource *res;
> -	int rc;
> -
> -	rc =3D i2c_del_adapter(adapter);
> -	platform_set_drvdata(pdev, NULL);
> -
> -	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	iounmap(twi_base);
> -	release_mem_region(res->start, resource_size(res));
> -
> -	clk_disable(twi_clk);		/* disable peripheral clock */
> -	clk_put(twi_clk);
> -
> -	return rc;
> -}
> -
> -#ifdef CONFIG_PM
> -
> -/* NOTE: could save a few mA by keeping clock off outside of at91_xfer..=
=2E */
> -
> -static int at91_i2c_suspend(struct platform_device *pdev, pm_message_t m=
esg)
> -{
> -	clk_disable(twi_clk);
> -	return 0;
> -}
> -
> -static int at91_i2c_resume(struct platform_device *pdev)
> -{
> -	return clk_enable(twi_clk);
> -}
> -
> -#else
> -#define at91_i2c_suspend	NULL
> -#define at91_i2c_resume		NULL
> -#endif
> -
> -/* work with "modprobe at91_i2c" from hotplugging or coldplugging */
> -MODULE_ALIAS("platform:at91_i2c");
> -
> -static struct platform_driver at91_i2c_driver =3D {
> -	.probe		=3D at91_i2c_probe,
> -	.remove		=3D __devexit_p(at91_i2c_remove),
> -	.suspend	=3D at91_i2c_suspend,
> -	.resume		=3D at91_i2c_resume,
> -	.driver		=3D {
> -		.name	=3D "at91_i2c",
> -		.owner	=3D THIS_MODULE,
> -	},
> -};
> -
> -static int __init at91_i2c_init(void)
> -{
> -	return platform_driver_register(&at91_i2c_driver);
> -}
> -
> -static void __exit at91_i2c_exit(void)
> -{
> -	platform_driver_unregister(&at91_i2c_driver);
> -}
> -
> -module_init(at91_i2c_init);
> -module_exit(at91_i2c_exit);
> -
> -MODULE_AUTHOR("Rick Bronson");
> -MODULE_DESCRIPTION("I2C (TWI) driver for Atmel AT91");
> -MODULE_LICENSE("GPL");

after this patch you could be breaking tree compilation.

--=20
balbi

--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuT6KAAoJEIaOsuA1yqRERrQP/i4TVflQwGsJTj1B+q7IeLjD
glUZQsynTo1iImFPoGJPQqRfmL6lvBwnlF5J+bx9phbq3fCMDtD6U4ijLV0F185H
XSdnlLkfDx727NJWurWQjw4mmQalCUX654IUxNU0x+Mcjd4ruYSWP9VhWTEmV41W
LWAS8Fc00H2QLz+ZI3NzmJgWK1G6R2B42j0Lq4cUPz/IA3RpCv4cWfNTjDgRPgNH
Sg0CYHGh2rEk4CO6oXDv1Yfn/kCjDigZFzjFm2UtYRNntVHzNpQnAeXhwpUJrIf6
Uz0LX0/aHZHy0prXwbpsBxrftyLc6NvAcda8ait9HIAAOpmvC1DqnrLEG0Nt/qKw
Ygs9EJzQVLUIIiiaIoRZYRm6bzmt1p9E6kyCCrR56QDDFV0moCKtWm1ikBfcrhVn
dW8skneEbc80rnM0ixcWWeXGhipXm5ynff5bTi9A8q+bWVJ4Go+jGOSWmPox7FY7
gIg+9H57YFcnTl3LFObI6RLmnWNQehGSdlLwAoK7sopuJm/ZZ/GirIGzlRRzKFGO
CoyF1PL/Ebyf8lO8wFteIcpms32H2Z60/k5cM64t+R55wYnOEf8AoZuPlcBZhMZF
fFd+q9RMIKVmg+geXQPZyGwPi22EHHy7PEZBsFMgaErPBuEebbPa4O6DWys/g2Xf
Hj6uTM/bghrdURAr9xlI
=qg3w
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
