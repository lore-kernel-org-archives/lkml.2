Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831Ab2AKRBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:01:41 -0500
Received: from mail.tpi.com ([70.99.223.143]:2854 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757811Ab2AKRBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:01:37 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-fsdevel@vger.kernel.org, tyler.hicks@canonical.com
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ecryptfs: Print inode on metadata error
Date: Wed, 11 Jan 2012 18:00:42 +0100
Message-Id: <1326301242-5817-3-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a lower file system file is corrupted, then ecryptfs prints
a generic and mostly useless log message when attempting to
read metadata. Print the inode associated with the file
so that a user can do something about it, e.g.,

find -inum INODE_NUM

Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: Tyler Hicks <tyler.hicks@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ecryptfs/crypto.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index ac063bd..affad0c 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1612,8 +1612,9 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 	rc = ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
 				 ecryptfs_inode);
 	if (rc < 0) {
-		printk(KERN_ERR "%s: Could not read %u bytes\n",
-			__func__, crypt_stat->extent_size);
+		printk(KERN_ERR "%s: Could not read %zu bytes, inode %lu\n",
+			__func__, crypt_stat->extent_size,
+			ecryptfs_inode->i_ino);
 		goto out;
 	}
 
@@ -1625,7 +1626,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file header region or xattr region\n");
+			       "file header region or xattr region, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 			goto out;
 		}
@@ -1634,7 +1636,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 						ECRYPTFS_DONT_VALIDATE_HEADER_SIZE);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
-			       "file xattr region either\n");
+			       "file xattr region either, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
 		if (crypt_stat->mount_crypt_stat->flags
@@ -1645,7 +1648,8 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 			       "crypto metadata only in the extended attribute "
 			       "region, but eCryptfs was mounted without "
 			       "xattr support enabled. eCryptfs will not treat "
-			       "this like an encrypted file.\n");
+			       "this like an encrypted file, inode %lu\n",
+				ecryptfs_inode->i_ino);
 			rc = -EINVAL;
 		}
 	}
-- 
1.7.8.3

