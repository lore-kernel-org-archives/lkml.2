Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2JSIVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:21:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60746 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2JSIVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:21:15 -0400
Date: Fri, 19 Oct 2012 10:21:07 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] lp855x_bl: use generic PWM functions
Message-ID: <20121019082107.GA20659@avionic-0098.mockup.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F6417916D@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F6417916D@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NFbUdjsaPO/ehfU7NK5zubnr1WYKV2/bQlTx7S85hnQ
 ymHLsST1NES4nfp0YhPFwpGSDIEu+Rdn1SZ4MF1XQlvi0n8DNu
 8vG+aL6RvXuMvahWzhRJf3gCyDygFK9ROnQruIG8ovTio3PmkL
 h+VmNJV6/3TAJdeoKtGY7R11Q2jypnkWYMx0f4wqyVeDxJL+N4
 aSQZFx36jBVPd+nKsakHtgO4yFDYESBJ4RiAJwrm1j7o+9dAlJ
 u+cHipJGAWOC37fguMBVw2+t1whR1bnWJWzigMWoGQWcfrnoUZ
 sAaE/LY7suqvZKQQTg/aIJqIdKM0MEKeGYI7XxFHr03swGjViw
 5Ee6Zhw83VEyO3ucmZNFp0vPmDZAHv1uwUO6/fee7dbD1unkd+
 QmdnV4mhxPRmhmJq0allTRbuYLO5nD9Fbo6BtTqk6obyr28TpJ
 9VN/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 19, 2012 at 08:11:50AM +0000, Kim, Milo wrote:
>  The LP855x family devices support the PWM input for the backlight contro=
l.
>  Period of the PWM is configurable in the platform side.
>  Platform specific functions are unnecessary anymore because
>  generic PWM functions are used inside the driver.
>=20
>  (PWM input mode)
>  To set the brightness, new lp855x_pwm_ctrl() is used.
>  If a PWM device is not allocated, devm_pwm_get() is called.
>  The PWM consumer name is from the chip name such as 'lp8550' and 'lp8556=
'.
>  To get the brightness value, no additional handling is required.
>  Just the value of 'props.brightness' is returned.
>=20
>  If the PWM driver is not ready while initializing the LP855x driver, it'=
s OK.
>  The PWM device can be retrieved later, when the brightness value is chan=
ged.
>=20
>  Documentation is updated with an example.
>=20
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Generally this looks good. Obviously you'll need to update any users of
this driver as well. It might make sense to include those changes in
this patch to avoid interim build failures.

Other than that I have just one smaller comment below.

> @@ -121,6 +123,25 @@ static int lp855x_init_registers(struct lp855x *lp)
>  	return ret;
>  }
> =20
> +static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
> +{
> +	unsigned int period =3D lp->pdata->period_ns;
> +	unsigned int duty =3D br * period / max_br;
> +	struct pwm_device *pwm;
> +
> +	/* request pwm device with the consumer name */
> +	if (!lp->pwm) {
> +		pwm =3D devm_pwm_get(lp->dev, lp->chipname);
> +		if (IS_ERR(pwm))
> +			return;
> +
> +		lp->pwm =3D pwm;
> +	}
> +
> +	pwm_config(lp->pwm, duty, period);
> +	duty =3D=3D 0 ? pwm_disable(lp->pwm) : pwm_enable(lp->pwm);

This is really ugly and should be written explicitly:

	if (duty =3D=3D 0)
		pwm_disable(lp->pwm);
	else
		pwm_enable(lp->pwm);

Thierry

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQgQ1zAAoJEN0jrNd/PrOheUIQAIeqjlQMGQgJXl6/4Ca0gPXU
wvVG0etq0s5C34yHbdp/WLJ0/RSfhH2Jhrv9c94X3uQTWa426EPPIgHihWahsSaw
hIPOddpbUZ8eEHhz2mZ1gL6RTOsvRNUaq/0mjigCmqDutWxejisgVN19mX9tmhOm
r3LG7GrAYr7kL6B6p7OPbMSlfIc/dSG5InRGgJuvr4PNE5LLB6l/cr3NK53hNyH3
bymHtcUVOGnush2LrdI5dSiade9dI9pWr/oOwifVDJMq3uOiP3mdmqjEJtodGf3O
/HDWhEHt6psSC8ipemw8X/FD83hYr1MgO97bgwTS/WfDwGN0vSKtStR0lMxImG5A
zqTn0k/RRwZAj0oGtYVIK5HF9/kLuHjgiklGOoifjszZ4xR4MYR+jVKPKZBloJA5
vID80lbrMy0M9ueJczJ3xfQ33m9UOrYV5QH1WCp4FYMj/f9OciLuBXYXW20FpSSp
WWT6fPDV3SPooRtOdBoIN0ABhT0T9uspDTc4rslyCNX/XpWrLo4SYt5c0h5cePmr
mF+4cL5tiZAa4KH7gknxs92OtR5JkO+SexawRiYZj/gzG1tB+uphG6+nfZdHHqaG
AF8aR8Bxxd3pKijESAZdgMuxCRfQYjR9l8KfnllhPPLHdh2LxNYEBPzGDEyr+7g4
cx/lb2f40eU/OvxXJv7Z
=c22V
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
