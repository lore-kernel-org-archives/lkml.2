Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1GFI2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:28:21 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58380 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614Ab1GFI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:28:19 -0400
Date: Wed, 6 Jul 2011 11:28:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: cjb@laptop.org, linux-mmc@vger.kernel.org,
        hans-christian.egtvedt@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@avr32linux.org,
        balbi@ti.com
Subject: Re: [PATCH V4] MMC: PM: add suspend/resume in atmel-mci
Message-ID: <20110706082808.GF10729@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4E11B57B.4040000@atmel.com>
 <1309944696-6415-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Content-Disposition: inline
In-Reply-To: <1309944696-6415-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AH+kv8CCoFf6qPuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 06, 2011 at 11:31:36AM +0200, Nicolas Ferre wrote:
> Take care of slots while going to suspend state.
>=20
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> @@ -1878,10 +1879,72 @@ static int __exit atmci_remove(struct platform_de=
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

just one small nitpicking which you can ignore if you like, but you
don't really need the else branch here. If you fall into if (ret < 0)
you will return early anyway, so you can save two lines and an
indentation level :-p

--=20
balbi

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFByYAAoJEAv8Txj19kN1ONcH/Rg7um74zY+ZiULxkkv77bLS
LLBa128mElCtI4PK6KN4tGuttAk9zN2mYT6RIAr+BLXXwLZkL88Fr41vZ2M990Ao
zI2Rj1L+kzHhSvj0GVPKhAQwvatR2ecsxUntxuTXcNGKwC1UmhTE5tIxLFqBmuSr
RHPcrrg4N/cNlO7uKPb0Wrh9dnJHUNFGsV0ztLhcqR6GM+XXHgMiWzJXxwffnt/2
w6U0ccfcbUZIxKUkp6GBQ1paPZKIDNJ9Zb+hqDnJLxjhPZ0vlYJhYEzoi+qlI90j
LcK32J53HdZa6RTXN6FUkLvp4wyfmu3uJvIlPNqMMk6SlS1nNHXC/vmxiaeT66Y=
=Ja9w
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
