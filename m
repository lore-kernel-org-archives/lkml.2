Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967481Ab2EPM5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:57:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:40216 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966072Ab2EPM5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:57:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="144662647"
Message-ID: <1337173272.24809.52.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Wed, 16 May 2012 16:01:12 +0300
In-Reply-To: <1337101871-31181-2-git-send-email-richard@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	 <1337101871-31181-2-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mmee3KLhHXw8RA/PINH/"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mmee3KLhHXw8RA/PINH/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 19:11 +0200, Richard Weinberger wrote:
> The fastmap mechanism needs to read the next sequence nummber
> directly.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

I started looking at the code, and made some notes at the same time and
few minor changes - here is the diff which you can apply on top of your
patches.

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 2399511..2f5c362 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -869,15 +869,22 @@ static int attach_by_fastmap(struct ubi_device *ubi)
=20
 	fm_start =3D ubi_find_fastmap(ubi);
 	if (fm_start < 0)
+		/* TODO: instead, return 1 which means that fall-back to
+		 * scanning is needed */
 		return -ENOENT;
=20
+	/* TODO: we need to re-name scan.h to attach.h, scan_info to
+	 * attach_info, si to ai, seb to aeb, and so on - because we share the
+	 * same data structures between scanning and fastmap, so the word
+	 * "scan" is not very sensible to have in the name any more.
+	 */
 	si =3D ubi_read_fastmap(ubi, fm_start);
 	if (IS_ERR(si))
 		return PTR_ERR(si);
=20
-	ubi->bad_peb_count =3D 0;
+	/* TODO: the rest looks very much like attach_by_scanning() - we
+	 * need to re-structure the code and avoid duplication */
 	ubi->good_peb_count =3D ubi->peb_count;
-	ubi->corr_peb_count =3D 0;
 	ubi->max_ec =3D si->max_ec;
 	ubi->mean_ec =3D si->mean_ec;
 	ubi_msg("max. sequence number:       %llu", si->max_sqnum);
@@ -888,6 +895,7 @@ static int attach_by_fastmap(struct ubi_device *ubi)
 		goto out_si;
 	}
=20
+	/* TODO: the _scan suffix makes no sens anymore - kill it */
 	err =3D ubi_wl_init_scan(ubi, si);
 	if (err) {
 		ubi_err("ubi_wl_init_scan failed!");
@@ -1022,7 +1030,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_=
num, int vid_hdr_offset)
 	err =3D attach_by_fastmap(ubi);
 	if (err) {
 		if (err !=3D -ENOENT)
-			ubi_msg("falling back to attach by scanning mode!");
+			ubi_msg("falling back to attach by scanning");
=20
 		ubi->attached_by_scanning =3D true;
 		err =3D attach_by_scanning(ubi);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 2ea1682..7c5f1f7 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -582,7 +582,12 @@ struct ubi_scan_info *ubi_read_fastmap(struct ubi_devi=
ce *ubi,
 		goto out;
 	}
=20
+	/* TODO: Before checking version - check the CRC.
+	 * I think you need to add a separate helper function in io.c, similar
+	 * to ubi_io_read_vid_hdr(). */
 	if (fmsb->version !=3D UBI_FM_FMT_VERSION) {
+		/* TODO: we can fall back to scanning instead of saying good
+		 * bye! */
 		ubi_err("Unknown fastmap format version!");
 		si =3D ERR_PTR(-EINVAL);
 		kfree(fmsb);
@@ -606,6 +611,7 @@ struct ubi_scan_info *ubi_read_fastmap(struct ubi_devic=
e *ubi,
 	if (!fm_raw) {
 		si =3D ERR_PTR(-ENOMEM);
 		kfree(fmsb);
+		/* TODO: goto? */
 	}
=20
 	vh =3D ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
@@ -617,6 +623,9 @@ struct ubi_scan_info *ubi_read_fastmap(struct ubi_devic=
e *ubi,
 	}
=20
 	for (i =3D 0; i < nblocks; i++) {
+		/* TODO: you basically perform the scanning here - you should
+		 * share the same code as we use in scan.c: use process_peb().
+		 */
 		ret =3D ubi_io_read_vid_hdr(ubi, be32_to_cpu(fmsb->block_loc[i]),
 			vh, 0);
 		if (ret) {
@@ -653,6 +662,7 @@ struct ubi_scan_info *ubi_read_fastmap(struct ubi_devic=
e *ubi,
 				i, be32_to_cpu(fmsb->block_loc[i]));
 			si =3D ERR_PTR(ret);
=20
+			/* TODO: fsmb is not freed? */
 			goto free_vhdr;
 		}
 	}


--=20
Best Regards,
Artem Bityutskiy

--=-mmee3KLhHXw8RA/PINH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs6UZAAoJECmIfjd9wqK0wXEP/2IzAwLv+FebFRh/rdIAQxi1
s5jn/I5if82NTteXgiN1DNZ3wk2K5vIHn+W28zTtM1I3QDsPfiAHTQMFGY7nxaj7
vshh1VFt/Ghfa/SUALMTmd1ZPZdMEyQVLJacqsM0OqUhNwYfUcPIPjSKUB7X18Ce
p6qSiMOKx2eSNulX+hYF2cuUirr8wt+HenchRQis+VrMbuTQgDP5CSxxHSMi5EiV
Gu8UX2vlmobMtxxA+rf4y5vT0mPIk5ADUwpflSxwZpTFXFiHSMBP9ZLqMfsa9/a3
MWbV58Fy6hbflGWp08y1udVGCPnB+G3JK6OwKfMnXPkZxpPLHo023Be7cMyo7GYY
IbnrWuPecIMrFlhs9RT1vqzGNyWiBGSlXVmbF6iQE8JW8mGOh4BqYE5UFXkhY/Kf
DcNVkK1rXf7fbzMxWmmGTWnMgjQLvhb2zSUaboZwZ9J5rcHu2ObLS0b00HR9aYJN
g8LQkoT/bfIQvQcgJc320cWySzQSpfhP+k2g28kchoFO38IAR9pnd9OO+fdUWAOX
5JdB217o3WmQJl/gdmnfa3O7v0NmCO2Crz570P+dr6Iq8yexcgebKrA2eyg2pFaH
tOtt4TB36e0Lc4uf7blMx5FUq+cbuV7To7S2YYO9m7IUoLKenoGdtzOuOw9p9BaM
BuS9MVsbMlgzIaKUj786
=/Z7z
-----END PGP SIGNATURE-----

--=-mmee3KLhHXw8RA/PINH/--

