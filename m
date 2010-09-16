Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0IPRsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:48:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab0IPRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jan Blunck <jblunck@infradead.org>
Subject: [PATCH 02/12] BKL: Remove BKL from fat
Date: Thu, 16 Sep 2010 19:46:15 +0200
Message-Id: <1284659185-8942-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:G8ccpZa9vPnD3ZdffJDgb4CvsQELfS1j7FqHMiFxgME
 aMdMt3zFcb7ZHIQqc11shqEBvjPTRolV8qOhohUWPuaswePrLK
 LS+YKPftMJsMwTXjLx+g/2ifDKH0B6YA63//RmvZcBjw/j589V
 nhT/dqNBFCTfCaL4/OzLvwUAY3aP7mcYGhse2Qk+BJuGwFF7sQ
 A9hmUBRSN1TVXasBh9fow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock_kernel in fat_put_super is not needed because
it only protects the super block itself and we know that
no other thread can reach it because we are about to
kfree the object.

In the two fill_super functions, this converts the locking
to use lock_super like elsewhere in the fat code. This
is probably not needed either, but is consistent and puts
us on the safe side.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Blunck <jblunck@infradead.org>
---
 fs/fat/inode.c       |    5 -----
 fs/fat/namei_msdos.c |    7 +++----
 fs/fat/namei_vfat.c  |    7 +++----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8300580..ad6998a 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -14,7 +14,6 @@
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
@@ -489,8 +488,6 @@ static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
-	lock_kernel();
-
 	if (sb->s_dirt)
 		fat_write_super(sb);
 
@@ -504,8 +501,6 @@ static void fat_put_super(struct super_block *sb)
 
 	sb->s_fs_info = NULL;
 	kfree(sbi);
-
-	unlock_kernel();
 }
 
 static struct kmem_cache *fat_inode_cachep;
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index e2b0b97..bbca5c1 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/buffer_head.h>
-#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "fat.h"
 
 /* Characters that are undesirable in an MS-DOS file name */
@@ -663,16 +662,16 @@ static int msdos_fill_super(struct super_block *sb, void *data, int silent)
 {
 	int res;
 
-	lock_kernel();
+	lock_super(sb);
 	res = fat_fill_super(sb, data, silent, &msdos_dir_inode_operations, 0);
 	if (res) {
-		unlock_kernel();
+		unlock_super(sb);
 		return res;
 	}
 
 	sb->s_flags |= MS_NOATIME;
 	sb->s_root->d_op = &msdos_dentry_operations;
-	unlock_kernel();
+	unlock_super(sb);
 	return 0;
 }
 
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 9006ad9..6f0f6c9 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -21,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
-#include <linux/smp_lock.h>     /* For lock_kernel() */
 #include "fat.h"
 
 /*
@@ -1056,10 +1055,10 @@ static int vfat_fill_super(struct super_block *sb, void *data, int silent)
 {
 	int res;
 
-	lock_kernel();
+	lock_super(sb);
 	res = fat_fill_super(sb, data, silent, &vfat_dir_inode_operations, 1);
 	if (res) {
-		unlock_kernel();
+		unlock_super(sb);
 		return res;
 	}
 
@@ -1068,7 +1067,7 @@ static int vfat_fill_super(struct super_block *sb, void *data, int silent)
 	else
 		sb->s_root->d_op = &vfat_dentry_ops;
 
-	unlock_kernel();
+	unlock_super(sb);
 	return 0;
 }
 
-- 
1.7.1

