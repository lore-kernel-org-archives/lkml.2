Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab1HVUu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:50:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:40453 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab1HVUtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,265,1312182000"; 
   d="scan'208";a="43951954"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        tytso@mit.edu
Subject: [PATCH 5/7] LSEEK: EXT4: Replace cut'n'pasted llseek code with generic_file_llseek_size
Date: Mon, 22 Aug 2011 13:49:10 -0700
Message-Id: <1314046152-2175-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
References: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This gives ext4 the benefits of unlocked llseek.

Cc: tytso@mit.edu
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/ext4/file.c |   47 +----------------------------------------------
 1 files changed, 1 insertions(+), 46 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index e4095e9..b9548f4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -224,53 +224,8 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
 	else
 		maxbytes = inode->i_sb->s_maxbytes;
-	mutex_lock(&inode->i_mutex);
-	switch (origin) {
-	case SEEK_END:
-		offset += inode->i_size;
-		break;
-	case SEEK_CUR:
-		if (offset == 0) {
-			mutex_unlock(&inode->i_mutex);
-			return file->f_pos;
-		}
-		offset += file->f_pos;
-		break;
-	case SEEK_DATA:
-		/*
-		 * In the generic case the entire file is data, so as long as
-		 * offset isn't at the end of the file then the offset is data.
-		 */
-		if (offset >= inode->i_size) {
-			mutex_unlock(&inode->i_mutex);
-			return -ENXIO;
-		}
-		break;
-	case SEEK_HOLE:
-		/*
-		 * There is a virtual hole at the end of the file, so as long as
-		 * offset isn't i_size or larger, return i_size.
-		 */
-		if (offset >= inode->i_size) {
-			mutex_unlock(&inode->i_mutex);
-			return -ENXIO;
-		}
-		offset = inode->i_size;
-		break;
-	}
-
-	if (offset < 0 || offset > maxbytes) {
-		mutex_unlock(&inode->i_mutex);
-		return -EINVAL;
-	}
-
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
-	}
-	mutex_unlock(&inode->i_mutex);
 
-	return offset;
+	return generic_file_llseek_size(file, offset, origin, maxbytes);
 }
 
 const struct file_operations ext4_file_operations = {
-- 
1.7.4.4

