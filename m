Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab2KIILS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:11:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2KIILO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:11:14 -0500
Date: Fri, 9 Nov 2012 09:11:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 08/10] pwm: pwm-tiehrpwm: Adding TBCLK gating support.
Message-ID: <20121109081104.GB26007@avionic-0098.mockup.avionic-design.de>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-9-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <1352361197-27442-9-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:dWLrXp5/m1m90XLzYWkpULf9ggYxhmwIv2XJ7k7wTRg
 WLkXaCs27jU7b3m8wE1zJ5b5wJLTn78zAbtP2D1gOThFadFxH3
 eHTRB89iQcto4/rPBKnPd1jG9tHr7FcCvRcXrixwBxXVRf81v9
 338yybFepQ+jSWpALJrtkfq85f67JpyEMTHXMhFZeAoNqdEK+8
 HAaFx4Lome7qgOQwzMqf/1CNtoOsspAx0q4dbtjcLQQ3nx0EaM
 JMYdlT9f76b/ih5l4w+Tzvmnj6/cJ8vy/urZSPmaZRPPvbBne9
 jnKwevUrucKCTQ0daX+ya94agxrx6eF8v0DkBvtTG7MhGB40dF
 6I9uKAOgfI2hwfOIKBO9DrpL/bvgN0fstdjE2wSpKM8w4p4Kv7
 3cJFW/CXSIN7DmYpfsMWp3Tjb4M4/2j5wM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 08, 2012 at 01:23:15PM +0530, Philip, Avinash wrote:
> Some platforms (like AM33XX) requires clock gating from control module
> explicitly for TBCLK. Enabling of this clock required for the
> functioning of the time base sub module in EHRPWM module. So adding
> optional TBCLK handling if DT node populated with tbclkgating. This
> helps the driver can coexist for Davinci platforms.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Cc:	Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> Changes since v1:
> 	- Moved TBCLK enable from probe to .pwm_enable & disable from
> 	  remove to .pwm_disable
>=20
> :100644 100644 07911e6... 927a8ed... M	drivers/pwm/pwm-tiehrpwm.c
>  drivers/pwm/pwm-tiehrpwm.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
> index 07911e6..927a8ed 100644
> --- a/drivers/pwm/pwm-tiehrpwm.c
> +++ b/drivers/pwm/pwm-tiehrpwm.c
> @@ -126,6 +126,7 @@ struct ehrpwm_pwm_chip {
>  	void __iomem	*mmio_base;
>  	unsigned long period_cycles[NUM_PWM_CHANNEL];
>  	enum pwm_polarity polarity[NUM_PWM_CHANNEL];
> +	struct	clk	*tbclk;
>  };
> =20
>  static inline struct ehrpwm_pwm_chip *to_ehrpwm_pwm_chip(struct pwm_chip=
 *chip)
> @@ -346,6 +347,13 @@ static int ehrpwm_pwm_enable(struct pwm_chip *chip, =
struct pwm_device *pwm)
>  	/* Channels polarity can be configured from action qualifier module */
>  	configure_polarity(pc, pwm->hwpwm);
> =20
> +	/*
> +	 * Platforms require explicit clock enabling of TBCLK has
> +	 * to enable TBCLK explicitly before enabling PWM device
> +	 */
> +	if (pc->tbclk)
> +		clk_enable(pc->tbclk);
> +
>  	/* Enable time counter for free_run */
>  	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_FREE_RUN);
>  	return 0;
> @@ -374,6 +382,10 @@ static void ehrpwm_pwm_disable(struct pwm_chip *chip=
, struct pwm_device *pwm)
> =20
>  	ehrpwm_modify(pc->mmio_base, AQCSFRC, aqcsfrc_mask, aqcsfrc_val);
> =20
> +	/* Disabling TBCLK on PWM disable */
> +	if (pc->tbclk)
> +		clk_disable(pc->tbclk);
> +
>  	/* Stop Time base counter */
>  	ehrpwm_modify(pc->mmio_base, TBCTL, TBCTL_RUN_MASK, TBCTL_STOP_NEXT);
> =20
> @@ -464,6 +476,16 @@ static int __devinit ehrpwm_pwm_probe(struct platfor=
m_device *pdev)
>  		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
>  		return ret;
>  	}
> +
> +	/* Some platforms require explicit tbclk gating */
> +	if (of_property_read_bool(pdev->dev.of_node, "tbclkgating")) {

Is it really necessary to have an extra boolean property for this?
Couldn't this just be handled by not defining a clock for the tbclk
consumer in board setup/DT

> +		pc->tbclk =3D clk_get(&pdev->dev, "tbclk");

You should be using devm_clk_get() or add a matching clk_put() in
=2Eremove().

Thierry

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnLqYAAoJEN0jrNd/PrOhHg4P+wTUIZpgbX9390s5ZeIEXOTr
zrsjPXF8qkOAL0siWyipO0mPvu/K7Lr9/aMEBMOfkTS2C/HWj1wzhyDBmHdvDCmW
gBzT1zEi66QFST9OGDtBeEGDIN+0pjC5uJ7GNnr2rkqBzuKADSncBXQNkPp1xKvu
N8nXm4LBr3BHzqbWRYCmrDsvq82XX4tLoZLXc0iU1BivHzfl4OL9KkE8AsXY/a0I
EdqLrhdB/igrt5nB32AI2keENeMJ3Qfwt+JTE/HFM98+sutlmSBjeXANu/dTioO/
lG2eJ3w9oGWB2MhmHuRAANbfvNfmMRUBYRkE+pucvqFSv4Yta7cXxUR6otbphNFb
CjjPPuEBAKDgff2KogagZMpdABszWbFKyo0Cse5KLtf6VEa1v9RiQqSM8HZt6rgm
9k8GezDZOKDMlUd+9c3PEuDL2Hej26vvJHsD3CrkH/d3rOIUjumeqjQ7NR+BCtUp
5q1/SJ59qba6PDSynRZH/XORqtiqEGZdXfon35mE83MpTQtmuC+BDVEHJx9TdqO4
rxAdUzL1jb+SqxCWt83g8eDn2cafWWhQYtdAp6wff3VRNZP5h4uZ9xl+IHW7ibVt
qMFvNnprnhd7csrY4DllF82IfrttE6zFCW8t4DTk4xKAaD4IUlK+iJYj653yeBRO
ibbTVuZs3cDWzqDsVhgi
=JtKg
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
