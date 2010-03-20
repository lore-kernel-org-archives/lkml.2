Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab0CTPcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 11:32:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0CTPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 11:31:57 -0400
Date: Sat, 20 Mar 2010 16:31:46 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-mtd@lists.infradead.org,
       kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] mtd/maps/pismo: remove dangling pointer and a
	leak
Message-ID: <20100320153146.GB5515@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-2-git-send-email-w.sang@pengutronix.de> <20100320145729.GA5399@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20100320145729.GA5399@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 20, 2010 at 02:57:30PM +0000, Russell King wrote:
> On Sat, Mar 20, 2010 at 03:12:42PM +0100, Wolfram Sang wrote:
> > + exit_free:
> > +	i2c_set_clientdata(client, NULL);
> > +	kfree(prismo);
>=20
> And this is a compile error...

[grabbing some brown paper bags]

I'm sorry. That was one of the manually adapted ones :(
Here is the typo corrected:

Subject: [PATCH V2] mtd/maps/pismo: remove dangling pointer and a leak

While looking for drivers which forgot to clear i2c_clientdata before freei=
ng
the data structure it points to, I found that the pismo driver even has a l=
eak
on the probe error path.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/mtd/maps/pismo.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/pismo.c b/drivers/mtd/maps/pismo.c
index 30e12c8..f021018 100644
--- a/drivers/mtd/maps/pismo.c
+++ b/drivers/mtd/maps/pismo.c
@@ -233,6 +233,7 @@ static int __devexit pismo_remove(struct i2c_client *cl=
ient)
 	/* FIXME: set_vpp needs saner arguments */
 	pismo_setvpp_remove_fix(pismo);
=20
+	i2c_set_clientdata(client, NULL);
 	kfree(pismo);
=20
 	return 0;
@@ -271,7 +272,7 @@ static int __devinit pismo_probe(struct i2c_client *cli=
ent,
 	ret =3D pismo_eeprom_read(client, &eeprom, 0, sizeof(eeprom));
 	if (ret < 0) {
 		dev_err(&client->dev, "error reading EEPROM: %d\n", ret);
-		return ret;
+		goto exit_free;
 	}
=20
 	dev_info(&client->dev, "%.15s board found\n", eeprom.board);
@@ -282,6 +283,11 @@ static int __devinit pismo_probe(struct i2c_client *cl=
ient,
 				      pdata->cs_addrs[i]);
=20
 	return 0;
+
+ exit_free:
+	i2c_set_clientdata(client, NULL);
+	kfree(pismo);
+	return ret;
 }
=20
 static const struct i2c_device_id pismo_id[] =3D {

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuk6mIACgkQD27XaX1/VRtWIgCgkU0LmGX9twrvrsTf1Qu7lavx
31oAoLJuDs3Kba8eewfOC6ViHvkhmkri
=P9pj
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
