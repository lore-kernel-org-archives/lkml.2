Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1HVUtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:49:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:59134 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab1HVUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:49:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,265,1312182000"; 
   d="scan'208";a="9888061"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/7] VFS: Add generic_file_llseek_size
Date: Mon, 22 Aug 2011 13:49:09 -0700
Message-Id: <1314046152-2175-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
References: <1314046152-2175-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a generic_file_llseek variant to the VFS that allows passing in
the current file size, instead of always using inode->i_size.
This can be used to eliminate some cut'n'paste seek code in ext4.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/read_write.c    |   34 +++++++++++++++++++++++++++-------
 include/linux/fs.h |    2 ++
 2 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 8e8aab3..3d55cc6 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -51,14 +51,14 @@ static loff_t lseek_execute(struct file *file, struct inode *inode, loff_t offse
 }
 
 /**
- * generic_file_llseek - generic llseek implementation for regular files
+ * generic_file_llseek_size - generic llseek implementation for regular files
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
  * @origin:	type of seek
+ * @size:       max size of file system
  *
- * This is a generic implemenation of ->llseek useable for all normal local
- * filesystems.  It just updates the file offset to the value specified by
- * @offset and @origin under i_mutex.
+ * Variant of generic_file_llseek that allows passing in a custom
+ * file size.
  *
  * Synchronization:
  * SEEK_SET is unsynchronized (but atomic on 64bit platforms)
@@ -67,7 +67,8 @@ static loff_t lseek_execute(struct file *file, struct inode *inode, loff_t offse
  * SEEK_END
  */
 loff_t
-generic_file_llseek(struct file *file, loff_t offset, int origin)
+generic_file_llseek_size(struct file *file, loff_t offset, int origin, 
+                         loff_t maxsize)
 {
 	struct inode *inode = file->f_mapping->host;
 
@@ -91,7 +92,7 @@ generic_file_llseek(struct file *file, loff_t offset, int origin)
 		 */
 		spin_lock(&file->f_lock);
 		offset = lseek_execute(file, inode, file->f_pos + offset, 
-				       inode->i_sb->s_maxbytes);
+				       maxsize);
 		spin_unlock(&file->f_lock);
 		return offset;
 	case SEEK_DATA:
@@ -113,7 +114,26 @@ generic_file_llseek(struct file *file, loff_t offset, int origin)
 		break;
 	}
 
-	return lseek_execute(file, inode, offset, inode->i_sb->s_maxbytes);
+	return lseek_execute(file, inode, offset, maxsize);
+}
+EXPORT_SYMBOL(generic_file_llseek_size);
+
+/**
+ * generic_file_llseek - generic llseek implementation for regular files
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @origin:	type of seek
+ *
+ * This is a generic implemenation of ->llseek useable for all normal local
+ * filesystems.  It just updates the file offset to the value specified by
+ * @offset and @origin under i_mutex.
+ */
+loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	return generic_file_llseek_size(file, offset, origin, 
+					inode->i_sb->s_maxbytes);
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3417259..d64b601 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2395,6 +2395,8 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
+extern loff_t generic_file_llseek_size(struct file *file, loff_t offset, int origin,
+				       loff_t size);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
-- 
1.7.4.4

