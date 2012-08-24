Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2HXQxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:53:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2HXQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:53:18 -0400
Date: Fri, 24 Aug 2012 18:53:14 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com, gururaja.hebbar@ti.com
Subject: Re: [PATCH 2/2] pwm: pwm-tiehrpwm: Add support for configuring
 polarity of PWM
Message-ID: <20120824165314.GA21435@avionic-0098.mockup.avionic-design.de>
References: <1345705251-10942-1-git-send-email-avinashphilip@ti.com>
 <1345705251-10942-3-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <1345705251-10942-3-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:aGNYIf3jS8l9pk8F6KGrdKCY7jyRDoLMJR0djJA8d+N
 z4bFBwqXi2X6YJKbZNuQlB9qslHZPqMcAFuJccadyiGC/24fvK
 NaBiT5BHWhSVriCR7lCKVNG4nIA4GrNCTPbn9LiR7JZkPvrM5P
 Wk/fmwpCaZFBivwu/wOkRY8BjMdatN+sdWX34+XLyoWpld2kJs
 yLHOhLnQsIh7LhdSwXsSpNBS50PcLaSkPCaVoQnvdLvLrWwTRw
 THO/2mmZOhhcq1zP0OTAHPzpQb1K0MkYO9g0oqZSc8HkS27GrN
 45EBBEX8jDTCyFiZd8A60HO92KTIjq5F6QuxLD0DxTcYcqAYhV
 lu65VEFVqA94ufTVtQOjxETwd5AWnly1nL0ZOYLx6wh8GDnXFB
 UlS/dqnmtLAP5bG/iSU6yZ1BHp9Dg8S8UU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 23, 2012 at 12:30:51PM +0530, Philip, Avinash wrote:
[...]
> diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
[...]
> @@ -100,10 +109,17 @@
> =20
>  #define NUM_PWM_CHANNEL		2	/* EHRPWM channels */
> =20
> +enum config {
> +	config_dutycycle,
> +	config_polarity,
> +};
> +

I don't think this makes sense, see below.

> @@ -165,38 +181,50 @@ static int set_prescale_div(unsigned long rqst_pres=
caler,
>  }
> =20
>  static void configure_chans(struct ehrpwm_pwm_chip *pc, int chan,
> -		unsigned long duty_cycles)
> +		enum config config)
>  {
> -	int cmp_reg, aqctl_reg;
> -	unsigned short aqctl_val, aqctl_mask;
> +	if (config =3D=3D config_dutycycle) {
> +		int cmp_reg;
> +
> +		if (chan =3D=3D 1)
> +			/* Channel 1 configured with compare B register */
> +			cmp_reg =3D CMPB;
> +		else
> +			/* Channel 0 configured with compare A register */
> +			cmp_reg =3D CMPA;
> +
> +		ehrpwm_write(pc->mmio_base, cmp_reg, pc->duty_cycles);
> +	} else if (config =3D=3D config_polarity) {
> +		int aqctl_reg;
> +		unsigned short aqctl_val, aqctl_mask;
> +
> +		/*
> +		 * Configure PWM output to HIGH/LOW level on counter
> +		 * reaches compare register value and LOW/HIGH level
> +		 * on counter value reaches period register value and
> +		 * zero value on counter
> +		 */
> +		if (chan =3D=3D 1) {
> +			aqctl_reg =3D AQCTLB;
> +			aqctl_mask =3D AQCTL_CBU_MASK;
> +
> +			if (pc->polarity =3D=3D PWM_POLARITY_INVERSED)
> +				aqctl_val =3D AQCTL_CHANB_POLINVERSED;
> +			else
> +				aqctl_val =3D AQCTL_CHANB_POLNORMAL;
> +		} else {
> +			aqctl_reg =3D AQCTLA;
> +			aqctl_mask =3D AQCTL_CAU_MASK;
> +
> +			if (pc->polarity =3D=3D PWM_POLARITY_INVERSED)
> +				aqctl_val =3D AQCTL_CHANA_POLINVERSED;
> +			else
> +				aqctl_val =3D AQCTL_CHANA_POLNORMAL;
> +		}
> =20
> -	/*
> -	 * Channels can be configured from action qualifier module.
> -	 * Channel 0 configured with compare A register and for
> -	 * up-counter mode.
> -	 * Channel 1 configured with compare B register and for
> -	 * up-counter mode.
> -	 */
> -	if (chan =3D=3D 1) {
> -		aqctl_reg =3D AQCTLB;
> -		cmp_reg =3D CMPB;
> -		/* Configure PWM Low from compare B value */
> -		aqctl_val =3D AQCTL_CBU_FRCLOW;
> -		aqctl_mask =3D AQCTL_CBU_MASK;
> -	} else {
> -		cmp_reg =3D CMPA;
> -		aqctl_reg =3D AQCTLA;
> -		/* Configure PWM Low from compare A value*/
> -		aqctl_val =3D AQCTL_CAU_FRCLOW;
> -		aqctl_mask =3D AQCTL_CAU_MASK;
> +		aqctl_mask |=3D AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
> +		ehrpwm_modify(pc->mmio_base, aqctl_reg, aqctl_mask, aqctl_val);
>  	}
> -
> -	/* Configure PWM High from period value and zero value */
> -	aqctl_val |=3D AQCTL_PRD_FRCHIGH | AQCTL_ZRO_FRCHIGH;
> -	aqctl_mask |=3D AQCTL_PRD_MASK | AQCTL_ZRO_MASK;
> -	ehrpwm_modify(pc->mmio_base,  aqctl_reg, aqctl_mask, aqctl_val);
> -
> -	ehrpwm_write(pc->mmio_base,  cmp_reg, duty_cycles);
>  }

I think it might be better to split this into two separate functions.
Both branches have absolutely no code in common, so splitting them off
would decrease the indentation level and make this much more readable
and wouldn't require the configuration enumeration from above.

> =20
>  /*
> @@ -254,12 +282,24 @@ static int ehrpwm_pwm_config(struct pwm_chip *chip,=
 struct pwm_device *pwm,
>  	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_CTRMODE_MASK,
>  			TBCTL_CTRMODE_UP);
> =20
> +	pc->duty_cycles =3D duty_cycles;
>  	/* Configure the channel for duty cycle */
> -	configure_chans(pc, pwm->hwpwm, duty_cycles);
> +	configure_chans(pc, pwm->hwpwm, config_dutycycle);
> +
>  	pm_runtime_put_sync(chip->dev);
>  	return 0;
>  }
> =20
> +static int ehrpwm_pwm_set_polarity(struct pwm_chip *chip,
> +		struct pwm_device *pwm,	enum pwm_polarity polarity)
> +{
> +	struct ehrpwm_pwm_chip *pc =3D to_ehrpwm_pwm_chip(chip);
> +
> +	/* Configuration of polarity in hardware delayed done at enable */
> +	pc->polarity =3D polarity;
> +	return 0;
> +}
> +

