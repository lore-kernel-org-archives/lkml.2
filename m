Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2EZNXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:23:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63196 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753789Ab2EZNXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:23:06 -0400
Message-ID: <1338038569.2525.21.camel@koala>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Sat, 26 May 2012 16:22:49 +0300
In-Reply-To: <1337771191-95358-2-git-send-email-richard@nod.at>
References: <1337771191-95358-1-git-send-email-richard@nod.at>
	 <1337771191-95358-2-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-VnU6NS+xwRV9Yv36PCpX"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VnU6NS+xwRV9Yv36PCpX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-23 at 13:06 +0200, Richard Weinberger wrote:
> Fastmap (aka checkpointing) allows attaching of an UBI volume in nearly
> constant time. Only a fixed number of PEBs has to be scanned.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>

Richard, Shmulik,

I've created 'fastmap' branch in the UBI tree. I've pushed a patch with
my TODO entries. It is also inlined in this e-mail at the end. I did not
have a lot of time to review this, but I will try to review a little bit
every day.

One thing which is apparent to me is that we have to change the way we
work - it needs improvements. The code drops are difficult to review.
And I noticed few basic errors which makes me believe the testing is not
very extensive.

So, I took an initiative to start hosting a branch where we can both
work on. Hopefully Shmulik too, may be others. I suggest you to send
incremental patches from now. They will go to that branch.

The other thing I strongly believe we must do is regression testing. We
need to start with a small set of simple tests. Then continuously make
it grow. And _every_ change has to be validated before it goes to the
fastmap branch. If something works - it must never be broken. This is
the only realistic way to quickly make fastmap production quality. The
open development in this mailing list hopefully will make more people
join.

So, I've also created a 'fastmap' branch in the mtd-utils.git repo. I've
added a 'fastmap-testing.txt' file there, empty so far. Will keep the
lists of tests we do there. Please, send patches against this branch.
Start with making fastmap pass the ubi teset from
mtd-utils.git/tests/ubi.

Thanks and hopefully this is acceptable for you.

P.S. Note, I do not intend to take over this stuff or anything like
that, I just try to involve myself a bit more, and re-use my experience
from UBIFS development where we use this "no regressions, ever growing
tests" approach. I think it was successful.

I also realize that some comments are nit-picks - we do not have to
address them immediately. We can preserve the TODOs in the code and
address later.

=46rom bd8313d8eb6b00dc4dff3304c49bbd76cc49196a Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 26 May 2012 16:01:06 +0300
Subject: [PATCH] UBI: add a bunch of fastmap TODOs.

Well, it does not look like this code was tested well. We need to start
taking this more seriously.

We need to do the following:

1. Make sure this code passes ubi tests from mtd-utils.git
   a) with images which have fastmap
   b) with images which do not have fastmap
2. Once the they pass, make sure we never break them. Whatever we commit
   has to be tested.
3. Increasingly add more tests and make testing tougher.

I can host the tests in the mtd-utils.git repository in the 'fastmap' branc=
h.

Please, also start sending incremental patches instead of patch-drops. This
will make review easier. I will put them to the 'fastmap' branch.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 TODO                        |   12 ++++++++++++
 drivers/mtd/ubi/attach.c    |   34 +++++++++++++++++++++++++++++++++-
 drivers/mtd/ubi/fastmap.c   |   36 ++++++++++++++++++++++++++++++++++++
 drivers/mtd/ubi/ubi-media.h |    4 ++++
 4 files changed, 85 insertions(+), 1 deletions(-)
 create mode 100644 TODO

diff --git a/TODO b/TODO
new file mode 100644
index 0000000..63a22b9
--- /dev/null
+++ b/TODO
@@ -0,0 +1,12 @@
+This is a TODO list for the fastmap feature which should be done before
+it is merged.
+
+For all or most of the items there we need to write a testcase. We can put=
 it
+to the ubi-utils.git repository, to a separate branch at the beginning
+
+1. Test with a R/O MTD device: !(mtd->flags & MTD_WRITEABLE)
+2. Implement power-cut emulation infrastructure similar to what is in UBIF=
S and
+   test UBI + fastmap with it.
+3. Test the autoresize feature
+4. Test 'ubi_flush()'
+5. Test
diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 23b3d55..792808a 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1224,12 +1224,26 @@ int ubi_attach(struct ubi_device *ubi)
 	int err;
 	struct ubi_attach_info *ai =3D NULL;
=20
+	/* TODO: Allocate ai in this fuction. And destroy it here as well */
+
 	err =3D ubi_scan_fastmap(ubi, &ai);
 	if (err > 0) {
+		/* TODO: in UBIFS we have a convention: every function prints
+		 * its own error messages. This makes things cleaner and easier
+		 * - the caller should not care about printing anything.
+		 * Please, move this error message to 'ubi_scan_fastmap()'. And
+		 * keep this in mind, and do similar thing globally for entire
+		 * fastmap code. */
 		if (err =3D=3D UBI_BAD_FASTMAP)
-			ubi_err("Attach by fastmap failed! " \
+			ubi_err("Attach by fastmap failed! "
 				"Falling back to attach by scanning.");
=20
+		/* TODO: please, remove this variable altogether, it is not
+		 * needed and it is a hack which you use to tell 'scan_peb()'
+		 * to handle fastmap volumes specially. Make this is a clean
+		 * way instead: after the scanning, go through the fastmap
+		 * volumes (if any was found) and delete them or do whatever
+		 * you need. Do not inject hacks to the scanning code. */
 		ubi->attached_by_scanning =3D 1;
 		ai =3D scan_all(ubi);
 		if (IS_ERR(ai))
@@ -1237,6 +1251,12 @@ int ubi_attach(struct ubi_device *ubi)
 	} else if (err < 0)
 		return err;
=20
+	/* TODO: When you create an image with ubinize - you do not know the
+	 * amount of PEBs. So you need to initialize this field with '-1' at
+	 * ubinize time. And here you need to check for -1 and initialize it if
+	 * needed. Then store it at fastmap. This special value has to be also
+	 * documented at ubi-media.h. You also have to amend 'nused' etc.
+	 * Probably this can be done later. */
 	ubi->bad_peb_count =3D ai->bad_peb_count;
 	ubi->good_peb_count =3D ubi->peb_count - ubi->bad_peb_count;
 	ubi->corr_peb_count =3D ai->corr_peb_count;
@@ -1244,6 +1264,10 @@ int ubi_attach(struct ubi_device *ubi)
 	ubi->mean_ec =3D ai->mean_ec;
 	ubi_msg("max. sequence number:       %llu", ai->max_sqnum);
=20
+	/* TODO: If you support fastmap but it was not found, you need to check
+	 * here that ai does not contain fastmap volumes. If it was corrupted,
+	 * you need to delete fastmap volumes or possible leftovers of them.
+	 * And then you have to create _new_ fastmap */
 	err =3D ubi_read_volume_table(ubi, ai);
 	if (err)
 		goto out_ai;
@@ -1257,6 +1281,14 @@ int ubi_attach(struct ubi_device *ubi)
 		goto out_wl;
=20
 	ubi_destroy_ai(ai);
+
+	/* TODO: UBI auto formats the flash if it is empty (see ubi->is_empty).
+	 * It is currently done so that every sub-system writes initializes its
+	 * own stuff. Well, now it is only the vtbl sub-system - it creates
+	 * empty volume table. And this is why we have "early" function for
+	 * getting free PEBs. Fastmap should do the same - so I guess it is
+	 * good to do it somewhere here. Also, we need to re-create the fastmap
+	 * on-flash data-structures if they were corrupted. */
 	return 0;
=20
 out_wl:
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 7757e5a..2ba2a80 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -595,6 +595,8 @@ fail:
  * ubi_find_fastmap - searches the first UBI_FM_MAX_START PEBs for the
  * fastmap super block.
  * @ubi: UBI device object
+ *
+ * TODO: clearly document return codes
  */
 static int ubi_find_fastmap(struct ubi_device *ubi, int *fm_start)
 {
@@ -614,6 +616,11 @@ static int ubi_find_fastmap(struct ubi_device *ubi, in=
t *fm_start)
=20
 		if (be32_to_cpu(vhdr->vol_id) =3D=3D UBI_FM_SB_VOLUME_ID) {
 			*fm_start =3D i;
+			/* TODO: fix globally: all UBI prints:
+			 *  a) do not need the '\n' at the end
+			 *  b) start with a small letter, because the macros
+			 *     add several prefixes.
+			 */
 			dbg_bld("Found fastmap super block at PEB %i\n", i);
 			ret =3D 0;
=20
@@ -623,6 +630,23 @@ static int ubi_find_fastmap(struct ubi_device *ubi, in=
t *fm_start)
=20
 	ubi_free_vid_hdr(ubi, vhdr);
=20
+	/* TODO: we can return:
+	 * < 0 - error
+	 * 0 - fastmap found
+	 * 0 - also if we did not find fastmap and the last
+	 *     'ubi_io_read_vid_hdr()' call returned 0. This was not
+	 *     tested with volumes which do not contain fastmap? We need to
+	 *     test this - we need to have a testcase for this in mtd-utils. I
+	 *     can create a branch there and we should agree on which tests are
+	 *     run before anything goes into the git repo.
+	 * > 0 - ignore?
+	 *
+	 * Please, make it instead:
+	 * return 0 - no errors
+	 * return < 0 - error
+	 * If FM not found, fm_start =3D -1
+	 * If FM found, fm_start is set properly
+	 */
 	return ret;
 }
=20
@@ -650,6 +674,13 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ub=
i_attach_info **ai)
=20
 		goto out;
 	}
