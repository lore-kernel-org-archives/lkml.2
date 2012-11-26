Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2KZSWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:22:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2KZRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyler Hicks <tyhicks@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 006/270] eCryptfs: Initialize empty lower files when opening them
Date: Mon, 26 Nov 2012 14:54:56 -0200
Message-Id: <1353949160-26803-7-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit e3ccaa9761200952cc269b1f4b7d7bb77a5e071b upstream.

Historically, eCryptfs has only initialized lower files in the
ecryptfs_create() path. Lower file initialization is the act of writing
the cryptographic metadata from the inode's crypt_stat to the header of
the file. The ecryptfs_open() path already expects that metadata to be
in the header of the file.

A number of users have reported empty lower files in beneath their
eCryptfs mounts. Most of the causes for those empty files being left
around have been addressed, but the presence of empty files causes
problems due to the lack of proper cryptographic metadata.

To transparently solve this problem, this patch initializes empty lower
files in the ecryptfs_open() error path. If the metadata is unreadable
due to the lower inode size being 0, plaintext passthrough support is
not in use, and the metadata is stored in the header of the file (as
opposed to the user.ecryptfs extended attribute), the lower file will be
initialized.

The number of nested conditionals in ecryptfs_open() was getting out of
hand, so a helper function was created. To avoid the same nested
conditional problem, the conditional logic was reversed inside of the
helper function.

https://launchpad.net/bugs/911507

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    2 ++
 fs/ecryptfs/file.c            |   71 ++++++++++++++++++++++++++---------------
 fs/ecryptfs/inode.c           |    4 +--
 3 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 867b64c..56e3aa5 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -568,6 +568,8 @@ struct ecryptfs_open_req {
 struct inode *ecryptfs_get_inode(struct inode *lower_inode,
 				 struct super_block *sb);
 void ecryptfs_i_size_init(const char *page_virt, struct inode *inode);
+int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry,
+			     struct inode *ecryptfs_inode);
 int ecryptfs_decode_and_decrypt_filename(char **decrypted_name,
 					 size_t *decrypted_name_size,
 					 struct dentry *ecryptfs_dentry,
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 49fc575..44ce5c6 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -140,6 +140,48 @@ out:
 
 struct kmem_cache *ecryptfs_file_info_cache;
 
+static int read_or_initialize_metadata(struct dentry *dentry)
+{
+	struct inode *inode = dentry->d_inode;
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+	struct ecryptfs_crypt_stat *crypt_stat;
+	int rc;
+
+	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
+	mount_crypt_stat = &ecryptfs_superblock_to_private(
+						inode->i_sb)->mount_crypt_stat;
+	mutex_lock(&crypt_stat->cs_mutex);
+
+	if (crypt_stat->flags & ECRYPTFS_POLICY_APPLIED &&
+	    crypt_stat->flags & ECRYPTFS_KEY_VALID) {
+		rc = 0;
+		goto out;
+	}
+
+	rc = ecryptfs_read_metadata(dentry);
+	if (!rc)
+		goto out;
+
+	if (mount_crypt_stat->flags & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED) {
+		crypt_stat->flags &= ~(ECRYPTFS_I_SIZE_INITIALIZED
+				       | ECRYPTFS_ENCRYPTED);
+		rc = 0;
+		goto out;
+	}
+
+	if (!(mount_crypt_stat->flags & ECRYPTFS_XATTR_METADATA_ENABLED) &&
+	    !i_size_read(ecryptfs_inode_to_lower(inode))) {
+		rc = ecryptfs_initialize_file(dentry, inode);
+		if (!rc)
+			goto out;
+	}
+
+	rc = -EIO;
+out:
+	mutex_unlock(&crypt_stat->cs_mutex);
+	return rc;
+}
+
 /**
  * ecryptfs_open
  * @inode: inode speciying file to open
@@ -215,32 +257,9 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		rc = 0;
 		goto out;
 	}
-	mutex_lock(&crypt_stat->cs_mutex);
-	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
-	    || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
-		rc = ecryptfs_read_metadata(ecryptfs_dentry);
-		if (rc) {
-			ecryptfs_printk(KERN_DEBUG,
-					"Valid headers not found\n");
-			if (!(mount_crypt_stat->flags
-			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
-				rc = -EIO;
-				printk(KERN_WARNING "Either the lower file "
-				       "is not in a valid eCryptfs format, "
-				       "or the key could not be retrieved. "
-				       "Plaintext passthrough mode is not "
-				       "enabled; returning -EIO\n");
-				mutex_unlock(&crypt_stat->cs_mutex);
-				goto out_put;
-			}
-			rc = 0;
-			crypt_stat->flags &= ~(ECRYPTFS_I_SIZE_INITIALIZED
-					       | ECRYPTFS_ENCRYPTED);
-			mutex_unlock(&crypt_stat->cs_mutex);
-			goto out;
-		}
-	}
-	mutex_unlock(&crypt_stat->cs_mutex);
+	rc = read_or_initialize_metadata(ecryptfs_dentry);
+	if (rc)
+		goto out_put;
 	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = "
 			"[0x%.16lx] size: [0x%.16llx]\n", inode, inode->i_ino,
 			(unsigned long long)i_size_read(inode));
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index b01c7a9..68166ea 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -200,8 +200,8 @@ out:
  *
  * Returns zero on success
  */
-static int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry,
-				    struct inode *ecryptfs_inode)
+int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry,
+			     struct inode *ecryptfs_inode)
 {
 	struct ecryptfs_crypt_stat *crypt_stat =
 		&ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
-- 
1.7.9.5

