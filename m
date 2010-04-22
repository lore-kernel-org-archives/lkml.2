Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab0DVTkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:40:32 -0400
Received: from kroah.org ([198.145.64.141]:41400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab0DVT3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:33 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:21 2010
Message-Id: <20100422190921.175033203@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [154/197] eCryptfs: Decrypt symlink target for stat size
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 3a60a1686f0d51c99bd0df8ac93050fb6dfce647 upstream.

Create a getattr handler for eCryptfs symlinks that is capable of
reading the lower target and decrypting its path.  Prior to this patch,
a stat's st_size field would represent the strlen of the encrypted path,
while readlink() would return the strlen of the decrypted path.  This
could lead to confusion in some userspace applications, since the two
values should be equal.

https://bugs.launchpad.net/bugs/524919

Reported-by: Loïc Minier <loic.minier@canonical.com>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |  100 +++++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 48 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -638,38 +638,17 @@ out_lock:
 	return rc;
 }
 
-static int
-ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
+static int ecryptfs_readlink_lower(struct dentry *dentry, char **buf,
+				   size_t *bufsiz)
 {
+	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	char *lower_buf;
-	size_t lower_bufsiz;
-	struct dentry *lower_dentry;
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
-	char *plaintext_name;
-	size_t plaintext_name_size;
+	size_t lower_bufsiz = PATH_MAX;
 	mm_segment_t old_fs;
 	int rc;
 
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!lower_dentry->d_inode->i_op->readlink) {
-		rc = -EINVAL;
-		goto out;
-	}
-	mount_crypt_stat = &ecryptfs_superblock_to_private(
-						dentry->d_sb)->mount_crypt_stat;
-	/*
-	 * If the lower filename is encrypted, it will result in a significantly
-	 * longer name.  If needed, truncate the name after decode and decrypt.
-	 */
-	if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES)
-		lower_bufsiz = PATH_MAX;
-	else
-		lower_bufsiz = bufsiz;
-	/* Released in this function */
 	lower_buf = kmalloc(lower_bufsiz, GFP_KERNEL);
-	if (lower_buf == NULL) {
-		printk(KERN_ERR "%s: Out of memory whilst attempting to "
-		       "kmalloc [%zd] bytes\n", __func__, lower_bufsiz);
+	if (!lower_buf) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -679,29 +658,31 @@ ecryptfs_readlink(struct dentry *dentry,
 						   (char __user *)lower_buf,
 						   lower_bufsiz);
 	set_fs(old_fs);
-	if (rc >= 0) {
-		rc = ecryptfs_decode_and_decrypt_filename(&plaintext_name,
-							  &plaintext_name_size,
-							  dentry, lower_buf,
-							  rc);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to decode and "
-			       "decrypt filename; rc = [%d]\n", __func__,
-				rc);
-			goto out_free_lower_buf;
-		}
-		/* Check for bufsiz <= 0 done in sys_readlinkat() */
-		rc = copy_to_user(buf, plaintext_name,
-				  min((size_t) bufsiz, plaintext_name_size));
-		if (rc)
-			rc = -EFAULT;
-		else
-			rc = plaintext_name_size;
-		kfree(plaintext_name);
-		fsstack_copy_attr_atime(dentry->d_inode, lower_dentry->d_inode);
-	}
-out_free_lower_buf:
+	if (rc < 0)
+		goto out;
+	lower_bufsiz = rc;
+	rc = ecryptfs_decode_and_decrypt_filename(buf, bufsiz, dentry,
+						  lower_buf, lower_bufsiz);
+out:
 	kfree(lower_buf);
+	return rc;
+}
+
+static int
+ecryptfs_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
+{
+	char *kbuf;
+	size_t kbufsiz, copied;
+	int rc;
+
+	rc = ecryptfs_readlink_lower(dentry, &kbuf, &kbufsiz);
+	if (rc)
+		goto out;
+	copied = min_t(size_t, bufsiz, kbufsiz);
+	rc = copy_to_user(buf, kbuf, copied) ? -EFAULT : copied;
+	kfree(kbuf);
+	fsstack_copy_attr_atime(dentry->d_inode,
+				ecryptfs_dentry_to_lower(dentry)->d_inode);
 out:
 	return rc;
 }
@@ -971,6 +952,28 @@ out:
 	return rc;
 }
 
+int ecryptfs_getattr_link(struct vfsmount *mnt, struct dentry *dentry,
+			  struct kstat *stat)
+{
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+	int rc = 0;
+
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+						dentry->d_sb)->mount_crypt_stat;
+	generic_fillattr(dentry->d_inode, stat);
+	if (mount_crypt_stat->flags & ECRYPTFS_GLOBAL_ENCRYPT_FILENAMES) {
+		char *target;
+		size_t targetsiz;
+
+		rc = ecryptfs_readlink_lower(dentry, &target, &targetsiz);
+		if (!rc) {
+			kfree(target);
+			stat->size = targetsiz;
+		}
+	}
+	return rc;
+}
+
 int ecryptfs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		     struct kstat *stat)
 {
@@ -1088,6 +1091,7 @@ const struct inode_operations ecryptfs_s
 	.put_link = ecryptfs_put_link,
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
+	.getattr = ecryptfs_getattr_link,
 	.setxattr = ecryptfs_setxattr,
 	.getxattr = ecryptfs_getxattr,
 	.listxattr = ecryptfs_listxattr,


