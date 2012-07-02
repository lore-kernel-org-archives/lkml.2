Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2GBOCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:02:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:37077 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2GBOCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:02:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="163109479"
Message-ID: <1341238012.2979.16.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 7/7] affs: get rid of affs_sync_super
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 17:06:52 +0300
In-Reply-To: <1338998217-5010-8-git-send-email-dedekind1@gmail.com>
References: <1338998217-5010-1-git-send-email-dedekind1@gmail.com>
	 <1338998217-5010-8-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kZTs5eQod1+aemNc1x1q"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kZTs5eQod1+aemNc1x1q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Tue, 5 Jun 2012 13:30:44 +0300
Subject: [PATCH v2 13/23] affs: get rid of affs_sync_super

This patch makes affs stop using the VFS '->write_super()' method along wit=
h
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

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/affs/affs.h   |    6 ++++++
 fs/affs/bitmap.c |    4 ++--
 fs/affs/super.c  |   48 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 45 insertions(+), 13 deletions(-)

|This is patch is the same except that it fixes several white-space
|issues. If you plrefer an incremental patch, please, let me know. The
|issues are:
|
|WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statement=
s (8, 15)
|#140: FILE: fs/affs/super.c:86:
|+       if (sb->s_flags & MS_RDONLY)
|+              return;
|
|WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statement=
s (8, 15)
|#144: FILE: fs/affs/super.c:90:
|+       if (!sbi->work_queued) {
|+              delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 5a726e9..3a130e2 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -3,6 +3,7 @@
 #include <linux/buffer_head.h>
 #include <linux/amigaffs.h>
 #include <linux/mutex.h>
+#include <linux/workqueue.h>
=20
 /* AmigaOS allows file names with up to 30 characters length.
  * Names longer than that will be silently truncated. If you
@@ -101,6 +102,9 @@ struct affs_sb_info {
 	char s_volume[32];		/* Volume prefix for absolute symlinks. */
 	spinlock_t symlink_lock;	/* protects the previous two */
 	struct super_block *sb;		/* the VFS superblock object */
+	int work_queued;		/* non-zero delayed work is queued */
+	struct delayed_work sb_work;	/* superblock flush delayed work */
+	spinlock_t work_lock;		/* protects sb_work and work_queued */
 };
=20
 #define SF_INTL		0x0001		/* International filesystem. */
@@ -121,6 +125,8 @@ static inline struct affs_sb_info *AFFS_SB(struct super=
_block *sb)
 	return sb->s_fs_info;
 }
=20
+void affs_mark_sb_dirty(struct super_block *sb);
+
 /* amigaffs.c */
=20
 extern int	affs_insert_hash(struct inode *inode, struct buffer_head *bh);
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 3e26271..6e0be43 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -103,7 +103,7 @@ affs_free_block(struct super_block *sb, u32 block)
 	*(__be32 *)bh->b_data =3D cpu_to_be32(tmp - mask);
=20
 	mark_buffer_dirty(bh);
-	sb->s_dirt =3D 1;
+	affs_mark_sb_dirty(sb);
 	bm->bm_free++;
=20
 	mutex_unlock(&sbi->s_bmlock);
@@ -248,7 +248,7 @@ find_bit:
 	*(__be32 *)bh->b_data =3D cpu_to_be32(tmp + mask);
=20
 	mark_buffer_dirty(bh);
-	sb->s_dirt =3D 1;
+	affs_mark_sb_dirty(sb);
=20
 	mutex_unlock(&sbi->s_bmlock);
=20
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 0496cbb..c70f1e5 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -17,6 +17,7 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/writeback.h>
 #include "affs.h"
=20
 extern struct timezone sys_tz;
@@ -47,6 +48,7 @@ affs_put_super(struct super_block *sb)
 	struct affs_sb_info *sbi =3D AFFS_SB(sb);
 	pr_debug("AFFS: put_super()\n");
=20
+	cancel_delayed_work_sync(&sbi->sb_work);
 	kfree(sbi->s_prefix);
 	affs_free_bitmap(sb);
 	affs_brelse(sbi->s_root_bh);
@@ -54,23 +56,45 @@ affs_put_super(struct super_block *sb)
 	sb->s_fs_info =3D NULL;
 }
