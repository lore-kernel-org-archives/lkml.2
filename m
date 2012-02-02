Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab2BBLtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 06:49:21 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59125 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755509Ab2BBLtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 06:49:20 -0500
Date: Thu, 2 Feb 2012 13:49:12 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: balbi@ti.com, "Gupta, Ajay Kumar" <ajay.gupta@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Message-ID: <20120202114911.GH29134@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
 <4F22CC37.8010307@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D2B9D@DBDE01.ent.ti.com>
 <4F27D011.8060203@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
 <20120202090923.GC9948@legolas.emea.dhcp.ti.com>
 <4F2A6FAC.8010906@mvista.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xzXx3ruJf7hsAzo"
Content-Disposition: inline
In-Reply-To: <4F2A6FAC.8010906@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2xzXx3ruJf7hsAzo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2012 at 03:12:44PM +0400, Sergei Shtylyov wrote:
> Hello.
>=20
> On 02-02-2012 13:09, Felipe Balbi wrote:
>=20
> >>>>>>As a next step to dma-engine based cppi4.1 driver implementation
> >>>>>>this RFC has the overview of changes in the musb driver.
> >>>>>>RFC on CPPI slave driver changes will follow next.
> >>>
> >>>>>>Overview of changes in the musb driver
> >>>>>>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> >>>>>>1)Add a dma-engine.c file in the drivers/usb/musb folder
> >>>>>>2)This file will host the current musb dma APIs and translates them=
 to
> >>>>>>     dmaengine APIs.
> >>>>>>3)This will help to keep the changes in drivers/usb/musb/musb* files
> >>>>>>     minimal and also to retain compatibility other DMA (Mentor etc=
=2E)
> >>>>>>     drivers which are yet to be moved to drivers/dma
> >>>>>>4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
> >>>>>>     make existing musb APIs compatible.
> >>>>>>5)drivers/usb/musb/dma-engine.c file will implement the filter
> >>>>>>     functions and also implement .dma_controller_create (allocates
> >>>>>>     &    provides "dma_controller" object) and .dma_controller_del=
ete
> >>>>>>6)CPPI4.1 DMA specific queue and buffer management will be internal
> >>>>>>     to slave CPPI DMA driver implementation.
>=20
> >>>>>      You mean drivers/dma/ driver?
>=20
> >>>>yes.
>=20
> >>>>>I think you are forgotting that CPPI 4.1 MUSB
> >>>>>has some registers controlling DMA/interrupts beside those of CPPI 4=
=2E1
> >>>>>controller and MUSB core itself. How do they fit in your scheme?
>=20
> >>>>We have been discussing on how to handle these in slave driver and
>=20
> >>>     These certainly cannot be handled in the slave driver because the
> >>>registers are different for every controller implementation and, the
> >>>main thing, they don't belong to CPPI 4.1 as such.
>=20
> >>Felipe suggested to use device tree for differences in register maps
> >>among different platforms.
>=20
> >>I do see issues in reading wrapper interrupt status register and then
> >>calling musb_interrupt() [defined inside musb_core.c] from slave driver.
>=20
> >I have been thinking about that lately. In the end of the day, I want to
> >remove direct dependencies between musb_core and glue. So what I was
> >thinking about goes like so:
>=20
> >Glue layer basically has to prepare musb->int_usb, musb->int_tx and
> >musb->int_rx for musb. Maybe handle some glue specific stuff and so on,
> >but the IRQ line still belongs to MUSB.
>=20
> >So the idea would be to add something like:
>=20
> >musb_platform_read_intrusb()
> >musb_platform_read_intrtx()
> >musb_platform_read_intrrx()
>=20
> >those would default to basic:
>=20
> >musb_readb(musb->mregs, MUSB_INTRUSB);
> >musb_readw(musb->mregs, MUSB_INTRTX);
> >musb_readw(musb->mregs, MUSB_INTRRX);
>=20
> >if platform ops aren't passed. So, it would look something like:
>=20
> >diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> >index 72a424d..ba0bcc2 100644
> >--- a/drivers/usb/musb/musb_core.c
> >+++ b/drivers/usb/musb/musb_core.c
> >@@ -1488,9 +1488,9 @@ static irqreturn_t generic_interrupt(int irq, void=
 *__hci)
