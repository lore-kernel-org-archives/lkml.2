Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab2J3EGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:06:02 -0400
Received: from [118.186.34.234] ([118.186.34.234]:55337 "EHLO kylinos.com.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2J3EF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:05:59 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 00:05:59 EDT
From: Li Wang <wangli@kylinos.com.cn>
To: Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>
Cc: <ecryptfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li Wang <wangli@kylinos.com.cn>,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Subject: [PATCH] eCryptfs: Avoid unnecessary disk read and data decryption during writing
Date: Tue, 30 Oct 2012 19:52:40 +0800
Message-Id: <1351597960-1503-1-git-send-email-wangli@kylinos.com.cn>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_write_begin grabs a page from page cache for writing.
If the page contains invalid data, or data older than the
counterpart on the disk, eCryptfs will read out the
corresponing data from the disk into the page, decrypt them,
then perform writing. However, for this page, if the length
of the data to be written into is equal to page size,
that means the whole page of data will be overwritten,
in which case, it does not matter whatever the data were before,
it is beneficial to perform writing directly rather than bothering
to read and decrypt first.

With this optimization, according to our test on a machine with
Intel Core 2 Duo processor, iozone 'write' operation on an existing
file with write size being multiple of page size will enjoy a steady
3x speedup.

Signed-off-by: Li Wang <wangli@kylinos.com.cn>
Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
---
 fs/ecryptfs/mmap.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index bd1d57f..564a1fa 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -338,7 +338,8 @@ static int ecryptfs_write_begin(struct file *file,
 			if (prev_page_end_size
 			    >= i_size_read(page->mapping->host)) {
 				zero_user(page, 0, PAGE_CACHE_SIZE);
-			} else {
+				SetPageUptodate(page);
+			} else if (len < PAGE_CACHE_SIZE) {
 				rc = ecryptfs_decrypt_page(page);
 				if (rc) {
 					printk(KERN_ERR "%s: Error decrypting "
@@ -348,8 +349,8 @@ static int ecryptfs_write_begin(struct file *file,
 					ClearPageUptodate(page);
 					goto out;
 				}
+				SetPageUptodate(page);
 			}
-			SetPageUptodate(page);
 		}
 	}
 	/* If creating a page or more of holes, zero them out via truncate.
@@ -499,6 +500,13 @@ static int ecryptfs_write_end(struct file *file,
 		}
 		goto out;
 	}
+	if (!PageUptodate(page)) {
+		if (copied < PAGE_CACHE_SIZE) {
+			rc = 0;
+			goto out;
+		}
+		SetPageUptodate(page);
+	}
 	/* Fills in zeros if 'to' goes beyond inode size */
 	rc = fill_zeros_to_end_of_page(page, to);
 	if (rc) {
-- 
1.7.6.5

