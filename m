Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0IPRqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:46:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab0IPRqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 12/12] BKL: Remove BKL from OCFS2
Date: Thu, 16 Sep 2010 19:46:25 +0200
Message-Id: <1284659185-8942-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jnn/9Z+rc2lENgNBnGnWVOuf4+yQEw4Cijt3PKOhSkn
 GjBNo+4VqY1dqcX2cuc/lN0MaUG75vpeP+IiHWeLMexRLQe38m
 6hufbaK5E3fCXsZHO+J0JpeiFI6EqKsfalyW/YHXcQ3qcmImKe
 ihVVgo8CrYaOgjAoOokRia/8M0zOI5Ynqbd6zcOq4E7loivxt1
 KROyvfX8Fk6+u+JKsFqDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL in ocfs2/dlmfs is used in put_super, fill_super and remount_fs
that are all three protected by the superblocks s_umount rw_semaphore.

The use in ocfs2_control_open is evidently unrelated and the function
is protected by ocfs2_control_lock.

Therefore it is safe to remove the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/dlmfs/dlmfs.c |    9 +--------
 fs/ocfs2/stack_user.c  |    3 ---
 fs/ocfs2/super.c       |   12 ------------
 3 files changed, 1 insertions(+), 23 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 667d7ce..c2903b8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -44,7 +44,6 @@
 #include <linux/string.h>
 #include <linux/backing-dev.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 
@@ -589,27 +588,21 @@ static int dlmfs_fill_super(struct super_block * sb,
 	struct inode * inode;
 	struct dentry * root;
 
-	lock_kernel();
-
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = DLMFS_MAGIC;
 	sb->s_op = &dlmfs_ops;
 	inode = dlmfs_get_root_inode(sb);
-	if (!inode) {
-		unlock_kernel();
+	if (!inode)
 		return -ENOMEM;
-	}
 
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_root = root;
-	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 2dc57bc..0e68f54 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -22,7 +22,6 @@
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/reboot.h>
 #include <asm/uaccess.h>
 
@@ -612,12 +611,10 @@ static int ocfs2_control_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	p->op_this_node = -1;
 
-	lock_kernel();
 	mutex_lock(&ocfs2_control_lock);
 	file->private_data = p;
 	list_add(&p->op_list, &ocfs2_control_private_list);
 	mutex_unlock(&ocfs2_control_lock);
-	unlock_kernel();
 
 	return 0;
 }
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index b7e4f2d..b7d7243 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -609,8 +609,6 @@ static int ocfs2_remount(struct super_block *sb, int *flags, char *data)
 	struct mount_options parsed_options;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 
-	lock_kernel();
-
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 1) ||
 	    !ocfs2_check_set_options(sb, &parsed_options)) {
 		ret = -EINVAL;
@@ -717,7 +715,6 @@ unlock_osb:
 							MS_POSIXACL : 0);
 	}
 out:
-	unlock_kernel();
 	return ret;
 }
 
@@ -1002,8 +999,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	char nodestr[8];
 	struct ocfs2_blockcheck_stats stats;
 
-	lock_kernel();
-
 	mlog_entry("%p, %p, %i", sb, data, silent);
 
 	if (!ocfs2_parse_options(sb, data, &parsed_options, 0)) {
@@ -1181,7 +1176,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 			atomic_set(&osb->vol_state, VOLUME_DISABLED);
 			wake_up(&osb->osb_mount_event);
 			mlog_exit(status);
-			unlock_kernel();
 			return status;
 		}
 	}
@@ -1196,7 +1190,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 	ocfs2_orphan_scan_start(osb);
 
 	mlog_exit(status);
-	unlock_kernel();
 	return status;
 
 read_super_error:
@@ -1212,7 +1205,6 @@ read_super_error:
 	}
 
 	mlog_exit(status);
-	unlock_kernel();
 	return status;
 }
 
@@ -1645,13 +1637,9 @@ static void ocfs2_put_super(struct super_block *sb)
 {
 	mlog_entry("(0x%p)\n", sb);
 
-	lock_kernel();
-
 	ocfs2_sync_blockdev(sb);
 	ocfs2_dismount_volume(sb, 0);
 
-	unlock_kernel();
-
 	mlog_exit_void();
 }
 
-- 
1.7.1

