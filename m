Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab2AKRBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:01:33 -0500
Received: from mail.tpi.com ([70.99.223.143]:2853 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757743Ab2AKRBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:01:31 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-fsdevel@vger.kernel.org, tyler.hicks@canonical.com
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] ecryptfs: Improve metatdata read failure logging
Date: Wed, 11 Jan 2012 18:00:41 +0100
Message-Id: <1326301242-5817-2-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
References: <1326301242-5817-1-git-send-email-tim.gardner@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 read failure cases in ecryptfs_read_metadata(), but only 2
of them are uniquely noted by kernel log messages. This patch
identifies and logs each read failure case. It also correctly interprets
a negative return value from ecryptfs_read_lower().

Removes unnecessary variable initialization.

Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: Tyler Hicks <tyler.hicks@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/ecryptfs/crypto.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index d3c8776..ac063bd 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1590,8 +1590,8 @@ int ecryptfs_read_and_validate_xattr_region(struct dentry *dentry,
  */
 int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 {
-	int rc = 0;
-	char *page_virt = NULL;
+	int rc;
+	char *page_virt;
 	struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
 	struct ecryptfs_crypt_stat *crypt_stat =
 	    &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
@@ -1611,10 +1611,15 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 	}
 	rc = ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
 				 ecryptfs_inode);
-	if (rc >= 0)
-		rc = ecryptfs_read_headers_virt(page_virt, crypt_stat,
-						ecryptfs_dentry,
-						ECRYPTFS_VALIDATE_HEADER_SIZE);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: Could not read %u bytes\n",
+			__func__, crypt_stat->extent_size);
+		goto out;
+	}
+
+	rc = ecryptfs_read_headers_virt(page_virt, crypt_stat,
+					ecryptfs_dentry,
+					ECRYPTFS_VALIDATE_HEADER_SIZE);
 	if (rc) {
 		memset(page_virt, 0, PAGE_CACHE_SIZE);
 		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
-- 
1.7.8.3

