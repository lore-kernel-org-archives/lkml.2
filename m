Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2HUJJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:09:12 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:54650 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981Ab2HUJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:09:08 -0400
Date: Tue, 21 Aug 2012 12:05:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] spi: omap2-mcspi: Remove the macro MOD_REG_BIT
Message-ID: <20120821090508.GC10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
 <1345529864-7937-3-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <1345529864-7937-3-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 11:47:43AM +0530, Shubhrajyoti D wrote:
> Remove the macro MOD_REG_BIT instead make the bit field modifications
> directly. This deletes a branch operation in cases where the the set
> is predecided.While at it optimise two sequential bit clear in one step.
               ^^
	       you need a space here, besides you can add the ack below

> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/spi/spi-omap2-mcspi.c |   28 ++++++++++++++--------------
>  1 files changed, 14 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index dd887eb..5642111 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -140,13 +140,6 @@ struct omap2_mcspi_cs {
>  	u32			chconf0;
>  };
> =20
> -#define MOD_REG_BIT(val, mask, set) do { \
> -	if (set) \
> -		val |=3D mask; \
> -	else \
> -		val &=3D ~mask; \
> -} while (0)
> -
>  static inline void mcspi_write_reg(struct spi_master *master,
>  		int idx, u32 val)
>  {
> @@ -205,7 +198,11 @@ static void omap2_mcspi_set_dma_req(const struct spi=
_device *spi,
>  	else
>  		rw =3D OMAP2_MCSPI_CHCONF_DMAW;
> =20
> -	MOD_REG_BIT(l, rw, enable);
> +	if (enable)
> +		l |=3D rw;
> +	else
> +		l &=3D ~rw;
> +
>  	mcspi_write_chconf0(spi, l);
>  }
> =20
> @@ -224,7 +221,11 @@ static void omap2_mcspi_force_cs(struct spi_device *=
spi, int cs_active)
>  	u32 l;
> =20
>  	l =3D mcspi_cached_chconf0(spi);
> -	MOD_REG_BIT(l, OMAP2_MCSPI_CHCONF_FORCE, cs_active);
> +	if (cs_active)
> +		l |=3D OMAP2_MCSPI_CHCONF_FORCE;
> +	else
> +		l &=3D ~OMAP2_MCSPI_CHCONF_FORCE;
> +
>  	mcspi_write_chconf0(spi, l);
>  }
> =20
> @@ -239,9 +240,8 @@ static void omap2_mcspi_set_master_mode(struct spi_ma=
ster *master)
>  	 * to single-channel master mode
>  	 */
>  	l =3D mcspi_read_reg(master, OMAP2_MCSPI_MODULCTRL);
> -	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_STEST, 0);
> -	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_MS, 0);
> -	MOD_REG_BIT(l, OMAP2_MCSPI_MODULCTRL_SINGLE, 1);
> +	l &=3D ~(OMAP2_MCSPI_MODULCTRL_STEST | OMAP2_MCSPI_MODULCTRL_MS);
> +	l |=3D OMAP2_MCSPI_MODULCTRL_SINGLE;
>  	mcspi_write_reg(master, OMAP2_MCSPI_MODULCTRL, l);
> =20
>  	ctx->modulctrl =3D l;
> @@ -1276,9 +1276,9 @@ static int omap2_mcspi_resume(struct device *dev)
>  			 * We need to toggle CS state for OMAP take this
>  			 * change in account.
>  			 */
> -			MOD_REG_BIT(cs->chconf0, OMAP2_MCSPI_CHCONF_FORCE, 1);
> +			cs->chconf0 |=3D OMAP2_MCSPI_CHCONF_FORCE;
>  			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
> -			MOD_REG_BIT(cs->chconf0, OMAP2_MCSPI_CHCONF_FORCE, 0);
> +			cs->chconf0 &=3D ~OMAP2_MCSPI_CHCONF_FORCE;
>  			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
>  		}
>  	}
> --=20
> 1.7.5.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM09EAAoJEIaOsuA1yqRE1vsP+QGOv3Wg+TMYUHjJX95co0/7
eP2vvc7bDAwL3eGy8veN+UI9c2WrVwZFE7nTzUWjgNJuipXaeGQPw7blYTpq/kGB
k+w/jRZ2EAu5rHYLT2XyIWRLshvboOyAwvqmbrkx3g6KXYo4FABXUuUJO9OasXwP
L+mrIM3ZvyCv4qFBp22PRsSRAxA+fV7IWZYkZJyn1EoIDediDuY3o7izvq80kufD
0Gd+rTK1JKUkFQsvOiKuxo0wV8KdVpUSA3gt+ygNLUntyPO0dHEOww9cyxdyIAVu
OLCK7mg7MDbt/eH1a9CqYAYFIXBJmbLIsVQ1AsTDTRM/kj+mWDqesf5Cxr3iZZCb
Pd+Rmyh+oJM9OX0i6Emrc9vaICIuZXmj2m3WVXZLxWChormLkwNuWuvRjJdPg2vR
7H257aVpbV1BWaATVkAC/twDKJHhXuaMHrZ7xfGpIAuzXMvPcCz1ppttv69mRWKx
A11M/R25I5uLexFB/eHE34/3EBOG4ogvpdnQSdCa6qa+ObeyszKx22diQBqXDqif
L8uEwb+TtRs6mIkb0z4vkBNQzndLydmzKXPkWEGtfv/hA1nFo3ZvNfrHMqVS+Ujx
IzI3GRcX4GPeik5bhqEuP1ZCVhC4QNhb3knk2iF58gdIp5koO1MsFCjJUkP4egIw
8vfpd42QzE7/qmY3t6WR
=Yqi/
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
