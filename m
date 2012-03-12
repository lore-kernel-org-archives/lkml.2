Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2CLAti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:49:38 -0400
Received: from 1wt.eu ([62.212.114.60]:63052 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab2CLAsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:22 -0400
Message-Id: <20120312002046.161770900@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:50 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: <stable@kernel.org>, Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Tyler Hicks <tyler.hicks@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 05/12] eCryptfs: Handle failed metadata read in lookup
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

When failing to read the lower file's crypto metadata during a lookup,
eCryptfs must continue on without throwing an error. For example, there
may be a plaintext file in the lower mount point that the user wants to
delete through the eCryptfs mount.

If an error is encountered while reading the metadata in lookup(), the
eCryptfs inode's size could be incorrect. We must be sure to reread the
plaintext inode size from the metadata when performing an open() or
setattr(). The metadata is already being read in those paths, so this
adds minimal performance overhead.

This patch introduces a flag which will track whether or not the
plaintext inode size has been read so that an incorrect i_size can be
fixed in the open() or setattr() paths.

BugLink: http://bugs.launchpad.net/bugs/509180
https://lists.ubuntu.com/archives/kernel-team/2012-March/019137.html

Cc: <stable@kernel.org>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

(backported from 3aeb86ea4cd15f728147a3bd5469a205ada8c767)
Cc: Tyler Hicks <tyler.hicks@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ecryptfs/crypto.c          |   21 +++++++++++++++++++++
 fs/ecryptfs/ecryptfs_kernel.h |    2 ++
 fs/ecryptfs/file.c            |    3 ++-
 fs/ecryptfs/inode.c           |   18 +++---------------
 4 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 7a5f1ac..7e164bb 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1455,6 +1455,25 @@ static void set_default_header_data(struct ecryptfs_crypt_stat *crypt_stat)
 		ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE;
 }
 
+void ecryptfs_i_size_init(const char *page_virt, struct inode *inode)
+{
+	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
+	struct ecryptfs_crypt_stat *crypt_stat;
+	u64 file_size;
+
+	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
+	mount_crypt_stat =
+		&ecryptfs_superblock_to_private(inode->i_sb)->mount_crypt_stat;
+	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED) {
+		file_size = i_size_read(ecryptfs_inode_to_lower(inode));
+		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
+			file_size += crypt_stat->num_header_bytes_at_front;
+	} else
+		file_size = get_unaligned_be64(page_virt);
+	i_size_write(inode, (loff_t)file_size);
+	crypt_stat->flags |= ECRYPTFS_I_SIZE_INITIALIZED;
+}
+
 /**
  * ecryptfs_read_headers_virt
  * @page_virt: The virtual address into which to read the headers
@@ -1485,6 +1504,8 @@ static int ecryptfs_read_headers_virt(char *page_virt,
 		rc = -EINVAL;
 		goto out;
 	}
+	if (!(crypt_stat->flags & ECRYPTFS_I_SIZE_INITIALIZED))
+		ecryptfs_i_size_init(page_virt, ecryptfs_dentry->d_inode);
 	offset += MAGIC_ECRYPTFS_MARKER_SIZE_BYTES;
 	rc = ecryptfs_process_flags(crypt_stat, (page_virt + offset),
 				    &bytes_read);
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 542f625..9685315 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -270,6 +270,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_ENCFN_USE_MOUNT_FNEK 0x00001000
 #define ECRYPTFS_ENCFN_USE_FEK        0x00002000
 #define ECRYPTFS_UNLINK_SIGS	      0x00004000
+#define ECRYPTFS_I_SIZE_INITIALIZED   0x00008000
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -619,6 +620,7 @@ struct ecryptfs_open_req {
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
 		       u32 flags);
+void ecryptfs_i_size_init(const char *page_virt, struct inode *inode);
 int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
 					struct dentry *lower_dentry,
 					struct inode *ecryptfs_dir_inode,
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 3015389..502b09f 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -237,7 +237,8 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 				goto out_free;
 			}
 			rc = 0;
-			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+			crypt_stat->flags &= ~(ECRYPTFS_I_SIZE_INITIALIZED
+						| ECRYPTFS_ENCRYPTED);
 			mutex_unlock(&crypt_stat->cs_mutex);
 			goto out;
 		}
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 4434e8f..90a6087 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -256,10 +256,8 @@ int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
 	struct dentry *lower_dir_dentry;
 	struct vfsmount *lower_mnt;
 	struct inode *lower_inode;
-	struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
 	struct ecryptfs_crypt_stat *crypt_stat;
 	char *page_virt = NULL;
-	u64 file_size;
 	int rc = 0;
 
 	lower_dir_dentry = lower_dentry->d_parent;
@@ -334,18 +332,7 @@ int ecryptfs_lookup_and_interpose_lower(struct dentry *ecryptfs_dentry,
 		}
 		crypt_stat->flags |= ECRYPTFS_METADATA_IN_XATTR;
 	}
-	mount_crypt_stat = &ecryptfs_superblock_to_private(
-		ecryptfs_dentry->d_sb)->mount_crypt_stat;
-	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED) {
-		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
-			file_size = (crypt_stat->num_header_bytes_at_front
-				     + i_size_read(lower_dentry->d_inode));
-		else
-			file_size = i_size_read(lower_dentry->d_inode);
-	} else {
-		file_size = get_unaligned_be64(page_virt);
-	}
-	i_size_write(ecryptfs_dentry->d_inode, (loff_t)file_size);
+	ecryptfs_i_size_init(page_virt, ecryptfs_dentry->d_inode);
 out_free_kmem:
 	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
 	goto out;
@@ -964,7 +951,8 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 				goto out;
 			}
 			rc = 0;
-			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+			crypt_stat->flags &= ~(ECRYPTFS_I_SIZE_INITIALIZED
+						| ECRYPTFS_ENCRYPTED);
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-- 
1.7.2.1.45.g54fbc



