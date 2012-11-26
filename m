Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2KZFoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:44:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53802 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2KZFoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:44:21 -0500
Date: Mon, 26 Nov 2012 16:44:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: linux-next: manual merge of the regulator tree with the mfd tree
Message-Id: <20121126164412.653f0cb43bb55775475f6ed3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_16_44_12_+1100_8AfNd.FPGKRBl=RP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_16_44_12_+1100_8AfNd.FPGKRBl=RP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the regulator tree got a conflict in
include/linux/mfd/tps65090.h between commit 3863db3e800c ("mfd: tps65090:
Remove unused member of struct tps65090") from the mfd tree and commit
24282a1ca33b ("regulator: tps65090: Register all regulators in single
probe call") from the regulator tree.

I fixed it up (I think - see below) and can carry the fix as necessary (no =
action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mfd/tps65090.h
index 4bbbb13,804e280..0000000
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@@ -23,35 -23,63 +23,70 @@@
  #define __LINUX_MFD_TPS65090_H
 =20
  #include <linux/irq.h>
 +#include <linux/regmap.h>
 +
 +/* TPS65090 IRQs */
 +enum {
 +	TPS65090_IRQ_VAC_STATUS_CHANGE,
 +	TPS65090_IRQ_VSYS_STATUS_CHANGE,
 +	TPS65090_IRQ_BAT_STATUS_CHANGE,
 +	TPS65090_IRQ_CHARGING_STATUS_CHANGE,
 +	TPS65090_IRQ_CHARGING_COMPLETE,
 +	TPS65090_IRQ_OVERLOAD_DCDC1,
 +	TPS65090_IRQ_OVERLOAD_DCDC2,
 +	TPS65090_IRQ_OVERLOAD_DCDC3,
 +	TPS65090_IRQ_OVERLOAD_FET1,
 +	TPS65090_IRQ_OVERLOAD_FET2,
 +	TPS65090_IRQ_OVERLOAD_FET3,
 +	TPS65090_IRQ_OVERLOAD_FET4,
 +	TPS65090_IRQ_OVERLOAD_FET5,
 +	TPS65090_IRQ_OVERLOAD_FET6,
 +	TPS65090_IRQ_OVERLOAD_FET7,
 +};
 =20
+ /* TPS65090 Regulator ID */
+ enum {
+ 	TPS65090_REGULATOR_DCDC1,
+ 	TPS65090_REGULATOR_DCDC2,
+ 	TPS65090_REGULATOR_DCDC3,
+ 	TPS65090_REGULATOR_FET1,
+ 	TPS65090_REGULATOR_FET2,
+ 	TPS65090_REGULATOR_FET3,
+ 	TPS65090_REGULATOR_FET4,
+ 	TPS65090_REGULATOR_FET5,
+ 	TPS65090_REGULATOR_FET6,
+ 	TPS65090_REGULATOR_FET7,
+ 	TPS65090_REGULATOR_LDO1,
+ 	TPS65090_REGULATOR_LDO2,
+=20
+ 	/* Last entry for maximum ID */
+ 	TPS65090_REGULATOR_MAX,
+ };
+=20
  struct tps65090 {
 -	struct mutex		lock;
  	struct device		*dev;
 -	struct i2c_client	*client;
  	struct regmap		*rmap;
 -	struct irq_chip		irq_chip;
 -	struct mutex		irq_lock;
 -	int			irq_base;
 -	unsigned int		id;
 -};
 -
 -struct tps65090_subdev_info {
 -	int		id;
 -	const char	*name;
 -	void		*platform_data;
 +	struct regmap_irq_chip_data *irq_data;
  };
 =20
+ /*
+  * struct tps65090_regulator_plat_data
+  *
+  * @reg_init_data: The regulator init data.
+  * @enable_ext_control: Enable extrenal control or not. Only available for
+  *     DCDC1, DCDC2 and DCDC3.
+  * @gpio: Gpio number if external control is enabled and controlled throu=
gh
+  *     gpio.
+  */
+ struct tps65090_regulator_plat_data {
+ 	struct regulator_init_data *reg_init_data;
+ 	bool enable_ext_control;
+ 	int gpio;
+ };
+=20
  struct tps65090_platform_data {
  	int irq_base;
 -	int num_subdevs;
 -	struct tps65090_subdev_info *subdevs;
+ 	struct tps65090_regulator_plat_data *reg_pdata[TPS65090_REGULATOR_MAX];
  };
 =20
  /*

--Signature=_Mon__26_Nov_2012_16_44_12_+1100_8AfNd.FPGKRBl=RP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQswGsAAoJEECxmPOUX5FEluEP/3lDQf1P/Ni/RRGZ1jsCJqho
BmGdfsckuB9ElEDRKGbQE8bjKbrLKVMuG8sVbCPhvVcEule86de8gNTZ5UOnLp0G
w8tQBZcq+pzG6isqhHYXpUxGmHF/OzZNBFhXW9KpadOHPU6oZvxJBbG5+YffhZMW
zeH2Q9/cdPeSKHY+K8ZpwOHgBFc1A8fHQytUxHW3cWhfGp4ieNvodjRZ6kbyQ0Gj
W8+xp9PEqFOXB5Cp8D16/UwrCw2HvZsUtpxLPxXMj5idWIBei21In33B//Zg56zd
BuiRc7mN13pE/UZHDXlcw53gohWAnwlmBa3PXVNDDO5LkI4kbabnce/B/M+996Db
94aetvaj8lgPA7MA1lQJFPYE7PviHimq66NVsB7cNCjdTJ2bwy/lxEHqS397fXeu
gnu9b8KtxsLuwzEL1MZ4rM3JuvHKpZ2zM4rHFB06LoSzofbhOnr+LxluPiLRIoTy
uBU6yNrCk52TpYX3MswcJGQNcWeFMiMAyJIqI1intYRfc1EEzzoZ35prO/HMRo8r
cI+96lzbCXOGCyoeyK6G6EBHjvaE1+1jLsiGQqeZ2eiicrB65xEX8J54dXThl59j
RVHUei9OTZGxGq9yzvmNxuxkm4TnHa+m6GtccptiXrjCf5xGQAJnJLybeX9yPMc2
ngDnUCKFh8W5jchnvkhv
=sV2t
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_16_44_12_+1100_8AfNd.FPGKRBl=RP--
