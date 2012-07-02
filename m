Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab2GBOLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:11:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:8153 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2GBOLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:11:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="172523829"
Message-ID: <1341238538.2979.21.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 6/6] hfs: get rid of hfs_sync_super
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Date: Mon, 02 Jul 2012 17:15:38 +0300
In-Reply-To: <1339488818-14461-7-git-send-email-dedekind1@gmail.com>
References: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
	 <1339488818-14461-7-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eL8i4qlIofSUm6odjEQX"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eL8i4qlIofSUm6odjEQX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Tue, 12 Jun 2012 10:40:56 +0300
Subject: [PATCH 19/23] hfs: get rid of hfs_sync_super

This patch makes hfs stop using the VFS '->write_super()' method along with
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
 fs/hfs/extent.c |    2 +-
 fs/hfs/hfs_fs.h |    9 +++++++-
 fs/hfs/inode.c  |   11 ++++------
 fs/hfs/mdb.c    |    2 ++
 fs/hfs/super.c  |   65 ++++++++++++++++++++++++++++++---------------------=
----
 5 files changed, 50 insertions(+), 39 deletions(-)

|This is patch is the same except that it fixes several white-space
|issues. If you prefer an incremental patch, please, let me know. The
|issues are:
|
|WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statement=
s (8, 15)
|#213: FILE: fs/hfs/super.c:73:
|+       if (sb->s_flags & MS_RDONLY)
|+              return;
|
|WARNING:SUSPECT_CODE_INDENT: suspect code indent for conditional statement=
s (8, 15)
|#217: FILE: fs/hfs/super.c:77:
|+       if (!sbi->work_queued) {
|+              delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);

diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index 2c16316..a67955a 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -432,7 +432,7 @@ out:
 		if (inode->i_ino < HFS_FIRSTUSER_CNID)
 			set_bit(HFS_FLG_ALT_MDB_DIRTY, &HFS_SB(sb)->flags);
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt =3D 1;
+		hfs_mark_mdb_dirty(sb);
 	}
 	return res;
=20
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 3515612..8275175 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -14,6 +14,7 @@
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
+#include <linux/workqueue.h>
=20
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
@@ -143,6 +144,9 @@ struct hfs_sb_info {
 	u16 blockoffset;
 	int fs_div;
 	struct super_block *sb;
+	int work_queued;		/* non-zero delayed work is queued */
+	struct delayed_work mdb_work;	/* MDB flush delayed work */
+	spinlock_t work_lock;		/* protects mdb_work and work_queued */
 };
=20
 #define HFS_FLG_BITMAP_DIRTY	0
