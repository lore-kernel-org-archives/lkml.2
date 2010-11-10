Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0KJXqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:46:33 -0500
Received: from mail.perches.com ([173.55.12.10]:4951 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532Ab0KJXq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:28 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>,
        Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net
Subject: [PATCH 4/6] fs/ecryptfs:  Add printf format/argument verification and fix fallout
Date: Wed, 10 Nov 2010 15:46:16 -0800
Message-Id: <6a5c98af6411ff3e10973fde991fb42e34121e98.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format... to __ecryptfs_printk
Make formats and arguments match.
Add casts to (unsigned long long) for %llu.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ecryptfs/crypto.c          |   20 ++++++++++++--------
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 fs/ecryptfs/file.c            |    6 +++---
 fs/ecryptfs/keystore.c        |    7 ++++---
 fs/ecryptfs/main.c            |    7 ++++---
 fs/ecryptfs/mmap.c            |   13 +++++++------
 6 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index cbadc1b..523bcb0 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -414,8 +414,9 @@ static int ecryptfs_encrypt_extent(struct page *enc_extent_page,
 				(extent_base + extent_offset));
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to "
-				"derive IV for extent [0x%.16x]; "
-				"rc = [%d]\n", (extent_base + extent_offset),
+				"derive IV for extent [0x%.16llx]; "
+				"rc = [%d]\n",
+				(unsigned long long)(extent_base + extent_offset),
 				rc);
 		goto out;
 	}
@@ -443,8 +444,9 @@ static int ecryptfs_encrypt_extent(struct page *enc_extent_page,
 	}
 	rc = 0;
 	if (unlikely(ecryptfs_verbosity > 0)) {
-		ecryptfs_printk(KERN_DEBUG, "Encrypt extent [0x%.16x]; "
-				"rc = [%d]\n", (extent_base + extent_offset),
+		ecryptfs_printk(KERN_DEBUG, "Encrypt extent [0x%.16llx]; "
+				"rc = [%d]\n",
+				(unsigned long long)(extent_base + extent_offset),
 				rc);
 		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
 				"encryption:\n");
@@ -541,8 +543,9 @@ static int ecryptfs_decrypt_extent(struct page *page,
 				(extent_base + extent_offset));
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error attempting to "
-				"derive IV for extent [0x%.16x]; "
-				"rc = [%d]\n", (extent_base + extent_offset),
+				"derive IV for extent [0x%.16llx]; "
+				"rc = [%d]\n",
+				(unsigned long long)(extent_base + extent_offset),
 				rc);
 		goto out;
 	}
@@ -571,8 +574,9 @@ static int ecryptfs_decrypt_extent(struct page *page,
 	}
 	rc = 0;
 	if (unlikely(ecryptfs_verbosity > 0)) {
-		ecryptfs_printk(KERN_DEBUG, "Decrypt extent [0x%.16x]; "
-				"rc = [%d]\n", (extent_base + extent_offset),
+		ecryptfs_printk(KERN_DEBUG, "Decrypt extent [0x%.16llx]; "
+				"rc = [%d]\n",
+				(unsigned long long)(extent_base + extent_offset),
 				rc);
 		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
 				"decryption:\n");
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 413a3c4..86c7101 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -584,6 +584,7 @@ ecryptfs_set_dentry_lower_mnt(struct dentry *dentry, struct vfsmount *lower_mnt)
 
 #define ecryptfs_printk(type, fmt, arg...) \
         __ecryptfs_printk(type "%s: " fmt, __func__, ## arg);
+__attribute__ ((format(printf, 1, 2)))
 void __ecryptfs_printk(const char *fmt, ...);
 
 extern const struct file_operations ecryptfs_main_fops;
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 91da029..d445672 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -243,9 +243,9 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		}
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = [0x%.16x] "
-			"size: [0x%.16x]\n", inode, inode->i_ino,
-			i_size_read(inode));
+	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = [0x%.16lx] "
+			"size: [0x%.16llx]\n", inode, inode->i_ino,
+			(unsigned long long)i_size_read(inode));
 	goto out;
 out_free:
 	kmem_cache_free(ecryptfs_file_info_cache,
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index b1f6858..e73f24c 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -59,7 +59,7 @@ static int process_request_key_err(long err_code)
 		break;
 	default:
 		ecryptfs_printk(KERN_WARNING, "Unknown error code: "
-				"[0x%.16x]\n", err_code);
+				"[0x%.16lx]\n", err_code);
 		rc = -EINVAL;
 	}
 	return rc;
