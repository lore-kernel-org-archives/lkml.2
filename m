Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1KHSG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:06:57 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:36578 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822Ab1KHSG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:06:56 -0500
Date: Tue, 8 Nov 2011 20:06:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "'balbi@ti.com'" <balbi@ti.com>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'khali@linux-fr.org'" <khali@linux-fr.org>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'rmallon@gmail.com'" <rmallon@gmail.com>
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111108180648.GA24399@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320753142.git.n.voss@weinmann.de>
 <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
 <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B899@wm021.weinmann.com>
 <20111108154004.GK20728@legolas.emea.dhcp.ti.com>
 <EF2E73589CA71846A15D0B2CDF79505D087B38B8B5@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D087B38B8B5@wm021.weinmann.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 08, 2011 at 04:49:07PM +0100, Voss, Nikolaus wrote:
> > > > > +#include <mach/at91_twi.h>
> > > > > +#include <mach/board.h>
> > > > > +#include <mach/cpu.h>
> > > >
> > > > avoid including <mach/*> on drivers.
> > >
> > > Should I move at91_twi.h to include/linux (omap does it like this,
> > > other use the mach-include)?
> >=20
> > maybe, is at91_twi.h some sort of platform_data ? there's
> > <linux/platform_data/...> for that.
>=20
> It contains hardware register definitions, not really platform data.
> So linux/i2c-at91.h (like linux/i2c-{omap,pxe,...}) would be the right pl=
ace?

if it's only register definitions, does it need to be in a header ? I
mean, is anyone outside of this driver trying to access those registers?
Otherwise they could sit on the C source file itself.

If there's anyone else which needs those register definitions then
<linux/i2c/at91.h> seems like a good place (??)

> > > > > +	if (irqstatus & AT91_TWI_TXCOMP) {
> > > > > +		at91_disable_twi_interrupts(dev);
> > > > > +		dev->transfer_status =3D status;
> > > > > +		complete(&dev->cmd_complete);
> > > > > +	}
> > > > > +	else if (irqstatus & AT91_TWI_RXRDY) {
> > > > > +		at91_twi_read_next_byte(dev);
> > > > > +	}
> > > > > +	else if (irqstatus & AT91_TWI_TXRDY) {
> > > > > +		at91_twi_write_next_byte(dev);
> > > > > +	}
> > > > > +	else {
> > > > > +		return IRQ_NONE;
> > > >
> > > > coding style is wrong. Also, are those IRQ events really mutually
> > exclusive ??
> > >
> > > These are indeed mutually exclusive (semantically).
> >=20
> > so you couldn't have AT91_TWI_TXCOMP and AT91_TWI_RXRDY set when you re=
ad
> > irqstatus ?
>=20
> Yes, I do have this, but in this constellation only TXCOMP is relevant and
> all other flags can be ignored (because the transfer is finished).

I asked about different directions exactly because of that. My question
was if you could have a TX Complete and RX Ready IRQs simultaneously.

The way you coded this IRQ handler is like a priority encoder, meaning
that you will ignore all other bits once you find the first set bit. I'm
wondering if you shouldn't drop the "else" as most of the IRQ handlers
do.

But it's your driver anyway, I don't know how this controller behaves.
Just found it a bit worrying that you ignore all other IRQ status bits.

--=20
balbi

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuW+4AAoJEIaOsuA1yqREBFgQAKItf/wJh0feu2b+79svlCM1
Uz3i2rleJEBbBGR4gRLDfPO0RkqTPfnyfXDMdurFdQhHak93SOwJ6qhNUbKu1cb/
iS/zeFgNuuRQfCgaNJeyEYfRpupF17ExKJSlP9mJlrN0cZO0DeIlTRfbynE2Y3rr
bPXmLpFudZKgAj179XUxE40//ANk8RjuQZoRaPVa5KtuzYuwPTPeHJEVn8RfB9/f
bJpVj4hj5UCp5D2R80cGUMnuvZlKBY5LiXwY6ksRG5iQr8cjP/s9Q9A2ddeZbyg6
Zcp/f3soI+YCB21sO/StA2r0qvy1CA0CWoGPAPzyXjmv6F5tGkhaW0b543uatgwT
n9Pw2ke+jVyCo4nehLvPbLRmvq+H5HkK20tEKZtQAgHCVeGmHbzNydCFtYCRm4Rf
g52hajS51N/7dAhP90ElzZEIoNas82hz04iOEDrwurzzVW2/a6EvG3vddHjDq15b
/1SH+UDOnN2uxY+8d34zg3MKd11hG3iRgumOSwyZto68jwtOVcQ/ZcJGHKoRZ12A
UudP38ptMfeTCGB7ZIS28ni/YuXvATfFhW8W/KklLP46uBbsIo+d3qMNnDTsNguc
2V0+FIu1p7lx3L7jMOpZyjKkKLC9yD7NXBlHpKvx9fMe7zA19DWSj1oieEBoQHo5
xwDG4/3Ih/nqATQs6v66
=m5vv
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
