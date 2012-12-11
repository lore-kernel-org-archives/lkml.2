Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab2LKHNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:13:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2LKHNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:13:05 -0500
Date: Tue, 11 Dec 2012 08:12:53 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v3 2/4] leds: leds-pwm: Preparing the driver for device
 tree support
Message-ID: <20121211071253.GC8294@avionic-0098.adnet.avionic-design.de>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
 <1355133637-2784-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
In-Reply-To: <1355133637-2784-3-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:mOBI/HM1Hvvme7qPTOl60A/mO8HhHRjppqr+zrdDT5Q
 XbZQU1l2/fFgreyCsuvY5G9aLyKVPDzvkpn78gYafYcMQ48XN4
 5yMIHTTsOLYGDFZYtu/AQXJWxv/om4F/zrxAsVn/ki5Y7E3g8+
 +zLcIxW7C2wVSxdnCAhlE77R72OyNbcZL6kK5Hwo/CqcumdH3G
 zigWYS8ccRKGgTyFcXde2e4EE/GMaz0cAUDz7zW+0k8vCeHsFB
 cajfb8pbj5swEYw60LKRANeG6oSu6p6Fqd3H9n8nT88HBSf1o3
 nene2G/nQumsfKUQfoDqD/JtQ2Ru+R/HvXxYFSOWV2zD8G6rjk
 o0jMCEKPFR6b+vZ7046pJP8SixOCBsUe17UqreLsomUUotDj+0
 LVfpnmGRVLQWtDC4R7PMqiZAgpgqiIJkkY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2012 at 11:00:35AM +0100, Peter Ujfalusi wrote:
> In order to be able to add device tree support for leds-pwm driver we need
> to rearrange the data structures used by the drivers.
>=20
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/leds/leds-pwm.c | 39 +++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index 351257c..02f0c0c 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -30,6 +30,11 @@ struct led_pwm_data {
>  	unsigned int		period;
>  };
> =20
> +struct led_pwm_priv {
> +	int num_leds;
> +	struct led_pwm_data leds[];
> +};

I think you want leds[0] here. Otherwise your structure is too large by
sizeof(struct led_pwm_data *).

> +
>  static void led_pwm_set(struct led_classdev *led_cdev,
>  	enum led_brightness brightness)
>  {
> @@ -47,25 +52,29 @@ static void led_pwm_set(struct led_classdev *led_cdev,
>  	}
>  }
> =20
> +static inline int sizeof_pwm_leds_priv(int num_leds)

Perhaps this should return size_t?

> +{
> +	return sizeof(struct led_pwm_priv) +
> +		      (sizeof(struct led_pwm_data) * num_leds);
> +}
> +
>  static int led_pwm_probe(struct platform_device *pdev)
>  {
>  	struct led_pwm_platform_data *pdata =3D pdev->dev.platform_data;
> -	struct led_pwm *cur_led;
> -	struct led_pwm_data *leds_data, *led_dat;
> +	struct led_pwm_priv *priv;
>  	int i, ret =3D 0;
> =20
>  	if (!pdata)
>  		return -EBUSY;
> =20
> -	leds_data =3D devm_kzalloc(&pdev->dev,
> -			sizeof(struct led_pwm_data) * pdata->num_leds,
> -				GFP_KERNEL);
> -	if (!leds_data)
> +	priv =3D devm_kzalloc(&pdev->dev, sizeof_pwm_leds_priv(pdata->num_leds),
> +			    GFP_KERNEL);

I'm not sure if sizeof_pwm_leds_priv() requires to be a separate
function. You could make it shorter by doing something like:

	size_t extra =3D sizeof(*led_dat) * pdata->num_leds;

	priv =3D devm_kzalloc(&pdev->dev, sizeof(*priv) + extra, GFP_KERNEL);

But that's really just a matter of taste, so no further objections if
you want to keep the inline function.

Thierry

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxtz1AAoJEN0jrNd/PrOhUU4P+gLJHgWtDm0s/NCnexXBdCrf
vzMxNBFgJ2yE8onyjjY7xBmb1gcPNZrjM92lTyy87mz6USNcq9EI5nNFzgZysGUQ
NxsEOlYD2EZ3FNi/9cdhq3T9EOR+G57HetqCvimoOdl7ZMGZ8DDKOADk/Wx25juX
lHotDE6l9Fcv8z4ObUZR3Nvr0SCU+4pal+q19qHWmeGjVFatB8zStqpNDBpv00ta
i3Q1TFOeDe7+WZhnMdL9vX5P5Lumlly1idZCd0s70mqJPB54eZId4qiKz2xWyOnl
Jgl0I8bifWCmRLBobEcwYtynHAnRoxni+JfkXxRp9jju2Sa7EtsQOJ+fxhLOLZ1O
pLoBcqNvhOPzWjn2lqacamp29ioHkyOR9ZxI/sa5d+7YWlujBMMqErIHcd2PknHb
Y6j4XdQM9Oyp2xiw4T7DIlt1VaNXqkEL7dD4+GjpH3AUSN6vRyr5sppvBJiqkaqR
Cr2Avy+64Hwnwnbq9wSi27t/rXmhFeQBbNqiCQ2cQRiKJQiGHf84JqbWMlBuqx/z
0oTQQwGhy7WdRuyObep2+t0ir0ZPT7ZH+XsMym/Ha8b5MyHqToMUdj08DiLDPylq
C700jKySZhoFHR0yWM4d1X0NJHb0uBlz2W6tckiY3k5L2148qhlBKK8xnVLZNDi3
dLhVV8MIKcZ66NwLvumq
=NODy
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