@@ -1864,8 +1864,9 @@ found_matching_auth_tok:
 				"session key for authentication token with sig "
 				"[%.*s]; rc = [%d]. Removing auth tok "
 				"candidate from the list and searching for "
-				"the next match.\n", candidate_auth_tok_sig,
-				ECRYPTFS_SIG_SIZE_HEX, rc);
+				"the next myouatch.\n",
+				ECRYPTFS_SIG_SIZE_HEX, candidate_auth_tok_sig,
+				rc);
 		list_for_each_entry_safe(auth_tok_list_item,
 					 auth_tok_list_item_tmp,
 					 &auth_tok_list, list) {
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index a9dbd62..cfe636d 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -828,9 +828,10 @@ static int __init ecryptfs_init(void)
 		ecryptfs_printk(KERN_ERR, "The eCryptfs extent size is "
 				"larger than the host's page size, and so "
 				"eCryptfs cannot run on this system. The "
-				"default eCryptfs extent size is [%d] bytes; "
-				"the page size is [%d] bytes.\n",
-				ECRYPTFS_DEFAULT_EXTENT_SIZE, PAGE_CACHE_SIZE);
+				"default eCryptfs extent size is [%u] bytes; "
+				"the page size is [%lu] bytes.\n",
+				ECRYPTFS_DEFAULT_EXTENT_SIZE,
+				(unsigned long)PAGE_CACHE_SIZE);
 		goto out;
 	}
 	rc = ecryptfs_init_kmem_caches();
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index b1d8275..667fc79 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -65,7 +65,7 @@ static int ecryptfs_writepage(struct page *page, struct writeback_control *wbc)
 	rc = ecryptfs_encrypt_page(page);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error encrypting "
-				"page (upper index [0x%.16x])\n", page->index);
+				"page (upper index [0x%.16lx])\n", page->index);
 		ClearPageUptodate(page);
 		goto out;
 	}
@@ -237,7 +237,7 @@ out:
 		ClearPageUptodate(page);
 	else
 		SetPageUptodate(page);
-	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
+	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16lx]\n",
 			page->index);
 	unlock_page(page);
 	return rc;
@@ -488,7 +488,7 @@ static int ecryptfs_write_end(struct file *file,
 	} else
 		ecryptfs_printk(KERN_DEBUG, "Not a new file\n");
 	ecryptfs_printk(KERN_DEBUG, "Calling fill_zeros_to_end_of_page"
-			"(page w/ index = [0x%.16x], to = [%d])\n", index, to);
+			"(page w/ index = [0x%.16lx], to = [%d])\n", index, to);
 	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
 		rc = ecryptfs_write_lower_page_segment(ecryptfs_inode, page, 0,
 						       to);
@@ -503,19 +503,20 @@ static int ecryptfs_write_end(struct file *file,
 	rc = fill_zeros_to_end_of_page(page, to);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error attempting to fill "
-			"zeros in page with index = [0x%.16x]\n", index);
+			"zeros in page with index = [0x%.16lx]\n", index);
 		goto out;
 	}
 	rc = ecryptfs_encrypt_page(page);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error encrypting page (upper "
-				"index [0x%.16x])\n", index);
+				"index [0x%.16lx])\n", index);
 		goto out;
 	}
 	if (pos + copied > i_size_read(ecryptfs_inode)) {
 		i_size_write(ecryptfs_inode, pos + copied);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
-				"[0x%.16x]\n", i_size_read(ecryptfs_inode));
+				"[0x%.16llx]\n",
+				(unsigned long long)i_size_read(ecryptfs_inode));
 	}
 	rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
 	if (rc)
-- 
1.7.3.1.g432b3.dirty

