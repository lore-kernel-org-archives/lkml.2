Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1JXGmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 02:42:35 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57921 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990Ab1JXGmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 02:42:33 -0400
Date: Mon, 24 Oct 2011 09:42:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: DeviceTree and children devices
Message-ID: <20111024064227.GW5453@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eUqGrSc0O7wKBRnC"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eUqGrSc0O7wKBRnC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

I have a question about how DeviceTree should be written in case a
device has a child device.

The way things are integrated on OMAP is that we will always have a
parent device which is a wrapper around an IP core in order to
integrate with the OMAP context (clocks, power management, etc).

That wrapper has its own address space and its own IRQ number
(generally). On my dwc3 driver I have modeled the OMAP wrapper as a
parent device which allocates a child device for the core IP driver.
This makes it a lot easier to re-use the core IP driver on other SoCs or
PCI (there's a glue layer for PCI too).

So I wonder if we should describe that on DeviceTree and not have the
OMAP glue layer allocate the core IP driver. Just to illustrate, here's
what we have:

static int dwc3_omap_probe(struct platform_device *pdev)
{
	struct platform_device	*dwc3;
	struct resource		res[2];

	dwc3 =3D platform_device_alloc("dwc3", -1);
	/* check*/

	dwc3->dev.parent =3D &pdev->dev;

	/* copy DMA fields from parent too */

	res[0].start =3D start_address;
	res[0].end =3D end_address;
	res[0].flags =3D IORESOURCE_MEM;

	res[1].start =3D irq_number;
	res[1].flags =3D IORESOURCE_IRQ;

	ret =3D platform_add_resources(dwc3, res, ARRAY_SIZE(res));
	/* check */

	return platform_add_device(dwc3);
}

and I wonder if I should have a DeviceTree like so:

usb@xxxxx {
	compatible =3D "ti,dwc3-omap";		// This is TI OMAP
						// wrapper
	range =3D <....>;

	...

	usb@yyyy {
		compatible =3D "synopsys,dwc3",	// This is core IP
						// inside wrapper

		...
	};
};

then I can drop the dwc3 platform_device allocation and all of that
resource copying, etc.

What do you think ?

--=20
balbi

--eUqGrSc0O7wKBRnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpQjTAAoJEIaOsuA1yqREXfcQAIHMNGjJSbjwBatTs1E22LpU
afx87kMB+qEUIeGFqlETChZINm+sVVoYgDD0WW2Z9kevNqQTrfN8VuMihU8GtkrW
bslsYdi58h3jmEj+oXbm/0MPQQ5MGxjXAQrux/uMgtDtN0pat8gTU5G7OK9OvAsW
LJTHsk9YAFWdy/fjt/r4NtDqLACdhBR4IMeXBKGMYgwzj6Y65kNcYYuOpGq0GwYX
QJ3UeGyyg8hmbDZtRadlP7f8xsS/Nf1HXfeHMakAYYZvXCUQHOhwm7B5x4/LjW7J
1xV0QyHsU9fzbNM24ltCLgZt8ozsr0m+W2h+Cvmu3XtAV3e7VFiScXLNJNCkRLwQ
42wka1Y78C5OPDqaEjsUd7qBvG/IgZDLR+6HblNMtfn+IwcAL+WZ+X0EmU1zsl+c
GTOogZpIcEAlFy3QIAHfKAew5LEnl8RHaoVWA9rI3jeSLBXa8fxnjsSMu77msAn8
fhwHVKGzmAbUmtqHs1WdViYvQcrj+c3G2V/v35uCXLDFQGLHClzjXnh2VXyqyoX8
S84D6KCbOoeyECVb+GQ9Ug4o28RHaUPexysHKsl72/KzE3VUKYD+i+vEi82yXCsx
YISS6d/TJHRyoK7D3He48SFVlDFYmuHBTBxGM8v1yQLjHdtvYu5D354qdEC89m/v
EcWrc/B060vQLcoThssZ
=At1Q
-----END PGP SIGNATURE-----

--eUqGrSc0O7wKBRnC--
