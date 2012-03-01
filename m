Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565Ab2CAVzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:55:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965434Ab2CAVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.227.105 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213926.126802364@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Christoph Hellwig <hch@lst.de>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-fsdevel@vger.kernel.org,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 24/34] eCryptfs: Use notify_change for truncating lower inodes
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 5f3ef64f4da1c587cdcfaaac72311225b7df094c upstream.

When truncating inodes in the lower filesystem, eCryptfs directly
invoked vmtruncate(). As Christoph Hellwig pointed out, vmtruncate() is
a filesystem helper function, but filesystems may need to do more than
just a call to vmtruncate().

This patch moves the lower inode truncation out of ecryptfs_truncate()
and renames the function to truncate_upper().  truncate_upper() updates
an iattr for the lower inode to indicate if the lower inode needs to be
truncated upon return.  ecryptfs_setattr() then calls notify_change(),
using the updated iattr for the lower inode, to complete the truncation.

For eCryptfs functions needing to truncate, ecryptfs_truncate() is
reintroduced as a simple way to truncate the upper inode to a specified
size and then truncate the lower inode accordingly.

https://bugs.launchpad.net/bugs/451368

Reported-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dustin Kirkland <kirkland@canonical.com>
Cc: ecryptfs-devel@lists.launchpad.net
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 fs/ecryptfs/inode.c |   99 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 32 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -758,18 +758,23 @@ upper_size_to_lower_size(struct ecryptfs
 }
 
 /**
- * ecryptfs_truncate
+ * truncate_upper
  * @dentry: The ecryptfs layer dentry
- * @new_length: The length to expand the file to
+ * @ia: Address of the ecryptfs inode's attributes
+ * @lower_ia: Address of the lower inode's attributes
  *
  * Function to handle truncations modifying the size of the file. Note
  * that the file sizes are interpolated. When expanding, we are simply
- * writing strings of 0's out. When truncating, we need to modify the
- * underlying file size according to the page index interpolations.
+ * writing strings of 0's out. When truncating, we truncate the upper
+ * inode and update the lower_ia according to the page index
+ * interpolations. If ATTR_SIZE is set in lower_ia->ia_valid upon return,
+ * the caller must use lower_ia in a call to notify_change() to perform
+ * the truncation of the lower inode.
  *
  * Returns zero on success; non-zero otherwise
  */
