Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab0EQNzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:55:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36617 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0EQNzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:55:48 -0400
MIME-Version: 1.0
Date: Mon, 17 May 2010 16:55:47 +0300
Message-ID: <AANLkTimB1DsCd8HuMDc9jgVOnOAE_PVd2ktssp3TIwxc@mail.gmail.com>
Subject: [PATCH v5] mtd: Do not corrupt backing device of device node inode
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
backing device of device node inode, since file->f_mapping is equal to
inode->i_mapping (see __dentry_open() in fs/open.c).

Let's introduce separate inode for MTD device with appropriate backing
device.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: Jan Kara <jack@suse.cz>
---
Changelog:
 v4 -> v5:
 - Fix race pointed by David Woodhouse.
 v3 -> v4:
 - Use igrab() instead of __iget inside the inode_lock;
 - Add stable@ to CC list.
 v2 -> v3:
 - Rebase to mtd-2.6.git.
 v1 -> v2:
 - Fix error handling based on comments by Jan Kara.

---
 drivers/mtd/mtdchar.c   |   80 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/mtd/mtdcore.c   |    3 ++
 include/linux/mtd/mtd.h |    3 ++
 3 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index c355491..eb672ec 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -15,12 +15,15 @@
 #include <linux/smp_lock.h>
 #include <linux/backing-dev.h>
 #include <linux/compat.h>
+#include <linux/mount.h>

 #include <linux/mtd/mtd.h>
 #include <linux/mtd/compatmac.h>

 #include <asm/uaccess.h>

+#define MTD_INODE_FS_MAGIC 0x11307854
+static struct vfsmount *mtd_inode_mnt __read_mostly;

 /*
  * Data structure to hold the pointer to the mtd device as well
@@ -85,11 +88,33 @@ static int mtd_open(struct inode *inode, struct file *file)
 		goto out;
 	}

-	if (mtd->backing_dev_info)
-		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
+	if (!mtd->inode) {
+		struct inode *mtd_inode;
+		mtd_inode = new_inode(mtd_inode_mnt->mnt_sb);
+		if (!mtd_inode) {
+			put_mtd_device(mtd);
+			ret = -ENOMEM;
+			goto out;
+		}
+		mtd_inode->i_mode = S_IFCHR;
+		mtd_inode->i_rdev = inode->i_rdev;
+		if (mtd->backing_dev_info) {
+			mtd_inode->i_data.backing_dev_info =
+				mtd->backing_dev_info;
+		}
+
+		if (unlikely(cmpxchg(&mtd->inode, NULL, mtd_inode))) {
+			/* Somebody has already initialized mtd->inode */
+			iput(mtd_inode);
+		}
+	}
+
+	igrab(mtd->inode);
+	file->f_mapping = mtd->inode->i_mapping;

 	/* You can't open it RW if it's not a writeable device */
 	if ((file->f_mode & FMODE_WRITE) && !(mtd->flags & MTD_WRITEABLE)) {
+		iput(mtd->inode);
 		put_mtd_device(mtd);
 		ret = -EACCES;
 		goto out;
@@ -97,6 +122,7 @@ static int mtd_open(struct inode *inode, struct file *file)

 	mfi = kzalloc(sizeof(*mfi), GFP_KERNEL);
 	if (!mfi) {
+		iput(mtd->inode);
 		put_mtd_device(mtd);
 		ret = -ENOMEM;
 		goto out;
@@ -122,6 +148,8 @@ static int mtd_close(struct inode *inode, struct file *file)
 	if ((file->f_mode & FMODE_WRITE) && mtd->sync)
 		mtd->sync(mtd);

+	iput(mtd->inode);
+
 	put_mtd_device(mtd);
 	file->private_data = NULL;
 	kfree(mfi);
@@ -951,22 +979,58 @@ static const struct file_operations mtd_fops = {
 #endif
 };

+static int mtd_inodefs_get_sb(struct file_system_type *fs_type, int flags,
+                               const char *dev_name, void *data,
+                               struct vfsmount *mnt)
+{
+        return get_sb_pseudo(fs_type, "mtd_inode:", NULL, MTD_INODE_FS_MAGIC,
+                             mnt);
+}
+
+static struct file_system_type mtd_inodefs_type = {
+       .name = "mtd_inodefs",
+       .get_sb = mtd_inodefs_get_sb,
+       .kill_sb = kill_anon_super,
+};
+
 static int __init init_mtdchar(void)
 {
-	int status;
+	int ret;

-	status = __register_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS,
+	ret = __register_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS,
 				   "mtd", &mtd_fops);
-	if (status < 0) {
-		printk(KERN_NOTICE "Can't allocate major number %d for Memory
Technology Devices.\n",
-		       MTD_CHAR_MAJOR);
+	if (ret < 0) {
+		pr_notice("Can't allocate major number %d for "
+				"Memory Technology Devices.\n", MTD_CHAR_MAJOR);
+		return ret;
+	}
+
+	ret = register_filesystem(&mtd_inodefs_type);
+	if (ret) {
+		pr_notice("Can't register mtd_inodefs filesystem: %d\n", ret);
+		goto err_unregister_chdev;
 	}

-	return status;
+	mtd_inode_mnt = kern_mount(&mtd_inodefs_type);
+	if (IS_ERR(mtd_inode_mnt)) {
+		ret = PTR_ERR(mtd_inode_mnt);
+		pr_notice("Error mounting mtd_inodefs filesystem: %d\n", ret);
+		goto err_unregister_filesystem;
+	}
+
+	return ret;
+
+err_unregister_filesystem:
+	unregister_filesystem(&mtd_inodefs_type);
+err_unregister_chdev:
+	unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
+	return ret;
 }

 static void __exit cleanup_mtdchar(void)
 {
+	mntput(mtd_inode_mnt);
+	unregister_filesystem(&mtd_inodefs_type);
 	__unregister_chrdev(MTD_CHAR_MAJOR, 0, 1 << MINORBITS, "mtd");
 }

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 3ae06c8..54aab32 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -399,6 +399,9 @@ int del_mtd_device (struct mtd_info *mtd)
 		       mtd->index, mtd->name, mtd->usecount);
 		ret = -EBUSY;
 	} else {
+		if (mtd->inode)
+			iput(mtd->inode);
+
 		device_unregister(&mtd->dev);

 		idr_remove(&mtd_idr, mtd->index);
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 5326435..d66409a 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -12,6 +12,7 @@
 #include <linux/uio.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
+#include <linux/fs.h>

 #include <linux/mtd/compatmac.h>
 #include <mtd/mtd-abi.h>
@@ -174,6 +175,8 @@ struct mtd_info {
 	 */
 	struct backing_dev_info *backing_dev_info;

+	/* inode for mtd device */
+	struct inode *inode;

 	int (*read) (struct mtd_info *mtd, loff_t from, size_t len, size_t
*retlen, u_char *buf);
 	int (*write) (struct mtd_info *mtd, loff_t to, size_t len, size_t
*retlen, const u_char *buf);
-- 
1.7.0.4
