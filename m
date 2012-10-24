Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab2JXFvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:51:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JXFvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:51:42 -0400
Date: Wed, 24 Oct 2012 07:51:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V4] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121024055137.GC9787@avionic-0098.mockup.avionic-design.de>
References: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:s5rgIilgwK96PszibQxGCWa2Ku2yOGcp7+7+G0yKDv7
 5TX8KflgtJ4yJxiZ4Zl32Hl24yEhXD74B5YGH8wHcXyAqrg05d
 GJiEMzhePgkUlcnLTURWS3sk6PO15BIwoYyaabMy+M81GrbrAr
 8yecXUghcyImyrYHgJR6oLMUMfbx3ATn+H3Z+YXQyKoDinbefA
 aAaHnp0B9I4AR3EwAYy86GG/ACy9U2GMv6Oe0rPxC57t+agjRU
 WMUD5SDcGMcjWTKS/i29GSDNeOVdSSKXy0hV9AzXATPfhEJ2Rg
 UDKKl96Sj0KZ+1S71eTYWLrhkXbIAqnMN8/tV7Xk/3Pj52Qnz2
 vEcoowmobu33pVpcaylQ7mSKJNJhRn+QbVRwHwmZkbPVGisMdT
 0XIVdWrvYzUUx08UnZGGUe9zS72RWBUQEPjg6YaXBQwUHJy3vr
 QzTh6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 22, 2012 at 04:36:41PM +0530, Shiraz Hashim wrote:
[...]
> +struct spear_pwm_chip {
> +	void __iomem *mmio_base;
> +	struct clk *clk;
> +	struct pwm_chip	chip;

My editor shows a tab between pwm_chip and chip. This should really be a
space.

> +	ret = pwmchip_add(&pc->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	ret = clk_prepare_enable(pc->clk);
> +	if (ret < 0)
> +		return pwmchip_remove(&pc->chip);

I think in order to fix the potential race condition that Viresh
mentioned we should move the clk_prepare_enable() before the
pwmchip_add(), but don't forget to disable and unprepare the clock if
pwmchip_add() fails.

Actually, can't we make it a clk_prepare() only at this point and move
the clk_enable() and clk_disable() into the if block below? In case the
compatible value is not "st,spear1340-pwm" we don't need the clock
enabled.

> +
> +	if (of_device_is_compatible(np, "st,spear1340-pwm")) {
> +		/*
> +		 * Following enables PWM chip, channels would still be
> +		 * enabled individually through their control register
> +		 */
> +		val = readl_relaxed(pc->mmio_base + PWMMCR);
> +		val |= PWMMCR_PWM_ENABLE;
> +		writel_relaxed(val, pc->mmio_base + PWMMCR);
> +

Oh, and a spurious newline here... =)

> +	}
> +
> +	/* only disable the clk and leave it prepared */
> +	clk_disable(pc->clk);

This can go into the if block to match the clk_enable().

Thierry

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQh4HpAAoJEN0jrNd/PrOhYasP+gNdOp7oJ5skYYVYaEdrdp9L
pKvMl7fXwaau04Pb1+P3djyX6WmvFTwy7ytoCUapHPK98yG8SxXnRT1GuQ+lshGK
mhZISwZ2cKDkLOeDTkTqxBB4We25cwStZ1C5Ng37JquuZculZG4t/1z01o67FOrM
sUjUyUz5KQfDQc3VmRbTpvcg8eGz/9JX0wh0nxxl7XKa7+tnh8HD77L6/sOv9nuu
AujYJ2ZKj0sZQtmbQQpPBTH6/rjATFmb6+RQw0Zur2K/9y2mtetLmZ+iqoj4AXsM
dJhCVb5l/CsoqOKVKg98CaDI8eqJ9vcy02Q7PUFFZBJciDt9ILHO0ZQWvmvX0g33
Z1CPQ++o+CG1Cc2gYrPkyN5VCAwzvUTk6sBjVIG3rjQYWpfYhP6g8Ar10twjNa3P
YnLRdLqbG6IBFpzBryn5v1l3DWUAuphbbVREPevu0AdQjpY8DwXfkkb3haUCVEP1
SNgJH2gx51infWySRwiDh3ORSmK78su0d2vYLBTVdZyDh5n/jRGex4cRPsSNsLWN
SWzZeQ+iQxzFCnMW7t9yPKYmE8wHi48apsAn3YW+49FH1DHndGryzDrHe71xYx7A
ENvNuXz773ZrnEf1ytuq/0SQGc8tfA3OsmjXSJMT57b9lXqQobmrEbvA6UDdyyZD
P9i6kyh93oCJxclUty9F
=x8wQ
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
