Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1F2QBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:01:19 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47487 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128Ab1F2QBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:01:17 -0400
Date: Wed, 29 Jun 2011 19:01:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@avr32linux.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] MMC: PM: add suspend/resume in atmel-mci
Message-ID: <20110629160110.GD2760@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1ef60c032bc39531302c1603bfcb841d2d437ccc.1309366360.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOYy6nE9rVgTbVLg"
Content-Disposition: inline
In-Reply-To: <1ef60c032bc39531302c1603bfcb841d2d437ccc.1309366360.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOYy6nE9rVgTbVLg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 29, 2011 at 06:54:19PM +0200, Nicolas Ferre wrote:
> Take care of slots while going to suspend state.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mmc/host/atmel-mci.c |   51 ++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 51 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index aa8039f..c414ebe 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -1878,8 +1878,59 @@ static int __exit atmci_remove(struct platform_dev=
ice *pdev)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_PM
> +static int atmci_suspend(struct platform_device *pdev, pm_message_t mesg)
> +{
> +	struct atmel_mci *host =3D platform_get_drvdata(pdev);
> +	struct atmel_mci_slot *slot;
> +	int i, ret;
> +
> +	 for (i =3D 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +		slot =3D host->slot[i];
> +		if (!slot)
> +			continue;
> +		ret =3D mmc_suspend_host(slot->mmc);
> +		if (ret < 0) {
> +			while (--i >=3D 0) {
> +				slot =3D host->slot[i];
> +				if (slot)
> +					mmc_resume_host(host->slot[i]->mmc);
> +			}
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int atmci_resume(struct platform_device *pdev)
> +{
> +	struct atmel_mci *host =3D platform_get_drvdata(pdev);
> +	struct atmel_mci_slot *slot;
> +	int i, ret;
> +
> +	for (i =3D 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +		slot =3D host->slot[i];
> +		if (!slot)
> +			continue;
> +		ret =3D mmc_resume_host(slot->mmc);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +#else
> +#define atmci_suspend	NULL
> +#define atmci_resume	NULL
> +#endif
> +
> +
> +
>  static struct platform_driver atmci_driver =3D {
>  	.remove		=3D __exit_p(atmci_remove),
> +	.suspend	=3D atmci_suspend,
> +	.resume		=3D atmci_resume,

should this be using dev_pm_ops instead ?

--=20
balbi

--GOYy6nE9rVgTbVLg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOC0xGAAoJEAv8Txj19kN1WrAH/jSeJzlVXCg18esFXGnVTjir
1iDCvpbPNMbIBITEzCYH09Jgfud218tu86leFPPy/fn5a08xWJfp/F9DtqPgGiGW
b+Wj1Tkbq81oK5Nt1/BOLVL2eXaDUm76o0+pZMauC24HaVMJobmbidvfa9vAIFsf
WGKpQT2DMplOkJ7LXd/BaZOC965zxLbBhejd9L1yap7MIY0k9OxTEcVn0NYTdu0R
8AQyFiCgq7WfLS5ZWoC23DSMB+QkEvUZffxOuWxZwljzRONNuuR9S1hDnXy4feIz
3CkTSn91Cb7mx2fun1SWmh0StMReXa1tyFpP7ttAZc6SJ9NfJnnyqq0+rUIjqe8=
=1YFL
-----END PGP SIGNATURE-----

--GOYy6nE9rVgTbVLg--
