Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1JXHuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:50:05 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:39696 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439Ab1JXHuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:50:03 -0400
Date: Mon, 24 Oct 2011 10:49:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: DeviceTree and children devices
Message-ID: <20111024074957.GB15288@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111024064227.GW5453@legolas.emea.dhcp.ti.com>
 <20111024074124.GB8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <20111024074124.GB8708@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2011 at 09:41:24AM +0200, Grant Likely wrote:
> On Mon, Oct 24, 2011 at 09:42:28AM +0300, Felipe Balbi wrote:
> > Hi Grant,
> >=20
> > I have a question about how DeviceTree should be written in case a
> > device has a child device.
> >=20
> > The way things are integrated on OMAP is that we will always have a
> > parent device which is a wrapper around an IP core in order to
> > integrate with the OMAP context (clocks, power management, etc).
> >=20
> > That wrapper has its own address space and its own IRQ number
> > (generally). On my dwc3 driver I have modeled the OMAP wrapper as a
> > parent device which allocates a child device for the core IP driver.
> > This makes it a lot easier to re-use the core IP driver on other SoCs or
> > PCI (there's a glue layer for PCI too).
> >=20
> > So I wonder if we should describe that on DeviceTree and not have the
> > OMAP glue layer allocate the core IP driver. Just to illustrate, here's
> > what we have:
> >=20
> > static int dwc3_omap_probe(struct platform_device *pdev)
> > {
> > 	struct platform_device	*dwc3;
> > 	struct resource		res[2];
> >=20
> > 	dwc3 =3D platform_device_alloc("dwc3", -1);
> > 	/* check*/
> >=20
> > 	dwc3->dev.parent =3D &pdev->dev;
> >=20
> > 	/* copy DMA fields from parent too */
> >=20
> > 	res[0].start =3D start_address;
> > 	res[0].end =3D end_address;
> > 	res[0].flags =3D IORESOURCE_MEM;
> >=20
> > 	res[1].start =3D irq_number;
> > 	res[1].flags =3D IORESOURCE_IRQ;
> >=20
> > 	ret =3D platform_add_resources(dwc3, res, ARRAY_SIZE(res));
> > 	/* check */
> >=20
> > 	return platform_add_device(dwc3);
> > }
> >=20
> > and I wonder if I should have a DeviceTree like so:
> >=20
> > usb@xxxxx {
> > 	compatible =3D "ti,dwc3-omap";		// This is TI OMAP
> > 						// wrapper
> > 	range =3D <....>;
> >=20
> > 	...
> >=20
> > 	usb@yyyy {
> > 		compatible =3D "synopsys,dwc3",	// This is core IP
> > 						// inside wrapper
> >=20
> > 		...
> > 	};
> > };
> >=20
> > then I can drop the dwc3 platform_device allocation and all of that
> > resource copying, etc.
> >=20
> > What do you think ?
>=20
> Looks reasonable to me.  of_platform_populate() should be able to
> handle the device generation for you here.

Ok cool I looking into that and it handles everything I need. There are
only three issues which I see:

a) it hardcoded DMA mask to 32-bit. Right ?
b) it's not using dma_set_coherent_mask()
c) in case parent is a valid pointer, shouldn't it copy DMA mask from
	parent ?

I mean (doesn't solve (a) above):

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index ed5a6d3..172d4a9 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -204,7 +204,12 @@ struct platform_device *of_platform_device_create_pdat=
a(
 #if defined(CONFIG_MICROBLAZE)
 	dev->archdata.dma_mask =3D 0xffffffffUL;
 #endif
-	dev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32);
+
+	if (parent)
+		dma_set_coherent_mask(&dev->dev, parent->coherent_dma_mask);
+	else
+		dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
+
 	dev->dev.bus =3D &platform_bus_type;
 	dev->dev.platform_data =3D platform_data;
=20

--=20
balbi

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpRilAAoJEIaOsuA1yqRE6/UP/AsxwJpphNhlJxGiSWq+ilrd
lfcH/xhXoVU6OC7RfkTvbe5kdhi5NfF2mJ3sOczSYG4gM/MgH1mh2M2ipfu6oR63
TRZlChH9dGCh9AVVICiHeHUUj+m8Nwtp/CQDw7ur0bEBRIyESHvWTGUeuNrmrDTn
ZX17+0zKGoYjyXty5H2dT7Sm67p0lO703uZNulRT/54TXapEjw9fd8HMuVmRGDsR
F+C4dQd0IgpkfD8/deWodW5CSXeI15+p7lCWP3YqvqizpNjCbZA7XgkqdnOHAkXu
rU8TpI57Ss+QyyuMMAllDpclvKOcH+08wtVNM/YwOpRqSUbyVntEiI4gPYvOVi1P
IugSGotFGRJIHSFNixSk6ncsYq0+8UeWA+mV9Lc/XaoXxoB940HB2y+Da7Ektme7
EdtdARq3VeSlBkCjtxOXWrkYSG+xkrTNgNa1HOPegnTo4fzrKWST364MggAitBpo
pgPuvQFmK+ffL1C2u3pZ7hNosMBTggZbZ4jj2C+amPLc0SQpK1frN4vsmatpgbfm
Mi8xP9zgdwzXe57LaetOHzvZjmank/afv1/TaDjTUYURNAHQOCzU6aUqc3TYvCSA
t7euopSYjlG3qhWtA9cVRGp5eFUVNpPgvSZpwVt780ri/8SeE6eV2AUdObq1oziZ
yLw2t5WG3dP/QAs+u0vj
=sWEo
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
