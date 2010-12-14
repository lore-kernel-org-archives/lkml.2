Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0LNXL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:11:57 -0500
Received: from www84.your-server.de ([213.133.104.84]:59282 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab0LNXL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:11:56 -0500
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: stefani@seibold.net
Subject: [PATCH] cramfs: generate unique inode number for better inode cache usage
Date: Wed, 15 Dec 2010 00:12:40 +0100
Message-Id: <1292368360-32216-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.3.3
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This is second version, hope this is less ugly code :-)

This patch generates a unique inode numbers for any entries in the cram file
system. For files which did not contain data's (device nodes, fifos and
sockets) the offset of the directory entry inside the cramfs plus 1 will be
used as inode number.

The + 1 for the inode will it make possible to distinguish between
a file which contains no data and files which has data, the later one has
a inode value where the lower two bits are always 0.

It also reimplement the behavoir to set the size and the number of block
to 0 for special file, which is the right value for empty files,
devices, fifos and sockets

As a little benefit it will be also more compatible which older
mkcramfs, because it will never use the cramfs_inode->offset for
creating a inode number for special files.

The patch is aginst 2.6.37-rc5

Please apply it.

Thanks,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 fs/cramfs/inode.c |   85 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/fs/cramfs/inode.c b/fs/cramfs/inode.c
index 32fd5fe..0b39167 100644
--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -36,16 +36,29 @@ static DEFINE_MUTEX(read_mutex);
 
 /* These two macros may change in future, to provide better st_ino
    semantics. */
-#define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
+#define CRAMINO_UNIQ(x)	((x) + 1)
 #define OFFSET(x)	((x)->i_ino)
 
