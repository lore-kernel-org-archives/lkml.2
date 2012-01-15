Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2AOOVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 09:21:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57024 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2AOOVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 09:21:48 -0500
Subject: Re: [PATCH] PM / MTD: Fix regressions related to mtd_suspend()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org
Date: Sun, 15 Jan 2012 16:21:45 +0200
In-Reply-To: <201201151443.30897.rjw@sisk.pl>
References: <201201151443.30897.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Toh7+SPC9WC95BjuoCuu"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1326637306.2201.22.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Toh7+SPC9WC95BjuoCuu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-01-15 at 14:43 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Commit 3fe4bae88460869a8e553397cd9057a4ee7ca341 (mtd: introduce
> mtd_suspend interface) introduced the mtd_suspend() routine
> which didn't check whether or not mtd and mtd->suspend were
> both valid pointers.  Later commit 079c985e7a6f4ce60f931cebfdd5ee3c3
> (mtd: do not use mtd->suspend and mtd->resume directly) added the
> check for mtd->suspend, but still it failed to check mtd.  Moreover,
> it caused mtd_suspend() to return an error code for NULL
> mtd->suspend, which makes system suspend fail on one of my test
> systems on every attempt and which is a regression from v3.2.
>=20
> Fix mtd_suspend() by making it check if mtd is not NULL and
> return 0 if mtd or mtd->suspend is NULL, which shouldn't prevent
> the system from suspending.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  include/linux/mtd/mtd.h |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> Index: linux/include/linux/mtd/mtd.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/linux/mtd/mtd.h
> +++ linux/include/linux/mtd/mtd.h
> @@ -427,9 +427,7 @@ static inline int mtd_is_locked(struct m
> =20
>  static inline int mtd_suspend(struct mtd_info *mtd)
>  {
> -	if (!mtd->suspend)
> -		return -EOPNOTSUPP;
> -	return mtd->suspend(mtd);
> +	return mtd && mtd->suspend ? mtd->suspend(mtd) : 0;
>  }

Thanks! But All the MTD API functions assume that the "mtd" pointer is
non-NULL, and this function should to the same for consistency.

Would you please give this patch a test?

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index b265188..de96865 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -119,7 +119,7 @@ static int mtd_cls_suspend(struct device *dev, pm_messa=
ge_t state)
 {
        struct mtd_info *mtd =3D dev_get_drvdata(dev);
=20
-       return mtd_suspend(mtd);
+       return mtd ? mtd_suspend(mtd) : 0;
 }
=20
 static int mtd_cls_resume(struct device *dev)
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 1a81fde..d8c7aad 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -427,9 +427,7 @@ static inline int mtd_is_locked(struct mtd_info *mtd, l=
off_t ofs, uint64_t len)
=20
 static inline int mtd_suspend(struct mtd_info *mtd)
 {
-       if (!mtd->suspend)
-               return -EOPNOTSUPP;
-       return mtd->suspend(mtd);
+       return mtd->suspend ? mtd->suspend(mtd) : 0;
 }

--=20
Best Regards,
Artem Bityutskiy

--=-Toh7+SPC9WC95BjuoCuu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPEuD5AAoJEJtuLFy+q7fe08kIAJfUnIaywgMoEiVQKW16CAfR
JeIwizfyYRM4a44OZH38UGX4wj9rpuEvqVz77NanyQylZFTV6jVTxLbkEPyV86/B
zeK2Scg35hKT6F+ZxoNqoiXmfzXLb6LJFWrfVOJFJlkM0m4++1QlWA3odWN5Honm
JIYh+Y2/Oxws0LNK5NEnldLiFh+DCfdMDhmC9nZPXtlyOzE3q2z0H3jiK6fOmJ/r
+uNkX7xAhKrWjheI+kK2O/E4DuhjXYMxlw/lUOtJHbKPp/8TFhzwBLeHGU5Y89r0
71fS4/aDuKzta0P3Z+Mv7mBt7Ab7/LlIn6q1hR/yf6bH5zHelrpSnvhwYi/yniQ=
=wQMi
-----END PGP SIGNATURE-----

--=-Toh7+SPC9WC95BjuoCuu--

