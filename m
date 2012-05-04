Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab2EDR0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:26:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:21168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278Ab2EDR0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:26:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="140179751"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 2/2] jffs2: get rid of jffs2_sync_super
Date: Fri,  4 May 2012 20:27:08 +0300
Message-Id: <1336152428-24242-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
References: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
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
'->write_super()'/'->s_dirt' to 'wbuf_inode'/'->write_inode'. Instead of
setting the 's_dirt' flag, we just mark the special 'wbuf_inode' inode as
dirty and let VFS invoke the '->write_inode' call-back when needed, where we
synchronize the write-buffer.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/jffs2/fs.c       |   18 ++++++++++++++++++
 fs/jffs2/os-linux.h |    3 ++-
 fs/jffs2/super.c    |   22 +---------------------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 94016a9..c6aacbb 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -228,6 +228,24 @@ int jffs2_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
+int jffs2_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
+
+	/*
+	 * JFFS2 is synchronous file-system, and the only the fake write-buffer
+	 * inode is allowed to be writen-out asynchronously - we use this to do
+	 * delayed write-buffer synchronization.
+	 */
+	BUG_ON(inode != c->wbuf_inode);
+
+	if (!(inode->i_sb->s_flags & MS_RDONLY)) {
+		jffs2_dbg(1, "%s()\n", __func__);
+		jffs2_flush_wbuf_gc(c, 0);
+	}
+
+	return 0;
+}
 
 void jffs2_evict_inode (struct inode *inode)
 {
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 6f28cc5..ab97e88 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -144,7 +144,7 @@ void jffs2_nor_wbuf_flash_cleanup(struct jffs2_sb_info *c);
 
 static inline void jffs2_dirty_trigger(struct jffs2_sb_info *c)
 {
-	OFNI_BS_2SFFJ(c)->s_dirt = 1;
+	__mark_inode_dirty(c->wbuf_inode, I_DIRTY_SYNC);
 }
 
 /* background.c */
@@ -173,6 +173,7 @@ extern const struct inode_operations jffs2_symlink_inode_operations;
 int jffs2_setattr (struct dentry *, struct iattr *);
 int jffs2_do_setattr (struct inode *, struct iattr *);
 struct inode *jffs2_iget(struct super_block *, unsigned long);
+int jffs2_write_inode(struct inode *inode, struct writeback_control *wbc);
 void jffs2_evict_inode (struct inode *);
 void jffs2_dirty_inode(struct inode *inode, int flags);
 struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode,
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index a180409..0b4e632 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -63,21 +63,6 @@ static void jffs2_i_init_once(void *foo)
 	inode_init_once(&f->vfs_inode);
 }
 
-static void jffs2_write_super(struct super_block *sb)
-{
-	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
-
-	lock_super(sb);
-	sb->s_dirt = 0;
-
-	if (!(sb->s_flags & MS_RDONLY)) {
-		jffs2_dbg(1, "%s()\n", __func__);
-		jffs2_flush_wbuf_gc(c, 0);
-	}
-
-	unlock_super(sb);
-}
-
 static const char *jffs2_compr_name(unsigned int compr)
 {
 	switch (compr) {
@@ -113,8 +98,6 @@ static int jffs2_sync_fs(struct super_block *sb, int wait)
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
-	jffs2_write_super(sb);
-
 	mutex_lock(&c->alloc_sem);
 	jffs2_flush_wbuf_pad(c);
 	mutex_unlock(&c->alloc_sem);
@@ -249,9 +232,9 @@ static int jffs2_remount_fs(struct super_block *sb, int *flags, char *data)
 static const struct super_operations jffs2_super_operations =
 {
 	.alloc_inode =	jffs2_alloc_inode,
+	.write_inode =  jffs2_write_inode,
 	.destroy_inode =jffs2_destroy_inode,
 	.put_super =	jffs2_put_super,
-	.write_super =	jffs2_write_super,
 	.statfs =	jffs2_statfs,
 	.remount_fs =	jffs2_remount_fs,
 	.evict_inode =	jffs2_evict_inode,
@@ -319,9 +302,6 @@ static void jffs2_put_super (struct super_block *sb)
 
 	jffs2_dbg(2, "%s()\n", __func__);
 
-	if (sb->s_dirt)
-		jffs2_write_super(sb);
-
 	mutex_lock(&c->alloc_sem);
 	jffs2_flush_wbuf_pad(c);
 	mutex_unlock(&c->alloc_sem);
-- 
1.7.7.6

