Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935349Ab1IOXHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:07:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:39227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935278Ab1IOXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,390,1312182000"; 
   d="scan'208";a="17625184"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/7] VFS: Make generic lseek lockless safe
Date: Thu, 15 Sep 2011 16:06:49 -0700
Message-Id: <1316128013-21980-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

- use f_lock to protect SEEK_CUR
- use i_size_read to safely read file sizes on 32bit

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/read_write.c    |   52 +++++++++++++++++++++++++++++++++++-----------------
 include/linux/fs.h |    3 ++-
 2 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 24f0001..8e8aab3 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -35,6 +35,21 @@ static inline int unsigned_offsets(struct file *file)
 	return file->f_mode & FMODE_UNSIGNED_OFFSET;
 }
 
+static loff_t lseek_execute(struct file *file, struct inode *inode, loff_t offset,
+			    loff_t maxsize)
+{
+	if (offset < 0 && !unsigned_offsets(file))
+		return -EINVAL;
+	if (offset > maxsize)
+		return -EINVAL;
+
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+	return offset;
+}
+
 /**
  * generic_file_llseek - generic llseek implementation for regular files
  * @file:	file structure to seek on
@@ -44,6 +59,12 @@ static inline int unsigned_offsets(struct file *file)
  * This is a generic implemenation of ->llseek useable for all normal local
  * filesystems.  It just updates the file offset to the value specified by
  * @offset and @origin under i_mutex.
+ *
+ * Synchronization:
+ * SEEK_SET is unsynchronized (but atomic on 64bit platforms)
+ * SEEK_CUR is synchronized against other SEEK_CURs, but not read/writes.
+ * read/writes behave like SEEK_SET against seeks.
+ * SEEK_END
  */
 loff_t
 generic_file_llseek(struct file *file, loff_t offset, int origin)
@@ -63,14 +84,22 @@ generic_file_llseek(struct file *file, loff_t offset, int origin)
 		 */
 		if (offset == 0)
 			return file->f_pos;
-		offset += file->f_pos;
-		break;
+		/*
+		 * f_lock protects against read/modify/write race with other
+		 * SEEK_CURs. Note that parallel writes and reads behave
+		 * like SEEK_SET.
+		 */
+		spin_lock(&file->f_lock);
+		offset = lseek_execute(file, inode, file->f_pos + offset, 
+				       inode->i_sb->s_maxbytes);
+		spin_unlock(&file->f_lock);
+		return offset;
 	case SEEK_DATA:
 		/*
 		 * In the generic case the entire file is data, so as long as
 		 * offset isn't at the end of the file then the offset is data.
 		 */
-		if (offset >= inode->i_size)
+		if (offset >= i_size_read(inode))
 			return -ENXIO;
 		break;
 	case SEEK_HOLE:
@@ -78,24 +107,13 @@ generic_file_llseek(struct file *file, loff_t offset, int origin)
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= inode->i_size)
+		if (offset >= i_size_read(inode))
 			return -ENXIO;
-		offset = inode->i_size;
+		offset = i_size_read(inode);
 		break;
 	}
 
-	if (offset < 0 && !unsigned_offsets(file))
-		return -EINVAL;
-	if (offset > inode->i_sb->s_maxbytes)
-		return -EINVAL;
-
-	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
-	}
-
-	return offset;
+	return lseek_execute(file, inode, offset, inode->i_sb->s_maxbytes);
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d9efdf7..fdcf2eb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -965,7 +965,8 @@ struct file {
 #define f_dentry	f_path.dentry
 #define f_vfsmnt	f_path.mnt
 	const struct file_operations	*f_op;
-	spinlock_t		f_lock;  /* f_ep_links, f_flags, no IRQ */
+	spinlock_t		f_lock;  /* f_ep_links, f_flags, no IRQ,
+					    SEEK_SET */
 #ifdef CONFIG_SMP
 	int			f_sb_list_cpu;
 #endif
-- 
1.7.4.4

