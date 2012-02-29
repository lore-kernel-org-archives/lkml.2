Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965882Ab2B2GVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:21:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41887 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2B2GVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:21:48 -0500
Date: Wed, 29 Feb 2012 17:21:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20120229172127.7b430cecc7ab2350d4e4a1b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_17_21_27_+1100_BZSZqcgI=NAFRdZw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_17_21_27_+1100_BZSZqcgI=NAFRdZw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/rtc/rtc-sa1100.c between commit 3888c09074db ("rtc: sa1100:
declare irq in resource") from the arm-soc tree and commit "drivers/rtc:
remove IRQF_DISABLED" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rtc/rtc-sa1100.c
index c105774,e70b4e6..0000000
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@@ -102,23 -156,20 +102,23 @@@ static irqreturn_t sa1100_rtc_interrupt
 =20
  static int sa1100_rtc_open(struct device *dev)
  {
 +	struct sa1100_rtc *info =3D dev_get_drvdata(dev);
 +	struct rtc_device *rtc =3D info->rtc;
  	int ret;
 -	struct platform_device *plat_dev =3D to_platform_device(dev);
 -	struct rtc_device *rtc =3D platform_get_drvdata(plat_dev);
 =20
 -	ret =3D request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, 0,
 +	ret =3D clk_prepare_enable(info->clk);
 +	if (ret)
 +		goto fail_clk;
- 	ret =3D request_irq(info->irq_1hz, sa1100_rtc_interrupt, IRQF_DISABLED,
++	ret =3D request_irq(info->irq_1hz, sa1100_rtc_interrupt, 0,
  		"rtc 1Hz", dev);
  	if (ret) {
 -		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTC1Hz);
 +		dev_err(dev, "IRQ %d already in use.\n", info->irq_1hz);
  		goto fail_ui;
  	}
- 	ret =3D request_irq(info->irq_alarm, sa1100_rtc_interrupt, IRQF_DISABLED,
 -	ret =3D request_irq(IRQ_RTCAlrm, sa1100_rtc_interrupt, 0,
++	ret =3D request_irq(info->irq_alarm, sa1100_rtc_interrupt, 0,
  		"rtc Alrm", dev);
  	if (ret) {
 -		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
 +		dev_err(dev, "IRQ %d already in use.\n", info->irq_alarm);
  		goto fail_ai;
  	}
  	rtc->max_user_freq =3D RTC_FREQ;

--Signature=_Wed__29_Feb_2012_17_21_27_+1100_BZSZqcgI=NAFRdZw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTcPnAAoJEECxmPOUX5FEyZIP/RdEgnR/95lNj4beet+b1IjO
LU30fI3DAcCk+RhDeJq8CIReXTEsrfSBavhlkObsdULmQsHQ36C1JdK6SRGjI1an
vZdtRIXg9AYafUgtQat0dANBlTYUblLW6YzQRd/jIKSJ/fcztS/akv11rxNyYGbZ
xgvvXuTQMGG+gqubIVI9nPVCqBFWLXAwFVh5oFRFkDElShqotW99vwno0p0MjZ9A
D0BMGL1jLN9Do92QHg7OmRtOrFzz6X6tbngxNfvFtLsId8Q5JedWExf+mMAkYOQo
we+ARfFiQd6cMZ5lMFO2n0Xp0WWK4k+FrpEcZs+NEaLxfNwqb4Sj/ALKocvPT3Sy
ZaPUycT8LU8I4RnD9FPbaXQctLTXzHVPOE/teXQPGQAbnK0tqR8ZggcccsOqJQcy
ZLqxV6/4oO7IqTl9uqRQP4XD0WvPk0AqRUYHsXJV5l+Ac/l4QdtURGADyyvB2mZW
Nj7LFEDjOY2NqbgBapT6xKPCbhzoEduRtN0Nqkdl1OIk+gleg4mFutQXQj/fPv7+
J/+Uw+8/Kh+jSzFzyasAIEAaAbue04sppUWSjWn2VTCXL8QyvzJGDsuCsxo6Y3My
8PNFFG6MDfnxtlYYaglpss0cvCVhYNoJUpgr8Dv9bKy1TEQ+9J7hSHJWzDkITWDQ
m6oPPwFjo5kpu3a5Zv1K
=dqXa
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_17_21_27_+1100_BZSZqcgI=NAFRdZw--
