Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab2BBVtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:49:15 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:33865 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933237Ab2BBVtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:49:14 -0500
Date: Thu, 2 Feb 2012 23:49:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: balbi@ti.com, khilman@ti.com, Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328203851-20435-1-git-send-email-tarun.kanti@ti.com>
 <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
 <20120202184106.GC29215@legolas.emea.dhcp.ti.com>
 <20120202191630.GT15343@ponder.secretlab.ca>
 <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
 <4F2AF68D.1000505@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <4F2AF68D.1000505@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 02, 2012 at 09:48:13PM +0100, Cousson, Benoit wrote:
> On 2/2/2012 8:45 PM, Felipe Balbi wrote:
> >On Thu, Feb 02, 2012 at 12:16:30PM -0700, Grant Likely wrote:
> >>On Thu, Feb 02, 2012 at 08:41:07PM +0200, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>On Thu, Feb 02, 2012 at 11:00:27PM +0530, Tarun Kanti DebBarma wrote:
> >>>>diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> >>>>index 0b05629..6ea7390 100644
> >>>>--- a/drivers/gpio/gpio-omap.c
> >>>>+++ b/drivers/gpio/gpio-omap.c
> >>>>@@ -28,7 +28,10 @@
> >>>>  #include<asm/gpio.h>
> >>>>  #include<asm/mach/irq.h>
> >>>>
> >>>>+static LIST_HEAD(omap_gpio_list);
> >>>
> >>>I guess it's now too late because patch is acked and everything, but I
> >>>think if you make the driver handle one bank alone and just instantiate
> >>>it multiple times (omap_gpio.0, omap_gpio.1, omap_gpio.3, etc) driver
> >>>would be faaaaaar simpler.
> >>
> >>Is there any shared state between the banks?  On my very cursory glance=
 it
> >>looked like banks still have some interaction between them.  If not, th=
en
> >>yes I agree that multiple instances would be better.
> >
> >A quick glance at the TRM shows that banks have separate address spaces
> >and IRQ lines. I think it's done this way because we can handoff one (or
> >more) bank to other cores on the SoC, so they need to be pretty
> >independent.
> >
> >I could be missing something though.
>=20
> In fact the driver already handled the 6 GPIOS banks as individual device=
s:
>=20
> [    0.185638] gpiochip_add: registered GPIOs 0 to 31 on device: gpio
> [    0.185882] OMAP GPIO hardware version 0.1
> [    0.186767] gpiochip_add: registered GPIOs 32 to 63 on device: gpio
> [    0.187744] gpiochip_add: registered GPIOs 64 to 95 on device: gpio
> [    0.188751] gpiochip_add: registered GPIOs 96 to 127 on device: gpio
> [    0.189819] gpiochip_add: registered GPIOs 128 to 159 on device: gpio
> [    0.190917] gpiochip_add: registered GPIOs 160 to 191 on device: gpio

yeah, but you can get all of that for free from driver core. Just add
one platform_device for each bank and make the omap-gpio.c only
understand one bank. No tricks.

What I'm trying to say is to remove the Bank array or list_head and make
probe() get called 6 times by creating 6 omap_gpio platform_devices.

=46rom probe you cann gpiochip_add() once and only once.

> That list is only used to iterate over all the instances during CPU idle:
>=20
> void omap2_gpio_prepare_for_idle(int pwr_mode)
> {
> 	struct gpio_bank *bank;
>=20
> 	list_for_each_entry(bank, &omap_gpio_list, node) {
> 		if (!bank->mod_usage || !bank->loses_context)
> 			continue;
>=20
> 		bank->power_mode =3D pwr_mode;
>=20
> 		pm_runtime_put_sync_suspend(bank->dev);
> 	}
> }
>=20
> void omap2_gpio_resume_after_idle(void)
> {
> 	struct gpio_bank *bank;
>=20
> 	list_for_each_entry(bank, &omap_gpio_list, node) {
> 		if (!bank->mod_usage || !bank->loses_context)
> 			continue;
>=20
> 		pm_runtime_get_sync(bank->dev);
> 	}
> }

that's the thing which is unnecessary, actually :-)

Why do we even have this omap2_gpio_resume_after_idle() ? Can't the gpio
driver handle its own PM or listen to cpuidle notificaitons for that ?

I would like to understand why do we need this hack for pm runtime.
Can't you just use ->prepare() and ->complete() from dev_pm_ops ?

> I don't know if there is some reason to not use driver_for_each_device.

driver_for_each_device() is already handled by driver core. So your
omap_device_build() would have a loop creating N omap_devices, one for
each gpio bank. Each bank would receive one IRQ line and one address
base. And they would only understand that. Every instance of the driver
handles the GPIOs connected on one bank.

--=20
balbi

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBAgAGBQJPKwTTAAoJEIaOsuA1yqREFXkP+NGFy9Y1M3SygI2Uzd+hSvkZ
c8fo83VxwYTZ1PIVV2/PtiB3IsZIYgxmhbW95Om2ZKCHouBeqEIiIqRg1LJim3I/
2/7IE0YyIKv7OsIg62rLaJcefuEVJcbhB7A9O06jck/ZCraMljn7ph4c+NFPR7fj
f6Cl/Z2yYFf3YD1842YG1fQkT5uXk2EOO8U4PDQ/3OYrNzHq0hDshNc/I52SJjVx
gdiz0Z/srhywNGssVMtF615GmjllH9sBHDtboWdsP8uJhKbm3RNi6DVIwvTSrcRO
UpM6RtPeJanwRaTjUzMd79U9gX8EkH1XS4X32XHt10UACY1SyJuMZfXV6Vgb2mnT
CNTdTecAUVOg8NZ6em3FBIrId44zN4A2dKtSU0Z42jy+y++a42ssWSys/Yt0+Wun
bfrP4+VTBPaGb8VjGe5bUTz8ety8WOBIL71PRcrYQNHGGvlhkCeREPs94emEI9Qb
nyvqh83KcRerb4IEgYp/8n0iB3ZRlEnCTsMRz7hwW0ZiCYiz+sjNu3zBLLLxTAKO
6DQA+613fuSh9vzuSL2zQkMPXK7Pys8mKosu+vQ1hucARO39pHTPBQXrummLLjLg
wIg93PuwBNnbgRer8HBpyTxRZITPoiJgvFe3j6PB/tRWkv+SJX+BbX8xCuz5/GHG
ml8Nx7AjzWydz+v4Spc=
=Zeb1
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
