Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2F1MkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:40:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:61301 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2F1MkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:40:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="171089890"
Message-ID: <1340887459.3070.100.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 04/16] UBI: Fastmap: Rename self_check_fastmap()
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, nyoushchenko@mvista.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, Marius.Mazarel@ugal.ro,
        tim.bird@am.sony.com
Date: Thu, 28 Jun 2012 15:44:19 +0300
In-Reply-To: <1340812676-14460-5-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
	 <1340812676-14460-5-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-jiHgj+UTY2ID7az2mGeS"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jiHgj+UTY2ID7az2mGeS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-27 at 17:57 +0200, Richard Weinberger wrote:
> Signed-off-by: Richard Weinberger <richard@nod.at>

Hi, pushed this and added a couple of TODOs. Could you please take a
look? Most TODOs are non-essential and easy, but one is more important -
the one about regression in attach time of non-fastmap images.

Thanks!

=46rom b43ceb01a33b322898232fb05e5cc7f754656421 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Thu, 28 Jun 2012 15:08:29 +0300
Subject: [PATCH 1/2] UBI: Fastmap: rename new_ai to alloc_ia

Just more consistent, we do not use "new" in, e.g., 'ubi_zalloc_vid_hdr()'.
Also move the code to avoid forward references, which we also do not use.

Also get rid of unneeded goto in alloc_ia(). Nothing major.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/attach.c |   41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 7552d25..8204b2d 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -91,7 +91,6 @@
=20
 static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *a=
i);
 static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)=
;
-static struct ubi_attach_info *new_ai(void);
=20
 /* Temporary variables used during scanning */
 static struct ubi_ec_hdr *ech;
@@ -1216,6 +1215,22 @@ out_ai:
 	return err;
 }
=20
+static struct ubi_attach_info *alloc_ai(void)
+{
+	static struct ubi_attach_info *ai;
+
+	ai =3D kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	if (ai) {
+		INIT_LIST_HEAD(&ai->corr);
+		INIT_LIST_HEAD(&ai->free);
+		INIT_LIST_HEAD(&ai->erase);
+		INIT_LIST_HEAD(&ai->alien);
+		ai->volumes =3D RB_ROOT;
+	}
+
+	return ai;
+}
+
 /**
  * ubi_attach - attach an MTD device.
  * @ubi: UBI device descriptor
@@ -1229,7 +1244,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan=
)
 	int err;
 	struct ubi_attach_info *ai;
=20
-	ai =3D new_ai();
+	ai =3D alloc_ai();
 	if (!ai)
 		return -ENOMEM;
=20
@@ -1239,7 +1254,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan=
)
 		err =3D ubi_scan_fastmap(ubi, ai);
 		if (err > 0) {
 			destroy_ai(ubi, ai);
-			ai =3D new_ai();
+			ai =3D alloc_ai();
 			if (!ai)
 				return -ENOMEM;
=20
@@ -1279,7 +1294,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan=
)
=20
 	if (ubi->fm && ubi->dbg->chk_gen) {
 		struct ubi_attach_info *scan_ai;
-		scan_ai =3D new_ai();
+		scan_ai =3D alloc_ai();
 		if (!scan_ai)
 			goto out_ai;
=20
@@ -1395,24 +1410,6 @@ static void destroy_ai(struct ubi_device *ubi, struc=
t ubi_attach_info *ai)
 	kfree(ai);
 }
=20
-static struct ubi_attach_info *new_ai(void)
-{
-	static struct ubi_attach_info *ai;
-
-	ai =3D kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-	if (!ai)
-		goto out;
-
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes =3D RB_ROOT;
-
-out:
-	return ai;
-}
-
 /**
  * self_check_ai - check the attaching information.
  * @ubi: UBI device description object
--=20
1.7.10


=46rom 400a911b104d88bbf6cc593e8bb24c9865a1c449 Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Thu, 28 Jun 2012 15:34:17 +0300
Subject: [PATCH 2/2] UBI: fastmap: some todo and random changes

Add few consmetic changes and a bunch of TODOs.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/attach.c |   29 +++++++++++++++++++++++++++++
 drivers/mtd/ubi/eba.c    |    7 ++++---
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 8204b2d..3d9be42 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -89,6 +89,13 @@
 #include <linux/random.h>
 #include "ubi.h"
=20
+/*
+ * TODO: please, no forward declarations. We do not use them in UBI code.
+ * Actually initially I did use them a lot, but when upstreaming, I was as=
ked
+ * to remove. Please, follow this convention as well. Please, change globa=
lly.
+ * I mean, I am already used to that _all_ the code is upside-down, let's =
keep
+ * it that way, or re-structure all the code. :-)
+ */
 static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *a=
i);
 static void destroy_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)=
;
=20
@@ -1170,6 +1177,7 @@ static int scan_all(struct ubi_device *ubi, struct ub=
i_attach_info *ai)
 	if (ai->ec_count)
 		ai->mean_ec =3D div_u64(ai->ec_sum, ai->ec_count);
=20
+	/* TODO: if we attach by fastmap, we do not execute this? */
 	err =3D late_analysis(ubi, ai);
 	if (err)
 		goto out_vidh;
