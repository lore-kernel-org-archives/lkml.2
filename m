Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101Ab2BJUeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:34:12 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59340 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752139Ab2BJUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:34:10 -0500
Date: Fri, 10 Feb 2012 12:34:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI / PM: Disable wakeup during shutdown for devices
 not enabled to wake up
Message-ID: <20120210123407.7087d6a4@jbarnes-desktop>
In-Reply-To: <201202070050.35931.rjw@sisk.pl>
References: <201202070050.35931.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L88X/y5H_gfWU8yoLP+iGMc"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/L88X/y5H_gfWU8yoLP+iGMc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2012 00:50:35 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> If a PCI device is enabled to generate wakeup signals (PME) when put
> into a low-power state by runtime PM, it will be still enabled to
> generate those signals after the system shutdown, unless its driver's
> .shutdown() callback takes care of the wakeup signals generation
> setting.  Moreover, there are devices that are not enabled to wake
> up the system and that are configured by runtime PM to generate
> wakeup signals so that (runtime) remote wakeup works with them.
> Those devices should be reconfigured during system shutdown so that
> they don't generate wakeup signals, but at least some drivers don't
> do that.  However, that very well may be done by the PCI core so
> that drivers don't have to worry about it.  For this reason, modify
> pci_device_shutdown() to disable the generation of wakeup events for
> devices not supposed to wake up the system.
>=20
> References: https://bugzilla.kernel.org/show_bug.cgi?id=3D37952
> Reported-and-tested-by: Kamil Iskra <kamil.54002@iskra.name>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-driver.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> Index: linux/drivers/pci/pci-driver.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/pci/pci-driver.c
> +++ linux/drivers/pci/pci-driver.c
> @@ -430,6 +430,16 @@ static void pci_device_shutdown(struct d
>  		drv->shutdown(pci_dev);
>  	pci_msi_shutdown(pci_dev);
>  	pci_msix_shutdown(pci_dev);
> +
> +	/*
> +	 * Devices may be enabled to wake up by runtime PM, but they need not
> +	 * be supposed to wake up the system from its "power off" state (e.g.
> +	 * ACPI S5).  Therefore disable wakeup for all devices that aren't
> +	 * supposed to wake up the system at this point.  The state argument
> +	 * will be ignored by pci_enable_wake().
> +	 */
> +	if (!device_may_wakeup(dev))
> +		pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
>  }
> =20
>  #ifdef CONFIG_PM
>=20

So where do we end up setting the right wakeup state for devices we
actually *do* want to wake the system from S5?  Presumably later in the
shutdown sequence?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/L88X/y5H_gfWU8yoLP+iGMc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNX8/AAoJEIEoDkX4Qk9hJkcP/ibuYtU7qFV6Ey42W3NheuWb
bVajGEw4J/48npAeSqUZ1B0wTruEEoyemN/88QocFmQOLkW215nfN/dj65Ngam7K
HBE5on3d+7WzrdroPiiUowFlwxlRiZoL9Csi07lgSBY9u9mQIAQn4r5xJu9CtRJF
zQBTTjP/Bw9VEaE9woy8W9cIVLf9j5lgZOr+G+FF27seDcsFyDXRKK2yGjnnbpjE
94vWpE5SwRRrbWPFzB+f1kfmfNvYfJBdbEpy+KuQqYJHREm60Dd81B+W89zPKTiE
H40pSPIDqQuSCSu8u3+rY8NwAyoCnsevEBMS8/NbXia+YtU+OgI8gPBe+o+OBKmm
lMT3WnkEGXHb287rHsUW46cBA7rd4epNz610Oh71C3P6Axf2w/YaFWKdjZ621iF5
USr6RveeYlRvkGMov5wFMzc61Qehnb+d3o4wZTHsM6m3x4WnXL3h7+xWdS5s6Dnk
Dhu2hbye2x7Ye0bh+96FPdsUp0rVrFyYIQNp+7jeL2bAVVQNGoEGFNF4hAl+pXKZ
/2nrnMUDMw51hkIF/rAeTL5zqIBOjECNMBrgo8FLx2cpdfSGPppXUSTKwz+UNNKq
25VrWT8D/GqMiJxOa3qAaTNo/6XFzwenVsPDRBmI0GTum/dBILBkRYycoWABUUP0
Rj0O1yWHoW3B1ntLLWEB
=7pdL
-----END PGP SIGNATURE-----

--Sig_/L88X/y5H_gfWU8yoLP+iGMc--
