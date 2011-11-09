Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab1KIT7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:59:36 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:55885 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031Ab1KIT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:59:35 -0500
Date: Wed, 9 Nov 2011 21:59:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org, khali@linux-fr.org,
        nicolas.ferre@atmel.com, rmallon@gmail.com, balbi@ti.com
Subject: Re: [PATCH v4 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111109195925.GB17406@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320853921.git.n.voss@weinmann.de>
 <fc7ccca66f0ffea1aa9c0409162b4a66974c46b3.1320853921.git.n.voss@weinmann.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <fc7ccca66f0ffea1aa9c0409162b4a66974c46b3.1320853921.git.n.voss@weinmann.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 08, 2011 at 11:49:46AM +0100, Nikolaus Voss wrote:
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index e8a1852..fba6da6 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -28,6 +28,7 @@ obj-$(CONFIG_I2C_HYDRA)		+=3D i2c-hydra.o
>  obj-$(CONFIG_I2C_POWERMAC)	+=3D i2c-powermac.o
> =20
>  # Embedded system I2C/SMBus host controller drivers
> +obj-$(CONFIG_I2C_AT91)		+=3D i2c-at91.o
>  obj-$(CONFIG_I2C_AU1550)	+=3D i2c-au1550.o
>  obj-$(CONFIG_I2C_BLACKFIN_TWI)	+=3D i2c-bfin-twi.o
>  obj-$(CONFIG_I2C_CPM)		+=3D i2c-cpm.o
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> new file mode 100644
> index 0000000..5f4be34
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -0,0 +1,417 @@
> +/*
> +    i2c Support for Atmel's AT91 Two-Wire Interface (TWI)
> +
> +    Copyright (C) 2011 Nikolaus Voss <n.voss@weinmann.de>
> +
> +    Evolved from original work by:
> +    Copyright (C) 2004 Rick Bronson
> +    Converted to 2.6 by Andrew Victor <andrew@sanpeople.com>
> +
> +    Borrowed heavily from original work by:
> +    Copyright (C) 2000 Philip Edelbrock <phil@stimpy.netroedge.com>
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +*/

wrong multi-line comment style.

> +static void at91_set_twi_clock(struct at91_twi_dev *dev)

this should be __devinit as it's only used by at91_twi_hwinit()

> +{
> +	unsigned long cdiv, ckdiv;
> +
> +	/* Calcuate clock dividers and round up */

typo: calculate.

> +	cdiv =3D (clk_get_rate(dev->clk) / (2 * TWI_CLOCK_HZ)) - 3 + 1;

DIV_ROUND_UP() ??

> +	ckdiv =3D 0;
> +	while (cdiv > 255) {
> +		ckdiv++;
> +		cdiv =3D cdiv >> 1;
> +	}
> +
> +	if (cpu_is_at91rm9200() && (ckdiv > 5)) {
> +		dev_err(dev->dev, "AT91RM9200 Erratum #22: using ckdiv =3D 5.\n");

is it really an error ? Or would it be enough as dev_dbg() ?

> +static int at91_do_twi_transfer(struct at91_twi_dev *dev, bool is_read)
> +{
> +	int ret;
> +
> +	INIT_COMPLETION(dev->cmd_complete);
> +	if (is_read) {
> +		if (!dev->buf_len)
> +			at91_twi_write(dev, AT91_TWI_CR,
> +				       AT91_TWI_START | AT91_TWI_STOP);
> +		else
> +			at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_START);
> +		at91_twi_write(dev, AT91_TWI_IER,
> +			       AT91_TWI_TXCOMP | AT91_TWI_RXRDY);
> +	} else {
> +		at91_twi_write_next_byte(dev);
> +		at91_twi_write(dev, AT91_TWI_IER,
> +			       AT91_TWI_TXCOMP | AT91_TWI_TXRDY);
> +	}
> +
> +	ret =3D wait_for_completion_interruptible_timeout(&dev->cmd_complete,
> +							dev->adapter.timeout);
> +	if (ret =3D=3D 0) {
> +		dev_err(dev->dev, "controller timed out\n");
> +		at91_init_twi_bus(dev);
> +		return -ETIMEDOUT;
> +	}
> +	if (dev->transfer_status & AT91_TWI_NACK) {
> +		dev_dbg(dev->dev, "received nack\n");
> +		return -ENODEV;

not sure error code matches here. If the HW replies with NACK you tell
your users there's no I2C adapter ? Sounds a bit weird to me...

> +static int __devinit at91_twi_probe(struct platform_device *pdev)
> +{
> +	struct at91_twi_dev *dev;
> +	struct resource *mem, *irq, *ioarea;
> +	int rc;
> +
> +	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!mem)
> +		return -ENODEV;
> +
> +	irq =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);

int irq =3D platform_get_irq(pdev, 0), would work better for you. In case
of error it will return -ENXIO

> +	if (!irq)
> +		return -ENODEV;
> +
> +	ioarea =3D request_mem_region(mem->start, resource_size(mem), pdev->nam=
e);
> +	if (!ioarea)
> +		return -EBUSY;
> +
> +	dev =3D kzalloc(sizeof(struct at91_twi_dev), GFP_KERNEL);

sizeof(*dev) would allow you to change the type of dev without having to
patch this line. Quite unlikely, I know, but still...

--=20
balbi

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOutudAAoJEIaOsuA1yqRElRkP/0/P5IouYTJHFsvKA+Dp0FIi
l/zrhYYuYHx4DTNvgP0qrgDPQH6Is5P19+UjSP4T+my5k3BDYeJOYJPidelJRpIH
kDUxheTFKPZUUOtMnOi4mAcP9YWzqLOqO5isna+dJzmm9f/elRwf82zy/ORJJcHA
4HzP6aKaF7LwV+vjklT5yzUmE7S1uu0HnOtMm4birfDG2T3kT0HE6kqev98pmWm0
09/4ZQxPxIP2yM/JxaiGO2qQiwgV1QkaCEEbkIh1O29szLn18fUs3b5hDxQzG5Po
akwxN/8vM7btB0Op9L7JPJHklH3fK0ylQnUcldHLv405Z8vDgzZyiJk0uBogwYfj
Kx3CljRzTrkGNPFoEf+xcMhSVmuDnVK3RnyCBrEZBXznt8swcKLKSBqEe3hgoxRW
mGxnCsy4pnVGE39lC2InrdxEiJLAidIJ/dDvw6vYZfjKlgylIGtOrkNyrthTZFoP
n6KqroQJuwgp57PWTt4409DOIZzRCABSa6rHumJuT0xNBcOH/MKycoriflsgTLZU
RqJwpfdNgcygPY8QobdKRkQ3fdHeYuVS9J+0oyzJInwLUkGQvslA+En87Tjcetm8
xVjsZDhP7EY5orzwAUr55LGNUzRCb1L4c6wpZfOS122Ir9dcPo3cM5CmV6/TU9Ti
R9XVe3i0sBb8UPGstflF
=DrI8
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
