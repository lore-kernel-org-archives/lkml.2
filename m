Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2IDP6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:58:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35521 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab2IDP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:58:41 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        bfields@fieldses.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
Date: Wed,  5 Sep 2012 00:58:32 +0900
Message-Id: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
inodes that have been unlinked but still having open file
descriptors).At file/directory creation time, skip using such i_pos
values.Removal of the i_pos from the list is done during inode eviction.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/dir.c        |    4 +++
 fs/fat/fat.h        |   11 ++++++++
 fs/fat/inode.c      |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fat/namei_vfat.c |   25 ++++++++++++++++-
 4 files changed, 116 insertions(+), 1 deletion(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 7b1b9c1..e24fe5e 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1268,7 +1268,10 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 		if (pos >= FAT_MAX_DIR_SIZE)
 			goto error;
 
+
 		if (IS_FREE(de->name)) {
+			if (sbi->options.nfs && fat_entry_busy(sbi, pos, bh))
+				goto free;
 			if (prev != bh) {
 				get_bh(bh);
 				bhs[nr_bhs] = prev = bh;
@@ -1278,6 +1281,7 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			if (free_slots == nr_slots)
 				goto found;
 		} else {
+free:
 			for (i = 0; i < nr_bhs; i++)
 				brelse(bhs[i]);
 			prev = NULL;
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 88b6c29..9a53783 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -93,6 +93,9 @@ struct msdos_sb_info {
 
 	spinlock_t dir_hash_lock;
 	struct hlist_head dir_hashtable[FAT_HASH_SIZE];
+
+	spinlock_t ipos_busy_lock;
+	struct list_head *ipos_list_head;
 };
 
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
@@ -128,6 +131,12 @@ struct fat_slot_info {
 	struct buffer_head *bh;
 };
 
+struct ipos_busy_list {
+	struct list_head ipos_list;
+	loff_t i_pos;	/* on disk position for busy directory entry */
+	int nr_slots;
+};
+
 static inline struct msdos_sb_info *MSDOS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
@@ -341,6 +350,8 @@ extern void fat_detach(struct inode *inode);
 extern struct inode *fat_iget(struct super_block *sb, loff_t i_pos);
 extern struct inode *fat_build_inode(struct super_block *sb,
 			struct msdos_dir_entry *de, loff_t i_pos);
+extern int fat_entry_busy(struct msdos_sb_info *sbi, loff_t ipos,
+			struct buffer_head *bh);
 extern int fat_sync_inode(struct inode *inode);
 extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 			  int isvfat, void (*setup)(struct super_block *));
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0811339..47ff899 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -291,6 +291,23 @@ static void dir_hash_init(struct super_block *sb)
 		INIT_HLIST_HEAD(&sbi->dir_hashtable[i]);
 }
 
+static int ipos_list_init(struct super_block *sb)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+
+	sbi->ipos_list_head = kzalloc(sizeof(struct ipos_busy_list),
+					GFP_KERNEL);
+	if (!sbi->ipos_list_head) {
+		fat_msg(sb, KERN_ERR,
+			"Failed to allocate memory for ipos list head");
+		return -ENOMEM;
+	}
+	spin_lock_init(&sbi->ipos_busy_lock);
+	INIT_LIST_HEAD(sbi->ipos_list_head);
+
+	return 0;
+}
+
 void fat_attach(struct inode *inode, loff_t i_pos)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
@@ -477,8 +494,64 @@ out:
 
 EXPORT_SYMBOL_GPL(fat_build_inode);
 
+int fat_entry_busy(struct msdos_sb_info *sbi, loff_t ipos,
+				struct buffer_head *bh)
+{
+	struct list_head *pos, *q;
+	struct ipos_busy_list *plist;
+	int offset;
+	loff_t curpos;
+
+	if (list_empty(sbi->ipos_list_head))
+		return 0;
+
+	offset = (ipos - sizeof(struct msdos_dir_entry)) >> MSDOS_DIR_BITS;
+	curpos = ((bh->b_blocknr) << sbi->dir_per_block_bits) | offset;
+
+	spin_lock(&sbi->ipos_busy_lock);
+	list_for_each_safe(pos, q, sbi->ipos_list_head) {
+		plist = list_entry(pos, struct ipos_busy_list, ipos_list);
+		if (plist) {
+			if ((curpos > (plist->i_pos - plist->nr_slots)) &&
+				(curpos <= plist->i_pos)) {
+				spin_unlock(&sbi->ipos_busy_lock);
+				return 1;
+			}
+		}
+	}
+	spin_unlock(&sbi->ipos_busy_lock);
+	return 0;
+}
+
+static void fat_remove_busy_entry(struct inode *inode)
+{
+
+	struct super_block *sb = inode->i_sb;
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct list_head *pos, *q;
+	struct ipos_busy_list *plist;
+
+	spin_lock(&sbi->ipos_busy_lock);
+		list_for_each_safe(pos, q, sbi->ipos_list_head) {
+			plist = list_entry(pos, struct ipos_busy_list,
+					 ipos_list);
+			if (plist) {
+				if (plist->i_pos == MSDOS_I(inode)->i_pos) {
+					list_del(pos);
+					kfree(plist);
+					break;
+				}
+			}
+		}
+	spin_unlock(&sbi->ipos_busy_lock);
+
+}
+
 static void fat_evict_inode(struct inode *inode)
 {
+
+	if (MSDOS_SB(inode->i_sb)->options.nfs)
+		fat_remove_busy_entry(inode);
 	truncate_inode_pages(&inode->i_data, 0);
 	if (!inode->i_nlink) {
 		inode->i_size = 0;
@@ -504,6 +577,8 @@ static void fat_put_super(struct super_block *sb)
 		kfree(sbi->options.iocharset);
 
 	sb->s_fs_info = NULL;
+	if (sbi->options.nfs)
+		kfree(sbi->ipos_list_head);
 	kfree(sbi);
 }
 
@@ -1367,6 +1442,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	fat_hash_init(sb);
 	dir_hash_init(sb);
 	fat_ent_access_init(sb);
+	if (sbi->options.nfs && ipos_list_init(sb) < 0)
+		goto out_fail;
 
 	/*
 	 * The low byte of FAT's first entry must have same value with
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 00d58ea..01020b7 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -834,6 +834,26 @@ out:
 	return err;
 }
 
+static void fat_add_busy_entry(struct super_block *sb, struct inode *inode,
+				struct fat_slot_info sinfo)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	struct ipos_busy_list *unlinked_ipos = NULL;
+
+	if (inode && (atomic_read(&inode->i_count))) {
+		unlinked_ipos = kzalloc(sizeof(struct ipos_busy_list),
+					 GFP_KERNEL);
+		if (unlinked_ipos) {
+			unlinked_ipos->i_pos = sinfo.i_pos;
+			unlinked_ipos->nr_slots = sinfo.nr_slots;
+			spin_lock(&sbi->ipos_busy_lock);
+			list_add_tail(&unlinked_ipos->ipos_list,
+					sbi->ipos_list_head);
+			spin_unlock(&sbi->ipos_busy_lock);
+		}
+	}
+}
+
 static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = dentry->d_inode;
@@ -852,7 +872,10 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 		goto out;
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
-	fat_detach(inode);
+	if (MSDOS_SB(sb)->options.nfs)
+		fat_add_busy_entry(sb, inode, sinfo);
+	else
+		fat_detach(inode);
 out:
 	unlock_super(sb);
 
-- 
1.7.9.5

