Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab2GWIan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:30:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab2GWIal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:30:41 -0400
Date: Mon, 23 Jul 2012 10:30:32 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, nsekhar@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH] PWM: Add support for configuring polarity of PWM
Message-ID: <20120723083032.GA12868@avionic-0098.mockup.avionic-design.de>
References: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1342616053-7793-1-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:doRNttArmhvuB3bs8HGcYPMfIFgX7tT4qS0dZZIn94c
 kZ3hHdgZwG89FtrcHkP1TGFyXWia3RwHRJbqPl9UmcRN47RWMt
 f2b+38Q2OlevJ9XgDHsWqZcRz4VSc+s8+5Z95Iu3NEp/foIpww
 PFFHzCmEmXbOmngehwNtCM+CKi6YX3cr+P87SBO4BpYxnxyPfY
 nWY+5FxVfVzeO54O9gDG4V795U+mnPn78Z9bnSJo2gekuUEVTH
 qnelPf6sW/vQUZcv2rSTshdfEqANcDlO5D5/xDopD5OGXlBtu2
 qLB/11/hY55N0toWPuVH8sEksvk5vYJbMtyR2tIgU2v798EvJC
 sB2FcP8W8yE5OC66eWjPJLPtVT8Jjps35RkifSKrrnUjOLJMrg
 qqTPY99n10FsFTFxlHphyoh3Tdluqa+F0Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2012 at 06:24:13PM +0530, Philip, Avinash wrote:
> Duty cycle inversion of PWM wave should achieved through PWM polarity
> inversion. Also polarity of PWM wave should configurable from slave
> drivers,

Actually, I don't think that duty cycle inversion *should* be achieved
through polarity inversion. But it is true that the same effect *can* be
achieved by inverting the polarity.

> Configure polarity
> 1. PWM_POLARITY_NORMAL  -> duty ns defines ON period of PWM wave
> 2. PWM_POLARITY_INVERSE -> duty ns defines OFF period of PWM wave.

Similarly, this text describes how polarity inversion can be used to
simular duty cycle inversion.

I think you should describe that this change adds support for
configuring the PWM polarity. If you absolutely must note that it can be
used to simulate the duty cycle inversion, then you can give it as an
example below the actual description.

> This patch adds support for configuring PWM polarity in PWM frame work.

"framework" is one word.

>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> Configuring polarity to be done with PWM device disabled, if not
> failure reported.
>=20
> If PWM device is enabled while configuring polarity, disabling and
> re_enabling make it complex. Whoever uses this API has to taken
> care of the basic rules.

These comments belong in the commit message because they are very useful
information about the change that you introduce. They probably belong
somewhere in the code as well.

> Discussions related to this can found at
> http://www.spinics.net/lists/kernel/msg1372110.html

Here's my proposal for a revised commit message:

	pwm: Add support for configuring the PWM polarity

	Some hardware supports inverting the polarity of the PWM signal. This
	commit adds support to the PWM framework to allow users of the PWM API
	to configure the polarity. Note that in order to reduce complexity,
	changing the polarity of a PWM signal is only allowed while the PWM is
	disabled.

	A practical example where this can prove useful is to simulate inversion
	of the duty cycle. While inversion of polarity and duty cycle are not
	exactly the same, the differences for most use-cases are negligible.

> :100644 100644 ecb7690... 24d5495... M	drivers/pwm/core.c
> :100644 100644 21d076c... 2e4e960... M	include/linux/pwm.h
>  drivers/pwm/core.c  |   32 ++++++++++++++++++++++++++++++++
>  include/linux/pwm.h |   15 +++++++++++++++
>  2 files changed, 47 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> index ecb7690..24d5495 100644
> --- a/drivers/pwm/core.c
> +++ b/drivers/pwm/core.c
> @@ -379,6 +379,38 @@ int pwm_config(struct pwm_device *pwm, int duty_ns, =
int period_ns)
>  EXPORT_SYMBOL_GPL(pwm_config);
> =20
>  /**
> + * pwm_set_polarity() - change PWM device Polarity

Maybe: "pwm_set_polarity() - configure the polarity of a PWM signal"

> + * @pwm: PWM device
> + * @polarity: Configure polarity of PWM

"new polarity of the PWM signal"

> + *
> + * Polarity to be configured with PWM device disabled.

"Note that the polarity cannot be configured while the PWM device is
enabled."

> + */
> +int pwm_set_polarity(struct pwm_device *pwm, int polarity)

The polarity parameter should be an enum pwm_polarity, see below.

