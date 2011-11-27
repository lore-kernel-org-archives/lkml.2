Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1K0JST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:18:19 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38505 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab1K0JSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:18:08 -0500
Date: Sun, 27 Nov 2011 10:18:03 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        keguang.zhang@gmail.com, wuzhangjin@gmail.com, r0bertz@gentoo.org,
        zhao zhang <zhzhl555@gmail.com>
Subject: Re: [rtc-linux] [PATCH V1] MIPS: Add RTC support for loongson1B
Message-ID: <20111127091803.GD5263@pengutronix.de>
References: <1322189527-4761-1-git-send-email-zhzhl555@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1322189527-4761-1-git-send-email-zhzhl555@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2011 at 10:52:07AM +0800, zhzhl555@gmail.com wrote:

> +	writel(t, SYS_TOYWRITE1);
> +	while (readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TS)
> +		usleep_range(1000, 3000);
> +	__asm__ volatile ("sync");

Timeout?

> +
> +static int __devinit ls1x_rtc_probe(struct platform_device *pdev)
> +{
> +	struct rtc_device *rtcdev;
> +	unsigned long v;
> +	int ret;
> +
> +	v =3D readl(SYS_COUNTER_CNTRL);
> +	if (!(v & RTC_CNTR_OK)) {
> +		dev_err(&pdev->dev, "rtc counters not working\n");
> +		ret =3D -ENODEV;
> +		goto err;
> +	}
> +	ret =3D -ETIMEDOUT;

Why not putting this line to the corresponding dev_err-block?

> +	/*set to 1 HZ if needed*/

Minor: Spaces around comment-markers, here and in other places

/* Comment */

> +	if (readl(SYS_TOYTRIM) !=3D 32767) {
> +		v =3D 0x100000;
> +		while ((readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TTS) && --v)
> +			usleep_range(1000, 3000);

Timeout?

> +
> +		if (!v) {
> +			dev_err(&pdev->dev, "time out\n");
> +			goto err;
> +		}
> +		writel(32767, SYS_TOYTRIM);
> +		__asm__ volatile("sync");
> +	}
> +	/*this loop coundn't be endless*/
> +	while (readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TTS)
> +		usleep_range(1000, 3000);

Timeout again. First, the comment does not help. Why are you sure the loop
could not be endless? And: Does it really need to be a usleep_range() inste=
ad
of a simple msleep()? And to make sure: There is no interrupt signalling the
status changed?

> +
> +	rtcdev =3D rtc_device_register("ls1x-rtc", &pdev->dev,
> +					&ls1x_rtc_ops , THIS_MODULE);
> +	if (IS_ERR(rtcdev)) {
> +		ret =3D PTR_ERR(rtcdev);
> +		goto err;
> +	}
> +
> +	platform_set_drvdata(pdev, rtcdev);
> +	return 0;
> +err:
> +	return ret;
> +}
> +

=2E..

> +static int __init ls1x_rtc_init(void)
> +{
> +	return platform_driver_probe(&ls1x_rtc_driver, ls1x_rtc_probe);
> +}
> +
> +static void __exit ls1x_rtc_exit(void)
> +{
> +	platform_driver_unregister(&ls1x_rtc_driver);
> +}
> +
> +
> +module_init(ls1x_rtc_init);
> +module_exit(ls1x_rtc_exit);

Please use the new module_platform_driver()-macro.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7SAEsACgkQD27XaX1/VRtViACeN5BTIhOk0UALyDm64z1zQv+2
otAAoLcDatRKZ5Gtt4yt1dhCXEA+0Nom
=0IPR
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
