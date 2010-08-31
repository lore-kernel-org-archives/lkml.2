Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0HaTKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:10:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45470 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0HaTKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:10:18 -0400
Date: Tue, 31 Aug 2010 21:10:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Julia Lawall <julia@diku.dk>
Cc: Wolfgang Grandegger <wg@grandegger.com>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/4] drivers/net/can/mscan/mpc5xxx_can.c: Add
	of_node_put to avoid memory leak
Message-ID: <20100831191014.GA9603@pengutronix.de>
References: <1283269738-14612-1-git-send-email-julia@diku.dk> <1283269738-14612-4-git-send-email-julia@diku.dk> <20100831165153.GB28015@pengutronix.de> <Pine.LNX.4.64.1008311943280.2668@ask.diku.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008311943280.2668@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 31, 2010 at 07:44:00PM +0200, Julia Lawall wrote:
> Add a call to of_node_put in the error handling code following a call to
> of_find_matching_node.
>=20
> This patch also moves the existing call to of_node_put after the call to
> iounmap in the error handling code, to make it possible to jump to
> of_node_put without doing iounmap.  These appear to be disjoint operation=
s,
> so the ordering doesn't matter.
>=20
> This patch furthermore changes the -ENODEV result in the error handling
> code for of_find_matching_node to a return of 0, as found in the error
> handling code for of_iomap, because the return type of the function is
> unsigned.
>=20
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @r exists@
> local idexpression x;
> expression E,E1,E2;
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
> |of_find_node_by_type
> |of_find_node_with_property
> |of_find_matching_node
> |of_parse_phandle
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
> (
> E2 =3D x;
> |
> of_node_put(x);
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

>=20
> ---
>  drivers/net/can/mscan/mpc5xxx_can.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/=
mpc5xxx_can.c
> --- a/drivers/net/can/mscan/mpc5xxx_can.c
> +++ b/drivers/net/can/mscan/mpc5xxx_can.c
> @@ -143,12 +143,12 @@ static u32 __devinit mpc512x_can_get_clock(struct p=
latform_device *ofdev,
>  	np_clock =3D of_find_matching_node(NULL, mpc512x_clock_ids);
>  	if (!np_clock) {
>  		dev_err(&ofdev->dev, "couldn't find clock node\n");
> -		return -ENODEV;
> +		return 0;
>  	}
>  	clockctl =3D of_iomap(np_clock, 0);
>  	if (!clockctl) {
>  		dev_err(&ofdev->dev, "couldn't map clock registers\n");
> -		return 0;
> +		goto exit_put;
>  	}
> =20
>  	/* Determine the MSCAN device index from the physical address */
> @@ -233,9 +233,9 @@ static u32 __devinit mpc512x_can_get_clock(struct pla=
tform_device *ofdev,
>  		clocksrc =3D=3D 1 ? "ref_clk" : "sys_clk", clockdiv);
> =20
>  exit_unmap:
> -	of_node_put(np_clock);
>  	iounmap(clockctl);
> -
> +exit_put:
> +	of_node_put(np_clock);
>  	return freq;
>  }
>  #else /* !CONFIG_PPC_MPC512x */

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkx9U5YACgkQD27XaX1/VRvRswCfaIzPWU+aALo73qKcL/e66JQJ
mgMAoI17T1cndUa96SC56LmGQ97ZOihE
=lnS1
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