+	/* TODO: then this will be:
+	 * if (ret)
+	 *         return ret;
+	 * if (sb_pnum =3D=3D -1)
+	 *         return UBI_NO_FASTMAP;
+	 *
+	 * Much better, I think */
=20
 	fmsb =3D kmalloc(sizeof(*fmsb), GFP_KERNEL);
 	if (!fmsb) {
@@ -661,6 +692,11 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ub=
i_attach_info **ai)
 	ret =3D ubi_io_read(ubi, fmsb, sb_pnum, ubi->leb_start, sizeof(*fmsb));
 	if (ret) {
 		ubi_err("Unable to read fastmap super block");
+		/* TODO: please, read what 'ubi_io_read()' returns.
+		 * This code is incorrect. All return codes are carefully
+		 * documented there. And do it globally, I see you ignore the
+		 * bitflips error code and treat it as error everywhere.
+		 * Please, start testing with UBI bit-flips emulation enabled */
 		if (ret > 0)
 			ret =3D UBI_BAD_FASTMAP;
=20
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 0e3019a..35628c3 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -389,6 +389,7 @@ struct ubi_vtbl_record {
 #define UBI_FM_POOL_MAGIC	0x67AF4D08
 #define UBI_FM_EBA_MAGIC	0xf0c040a8
=20
+/* TODO: would be great to have short coments for the constants */
 #define UBI_FM_MAX_START	64
 #define UBI_FM_MAX_BLOCKS	32
 #define UBI_FM_MIN_POOL_SIZE	8
@@ -426,6 +427,9 @@ struct ubi_fm_sb {
  */
 struct ubi_fm_hdr {
 	__be32 magic;
+	/* TODO: would you please name these fields using the same names UBI
+	 * uses in the in-RAM data structures (bad_peb_count, good_peb_count,
+	 * etc.) See struct ubi_device. */
 	__be32 nfree;
 	__be32 nused;
 	__be32 nvol;
--=20
1.7.7.6

--=20
Best Regards,
Artem Bityutskiy

--=-VnU6NS+xwRV9Yv36PCpX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPwNkpAAoJECmIfjd9wqK0SL0QAMiqGNMlZgmkVMn/wqoTSJaI
Sei56mXVkkp1rxKgEXi5Fl+bq3mLD8T+cxPUD/thzjX0HIeqMzUtRtgwJlza2Gx4
QqY/FfRQNJbVPzuY5S4vSl4tcAtc+iSnXoIIDp/GWD1k3TqqpO037waoGCwb5Icu
bVU9Kcq1ByBrqGyW0R2q2GQ25NU4/Y1zyBOLwtn/mVpja4eBd1GCliANTIQw18XP
w0sV3iKVpGM5Ci+PtSiLN5lXga6x7Zao8u9mZfYbef7vHGAArApPzD0ejrv8oWnH
IY314hQRyuY7aUGCPZVvD8ufmHr5SgQ2T+N/mj4YTSd6fkP/HOUzCAGT/JIyA/3H
/KEcCAeWzosxnFr0XZjWIDU/TfzwCrL3pBo9xargg8TNKY0YxoRDKUnKYPoDcaM3
o9p0kb4RwIqNiRKEe37qTrfwzsFUggGYojDkpbsZLm2YK6iOuEBbho7O2v5Qw3UP
kQGFYF70WELZLw98DXS4yO41VIfhqn7CaPx0T4MSW+X3ykvLm6zujSIgiqT9knVV
WDiUDlqsfHjjUCdY7HZ/u2+psRNSwNzhdAn4JG/k5cQ1cJKOuHKCyOIPnDrRicpx
lNGV5NX5BDVSIiYet8gp6MEbUW3IR5jJMvX5pVQ/OxXdWjIE9/EKpPHmJ9T3lng7
pt2WXXdPyS9uZOFUQrfX
=vdSg
-----END PGP SIGNATURE-----

--=-VnU6NS+xwRV9Yv36PCpX--

