Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2G3ANH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 20:13:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab2G3ANF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 20:13:05 -0400
Date: Mon, 30 Jul 2012 10:12:45 +1000
From: NeilBrown <neilb@suse.de>
To: Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MMC/omap_hsmmc: handle failure of regulator_get better.
Message-ID: <20120730101245.7dbe72b0@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b9gLLBPGtKQhFTl1thaI0dZ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b9gLLBPGtKQhFTl1thaI0dZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


1/ if regulator_get fails, return an error.  This is important
   if it failed with EPROBE_DEFER, as the probe needs to be
   deferred.

2/ Don't set .set_power until the regulator has been found, or
   the deferred probe will not bother calling omap_hsmmc_reg_get().

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 389a3ee..f052c29 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -299,12 +299,12 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_host =
*host)
 	struct regulator *reg;
 	int ocr_value =3D 0;
=20
-	mmc_slot(host).set_power =3D omap_hsmmc_set_power;
-
 	reg =3D regulator_get(host->dev, "vmmc");
 	if (IS_ERR(reg)) {
 		dev_dbg(host->dev, "vmmc regulator missing\n");
+		return PTR_ERR(reg);
 	} else {
+		mmc_slot(host).set_power =3D omap_hsmmc_set_power;
 		host->vcc =3D reg;
 		ocr_value =3D mmc_regulator_get_ocrmask(reg);
 		if (!mmc_slot(host).ocr_mask) {

--Sig_/b9gLLBPGtKQhFTl1thaI0dZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBXRfTnsnt1WYoG5AQKRoRAAlGo3H3AeUZ/dXZOdgW5my7xflVOmtWtP
dBe1w+SWHO77jFq3dtdhmVr/hvVlFRYMiC8WRxIOLgbJfDnqf0hh6rP7+5o76nXF
n2Lr5MOT1yQPIUBUOCZnCCyWZ4/BbdHeoe5f/qBmE1hSVtYwt3wNmpIpM1ueySZL
xpRMqpaKLrU+2S9DX9fQkID3NcfDd+A1MMx1GvnqHg057gSRHXURfxpVzK3g0dw3
QjG9EiiecIDuiHIRuDWoE0aOACsVv5WLbLCXh/mQr2ioxyrCJorBi77LfPBiR3Vj
3JO0PnzoLge6H3BjXFR6d3EtySSb/F/sUYJH5bP50AkG47l3NfmUqm0YTlnJT47Q
llCl2nq9c114jeel+ZeZaiuu9ZHtjtLAd233Yv9JYkQG6CJJraYl0Tei2xZElY2u
bso8mJvofh0iZ32TDBcbwuk1UOJB+NjbEaFcFY3dBQa3/s7vuTH7PD9t3uZh0Gk4
0dvHFxa9pxoJXhGL0qhVDY6JNa7hCtC5lsRnjyed5bGBL6SsD8h3MtoCWwoa3+WJ
WRzwcOr3+LTOrrgxzc8LOTYJFcCt7zYP6nGecAw+0ZRP13oFXUHQFOj1LpK/fayk
zQL5SJljyit9jkOjnOxwhbA2mLb3rGTWCF9A9xhybNiPfEiPoZ/xdLTc6yXyi92U
xcolJ3Pf42Y=
=FKek
-----END PGP SIGNATURE-----

--Sig_/b9gLLBPGtKQhFTl1thaI0dZ--
