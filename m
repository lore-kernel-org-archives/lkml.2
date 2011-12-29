Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab1L2EmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 23:42:25 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:61835 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab1L2EmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 23:42:23 -0500
Date: Thu, 29 Dec 2011 04:42:22 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH] squashfs: add missing block release on error condition
Message-ID: <4efbefae.oAXMu0PI4fqz/DTf%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

squashfs_read_metadata forgets to release the cache block if
an error has occurred.

Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
---
 fs/squashfs/cache.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index f744be9..ea6e798 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -332,17 +332,20 @@ int squashfs_read_metadata(struct super_block *sb, void *buffer,
 		u64 *block, int *offset, int length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int bytes, copied = length;
+	int bytes, res = length;
 	struct squashfs_cache_entry *entry;
 
 	TRACE("Entered squashfs_read_metadata [%llx:%x]\n", *block, *offset);
 
 	while (length) {
 		entry = squashfs_cache_get(sb, msblk->block_cache, *block, 0);
-		if (entry->error)
-			return entry->error;
-		else if (*offset >= entry->length)
-			return -EIO;
+		if (entry->error) {
+			res = entry->error;
+			goto error;
+		} else if (*offset >= entry->length) {
+			res = -EIO;
+			goto error;
+		}
 
 		bytes = squashfs_copy_data(buffer, entry, *offset, length);
 		if (buffer)
@@ -358,7 +361,11 @@ int squashfs_read_metadata(struct super_block *sb, void *buffer,
 		squashfs_cache_put(entry);
 	}
 
-	return copied;
+	return res;
+
+error:
+	squashfs_cache_put(entry);
+	return res;
 }
 
 
-- 
1.7.5.4

