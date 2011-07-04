Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1GDLHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:07:00 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:42556 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1GDLG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:06:58 -0400
Date: Mon, 4 Jul 2011 14:06:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@avr32linux.org,
        u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH V3] MMC: PM: add suspend/resume in atmel-mci
Message-ID: <20110704110651.GC2820@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309530754.4373.3.camel@hcegtvedt.norway.atmel.com>
 <1309779505-25509-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline
In-Reply-To: <1309779505-25509-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 04, 2011 at 01:38:25PM +0200, Nicolas Ferre wrote:
> Take care of slots while going to suspend state.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> V3: take care of each slot SUSPENDED state
>     (adding a status bit in the slot "flags")
> V2: move to pm_ops
>=20
>  drivers/mmc/host/atmel-mci.c |   60 ++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index aa8039f..ed63bcd 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -203,6 +203,7 @@ struct atmel_mci_slot {
>  #define ATMCI_CARD_PRESENT	0
>  #define ATMCI_CARD_NEED_INIT	1
>  #define ATMCI_SHUTDOWN		2
> +#define ATMCI_SUSPENDED		3
> =20
>  	int			detect_pin;
>  	int			wp_pin;
> @@ -1878,10 +1879,69 @@ static int __exit atmci_remove(struct platform_de=
vice *pdev)
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_PM
> +static int atmci_suspend(struct device *dev)
> +{
> +	struct atmel_mci *host =3D dev_get_drvdata(dev);
> +	int i;
> +
> +	 for (i =3D 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +		struct atmel_mci_slot *slot =3D host->slot[i];
> +		int ret;
> +
> +		if (!slot)
> +			continue;
> +		ret =3D mmc_suspend_host(slot->mmc);
> +		if (ret < 0) {
> +			while (--i >=3D 0) {
> +				slot =3D host->slot[i];
> +				if (slot
> +				&& test_bit(ATMCI_SUSPENDED, &slot->flags)) {
> +					mmc_resume_host(host->slot[i]->mmc);
> +					clear_bit(ATMCI_SUSPENDED, &slot->flags);
> +				}
> +			}
> +			return ret;
> +		} else {
> +			set_bit(ATMCI_SUSPENDED, &slot->flags);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int atmci_resume(struct device *dev)
> +{
> +	struct atmel_mci *host =3D dev_get_drvdata(dev);
> +	int i;
> +	int ret =3D 0;
> +
> +	for (i =3D 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> +		struct atmel_mci_slot *slot =3D host->slot[i];
> +		int err;
> +
> +		slot =3D host->slot[i];
> +		if (!slot)
> +			continue;
> +		if (!test_bit(ATMCI_SUSPENDED, &slot->flags))
> +			continue;
> +		err =3D mmc_resume_host(slot->mmc);
> +		if (err < 0)
> +			ret =3D err;
> +		else
> +			clear_bit(ATMCI_SUSPENDED, &slot->flags);
> +	}
> +
> +	return ret;
> +}
> +#endif
> +static SIMPLE_DEV_PM_OPS(atmci_pm, atmci_suspend, atmci_resume);

if you disable CONFIG_PM this won't work. atmci_resume and atmci_suspend
will be undefined.

>  static struct platform_driver atmci_driver =3D {
>  	.remove		=3D __exit_p(atmci_remove),
>  	.driver		=3D {
>  		.name		=3D "atmel_mci",
> +		.pm		=3D &atmci_pm,

this pointer will also be invalid.

what most people do is:

#ifdef CONFIG_PM

suspend()
resume()

static SIMPLE_DEV_PM_OPS(atmci_pm, suspend, resume);

#define DEV_PM_OPS	(&atmci_pm)
#else
#define DEV_PM_OPS	NULL
#endif

--=20
balbi

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOEZ7LAAoJEAv8Txj19kN1XnYH/i23o2IAwgT9yjxzOH/id0ob
x3nLkAStugXfZIeRL00l7Dh+r7tMlxgJHnOEaNUMoXo1gUND3Y2h7YZFtRHaoEOx
Y1i3Vx9akQ4OONpHbtmXwLVmXgYy8rD7Bwl/Brc6scSLQzFZspCxXml4zknomwmw
3CFJLztMR+gXmcy5/o/rHYoWQtboUJKclCWpNoBfsAHLarNYh8COpIx8QJL94Cgc
mW2pCen3SOFDNs1vHwLYX+f2SRdvnXYYFiLugDQOYzS7cFxqnO+1Ebb60JSlMtxo
IrPNX0AfsEgeyRTZwf6IJX2Us0cIgQXbZeaIKBdEOyTHZAg8WxcIum0XDs4RTuM=
=gLEm
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