-static void setup_inode(struct inode *inode, struct cramfs_inode * cramfs_inode)
+static unsigned long cramino(struct cramfs_inode * cino,
+					unsigned int offset)
+{
+	if (!cino->offset)
+		return CRAMINO_UNIQ(offset);
+	if (!cino->size)
+		return CRAMINO_UNIQ(offset);
+
+	return cino->offset << 2;
+}
+
+static void setup_inode(struct inode *inode, struct cramfs_inode * cramfs_inode, u32 size)
 {
 	static struct timespec zerotime;
 	inode->i_mode = cramfs_inode->mode;
 	inode->i_uid = cramfs_inode->uid;
-	inode->i_size = cramfs_inode->size;
-	inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
+	if (size) {
+		inode->i_size = size;
+		inode->i_blocks = (size - 1) / 512 + 1;
+	}
 	inode->i_gid = cramfs_inode->gid;
 	/* Struct copy intentional */
 	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
@@ -53,36 +66,41 @@ static void setup_inode(struct inode *inode, struct cramfs_inode * cramfs_inode)
 	   but it's the best we can do without reading the directory
 	   contents.  1 yields the right result in GNU find, even
 	   without -noleaf option. */
-	if (S_ISREG(inode->i_mode)) {
-		inode->i_fop = &generic_ro_fops;
-		inode->i_data.a_ops = &cramfs_aops;
-	} else if (S_ISDIR(inode->i_mode)) {
-		inode->i_op = &cramfs_dir_inode_operations;
-		inode->i_fop = &cramfs_directory_operations;
-	} else if (S_ISLNK(inode->i_mode)) {
-		inode->i_op = &page_symlink_inode_operations;
-		inode->i_data.a_ops = &cramfs_aops;
-	} else {
-		init_special_inode(inode, inode->i_mode,
-			old_decode_dev(cramfs_inode->size));
-	}
+	unlock_new_inode(inode);
 }
 
 static struct inode *get_cramfs_inode(struct super_block *sb,
-				struct cramfs_inode * cramfs_inode)
+	struct cramfs_inode * cramfs_inode, unsigned int offset)
 {
 	struct inode *inode;
-	if (CRAMINO(cramfs_inode) == 1) {
-		inode = new_inode(sb);
-		if (inode) {
-			inode->i_ino = 1;
-			setup_inode(inode, cramfs_inode);
+
+	if (S_ISREG(cramfs_inode->mode)) {
+		inode = iget_locked(sb, cramino(cramfs_inode, offset));
+		if (inode && (inode->i_state & I_NEW)) {
+			inode->i_fop = &generic_ro_fops;
+			inode->i_data.a_ops = &cramfs_aops;
+			setup_inode(inode, cramfs_inode, cramfs_inode->size);
+		}
+	} else if (S_ISDIR(cramfs_inode->mode)) {
+		inode = iget_locked(sb, cramino(cramfs_inode, offset));
+		if (inode && (inode->i_state & I_NEW)) {
+			inode->i_op = &cramfs_dir_inode_operations;
+			inode->i_fop = &cramfs_directory_operations;
+			setup_inode(inode, cramfs_inode, cramfs_inode->size);
+		}
+	} else if (S_ISLNK(cramfs_inode->mode)) {
+		inode = iget_locked(sb, cramino(cramfs_inode, offset));
+		if (inode && (inode->i_state & I_NEW)) {
+			inode->i_op = &page_symlink_inode_operations;
+			inode->i_data.a_ops = &cramfs_aops;
+			setup_inode(inode, cramfs_inode, cramfs_inode->size);
 		}
 	} else {
-		inode = iget_locked(sb, CRAMINO(cramfs_inode));
+		inode = iget_locked(sb, CRAMINO_UNIQ(offset));
 		if (inode && (inode->i_state & I_NEW)) {
-			setup_inode(inode, cramfs_inode);
-			unlock_new_inode(inode);
+			init_special_inode(inode, cramfs_inode->mode,
+				old_decode_dev(cramfs_inode->size));
+			setup_inode(inode, cramfs_inode, 0);
 		}
 	}
 	return inode;
@@ -265,6 +283,9 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 		printk(KERN_ERR "cramfs: root is not a directory\n");
 		goto out;
 	}
+	/* correct strange, hard-coded permissions of mkcramfs */
+	super.root.mode |= (S_IRUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
+
 	root_offset = super.root.offset << 2;
 	if (super.flags & CRAMFS_FLAG_FSID_VERSION_2) {
 		sbi->size=super.size;
@@ -289,7 +310,7 @@ static int cramfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Set it all up.. */
 	sb->s_op = &cramfs_ops;
-	root = get_cramfs_inode(sb, &super.root);
+	root = get_cramfs_inode(sb, &super.root, 0);
 	if (!root)
 		goto out;
 	sb->s_root = d_alloc_root(root);
@@ -365,8 +386,11 @@ static int cramfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		 */
 		namelen = de->namelen << 2;
 		memcpy(buf, name, namelen);
-		ino = CRAMINO(de);
 		mode = de->mode;
+		if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
+			ino = cramino(de, OFFSET(inode) + offset);
+		else
+			ino = CRAMINO_UNIQ(OFFSET(inode) + offset);
 		mutex_unlock(&read_mutex);
 		nextoffset = offset + sizeof(*de) + namelen;
 		for (;;) {
@@ -404,8 +428,9 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 		struct cramfs_inode *de;
 		char *name;
 		int namelen, retval;
+		int dir_off = OFFSET(dir) + offset;
 
-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
+		de = cramfs_read(dir->i_sb, dir_off, sizeof(*de)+CRAMFS_MAXPATHLEN);
 		name = (char *)(de+1);
 
 		/* Try to take advantage of sorted directories */
@@ -436,7 +461,7 @@ static struct dentry * cramfs_lookup(struct inode *dir, struct dentry *dentry, s
 		if (!retval) {
 			struct cramfs_inode entry = *de;
 			mutex_unlock(&read_mutex);
-			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry));
+			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry, dir_off));
 			return NULL;
 		}
 		/* else (retval < 0) */
-- 
1.7.3.3