@@ -222,6 +226,9 @@ extern int hfs_compare_dentry(const struct dentry *pare=
nt,
 extern void hfs_asc2mac(struct super_block *, struct hfs_name *, struct qs=
tr *);
 extern int hfs_mac2asc(struct super_block *, char *, const struct hfs_name=
 *);
=20
+/* super.c */
+extern void hfs_mark_mdb_dirty(struct super_block *sb);
+
 extern struct timezone sys_tz;
=20
 /*
@@ -249,7 +256,7 @@ static inline const char *hfs_mdb_name(struct super_blo=
ck *sb)
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt =3D 1;
+	hfs_mark_mdb_dirty(sb);
 }
=20
 #define sb_bread512(sb, sec, data) ({			\
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 629eba4..cb78138 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -220,7 +220,7 @@ struct inode *hfs_new_inode(struct inode *dir, struct q=
str *name, umode_t mode)
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt =3D 1;
+	hfs_mark_mdb_dirty(sb);
=20
 	return inode;
 }
@@ -235,7 +235,7 @@ void hfs_delete_inode(struct inode *inode)
 		if (HFS_I(inode)->cat_key.ParID =3D=3D cpu_to_be32(HFS_ROOT_CNID))
 			HFS_SB(sb)->root_dirs--;
 		set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-		sb->s_dirt =3D 1;
+		hfs_mark_mdb_dirty(sb);
 		return;
 	}
 	HFS_SB(sb)->file_count--;
@@ -248,7 +248,7 @@ void hfs_delete_inode(struct inode *inode)
 		}
 	}
 	set_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags);
-	sb->s_dirt =3D 1;
+	hfs_mark_mdb_dirty(sb);
 }
=20
 void hfs_inode_read_fork(struct inode *inode, struct hfs_extent *ext,
@@ -644,10 +644,7 @@ static int hfs_file_fsync(struct file *filp, loff_t st=
art, loff_t end,
=20
 	/* sync the superblock to buffers */
 	sb =3D inode->i_sb;
-	if (sb->s_dirt) {
-		sb->s_dirt =3D 0;
-		hfs_mdb_commit(sb);
-	}
+	flush_delayed_work_sync(&HFS_SB(sb)->mdb_work);
 	/* .. finally sync the buffers to disk */
 	err =3D sync_blockdev(sb->s_bdev);
 	if (!ret)
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 5fd51a5..a5cd355 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -263,6 +263,8 @@ void hfs_mdb_commit(struct super_block *sb)
 	if (sb->s_flags & MS_RDONLY)
 		return;
=20
+	cancel_delayed_work(&HFS_SB(sb)->mdb_work);
+
 	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 99c6239..14528ee 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -29,38 +29,9 @@ static struct kmem_cache *hfs_inode_cachep;
=20
 MODULE_LICENSE("GPL");
=20
-/*
- * hfs_write_super()
- *
- * Description:
- *   This function is called by the VFS only. When the filesystem
- *   is mounted r/w it updates the MDB on disk.
- * Input Variable(s):
- *   struct super_block *sb: Pointer to the hfs superblock
- * Output Variable(s):
- *   NONE
- * Returns:
- *   void
- * Preconditions:
- *   'sb' points to a "valid" (struct super_block).
- * Postconditions:
- *   The MDB is marked 'unsuccessfully unmounted' by clearing bit 8 of drA=
trb
- *   (hfs_put_super() must set this flag!). Some MDB fields are updated
- *   and the MDB buffer is written to disk by calling hfs_mdb_commit().
- */
-static void hfs_write_super(struct super_block *sb)
-{
-	sb->s_dirt =3D 0;
-
-	/* sync everything to the buffers */
-	hfs_mdb_commit(sb);
-}
-
 static int hfs_sync_fs(struct super_block *sb, int wait)
 {
 	hfs_mdb_commit(sb);
-	sb->s_dirt =3D 0;
-
 	return 0;
 }
=20
@@ -73,11 +44,44 @@ static int hfs_sync_fs(struct super_block *sb, int wait=
)
  */
 static void hfs_put_super(struct super_block *sb)
 {
+	cancel_delayed_work_sync(&HFS_SB(sb)->mdb_work);
 	hfs_mdb_close(sb);
 	/* release the MDB's resources */
 	hfs_mdb_put(sb);
 }
=20
+static void flush_mdb(struct work_struct *work)
+{
+	struct hfs_sb_info *sbi;
+	struct super_block *sb;
+
+	sbi =3D container_of(work, struct hfs_sb_info, mdb_work.work);
+	sb =3D sbi->sb;
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued =3D 0;
+	spin_unlock(&sbi->work_lock);
+
+	hfs_mdb_commit(sb);
+}
+
+void hfs_mark_mdb_dirty(struct super_block *sb)
+{
+	struct hfs_sb_info *sbi =3D HFS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+		delay =3D msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->mdb_work, delay);
+		sbi->work_queued =3D 1;
+	}
+	spin_unlock(&sbi->work_lock);
+}
+
 /*
  * hfs_statfs()
  *
@@ -177,7 +181,6 @@ static const struct super_operations hfs_super_operatio=
ns =3D {
 	.write_inode	=3D hfs_write_inode,
 	.evict_inode	=3D hfs_evict_inode,
 	.put_super	=3D hfs_put_super,
-	.write_super	=3D hfs_write_super,
 	.sync_fs	=3D hfs_sync_fs,
 	.statfs		=3D hfs_statfs,
 	.remount_fs     =3D hfs_remount,
@@ -382,6 +385,8 @@ static int hfs_fill_super(struct super_block *sb, void =
*data, int silent)
=20
 	sbi->sb =3D sb;
 	sb->s_fs_info =3D sbi;
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->mdb_work, flush_mdb);
=20
 	res =3D -EINVAL;
 	if (!parse_options((char *)data, sbi)) {
--=20
1.7.10

--=-eL8i4qlIofSUm6odjEQX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP8a0LAAoJECmIfjd9wqK0gpoQAKMKY350y7Ux1x8ZW7WBhQws
QpFm80sJAg0TJyLGT806k28Wf13ngju4gQ1BveedL8fEROMES4IZSO+M53oi+lWs
h2qHEcj3EB8cB0M6A58ehYpmKraxXfl8WaRFddlhtXeiMWk/dX9HHAA85Da1KlXn
S6DIOykG4dKs2q7xMpbDSWBi3aPfRQXOa1S3VC6jG1+BsdSCkhFK/K7OfKGbUmlB
26M4TXbWtB/Ioc09d4nPOGkGeYHxhSfDIkC8DACKykSpKOPDnl229+phBJ2E0nmm
o+F1tuD60sIFZT2Etlwc2M3/w+lTwKeU80lOv6Q+VF7hIwmn66voE0RMw44ZANbh
Qj2A/o2IhzaUFJCv8ODl9sl3uFoC4bg53gDkYn9/iLLpMHIDTfzPjwdi5d5sedBj
pPXnC1yNkxY/l/Ibxhvq/isih+egHInrtEfNNWg1iSJSu1OAa1/+pKOcY526ONvg
qMqKXjgCtOhswtLc0cYcJBdbuvK0bC1HfTSdTaGU1+nvj3owxubXZ2VVRzHGvQq0
IUn9acDxnL7ZCmdeV3bojv+SYqx7T4glWzDB8WykiO5CIUiV6U0T33YM03blQa0D
tv1DZI09dznMJnEc7YZfWWLl8Fp9ox4LZCIfBJY16fkFswx0EkF/V45MxHdzSX7S
gfmOR3PI0v98hiPijcHd
=arm5
-----END PGP SIGNATURE-----

--=-eL8i4qlIofSUm6odjEQX--

