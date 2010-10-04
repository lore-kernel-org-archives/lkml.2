Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab0JDBvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 21:51:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56135 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0JDBu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 21:50:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=K68TFrPeU878aANKAam8rHpVv87XIIcsJ3A/QdLUlDOXM7p8iT/Sj5SnV3bohOJlGe
         1GYn6Y4mr3EAKByczRiiP2h7SpCm12fmPC2VOUA5FATWPnIBqhXN/QeBhGSYye/cmUnP
         5tDz76ThixqfohF+HTVTf3P856f0miW/NRW14=
Date: Sun, 3 Oct 2010 18:50:56 -0700
From: Brian Harring <ferringb@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, richard.rojfors@pelagicore.com
Subject: [PATCH] add platform_data only if non NULL
Message-ID: <20101004015056.GA22095@hrair>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If a NULL or 0 size platform_data is added, the underlying dup results in a=
 pointer into nullspace- meaning drivers can't do null checks for platform_=
data.

This fixes an oops during probing for drivers/net/ks8842, and drivers/mmc/h=
ost/sdhci-pltform when the mfd is timberdale

Signed-off-by: Brian Harring <ferringb@gmail.com>
---
 drivers/mfd/mfd-core.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 1823a57..eee73a8 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -38,10 +38,15 @@ static int mfd_add_device(struct device *parent, int id,
 	pdev->dev.parent =3D parent;
 	platform_set_drvdata(pdev, cell->driver_data);
=20
-	ret =3D platform_device_add_data(pdev,
-			cell->platform_data, cell->data_size);
-	if (ret)
-		goto fail_res;
+	if (cell->data_size) {
+		ret =3D platform_device_add_data(pdev,
+				cell->platform_data, cell->data_size);
+		if (ret)
+			goto fail_res;
+	} else {
+		/* potentially nulled already, just being paranoid. */
+		pdev->dev.platform_data =3D NULL;
+	}
=20
 	for (r =3D 0; r < cell->num_resources; r++) {
 		res[r].name =3D cell->resources[r].name;
--=20
1.7.2


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEARECAAYFAkypMwAACgkQsiLx3HvNzgfy3gCgwh50x3WcuaGozGb2A/xnfbMc
Xj4AnA7J1Z7voMpmIEHUGPkTRDrcg7yG
=XmOU
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
