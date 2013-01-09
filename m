Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3AIGYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:24:21 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49998 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3AIGYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:24:19 -0500
MIME-Version: 1.0
In-Reply-To: <87k3sblmj2.fsf@devron.myhome.or.jp>
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
	<878v9f5ugn.fsf@devron.myhome.or.jp>
	<CAKYAXd-ydXkwDq6vkECEKPUQiNgg2+GKbL+ah9sn+uqr8BT1kQ@mail.gmail.com>
	<87k3sy17vk.fsf@devron.myhome.or.jp>
	<CAKYAXd8=7BG8NsVyvUP5xW48Y9FJpD7M95_MiJVGcwYOfYsrLA@mail.gmail.com>
	<87txs0x45r.fsf@devron.myhome.or.jp>
	<CAKYAXd8OP_FXxJWHESW_bCY1hGQuZPMJYOkLkmQ4fOkDhGO8xw@mail.gmail.com>
	<CAKYAXd9NXVsBTMpTUWxN_10z1Ozt47f6Ghvsv9rbp_Y8tVMg2A@mail.gmail.com>
	<87623ydnvq.fsf@devron.myhome.or.jp>
	<CAKYAXd8GgrG+cMN_wQDFLiuXoBPbR7c6N9eZqGCrK-OH3HpuZA@mail.gmail.com>
	<CAKYAXd9OhKDh5r6O=ACyDez1B2S=DB0Eo2-cSNuM1vaURmFNoQ@mail.gmail.com>
	<877gobn7fy.fsf@devron.myhome.or.jp>
	<CAKYAXd8SB7tz82Y57TKcngZC8vzvy1S=SAhzurA92jyobaVtNg@mail.gmail.com>
	<87obhnlmkt.fsf@devron.myhome.or.jp>
	<87k3sblmj2.fsf@devron.myhome.or.jp>
Date: Wed, 9 Jan 2013 15:24:18 +0900
Message-ID: <CAKYAXd-7kq9EoBE7e5sGXBeA8u914moz15-ubFimczGyiznUCA@mail.gmail.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if
 fat_dget() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> BTW, fat_search_long() was wrong as similar function. Actually it would
> be fat_scan(), because we don't care longname entry.
Hi OGAWA.

We rewrite patch as your suggestion using dummy inode. Would please
you review below patch code ?

Thanks.

--------------------------------------------------------------------------------------------
Subject: [PATCH] fat (exportfs): rebuild directory-inode if fat_dget()
 fails

This patch enables rebuilding of directory inodes which are not present
in the cache.This is done by traversing the disk clusters to find the
directory entry of the parent directory and using its i_pos to build the
inode.

Do this only if the "nostale_ro" nfs mount option is specified.

---
 fs/fat/dir.c   |   23 +++++++++++++++++++++++
 fs/fat/fat.h   |    3 +++
 fs/fat/inode.c |    2 +-
 fs/fat/nfs.c   |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 695c15c..ac97f34 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -975,6 +975,29 @@ int fat_scan(struct inode *dir, const unsigned char *name,

 EXPORT_SYMBOL_GPL(fat_scan);

+/*
+ * Scans a directory for a given logstart.
+ * Returns an error code or zero.
+ */
+int fat_scan_logstart(struct inode *dir, int i_logstart,
+		      struct fat_slot_info *sinfo)
+{
+	struct super_block *sb = dir->i_sb;
+
+	sinfo->slot_off = 0;
+	sinfo->bh = NULL;
+	while (fat_get_short_entry(dir, &sinfo->slot_off, &sinfo->bh,
+				   &sinfo->de) >= 0) {
+		if (fat_get_start(MSDOS_SB(sb), sinfo->de) == i_logstart) {
+			sinfo->slot_off -= sizeof(*sinfo->de);
+			sinfo->nr_slots = 1;
+			sinfo->i_pos = fat_make_i_pos(sb, sinfo->bh, sinfo->de);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
 static int __fat_remove_entries(struct inode *dir, loff_t pos, int nr_slots)
 {
 	struct super_block *sb = dir->i_sb;
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 73f15b8..d882c01 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -291,6 +291,8 @@ extern int fat_dir_empty(struct inode *dir);
 extern int fat_subdirs(struct inode *dir);
 extern int fat_scan(struct inode *dir, const unsigned char *name,
 		    struct fat_slot_info *sinfo);
+extern int fat_scan_logstart(struct inode *dir, int i_logstart,
+			     struct fat_slot_info *sinfo);
 extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 				struct msdos_dir_entry **de);
 extern int fat_alloc_new_dir(struct inode *dir, struct timespec *ts);
@@ -370,6 +372,7 @@ extern int fat_fill_super(struct super_block *sb,
void *data, int silent,

 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
+extern int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de);
 static inline unsigned long fat_dir_hash(int logstart)
 {
 	return hash_32(logstart, FAT_HASH_BITS);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 491320b..c4c286a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -384,7 +384,7 @@ static int fat_calc_dir_size(struct inode *inode)
 }

 /* doesn't deal with root inode */
-static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
+int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int error;
diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index 08ff9fa..e94da33 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -213,6 +213,53 @@ static struct dentry
*fat_fh_to_parent_nostale(struct super_block *sb,
 }

 /*
+ * Rebuild the parent for a directory that is not connected
+ *  to the filesystem root
+ */
+static
+struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
+{
+	int search_clus, clus_to_match;
+	struct msdos_dir_entry *de;
+	struct inode *parent = NULL;
+	struct inode *dummy_grand_parent = NULL;
+	struct fat_slot_info sinfo;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
+	struct buffer_head *parent_bh = sb_bread(sb, blknr);
+	if (!parent_bh) {
+		fat_msg(sb, KERN_ERR,
+			"unable to read cluster of parent directory");
+		return NULL;
+	}
+
+	de = (struct msdos_dir_entry *) parent_bh->b_data;
+	clus_to_match = fat_get_start(sbi, &de[0]);
+	search_clus = fat_get_start(sbi, &de[1]);
+
+	dummy_grand_parent = fat_dget(sb, search_clus);
+	if (!dummy_grand_parent) {
+		dummy_grand_parent = new_inode(sb);
+		if (!dummy_grand_parent) {
+			brelse(parent_bh);
+			return parent;
+		}
+
+		dummy_grand_parent->i_ino = iunique(sb, MSDOS_ROOT_INO);
+		fat_fill_inode(dummy_grand_parent, &de[1]);
+		MSDOS_I(dummy_grand_parent)->i_pos = -1;
+	}
+
+	if (!fat_scan_logstart(dummy_grand_parent, clus_to_match, &sinfo))
+		parent = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
+
+	brelse(parent_bh);
+	iput(dummy_grand_parent);
+
+	return parent;
+}
+
+/*
  * Find the parent for a directory that is not currently connected to
  * the filesystem root.
  *
@@ -224,10 +271,13 @@ static struct dentry *fat_get_parent(struct
dentry *child_dir)
 	struct buffer_head *bh = NULL;
 	struct msdos_dir_entry *de;
 	struct inode *parent_inode = NULL;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);

 	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
-		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
+		int parent_logstart = fat_get_start(sbi, de);
 		parent_inode = fat_dget(sb, parent_logstart);
+		if (!parent_inode && sbi->options.nfs == FAT_NFS_NOSTALE_RO)
+			parent_inode = fat_rebuild_parent(sb, parent_logstart);
 	}
 	brelse(bh);

-- 
1.7.7.6
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