=20
-static void
-affs_write_super(struct super_block *sb)
-{
-	if (!(sb->s_flags & MS_RDONLY))
-		affs_commit_super(sb, 1);
-	sb->s_dirt =3D 0;
-	pr_debug("AFFS: write_super() at %lu, clean=3D2\n", get_seconds());
-}
-
 static int
 affs_sync_fs(struct super_block *sb, int wait)
 {
 	affs_commit_super(sb, wait);
-	sb->s_dirt =3D 0;
 	return 0;
 }
=20
+static void flush_superblock(struct work_struct *work)
+{
+	struct affs_sb_info *sbi;
+	struct super_block *sb;
+
+	sbi =3D container_of(work, struct affs_sb_info, sb_work.work);
+	sb =3D sbi->sb;
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued =3D 0;
+	spin_unlock(&sbi->work_lock);
+
+	affs_commit_super(sb, 1);
+}
+
+void affs_mark_sb_dirty(struct super_block *sb)
+{
+	struct affs_sb_info *sbi =3D AFFS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+		delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->sb_work, delay);
+		sbi->work_queued =3D 1;
+	}
+	spin_unlock(&sbi->work_lock);
+}
+
 static struct kmem_cache * affs_inode_cachep;
=20
 static struct inode *affs_alloc_inode(struct super_block *sb)
@@ -132,7 +156,6 @@ static const struct super_operations affs_sops =3D {
 	.write_inode	=3D affs_write_inode,
 	.evict_inode	=3D affs_evict_inode,
 	.put_super	=3D affs_put_super,
-	.write_super	=3D affs_write_super,
 	.sync_fs	=3D affs_sync_fs,
 	.statfs		=3D affs_statfs,
 	.remount_fs	=3D affs_remount,
@@ -302,6 +325,8 @@ static int affs_fill_super(struct super_block *sb, void=
 *data, int silent)
 	sbi->sb =3D sb;
 	mutex_init(&sbi->s_bmlock);
 	spin_lock_init(&sbi->symlink_lock);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sb_work, flush_superblock);
=20
 	if (!parse_options(data,&uid,&gid,&i,&reserved,&root_block,
 				&blocksize,&sbi->s_prefix,
@@ -526,6 +551,7 @@ affs_remount(struct super_block *sb, int *flags, char *=
data)
 		return -EINVAL;
 	}
=20
+	flush_delayed_work_sync(&sbi->sb_work);
 	replace_mount_options(sb, new_opts);
=20
 	sbi->s_flags =3D mount_flags;
--=20
1.7.10

--=-kZTs5eQod1+aemNc1x1q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8ar8AAoJECmIfjd9wqK0FpMP+gKLupGZJaTrZweanfawjQqx
2+PJkOw6iVfLCRdVtTQ5e8Oyk8/R/mwE52F+TNLRvT4VMjhc4QQsat8zIdLgVk1C
m5z3YcqHsigPG/mo2cnzl3b3JI6bQqY56lX1RNxHKwiX7wYsPTbtvL1KDvNX5BSF
eoQ5cDotbRKrHs3Xc6I/cAapkG1drMRth6PEpxwlibq63iQUeilJFNpgq5vCqR57
ITZQXOkqkL38XxM51OiIqBztqO70sR1gCbvuXewq/nGsUvHV0+qgdKVZdUUe7hMt
UceKM6T7C2iWLc9PFwa7VWLemSqjVbNiBPgdyxBEdhwRvQuUpindy1tlnHW9dFN4
pXUoA/G4pRdUuN2lhfTzgJhrdWg7CfE/vH1RYm15ZIwn/PmLMKCumXJW5eGDNcM1
XldSgk96P1Rzw8D2Uw+O1n7mJxSpuVv1rMmJKql4ePgHp3uVo41JKiPahJ16cN59
ikmEkqPtTKRP794ukLvFYG7U98KBJyQ5jBUSec0kRZXZsL4ZE02Oc8iWtncoAnKg
DcX7hIr7EcLIpxbfTAdMuIv0gQNjjQg5nRgHW9PLekqCpZt+ziLmF7+6+c2+2HSn
Z/tELu9CAmVT6Ux4lzNdgnjks3yLvQ2AfWPM6ZSOzHUKgGLJBJqVRLXgDX8YbWuF
ZkWoJaY/qq0doup9AncS
=7Yps
-----END PGP SIGNATURE-----

--=-kZTs5eQod1+aemNc1x1q--

