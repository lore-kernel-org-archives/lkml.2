Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab2HUJIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:08:38 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:38800 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472Ab2HUJIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:08:35 -0400
Date: Tue, 21 Aug 2012 12:04:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: omap2-mcspi: Call pm_runtime_* functions
 directly
Message-ID: <20120821090435.GB10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345529864-7937-1-git-send-email-shubhrajyoti@ti.com>
 <1345529864-7937-2-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <1345529864-7937-2-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 11:47:42AM +0530, Shubhrajyoti D wrote:
> Call the pm_runtime functions directly making room for possible
> pm optimisations. Also the runtime functions aren't just about
> enabling and disabling of clocks though it does enable clocks also.
>=20
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/spi/spi-omap2-mcspi.c |   28 +++++++++++-----------------
>  1 files changed, 11 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
> index 259f601..dd887eb 100644
> --- a/drivers/spi/spi-omap2-mcspi.c
> +++ b/drivers/spi/spi-omap2-mcspi.c
> @@ -260,16 +260,6 @@ static void omap2_mcspi_restore_ctx(struct omap2_mcs=
pi *mcspi)
>  	list_for_each_entry(cs, &ctx->cs, node)
>  		__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
>  }
> -static void omap2_mcspi_disable_clocks(struct omap2_mcspi *mcspi)
> -{
> -	pm_runtime_mark_last_busy(mcspi->dev);
> -	pm_runtime_put_autosuspend(mcspi->dev);
> -}
> -
> -static int omap2_mcspi_enable_clocks(struct omap2_mcspi *mcspi)
> -{
> -	return pm_runtime_get_sync(mcspi->dev);
> -}
> =20
>  static int omap2_prepare_transfer(struct spi_master *master)
>  {
> @@ -848,12 +838,13 @@ static int omap2_mcspi_setup(struct spi_device *spi)
>  			return ret;
>  	}
> =20
> -	ret =3D omap2_mcspi_enable_clocks(mcspi);
> +	ret =3D pm_runtime_get_sync(mcspi->dev);
>  	if (ret < 0)
>  		return ret;
> =20
>  	ret =3D omap2_mcspi_setup_transfer(spi, NULL);
> -	omap2_mcspi_disable_clocks(mcspi);
> +	pm_runtime_mark_last_busy(mcspi->dev);
> +	pm_runtime_put_autosuspend(mcspi->dev);
> =20
>  	return ret;
>  }
> @@ -1067,7 +1058,7 @@ static int __devinit omap2_mcspi_master_setup(struc=
t omap2_mcspi *mcspi)
>  	struct omap2_mcspi_regs	*ctx =3D &mcspi->ctx;
>  	int			ret =3D 0;
> =20
> -	ret =3D omap2_mcspi_enable_clocks(mcspi);
> +	ret =3D pm_runtime_get_sync(mcspi->dev);
>  	if (ret < 0)
>  		return ret;
> =20
> @@ -1076,7 +1067,8 @@ static int __devinit omap2_mcspi_master_setup(struc=
t omap2_mcspi *mcspi)
>  	ctx->wakeupenable =3D OMAP2_MCSPI_WAKEUPENABLE_WKEN;
> =20
>  	omap2_mcspi_set_master_mode(master);
> -	omap2_mcspi_disable_clocks(mcspi);
> +	pm_runtime_mark_last_busy(mcspi->dev);
> +	pm_runtime_put_autosuspend(mcspi->dev);
>  	return 0;
>  }
> =20
> @@ -1251,7 +1243,8 @@ static int __devexit omap2_mcspi_remove(struct plat=
form_device *pdev)
>  	mcspi =3D spi_master_get_devdata(master);
>  	dma_channels =3D mcspi->dma_channels;
> =20
> -	omap2_mcspi_disable_clocks(mcspi);
> +	pm_runtime_mark_last_busy(mcspi->dev);
> +	pm_runtime_put_autosuspend(mcspi->dev);
>  	pm_runtime_disable(&pdev->dev);
> =20
>  	spi_unregister_master(master);
> @@ -1276,7 +1269,7 @@ static int omap2_mcspi_resume(struct device *dev)
>  	struct omap2_mcspi_regs	*ctx =3D &mcspi->ctx;
>  	struct omap2_mcspi_cs	*cs;
> =20
> -	omap2_mcspi_enable_clocks(mcspi);
> +	pm_runtime_get_sync(mcspi->dev);
>  	list_for_each_entry(cs, &ctx->cs, node) {
>  		if ((cs->chconf0 & OMAP2_MCSPI_CHCONF_FORCE) =3D=3D 0) {
>  			/*
> @@ -1289,7 +1282,8 @@ static int omap2_mcspi_resume(struct device *dev)
>  			__raw_writel(cs->chconf0, cs->base + OMAP2_MCSPI_CHCONF0);
>  		}
>  	}
> -	omap2_mcspi_disable_clocks(mcspi);
> +	pm_runtime_mark_last_busy(mcspi->dev);
> +	pm_runtime_put_autosuspend(mcspi->dev);
>  	return 0;
>  }
>  #else
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

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM08jAAoJEIaOsuA1yqREqWgP/03mYC5ZMwlTG3bKvsieZYGy
CLeYXZDXo6aVQpyJBjdDWLPQfhFRw4AUI0glQTEoQHwyEwqh25te+TxlRq597qDH
mnt38R3bx/g20L7LTdYKLMwsnCUMO2CV82F5UtRDdx2woNOFIeiBJZbsoZkqzrpP
ZjuaZhjtB1saR3VoREcXjqnGERt7q9jRQW4R7zoNpKVT6n7Ti5eXE3k2H6pV7nGb
WzBMdks0Do4LxMWCSBRfnZcQKuNxJ5RZy/wghDz+3aXpAzHwUa1LQShp4qIj3+yi
9HG+h9W+65Qk71wuei5rGi7fYMbVLbFowaQ42HfaBjSgThvKLtpDPFXDol/Ty1Wg
Ej1EpScZAekiVqDh9n3O1b6lWm7Ru5IszftyuiaBcpuz7nFwA2W5NbmIoPv6NgUu
4yk1XELf6spzfj+rAshUncEfuwzhn1mwacEJjwV7AXXZt/f+F8rL6EgDB+TWrT8N
9Lc/wD5L+7xhkGs0kvUSCTrfpDyCFWK/Ie/sQTwmqT6cI9ZlcUn4wJepuG9X4PdB
mOZdkiVwQknLl9r68SQZ3srjsbMG3uo61cCHUgTWSmhcnwB43Ugr3IBQ4cpDFN/T
vKJUnfv7+FMC0n9AWQZACzun+2IaZgh+89lLKez/G0m7/Us5lOCpLvtA/EY1q5s5
TWMHkxQntIEwftUWw1RR
=wPVi
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
