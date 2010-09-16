Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0IPRrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:47:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab0IPRqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: [PATCH 11/12] BKL: Remove BKL from squashfs
Date: Thu, 16 Sep 2010 19:46:24 +0200
Message-Id: <1284659185-8942-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5AE8D2Zz4QpG/gk1EEY+/SJ25Mjnfo+EWGSccMbyU48
 ZpEWUB69B4t787qCWw8cW50IzCl6VjTbUR/7gSOyxbMVnlcjo7
 VKT6Oxjc5Ab61VGHeC9+lkHSw6yhlyfFEiYy5I8ISZV3B6RP0r
 4bI+85q747SYlJPOXWuBj6q+LZyuiTmDp9SmSIqD2erBk9fTHY
 NWZJ/uUoDcupIH9u6Q+CA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super and fill_super, which are both protected
by the superblocks s_umount rw_semaphore. Therefore it is safe to remove
the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/super.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index ab1a401..07a4f11 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -30,7 +30,6 @@
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -87,14 +86,11 @@ static int squashfs_fill_super(struct super_block *sb, void *data, int silent)
 	u64 lookup_table_start, xattr_id_table_start;
 	int err;
 
-	lock_kernel();
-
 	TRACE("Entered squashfs_fill_superblock\n");
 
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	msblk = sb->s_fs_info;
@@ -304,7 +300,6 @@ allocate_root:
 
 	TRACE("Leaving squashfs_fill_super\n");
 	kfree(sblk);
-	unlock_kernel();
 	return 0;
 
 failed_mount:
@@ -319,13 +314,11 @@ failed_mount:
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 	kfree(sblk);
-	unlock_kernel();
 	return err;
 
 failure:
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
-	unlock_kernel();
 	return -ENOMEM;
 }
 
@@ -360,8 +353,6 @@ static int squashfs_remount(struct super_block *sb, int *flags, char *data)
 
 static void squashfs_put_super(struct super_block *sb)
 {
-	lock_kernel();
-
 	if (sb->s_fs_info) {
 		struct squashfs_sb_info *sbi = sb->s_fs_info;
 		squashfs_cache_delete(sbi->block_cache);
@@ -376,8 +367,6 @@ static void squashfs_put_super(struct super_block *sb)
 		kfree(sb->s_fs_info);
 		sb->s_fs_info = NULL;
 	}
-
-	unlock_kernel();
 }
 
 
-- 
1.7.1

