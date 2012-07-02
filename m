Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2GBOJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:09:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:65427 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2GBOJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:09:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208,223";a="172522894"
Message-ID: <1341238411.2979.19.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] hfsplus: get rid of write_super
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 17:13:31 +0300
In-Reply-To: <1339587471-2713-5-git-send-email-dedekind1@gmail.com>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
	 <1339587471-2713-5-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8IZMCauJC19rQNGdJj75"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8IZMCauJC19rQNGdJj75
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=46rom 6db7ba9f129f1f7bd8c252089700abc6935e3d9a Mon Sep 17 00:00:00 2001
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Wed, 13 Jun 2012 14:17:40 +0300
Subject: [PATCH 23/23] hfsplus: get rid of write_super

This patch makes hfsplus stop using the VFS '->write_super()' method along =
with
the 's_dirt' superblock flag, because they are on their way out.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds =
and
writes out all dirty superblocks using the '->write_super()' call-back.  Bu=
t the
problem with this thread is that it wastes power by waking up the system ev=
ery
5 seconds, even if there are no diry superblocks, or there are no client
file-systems which would need this (e.g., btrfs does not use
'->write_super()'). So we want to kill it completely and thus, we need to m=
ake
file-systems to stop using the '->write_super()' VFS service, and then remo=
ve
it together with the kernel thread.

Tested using fsstress from the LTP project.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfsplus/bitmap.c     |    4 ++--
 fs/hfsplus/dir.c        |    2 +-
 fs/hfsplus/hfsplus_fs.h |    6 +++++-
 fs/hfsplus/inode.c      |    6 +++---
 fs/hfsplus/super.c      |   41 +++++++++++++++++++++++++++++++++--------
 5 files changed, 44 insertions(+), 15 deletions(-)

|This is patch is the same except that it fixes several white-space
|issues. If you prefer an incremental patch, please, let me know. The
|issues are:
|
|WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statement=
s (8, 15)
|#170: FILE: fs/hfsplus/super.c:247:
|+       if (sb->s_flags & MS_RDONLY)
|+              return;
|
|WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statement=
s (8, 15)
|#174: FILE: fs/hfsplus/super.c:251:
|+       if (!sbi->work_queued) {
|+              delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);

diff --git a/fs/hfsplus/bitmap.c b/fs/hfsplus/bitmap.c
index 1cad80c..4cfbe2e 100644
--- a/fs/hfsplus/bitmap.c
+++ b/fs/hfsplus/bitmap.c
@@ -153,7 +153,7 @@ done:
 	kunmap(page);
 	*max =3D offset + (curr - pptr) * 32 + i - start;
 	sbi->free_blocks -=3D *max;
-	sb->s_dirt =3D 1;
+	hfsplus_mark_mdb_dirty(sb);
 	dprint(DBG_BITMAP, "-> %u,%u\n", start, *max);
 out:
 	mutex_unlock(&sbi->alloc_mutex);
@@ -228,7 +228,7 @@ out:
 	set_page_dirty(page);
 	kunmap(page);
 	sbi->free_blocks +=3D len;
-	sb->s_dirt =3D 1;
+	hfsplus_mark_mdb_dirty(sb);
 	mutex_unlock(&sbi->alloc_mutex);
=20
 	return 0;
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 26b53fb..8375504 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -316,7 +316,7 @@ static int hfsplus_link(struct dentry *src_dentry, stru=
ct inode *dst_dir,
 	inode->i_ctime =3D CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	sbi->file_count++;
-	dst_dir->i_sb->s_dirt =3D 1;
+	hfsplus_mark_mdb_dirty(dst_dir->i_sb);
 out:
 	mutex_unlock(&sbi->vh_mutex);
 	return res;
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 66a9365..558dbb4 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -153,8 +153,11 @@ struct hfsplus_sb_info {
 	gid_t gid;
=20
 	int part, session;
-
 	unsigned long flags;
+
+	int work_queued;               /* non-zero delayed work is queued */
+	struct delayed_work sync_work; /* FS sync delayed work */
+	spinlock_t work_lock;          /* protects sync_work and work_queued */
 };
=20
 #define HFSPLUS_SB_WRITEBACKUP	0
@@ -428,6 +431,7 @@ int hfsplus_show_options(struct seq_file *, struct dent=
ry *);
=20
 /* super.c */
 struct inode *hfsplus_iget(struct super_block *, unsigned long);
+void hfsplus_mark_mdb_dirty(struct super_block *sb);
=20
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 82b69ee..ad1f16f 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -431,7 +431,7 @@ struct inode *hfsplus_new_inode(struct super_block *sb,=
 umode_t mode)
 		sbi->file_count++;
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
-	sb->s_dirt =3D 1;
+	hfsplus_mark_mdb_dirty(sb);
=20
 	return inode;
 }
@@ -442,7 +442,7 @@ void hfsplus_delete_inode(struct inode *inode)
=20
 	if (S_ISDIR(inode->i_mode)) {
 		HFSPLUS_SB(sb)->folder_count--;
-		sb->s_dirt =3D 1;
+		hfsplus_mark_mdb_dirty(sb);
 		return;
 	}
 	HFSPLUS_SB(sb)->file_count--;
@@ -455,7 +455,7 @@ void hfsplus_delete_inode(struct inode *inode)
 		inode->i_size =3D 0;
 		hfsplus_file_truncate(inode);
 	}
