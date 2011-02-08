Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1BHXVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:21:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60022 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1BHXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:21:18 -0500
From: Thieu Le <thieule@chromium.org>
To: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com
Cc: ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org,
        Thieu Le <thieule@chromium.org>
Subject: [PATCH] ecryptfs: modify write path to encrypt page in writepage
Date: Tue,  8 Feb 2011 15:20:12 -0800
Message-Id: <1297207213-31279-1-git-send-email-thieule@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the write path to encrypt the data only when the page is written to
disk in ecryptfs_writepage. Previously, ecryptfs encrypts the page in
ecryptfs_write_end which means that if there are multiple write requests to
the same page, ecryptfs ends up re-encrypting that page over and over again.
This patch minimizes the number of encryptions needed.

Signed-off-by: Thieu Le <thieule@chromium.org>
---
 fs/ecryptfs/ecryptfs_kernel.h |    1 -
 fs/ecryptfs/file.c            |    9 ++++++++-
 fs/ecryptfs/main.c            |    2 --
 fs/ecryptfs/mmap.c            |   20 ++++++++------------
 fs/ecryptfs/read_write.c      |   12 ++----------
 fs/ecryptfs/super.c           |    1 -
 6 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index dbc84ed..13517ac 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -297,7 +297,6 @@ struct ecryptfs_inode_info {
 	struct inode vfs_inode;
 	struct inode *wii_inode;
 	struct file *lower_file;
-	struct mutex lower_file_mutex;
 	struct ecryptfs_crypt_stat crypt_stat;
 };
 
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 81e10e6..9f7ce63 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -273,7 +273,14 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
 static int
 ecryptfs_fsync(struct file *file, int datasync)
 {
-	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
+	int rc = 0;
+
+	rc = generic_file_fsync(file, datasync);
+	if (rc)
+		goto out;
+	rc = vfs_fsync(ecryptfs_file_to_lower(file), datasync);
+out:
+	return rc;
 }
 
 static int ecryptfs_fasync(int fd, struct file *file, int flag)
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 758323a..63e412c 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -122,7 +122,6 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
 	int rc = 0;
 
-	mutex_lock(&inode_info->lower_file_mutex);
 	if (!inode_info->lower_file) {
 		struct dentry *lower_dentry;
 		struct vfsmount *lower_mnt =
@@ -138,7 +137,6 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 			inode_info->lower_file = NULL;
 		}
 	}
-	mutex_unlock(&inode_info->lower_file_mutex);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index cc64fca..c5676e6 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -512,24 +512,20 @@ static int ecryptfs_write_end(struct file *file,
 			"zeros in page with index = [0x%.16lx]\n", index);
 		goto out;
 	}
-	rc = ecryptfs_encrypt_page(page);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING, "Error encrypting page (upper "
-				"index [0x%.16lx])\n", index);
-		goto out;
-	}
+	set_page_dirty(page);
 	if (pos + copied > i_size_read(ecryptfs_inode)) {
 		i_size_write(ecryptfs_inode, pos + copied);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
 			"[0x%.16llx]\n",
 			(unsigned long long)i_size_read(ecryptfs_inode));
+		rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
+		if (rc) {
+			printk(KERN_ERR "Error writing inode size to metadata; "
+			       "rc = [%d]\n", rc);
+			goto out;
+		}
 	}
-	rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
-	if (rc)
-		printk(KERN_ERR "Error writing inode size to metadata; "
-		       "rc = [%d]\n", rc);
-	else
-		rc = copied;
+	rc = copied;
 out:
 	unlock_page(page);
 	page_cache_release(page);
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index db184ef..85d4309 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -44,15 +44,11 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 	ssize_t rc;
 
 	inode_info = ecryptfs_inode_to_private(ecryptfs_inode);
-	mutex_lock(&inode_info->lower_file_mutex);
 	BUG_ON(!inode_info->lower_file);
-	inode_info->lower_file->f_pos = offset;
 	fs_save = get_fs();
 	set_fs(get_ds());
-	rc = vfs_write(inode_info->lower_file, data, size,
-		       &inode_info->lower_file->f_pos);
+	rc = vfs_write(inode_info->lower_file, data, size, &offset);
 	set_fs(fs_save);
-	mutex_unlock(&inode_info->lower_file_mutex);
 	mark_inode_dirty_sync(ecryptfs_inode);
 	return rc;
 }
@@ -234,15 +230,11 @@ int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
 	mm_segment_t fs_save;
 	ssize_t rc;
 
-	mutex_lock(&inode_info->lower_file_mutex);
 	BUG_ON(!inode_info->lower_file);
-	inode_info->lower_file->f_pos = offset;
 	fs_save = get_fs();
 	set_fs(get_ds());
-	rc = vfs_read(inode_info->lower_file, data, size,
-		      &inode_info->lower_file->f_pos);
+	rc = vfs_read(inode_info->lower_file, data, size, &offset);
 	set_fs(fs_save);
-	mutex_unlock(&inode_info->lower_file_mutex);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 3042fe1..15c969e 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -55,7 +55,6 @@ static struct inode *ecryptfs_alloc_inode(struct super_block *sb)
 	if (unlikely(!inode_info))
 		goto out;
 	ecryptfs_init_crypt_stat(&inode_info->crypt_stat);
-	mutex_init(&inode_info->lower_file_mutex);
 	inode_info->lower_file = NULL;
 	inode = &inode_info->vfs_inode;
 out:
-- 
1.7.3.1

