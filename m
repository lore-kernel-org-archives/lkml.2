Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab1FPVJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:09:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:20285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701Ab1FPVIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:08:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="17215408"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        tytso@mit.edu
Subject: [PATCH 4/5] EXT4: Replace cut'n'pasted llseek code with generic_file_llseek_size
Date: Thu, 16 Jun 2011 14:07:21 -0700
Message-Id: <1308258442-19804-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This gives ext4 the benefits of unlocked llseek.

Cc: tytso@mit.edu
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/ext4/file.c |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2c09723..ce40447 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -224,32 +224,8 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
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

