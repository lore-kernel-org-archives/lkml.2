Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab3ABOJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:09:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:09:50 -0500
Date: Wed, 2 Jan 2013 15:09:41 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 2/2] pwm: vt8500: Add support for .set_polarity
Message-ID: <20130102140941.GC4414@avionic-0098.adnet.avionic-design.de>
References: <1356899005-8876-1-git-send-email-linux@prisktech.co.nz>
 <1356899005-8876-2-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <1356899005-8876-2-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5CxnA7A1a3DrDwM8BFK9wl3MV2cHQXKyt3QxKSCEfWu
 DY2o10UrRXLg/2mrIyB/l1uK37Vgyl8wz7rAfpYymqL0itDyoj
 vNcbzqbnYbyz2fgB34S0atzfbQtyIArh83fXHDkCkbOxKVUQvw
 56oXxyA4Fdll3ilxSY8L5aLVCTR0JozR1VzM+wHSk/6sGfZ0qZ
 jgxsXlAgyxOATLB4xuEM1Rpf74vwzkoFffLWeEZxRZvgouCWLi
 ZRaIFEg0hXpOXI1ypWQLX9sMuP4S3rmYFufh+83HjiflpSHmJO
 mf5Z3RvZGR2x5GJDLEtwJ1LUpP9dPl+3Yrdnty0mPPffVwLqeg
 +IRzImcs3Gg0SPFLoicg/zCUNocKS8znCdJjpKsBeXEYXOOiJM
 PSU+losFowIOHZcgfKoduUK3DPUpXGmnk0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 31, 2012 at 09:23:25AM +1300, Tony Prisk wrote:
> Add support to set polarity on pwm devices, allowing for inverted
> duty cycles.

"PWM devices", please. Maybe the subject could be something less API
specific, like "pwm: vt8500: Add polarity support".

>  .../devicetree/bindings/pwm/vt8500-pwm.txt         |    7 ++++---
>  drivers/pwm/pwm-vt8500.c                           |   21 ++++++++++++++=
++++++
>  2 files changed, 25 insertions(+), 3 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Docum=
entation/devicetree/bindings/pwm/vt8500-pwm.txt
> index bcc6367..f71cc8d 100644
> --- a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> +++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> @@ -3,14 +3,15 @@ VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
>  Required properties:
>  - compatible: should be "via,vt8500-pwm"
>  - reg: physical base address and length of the controller's registers
> -- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> -  of the PWM to use and the second cell is the period in nanoseconds.
> +- #pwm-cells: should be 3.  The first cell specifies the per-chip index
> +  of the PWM to use, the second cell is the period in nanoseconds, and t=
he
> +  third cell is for flags.

This needs to document what flags the third cell encodes and how. Either
that or refer to the generic PWM binding documentation.

> diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
> index 27ed0f4..9abf561 100644
> --- a/drivers/pwm/pwm-vt8500.c
> +++ b/drivers/pwm/pwm-vt8500.c
> @@ -164,10 +164,31 @@ static void vt8500_pwm_disable(struct pwm_chip *chi=
p, struct pwm_device *pwm)
>  	clk_disable(vt8500->clk);
>  }
> =20
> +static int vt8500_pwm_set_polarity(struct pwm_chip *chip,
> +				   struct pwm_device *pwm,
> +				   enum pwm_polarity polarity)
> +{
> +	struct vt8500_chip *vt8500 =3D to_vt8500_chip(chip);
> +	u32 val;
> +
> +	val =3D readl(vt8500->base + REG_CTRL(pwm->hwpwm));
> +
> +	if (polarity =3D=3D PWM_POLARITY_INVERSED)
> +		val |=3D CTRL_INVERT;
> +	else
> +		val &=3D ~CTRL_INVERT;
> +
> +	writel(val, vt8500->base + REG_CTRL(pwm->hwpwm));
> +	pwm_busy_wait(vt8500, pwm->hwpwm, STATUS_CTRL_UPDATE);
> +
> +	return 0;
> +}
> +
>  static struct pwm_ops vt8500_pwm_ops =3D {
>  	.enable =3D vt8500_pwm_enable,
>  	.disable =3D vt8500_pwm_disable,
>  	.config =3D vt8500_pwm_config,
> +	.set_polarity =3D vt8500_pwm_set_polarity,
>  	.owner =3D THIS_MODULE,
>  };

This patch is missing the corresponding changes to the DT code. You need
to override the pwm_chip's .of_xlate() and .of_pwm_n_cells fields. You
can look at the TI EHRPWM driver if you need inspiration.

Thierry

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5D+lAAoJEN0jrNd/PrOhmqEP/j0ENc22jCehiWa6OrLvEhg0
UnHdlXyjsPDSNwsu08hVH93npv8t4TrQlP889136sD/ybBvgstQZsT2dPXtcbKOK
G1nVgAvu59YpFFQCjYY2fkSQcsS/N2/SH7ixYQ5/od9pfHUHjFzwqizaKi/x0i/B
jPQiw6hwv264muGKTQNTwqzZAHK3AIy6d3aHqxhgSInHnvCgS1Tgb+P9UxH41lwY
chKyoqnFKWLWXkuZ/bR6UZVcTxE9B4c2mbMPg3JC0+1eC88f0FaYnI/AOwDw/Gpu
1WfkWsYfeUU1V1PwlE0J1bKOsrZoHe+x/cpjTm60W1L0CKCom2hQUmzeCd+qYVeX
Cq0LxwtdajdriYYTgs7Z4acDd8j/e6W2trhU15NnfUI83lHYoZGbCe79iR4RVdsc
/NgIZ1sdFtQfDA3ZD5YQCs6Zs/38rv/0nWpCJ/5MFA0Czpgt7Hd4sySCPewlEm91
zt+HR8VK8/vweHop19ShqNLm2OV2DSptQLUjl4w0jBpOo+t/sK6Q2tEPhgZaPRyj
5XGEmjnV/PE3ft1cxn1ZuokihWEgli/CRBkkWaQsRulnfpQ4fJAyaaLgc9IgjQCM
XA+VPcij5pCaLRuR0xBYAUEvGBHCl3wToTRfxTCl8KWx36ZZBLJNEkZOqiPX0zaj
Wl930CehB+OR4srOhLgi
=OxAO
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
