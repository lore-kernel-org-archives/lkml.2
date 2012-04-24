Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2DXOXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:23:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679Ab2DXOW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:22:59 -0400
Subject: GFS2: Pull request (fix)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zlDNosrtsCefN1nlja9P"
Organization: Red Hat UK Ltd
Date: Tue, 24 Apr 2012 15:06:40 +0100
Message-ID: <1335276400.2706.72.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zlDNosrtsCefN1nlja9P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following fix,

Steve.

---------------------------------------------------------------------------=
--
The following changes since commit 95f714727436836bb46236ce2bcd8ee8f9274aed=
:

  Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/tytso/ext4 (2012-04-23 19:52:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Bob Peterson (1):
      GFS2: Instruct DLM to avoid queue convert slowdown

 fs/gfs2/lock_dlm.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

--------------------------------------------------------------------------
=46rom 4c569a72c30dfee9b5133284aba67e3aa0c9505d Mon Sep 17 00:00:00 2001
From: Bob Peterson <rpeterso@redhat.com>
Date: Tue, 10 Apr 2012 14:45:24 -0400
Subject: [PATCH] GFS2: Instruct DLM to avoid queue convert slowdown

This patch instructs DLM to prevent an "in place" conversion, where the
lock just stays on the granted queue, and instead forces the conversion to
the back of the convert queue. This is done on upward conversions only.

This is useful in cases where, for example, a lock is frequently needed in
PR on one node, but another node needs it temporarily in EX to update it.
This may happen, for example, when the rindex is being updated by gfs2_grow=
.
The gfs2_grow needs to have the lock in EX, but the other nodes need to
re-read it to retrieve the updates. The glock is already granted in PR on
the non-growing nodes, so this prevents them from continually re-granting
the lock in PR, and forces the EX from gfs2_grow to go through.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index f8411bd..5f5e70e 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -200,10 +200,11 @@ static int make_mode(const unsigned int lmstate)
 	return -1;
 }
=20
-static u32 make_flags(const u32 lkid, const unsigned int gfs_flags,
+static u32 make_flags(struct gfs2_glock *gl, const unsigned int gfs_flags,
 		      const int req)
 {
 	u32 lkf =3D DLM_LKF_VALBLK;
+	u32 lkid =3D gl->gl_lksb.sb_lkid;
=20
 	if (gfs_flags & LM_FLAG_TRY)
 		lkf |=3D DLM_LKF_NOQUEUE;
@@ -227,8 +228,11 @@ static u32 make_flags(const u32 lkid, const unsigned i=
nt gfs_flags,
 			BUG();
 	}
=20
-	if (lkid !=3D 0)=20
+	if (lkid !=3D 0) {
 		lkf |=3D DLM_LKF_CONVERT;
+		if (test_bit(GLF_BLOCKING, &gl->gl_flags))
+			lkf |=3D DLM_LKF_QUECVT;
+	}
=20
 	return lkf;
 }
@@ -250,7 +254,7 @@ static int gdlm_lock(struct gfs2_glock *gl, unsigned in=
t req_state,
 	char strname[GDLM_STRNAME_BYTES] =3D "";
=20
 	req =3D make_mode(req_state);
-	lkf =3D make_flags(gl->gl_lksb.sb_lkid, flags, req);
+	lkf =3D make_flags(gl, flags, req);
 	gfs2_glstats_inc(gl, GFS2_LKS_DCOUNT);
 	gfs2_sbstats_inc(gl, GFS2_LKS_DCOUNT);
 	if (gl->gl_lksb.sb_lkid) {
--=20
1.7.4



--=-zlDNosrtsCefN1nlja9P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPlrNrAAoJEMrg3m4a/8jSc50QAIlepKtgrBwkg4l+4iq4naWR
iKFQGuQzpGAGcGBvL2O6wSMhlxZDP3Da1ueE5Wtx8uxdLkJPv+8d8SSF0vfxcZpv
2XJcOrA8f/WiaLuDupdn8GHrNKIGt3LjyIrTSFJjqzY2OWKpXDUlIOkHIwzUbCoH
0+6FU1qgdr95eIo+FHjQpsflVXsLJw+o6JHhlickEzBAE0nPXJnwmbad1HrEV/OD
Th0pFDrPr2QQTthBOoatQaXlgRiUMU0oEGSlWFpC1D9p3kRnrOD55pdY8JEV5c8M
5wUh3i8jhZNu0FhSmdJE5zWOAoBJfIMzdtuV/9IR92WP+jY37UXQGURqm01Lu8ka
ANl8F8svqVGJ4NOH3XdMz3zwFa2rSpDtKh5ANz+kCZ2pKZdtu8Bp6eOsnPbOki3E
2LDkqWrzQ500Vyh3WVsqA0mnlMz6WI4ei/N2atGasVZgjCZA2+YytYolifiD4jKl
vMvTs8S/GRglaNEzJ2gQnt/QoQt+LWr+eJ53FZVIFHMClQ9UXEPgg/DCSOwnjnVY
yaobos2s/J4WX/tiyYfl1pZ6rkdBMUse4d3RgJerWjIstPlSrzl3QXS9MO/p7YLA
EF+3lZ5wFSmsBdGwRYuisve+ROeYk2TYJ6iXLRRI4DDFA1twrM2VrTzmMl/SkjUw
sogqozMxXcMGZTiOFxsw
=/c9j
-----END PGP SIGNATURE-----

--=-zlDNosrtsCefN1nlja9P--