@@ -1251,6 +1259,25 @@ int ubi_attach(struct ubi_device *ubi, int force_sca=
n)
 	if (force_scan)
 		err =3D scan_all(ubi, ai);
 	else {
+		/* TODO: this is a regression. If I have an old image, and I do
+		 * not want to use fastmap, I will be forced to waste time for
+		 * useless scan of 64 first eraseblocks. Not good.
+		 *
+		 * Can you teach ubi_scan_fastmap() to use 'scan_peb()'
+		 * function for scanning and build normal ai information? If it
+		 * finds fastmap - it can destroy the collected ai. If it does
+		 * not find, it returns ai. Then you just confinue scanning.
+		 *
+		 * I buess what we'll need is:
+		 * 1. scan_all() -> scan_range(..., int pnum1, int pnum2);
+		 * 2. ubi_scan_fastmap() returns the pnum of the last scanned
+		 *    eraseblock if fastmap was not found;
+		 *    Also 'ubi_scan_fastmap()' uses scan_peb() for scanning.
+		 * 3. You call 'scan_range(..., pnum, c->peb_cnt - 1)' and
+		 *    it continues.
+		 *
+		 * And no regressions.
+		 */
 		err =3D ubi_scan_fastmap(ubi, ai);
 		if (err > 0) {
 			destroy_ai(ubi, ai);
@@ -1276,6 +1303,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan=
)
 	if (err)
 		goto out_ai;
=20
+	/* TODO: Hmm why this code is not hidden in 'ubi_scan_fastmap()' ? */
 	if (ubi->fm) {
 		ubi->fm_pool.max_size =3D ubi->fm->max_pool_size;
 		ubi->fm_wl_pool.max_size =3D ubi->fm->max_wl_pool_size;
@@ -1294,6 +1322,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan=
)
=20
 	if (ubi->fm && ubi->dbg->chk_gen) {
 		struct ubi_attach_info *scan_ai;
+
 		scan_ai =3D alloc_ai();
 		if (!scan_ai)
 			goto out_ai;
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index cb0139c..6d6e301 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -1218,11 +1218,12 @@ static void print_rsvd_warning(struct ubi_device *u=
bi,
 }
=20
 /**
- * self_check_eba - run a self check on the EBA table construected by fast=
map.
- *
+ * self_check_eba - run a self check on the EBA table constructed by fastm=
ap.
  * @ubi: UBI device description object
  * @ai_fastmap: UBI attach info object created by fastmap
  * @ai_scan: UBI attach info object created by scanning
+ *
+ * TODO: what we do and what return.
  */
 int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fast=
map,
 		   struct ubi_attach_info *ai_scan)
@@ -1290,6 +1291,7 @@ int self_check_eba(struct ubi_device *ubi, struct ubi=
_attach_info *ai_fastmap,
=20
 				ubi_err("LEB:%i:%i is PEB:%i instead of %i!",
 					vol->vol_id, i, fm_eba[i][j], scan_eba[i][j]);
+				/* TODO: no, please, return error instead */
 				BUG();
 			}
 		}
@@ -1306,7 +1308,6 @@ out_free:
=20
 	kfree(scan_eba);
 	kfree(fm_eba);
-
 	return ret;
 }
=20
--=20
1.7.10

--=20
Best Regards,
Artem Bityutskiy

--=-jiHgj+UTY2ID7az2mGeS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7FGjAAoJECmIfjd9wqK0yd0P/16gmyWi8SjHUFvoeWYvXVbx
Ob5azqSVv4L81WqYXp3itkCVR6rlq7GZcsMDEVs6Ly78LQp7Jnb6VZM0RnfFplQt
Yx9jdThayQuuoOnZJMMI+rgp7BBsGx0dwXWsp/07x4bZAMIM7HuqjtRIxQrbEbml
n+sc+6ovctq4u1uD+7gRMSvV5np0mMzuFVyXNEyvGgUnkpgMSNZRa+B+8d9uj+48
nbZVr/3RwjoxXLN/RpPtXUAtgVKblL+Cjpf5dBmvQHHY0FJaSfyhfN7gS8Q28c3g
art9ygG8aWE1VrSsH9Ae66p7Zf8Up5uCdVZnbzaiKv3DVJr6e8SqEaI7TSVJFkNU
4Mwx5whLxeJb7oA1ghoPKme3pjkoiyV2tNoeZBUPA4WiZrvXdvq21lEaa4MzV8I3
KGrCy0JuZZOsZwcxyi+oXAGl4snSZRRNKnZ6CTIaMG+Xx7nV8sB+eiMROkU0joqr
Os2VmfPruRhJ389VpSb9H4iJVLTVh/L/TuVtKovUiKsCbO2wPgR1GrLZ/iUAYr5z
fbQlWm1FrZAi3L6ZFtNGCXDBERMTmHzJSp347qP+Nl0bEi5qalsXW2KRQzuYfzqh
wPky6eZasz0+8+x/JcClfHgHRu4DKpFHzfVXbxwcU/dkLXRWTGp8XjYRuOtiyiff
E4y913zDc7myZAHxF0K4
=pJsA
-----END PGP SIGNATURE-----

--=-jiHgj+UTY2ID7az2mGeS--

