Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2DYKuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 06:50:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757654Ab2DYKuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 06:50:08 -0400
Date: Wed, 25 Apr 2012 20:50:02 +1000
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl-regulator: Allow CONFIG_TWL4030_ALLOW_UNSUPPORTED
 to be requested.
Message-ID: <20120425205002.104ff358@notabene.brown>
In-Reply-To: <20120425101258.GI3195@opensource.wolfsonmicro.com>
References: <20120425122924.0f08f5dc@notabene.brown>
	<20120425082417.GE3195@opensource.wolfsonmicro.com>
	<20120425195956.5b3d9c2a@notabene.brown>
	<20120425101258.GI3195@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GKDRxYWIVDp8lJe0Qb6qCN."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GKDRxYWIVDp8lJe0Qb6qCN.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 11:12:59 +0100 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Apr 25, 2012 at 07:59:56PM +1000, NeilBrown wrote:
>=20
> > That make sense - but I cannot find a good place to put the flag.
> > TWL doesn't have any twl-specific platform data, it just uses
> > struct regulator_init_data.  I don't suppose it would be acceptable
> > to tuck an 'allow_unsupported' flag inside 'struct regulation_constrain=
ts'?
>=20
> > I'm not sure how else to do it without fairly major surgery.
>=20
> This is what the driver_data in regulator_init_data is there for - to
> allow device specific extensions to be added if needed.  I guess it
> should be possible to use that?

Ahh... (digs around) and twl treats that as a 'long' and copies it into
  info->features
(which is otherwize set from static data).

So maybe something like that (completely untested as yet) ??
(and this seems to have changed between 3.3 and 3.4 which confused me
a bit.  But if you think this approach is OK I'll come up with something
that is right for 3.4).

Thanks,
NeilBrown

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regu=
lator.c
index 181a2cf..00fd3d2 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -375,14 +375,12 @@ static int twl6030reg_set_mode(struct regulator_dev *=
rdev, unsigned mode)
  * VAUX3 at 3V is incorrectly listed in some TI manuals as unsupported.
  * TI are revising the twl5030/tps659x0 specs to support that 3.0V setting.
  */
-#ifdef CONFIG_TWL4030_ALLOW_UNSUPPORTED
-#define UNSUP_MASK	0x0000
-#else
 #define UNSUP_MASK	0x8000
-#endif
=20
 #define UNSUP(x)	(UNSUP_MASK | (x))
-#define IS_UNSUP(x)	(UNSUP_MASK & (x))
+#define IS_UNSUP(info, x)			\
+	((UNSUP_MASK & (x)) &&			\
+	 !((info)->features & TWL4030_ALLOW_UNSUPPORTED))
 #define LDO_MV(x)	(~UNSUP_MASK & (x))
=20
=20
@@ -456,7 +454,7 @@ static int twl4030ldo_list_voltage(struct regulator_dev=
 *rdev, unsigned index)
 	struct twlreg_info	*info =3D rdev_get_drvdata(rdev);
 	int			mV =3D info->table[index];
=20
-	return IS_UNSUP(mV) ? 0 : (LDO_MV(mV) * 1000);
+	return IS_UNSUP(info, mV) ? 0 : (LDO_MV(mV) * 1000);
 }
=20
 static int
@@ -470,7 +468,7 @@ twl4030ldo_set_voltage(struct regulator_dev *rdev, int =
min_uV, int max_uV,
 		int mV =3D info->table[vsel];
 		int uV;
=20
-		if (IS_UNSUP(mV))
+		if (IS_UNSUP(info, mV))
 			continue;
 		uV =3D LDO_MV(mV) * 1000;
=20
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index 5b87dc9..5f56743 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -172,6 +172,9 @@ TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
 TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
=20
 #define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
+#define TWL4030_ALLOW_UNSUPPORTED BIT(0) /* Some voltages are possible
+					  * but not officially supported
+					  */
=20
 /*
  * Read and write single 8-bit registers

--Sig_/GKDRxYWIVDp8lJe0Qb6qCN.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5fW2jnsnt1WYoG5AQLDPBAApPlhnJZ1PcBzhR/wHfBjKMm0euQ6gVbD
KqYGFEjEW96stQlV5LgCCk1cakeNq2AdNDbHgtzPwqBVVu9YPY2apWUqw7K4xjWO
U/T4sm7cV9VJPI8qAGENU0lphKRNtox69QD34BszMwbcA6nkz13/vcZnGjV1rPAD
RpbJZm1iIRSe5HshEjfib4ZaddUw+ELasIsFSNiANM4+TY9ue2WHo4tUcyYkGidx
XuMfpBCQ95+s2pwKp43SQfpeig8C/QZ9xxqS5G6J72UQm3sD3fCxAg/5D3ku7AX/
pYLJ6nsu9wXn7DP9m7yPjhClEarYZfBRdOnSwPKD2yDINYiZGOjZA0DU2MvRs/sg
pWsq8rBgGT1qdeRkL7d2L928GEtOfJ+HY3bw+CJmL0ar2dFRmi3H7Zc6/UI/bBgq
REcXKtuz7fjQ+o115yE0CcVysRb7WHNcy1UaJyCPeeD89dn7Xi/gAm+DXcPDJEA9
kAvjSwfDt4BdMwkbFZQ6SVmt6i1ws5Ru7jPKy5GBtjwx+RazdoXdJhBOaKqQFku6
taW3qQ3FUFSzs+JBZYYnkJrO18TkXCdAh6gvVzq48bWl4TjaP6n4q3NLGolPXfQW
e0eYGqTGEny5tQxCdTRKqO8P5CgligTaXQIGjvevtk0RUrSr4RWPeYRG+5ghzafB
2K8ogbIJ8Ck=
=7BiC
-----END PGP SIGNATURE-----

--Sig_/GKDRxYWIVDp8lJe0Qb6qCN.--
