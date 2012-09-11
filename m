Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2IKGTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:19:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2IKGTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:19:06 -0400
Date: Tue, 11 Sep 2012 08:19:01 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: Re: [PATCH] pwm: Fix compilation error when CONFIG_PWM is not defined
Message-ID: <20120911061901.GA24260@avionic-0098.mockup.avionic-design.de>
References: <1347343464-15417-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1347343464-15417-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:T0EDaQJ0w/APc/nA5C2cfQDHbbLe8D0yGTUx3jNknTa
 a0ESJVSGbJPFjbo0n2ih81rQ713qsll4H+TkS3HFTfaq9u3SQU
 6huyJ05I3aqeWYq0V1izWp9W0U/CgDmM/WVJc8Ukakg5Rx36de
 EjyQ0xl946BkyGyRNrCObv6RdFg408WOk8S54/DL5Ntnf0q4Ll
 C3mVyzPWUV7mjbgTN0twQsp4aYqLRIP6mrBdBsckOMMDoFvjyH
 c/oOJUq3OzAksl7q6APdMH+joA9ZHungDQlE6dUf6egk+tIlAO
 2htzSN0jXElHMPkVeAyNaCm6sGAZ5HuGUYtIDSoTrQmFaq5HfW
 nm5yKcHD0lBjuROaCktGwoxsnPT5g5McALJPKZJf0g/qVL4uoB
 qA2Vp185hDC6GoYwPJNVhuA5aBcxqHdCMQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 11:34:24AM +0530, Tushar Behera wrote:
> As per Documentation/pwm.txt, PWM_LOOKUP and pwm_add_table are used in
> board support files to add PWM chip entries. Currently these
> definitions are protected within CONFIG_PWM macro in
> include/linux/pwm.h.
>=20
> Otherwise, we have to add ifdef's in machine file to fix following
> compilation error.
>=20
> error: array type has incomplete element type
> error: implicit declaration of function =E2=80=98PWM_LOOKUP=E2=80=99 [-We=
rror=3Dimplicit-function-declaration]
> error: implicit declaration of function =E2=80=98pwm_add_table=E2=80=99 [=
-Werror=3Dimplicit-function-declaration]
> error: bit-field =E2=80=98<anonymous>=E2=80=99 width not an integer const=
ant

I think it would make more sense to have the board's Kconfig option
select PWM instead. After all if you're defining a lookup table you
probably want to use it as well.

Eventually I was going to rework the pwm.h a bit to safely compile
out if the PWM symbol is not selected, similar to how the GPIO or
clock subsystems do this. Something like your patch will be part of
that but more needs to be done. If you feel up to it, maybe you can
take this patch further and provide dummies for all the remaining
functions as well.

If you do that, one additional comment below.

> Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  include/linux/pwm.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 21d076c..87e7f45 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -124,6 +124,7 @@ struct pwm_device *pwm_request_from_chip(struct pwm_c=
hip *chip,
> =20
>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
>  void pwm_put(struct pwm_device *pwm);
> +#endif
> =20
>  struct pwm_lookup {
>  	struct list_head list;
> @@ -141,8 +142,10 @@ struct pwm_lookup {
>  		.con_id =3D _con_id,			\
>  	}
> =20
> +#ifdef CONFIG_PWM
>  void pwm_add_table(struct pwm_lookup *table, size_t num);
> -
> +#else
> +static void pwm_add_table(struct pwm_lookup *table, size_t num) {}
>  #endif

This should be "static inline" and I prefer to have the {} on separate
lines.

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQTtfVAAoJEN0jrNd/PrOhFR0P/Al+ypQ60Lhd2dRuiG9Z50wt
0VjXJil9N+Zu4UO9hxlBrdcpY77Klw61rfg/EGa0WosCWZPwZNN/QUKLc7GcE/jt
dvrDNZhDz/n3jXHCx/gPYmfELf3x51YSVJQyIUu5JkzkQbiPo0HsdbHe2jC2btz/
vSgDCsbuA242K7M9Qv8xx/TUTCKS68TVIVXtTZ287uSOsc841Es14QQ87NE5o5rc
WSNlMh1emSw+OxN5zb6R01swneSQtaaL3u/CVSX9AbtqJCu6jJTyDXjkb7JGi47D
bi+wRcWNN0nxDv4p4IfYFUjVivg9GK7Ypfq+bzWp1YhDRjzmGag9EBXGntjaR+Me
3z8ZahMATNIwd0B6w1/W11pLG+t78KGYAf/9SvTNl0FksGRpkw6bD0J99msuOr3G
dAsRT4X1GOOT7bDLGmpbcY2cGw4Q2369VmAH9LKKF3CyR1fn2J2PuShS07LU0ALM
3xgzKfIq09QxDk3fl4zpOV/VHuTuXqTWq+6i4QwrDmUcNAZULjOLaBbDyet39fhL
CPoizkLWBAB01cLbJmpZmFjnwM4PSroKr06SShRpexkGaEMSCgV7KA8bqWT3vroD
AgirdV8F5i5bVVlA215MgIYRiSE1Ot5H3mnYC8kbgLFHExz8w8M6E+G96q+A8DHg
K0sWZBzfyEn13pJaEKjF
=SU5Z
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
