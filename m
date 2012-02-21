Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab2BUUCq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:02:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2BUTwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:55 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 67/73] ext2: Remove target inode pointer from ext2_add_entry()
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Further development)
Date: Tue, 21 Feb 2012 18:05:54 +0000
Message-ID: <20120221180553.25235.8550.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext2_add_entry() does not really need an inode pointer except to get at the
inode number and file mode that it contains.  Instead of passing in an inode
pointer, pass in the inode number and type to be recorded in the directory
entry.

ext2_add_link() can then calculate the directory entry type from the file mode
and pass it to ext2_add_entry().

Original-author: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Further development)
---

 fs/ext2/dir.c |   64 +++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index d8382dc..dcb2d64 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -282,13 +282,18 @@ static unsigned char ext2_type_by_mode[S_IFMT >> S_SHIFT] = {
 	[S_IFLNK >> S_SHIFT]	= EXT2_FT_SYMLINK,
 };
 
-static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
+static inline void ext2_set_de_type(ext2_dirent *de, struct super_block *sb,
+				    umode_t mode, unsigned char file_type)
 {
-	umode_t mode = inode->i_mode;
-	if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
-		de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
-	else
+	if (!EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE)) {
 		de->file_type = 0;
+		return;
+	}
+
+	if (file_type)
+		de->file_type = file_type;
+	else
+		de->file_type = ext2_type_by_mode[(mode & S_IFMT) >> S_SHIFT];
 }
 
 static int
@@ -480,7 +485,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	err = ext2_prepare_chunk(page, pos, len);
 	BUG_ON(err);
 	de->inode = cpu_to_le32(inode->i_ino);
-	ext2_set_de_type(de, inode);
+	ext2_set_de_type(de, inode->i_sb, inode->i_mode, 0);
 	err = ext2_commit_chunk(page, pos, len);
 	ext2_put_page(page);
 	if (update_times)
@@ -489,7 +494,18 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 	mark_inode_dirty(dir);
 }
 
-int ext2_add_entry(struct dentry *dentry, struct inode *inode)
+/*
+ * Called from three settings:
+ *
+ * - Creating a regular entry - de/page NULL, doesn't exist
+ * - Creating a fallthru - de/page NULL, doesn't exist
+ * - Creating a whiteout - de/page set if it exists
+ *
+ * @new_file_type is either EXT2_FT_WHT, EXT2_FT_FALLTHRU, or 0.  If
+ * 0, file type is determined by inode->i_mode.
+ */
+int ext2_add_entry(struct dentry *dentry, ino_t ino, umode_t mode,
+		   unsigned char new_file_type)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
 	const char *name = dentry->d_name.name;
@@ -497,10 +513,10 @@ int ext2_add_entry(struct dentry *dentry, struct inode *inode)
 	unsigned chunk_size = ext2_chunk_size(dir);
 	unsigned reclen = EXT2_DIR_REC_LEN(namelen);
 	unsigned short rec_len, name_len;
-	struct page *page = NULL;
-	ext2_dirent * de;
 	unsigned long npages = dir_pages(dir);
 	unsigned long n;
+	ext2_dirent *de;
+	struct page *page;
 	char *kaddr;
 	loff_t pos;
 	int err;
@@ -530,6 +546,7 @@ int ext2_add_entry(struct dentry *dentry, struct inode *inode)
 				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
 				de->file_type = 0;
+				printk("%s: allocated new de\n", dentry->d_name.name);
 				goto got_it;
 			}
 			if (de->rec_len == 0) {
@@ -538,15 +555,22 @@ int ext2_add_entry(struct dentry *dentry, struct inode *inode)
 				err = -EIO;
 				goto out_unlock;
 			}
-			err = -EEXIST;
-			if (ext2_match (namelen, name, de))
-				goto out_unlock;
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
 			rec_len = ext2_rec_len_from_disk(de->rec_len);
-			if (!ext2_dirent_in_use(de) && rec_len >= reclen)
+			if (ext2_match(namelen, name, de)) {
+				err = -EEXIST;
+				/* XXX handle whiteouts and fallthroughs here */
+				printk("%s: found existing de\n", dentry->d_name.name);
+				goto got_it;
+			}
+			if (!ext2_dirent_in_use(de) && rec_len >= reclen) {
+				printk("%s: reusing empty de\n", dentry->d_name.name);
 				goto got_it;
-			if (rec_len >= name_len + reclen)
+			}
+			if (rec_len >= name_len + reclen) {
+				printk("%s: carving off end of in-use de\n", dentry->d_name.name);
 				goto got_it;
+			}
 			de = (ext2_dirent *) ((char *) de + rec_len);
 		}
 		unlock_page(page);
@@ -561,7 +585,7 @@ got_it:
 	err = ext2_prepare_chunk(page, pos, rec_len);
 	if (err)
 		goto out_unlock;
-	if (ext2_dirent_in_use(de)) {
+	if (ext2_dirent_in_use(de) && !ext2_match (namelen, name, de)) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
 		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
 		de->rec_len = ext2_rec_len_to_disk(name_len);
@@ -569,8 +593,8 @@ got_it:
 	}
 	de->name_len = namelen;
 	memcpy(de->name, name, namelen);
-	de->inode = cpu_to_le32(inode->i_ino);
-	ext2_set_de_type (de, inode);
+	de->inode = cpu_to_le32(ino);
+	ext2_set_de_type(de, dir->i_sb, mode, new_file_type);
 	err = ext2_commit_chunk(page, pos, rec_len);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
@@ -587,7 +611,7 @@ out_unlock:
 
 int ext2_add_link(struct dentry *dentry, struct inode *inode)
 {
-	return ext2_add_entry(dentry, inode);
+	return ext2_add_entry(dentry, inode->i_ino, inode->i_mode, 0);
 }
 
 /*
@@ -660,14 +684,14 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
 	de->rec_len = ext2_rec_len_to_disk(EXT2_DIR_REC_LEN(1));
 	memcpy (de->name, ".\0\0", 4);
 	de->inode = cpu_to_le32(inode->i_ino);
-	ext2_set_de_type (de, inode);
+	ext2_set_de_type (de, inode->i_sb, inode->i_mode, 0);
 
 	de = (struct ext2_dir_entry_2 *)(kaddr + EXT2_DIR_REC_LEN(1));
 	de->name_len = 2;
 	de->rec_len = ext2_rec_len_to_disk(chunk_size - EXT2_DIR_REC_LEN(1));
 	de->inode = cpu_to_le32(parent->i_ino);
 	memcpy (de->name, "..\0", 4);
-	ext2_set_de_type (de, inode);
+	ext2_set_de_type (de, inode->i_sb, inode->i_mode, 0);
 	kunmap_atomic(kaddr, KM_USER0);
 	err = ext2_commit_chunk(page, 0, chunk_size);
 fail:

