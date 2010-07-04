Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab0GDFda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 01:33:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:46908 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0GDFd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 01:33:28 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: linux-nilfs@vger.kernel.org
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] nilfs2: remove BKL uses
Date: Sun,  4 Jul 2010 14:22:08 +0900
Message-Id: <1278220928-28121-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.6.2
X-Dispatcher: imput version 20070423(IM149)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sun, 04 Jul 2010 14:33:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nilfs has BKL uses in its put_super and remount functions, but none of
them are necessary, just came from earlier push downs.  This
eliminates the BKL uses from nilfs.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/ioctl.c |    1 -
 fs/nilfs2/super.c |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index f90a33d..0442ee3 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -22,7 +22,6 @@
 
 #include <linux/fs.h>
 #include <linux/wait.h>
-#include <linux/smp_lock.h>	/* lock_kernel(), unlock_kernel() */
 #include <linux/slab.h>
 #include <linux/capability.h>	/* capable() */
 #include <linux/uaccess.h>	/* copy_from_user(), copy_to_user() */
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index f2cfbba..29be735 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -45,7 +45,6 @@
 #include <linux/parser.h>
 #include <linux/random.h>
 #include <linux/crc32.h>
-#include <linux/smp_lock.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
 #include <linux/kobject.h>
@@ -357,8 +356,6 @@ static void nilfs_put_super(struct super_block *sb)
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct the_nilfs *nilfs = sbi->s_nilfs;
 
-	lock_kernel();
-
 	nilfs_detach_segment_constructor(sbi);
 
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -376,8 +373,6 @@ static void nilfs_put_super(struct super_block *sb)
 	sbi->s_super = NULL;
 	sb->s_fs_info = NULL;
 	nilfs_put_sbinfo(sbi);
-
-	unlock_kernel();
 }
 
 static int nilfs_sync_fs(struct super_block *sb, int wait)
@@ -913,8 +908,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	struct nilfs_mount_options old_opts;
 	int was_snapshot, err;
 
-	lock_kernel();
-
 	down_write(&nilfs->ns_super_sem);
 	old_sb_flags = sb->s_flags;
 	old_opts.mount_opt = sbi->s_mount_opt;
@@ -988,7 +981,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	}
  out:
 	up_write(&nilfs->ns_super_sem);
-	unlock_kernel();
 	return 0;
 
  restore_opts:
@@ -996,7 +988,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	sbi->s_mount_opt = old_opts.mount_opt;
 	sbi->s_snapshot_cno = old_opts.snapshot_cno;
 	up_write(&nilfs->ns_super_sem);
-	unlock_kernel();
 	return err;
 }
 
-- 
1.6.6.2

