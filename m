Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0H2Prw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:47:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46072 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab0H2Prv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:47:51 -0400
Date: Sun, 29 Aug 2010 17:47:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/7] drivers/mtd/nand/mpc5121_nfc.c: Add of_node_put to
	avoid memory leak
Message-ID: <20100829154744.GB4647@pengutronix.de>
References: <1283075566-27441-1-git-send-email-julia@diku.dk> <1283075566-27441-4-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <1283075566-27441-4-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 29, 2010 at 11:52:42AM +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_compatible_node.
>=20
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1;
> statement S;
> @@
>=20
> *x =3D=20
> (of_find_node_by_path
> |of_find_node_by_name
> |of_find_node_by_phandle
> |of_get_parent
> |of_get_next_parent
> |of_get_next_child
> |of_find_compatible_node
> |of_match_node
> )(...);
> ...
> if (x =3D=3D NULL) S
> <... when !=3D x =3D E
> *if (...) {
>   ... when !=3D of_node_put(x)
>       when !=3D if (...) { ... of_node_put(x); ... }
> (
>   return <+...x...+>;
> |
> *  return ...;
> )
> }
> ...>
> of_node_put(x);
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

adding ppc-list to cc.

>=20
> ---
>  drivers/mtd/nand/mpc5121_nfc.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nf=
c.c
> index df0c1da..f4610bc 100644
> --- a/drivers/mtd/nand/mpc5121_nfc.c
> +++ b/drivers/mtd/nand/mpc5121_nfc.c
> @@ -568,6 +568,7 @@ static int mpc5121_nfc_read_hw_config(struct mtd_info=
 *mtd)
>  	uint rcw_width;
>  	uint rcwh;
>  	uint romloc, ps;
> +	int ret =3D 0;
> =20
>  	rmnode =3D of_find_compatible_node(NULL, NULL, "fsl,mpc5121-reset");
>  	if (!rmnode) {
> @@ -579,7 +580,8 @@ static int mpc5121_nfc_read_hw_config(struct mtd_info=
 *mtd)
>  	rm =3D of_iomap(rmnode, 0);
>  	if (!rm) {
>  		dev_err(prv->dev, "Error mapping reset module node!\n");
> -		return -EBUSY;
> +		ret =3D -EBUSY;
> +		goto out;
>  	}
> =20
>  	rcwh =3D in_be32(&rm->rcwhr);
> @@ -628,8 +630,9 @@ static int mpc5121_nfc_read_hw_config(struct mtd_info=
 *mtd)
>  				rcw_width * 8, rcw_pagesize,
>  				rcw_sparesize);
>  	iounmap(rm);
> +out:
>  	of_node_put(rmnode);
> -	return 0;
> +	return ret;
>  }
> =20
>  /* Free driver resources */
>=20
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkx6gSAACgkQD27XaX1/VRu0AgCgtucFBgSniN12c8AQGNzYv0jp
B0AAnRHH0tAw2XCxIB4aR3p+Gk3D0luH
=0rXz
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
