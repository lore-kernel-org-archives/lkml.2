Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab2BAVgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:36:44 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55786 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499Ab2BAVJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:09:56 -0500
X-Sasl-enc: zIuurSMNrIs0YIWRb+R+DfMdDCGZ2IK9XgrXysEsc9YK 1328130595
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:44 2012
Message-Id: <20120201210044.421971683@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:59:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>,
        Li Wang <liwang@nudt.edu.cn>
Subject: [06/89] eCryptfs: Check inode changes in setattr
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit a261a03904849c3df50bd0300efb7fb3f865137d upstream.

Most filesystems call inode_change_ok() very early in ->setattr(), but
eCryptfs didn't call it at all. It allowed the lower filesystem to make
the call in its ->setattr() function. Then, eCryptfs would copy the
appropriate inode attributes from the lower inode to the eCryptfs inode.

This patch changes that and actually calls inode_change_ok() on the
eCryptfs inode, fairly early in ecryptfs_setattr(). Ideally, the call
would happen earlier in ecryptfs_setattr(), but there are some possible
inode initialization steps that must happen first.

Since the call was already being made on the lower inode, the change in
functionality should be minimal, except for the case of a file extending
truncate call. In that case, inode_newsize_ok() was never being
called on the eCryptfs inode. Rather than inode_newsize_ok() catching
maximum file size errors early on, eCryptfs would encrypt zeroed pages
and write them to the lower filesystem until the lower filesystem's
write path caught the error in generic_write_checks(). This patch
introduces a new function, called ecryptfs_inode_newsize_ok(), which
checks if the new lower file size is within the appropriate limits when
the truncate operation will be growing the lower file.

In summary this change prevents eCryptfs truncate operations (and the
resulting page encryptions), which would exceed the lower filesystem
limits or FSIZE rlimits, from ever starting.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reviewed-by: Li Wang <liwang@nudt.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/inode.c |   48 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -841,18 +841,6 @@ static int truncate_upper(struct dentry
 		size_t num_zeros = (PAGE_CACHE_SIZE
 				    - (ia->ia_size & ~PAGE_CACHE_MASK));
 
-
-		/*
-		 * XXX(truncate) this should really happen at the begginning
-		 * of ->setattr.  But the code is too messy to that as part
-		 * of a larger patch.  ecryptfs is also totally missing out
-		 * on the inode_change_ok check at the beginning of
-		 * ->setattr while would include this.
-		 */
-		rc = inode_newsize_ok(inode, ia->ia_size);
-		if (rc)
-			goto out;
-
 		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
 			truncate_setsize(inode, ia->ia_size);
 			lower_ia->ia_size = ia->ia_size;
@@ -902,6 +890,28 @@ out:
 	return rc;
 }
 
+static int ecryptfs_inode_newsize_ok(struct inode *inode, loff_t offset)
+{
+	struct ecryptfs_crypt_stat *crypt_stat;
+	loff_t lower_oldsize, lower_newsize;
+
+	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
+	lower_oldsize = upper_size_to_lower_size(crypt_stat,
+						 i_size_read(inode));
+	lower_newsize = upper_size_to_lower_size(crypt_stat, offset);
+	if (lower_newsize > lower_oldsize) {
+		/*
+		 * The eCryptfs inode and the new *lower* size are mixed here
+		 * because we may not have the lower i_mutex held and/or it may
+		 * not be appropriate to call inode_newsize_ok() with inodes
+		 * from other filesystems.
+		 */
+		return inode_newsize_ok(inode, lower_newsize);
+	}
+
+	return 0;
+}
+
 /**
  * ecryptfs_truncate
  * @dentry: The ecryptfs layer dentry
@@ -918,6 +928,10 @@ int ecryptfs_truncate(struct dentry *den
 	struct iattr lower_ia = { .ia_valid = 0 };
 	int rc;
 
+	rc = ecryptfs_inode_newsize_ok(dentry->d_inode, new_length);
+	if (rc)
+		return rc;
+
 	rc = truncate_upper(dentry, &ia, &lower_ia);
 	if (!rc && lower_ia.ia_valid & ATTR_SIZE) {
 		struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
@@ -997,6 +1011,16 @@ static int ecryptfs_setattr(struct dentr
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
+
+	rc = inode_change_ok(inode, ia);
+	if (rc)
+		goto out;
+	if (ia->ia_valid & ATTR_SIZE) {
+		rc = ecryptfs_inode_newsize_ok(inode, ia->ia_size);
+		if (rc)
+			goto out;
+	}
+
 	if (S_ISREG(inode->i_mode)) {
 		rc = filemap_write_and_wait(inode->i_mapping);
 		if (rc)


