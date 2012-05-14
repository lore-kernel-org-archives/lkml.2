Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2ENIy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:54:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53241 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab2ENIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:54:58 -0400
Date: Mon, 14 May 2012 18:54:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 tree
Message-Id: <20120514185450.4682573d6cb7c4745c9ea8b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_18_54_50_+1000_aacaX6r_q+MO1kEV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_18_54_50_+1000_aacaX6r_q+MO1kEV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
sound/soc/mxs/mxs-saif.c between commit 08641c7c74dd ("ASoC: mxs: add
device tree support for mxs-saif") from the sound-asoc tree and commit
f755865f9082 ("ASoC: mxs-saif: adopt pinctrl support") from the arm-soc
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/mxs/mxs-saif.c
index 0642748,7fd224b..0000000
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@@ -628,50 -626,38 +629,57 @@@ static int __devinit mxs_saif_probe(str
  	struct resource *iores, *dmares;
  	struct mxs_saif *saif;
  	struct mxs_saif_platform_data *pdata;
+ 	struct pinctrl *pinctrl;
  	int ret =3D 0;
 =20
 -	if (pdev->id >=3D ARRAY_SIZE(mxs_saif))
 +
 +	if (!np && pdev->id >=3D ARRAY_SIZE(mxs_saif))
  		return -EINVAL;
 =20
  	saif =3D devm_kzalloc(&pdev->dev, sizeof(*saif), GFP_KERNEL);
  	if (!saif)
  		return -ENOMEM;
 =20
 -	mxs_saif[pdev->id] =3D saif;
 -	saif->id =3D pdev->id;
 -
 -	pdata =3D pdev->dev.platform_data;
 -	if (pdata && !pdata->master_mode) {
 -		saif->master_id =3D pdata->master_id;
 -		if (saif->master_id < 0 ||
 -			saif->master_id >=3D ARRAY_SIZE(mxs_saif) ||
 -			saif->master_id =3D=3D saif->id) {
 -			dev_err(&pdev->dev, "get wrong master id\n");
 -			return -EINVAL;
 +	if (np) {
 +		struct device_node *master;
 +		saif->id =3D of_alias_get_id(np, "saif");
 +		if (saif->id < 0)
 +			return saif->id;
 +		/*
 +		 * If there is no "fsl,saif-master" phandle, it's a saif
 +		 * master.  Otherwise, it's a slave and its phandle points
 +		 * to the master.
 +		 */
 +		master =3D of_parse_phandle(np, "fsl,saif-master", 0);
 +		if (!master) {
 +			saif->master_id =3D saif->id;
 +		} else {
 +			saif->master_id =3D of_alias_get_id(master, "saif");
 +			if (saif->master_id < 0)
 +				return saif->master_id;
  		}
  	} else {
 -		saif->master_id =3D saif->id;
 +		saif->id =3D pdev->id;
 +		pdata =3D pdev->dev.platform_data;
 +		if (pdata && !pdata->master_mode)
 +			saif->master_id =3D pdata->master_id;
 +		else
 +			saif->master_id =3D saif->id;
 +	}
 +
 +	if (saif->master_id < 0 || saif->master_id >=3D ARRAY_SIZE(mxs_saif)) {
 +		dev_err(&pdev->dev, "get wrong master id\n");
 +		return -EINVAL;
  	}
 =20
 +	mxs_saif[saif->id] =3D saif;
 +
+ 	pinctrl =3D devm_pinctrl_get_select_default(&pdev->dev);
+ 	if (IS_ERR(pinctrl)) {
+ 		ret =3D PTR_ERR(pinctrl);
+ 		return ret;
+ 	}
+=20
  	saif->clk =3D clk_get(&pdev->dev, NULL);
  	if (IS_ERR(saif->clk)) {
  		ret =3D PTR_ERR(saif->clk);

--Signature=_Mon__14_May_2012_18_54_50_+1000_aacaX6r_q+MO1kEV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMhaAAoJEECxmPOUX5FEIIsP/josrIar3yza7wdiPClJcJ8x
+YLY/nGZX2Fg2leqXLChrw/kUkmnC6Zf4EPDyb9VbZcrPmm5cy6FSU3TNcLvJMeR
z8Islc4u6bl/XrPn92jti/BuAF/iOx/BcBZXeatFIGxiwb5goBOMJDDZiZCwrz8/
dsENkR0kkOjTYDYAlauQZtaqhpxTdGssOFUreuAZvvdUo0Dhzn6i6IVwlaBSKi/D
HBLxjb1y8OPvFGQPoHnQj8xvt3Q3SKVMNpEc7uYpAExGCg2WcTKoZE9RQHeJz7Fs
0BMv72o/qnN4amFA2lVk8zAC8zTih8Wgmb2M7AmCJhEFkODxpyE4qE+Wrklu0t6x
BXvSpEbece8LdA/VcUDBnqE/chLMMauSaOqlIy+2yxsalZ4CZW9RYQ3VAsB5EDhO
kOgXekPhhsWakcj3DsRjvUb38Fh3M4GCQv5GAbb+AEn8YpjepuAA7ut8MwJ1hUOR
EYtl8xdWCRe0jP2L4CRSKswfyoapouKp+mqbj3jdZ1ngxiuBSOOdmlqNWppkOP1m
cZ5Axbe2VrV2hoH1Ml3WNR3Rj9C7ejSx907KCQCmBUOtSCs1Onz92n/uGAKCuijj
nwwfUwSa2DlQL6bMJuKpC3quKmaak0AkJw2yDNnLd2F/n9XA3tbXfQdph6Se5+vp
vaEVwk1cMu/fnnIvZTa+
=w2y9
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_18_54_50_+1000_aacaX6r_q+MO1kEV--
