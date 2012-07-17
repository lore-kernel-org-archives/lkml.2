Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab2GQPOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:14:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab2GQPOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:14:12 -0400
Message-ID: <1342538038.1813.1.camel@koala>
Subject: Re: [PATCH 0/3] fs/sysv: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 17 Jul 2012 18:13:58 +0300
In-Reply-To: <20120713144244.f3c9fb27.akpm@linux-foundation.org>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
	 <1342103878.18274.98.camel@sauron.fi.intel.com>
	 <20120713144244.f3c9fb27.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-O4VLXN2fzFYygjYKmMHD"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O4VLXN2fzFYygjYKmMHD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Tue, 3 Jul 2012 15:47:44 +0300
Subject: [PATCH] fs/sysv: stop using write_super and s_dirt

It does not look like sysv FS needs 'write_super()' at all, because all it
does is a timestamp update. I cannot test this patch, because this
file-system is so old and probably has not been used by anyone for years,
so there are no tools to create it in Linux.

In sysv FS marking the superblock as dirty is basically marking the superbl=
ock
buffers as drity and then setting the s_dirt flag. And when 'write_super()'=
 is
executed to handle the s_dirt flag, we just update the timestamp and again =
mark
the superblock buffer as dirty. The reason for this strange behavior is
probably that the Linux sysv implementation is trying to do what sysv itsel=
f
was doing:

"It's the way sysv itself does stuff. The timestamp on v7/sys3/sys5
reflects the clock on the box. A lot of ancient boxes with no decent
hardware clocks used to reset the system time off the root fs superblock
on a loss of power" (Alan Cox).

However, the Linux sysv FS implementation is very unlikely of much help for
clock-less systems anyway, because it updates the superblock time-stamp _on=
ly_
if there was write activity, therwise it does not.

Thus, we can update the timestamp more opprtunistically - on unmount or rem=
ount
of sync, and nothing should change. So this patch removes 'sysv_write_super=
()'
and 's_dirt'.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

Updated the changelog, nothing else.

 fs/sysv/inode.c |   10 ----------
 fs/sysv/sysv.h  |    1 -
 2 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index f20ffe3..80e1e2b 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -43,7 +43,6 @@ static int sysv_sync_fs(struct super_block *sb, int wait)
 	 * then attach current time stamp.
 	 * But if the filesystem was marked clean, keep it clean.
 	 */
-	sb->s_dirt =3D 0;
 	old_time =3D fs32_to_cpu(sbi, *sbi->s_sb_time);
 	if (sbi->s_type =3D=3D FSTYPE_SYSV4) {
 		if (*sbi->s_sb_state =3D=3D cpu_to_fs32(sbi, 0x7c269d38 - old_time))
@@ -57,14 +56,6 @@ static int sysv_sync_fs(struct super_block *sb, int wait=
)
 	return 0;
 }
=20
-static void sysv_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		sysv_sync_fs(sb, 1);
-	else
-		sb->s_dirt =3D 0;
-}
-
 static int sysv_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct sysv_sb_info *sbi =3D SYSV_SB(sb);
@@ -351,7 +342,6 @@ const struct super_operations sysv_sops =3D {
 	.write_inode	=3D sysv_write_inode,
 	.evict_inode	=3D sysv_evict_inode,
 	.put_super	=3D sysv_put_super,
-	.write_super	=3D sysv_write_super,
 	.sync_fs	=3D sysv_sync_fs,
 	.remount_fs	=3D sysv_remount,
 	.statfs		=3D sysv_statfs,
diff --git a/fs/sysv/sysv.h b/fs/sysv/sysv.h
index 11b0767..0bc35fd 100644
--- a/fs/sysv/sysv.h
+++ b/fs/sysv/sysv.h
@@ -117,7 +117,6 @@ static inline void dirty_sb(struct super_block *sb)
 	mark_buffer_dirty(sbi->s_bh1);
 	if (sbi->s_bh1 !=3D sbi->s_bh2)
 		mark_buffer_dirty(sbi->s_bh2);
-	sb->s_dirt =3D 1;
 }
=20
=20
--=20
1.7.7.6



--=-O4VLXN2fzFYygjYKmMHD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBYE2AAoJECmIfjd9wqK0sdYP/j9LSv1wXED4HyPDclR8tlSS
AUE20IGm3AUoaJDMczu9AFbajigzqCwZ2C4FPotQ3hFpmpA+ouwf6zHg1LBUDtuO
uBdvHPMx89AXCc3fb+ax9JD/stA+GYd8BKdZr+nZitxIyvmyubZZDf6HjjsMxqWS
hV/260tDn5OSVs2ZbNZYh17wKtKfPyULPqxjBZUtVaRY7HognY+R+I+L8bw8heUK
htw+pktquXnCNbXnykNunCuzkUtgKbkG2Ghp14JjFgQsmWevNe6t4cPn2f0airOk
x+xe5Abg4M/ya/HYhZevH8T/6PlBAfocU+kMbBVaOdMrhWjGRz9yDAX5PGBIKiET
g+zsnHkpqB3CFeASB1MG6cknP31RQng+OQ8hiQ4q17+PKO+iFojOktgsis6W+2Iv
NlUxORNBgrwj4ZcNkRjpkW0kbMR2S7GGDXbRL24eAy9MjEz3Rn73tRX1TKB6L+ku
n8KS4trlaFENFa91b24yM1n+0qgddBisx3TrG00n8MYHUH9AcV/mLObUigm4t+8P
XWkrol5NPmb6DvFX91n5xEOqUFxD3o3vWNPr5wbDAVpWALlzmNF5cD3rMfvMAbUd
zFAjGLHJ1rRNHdKyHLaz6eeu9rqTQswPSnjZspwek6zhN1j5SAX9Bb9UFtqlgMvz
G7S2A3hSXKiLaOMDQoJ/
=vzk8
-----END PGP SIGNATURE-----

--=-O4VLXN2fzFYygjYKmMHD--

