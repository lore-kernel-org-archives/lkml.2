Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab2GJOVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:21:22 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:49802 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab2GJOVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:21:20 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=A2IailkaF23VoGkWkGlUeiIkUJpMosWYxU+j8nxniN3gf/UJzJLsi20idbMH
	Z11c/qj7X9Cji5Ce7c/r6AE5T4tJeMEEnNaLlx4Mn5MkE1DeieN3Mg8/7
	WEGdMZ08mQqlEevaEYIohYtFHo0u7iZ1EyQPDvGT5W5n+LcMaJYm9A=;
X-Spam-Processed: mail.digidescorp.com, Tue, 10 Jul 2012 09:21:18 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1538729052=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, steve@digidescorp.com
Subject: [PATCH 1/2] fat (exportfs): move NFS support code
Date: Tue, 10 Jul 2012 09:20:52 -0500
Message-Id: <1341930053-10689-2-git-send-email-steve@digidescorp.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341930053-10689-1-git-send-email-steve@digidescorp.com>
References: <1341930053-10689-1-git-send-email-steve@digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move NFS-related code into its own C file.
No functional changes.

Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
---
diff -uprN a/fs/fat/fat.h b/fs/fat/fat.h
--- a/fs/fat/fat.h	2012-07-09 08:33:25.206615179 -0500
+++ b/fs/fat/fat.h	2012-07-10 09:10:14.064615822 -0500
@@ -341,6 +341,20 @@ extern int fat_fill_super(struct super_b
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
+static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
+				    struct inode *inode)
+{
+	loff_t i_pos;
+#if BITS_PER_LONG == 32
+	spin_lock(&sbi->inode_hash_lock);
+#endif
+	i_pos = MSDOS_I(inode)->i_pos;
+#if BITS_PER_LONG == 32
+	spin_unlock(&sbi->inode_hash_lock);
+#endif
+	return i_pos;
+}
+
 /* fat/misc.c */
 extern __printf(3, 4) __cold
 void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
@@ -366,6 +380,14 @@ extern int fat_sync_bhs(struct buffer_he
 int fat_cache_init(void);
 void fat_cache_destroy(void);
 
+/* fat/nfs.c */
+struct fid;
+extern int fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp,
+			 struct inode *parent);
+extern struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type);
+extern struct dentry *fat_get_parent(struct dentry *child_dir);
+
 /* helper for printk */
 typedef unsigned long long	llu;
 
diff -uprN a/fs/fat/inode.c b/fs/fat/inode.c
--- a/fs/fat/inode.c	2012-07-09 08:33:25.249614939 -0500
+++ b/fs/fat/inode.c	2012-07-10 09:09:58.654691584 -0500
@@ -557,20 +557,6 @@ static int fat_statfs(struct dentry *den
 	return 0;
 }
 
-static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
-				    struct inode *inode)
-{
-	loff_t i_pos;
-#if BITS_PER_LONG == 32
-	spin_lock(&sbi->inode_hash_lock);
-#endif
-	i_pos = MSDOS_I(inode)->i_pos;
-#if BITS_PER_LONG == 32
-	spin_unlock(&sbi->inode_hash_lock);
-#endif
-	return i_pos;
-}
-
 static int __fat_write_inode(struct inode *inode, int wait)
 {
 	struct super_block *sb = inode->i_sb;
@@ -663,122 +649,6 @@ static const struct super_operations fat
 	.show_options	= fat_show_options,
 };
 