> +{
> +	int pwm_flags =3D PWM_POLARITY_NORMAL;

I don't think this is needed.

> +
> +	if (!pwm || !pwm->chip->ops->set_polarity)
> +		return -EINVAL;

I'd prefer -ENOSYS if .set_polarity is not implemented, so this check
should probably be split up:

	if (!pwm || !pwm->chip || !pwm->chip->ops)
		return -EINVAL;

	if (!pwm->chip->ops->set_polarity)
		return -ENOSYS;

> +
> +	if (test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		dev_err(pwm->chip->dev,
> +			"Polarity configuration Failed!, PWM device enabled\n");
> +		return -EBUSY;
> +	}

Maybe something like: "polarity cannot be configured while PWM device is
enabled"? Though I'm not sure the error message is all that useful. I'd
expect the user driver to handle -EBUSY specially.

> +
> +	if (polarity =3D=3D PWM_POLARITY_INVERSE)
> +		pwm_flags =3D PWM_POLARITY_INVERSE;
> +
> +	if (!pwm_flags)
> +		clear_bit(PWMF_POLARITY_INVERSE, &pwm->flags);
> +	else
> +		set_bit(PWMF_POLARITY_INVERSE, &pwm->flags);

You can make this decision based on the value of polarity, no need for
the additional variable. Also as I mention below, maybe this flag isn't
all that useful.

> +
> +	return pwm->chip->ops->set_polarity(pwm->chip, pwm, polarity);
> +}
> +EXPORT_SYMBOL_GPL(pwm_set_polarity);
> +
> +/**
>   * pwm_enable() - start a PWM output toggling
>   * @pwm: PWM device
>   */
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 21d076c..2e4e960 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -21,6 +21,16 @@ void pwm_free(struct pwm_device *pwm);
>   */
>  int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> =20
> +enum {
> +	PWM_POLARITY_NORMAL,	/* ON period depends on duty_ns */
> +	PWM_POLARITY_INVERSE,	/* OFF period depends on duty_ns */
> +};

You should name this enumeration so that it can actually be used as a
type (enum pwm_polarity). Also you can drop the comments because they
only apply to the specific use-case of simulating duty-cycle inversion.

Maybe you can put a comment above the enum, but I think if you name it
pwm_polarity, the meaning will be quite obvious.

> +
> +/*
> + * pwm_set_polarity - set polarity of PWM device
> + */
> +int pwm_set_polarity(struct pwm_device *pwm, int polarity);
> +

The enumeration and this prototype need to move inside the #ifdef
CONFIG_PWM block because they are not available in the legacy API.
Also as indicated above you should change the type of the polarity
parameter to "enum pwm_polarity".

>  /*
>   * pwm_enable - start a PWM output toggling
>   */
> @@ -37,6 +47,7 @@ struct pwm_chip;
>  enum {
>  	PWMF_REQUESTED =3D 1 << 0,
>  	PWMF_ENABLED =3D 1 << 1,
> +	PWMF_POLARITY_INVERSE =3D 1 << 2,

This should be named PWMF_POLARITY_INVERSED for consistency. I'm not
sure that we really need this flag, though. It isn't used anywhere. But
maybe you have a use-case in mind?

>  };
> =20
>  struct pwm_device {
> @@ -66,6 +77,7 @@ static inline unsigned int pwm_get_period(struct pwm_de=
vice *pwm)
>   * @request: optional hook for requesting a PWM
>   * @free: optional hook for freeing a PWM
>   * @config: configure duty cycles and period length for this PWM
> + * @set_polarity: configure polarity of PWM

"configure the polarity of this PWM"

>   * @enable: enable PWM output toggling
>   * @disable: disable PWM output toggling
>   * @dbg_show: optional routine to show contents in debugfs
> @@ -79,6 +91,9 @@ struct pwm_ops {
>  	int			(*config)(struct pwm_chip *chip,
>  					  struct pwm_device *pwm,
>  					  int duty_ns, int period_ns);
> +	int			(*set_polarity)(struct pwm_chip *chip,
> +					  struct pwm_device *pwm,
> +					  int polarity);

Make sure these line up properly.

Thierry

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQDQuoAAoJEN0jrNd/PrOh/ZgP/3aFysZaV5ec+itaVSh/3CZz
M7rr0Kl9oYpbRYCmC4gCZHTO1SuM/HNZwE7M4S2Asoj2N4FFYQvASv7wpyHMN8cO
nhIXuGzyhi69rjkIOaBQ3AWryZr5tLfwEc9rzUriwWFouKGjkfOXSOnTsN6pjzO2
44B+GvgjJIutVE0yUhc75DQQ55rd9ivmQtotboQS+ZZ+5muORIhD0WDgDck7X4Dl
fSjmgFIM9deY346A1XZAHuhmcf7uL5Gd+/OUiBQvX/x8rTQdxjS0dyT0WwiEgwJZ
kLxJRNIx+msmZzJ9NKf9hqMNqGjzpHD7zw/jMDLKmQWipjI6MsU23f/GabNYOrKB
9TuNBbsX8lCIt6g5P7gSHgiuLIRlpAgQvIoedWjqyUFuTj5+MbQoyFgt/L6hmY03
c9shFy4rVhXfUFVtnWfPvOV+66WBLgy+KNr1WIrUCbR0kJ2uAfTcHED4F2ssdHU2
1GjpojX3AQA0zXvjy/kj3x4oj2akb3YRfwtX9pBZLGP/Y2MhRUeJHfNQ9VH9KmcB
buC8l/ps5NKxBO+APtzcAthK5yfIECpm8QE1ny7urgApHAD0N8ln3fD29k4AEXaP
cfEiL6JoMPOfg3IcUxJkM4SjwwfUgHoPqdz6AJPBYcypHUYZ+WO8CMxl8N9lNjNF
CeaoPcHUYflD+VkPEG1b
=G9wH
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
