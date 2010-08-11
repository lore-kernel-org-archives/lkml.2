Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0HKXvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:51:31 -0400
Received: from kroah.org ([198.145.64.141]:57525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331Ab0HKXt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:49:56 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:46:25 2010
Message-Id: <20100811234625.355806331@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:45:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [05/11] eCryptfs: Handle ioctl calls with unlocked and compat functions
In-Reply-To: <20100811234809.GA676@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit c43f7b8fb03be8bcc579bfc4e6ab70eac887ab55 upstream.

Lower filesystems that only implemented unlocked_ioctl weren't being
passed ioctl calls because eCryptfs only checked for
lower_file->f_op->ioctl and returned -ENOTTY if it was NULL.

eCryptfs shouldn't implement ioctl(), since it doesn't require the BKL.
This patch introduces ecryptfs_unlocked_ioctl() and
ecryptfs_compat_ioctl(), which passes the calls on to the lower file
system.

https://bugs.launchpad.net/ecryptfs/+bug/469664

Reported-by: James Dupin <james.dupin@gmail.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/file.c |   56 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 21 deletions(-)

--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -303,12 +303,40 @@ static int ecryptfs_fasync(int fd, struc
 	return rc;
 }
 
-static int ecryptfs_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg);
+static long
+ecryptfs_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct file *lower_file = NULL;
+	long rc = -ENOTTY;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (lower_file && lower_file->f_op && lower_file->f_op->unlocked_ioctl)
+		rc = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
+	return rc;
+}
+
+#ifdef CONFIG_COMPAT
+static long
+ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct file *lower_file = NULL;
+	long rc = -ENOIOCTLCMD;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (lower_file && lower_file->f_op && lower_file->f_op->compat_ioctl)
+		rc = lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
+	return rc;
+}
+#endif
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ecryptfs_compat_ioctl,
+#endif
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -325,7 +353,10 @@ const struct file_operations ecryptfs_ma
 	.write = do_sync_write,
 	.aio_write = generic_file_aio_write,
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ecryptfs_compat_ioctl,
+#endif
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -334,20 +365,3 @@ const struct file_operations ecryptfs_ma
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
 };
-
-static int
-ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
-{
-	int rc = 0;
-	struct file *lower_file = NULL;
-
-	if (ecryptfs_file_to_private(file))
-		lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file && lower_file->f_op && lower_file->f_op->ioctl)
-		rc = lower_file->f_op->ioctl(ecryptfs_inode_to_lower(inode),
-					     lower_file, cmd, arg);
-	else
-		rc = -ENOTTY;
-	return rc;
-}


