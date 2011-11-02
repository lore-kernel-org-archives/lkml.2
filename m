Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1KBV1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:27:44 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51497 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab1KBV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:27:42 -0400
From: Thieu Le <thieule@chromium.org>
To: hch@infradead.org
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thieu Le <thieule@chromium.org>
Subject: [PATCH] vfs: Export fallocate facility to kernel modules
Date: Wed,  2 Nov 2011 14:27:05 -0700
Message-Id: <1320269225-18489-1-git-send-email-thieule@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20111102075328.GA28954@infradead.org>
References: <20111102075328.GA28954@infradead.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below illustrates the use of vfs_allocate() by ecryptfs.

---

eCryptfs does not allocate space in the lower file until writepage.  In
low free space situation, this leads to the application thinking the
write succeeds but it actually fails later when the page is written out.
This patch preallocates the space in the write path using fallocate()
first.  For lower file systems that do not support fallocate(), it falls back
to writing the encrypted page directly to the lower file.  The
preallocation is only done for writes that extend the file.

Signed-off-by: Thieu Le <thieule@chromium.org>
---
 fs/ecryptfs/mmap.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 6a44148..ed0eace 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -520,9 +520,29 @@ static int ecryptfs_write_end(struct file *file,
 		goto out;
 	}
 	set_page_dirty(page);
-	unlock_page(page);
-	need_unlock_page = 0;
 	if (pos + copied > i_size_read(ecryptfs_inode)) {
+		struct ecryptfs_inode_info *inode_info =
+			ecryptfs_inode_to_private(ecryptfs_inode);
+		loff_t offset = ecryptfs_lower_header_size(crypt_stat) + pos;
+		BUG_ON(!inode_info->lower_file);
+		rc = vfs_fallocate(inode_info->lower_file, 0, offset,
+				   PAGE_CACHE_SIZE);
+		if (rc == -EOPNOTSUPP)
+			rc = ecryptfs_encrypt_page(page);
+		if (rc) {
+			if (rc != -ENOSPC) {
+				ecryptfs_printk(KERN_ERR,
+						"Error preallocating page "
+						"(upper index "
+						"[0x%.16lx], rc = [%d])\n",
+						index, rc);
+			}
+			goto out;
+		}
+
+		unlock_page(page);
+		need_unlock_page = 0;
+
 		i_size_write(ecryptfs_inode, pos + copied);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
 			"[0x%.16llx]\n",
@@ -540,6 +560,8 @@ out:
 	if (need_unlock_page)
 		unlock_page(page);
 	page_cache_release(page);
+	if (rc)
+		truncate_inode_pages(mapping, i_size_read(ecryptfs_inode));
 	return rc;
 }
 
-- 
1.7.3.1