-	sb->s_dirt =3D 1;
+	hfsplus_mark_mdb_dirty(sb);
 }
=20
 void hfsplus_inode_read_fork(struct inode *inode, struct hfsplus_fork_raw =
*fork)
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index f4f3d54..cb6b9c1 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -124,7 +124,7 @@ static int hfsplus_system_write_inode(struct inode *ino=
de)
=20
 	if (fork->total_size !=3D cpu_to_be64(inode->i_size)) {
 		set_bit(HFSPLUS_SB_WRITEBACKUP, &sbi->flags);
-		inode->i_sb->s_dirt =3D 1;
+		hfsplus_mark_mdb_dirty(inode->i_sb);
 	}
 	hfsplus_inode_write_fork(inode, fork);
 	if (tree)
@@ -173,7 +173,7 @@ static int hfsplus_sync_fs(struct super_block *sb, int =
wait)
=20
 	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
=20
-	sb->s_dirt =3D 0;
+	cancel_delayed_work(&sbi->sync_work);
=20
 	/*
 	 * Explicitly write out the special metadata inodes.
@@ -226,12 +226,34 @@ out:
 	return error;
 }
=20
-static void hfsplus_write_super(struct super_block *sb)
+static void delayed_sync_fs(struct work_struct *work)
 {
-	if (!(sb->s_flags & MS_RDONLY))
-		hfsplus_sync_fs(sb, 1);
-	else
-		sb->s_dirt =3D 0;
+	struct hfsplus_sb_info *sbi;
+
+	sbi =3D container_of(work, struct hfsplus_sb_info, sync_work.work);
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued =3D 0;
+	spin_unlock(&sbi->work_lock);
+
+	hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
+}
+
+void hfsplus_mark_mdb_dirty(struct super_block *sb)
+{
+	struct hfsplus_sb_info *sbi =3D HFSPLUS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+		delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
+		sbi->work_queued =3D 1;
+	}
+	spin_unlock(&sbi->work_lock);
 }
=20
 static void hfsplus_put_super(struct super_block *sb)
@@ -240,6 +262,8 @@ static void hfsplus_put_super(struct super_block *sb)
=20
 	dprint(DBG_SUPER, "hfsplus_put_super\n");
=20
+	cancel_delayed_work_sync(&sbi->sync_work);
+
 	if (!(sb->s_flags & MS_RDONLY) && sbi->s_vhdr) {
 		struct hfsplus_vh *vhdr =3D sbi->s_vhdr;
=20
@@ -325,7 +349,6 @@ static const struct super_operations hfsplus_sops =3D {
 	.write_inode	=3D hfsplus_write_inode,
 	.evict_inode	=3D hfsplus_evict_inode,
 	.put_super	=3D hfsplus_put_super,
-	.write_super	=3D hfsplus_write_super,
 	.sync_fs	=3D hfsplus_sync_fs,
 	.statfs		=3D hfsplus_statfs,
 	.remount_fs	=3D hfsplus_remount,
@@ -352,6 +375,8 @@ static int hfsplus_fill_super(struct super_block *sb, v=
oid *data, int silent)
 	sb->s_fs_info =3D sbi;
 	mutex_init(&sbi->alloc_mutex);
 	mutex_init(&sbi->vh_mutex);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	hfsplus_fill_defaults(sbi);
=20
 	err =3D -EINVAL;
--=20
1.7.10


--=-8IZMCauJC19rQNGdJj75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8ayLAAoJECmIfjd9wqK0HbMP/2mFisinPxvMC6tBGZ8CbmZB
cr9VGibSRAgo+qxfbRkuQsYApFcfJlT850r5Kzhe6asFf4BrAS4WwVlAeVrh1MvU
EW/tv4VotHWumcIWPrNXgo56FyMaIT0xJQgzPkStxXicjUguMcvQ6Z8YwCNF5m4v
aFEzhqSVtF0FTD4w8yCA0VuspCmMXLfg8ylVmbkZymU0fMDTf5DjJde7zs3PUZfo
CXG9Khe/dxPRp+wvJAWTcu8ge7WC/pYhDIClY/ntQy0Pvf124IClmqKjRAUy8MO+
ZpqrLJcpovKYifNXk3Jcya6u+j8yJqHZGotOqFRBT1msY7uD49NCdg9wc5ZOVg6K
1GiCPXms2OJNV3DZgP+J8GnR0TGHh6ByeMs2lRoefvxfsMWY80CkChYbPCTtTAPy
7D2MGCV6QF8RLDTgr88owECS1QNdQB+uPW/3xdLzMub+BEM+4DKKtlGlVPWWQlEw
50892YR/J1OXu1Bkvqfwy5I4kygDW45eyuspLKOhY8RxhW6WujyeR3Pst6VdPa+i
0x7u+XsKfgJVTPeyt1gjWPd25wdKm3u3wh8ptXDdA+x4KQAOWPyhAJ8rfhosmOr7
CZ4QhzlpdbAYBDNVxe6FsKKIvEhbCOaL65IY4+6e3hE9z/+n2iF3sphJDqgAlz8p
IVL+JcmK/RI6FPt2OGFk
=Xeko
-----END PGP SIGNATURE-----

--=-8IZMCauJC19rQNGdJj75--

