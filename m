Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1KVRak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:30:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57471 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1KVRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:30:39 -0500
Date: Tue, 22 Nov 2011 18:30:29 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: Wim@vger.kernel.org, wim@iguana.be, Welte@vger.kernel.org,
        Van@vger.kernel.org, Sebroeck@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com, Harald@vger.kernel.org
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111122173029.GA14349@pengutronix.de>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2011 at 06:05:48PM +0100, Marc Vertes wrote:
> Wolfram Sang <w.sang@pengutronix.de> wrote:
>=20
> > On Tue, Nov 22, 2011 at 12:17:13PM +0100, Marc Vertes wrote:
> > > Add a new driver for the hardware watchdog timer on VIA chipsets.
> > > Tested on a Artigo A1100, VX855 chipset.
> > >=20
> > > Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
> >
> > New watchdog drivers should use the framework. Have a look at
> > Documentation/watchdog/convert_drivers_to_kernel_api.txt for a guide. It
> > is mainly removing code, though.
> >
> Here it is:

Great, thanks.

> +static int wdt_start(struct watchdog_device *wdev)
> +{
> +	/* Nothing to do. The watchdog can only be started by the BIOS. */
> +	return 0;
> +}
> +
> +static int wdt_stop(struct watchdog_device *wdev)
> +{
> +	/* Nothing to do. The watchdog can not be stopped. */
> +	return 0;
> +}

Hmm, I'll leave this to Wim if it can stay like this (or if he wants a time=
r to
serve the non-stoppable watchdog or so).

> +static int __devinit wdt_probe(struct pci_dev *pdev,
> +			       const struct pci_device_id *ent)
> +{
> +	unsigned int mmio =3D 0;
> +	void __iomem *wdt_mem;
> +	int ret;
> +
> +	if (pci_enable_device(pdev)) {
> +		dev_err(&pdev->dev, "cannot enable PCI device\n");
> +		return -ENODEV;
> +	}
> +	pci_read_config_dword(pdev, VIA_WDT_MB_OFFSET, &mmio);
> +	dev_info(&pdev->dev, "VIA Chipset watchdog MMIO: %x\n", mmio);
> +	if (mmio =3D=3D 0) {
> +		dev_err(&pdev->dev, "watchdog timer is not enabled in BIOS\n");
> +		return -ENODEV;
> +	}

What about

	if (mmio !=3D 0) {
		dev_info("VIA Chipset...")
	} else {
		dev_err()
		return -ENODEV;
	}

to only have the needed printouts.

> +	wdt_mem =3D ioremap(mmio, 8);
> +	if (wdt_mem =3D=3D NULL) {
> +		dev_err(&pdev->dev, "cannot remap VIA wdt mmio registers\n");
> +		return -ENODEV;
> +	}
> +	ret =3D watchdog_register_device(&wdt_dev);
> +	if (ret)
> +		return ret;

You need to iounmap in the error-case.

> +	watchdog_set_drvdata(&wdt_dev, wdt_mem);
> +	if (readl(wdt_mem) & VIA_WDT_FIRED) {
> +		wdt_dev.bootstatus |=3D WDIOF_CARDRESET;
> +		dev_notice(&pdev->dev, "restarted by expired watchdog\n");

Skip the printout. This can be detected using CARDRESET.

> +/*
> + * The driver has not been tested yet on CX700 and VX800.
> + */

Then, I'd rather skip this comment and the IDs. Or if you are sure enough it
works, leave them in ;) Best option would be testers showing up.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7L3DUACgkQD27XaX1/VRt0iQCaAtwVRshSc4kt1TBuw44PcZ98
Fs8AoJoIW8CmN3Cww6eXZrVEAC9znuWV
=d7Ai
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