-/*
- * a FAT file handle with fhtype 3 is
- *  0/  i_ino - for fast, reliable lookup if still in the cache
- *  1/  i_generation - to see if i_ino is still valid
- *          bit 0 == 0 iff directory
- *  2/  i_pos(8-39) - if ino has changed, but still in cache
- *  3/  i_pos(4-7)|i_logstart - to semi-verify inode found at i_pos
- *  4/  i_pos(0-3)|parent->i_logstart - maybe used to hunt for the file on disc
- *
- * Hack for NFSv2: Maximum FAT entry number is 28bits and maximum
- * i_pos is 40bits (blocknr(32) + dir offset(8)), so two 4bits
- * of i_logstart is used to store the directory entry offset.
- */
-
-static struct dentry *fat_fh_to_dentry(struct super_block *sb,
-		struct fid *fid, int fh_len, int fh_type)
-{
-	struct inode *inode = NULL;
-	u32 *fh = fid->raw;
-
-	if (fh_len < 5 || fh_type != 3)
-		return NULL;
-
-	inode = ilookup(sb, fh[0]);
-	if (!inode || inode->i_generation != fh[1]) {
-		if (inode)
-			iput(inode);
-		inode = NULL;
-	}
-	if (!inode) {
-		loff_t i_pos;
-		int i_logstart = fh[3] & 0x0fffffff;
-
-		i_pos = (loff_t)fh[2] << 8;
-		i_pos |= ((fh[3] >> 24) & 0xf0) | (fh[4] >> 28);
-
-		/* try 2 - see if i_pos is in F-d-c
-		 * require i_logstart to be the same
-		 * Will fail if you truncate and then re-write
-		 */
-
-		inode = fat_iget(sb, i_pos);
-		if (inode && MSDOS_I(inode)->i_logstart != i_logstart) {
-			iput(inode);
-			inode = NULL;
-		}
-	}
-
-	/*
-	 * For now, do nothing if the inode is not found.
-	 *
-	 * What we could do is:
-	 *
-	 *	- follow the file starting at fh[4], and record the ".." entry,
-	 *	  and the name of the fh[2] entry.
-	 *	- then follow the ".." file finding the next step up.
-	 *
-	 * This way we build a path to the root of the tree. If this works, we
-	 * lookup the path and so get this inode into the cache.  Finally try
-	 * the fat_iget lookup again.  If that fails, then we are totally out
-	 * of luck.  But all that is for another day
-	 */
-	return d_obtain_alias(inode);
-}
-
-static int
-fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
-{
-	int len = *lenp;
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
-	loff_t i_pos;
-
-	if (len < 5) {
-		*lenp = 5;
-		return 255; /* no room */
-	}
-
-	i_pos = fat_i_pos_read(sbi, inode);
-	*lenp = 5;
-	fh[0] = inode->i_ino;
-	fh[1] = inode->i_generation;
-	fh[2] = i_pos >> 8;
-	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
-	fh[4] = (i_pos & 0x0f) << 28;
-	if (parent)
-		fh[4] |= MSDOS_I(parent)->i_logstart;
-	return 3;
-}
-
-static struct dentry *fat_get_parent(struct dentry *child)
-{
-	struct super_block *sb = child->d_sb;
-	struct buffer_head *bh;
-	struct msdos_dir_entry *de;
-	loff_t i_pos;
-	struct dentry *parent;
-	struct inode *inode;
-	int err;
-
-	lock_super(sb);
-
-	err = fat_get_dotdot_entry(child->d_inode, &bh, &de, &i_pos);
-	if (err) {
-		parent = ERR_PTR(err);
-		goto out;
-	}
-	inode = fat_build_inode(sb, de, i_pos);
-	brelse(bh);
-
-	parent = d_obtain_alias(inode);
-out:
-	unlock_super(sb);
-
-	return parent;
-}
-
 static const struct export_operations fat_export_ops = {
 	.encode_fh	= fat_encode_fh,
 	.fh_to_dentry	= fat_fh_to_dentry,
diff -uprN a/fs/fat/Makefile b/fs/fat/Makefile
--- a/fs/fat/Makefile	2012-07-09 08:33:25.240614990 -0500
+++ b/fs/fat/Makefile	2012-07-09 08:33:25.370614268 -0500
@@ -6,6 +6,6 @@ obj-$(CONFIG_FAT_FS) += fat.o
 obj-$(CONFIG_VFAT_FS) += vfat.o
 obj-$(CONFIG_MSDOS_FS) += msdos.o
 
-fat-y := cache.o dir.o fatent.o file.o inode.o misc.o
+fat-y := cache.o dir.o fatent.o file.o inode.o misc.o nfs.o
 vfat-y := namei_vfat.o
 msdos-y := namei_msdos.o
diff -uprN a/fs/fat/nfs.c b/fs/fat/nfs.c
--- a/fs/fat/nfs.c	1969-12-31 18:00:00.000000000 -0600
+++ b/fs/fat/nfs.c	2012-07-10 08:53:24.272703129 -0500
@@ -0,0 +1,151 @@
+/* fs/fat/nfs.c
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/exportfs.h>
+#include "fat.h"
+
+/*
+ * a FAT file handle with fhtype 3 is
+ *  0/  i_ino - for fast, reliable lookup if still in the cache
+ *  1/  i_generation - to see if i_ino is still valid
+ *          bit 0 == 0 iff directory
+ *  2/  i_pos(8-39) - if ino has changed, but still in cache
+ *  3/  i_pos(4-7)|i_logstart - to semi-verify inode found at i_pos
+ *  4/  i_pos(0-3)|parent->i_logstart - maybe used to hunt for the file on disc
+ *
+ * Hack for NFSv2: Maximum FAT entry number is 28bits and maximum
+ * i_pos is 40bits (blocknr(32) + dir offset(8)), so two 4bits
+ * of i_logstart is used to store the directory entry offset.
+ */
+
+int
+fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
+{
+	int len = *lenp;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	loff_t i_pos;
+
+	if (len < 5) {
+		*lenp = 5;
+		return 255; /* no room */
+	}
+
+	i_pos = fat_i_pos_read(sbi, inode);
+	*lenp = 5;
+	fh[0] = inode->i_ino;
+	fh[1] = inode->i_generation;
+	fh[2] = i_pos >> 8;
+	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
+	fh[4] = (i_pos & 0x0f) << 28;
+	if (parent)
+		fh[4] |= MSDOS_I(parent)->i_logstart;
+	return 3;
+}
+
+static int fat_is_valid_fh(int fh_len, int fh_type)
+{
+	return ((fh_len >= 5) && (fh_type == 3));
+}
+
+/**
+ * Map a NFS file handle to a corresponding dentry.
+ * The dentry may or may not be connected to the filesystem root.
+ */
+struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				int fh_len, int fh_type)
+{
+	struct inode *inode = NULL;
+	u32 *fh = fid->raw;
+	loff_t i_pos;
+	unsigned long i_ino;
+	__u32 i_generation;
+	int i_logstart;
+
+	if (!fat_is_valid_fh(fh_len, fh_type))
+		return NULL;
+
+	i_ino = fh[0];
+	i_generation = fh[1];
+	i_logstart = fh[3] & 0x0fffffff;
+
+	/* Try i_ino lookup first - fastest and most reliable */
+	inode = ilookup(sb, i_ino);
+	if (inode && (inode->i_generation != i_generation)) {
+		iput(inode);
+		inode = NULL;
+	}
+	if (!inode) {
+		i_pos = (loff_t)fh[2] << 8;
+		i_pos |= ((fh[3] >> 24) & 0xf0) | (fh[4] >> 28);
+
+		/* try 2 - see if i_pos is in F-d-c
+		 * require i_logstart to be the same
+		 * Will fail if you truncate and then re-write
+		 */
+
+		inode = fat_iget(sb, i_pos);
+		if (inode && MSDOS_I(inode)->i_logstart != i_logstart) {
+			iput(inode);
+			inode = NULL;
+		}
+	}
+
+	/*
+	 * For now, do nothing if the inode is not found.
+	 *
+	 * What we could do is:
+	 *
+	 *	- follow the file starting at fh[4], and record the ".." entry,
+	 *	  and the name of the fh[2] entry.
+	 *	- then follow the ".." file finding the next step up.
+	 *
+	 * This way we build a path to the root of the tree. If this works, we
+	 * lookup the path and so get this inode into the cache.  Finally try
+	 * the fat_iget lookup again.  If that fails, then we are totally out
+	 * of luck.  But all that is for another day
+	 */
+	return d_obtain_alias(inode);
+}
+
+/*
+ * Find the parent for a directory that is not currently connected to
+ * the filesystem root.
+ *
+ * On entry, the caller holds child_dir->d_inode->i_mutex.
+ */
+struct dentry *fat_get_parent(struct dentry *child_dir)
+{
+	struct super_block *sb = child_dir->d_sb;
+	struct buffer_head *bh = NULL;
+	struct msdos_dir_entry *de;
+	loff_t i_pos;
+	struct dentry *parent;
+	struct inode *inode;
+	int err;
+
+	lock_super(sb);
+
+	err = fat_get_dotdot_entry(child_dir->d_inode, &bh, &de, &i_pos);
+	if (err) {
+		parent = ERR_PTR(err);
+		goto out;
+	}
+	inode = fat_build_inode(sb, de, i_pos);
+
+	parent = d_obtain_alias(inode);
+out:
+	brelse(bh);
+	unlock_super(sb);
+
+	return parent;
+}

