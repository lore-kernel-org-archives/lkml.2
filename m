Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab1BYSDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:03:15 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35294 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab1BYSC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:02:58 -0500
Date: Fri, 25 Feb 2011 19:02:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: always use max timeout for xfers
Message-ID: <20110225180248.GA15491@pengutronix.de>
References: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <D8739074-546D-4531-A8E9-23E9F7A33EB5@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philip,

On Fri, Feb 25, 2011 at 09:54:35AM -0800, Philip Rakity wrote:
> Rather then special case busy etc .. lets just use the max value. =20

OK.

>=20
> Did not remove BROKEN_TIMEOUT QUIRK so existing code will compile
> we can remove this once existing platform drivers delete usage and get
> quirk back.

If we wait for that, we'll probably wait till eternity ;) I'd vote that
removing the quirk should be part of the patch.

>=20
> Patch starts after =3D=3D=3D=3D
> =3D=3D=3D=3D=3D

The usual nomenclature is that such comments simply go between '---' and the
diffstat. Most tools are prepared for this...

> The card/host controller may sometimes return a value that is
> too low and cause the h/w to timeout a transfer that would have
> worked.  Using the maximum value avoids this.
>=20
> Signed-off-by: Philip Rakity <prakity@marvell.com>
> ---

=2E.. to handle them here.

>  drivers/mmc/host/sdhci.c |   48 ++++------------------------------------=
-----
>  1 files changed, 5 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 655617c..dd99da8 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -592,53 +592,15 @@ static void sdhci_adma_table_post(struct sdhci_host=
 *host,
>  		data->sg_len, direction);
>  }
> =20
> -static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_data *d=
ata)
> +static inline u8 sdhci_calc_timeout(void)
>  {
> -	u8 count;
> -	unsigned target_timeout, current_timeout;
> -
>  	/*
> -	 * If the host controller provides us with an incorrect timeout
> -	 * value, just skip the check and use 0xE.  The hardware may take
> +	 * The host controller/card can provide us with an incorrect timeout
> +	 * value, just use the maximum value 0xE.  The hardware may take
>  	 * longer to time out, but that's much better than having a too-short
>  	 * timeout value.
>  	 */
> -	if (host->quirks & SDHCI_QUIRK_BROKEN_TIMEOUT_VAL)
> -		return 0xE;
> -
> -	/* timeout in us */
> -	target_timeout =3D data->timeout_ns / 1000 +
> -		data->timeout_clks / host->clock;
> -
> -	if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)
> -		host->timeout_clk =3D host->clock / 1000;

This quirk could go then as well?

> -
> -	/*
> -	 * Figure out needed cycles.
> -	 * We do this in steps in order to fit inside a 32 bit int.
> -	 * The first step is the minimum timeout, which will have a
> -	 * minimum resolution of 6 bits:
> -	 * (1) 2^13*1000 > 2^22,
> -	 * (2) host->timeout_clk < 2^16
> -	 *     =3D>
> -	 *     (1) / (2) > 2^6
> -	 */
> -	count =3D 0;
> -	current_timeout =3D (1 << 13) * 1000 / host->timeout_clk;
> -	while (current_timeout < target_timeout) {
> -		count++;
> -		current_timeout <<=3D 1;
> -		if (count >=3D 0xF)
> -			break;
> -	}
> -
> -	if (count >=3D 0xF) {
> -		printk(KERN_WARNING "%s: Too large timeout requested!\n",
> -			mmc_hostname(host->mmc));
> -		count =3D 0xE;
> -	}
> -
> -	return count;
> +	return 0xE;

Why don't you remove the function entirely?

>  }
> =20
>  static void sdhci_set_transfer_irqs(struct sdhci_host *host)
> @@ -671,7 +633,7 @@ static void sdhci_prepare_data(struct sdhci_host *hos=
t, struct mmc_data *data)
>  	host->data =3D data;
>  	host->data_early =3D 0;
> =20
> -	count =3D sdhci_calc_timeout(host, data);
> +	count =3D sdhci_calc_timeout();
>  	sdhci_writeb(host, count, SDHCI_TIMEOUT_CONTROL);
> =20
>  	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1n7sgACgkQD27XaX1/VRuWnwCgkvfujXh2Ttzw3ZvvQPCiFmIH
GDEAoLnKOHDqZ5dp7U69ZHxOXOrcoX9G
=FoAH
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
