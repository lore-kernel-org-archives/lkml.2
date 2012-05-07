Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2EGQ4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:56:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:19926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476Ab2EGQ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:56:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="137865931"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/4] jffs2: get rid of jffs2_sync_super
Date: Mon,  7 May 2012 19:56:53 +0300
Message-Id: <1336409813-6365-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336409813-6365-1-git-send-email-dedekind1@gmail.com>
References: <1336409813-6365-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Currently JFFS2 file-system maps the VFS "superblock" abstraction to the
write-buffer. Namely, it uses VFS services to synchronize the write-buffer
periodically.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds and
writes out all dirty superblock using the '->write_super()' call-back. But the
problem with this thread is that it wastes power by waking up the system every
5 seconds no matter what. So we want to kill it completely and thus, we need to
make file-systems to stop using the '->write_super' VFS service, and then
remove it together with the kernel thread.

This patch switches the JFFS2 write-buffer management from
'->write_super()'/'->s_dirt' to a delayed work. Instead of setting the 's_dirt'
flag we just schedule a delayed work for synchronizing the write-buffer.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/jffs2/jffs2_fs_sb.h |    4 +++
 fs/jffs2/os-linux.h    |    7 +----
 fs/jffs2/super.c       |   13 -----------
 fs/jffs2/wbuf.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 55a0c1d..44dca1f 100644
--- a/fs/jffs2/jffs2_fs_sb.h
+++ b/fs/jffs2/jffs2_fs_sb.h
@@ -126,6 +126,10 @@ struct jffs2_sb_info {
 	struct jffs2_inodirty *wbuf_inodes;
 	struct rw_semaphore wbuf_sem;	/* Protects the write buffer */
 
+	struct delayed_work wbuf_dwork; /* write-buffer write-out work */
+	int wbuf_queued;                /* non-zero delayed work is queued */
+	spinlock_t wbuf_dwork_lock;     /* protects wbuf_dwork and and wbuf_queued */
+
 	unsigned char *oobbuf;
 	int oobavail; /* How many bytes are available for JFFS2 in OOB */
 #endif
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 1cd3aec..bcd983d 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -95,6 +95,7 @@ static inline void jffs2_init_inode_info(struct jffs2_inode_info *f)
 #define jffs2_ubivol(c) (0)
 #define jffs2_ubivol_setup(c) (0)
 #define jffs2_ubivol_cleanup(c) do {} while (0)
+#define jffs2_dirty_trigger(c) do {} while (0)
 
 #else /* NAND and/or ECC'd NOR support present */
 
@@ -135,14 +136,10 @@ void jffs2_ubivol_cleanup(struct jffs2_sb_info *c);
 #define jffs2_nor_wbuf_flash(c) (c->mtd->type == MTD_NORFLASH && ! (c->mtd->flags & MTD_BIT_WRITEABLE))
 int jffs2_nor_wbuf_flash_setup(struct jffs2_sb_info *c);
 void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c);
+void jffs2_dirty_trigger(struct jffs2_sb_info *c);
 
 #endif /* WRITEBUFFER */
 
-static inline void jffs2_dirty_trigger(struct jffs2_sb_info *c)
-{
-	OFNI_BS_2SFFJ(c)->s_dirt = 1;
-}
-
 /* background.c */
 int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c);
 void jffs2_stop_garbage_collect_thread(struct jffs2_sb_info *c);
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index dc366c0..bc586f2 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -63,18 +63,6 @@ static void jffs2_i_init_once(void *foo)
 	inode_init_once(&f->vfs_inode);
 }
 
