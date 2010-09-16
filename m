Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0IPRqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:46:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0IPRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 10/12] BKL: Remove BKL from jffs2
Date: Thu, 16 Sep 2010 19:46:23 +0200
Message-Id: <1284659185-8942-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:A1k/RDHVQFUQ+H2tF3twAPeSFlPz30pKSG3NPwRsOEx
 AJXjriFfQNMcBPcD7O53ZvBQSreg7HL7i7+SPT6KSlD+w4VszX
 0WgeIQVTxLbDxPaMs8+SfbmGu3Epax3TWAGRz2XoV1YG7UrS89
 3Bhtj9mMVfce8NrPjAq2IbDcyIBH620HgluD613/mqPGQqd8Dn
 58vIUbeYkZBIdC18cE6NQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super, fill_super and remount_fs that are all
three protected by the superblocks s_umount rw_semaphore. Therefore it is
safe to remove the BKL entirely.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 fs/jffs2/fs.c    |    4 ----
 fs/jffs2/super.c |   12 +-----------
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 6b2964a..d9beb06 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -21,7 +21,6 @@
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
 #include <linux/crc32.h>
-#include <linux/smp_lock.h>
 #include "nodelist.h"
 
 static int jffs2_flash_setup(struct jffs2_sb_info *c);
@@ -391,7 +390,6 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 	   This also catches the case where it was stopped and this
 	   is just a remount to restart it.
 	   Flush the writebuffer, if neccecary, else we loose it */
-	lock_kernel();
 	if (!(sb->s_flags & MS_RDONLY)) {
 		jffs2_stop_garbage_collect_thread(c);
 		mutex_lock(&c->alloc_sem);
@@ -403,8 +401,6 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 		jffs2_start_garbage_collect_thread(c);
 
 	*flags |= MS_NOATIME;
-
-	unlock_kernel();
 	return 0;
 }
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 58dd9cf..d1ae5df 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/fs.h>
@@ -148,17 +147,13 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 	struct jffs2_sb_info *c;
 	int ret;
 
-	lock_kernel();
-
 	D1(printk(KERN_DEBUG "jffs2_get_sb_mtd():"
 		  " New superblock for device %d (\"%s\")\n",
 		  sb->s_mtd->index, sb->s_mtd->name));
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
-	if (!c) {
-		unlock_kernel();
+	if (!c)
 		return -ENOMEM;
-	}
 
 	c->mtd = sb->s_mtd;
 	c->os_priv = sb;
@@ -181,7 +176,6 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags |= MS_POSIXACL;
 #endif
 	ret = jffs2_do_fill_super(sb, data, silent);
-	unlock_kernel();
 	return ret;
 }
 
@@ -199,8 +193,6 @@ static void jffs2_put_super (struct super_block *sb)
 
 	D2(printk(KERN_DEBUG "jffs2: jffs2_put_super()\n"));
 
-	lock_kernel();
-
 	if (sb->s_dirt)
 		jffs2_write_super(sb);
 
@@ -222,8 +214,6 @@ static void jffs2_put_super (struct super_block *sb)
 	if (c->mtd->sync)
 		c->mtd->sync(c->mtd);
 
-	unlock_kernel();
-
 	D1(printk(KERN_DEBUG "jffs2_put_super returning\n"));
 }
 
-- 
1.7.1

