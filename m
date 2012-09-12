Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2ILE47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 00:56:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42748 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2ILE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 00:56:57 -0400
Date: Wed, 12 Sep 2012 14:56:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the workqueues tree with the omap_dss2
 tree
Message-Id: <20120912145649.b48d9ef66ce8cb9bca74dc44@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_14_56_49_+1000_RvNdeaxowSz=XyaY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_14_56_49_+1000_RvNdeaxowSz=XyaY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
drivers/video/omap2/displays/panel-taal.c between commit 5e56ad44b4d2
("OMAPDSS: Taal: use devm_* functions") from the omap_dss2 tree and
commit 203b42f73174 ("workqueue: make deferrable delayed_work initializer
names consistent") from the workqueues tree.

I fixed it up (see below) and can carry the fix as necessary (no action=20
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/omap2/displays/panel-taal.c
index 4cf9416,6b5e6e0..0000000
--- a/drivers/video/omap2/displays/panel-taal.c
+++ b/drivers/video/omap2/displays/panel-taal.c
@@@ -925,50 -900,29 +925,50 @@@ static int taal_probe(struct omap_dss_d
 =20
  	atomic_set(&td->do_update, 0);
 =20
 -	td->workqueue =3D create_singlethread_workqueue("taal_esd");
 -	if (td->workqueue =3D=3D NULL) {
 -		dev_err(&dssdev->dev, "can't create ESD workqueue\n");
 -		r =3D -ENOMEM;
 -		goto err_wq;
 +	if (gpio_is_valid(td->reset_gpio)) {
 +		r =3D devm_gpio_request_one(&dssdev->dev, td->reset_gpio,
 +				GPIOF_OUT_INIT_LOW, "taal rst");
 +		if (r) {
 +			dev_err(&dssdev->dev, "failed to request reset gpio\n");
 +			return r;
 +		}
  	}
 -	INIT_DEFERRABLE_WORK(&td->esd_work, taal_esd_work);
 -	INIT_DELAYED_WORK(&td->ulps_work, taal_ulps_work);
 =20
 -	dev_set_drvdata(&dssdev->dev, td);
 +	if (gpio_is_valid(td->ext_te_gpio)) {
 +		r =3D devm_gpio_request_one(&dssdev->dev, td->ext_te_gpio,
 +				GPIOF_IN, "taal irq");
 +		if (r) {
 +			dev_err(&dssdev->dev, "GPIO request failed\n");
 +			return r;
 +		}
 +
 +		r =3D devm_request_irq(&dssdev->dev, gpio_to_irq(td->ext_te_gpio),
 +				taal_te_isr,
 +				IRQF_TRIGGER_RISING,
 +				"taal vsync", dssdev);
 =20
 -	if (gpio_is_valid(panel_data->reset_gpio)) {
 -		r =3D gpio_request_one(panel_data->reset_gpio, GPIOF_OUT_INIT_LOW,
 -				"taal rst");
  		if (r) {
 -			dev_err(&dssdev->dev, "failed to request reset gpio\n");
 -			goto err_rst_gpio;
 +			dev_err(&dssdev->dev, "IRQ request failed\n");
 +			return r;
  		}
 +
- 		INIT_DELAYED_WORK_DEFERRABLE(&td->te_timeout_work,
++		INIT_DEFERRABLE_WORK(&td->te_timeout_work,
 +					taal_te_timeout_work_callback);
 +
 +		dev_dbg(&dssdev->dev, "Using GPIO TE\n");
  	}
 =20
 +	td->workqueue =3D create_singlethread_workqueue("taal_esd");
 +	if (td->workqueue =3D=3D NULL) {
 +		dev_err(&dssdev->dev, "can't create ESD workqueue\n");
 +		return -ENOMEM;
 +	}
- 	INIT_DELAYED_WORK_DEFERRABLE(&td->esd_work, taal_esd_work);
++	INIT_DEFERRABLE_WORK(&td->esd_work, taal_esd_work);
 +	INIT_DELAYED_WORK(&td->ulps_work, taal_ulps_work);
 +
  	taal_hw_reset(dssdev);
 =20
 -	if (panel_data->use_dsi_backlight) {
 +	if (td->use_dsi_backlight) {
  		memset(&props, 0, sizeof(struct backlight_properties));
  		props.max_brightness =3D 255;
 =20

--Signature=_Wed__12_Sep_2012_14_56_49_+1000_RvNdeaxowSz=XyaY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUBYRAAoJEECxmPOUX5FEVDcP/iysp4qxFdGlFlBE/ekLkl27
KchAxygvhFS6H1B46tNWFMf1rTN6jrCTntc5q7m5xuVPYS+P3zm4FiaSP0MZE5vE
m1+nxHTbsBnMtH6fknaOiagTVQ5GANX1ui//lqbw106v+c4iSKeJZddBXrjw/c7t
Hck2NC6i4iI055GHp5r84RT/zsQdb2VVZjPnHJgBAUW6hplIHDp28O+qsREi085b
Sf1TTRf4qK7Fh7ENqXgAOcHiyTGIjpfQhtaS+iv2ASv+Z0idvBrhZHuXB1XW775m
rRsQO7ooH2m60EBleHPzPfaR3zP7CROdT8dR/3Ku9f8q4wo+DBG0qOXJwDFRDDZh
d/wRmmCg9qztVDIzTAYMe6jXMZqgnEFoMeUoQ6+BnhRoLAjC450A14pkENU2aoJl
bkXNWYNlA9gru3Da5p2XhqmLuv28IrYeOx869msHto5mhRS9mOh14dLsNWibhqW4
XgJCHkVy5lSZZW+WVlPithuMJhtVKnvvJ5B0TOWnHAxkvZFxlulOAfMQvu4MksYS
+pw+RAxnH480gP/dO4n/K4JK2BiViR5uyF2fGWbeYyeVLUEHDUPTUHbRWOT15KS2
HkKJlnRealFEdhrqIbMMqbY13FOaiCfUAO5myTzTa3/P4ha+WNK+F49fGOxNluPr
spChC0NAI9yPgrPHctLu
=7DHa
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_14_56_49_+1000_RvNdeaxowSz=XyaY--