-static void jffs2_write_super(struct super_block *sb)
-{
-	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
-
-	sb->s_dirt = 0;
-
-	if (!(sb->s_flags & MS_RDONLY)) {
-		jffs2_dbg(1, "%s()\n", __func__);
-		jffs2_flush_wbuf_gc(c, 0);
-	}
-}
-
 static const char *jffs2_compr_name(unsigned int compr)
 {
 	switch (compr) {
@@ -246,7 +234,6 @@ static const struct super_operations jffs2_super_operations =
 	.alloc_inode =	jffs2_alloc_inode,
 	.destroy_inode =jffs2_destroy_inode,
 	.put_super =	jffs2_put_super,
-	.write_super =	jffs2_write_super,
 	.statfs =	jffs2_statfs,
 	.remount_fs =	jffs2_remount_fs,
 	.evict_inode =	jffs2_evict_inode,
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 74d9be1..6f4529d 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -20,6 +20,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/jiffies.h>
 #include <linux/sched.h>
+#include <linux/writeback.h>
 
 #include "nodelist.h"
 
@@ -85,7 +86,7 @@ static void jffs2_wbuf_dirties_inode(struct jffs2_sb_info *c, uint32_t ino)
 {
 	struct jffs2_inodirty *new;
 
-	/* Mark the superblock dirty so that kupdated will flush... */
+	/* Schedule delayed write-buffer write-out */
 	jffs2_dirty_trigger(c);
 
 	if (jffs2_wbuf_pending_for_ino(c, ino))
@@ -1148,6 +1149,47 @@ int jffs2_write_nand_badblock(struct jffs2_sb_info *c, struct jffs2_eraseblock *
 	return 1;
 }
 
+static struct jffs2_sb_info *work_to_sb(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+
+	dwork = container_of(work, struct delayed_work, work);
+	return container_of(dwork, struct jffs2_sb_info, wbuf_dwork);
+}
+
+static void delayed_wbuf_sync(struct work_struct *work)
+{
+	struct jffs2_sb_info *c = work_to_sb(work);
+	struct super_block *sb = OFNI_BS_2SFFJ(c);
+
+	spin_lock(&c->wbuf_dwork_lock);
+	c->wbuf_queued = 0;
+	spin_unlock(&c->wbuf_dwork_lock);
+
+	if (!(sb->s_flags & MS_RDONLY)) {
+		jffs2_dbg(1, "%s()\n", __func__);
+		jffs2_flush_wbuf_gc(c, 0);
+	}
+}
+
+void jffs2_dirty_trigger(struct jffs2_sb_info *c)
+{
+	struct super_block *sb = OFNI_BS_2SFFJ(c);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
+	spin_lock(&c->wbuf_dwork_lock);
+	if (!c->wbuf_queued) {
+		jffs2_dbg(1, "%s()\n", __func__);
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &c->wbuf_dwork, delay);
+		c->wbuf_queued = 1;
+	}
+	spin_unlock(&c->wbuf_dwork_lock);
+}
+
 int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
 {
 	struct nand_ecclayout *oinfo = c->mtd->ecclayout;
@@ -1169,6 +1211,8 @@ int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
 
 	/* Initialise write buffer */
 	init_rwsem(&c->wbuf_sem);
+	spin_lock_init(&c->wbuf_dwork_lock);
+	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 	c->wbuf_pagesize = c->mtd->writesize;
 	c->wbuf_ofs = 0xFFFFFFFF;
 
@@ -1207,8 +1251,8 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 
 	/* Initialize write buffer */
 	init_rwsem(&c->wbuf_sem);
-
-
+	spin_lock_init(&c->wbuf_dwork_lock);
+	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 	c->wbuf_pagesize =  c->mtd->erasesize;
 
 	/* Find a suitable c->sector_size
@@ -1267,6 +1311,9 @@ int jffs2_nor_wbuf_flash_setup(struct jffs2_sb_info *c) {
 
 	/* Initialize write buffer */
 	init_rwsem(&c->wbuf_sem);
+	spin_lock_init(&c->wbuf_dwork_lock);
+	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
+
 	c->wbuf_pagesize = c->mtd->writesize;
 	c->wbuf_ofs = 0xFFFFFFFF;
 
@@ -1299,6 +1346,8 @@ int jffs2_ubivol_setup(struct jffs2_sb_info *c) {
 		return 0;
 
 	init_rwsem(&c->wbuf_sem);
+	spin_lock_init(&c->wbuf_dwork_lock);
+	INIT_DELAYED_WORK(&c->wbuf_dwork, delayed_wbuf_sync);
 
 	c->wbuf_pagesize =  c->mtd->writesize;
 	c->wbuf_ofs = 0xFFFFFFFF;
-- 
1.7.7.6

