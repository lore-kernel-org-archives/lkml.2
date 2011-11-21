Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab1KULLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:11:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43422 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756275Ab1KULLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:11:47 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 4/4] vfs: prevent remount read-only if pending removes
Date: Mon, 21 Nov 2011 12:11:33 +0100
Message-Id: <1321873893-4544-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If there are any inodes on the super block that have been unlinked
(i_nlink == 0) but have not yet been deleted then prevent the
remounting the super block read-only.

Reported-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/file_table.c    |   23 -----------------------
 fs/namespace.c     |    7 +++++++
 fs/super.c         |    4 ----
 include/linux/fs.h |    2 --
 4 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index c322794..20002e3 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -474,29 +474,6 @@ void file_sb_list_del(struct file *file)
 
 #endif
 
-int fs_may_remount_ro(struct super_block *sb)
-{
-	struct file *file;
-	/* Check that no files are currently opened for writing. */
-	lg_global_lock(files_lglock);
-	do_file_list_for_each_entry(sb, file) {
-		struct inode *inode = file->f_path.dentry->d_inode;
-
-		/* File with pending delete? */
-		if (inode->i_nlink == 0)
-			goto too_bad;
-
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
-			goto too_bad;
-	} while_file_list_for_each_entry;
-	lg_global_unlock(files_lglock);
-	return 1; /* Tis' cool bro. */
-too_bad:
-	lg_global_unlock(files_lglock);
-	return 0;
-}
-
 /**
  *	mark_files_ro - mark all files read-only
  *	@sb: superblock in question
diff --git a/fs/namespace.c b/fs/namespace.c
index f296790..62684d3 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -480,6 +480,10 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 	struct vfsmount *mnt;
 	int err = 0;
 
+	/* Racy optimization.  Recheck the counter under MNT_WRITE_HOLD */
+	if (atomic_long_read(&sb->s_remove_count))
+		return -EBUSY;
+
 	br_write_lock(vfsmount_lock);
 	list_for_each_entry(mnt, &sb->s_mounts, mnt_instance) {
 		if (!(mnt->mnt_flags & MNT_READONLY)) {
@@ -491,6 +495,9 @@ int sb_prepare_remount_readonly(struct super_block *sb)
 			}
 		}
 	}
+	if (!err && atomic_long_read(&sb->s_remove_count))
+		err = -EBUSY;
+
 	if (!err) {
 		sb->s_readonly_remount = 1;
 		smp_wmb();
diff --git a/fs/super.c b/fs/super.c
index 027e02d..e81baed 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -727,10 +727,6 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 			retval = sb_prepare_remount_readonly(sb);
 			if (retval)
 				return retval;
-
-			retval = -EBUSY;
-			if (!fs_may_remount_ro(sb))
-				goto cancel_readonly;
 		}
 	}
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f4636c3..963dd2a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2146,8 +2146,6 @@ extern const struct file_operations read_pipefifo_fops;
 extern const struct file_operations write_pipefifo_fops;
 extern const struct file_operations rdwr_pipefifo_fops;
 
-extern int fs_may_remount_ro(struct super_block *);
-
 #ifdef CONFIG_BLOCK
 /*
  * return READ, READA, or WRITE
-- 
1.7.7

