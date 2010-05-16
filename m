Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0EPBJp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 21:09:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37565 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab0EPBJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 21:09:44 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1269401791.18314.267.camel@localhost>
References: <1269401791.18314.267.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iPckc6+QB5zXy/uY2gBt"
Date: Sun, 16 May 2010 02:09:37 +0100
Message-ID: <1273972177.2564.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 2/2] amd64-agp: Probe unknown AGP devices the right way
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iPckc6+QB5zXy/uY2gBt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-03-24 at 03:36 +0000, Ben Hutchings wrote:
> The current initialisation code probes 'unsupported' AGP devices
> simply by calling its own probe function.  It does not lock these
> devices or even check whether another driver is already bound to
> them.
>=20
> We must use the device core to manage this.  So if the specific
> device id table didn't match anything and agp_try_unsupported=3D1,
> switch the device id table and call driver_attach() again.

Can you please apply or nak this?

Ben.

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> This is untested as I have no suitable hardware.
>=20
> Greg, please confirm that the use of driver_attach() is sane.
>=20
> Ben.
>=20
>  drivers/char/agp/amd64-agp.c |   27 +++++++++++++++------------
>  1 files changed, 15 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
> index fd50ead..93f56d6 100644
> --- a/drivers/char/agp/amd64-agp.c
> +++ b/drivers/char/agp/amd64-agp.c
> @@ -499,6 +499,10 @@ static int __devinit agp_amd64_probe(struct pci_dev =
*pdev,
>  	u8 cap_ptr;
>  	int err;
> =20
> +	/* The Highlander principle */
> +	if (agp_bridges_found)
> +		return -ENODEV;
> +
>  	cap_ptr =3D pci_find_capability(pdev, PCI_CAP_ID_AGP);
>  	if (!cap_ptr)
>  		return -ENODEV;
> @@ -562,6 +566,8 @@ static void __devexit agp_amd64_remove(struct pci_dev=
 *pdev)
>  			   amd64_aperture_sizes[bridge->aperture_size_idx].size);
>  	agp_remove_bridge(bridge);
>  	agp_put_bridge(bridge);
> +
> +	agp_bridges_found--;
>  }
> =20
>  #ifdef CONFIG_PM
> @@ -709,6 +715,11 @@ static struct pci_device_id agp_amd64_pci_table[] =
=3D {
> =20
>  MODULE_DEVICE_TABLE(pci, agp_amd64_pci_table);
> =20
> +static DEFINE_PCI_DEVICE_TABLE(agp_amd64_pci_promisc_table) =3D {
> +	{ PCI_DEVICE_CLASS(0, 0) },
> +	{ }
> +};
> +
>  static struct pci_driver agp_amd64_pci_driver =3D {
>  	.name		=3D "agpgart-amd64",
>  	.id_table	=3D agp_amd64_pci_table,
> @@ -734,7 +745,6 @@ int __init agp_amd64_init(void)
>  		return err;
> =20
>  	if (agp_bridges_found =3D=3D 0) {
> -		struct pci_dev *dev;
>  		if (!agp_try_unsupported && !agp_try_unsupported_boot) {
>  			printk(KERN_INFO PFX "No supported AGP bridge found.\n");
>  #ifdef MODULE
> @@ -750,17 +760,10 @@ int __init agp_amd64_init(void)
>  			return -ENODEV;
> =20
>  		/* Look for any AGP bridge */
> -		dev =3D NULL;
> -		err =3D -ENODEV;
> -		for_each_pci_dev(dev) {
> -			if (!pci_find_capability(dev, PCI_CAP_ID_AGP))
> -				continue;
> -			/* Only one bridge supported right now */
> -			if (agp_amd64_probe(dev, NULL) =3D=3D 0) {
> -				err =3D 0;
> -				break;
> -			}
> -		}
> +		agp_amd64_pci_driver.id_table =3D agp_amd64_pci_promisc_table;
> +		err =3D driver_attach(&agp_amd64_pci_driver.driver);
> +		if (err =3D=3D 0 && agp_bridges_found =3D=3D 0)
> +			err =3D -ENODEV;
>  	}
>  	return err;
>  }

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-iPckc6+QB5zXy/uY2gBt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS+9F0Oe/yOyVhhEJAQLMxQ/6A4W2gNvKhtkDIwNXdSt284oZ4/Crps+L
9q4z18wTXJUbd7nxCT2tbK7G+EQGyHs6WAQf03KZWCtfJkt9XmraYeB9XPx0vejK
YqdTwZdedtGZ+P+4eod/Sr5PHgoOWwOv76wJN1h1TjwwtoylqI/LhH96/fnmubxh
H9DqYtB6dD2a3caDY7CYZR/muTXWu0j2Mgys7i1iHYri39IyjQqpw0Joes9sE5Qz
EQKYW5fogxdO75PyFMvBDdthXzobk+Wfe2weqUg+fnZCPpM2QBDRtUILIiVRaig7
8WzMKdL3rit1LiVFuUh0kU26fKJXP/yInczF7dLcE+k+F4jpXKF7aWcQbJhnigQp
hDs2xxFaJ8GIK/2eRvtZj8I3SJKNNpYDfZs7KGsHrfxIReSTPzxKAIpGOo++8Vyk
C7w00tJd0ioEKl8QS5IqL7H9S9trrwS2aK0LnhU/WMEASHZiSq6Hne1sTPoenjiH
0uRR067iQDj8BpT618bJPamgVF426N6cbv37E/lW47gr/MOA1WKcuz6TxM29jkYj
LurgDTNc1QjUS4nKuW4arZ3i1n+NnFZqRPYGqFRkqvpWvsDuRHFuGLvzyUoiZfw/
ghAnovwBDMZup5JheYnyarBXD/6W+r0wdfv20o6XlUu0mHqB9NkBqf3+TcT3TPoE
D6pZ2gRpbsA=
=WF2T
-----END PGP SIGNATURE-----

--=-iPckc6+QB5zXy/uY2gBt--
