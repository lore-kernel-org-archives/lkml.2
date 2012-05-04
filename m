Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab2EDR0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:26:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:21168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834Ab2EDR0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:26:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="140179738"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 1/2] jffs2: introduce fake wbuf inode
Date: Fri,  4 May 2012 20:27:07 +0300
Message-Id: <1336152428-24242-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
References: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch is just a preparation for further changes. It introduces a special
inode ('wbuf_inode') in JFFS2 file-system which we'll later use for delayed
write-out of the write-buffer.

We do not allocate JFFS2 data structures like 'struct jffs2_inode_info' for
this inode because we won't need them. We allocate the next available inode
number for 'wbuf_inode' after the JFFS2 media is scanned. Of course, wbuf_inode
won't ever be written to the flash media.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/jffs2/fs.c          |   13 ++++++++++---
 fs/jffs2/jffs2_fs_sb.h |    1 +
 fs/jffs2/os-linux.h    |    4 ++++
 fs/jffs2/super.c       |    1 +
 fs/jffs2/wbuf.c        |   24 ++++++++++++++++++++++++
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index bb6f993..94016a9 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -241,7 +241,8 @@ void jffs2_evict_inode (struct inode *inode)
 		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages(&inode->i_data, 0);
 	end_writeback(inode);
-	jffs2_do_clear_inode(c, f);
+	if (inode != c->wbuf_inode)
+		jffs2_do_clear_inode(c, f);
 }
 
 struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
@@ -562,12 +563,16 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	if ((ret = jffs2_do_mount_fs(c)))
 		goto out_inohash;
 
+	ret = jffs2_setup_wbuf_inode(c);
+	if (ret)
+		goto out_root;
+
 	jffs2_dbg(1, "%s(): Getting root inode\n", __func__);
 	root_i = jffs2_iget(sb, 1);
 	if (IS_ERR(root_i)) {
 		jffs2_dbg(1, "get root inode failed\n");
 		ret = PTR_ERR(root_i);
-		goto out_root;
+		goto out_wbuf_inode;
 	}
 
 	ret = -ENOMEM;
@@ -575,7 +580,7 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	jffs2_dbg(1, "%s(): d_make_root()\n", __func__);
 	sb->s_root = d_make_root(root_i);
 	if (!sb->s_root)
-		goto out_root;
+		goto out_wbuf_inode;
 
 	sb->s_maxbytes = 0xFFFFFFFF;
 	sb->s_blocksize = PAGE_CACHE_SIZE;
@@ -585,6 +590,8 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 		jffs2_start_garbage_collect_thread(c);
 	return 0;
 
+out_wbuf_inode:
+	jffs2_free_wbuf_inode(c);
 out_root:
 	jffs2_free_ino_caches(c);
 	jffs2_free_raw_node_refs(c);
diff --git a/fs/jffs2/jffs2_fs_sb.h b/fs/jffs2/jffs2_fs_sb.h
index 55a0c1d..11d43f2 100644
--- a/fs/jffs2/jffs2_fs_sb.h
+++ b/fs/jffs2/jffs2_fs_sb.h
@@ -125,6 +125,7 @@ struct jffs2_sb_info {
 	uint32_t wbuf_len;
 	struct jffs2_inodirty *wbuf_inodes;
 	struct rw_semaphore wbuf_sem;	/* Protects the write buffer */
+	struct inode *wbuf_inode; /* Fake inode for delayed wbuf write-out */
 
 	unsigned char *oobbuf;
 	int oobavail; /* How many bytes are available for JFFS2 in OOB */
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 1cd3aec..6f28cc5 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -82,6 +82,8 @@ static inline void jffs2_init_inode_info(struct jffs2_inode_info *f)
 #define jffs2_write_nand_badblock(c,jeb,bad_offset) (1)
 #define jffs2_nand_flash_setup(c) (0)
 #define jffs2_nand_flash_cleanup(c) do {} while(0)
+#define jffs2_setup_wbuf_inode(c) 0
+#define jffs2_free_wbuf_inode(c) do {} while(0)
 #define jffs2_wbuf_dirty(c) (0)
 #define jffs2_flash_writev(a,b,c,d,e,f) jffs2_flash_direct_writev(a,b,c,d,e)
 #define jffs2_wbuf_timeout NULL
@@ -124,6 +126,8 @@ int jffs2_flush_wbuf_gc(struct jffs2_sb_info *c, uint32_t ino);
 int jffs2_flush_wbuf_pad(struct jffs2_sb_info *c);
 int jffs2_nand_flash_setup(struct jffs2_sb_info *c);
 void jffs2_nand_flash_cleanup(struct jffs2_sb_info *c);
+int jffs2_setup_wbuf_inode(struct jffs2_sb_info *c);
+void jffs2_free_wbuf_inode(struct jffs2_sb_info *c);
 
 #define jffs2_dataflash(c) (c->mtd->type == MTD_DATAFLASH)
 int jffs2_dataflash_setup(struct jffs2_sb_info *c);
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index f9916f3..a180409 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -326,6 +326,7 @@ static void jffs2_put_super (struct super_block *sb)
 	jffs2_flush_wbuf_pad(c);
 	mutex_unlock(&c->alloc_sem);
 
+	jffs2_free_wbuf_inode(c);
 	jffs2_sum_exit(c);
 
 	jffs2_free_ino_caches(c);
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 74d9be1..65373cf 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -1315,3 +1315,27 @@ int jffs2_ubivol_setup(struct jffs2_sb_info *c) {
 void jffs2_ubivol_cleanup(struct jffs2_sb_info *c) {
 	kfree(c->wbuf);
 }
+
+/*
+ * Allocate a fake inode and which is used for delayed write-out of the
+ * write-buffer: we mark it as dirty when the write-buffer is not empty we will
+ * synchronize the write-buffer in 'jffs2_write_inode'.
+ */
+int jffs2_setup_wbuf_inode(struct jffs2_sb_info *c)
+{
+	struct super_block *sb = OFNI_BS_2SFFJ(c);
+
+	c->wbuf_inode = new_inode(sb);
+	if (!c->wbuf_inode)
+		return -ENOMEM;
+
+	c->wbuf_inode->i_ino = ++c->highest_ino;
+	insert_inode_hash(c->wbuf_inode);
+
+	return 0;
+}
+
+void jffs2_free_wbuf_inode(struct jffs2_sb_info *c)
+{
+	iput(c->wbuf_inode);
+}
-- 
1.7.7.6

