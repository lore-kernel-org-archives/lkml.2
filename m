Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2BBVx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:53:59 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:41427 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab2BBVx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:53:57 -0500
Date: Thu, 2 Feb 2012 23:53:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>, khilman@ti.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
 <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
 <20120202184106.GC29215@legolas.emea.dhcp.ti.com>
 <20120202191630.GT15343@ponder.secretlab.ca>
 <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
 <4F2AF68D.1000505@ti.com>
 <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again,

On Thu, Feb 02, 2012 at 11:49:08PM +0200, Felipe Balbi wrote:
> > In fact the driver already handled the 6 GPIOS banks as individual devi=
ces:
> >=20
> > [    0.185638] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
> > [    0.185882] OMAP GPIO hardware version 0.1
> > [    0.186767] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
> > [    0.187744] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
> > [    0.188751] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
> > [    0.189819] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
> > [    0.190917] gpiochip_add: registered GPIOs 160 to 191 on device: gpio
>=20
> yeah, but you can get all of that for free from driver core. Just add
> one platform_device for each bank and make the omap-gpio.c only
> understand one bank. No tricks.
>=20
> What I'm trying to say is to remove the Bank array or list_head and make
> probe() get called 6 times by creating 6 omap_gpio platform_devices.
>=20
> From probe you cann gpiochip_add() once and only once.
		 ^^^^
		 call

I actually just took the time to go over the driver and that's what it
does. So the list_head is only there fo the nasty cpuidle stuff below:

> > That list is only used to iterate over all the instances during CPU idl=
e:
> >=20
> > void omap2_gpio_prepare_for_idle(int pwr_mode)
> > {
> > 	struct gpio_bank *bank;
> >=20
> > 	list_for_each_entry(bank, &omap_gpio_list, node) {
> > 		if (!bank->mod_usage || !bank->loses_context)
> > 			continue;
> >=20
> > 		bank->power_mode =3D pwr_mode;
> >=20
> > 		pm_runtime_put_sync_suspend(bank->dev);
> > 	}
> > }
> >=20
> > void omap2_gpio_resume_after_idle(void)
> > {
> > 	struct gpio_bank *bank;
> >=20
> > 	list_for_each_entry(bank, &omap_gpio_list, node) {
> > 		if (!bank->mod_usage || !bank->loses_context)
> > 			continue;
> >=20
> > 		pm_runtime_get_sync(bank->dev);
> > 	}
> > }
>=20
> that's the thing which is unnecessary, actually :-)
>=20
> Why do we even have this omap2_gpio_resume_after_idle() ? Can't the gpio
> driver handle its own PM or listen to cpuidle notificaitons for that ?
>=20
> I would like to understand why do we need this hack for pm runtime.
> Can't you just use ->prepare() and ->complete() from dev_pm_ops ?

This question remains. Why do we need those funtions ?

--=20
balbi

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKwXuAAoJEIaOsuA1yqREVE4P/3Tot/M5xwIL7eErr3XNhaG+
60g/tvRatnwsUc0zO1cmHc1370UM5FAgzS8XCpdyVk/nPCr0cZ801dznT63RDxNk
nf1Oe1ti2ANsJoltLO7WBb3mBaOWIItZdG+JPBvvkpEx5TytiYFLJ3gALHVP7Ml1
IVokZd1rRZgu3wY1jZckW+to429TO/gIJoJjD0n7r9mfmgAtdb/VXa38y/FjQBOA
VjD0CqRz75h/3n7st7oSKf7XDAoIO0LDhYFqQTAFo5E3We97HUjYi6RAMg7BpkPf
T9w9bpbnqUvbJUi0OZd+n8mvI87ByOO2sr7D2VCBnZ723/oT0/q+yYPerXOaGRd7
S9+LMSdyTPI2/JCxXF0SBEsLHUlar+C2VaGYjpbhV6qWudxbrL7r9Cc+u4KwhLuO
7KiwcpPUPkgKKrYXTFTy88nCB2iNamgXYaHKZP5DPVzRNsmYSzPlrUMmzV1+jjGo
069dbvhuA+Uu6yNLRH6OS6g5lLTt5ChRa6hvDQ6xM6Y6wWz17T9keve+h21iH2c+
Igd0Cr54O+9YjMWgMMWsntqw7X3CcDcBPdKqIIAHZB1AUKvoJUW4TdGoC0LZ8nqG
6PR4ojZPe8eRhbAe5wwB5Bt0rWc6cmj/VInO0BVJlv6nQiw9668JGkBVLYZ/KHXU
UooVZBsEi8iLyekNPsmO
=nTGB
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
