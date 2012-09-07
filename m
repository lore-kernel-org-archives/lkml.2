Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2IGNFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:05:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54139 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2IGNFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:05:06 -0400
Date: Fri, 7 Sep 2012 15:04:05 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/9] pwm i.MX: factor out SoC specific functions
Message-ID: <20120907130405.GC29340@avionic-0098.mockup.avionic-design.de>
References: <1346935695-25179-1-git-send-email-s.hauer@pengutronix.de>
 <1346935695-25179-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <1346935695-25179-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:sZW/oYfz/Sjg/z81HBEC7WylGQAFYrHxEdfWFtBIpVK
 mnH2bH0XiFYEl07YLyRcQQJspDhjIYCsoz5qpVzc6QYwqzFYB5
 sx67VnDryq/pxx6tCj3kXfpRoVJk0LsGN5W8916OznsWQzOmiV
 cPR13LtqCtP4GXSCN4Wj//00b+NHt8WTQ1PKR8UXk/1hOME8XP
 hKiIBRO+fc/DS/Qmm426lSnIObFk863uCObE43a+pcGX7xfZZ3
 uRIHMnGyrMH2GX7vcxoILKDR0fNi0Uheu198Nm8OW93Ud4nNnN
 E9+CNF2H0onqyNo1+ZUzGbV7jYn+9MW5oV3k4CZ+kBnfEbw+kx
 z3jkKFvthdm56mklGenuSw9ldtp2tyxJVtssvPKYxt8R6JRCMR
 1sqeiQj/JE6+IJkHK94hZSQ9PiaFL+vvQg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 02:48:07PM +0200, Sascha Hauer wrote:
> To make the code more flexible.

The code isn't made much more flexible, but it is cleaned up quite a
bit. Maybe this should be mentioned instead. Or something along the
lines that these changes make it easier to support multiple variants
in the driver.

Also, can we please try to stick to the "pwm:" prefix for the subject. I
like to keep for consistency and because it makes filtering easier.
Furthermore I've been getting on people's nerves by telling them to use
the all uppercase "PWM" when referring to PWM devices (note the prefix
subject is still lowercase), so it would be unfair not to get on your
nerves as well. =3D)

One other comment inline.

> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Beno=C3=AEt Th=C3=A9baudeau <benoit.thebaudeau@advansee.com>
> ---
>  drivers/pwm/pwm-imx.c |  145 ++++++++++++++++++++++++++++---------------=
------
>  1 file changed, 82 insertions(+), 63 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index 2a0b353..38270f4 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -46,81 +46,95 @@ struct imx_chip {
>  	void __iomem	*mmio_base;
> =20
>  	struct pwm_chip	chip;
> +
> +	int (*config)(struct pwm_chip *chip,
> +		struct pwm_device *pwm, int duty_ns, int period_ns);
>  };
> =20
>  #define to_imx_chip(chip)	container_of(chip, struct imx_chip, chip)
> =20
> -static int imx_pwm_config(struct pwm_chip *chip,
> +static int imx_pwm_config_v1(struct pwm_chip *chip,
>  		struct pwm_device *pwm, int duty_ns, int period_ns)
>  {
>  	struct imx_chip *imx =3D to_imx_chip(chip);
> =20
> -	if (!(cpu_is_mx1() || cpu_is_mx21())) {
> -		unsigned long long c;
> -		unsigned long period_cycles, duty_cycles, prescale;
> -		u32 cr;
> -
> -		c =3D clk_get_rate(imx->clk);
> -		c =3D c * period_ns;
> -		do_div(c, 1000000000);
> -		period_cycles =3D c;
> -
> -		prescale =3D period_cycles / 0x10000 + 1;
> -
> -		period_cycles /=3D prescale;
> -		c =3D (unsigned long long)period_cycles * duty_ns;
> -		do_div(c, period_ns);
> -		duty_cycles =3D c;
> -
> -		/*
> -		 * according to imx pwm RM, the real period value should be
> -		 * PERIOD value in PWMPR plus 2.
> -		 */
> -		if (period_cycles > 2)
> -			period_cycles -=3D 2;
> -		else
> -			period_cycles =3D 0;
> -
> -		writel(duty_cycles, imx->mmio_base + MX3_PWMSAR);
> -		writel(period_cycles, imx->mmio_base + MX3_PWMPR);
> -
> -		cr =3D MX3_PWMCR_PRESCALER(prescale) |
> -			MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
> -			MX3_PWMCR_DBGEN | MX3_PWMCR_EN;
> -
> -		if (cpu_is_mx25())
> -			cr |=3D MX3_PWMCR_CLKSRC_IPG;
> -		else
> -			cr |=3D MX3_PWMCR_CLKSRC_IPG_HIGH;
> -
> -		writel(cr, imx->mmio_base + MX3_PWMCR);
> -	} else if (cpu_is_mx1() || cpu_is_mx21()) {
> -		/* The PWM subsystem allows for exact frequencies. However,
> -		 * I cannot connect a scope on my device to the PWM line and
> -		 * thus cannot provide the program the PWM controller
> -		 * exactly. Instead, I'm relying on the fact that the
> -		 * Bootloader (u-boot or WinCE+haret) has programmed the PWM
> -		 * function group already. So I'll just modify the PWM sample
> -		 * register to follow the ratio of duty_ns vs. period_ns
> -		 * accordingly.
> -		 *
> -		 * This is good enough for programming the brightness of
> -		 * the LCD backlight.
> -		 *
> -		 * The real implementation would divide PERCLK[0] first by
> -		 * both the prescaler (/1 .. /128) and then by CLKSEL
> -		 * (/2 .. /16).
> -		 */
> -		u32 max =3D readl(imx->mmio_base + MX1_PWMP);
> -		u32 p =3D max * duty_ns / period_ns;
> -		writel(max - p, imx->mmio_base + MX1_PWMS);
> -	} else {
> -		BUG();
> -	}
> +	/* The PWM subsystem allows for exact frequencies. However,

According to CodingStyle, this should be:

	/*
	 * The PWM subsystem...
	 * ...
	 */

I know the original had it wrong as well, but since you're changing the
lines anyway, would you mind fixing it anyway?

Thierry

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSfDFAAoJEN0jrNd/PrOhzQgP/Aye9bAowx8MXusW9CkEDuig
CUNC5fWewd4b1vAQIh2GmsHysDh6wg+iBZUrNS3/0OkS1uWNXJ1IS/Dcq7uUkgxA
Ymm8UL2X54mtE45cJbWfXA2CDDGSrQ7JEpwO0ZhXRKLSx09g1C2hi6EogwaGWWm6
mOUN9r8GL2FzpbT6PyJCboCqYez3y7UblaAjpSxllO8828ZUNzynJoH3oWDPbXi5
WWDC1p8/iRaMBZGbbdJhEeelxjBMnS0tvNzYjBjHOITK8nJVDF/o+rSTkG+pNJzt
mN/FROzCifR5oBmzDI9wvUDnynRdD+WpH4yX2p4ziJ/YF17IWtSycC/awP2mYsh+
FyN63VNaYmGSWxLpjb0Eu30r4xkOhK4K3uTZOQg39BbDLOb5Z7Lvy64WKwGh44dk
rkdICOTxb6p0m097d5tMA4JGSRwqbSkqLW7Susqy6xBq38z3Qtu2/v8OSeLuUpaI
w63fNcuHnrqYfnSRluv8f1MW0kGhq6PvI65YiT0KBKIU7SD1l1wrGWPqxkx9GB52
FXOGlB99IaMNqD8hxz2R1n09QNjrwHIfbntUHdvjbqOQWxikHJexThSWxtJJKo9B
llhb0LJfMbUA4aCJvBK514oW07v8o4nwfTi2/NsU2dDt/4CD810c+PjkQ186cR8B
UDi7YP87wBMgZvxZvXro
=JG3b
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
