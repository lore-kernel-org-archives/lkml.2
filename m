Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2HAIFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:05:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2HAIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:05:00 -0400
Date: Wed, 1 Aug 2012 10:04:53 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: add devm_pwm_get() and devm_pwm_put()
Message-ID: <20120801080453.GJ29673@avionic-0098.adnet.avionic-design.de>
References: <1343806629-14397-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9aCKuHbn5v2q3RVc"
Content-Disposition: inline
In-Reply-To: <1343806629-14397-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NOj7o52ZycesKtFTRxSs9t5rYNxiaGdQvoD2Il9lwkW
 pg79PEI+vy27soYsg0rqEM785rN+lhhx+P+WAxTm6CNQOSpaCy
 JS6TNwwd8O9Sl9Wbo+OokgeYI0flKkaEJCA/GKgsErgzRlQyiN
 5b8d22g2y62nB6aT0+46HjseQmuzBdpoV3GnU/OHalDK+TJL0C
 o2OY3Ii/KsaOuINdGdjXvT/0GLwBRgU2h1oYTpEBFocgzx7zPy
 yWbW1Jgt9s+43Vfcqw22Gl+qNTOOiTiI6HtFlxXyyKj2VclUTy
 at+76zT0Lo3vBNAzu6GgyPeHUv1uAKsrrgy5zdCRQa9/EOPKpF
 gJkOq9MsJFF6w0m/WHe7XpMU9Mr5NxpmECfWUGuzOJoBQV+8J+
 gOmAg+eAjmlqUUH3Z0Hb4L7D/4FTfHIneQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9aCKuHbn5v2q3RVc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 01, 2012 at 04:37:09PM +0900, Alexandre Courbot wrote:
> Add resource managed variants of pwm_get() and pwm_put() for
> convenience. Code is largely inspired by the equivalent devm functions
> of the regulator framework.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  Documentation/driver-model/devres.txt |  4 +++
>  Documentation/pwm.txt                 |  5 +--
>  drivers/pwm/core.c                    | 57 +++++++++++++++++++++++++++++=
++++++
>  include/linux/pwm.h                   |  3 ++
>  4 files changed, 67 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver=
-model/devres.txt
> index 950856b..43cff70 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -284,3 +284,7 @@ CLOCK
>  PINCTRL
>    devm_pinctrl_get()
>    devm_pinctrl_put()
> +
> +PWM
> +  devm_pwm_get()
> +  devm_pwm_put()
> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> index 554290e..4719c12 100644
> --- a/Documentation/pwm.txt
> +++ b/Documentation/pwm.txt
> @@ -35,8 +35,9 @@ Using PWMs
>  Legacy users can request a PWM device using pwm_request() and free it
>  after usage with pwm_free().
> =20
> -New users should use the pwm_get() function and pass to it the consumer
> -device or a consumer name. pwm_put() is used to free the PWM device.
> +New users should use the pwm_get() or devm_pwm_get() function and pass t=
o it the
> +consumer device or a consumer name. pwm_put() or devm_pwm_put() is used =
to free
> +the PWM device.

I think I'd prefer the original text with an additional line mentioning
the managed variants.

> =20
>  After being requested a PWM has to be configured using:
> =20
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index ecb7690..5a5e19b 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -624,6 +624,63 @@ out:
>  }
>  EXPORT_SYMBOL_GPL(pwm_put);
> =20
> +static void devm_pwm_release(struct device *dev, void *res)
> +{
> +	pwm_put(*(struct pwm_device **)res);
> +}
> +
> +/**
> + * devm_pwm_get() - Resource managed pwm_get()

This is missing parameter descriptions here.

> + *
> + * This works are pwm_get() but the acquired pwm will automatically be r=
eleased

"works like"? Also "acquired PWM" or "acquired PWM device".

> + * on driver detach. See pwm_get() for more details.
> + */
> +struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer)
> +{
> +	struct pwm_device **ptr, *pwm;
> +
> +	ptr =3D devres_alloc(devm_pwm_release, sizeof(**ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	pwm =3D pwm_get(dev, consumer);
> +	if (!IS_ERR(pwm)) {
> +		*ptr =3D pwm;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +
> +	return pwm;
> +}
> +EXPORT_SYMBOL_GPL(devm_pwm_get);
> +
> +static int devm_pwm_match(struct device *dev, void *res, void *data)
> +{
> +	struct pwm_device **p =3D res;
> +
> +	if (WARN_ON(!p || !*p))
> +		return 0;
> +
> +	return *p =3D=3D data;
> +}
> +
> +/**
> + * devm_pwm_put() - Resource managed pwm_put()
> + *
> + * Releases a pwm previously allocated using devm_pwm_get. Calling this =
function
> + * is usually not needed as the devm-allocated pwm will automatically be
> + * released on driver detach.
> + */

Same comments as for devm_pwm_get().

> +void devm_pwm_put(struct device *dev, struct pwm_device *pwm)
> +{
> +	int ret;
> +
> +	ret =3D devres_release(dev, devm_pwm_release, devm_pwm_match, pwm);
> +	WARN_ON(ret);
> +}
> +EXPORT_SYMBOL_GPL(devm_pwm_put);
> +
>  #ifdef CONFIG_DEBUG_FS
>  static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
>  {
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 21d076c..af9c39a 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -123,7 +123,10 @@ struct pwm_device *pwm_request_from_chip(struct pwm_=
chip *chip,
>  					 const char *label);
> =20
>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
> +struct pwm_device *devm_pwm_get(struct device *dev, const char *consumer=
);
> +
>  void pwm_put(struct pwm_device *pwm);
> +void devm_pwm_put(struct device *dev, struct pwm_device *pwm);

Can the managed variants be grouped together, please?

Looks good otherwise. Thanks for taking care of it.

Thierry

--9aCKuHbn5v2q3RVc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGOMlAAoJEN0jrNd/PrOhBM4P/jVO9xPSVr51iTDIWo9ufnGZ
E8VtBuQi6xNs3HCme4cCMdVswWdilStWJxC6h52Ob7ImXUgBTIesgMB+Q5I5aVsZ
4E9wC6O9DDRg0uO3vWw6JwlK0UKoNs5aBy86sGqC52tw2pNN0RXouDahyyh30Nz+
u7Gv11ZivKxFeDGpTQnl7mxltYBL2kvqUchyMT8oivV1Sy4ato/r/4d0qYggQDfH
I6IwO5VVEVA4qd5W8rxWU+36lsypnpK56U1Z2Av2VBNbGCiXLCeaUGbBNu+dn3Yt
zuevvE/ud05RVaAEh+6xMyOGd9IO23b461hAB+5tvQ7j3uzgzuZ/gDP2TSxM8ZHa
ZD5tVEvPDuHxWDH216QeBkKEqeb8oRFkiK/o83Kmx2BW/5ZGgT2SGW2TqJzBxZxA
NAnojUYsPRLoNHOjGe2rA6Lnb68Ht9lDmltn5iTpbzIUmA0EAiF7YQ7zhPa6Yfjy
j/sCIJCKu11CiPZCx0pkNpn08hf+dQsmJ/MskHsgsY6zMUgIoMLnHEd0o6qXJoAy
UCwU08+XMW0rfU93r6619Psk+GOVzg7TXjxzJL8SmgcYYbEuygx9i4DspcFh03ky
RTLDyHiIZWQ+jko3XaENxrTOiB0Yl3lyW2x2yiGB57xZRpr7coFB0PyvpKuKM9PT
2xtbSDU9qGcEURdRIJgw
=q5eJ
-----END PGP SIGNATURE-----

--9aCKuHbn5v2q3RVc--
