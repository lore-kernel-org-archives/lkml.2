Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2IEDPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:15:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54757 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2IEDPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:15:52 -0400
Date: Wed, 5 Sep 2012 13:15:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lauri Hintsala <lauri.hintsala@bluegiga.com>,
        Chris Ball <cjb@laptop.org>, Marek Vasut <marex@denx.de>
Subject: linux-next: manual merge of the spi-mb tree with the mmc tree
Message-Id: <20120905131539.95d7a613d49f741ab6f123a6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Sep_2012_13_15_39_+1000_i5ySC6_Ni0wobtGW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Sep_2012_13_15_39_+1000_i5ySC6_Ni0wobtGW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Today's linux-next merge of the spi-mb tree got a conflict in
drivers/mmc/host/mxs-mmc.c between commit fc108d24d3a6 ("mmc: mxs-mmc:
fix deadlock caused by recursion loop") from the mmc tree and commit
829c1bf40b92 ("mmc: spi: Pull out parts shared between MMC and SPI") from
the spi-mb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/mxs-mmc.c
index ad3fcea,4da9966..0000000
--- a/drivers/mmc/host/mxs-mmc.c
+++ b/drivers/mmc/host/mxs-mmc.c
@@@ -281,12 -193,10 +193,12 @@@ static irqreturn_t mxs_mmc_irq_handler(
 =20
  	spin_lock(&host->lock);
 =20
- 	stat =3D readl(host->base + HW_SSP_CTRL1(host));
+ 	stat =3D readl(ssp->base + HW_SSP_CTRL1(ssp));
  	writel(stat & MXS_MMC_IRQ_BITS,
- 	       host->base + HW_SSP_CTRL1(host) + STMP_OFFSET_REG_CLR);
+ 	       ssp->base + HW_SSP_CTRL1(ssp) + STMP_OFFSET_REG_CLR);
 =20
 +	spin_unlock(&host->lock);
 +
  	if ((stat & BM_SSP_CTRL1_SDIO_IRQ) && (stat & BM_SSP_CTRL1_SDIO_IRQ_EN))
  		mmc_signal_sdio_irq(host->mmc);
 =20
@@@ -641,22 -523,22 +523,22 @@@ static void mxs_mmc_enable_sdio_irq(str
 =20
  	if (enable) {
  		writel(BM_SSP_CTRL0_SDIO_IRQ_CHECK,
- 		       host->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_SET);
+ 		       ssp->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_SET);
  		writel(BM_SSP_CTRL1_SDIO_IRQ_EN,
- 		       host->base + HW_SSP_CTRL1(host) + STMP_OFFSET_REG_SET);
+ 		       ssp->base + HW_SSP_CTRL1(ssp) + STMP_OFFSET_REG_SET);
 -
 -		if (readl(ssp->base + HW_SSP_STATUS(ssp)) &
 -				BM_SSP_STATUS_SDIO_IRQ)
 -			mmc_signal_sdio_irq(host->mmc);
 -
  	} else {
  		writel(BM_SSP_CTRL0_SDIO_IRQ_CHECK,
- 		       host->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_CLR);
+ 		       ssp->base + HW_SSP_CTRL0 + STMP_OFFSET_REG_CLR);
  		writel(BM_SSP_CTRL1_SDIO_IRQ_EN,
- 		       host->base + HW_SSP_CTRL1(host) + STMP_OFFSET_REG_CLR);
+ 		       ssp->base + HW_SSP_CTRL1(ssp) + STMP_OFFSET_REG_CLR);
  	}
 =20
  	spin_unlock_irqrestore(&host->lock, flags);
 +
- 	if (enable && readl(host->base + HW_SSP_STATUS(host)) &
++	if (enable && readl(ssp->base + HW_SSP_STATUS(ssp)) &
 +			BM_SSP_STATUS_SDIO_IRQ)
 +		mmc_signal_sdio_irq(host->mmc);
 +
  }
 =20
  static const struct mmc_host_ops mxs_mmc_ops =3D {

--Signature=_Wed__5_Sep_2012_13_15_39_+1000_i5ySC6_Ni0wobtGW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRsPbAAoJEECxmPOUX5FEdPMQAKoBVDaSYUoxESSoSmAJ2nLQ
sCJ7ekSdVnQhYgjaIY3+j/g+UIEqx1eZeygDIblEDdGn3UTJ9OlrdTDFqMxIvwcc
hxFYV7gGx/NMAxTd3AQVjxHrbaj5HRxt+D8+mOSIEatkSFQbW108oVUNTNLM3yEe
zRKrAA/wGQ1szyhnl1vo+RChITDOc2muvKIBwr3lfdHBK8dG+dl5tk5DYKQq+Jgs
OfIpM4jZN/FzcmGSQzZVXtsC4yA3fMoeWR4ooX1a5ea57KTUKNQzuTYYTrrj1+5u
H9QfrYBmE6BbidB3rKJeUwrOv5aLx8Qc0HM600FMLpHoVnIT55br2HC2EHMzmsr3
wE2luB2EnB72VZHvbx3nhwwfFKc0TxpFwgZlMofg6s26CV0gup7gjxEzLulXUEgn
RZcnRuX40U+tt7PGQ4syIFftMZs31T39z15VZG5OT/y+1FNnLbmNI/zZ/cUNRr3l
WdJxn4zaVx8A7k3zc98kMzGHtsfWevxB5DUzbeAIJ4TRPUxKUy1/Tgd8OCI7mCnU
IV3yt2uAVK0ruECXkY9URlN2xbeaHuDRP62X+qN2jxPuPi5G2tSHwiEiHCKyzvhw
jWBGP6VKuJJuEjTwlBtk5aTLsulLuUXM+B19+4Js+rXdJkq+xVZ30ugYt0FmiUBU
XyqKLOXDOWP7brywdSeM
=l457
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Sep_2012_13_15_39_+1000_i5ySC6_Ni0wobtGW--
