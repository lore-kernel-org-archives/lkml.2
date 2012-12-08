Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2LHFzA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 00:55:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48155 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2LHFy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 00:54:59 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 4/5] f2fs: introduce accessor to retrieve number of dentry slots
Date: Sat,  8 Dec 2012 14:54:50 +0900
Message-Id: <1354946090-7652-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Simplify code by providing the accessor macro to retrieve the
number of dentry slots for a given filename length.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/dir.c           |   13 +++++--------
 include/linux/f2fs_fs.h |    3 +++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index fc02d8b..d900c08 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -99,8 +99,7 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 					NR_DENTRY_IN_BLOCK, 0);
 	while (bit_pos < NR_DENTRY_IN_BLOCK) {
 		de = &dentry_blk->dentry[bit_pos];
-		slots = (le16_to_cpu(de->name_len) + F2FS_NAME_LEN - 1) /
-							F2FS_NAME_LEN;
+		slots = GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 
 		if (early_match_name(name, namelen, namehash, de)) {
 			if (!memcmp(dentry_blk->filename[bit_pos],
@@ -130,7 +129,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 		unsigned int level, const char *name, int namelen,
 			f2fs_hash_t namehash, struct page **res_page)
 {
-	int s = (namelen + F2FS_NAME_LEN - 1) / F2FS_NAME_LEN;
+	int s = GET_DENTRY_SLOTS(namelen);
 	unsigned int nbucket, nblock;
 	unsigned int bidx, end_block;
 	struct page *dentry_page;
@@ -383,7 +382,7 @@ int f2fs_add_link(struct dentry *dentry, struct inode *inode)
 	int namelen = dentry->d_name.len;
 	struct page *dentry_page = NULL;
 	struct f2fs_dentry_block *dentry_blk = NULL;
-	int slots = (namelen + F2FS_NAME_LEN - 1) / F2FS_NAME_LEN;
+	int slots = GET_DENTRY_SLOTS(namelen);
 	int err = 0;
 	int i;
 
@@ -465,8 +464,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	struct address_space *mapping = page->mapping;
 	struct inode *dir = mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
-	int slots = (le16_to_cpu(dentry->name_len) + F2FS_NAME_LEN - 1) /
-							F2FS_NAME_LEN;
+	int slots = GET_DENTRY_SLOTS(le16_to_cpu(dentry->name_len));
 	void *kaddr = page_address(page);
 	int i;
 
@@ -641,8 +639,7 @@ static int f2fs_readdir(struct file *file, void *dirent, filldir_t filldir)
 				file->f_pos += bit_pos - start_bit_pos;
 				goto success;
 			}
-			slots = (le16_to_cpu(de->name_len) + F2FS_NAME_LEN - 1)
-								/ F2FS_NAME_LEN;
+			slots = GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 			bit_pos += slots;
 		}
 		bit_pos = 0;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index c2fbbc3..fdcef79 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -363,6 +363,9 @@ typedef __le32	f2fs_hash_t;
 
 /* One directory entry slot covers 8bytes-long file name */
 #define F2FS_NAME_LEN		8
+#define F2FS_NAME_LEN_BITS	3
+
+#define GET_DENTRY_SLOTS(x)	((x + F2FS_NAME_LEN - 1) >> F2FS_NAME_LEN_BITS)
 
 /* the number of dentry in a block */
 #define NR_DENTRY_IN_BLOCK	214
-- 
1.7.9.5

