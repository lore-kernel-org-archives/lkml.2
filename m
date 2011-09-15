Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348Ab1IOXIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:08:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:39227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935289Ab1IOXHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:07:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="49349831"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/7] VFS: Do (nearly) lockless generic_file_llseek
Date: Thu, 15 Sep 2011 16:06:48 -0700
Message-Id: <1316128013-21980-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The i_mutex lock use of generic _file_llseek hurts.  Independent processes
accessing the same file synchronize over a single lock, even though
they have no need for synchronization at all.

Under high utilization this can cause llseek to scale very poorly on larger
systems.

This patch does some rethinking of the llseek locking model:

First the 64bit f_pos is not necessarily atomic without locks
on 32bit systems. This can already cause races with read() today.
This was discussed on linux-kernel in the past and deemed acceptable.
The patch does not change that.

Let's look at the different seek variants:

SEEK_SET: Doesn't really need any locking.
If there's a race one writer wins, the other loses.

For 32bit the non atomic update races against read()
stay the same. Without a lock they can also happen
against write() now.  The read() race was deemed
acceptable in past discussions, and I think if it's
ok for read it's ok for write too.

=> Don't need a lock.

SEEK_END: This behaves like SEEK_SET plus it reads
the maximum size too. Reading the maximum size would have the
32bit atomic problem. But luckily we already have a way to read
the maximum size without locking (i_size_read), so we
can just use that instead.

Without i_mutex there is no synchronization with write() anymore,
however since the write() update is atomic on 64bit it just behaves
like another racy SEEK_SET.  On non atomic 32bit it's the same
as SEEK_SET.

=> Don't need a lock, but need to use i_size_read()

SEEK_CUR: This has a read-modify-write race window
on the same file. One could argue that any application
doing unsynchronized seeks on the same file is already broken.
But for the sake of not adding a regression here I'm
using the file->f_lock to synchronize this. Using this
lock is much better than the inode mutex because it doesn't
synchronize between processes.

=> So still need a lock, but can use a cheap local one.

This patch implements this new scheme in generic_file_llseek.
I dropped generic_file_llseek_unlocked and changed all callers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/btrfs/file.c    |    2 +-
 fs/cifs/cifsfs.c   |    2 +-
 fs/gfs2/file.c     |    4 ++--
 fs/nfs/file.c      |    5 +++--
 fs/read_write.c    |   33 ++++++---------------------------
 include/linux/fs.h |    2 --
 6 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7ec0a24..62f56d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1813,7 +1813,7 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 	switch (origin) {
 	case SEEK_END:
 	case SEEK_CUR:
-		offset = generic_file_llseek_unlocked(file, offset, origin);
+		offset = generic_file_llseek(file, offset, origin);
 		goto out;
 	case SEEK_DATA:
 	case SEEK_HOLE:
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f93eb94..e43641b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -721,7 +721,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 		if (rc < 0)
 			return (loff_t)rc;
 	}
-	return generic_file_llseek_unlocked(file, offset, origin);
+	return generic_file_llseek(file, offset, origin);
 }
 
 static int cifs_setlease(struct file *file, long arg, struct file_lock **lease)
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index edeb9e8..fe6bc02 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -63,11 +63,11 @@ static loff_t gfs2_llseek(struct file *file, loff_t offset, int origin)
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (!error) {
-			error = generic_file_llseek_unlocked(file, offset, origin);
+			error = generic_file_llseek(file, offset, origin);
 			gfs2_glock_dq_uninit(&i_gh);
 		}
 	} else
-		error = generic_file_llseek_unlocked(file, offset, origin);
+		error = generic_file_llseek(file, offset, origin);
 
 	return error;
 }
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 28b8c3f..12623ab 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -198,11 +198,12 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
 		if (retval < 0)
 			return (loff_t)retval;
 
+		/* AK: should drop this lock. Unlikely to be needed. */
 		spin_lock(&inode->i_lock);
-		loff = generic_file_llseek_unlocked(filp, offset, origin);
+		loff = generic_file_llseek(filp, offset, origin);
 		spin_unlock(&inode->i_lock);
 	} else
-		loff = generic_file_llseek_unlocked(filp, offset, origin);
+		loff = generic_file_llseek(filp, offset, origin);
 	return loff;
 }
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 179f1c3..24f0001 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -36,22 +36,23 @@ static inline int unsigned_offsets(struct file *file)
 }
 
 /**
- * generic_file_llseek_unlocked - lockless generic llseek implementation
+ * generic_file_llseek - generic llseek implementation for regular files
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
  * @origin:	type of seek
  *
- * Updates the file offset to the value specified by @offset and @origin.
- * Locking must be provided by the caller.
+ * This is a generic implemenation of ->llseek useable for all normal local
+ * filesystems.  It just updates the file offset to the value specified by
+ * @offset and @origin under i_mutex.
  */
 loff_t
-generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
+generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 
 	switch (origin) {
 	case SEEK_END:
-		offset += inode->i_size;
+		offset += i_size_read(inode);
 		break;
 	case SEEK_CUR:
 		/*
@@ -96,28 +97,6 @@ generic_file_llseek_unlocked(struct file *file, loff_t offset, int origin)
 
 	return offset;
 }
-EXPORT_SYMBOL(generic_file_llseek_unlocked);
-
-/**
- * generic_file_llseek - generic llseek implementation for regular files
- * @file:	file structure to seek on
- * @offset:	file offset to seek to
- * @origin:	type of seek
- *
- * This is a generic implemenation of ->llseek useable for all normal local
- * filesystems.  It just updates the file offset to the value specified by
- * @offset and @origin under i_mutex.
- */
-loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t rval;
-
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
-	rval = generic_file_llseek_unlocked(file, offset, origin);
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
-
-	return rval;
-}
 EXPORT_SYMBOL(generic_file_llseek);
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c2bd68f..d9efdf7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2399,8 +2399,6 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping);
 extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
-extern loff_t generic_file_llseek_unlocked(struct file *file, loff_t offset,
-			int origin);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
-- 
1.7.4.4

