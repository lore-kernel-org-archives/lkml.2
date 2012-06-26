Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab2FZGJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 02:09:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2FZGJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 02:09:44 -0400
Date: Tue, 26 Jun 2012 08:09:36 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v2] spi/pl022: add devicetree support
Message-ID: <20120626060936.GA12229@avionic-0098.adnet.avionic-design.de>
References: <1340658390-29569-1-git-send-email-aletes.xgr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <1340658390-29569-1-git-send-email-aletes.xgr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:phA5qaVMQXbhmba4dtjH3DLQpPxfgOskywX3Ywymej6
 Vvc04mJNARiTUovBYZImXADkTUsZr8jBbfCMnUZrzoqlPDhgID
 bNakImLmAs6kDouKQ2uXKxKbXuGosnMLlsbaBqhxzcUOKbjXvm
 t7AEDw9Ne3vjNaPuEKnlGHYjXNbfPdT1ZQYms2FhKnoxqAAsG5
 gs2S/XFtuRG1hTrH1kICBGNvqPc1CwmPJOsR55ALNntowk+MHz
 9UiE5DsrVJyOlb6UAcu7e8Hpdjv3xLR3ydATP4Qnxf2a/1NrkN
 UCh8kp6JHtpAlz7MfzE8qVkh8GAryZEE+x8KbXTCPC9J/5E1fW
 ALWxvHp7pUrHxG7cg0iKPNO8GFMncGMq8qz7/Oi0WawVHvsmQE
 VRaSy51B9mdDLvVM1AlknirSNvX+EHVwjQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 25, 2012 at 06:06:28PM -0300, Alexandre Pereira da Silva wrote:
[...]
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
[...]
> @@ -1733,7 +1744,7 @@ static int calculate_effective_freq(struct pl022 *p=
l022, int freq, struct
>   * A piece of default chip info unless the platform
>   * supplies it.
>   */
> -static const struct pl022_config_chip pl022_default_chip_info =3D {
> +static struct pl022_config_chip pl022_default_chip_info =3D {
>  	.com_mode =3D POLLING_TRANSFER,
>  	.iface =3D SSP_INTERFACE_MOTOROLA_SPI,
>  	.hierarchy =3D SSP_SLAVE,

What's the reason for removing the const? You're only reading data from
the structure.

[...]
> @@ -1998,8 +2039,14 @@ pl022_probe(struct amba_device *adev, const struct=
 amba_id *id)
>  		goto err_no_pdata;
>  	}
> =20
> +	num_cs =3D platform_info->num_chipselect;
> +#ifdef CONFIG_OF
> +	of_property_read_u32(np, "pl022,num-chipselects", &num_cs);
> +#endif

This...

[...]
> @@ -2017,13 +2064,40 @@ pl022_probe(struct amba_device *adev, const struc=
t amba_id *id)
>  	 * on this board
>  	 */
>  	master->bus_num =3D platform_info->bus_id;
> -	master->num_chipselect =3D platform_info->num_chipselect;
> +	master->num_chipselect =3D num_cs;
>  	master->cleanup =3D pl022_cleanup;
>  	master->setup =3D pl022_setup;
>  	master->prepare_transfer_hardware =3D pl022_prepare_transfer_hardware;
>  	master->transfer_one_message =3D pl022_transfer_one_message;
>  	master->unprepare_transfer_hardware =3D pl022_unprepare_transfer_hardwa=
re;
>  	master->rt =3D platform_info->rt;
> +	master->dev.of_node =3D dev->of_node;
> +
> +#ifdef CONFIG_OF
> +	for (i =3D 0; i < num_cs; i++) {
> +		int cs_gpio =3D of_get_named_gpio(np, "cs-gpios", i);
> +
> +		if (cs_gpio =3D=3D -EPROBE_DEFER) {
> +			status =3D -EPROBE_DEFER;
> +			goto err_no_gpio;
> +		}
> +
> +		pl022->chipselect[i] =3D cs_gpio;
> +
> +		if (gpio_is_valid(cs_gpio)) {
> +			if (gpio_request(cs_gpio, "ssp-pl022"))
> +				dev_err(&adev->dev,
> +					"could not request %d gpio\n", cs_gpio);
> +			else if (gpio_direction_output(cs_gpio, 1))
> +				dev_err(&adev->dev,
> +					"could set gpio %d as output\n",
> +					cs_gpio);
> +		}
> +	}
> +#else
> +	for (i =3D 0; i < num_cs; i++)
> +		pl022->chipselect[i] =3D -EINVAL;
> +#endif

=2E.. and this would be good candidates for IS_ENABLED(CONFIG_OF).

> =20
>  	/*
>  	 * Supports mode 0-3, loopback, and active low CS. Transfers are
> @@ -2130,6 +2204,9 @@ pl022_probe(struct amba_device *adev, const struct =
amba_id *id)
>   err_no_ioremap:
>  	amba_release_regions(adev);
>   err_no_ioregion:
> + #ifdef CONFIG_OF
> + err_no_gpio:
> + #endif

If you use the IS_ENABLED() macro, then you no longer need these either.

Thierry

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIbBAEBAgAGBQJP6VIgAAoJEN0jrNd/PrOh+hEP9jKvRys0+misWJJvA8OThxtU
WGnVTSHA/NzrOsiSAX7C0ZoCzo7iWk7xqPGRvblLFlwE8OiZNyc/34oa/s31OVr3
4zgIQgQlXwncZHMuxn2CDUDQKC3IDgekg5ytelNcE8zjl6ZucqA9uQWvYJM3FCt2
fBdY5wpQGVdSiPECbn2HW244wVq7caIOmsSHPvCecKKK/uF4sOjgECMi/5AbGeyP
TH8uwLU2L8J9j6Reji7pNTaiK2SCLsKjbSY7pUpC+A6bG/LT78smFupmEYwwaXvU
wPyAffoGa7HnSBb24u2pz2Rc2SMKvXOL/jkTy4KMpyk86wVvOR25gZ7hYT0HwPn8
7ivjhP3XQXHYaPYLEnVkBpyUaBlvZKeZijAZSAA7+GudBL72Mkx86/RUicrMkvvC
4n6DRrN5MejqigBQIaUL6nGBN2J1G+1IAFs+zrxvM1y1eBD6smDsWx0USQ2b0qCQ
uMiR+RSeI0/EbTxYyzRujAVp1TOnhCVbcTpNVUyjC7Q2WUavfc4/PlRZpQlTQi0S
BMKeyW9VjnWpYPxty87kHKFdsdnIwOpqM4Mz7/INBuPuN9aJmmdQlwkesd/HkPxl
9MOhotMxrWkLhSwj4ULdhqL+JYjaekDzTMj//1krI8GPOXtYY+ilqcetQzjfETbz
32XQ/ICxFOegtyuVuDY=
=oyZ0
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