The problem here, which is true for both of the .set_polarity() and
=2Econfig() implementations is that both channels share a single duty
cycle and polarity. What if the two channels are configured with
conflicting settings? Shouldn't that at least give a warning or even
return an error?

>  static int ehrpwm_pwm_enable(struct pwm_chip *chip, struct pwm_device *p=
wm)
>  {
>  	struct ehrpwm_pwm_chip *pc =3D to_ehrpwm_pwm_chip(chip);
> @@ -283,6 +323,9 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, s=
truct pwm_device *pwm)
> =20
>  	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
> =20
> +	/* Channels Polarity can be configured from action qualifier module */
> +	configure_chans(pc, pwm->hwpwm, config_polarity);
> +

What's this "action qualifier module"?

Thierry

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQN7F6AAoJEN0jrNd/PrOhZRYQAIGI8G0YDVFnn/ROGMSOpDzG
wTHUrcuARjBiYtTmz1j2bC6QxKDmjO2Xge4LhxdmX4eRXVMLXdNDREIKSWf0S8zb
sfkYoIzR8ZowAjssDDMdQTCylv6PeVk+BqUvgK/8XTDdcoQqeDjnc9OmuTB0C5wH
zIwFSBiBzKWqvqa4aTJ/AV+mtf2zJNNu8YnlQhjrXeWcDNzVYYvJTTcK+c1PuwMJ
D49yERJ7es87c5uTf2M1Gc41T1m2TylbL6YrQTa4KBOeR3yeqHPPixZLqOKCt6+d
QJgFsSADDd4aLnv5hjxFnW2WFW82ip8WN4bDKLcOkyc2Ay+VlzT37Hgss+XdVd97
sgTXYaFpUSoLs3OKJytFszmz9lfshOQRQoEOI8OrkssYrnaF3V6gpNeztastKyYx
+E80lqAt57AGxaT4WnaI9+qn1rZJOf8wSxLqEZCNID70eWEBbieeeNA70NCUK7Pb
wlkpt8evPigGpLzUbkS69mOh6YW5Jvfzx21ptnlJu8nte8cbj0SNoMzlZkeaZDG+
YcJzKqEGDriBCRG2Y8FhH2x/Xx+8Pdlg0/HvF6F+ivL9EQsjxCwGSUbC1ohEbwEi
7ZlJHly0pb/iHoK3fjUpunzaSYlXpvprn7Jk+rNCR6S76rD9NwUZ3IhFOq5cJFpN
kp3ZkXF9vO3a420wndyd
=+MvC
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
