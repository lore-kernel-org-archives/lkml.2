Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab1FPVJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:09:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:28121 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744Ab1FPVJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:09:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="14470513"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] VFS: Use f_lock for SEEK_SET
Date: Thu, 16 Jun 2011 14:07:19 -0700
Message-Id: <1308258442-19804-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/read_write.c    |   44 ++++++++++++++++++++++++++++++--------------
 include/linux/fs.h |    3 ++-
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 9bd5d23..0b1d4ca 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -35,6 +35,20 @@ static inline int unsigned_offsets(struct file *file)
 	return file->f_mode & FMODE_UNSIGNED_OFFSET;
 }
 
+static loff_t lseek_execute(struct file *file, struct inode *inode, loff_t offset)
+{
+	if (offset < 0 && !unsigned_offsets(file))
+		return -EINVAL;
+	if (offset > inode->i_sb->s_maxbytes)
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
@@ -44,6 +58,12 @@ static inline int unsigned_offsets(struct file *file)
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
@@ -63,22 +83,18 @@ generic_file_llseek(struct file *file, loff_t offset, int origin)
 		 */
 		if (offset == 0)
 			return file->f_pos;
-		offset += file->f_pos;
-		break;
-	}
-
-	if (offset < 0 && !unsigned_offsets(file))
-		return -EINVAL;
-	if (offset > inode->i_sb->s_maxbytes)
-		return -EINVAL;
-
-	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
+		/* 
+		 * f_lock protects against read/modify/write race with other
+		 * SEEK_CURs. Note that parallel writes and reads behave
+		 * like SEEK_SET.
+		 */
+		spin_lock(&file->f_lock);
+		offset = lseek_execute(file, inode, offset + file->f_pos);
+		spin_unlock(&file->f_lock);
+		return offset;
 	}
 
-	return offset;
+	return lseek_execute(file, inode, offset);
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index deec2cd..a19d164 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -946,7 +946,8 @@ struct file {
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

