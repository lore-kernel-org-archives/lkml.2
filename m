Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2ILJl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:41:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64740 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab2ILJl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:41:58 -0400
Date: Wed, 12 Sep 2012 11:41:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: Re: [PATCH v3] pwm: Fix compilation error when CONFIG_PWM is not
 defined
Message-ID: <20120912094151.GA21786@avionic-0098.mockup.avionic-design.de>
References: <1347440412-17249-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1347440412-17249-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6TXgEVGFOIrnXzCpNxeChfBn7UkY6Up6UEFpXJnAUdX
 ebrIg5Cu+pYr/zlrFKNaLvyivxVj1SID2o2nU81b2yjbDkxeeT
 ub6OaJ9qRbKrKxpKpwH3oSHzirRFW8xe//YQ5jXtXVwqi33Osz
 cOqMUtlJpVZulkBCd2frzY5nK+9/r/jxDjULuApa47N6x9iok6
 Fw54WVwlIAJxiG6sgEa8mIaDrB07AF+TFZwPVwH6eogqAZL1CJ
 90qn0bifeto6khQhRnhy5lAEyvK03jx8hr9vOZzikfXYwBKfY4
 BU1O2YJy/NaQs/YIfhNZpNRQwIYJCyOjKJYFBSKIoBFyXLRInG
 rZZolYJ7VsjcffBDJ/X6iFmsplDzHu1o4Ecx+IQ/m95FCpoHOG
 Tq81JoSVVBdZ7Mcb/hL1o9+f+/IN2L2cigC/WxO7K6xFkFJdoH
 JNq8p
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 12, 2012 at 02:30:12PM +0530, Tushar Behera wrote:
> Add dummy implemention of public symbols for compilation-safe inclusion
> of include/linux/pwm.h file when CONFIG_PWM is not defined.
>=20
> Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Changes since v2:
> * #if condition for legacy functions modified
> * Reverted layout changes, can be taken up when HAVE_PWM is no longer
> required.
>=20
> Changes since v1:
> * Incorporated Thierry's suggestions regarding adding dummy function
> implemention for all global functions
> * Reorganized header file to have structure definitions first and then the
> function definitions.
>=20
>  include/linux/pwm.h |   69 +++++++++++++++++++++++++++++++++++++++++++++=
+++--
>  1 files changed, 66 insertions(+), 3 deletions(-)

This is starting to look real good. Two more things I forgot to mention
on the last round. And one nitpick.

> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 21d076c..2c5daa9 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -6,6 +6,7 @@
>  struct pwm_device;
>  struct seq_file;
> =20
> +#if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
>  /*
>   * pwm_request - request a PWM device
>   */
> @@ -30,8 +31,29 @@ int pwm_enable(struct pwm_device *pwm);
>   * pwm_disable - stop a PWM output toggling
>   */
>  void pwm_disable(struct pwm_device *pwm);
> +#else
> +static inline struct pwm_device *pwm_request(int pwm_id, const char *lab=
el)
> +{
> +	return NULL;
> +}
> +
> +static inline void pwm_free(struct pwm_device *pwm)
> +{}

These should also go on separate lines. I should have been more clear
about that. So:

	static inline void pwm_free(struct pwm_device *pwm)
	{
	}

There are a couple more of these below.

> +
> +static inline int pwm_config(struct pwm_device *pwm, int duty_ns, int pe=
riod_ns)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int pwm_enable(struct pwm_device *pwm)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline void pwm_disable(struct pwm_device *pwm)
> +{}
> +#endif /* !(IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)) */

I don't think this comment is necessary. Most editors allow you to jump
to the matching #if or #else. Mostly these comments just confuse me.

> =20
> -#ifdef CONFIG_PWM
>  struct pwm_chip;
> =20
>  enum {
> @@ -113,6 +135,7 @@ struct pwm_chip {
>  	unsigned int		of_pwm_n_cells;
>  };
> =20
> +#if IS_ENABLED(CONFIG_PWM)
>  int pwm_set_chip_data(struct pwm_device *pwm, void *data);
>  void *pwm_get_chip_data(struct pwm_device *pwm);
> =20
> @@ -124,6 +147,43 @@ struct pwm_device *pwm_request_from_chip(struct pwm_=
chip *chip,
> =20
>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
>  void pwm_put(struct pwm_device *pwm);
> +#else
> +static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline void *pwm_get_chip_data(struct pwm_device *pwm)
> +{
> +	return NULL;
> +}
> +
> +static inline int pwmchip_add(struct pwm_chip *chip)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline int pwmchip_remove(struct pwm_chip *chip)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline struct pwm_device *pwm_request_from_chip(struct pwm_chip *=
chip,
> +		unsigned int index,
> +		const char *label)
> +{
> +	return NULL;
> +}
> +
> +static inline struct pwm_device *pwm_get(struct device *dev,
> +		const char *consumer)
> +{
> +	return NULL;
> +}

Can you align the split parameter list on subsequent lines with the
first parameter, please? Like so:

static inline struct pwm_device *pwm_request_from_chip(struct pwm_chip *chi=
p,
						       unsigned int index,
						       const char *label)

static inline struct pwm_device *pwm_get(struct device *dev,
					 const char *consumer)

Thierry

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQUFjfAAoJEN0jrNd/PrOhkqAQAKi0HZqWmdfNRjWIRM6d44fJ
Bj8Yyv304zUi1ixMPlz09/rW8gmeUvEQfkj1JR4EwRqv3lRrty0fImhsXvQXvUok
PuFPSsNgrd4zjGqZrzMqgDZCFno+AgYS3STEUMX1CN6QBOzb1eKqkfB2NzrWzfvv
BOLY3MCnTFgSNwnYErRNq5cjeH4su5VN2QVMy9b03Zek6Bhc8zTBlssn8SQlyJ0b
5QnlNYIyLLdxIMpHEJb53XyN5Ngn6sQAorcWXSLVWqhVjNeYlbSE7TLwUmtC/3Qr
keH25rLQnaXy0sZH60gsL/nhyemTSJ/34RMdCAu7Gpd/sLPJ1AHh1qqLgkaynTQV
MEdEZXe7jtYgbP5yFJAOQeXKsBV1gHfAcA/+F3IfasQshmB0r2Ys51KqVEYtLbK3
fFysL8WwlpIfktaiUECVAEBGo5HPPj0b1zpQzoesQpxYi2IB8aNhydW+eTBpRO05
SuDD9h3oUehTUj7MVD7YAB8AqjhphU2KyqMRVcyr0BJ7WpEI5218z/r798r5DT26
bhPERFs7a4EcvkKVJxScDux3rTotImd2Y/mjgcUTUojCTwBaVKvHgmhnzQFhi8fj
7f7BtKt0AEBFxOVLPu6VJs0/3gWlkUw3zEbgbu3RFkLpnrkDVoTvPU06lIcO1PBL
5kuCuuC9dNtC4FOf5RZS
=ss9r
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
