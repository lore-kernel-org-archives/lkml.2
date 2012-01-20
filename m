Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2ATWfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 17:35:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33962 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2ATWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 17:35:47 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        john.johansen@canonical.com, dustin.kirkland@gazzang.com,
        Cong Wang <xiyou.wangcong@gmail.com>, Li Wang <liwang@nudt.edu.cn>
Subject: [PATCH 1/3] eCryptfs: Make truncate path killable
Date: Fri, 20 Jan 2012 16:35:05 -0600
Message-Id: <1327098907-28963-2-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
References: <1327098907-28963-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ecryptfs_write() handles the truncation of eCryptfs inodes. It grabs a
page, zeroes out the appropriate portions, and then encrypts the page
before writing it to the lower filesystem. It was unkillable and due to
the lack of sparse file support could result in tying up a large portion
of system resources, while encrypting pages of zeros, with no way for
the truncate operation to be stopped from userspace.

This patch adds the ability for ecryptfs_write() to detect a pending
fatal signal and return as gracefully as possible. The intent is to
leave the lower file in a useable state, while still allowing a user to
break out of the encryption loop. If a pending fatal signal is detected,
the eCryptfs inode size is updated to reflect the modified inode size
and then -EINTR is returned.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Cc: <stable@vger.kernel.org>
---
 fs/ecryptfs/read_write.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index ec3d936..608c1c3 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -132,6 +132,11 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char *data, loff_t offset,
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
 		loff_t total_remaining_bytes = ((offset + size) - pos);
 
+		if (fatal_signal_pending(current)) {
+			rc = -EINTR;
+			break;
+		}
+
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
@@ -193,15 +198,19 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char *data, loff_t offset,
 		}
 		pos += num_bytes;
 	}
-	if ((offset + size) > ecryptfs_file_size) {
-		i_size_write(ecryptfs_inode, (offset + size));
+	if (pos > ecryptfs_file_size) {
+		i_size_write(ecryptfs_inode, pos);
 		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED) {
-			rc = ecryptfs_write_inode_size_to_metadata(
+			int rc2;
+
+			rc2 = ecryptfs_write_inode_size_to_metadata(
 								ecryptfs_inode);
-			if (rc) {
+			if (rc2) {
 				printk(KERN_ERR	"Problem with "
 				       "ecryptfs_write_inode_size_to_metadata; "
-				       "rc = [%d]\n", rc);
+				       "rc = [%d]\n", rc2);
+				if (!rc)
+					rc = rc2;
 				goto out;
 			}
 		}
-- 
1.7.8.3