> >
> >  	spin_lock_irqsave(&musb->lock, flags);
> >
> >-	musb->int_usb =3D musb_readb(musb->mregs, MUSB_INTRUSB);
> >-	musb->int_tx =3D musb_readw(musb->mregs, MUSB_INTRTX);
> >-	musb->int_rx =3D musb_readw(musb->mregs, MUSB_INTRRX);
> >+	musb->int_usb =3D musb_platform_read_intusb(musb->controller);
> >+	musb->int_tx =3D musb_platform_read_inttx(musb->controller);
> >+	musb->int_rx =3D musb_platform_read_intrx(musb->controller);
> >
> >  	if (musb->int_usb || musb->int_tx || musb->int_rx)
> >  		retval =3D musb_interrupt(musb);
> >
> >those would make sure to prepare the cached IRQ status registers for
> >MUSB core.
> >
> >Keep in mind that this is only necessary because on
> >DaVinci/OMAP-L13x/AM35x devices you guys have decided to make the
> >wrapper read the IRQ status register from MUSB address space. And
> >because those are clear-on-read, we're screwed.
>=20
> >Oh well, this is the best I could come up with. Any problems you guys
> >see ?
>=20
>    On DaVinci/OMAP-L1x these 3 calls need to extract data from a
> single 32-bit register, so that doesn't seem a good idea to me. The

that's a problem on DaVinci/OMAP-L1x.

> current scheme seems OK to me. Or either implement a signle function
> to read all 3 interrupt masks...
>=20
> musb_platform_read_ints()

I wanted to avoid glue layer having to access the musb pointer directly.
If I implement musb_platform_read_ints() I will have to pass musb as
argument, or agree on another way to return the values. Thanks, but no
thanks.

I want to remove direct access of musb from glue layer, and at some
point I will have to do it in order to fix a few problems we might still
have with modules, basically because glue layer could be trying to
access memory which was freed already.

--=20
balbi

--2xzXx3ruJf7hsAzo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKng3AAoJEIaOsuA1yqREvB0QAKazyBwVA/kAdtoRcokWQ/Sg
weCufONT6G7VL2ezjCQGcQ18VYa1XK4nAq3pMUA8PVsT0rBPqcFn0FqyssgExnYY
e265OuUhDsCcBF2CfeGIgahJxs5iEyTqHIE/DdZ6GMY3Fa7oVioD36uNZaPGEIAP
qWvD2e4yyjZYPP/dWeOiO7Emy4jXPcMbSMMqARi/DwelBZ4H2Qp2yYKrbwsivWM5
6lUyi6LojXtkHXKZQm2uXUbLSISPSU1QtQW6iFqVm2zkaOVCBUu5KRsOHLaGMxYD
2yLvAmRTCTCiNPpV8/WMMOirTVO4OOcJwgcNH1Zp+oOP8sUtRYmK+a11DebZnKmb
K7rMbBmzUOn2YhAqcIBFV0J+AR+zM4sYFPqA+dAb6EIAUFuNF9IxtXZ2poUrc3rH
sV4YeJCHE/d2eOzY6zGb2R7edAdcUWOn890pI1VpSzCBh7zssYGKeYJ0WNvYokUl
riHSz4sbHj9qynnnA7J2FrwBDNMlt5sFxj1K1HZ8QHzcD5pxTZxkcpYvbIgnXt1w
vEtTxBiO5P+6JRLdYJvWeBpiBaFGk1SR0O6oWcJ5Qo+gOsEWjQ7Wj9VCXJBgEdWn
NlZbvibcPTPMY2an4xO7dlCf4PHgkoCOG0NVCa2fPg+iDmurxUULIXIj3nZXidaX
/NqE1Dk4FIskgY5YT4dU
=5yJv
-----END PGP SIGNATURE-----

--2xzXx3ruJf7hsAzo--
