Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab2BBJJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:09:36 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:44450 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab2BBJJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:09:32 -0500
Date: Thu, 2 Feb 2012 11:09:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Message-ID: <20120202090923.GC9948@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
 <4F22CC37.8010307@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D2B9D@DBDE01.ent.ti.com>
 <4F27D011.8060203@mvista.com>
 <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VUDLurXRWRKrGuMn"
Content-Disposition: inline
In-Reply-To: <47CEF8C4B26E8C44B22B028A650E0EA9317D9346@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VUDLurXRWRKrGuMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2012 at 04:57:16AM +0000, Gupta, Ajay Kumar wrote:
> Hi,
> > On 31-01-2012 8:41, Gupta, Ajay Kumar wrote:
> >=20
> > >>> As a next step to dma-engine based cppi4.1 driver implementation
> > >>> this RFC has the overview of changes in the musb driver.
> > >>> RFC on CPPI slave driver changes will follow next.
> >=20
> > >>> Overview of changes in the musb driver
> > >>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > >>> 1)Add a dma-engine.c file in the drivers/usb/musb folder
> > >>> 2)This file will host the current musb dma APIs and translates them
> > to
> > >>>     dmaengine APIs.
> > >>> 3)This will help to keep the changes in drivers/usb/musb/musb* files
> > >>>     minimal and also to retain compatibility other DMA (Mentor etc.)
> > >>>     drivers which are yet to be moved to drivers/dma
> > >>> 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to
> > >>>     make existing musb APIs compatible.
> > >>> 5)drivers/usb/musb/dma-engine.c file will implement the filter
> > >>>     functions and also implement .dma_controller_create (allocates
> > >>>     &   provides "dma_controller" object) and .dma_controller_delete
> > >>> 6)CPPI4.1 DMA specific queue and buffer management will be internal
> > >>>     to slave CPPI DMA driver implementation.
> >=20
> > >>      You mean drivers/dma/ driver?
> >=20
> > > yes.
> >=20
> > >> I think you are forgotting that CPPI 4.1 MUSB
> > >> has some registers controlling DMA/interrupts beside those of CPPI
> > 4.1
> > >> controller and MUSB core itself. How do they fit in your scheme?
> >=20
> > > We have been discussing on how to handle these in slave driver and
> >=20
> >     These certainly cannot be handled in the slave driver because the
> > registers are different for every controller implementation and, the
> > main thing, they don't belong to CPPI 4.1 as such.
>=20
> Felipe suggested to use device tree for differences in register maps
> among different platforms.
>=20
> I do see issues in reading wrapper interrupt status register and then
> calling musb_interrupt() [defined inside musb_core.c] from slave driver.

I have been thinking about that lately. In the end of the day, I want to
remove direct dependencies between musb_core and glue. So what I was
thinking about goes like so:

Glue layer basically has to prepare musb->int_usb, musb->int_tx and
musb->int_rx for musb. Maybe handle some glue specific stuff and so on,
but the IRQ line still belongs to MUSB.

So the idea would be to add something like:

musb_platform_read_intrusb()
musb_platform_read_intrtx()
musb_platform_read_intrrx()

those would default to basic:

musb_readb(musb->mregs, MUSB_INTRUSB);
musb_readw(musb->mregs, MUSB_INTRTX);
musb_readw(musb->mregs, MUSB_INTRRX);

if platform ops aren't passed. So, it would look something like:

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 72a424d..ba0bcc2 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1488,9 +1488,9 @@ static irqreturn_t generic_interrupt(int irq, void *_=
_hci)
=20
 	spin_lock_irqsave(&musb->lock, flags);
=20
-	musb->int_usb =3D musb_readb(musb->mregs, MUSB_INTRUSB);
-	musb->int_tx =3D musb_readw(musb->mregs, MUSB_INTRTX);
-	musb->int_rx =3D musb_readw(musb->mregs, MUSB_INTRRX);
+	musb->int_usb =3D musb_platform_read_intusb(musb->controller);
+	musb->int_tx =3D musb_platform_read_inttx(musb->controller);
+	musb->int_rx =3D musb_platform_read_intrx(musb->controller);
=20
 	if (musb->int_usb || musb->int_tx || musb->int_rx)
 		retval =3D musb_interrupt(musb);

those would make sure to prepare the cached IRQ status registers for
MUSB core.

Keep in mind that this is only necessary because on
DaVinci/OMAP-L13x/AM35x devices you guys have decided to make the
wrapper read the IRQ status register from MUSB address space. And
because those are clear-on-read, we're screwed.

Oh well, this is the best I could come up with. Any problems you guys
see ?

--=20
balbi

--VUDLurXRWRKrGuMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKlLDAAoJEIaOsuA1yqRE2xEP/1vkSkpDbDnHKrFZe5j8Fdh/
7gMqNCnG4tg0ryHyO2oMeTHioGT4pO2HLMqaTi9OugAQeTdf9gGrntoNl4tXVMLH
Os3RQpFd8v/T2DOOPpdLo90SkV6G4xAjvo0gH/HMe/BI9VPCBvTHDthpXTAtAyeO
KzVCPIe3aww3uHfMlU4QF1/Dtph/V8glt+8Vqzxt4QBrw1rbgaRmS/se+8XKHtak
RsocOvwumKTbuEZYy9cl7Wv+dOzn5WM9Tiq2XMp84nqZs54A60TLWxedtML6dzhv
uAgxD10K1SKUw2BbsURKYWczTtrpyeI+KRDNAISbDfoRDxnEPKTCw1bEBZw+NPjR
DphN6trXiMu8b9180f4gfXc2MeNJUWAUJKXs3UBz5miwJhGSLg8D6HCRpbSN9CpR
0CFg99M4bnQDv12Ii+BWkkKhkQlDgnCRKhJ/SFPuhT0qz0CqQd20XK5uva0gZHYU
H/eVXhreDNPz6nM3ngKVYwrZEjWK5HlQPbpzYSOMzx3/1DrDpFRxTW0ZCuFTuwKV
2VgZtcqbyJzpRKfQGs16TanQH9d5xVd3K5U9vIGeVJBTJch/+1bf9vWRKhD0MZnu
puEsE09zbcBikK1UwQnphOH/KH9i74FozHahwUMzbE2Js2lggc9hKYx7ySKu8ppY
V7AoSObI2Oqh9DoVsH69
=2uIR
-----END PGP SIGNATURE-----

--VUDLurXRWRKrGuMn--
