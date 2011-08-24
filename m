Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1HXXEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:04:24 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:39138 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab1HXXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:04:23 -0400
Date: Thu, 25 Aug 2011 02:04:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110824230418.GA19890@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1108241114270.2010-100000@iolanthe.rowland.org>
 <op.v0p439txvgw7ix@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <op.v0p439txvgw7ix@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 24, 2011 at 05:25:11PM +0200, Michal Nazarewicz wrote:
> On Wed, 24 Aug 2011 17:15:29 +0200, Alan Stern
> <stern@rowland.harvard.edu> wrote:
>=20
> >On Wed, 24 Aug 2011, Michal Nazarewicz wrote:
> >
> >>I've found where my reasoning was faulty.  The usb_gadget_driver's
> >>max_speed is set before all the functions get added so composite.c has
> >>no way to figure those things in advance.  That's why we need to relay
> >>on usb_composite_driver's max_speed be set to a proper value.
> >
> >This is what Felipe was complaining about earlier.  We shouldn't set
> >max_speed or allow the UDC to connect to the host until all the
> >functions have been added.
>=20
> We're not doing the latter.  The functions are added in bind callback so
> (hopefully) UDC will first run the bind callback and then try connecting
> to host.
>=20
> And the former would be fixed if we allowed gadget driver to set max_speed
> in bind callback rather then prior to calling usb_gadget_probe_driver().

there's one catch. As of today, we always start UDCs with data pullups
connected, which means that we could connect to a host even before a
gadget driver is loaded. My point in moving to udc_start/udc_stop is
that the above would be take care of. See udc-core.c:

int usb_gadget_probe_driver(struct usb_gadget_driver *driver,
		int (*bind)(struct usb_gadget *))
{
	....

	if (udc_is_newstyle(udc)) {
		ret =3D bind(udc->gadget);
		if (ret)
			goto err1;
		ret =3D usb_gadget_udc_start(udc->gadget, driver);
		if (ret) {
			driver->unbind(udc->gadget);
			goto err1;
		}
		usb_gadget_connect(udc->gadget);
	} else {
		ret =3D usb_gadget_start(udc->gadget, driver, bind);
		if (ret)
			goto err1;

	}

	...
}

If all UDCs are converted to udc_start()/udc_stop() we get the guarantee
that they will only conect to host after gadget driver is fully loaded
for free. We can also, finally, properly use the
usb_function_deactivate/usb_function_activate properly. So for each
registered function, composite.c calls usb_function_deactivate() and
function is _required_ to call usb_function_activate when it's ready
(for f_obex.c that would be when userland OBEX stack has opened
/dev/ttyGS*, for g_mass_storage that would be on function bind(), and so
on).

Then, when on gadget driver's bind() we can take this kind of spee
decision and pass that on to UDC driver.

--=20
balbi

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVYNyAAoJEAv8Txj19kN1glMH/3a+MJJlAaCIjx8ajt2+aWC8
PRzvVH7byAC55I5tk5YwWK5DNE3BfVnFm5nDXlw9oCZFjxj3K9qqjsKm8gWJp55k
tgJCrdvExjNqmlRuVxcoAuEXOOwrFMXj36nR4dEgvAmEWU/B453Wcm1yx2tjhg4e
fFyKo/X245+Sw+lktUaBNWIGaVAKnT7R54TYjQFBKRW82pyqlkRmxoIAbWN01JOj
dWpbbHUvVFJm9SMR3+1CJrZSPhpI9jd/3AhP7H6mClZ/RRWjjZVV9fG/Q/3mQ6cs
BaXoUfqI8JFDXzIO8I6N9rX33MBgJsiWMv4FmVqh+e+NUl64T15ie1s0wYDI2V4=
=Rpx4
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
