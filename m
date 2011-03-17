Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1CQX3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:29:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:26826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab1CQX3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="614394818"
To: Al Viro <viro@ZenIV.linux.org.uk>
From: Tony Luck <tony.luck@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Some fixes for pstore (Was Re: [git pull] mnt_devname queue)
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
 <20110317072344.GZ22723@ZenIV.linux.org.uk>
 <AANLkTin=5jSzZKXLL=A+dbRn1jB+tPg56LmjthzC02ui@mail.gmail.com>
 <20110317104434.GB22723@ZenIV.linux.org.uk>
 <4d827eae305473e2bf@agluck-desktop.sc.intel.com>
 <20110317224252.GC22723@ZenIV.linux.org.uk>
 <AANLkTim5pj0J4VaYRzK8_8fpb0=hO5yxhAL48egiTE2e@mail.gmail.com>
In-Reply-To: <20110316235608.GY22723@ZenIV.linux.org.uk>
Date: Thu, 17 Mar 2011 16:29:15 -0700
Message-Id: <4d82994b3095310bde@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Send the updated patch my way, please.

Here it is.

-Tony

---

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 549d245..0834223 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -40,9 +40,29 @@
 struct pstore_private {
 	u64	id;
 	int	(*erase)(u64);
+	ssize_t	size;
+	char	data[];
 };
 
-#define pstore_get_inode ramfs_get_inode
+static int pstore_file_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
+						size_t count, loff_t *ppos)
+{
+	struct pstore_private *ps = file->private_data;
+
+	return simple_read_from_buffer(userbuf, count, ppos, ps->data, ps->size);
+}
+
+static const struct file_operations pstore_file_operations = {
+	.open	= pstore_file_open,
+	.read	= pstore_file_read,
+	.llseek	= default_llseek,
+};
 
 /*
  * When a file is unlinked from our file system we call the
@@ -63,6 +83,30 @@ static const struct inode_operations pstore_dir_inode_operations = {
 	.unlink		= pstore_unlink,
 };
 
+static struct inode *pstore_get_inode(struct super_block *sb,
+					const struct inode *dir, int mode, dev_t dev)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (inode) {
+		inode->i_ino = get_next_ino();
+		inode->i_uid = inode->i_gid = 0;
+		inode->i_mode = mode;
+		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+		switch (mode & S_IFMT) {
+		case S_IFREG:
+			inode->i_fop = &pstore_file_operations;
+			break;
+		case S_IFDIR:
+			inode->i_op = &pstore_dir_inode_operations;
+			inode->i_fop = &simple_dir_operations;
+			inc_nlink(inode);
+			break;
+		}
+	}
+	return inode;
+}
+
 static const struct super_operations pstore_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
@@ -70,37 +114,10 @@ static const struct super_operations pstore_ops = {
 };
 
 static struct super_block *pstore_sb;
-static struct vfsmount *pstore_mnt;
 
 int pstore_is_mounted(void)
 {
-	return pstore_mnt != NULL;
-}
-
-/*
- * Set up a file structure as if we had opened this file and
- * write our data to it.
- */
-static int pstore_writefile(struct inode *inode, struct dentry *dentry,
-	char *data, size_t size)
-{
-	struct file f;
-	ssize_t n;
-	mm_segment_t old_fs = get_fs();
-
-	memset(&f, '0', sizeof f);
-	f.f_mapping = inode->i_mapping;
-	f.f_path.dentry = dentry;
-	f.f_path.mnt = pstore_mnt;
-	f.f_pos = 0;
-	f.f_op = inode->i_fop;
-	set_fs(KERNEL_DS);
-	n = do_sync_write(&f, data, size, &f.f_pos);
-	set_fs(old_fs);
-
-	fsnotify_modify(&f);
-
-	return n == size;
+	return pstore_sb != NULL;
 }
 
 /*
@@ -123,8 +140,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	inode = pstore_get_inode(pstore_sb, root->d_inode, S_IFREG | 0444, 0);
 	if (!inode)
 		goto fail;
-	inode->i_uid = inode->i_gid = 0;
-	private = kmalloc(sizeof *private, GFP_KERNEL);
+	private = kmalloc(sizeof *private + size, GFP_KERNEL);
 	if (!private)
 		goto fail_alloc;
 	private->id = id;
@@ -152,28 +168,19 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
 	if (IS_ERR(dentry))
 		goto fail_lockedalloc;
 
-	d_add(dentry, inode);
-
-	mutex_unlock(&root->d_inode->i_mutex);
-
-	if (!pstore_writefile(inode, dentry, data, size))
-		goto fail_write;
+	memcpy(private->data, data, size);
+	inode->i_size = private->size = size;
 
 	inode->i_private = private;
 
 	if (time.tv_sec)
 		inode->i_mtime = inode->i_ctime = time;
 
-	return 0;
+	d_add(dentry, inode);
 
-fail_write:
-	kfree(private);
-	inode->i_nlink--;
-	mutex_lock(&root->d_inode->i_mutex);
-	d_delete(dentry);
-	dput(dentry);
 	mutex_unlock(&root->d_inode->i_mutex);
-	goto fail;
+
+	return 0;
 
 fail_lockedalloc:
 	mutex_unlock(&root->d_inode->i_mutex);
@@ -225,32 +232,21 @@ fail:
 	return err;
 }
 
-static int pstore_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
+static struct dentry *pstore_mount(struct file_system_type *fs_type,
+	int flags, const char *dev_name, void *data)
 {
-	struct dentry *root;
-
-	root = mount_nodev(fs_type, flags, data, pstore_fill_super);
-	if (IS_ERR(root))
-		return -ENOMEM;
-
-	mnt->mnt_root = root;
-	mnt->mnt_sb = root->d_sb;
-	pstore_mnt = mnt;
-
-	return 0;
+	return mount_single(fs_type, flags, data, pstore_fill_super);
 }
 
 static void pstore_kill_sb(struct super_block *sb)
 {
 	kill_litter_super(sb);
 	pstore_sb = NULL;
-	pstore_mnt = NULL;
 }
 
 static struct file_system_type pstore_fs_type = {
 	.name		= "pstore",
-	.get_sb		= pstore_get_sb,
+	.mount		= pstore_mount,
 	.kill_sb	= pstore_kill_sb,
 };
 