-int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
+static int truncate_upper(struct dentry *dentry, struct iattr *ia,
+			  struct iattr *lower_ia)
 {
 	int rc = 0;
 	struct inode *inode = dentry->d_inode;
@@ -780,8 +785,10 @@ int ecryptfs_truncate(struct dentry *den
 	loff_t lower_size_before_truncate;
 	loff_t lower_size_after_truncate;
 
-	if (unlikely((new_length == i_size)))
+	if (unlikely((ia->ia_size == i_size))) {
+		lower_ia->ia_valid &= ~ATTR_SIZE;
 		goto out;
+	}
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	/* Set up a fake ecryptfs file, this is used to interface with
 	 * the file in the underlying filesystem so that the
@@ -801,28 +808,30 @@ int ecryptfs_truncate(struct dentry *den
 		&fake_ecryptfs_file,
 		ecryptfs_inode_to_private(dentry->d_inode)->lower_file);
 	/* Switch on growing or shrinking file */
-	if (new_length > i_size) {
+	if (ia->ia_size > i_size) {
 		char zero[] = { 0x00 };
 
+		lower_ia->ia_valid &= ~ATTR_SIZE;
 		/* Write a single 0 at the last position of the file;
 		 * this triggers code that will fill in 0's throughout
 		 * the intermediate portion of the previous end of the
 		 * file and the new and of the file */
 		rc = ecryptfs_write(&fake_ecryptfs_file, zero,
-				    (new_length - 1), 1);
-	} else { /* new_length < i_size_read(inode) */
-		/* We're chopping off all the pages down do the page
-		 * in which new_length is located. Fill in the end of
-		 * that page from (new_length & ~PAGE_CACHE_MASK) to
+				    (ia->ia_size - 1), 1);
+	} else { /* ia->ia_size < i_size_read(inode) */
+		/* We're chopping off all the pages down to the page
+		 * in which ia->ia_size is located. Fill in the end of
+		 * that page from (ia->ia_size & ~PAGE_CACHE_MASK) to
 		 * PAGE_CACHE_SIZE with zeros. */
 		size_t num_zeros = (PAGE_CACHE_SIZE
-				    - (new_length & ~PAGE_CACHE_MASK));
+				    - (ia->ia_size & ~PAGE_CACHE_MASK));
 
 		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
-			rc = vmtruncate(inode, new_length);
+			rc = vmtruncate(inode, ia->ia_size);
 			if (rc)
 				goto out_free;
-			rc = vmtruncate(lower_dentry->d_inode, new_length);
+			lower_ia->ia_size = ia->ia_size;
+			lower_ia->ia_valid |= ATTR_SIZE;
 			goto out_free;
 		}
 		if (num_zeros) {
@@ -834,7 +843,7 @@ int ecryptfs_truncate(struct dentry *den
 				goto out_free;
 			}
 			rc = ecryptfs_write(&fake_ecryptfs_file, zeros_virt,
-					    new_length, num_zeros);
+					    ia->ia_size, num_zeros);
 			kfree(zeros_virt);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to zero out "
@@ -843,7 +852,7 @@ int ecryptfs_truncate(struct dentry *den
 				goto out_free;
 			}
 		}
-		vmtruncate(inode, new_length);
+		vmtruncate(inode, ia->ia_size);
 		rc = ecryptfs_write_inode_size_to_metadata(inode);
 		if (rc) {
 			printk(KERN_ERR	"Problem with "
@@ -856,10 +865,12 @@ int ecryptfs_truncate(struct dentry *den
 		lower_size_before_truncate =
 		    upper_size_to_lower_size(crypt_stat, i_size);
 		lower_size_after_truncate =
-		    upper_size_to_lower_size(crypt_stat, new_length);
-		if (lower_size_after_truncate < lower_size_before_truncate)
-			vmtruncate(lower_dentry->d_inode,
-				   lower_size_after_truncate);
+		    upper_size_to_lower_size(crypt_stat, ia->ia_size);
+		if (lower_size_after_truncate < lower_size_before_truncate) {
+			lower_ia->ia_size = lower_size_after_truncate;
+			lower_ia->ia_valid |= ATTR_SIZE;
+		} else
+			lower_ia->ia_valid &= ~ATTR_SIZE;
 	}
 out_free:
 	if (ecryptfs_file_to_private(&fake_ecryptfs_file))
@@ -869,6 +880,33 @@ out:
 	return rc;
 }
 
+/**
+ * ecryptfs_truncate
+ * @dentry: The ecryptfs layer dentry
+ * @new_length: The length to expand the file to
+ *
+ * Simple function that handles the truncation of an eCryptfs inode and
+ * its corresponding lower inode.
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
+{
+	struct iattr ia = { .ia_valid = ATTR_SIZE, .ia_size = new_length };
+	struct iattr lower_ia = { .ia_valid = 0 };
+	int rc;
+
+	rc = truncate_upper(dentry, &ia, &lower_ia);
+	if (!rc && lower_ia.ia_valid & ATTR_SIZE) {
+		struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
+
+		mutex_lock(&lower_dentry->d_inode->i_mutex);
+		rc = notify_change(lower_dentry, &lower_ia);
+		mutex_unlock(&lower_dentry->d_inode->i_mutex);
+	}
+	return rc;
+}
+
 static int
 ecryptfs_permission(struct inode *inode, int mask)
 {
@@ -891,6 +929,7 @@ static int ecryptfs_setattr(struct dentr
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
+	struct iattr lower_ia;
 	struct inode *inode;
 	struct inode *lower_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
@@ -929,15 +968,11 @@ static int ecryptfs_setattr(struct dentr
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
+	memcpy(&lower_ia, ia, sizeof(lower_ia));
+	if (ia->ia_valid & ATTR_FILE)
+		lower_ia.ia_file = ecryptfs_file_to_lower(ia->ia_file);
 	if (ia->ia_valid & ATTR_SIZE) {
-		ecryptfs_printk(KERN_DEBUG,
-				"ia->ia_valid = [0x%x] ATTR_SIZE" " = [0x%x]\n",
-				ia->ia_valid, ATTR_SIZE);
-		rc = ecryptfs_truncate(dentry, ia->ia_size);
-		/* ecryptfs_truncate handles resizing of the lower file */
-		ia->ia_valid &= ~ATTR_SIZE;
-		ecryptfs_printk(KERN_DEBUG, "ia->ia_valid = [%x]\n",
-				ia->ia_valid);
+		rc = truncate_upper(dentry, ia, &lower_ia);
 		if (rc < 0)
 			goto out;
 	}
@@ -946,11 +981,11 @@ static int ecryptfs_setattr(struct dentr
 	 * mode change is for clearing setuid/setgid bits. Allow lower fs
 	 * to interpret this in its own way.
 	 */
-	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
-		ia->ia_valid &= ~ATTR_MODE;
+	if (lower_ia.ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		lower_ia.ia_valid &= ~ATTR_MODE;
 
 	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = notify_change(lower_dentry, ia);
+	rc = notify_change(lower_dentry, &lower_ia);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
 	fsstack_copy_attr_all(inode, lower_inode, NULL);


