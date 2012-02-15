Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2BOX5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:57:30 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59719 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752160Ab2BOX51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:57:27 -0500
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
Date: Wed, 15 Feb 2012 15:56:43 -0800
Message-Id: <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1329349881.git.joe@perches.com>
References: <cover.1329349881.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

D1 and D2 macros are mostly uses to emit debugging messages.

Convert the logging uses of D1 & D2 to jffs2_dbg(level, fmt, ...)
to be a bit more consistent style with the rest of the kernel.

All jffs2_dbg output is now at KERN_DEBUG where some of
the previous uses were emitted at various KERN_<LEVEL>s.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jffs2/background.c |   23 ++++---
 fs/jffs2/compr.c      |   14 ++--
 fs/jffs2/compr_zlib.c |   31 +++++----
 fs/jffs2/debug.h      |    7 ++
 fs/jffs2/dir.c        |   32 ++++++----
 fs/jffs2/erase.c      |   33 ++++++----
 fs/jffs2/file.c       |   31 ++++++----
 fs/jffs2/fs.c         |   43 ++++++++------
 fs/jffs2/gc.c         |  162 +++++++++++++++++++++++++++++--------------------
 fs/jffs2/nodemgmt.c   |  161 +++++++++++++++++++++++++++++--------------------
 fs/jffs2/read.c       |   47 +++++++++------
 fs/jffs2/scan.c       |  126 ++++++++++++++++++++++----------------
 fs/jffs2/super.c      |   10 ++--
 fs/jffs2/symlink.c    |    3 +-
 fs/jffs2/wbuf.c       |   67 +++++++++++---------
 fs/jffs2/write.c      |   74 ++++++++++++----------
 16 files changed, 504 insertions(+), 360 deletions(-)

diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 404111b..26ce06c 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -47,7 +47,8 @@ int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 		ret = PTR_ERR(tsk);
 	} else {
 		/* Wait for it... */
-		D1(printk(KERN_DEBUG "JFFS2: Garbage collect thread is pid %d\n", tsk->pid));
+		jffs2_dbg(1, "JFFS2: Garbage collect thread is pid %d\n",
+			  tsk->pid);
 		wait_for_completion(&c->gc_thread_start);
 		ret = tsk->pid;
 	}
@@ -60,7 +61,7 @@ void jffs2_stop_garbage_collect_thread(struct jffs2_sb_info *c)
 	int wait = 0;
 	spin_lock(&c->erase_completion_lock);
 	if (c->gc_task) {
-		D1(printk(KERN_DEBUG "jffs2: Killing GC task %d\n", c->gc_task->pid));
+		jffs2_dbg(1, "jffs2: Killing GC task %d\n", c->gc_task->pid);
 		send_sig(SIGKILL, c->gc_task, 1);
 		wait = 1;
 	}
@@ -90,7 +91,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 		if (!jffs2_thread_should_wake(c)) {
 			set_current_state (TASK_INTERRUPTIBLE);
 			spin_unlock(&c->erase_completion_lock);
-			D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread sleeping...\n"));
+			jffs2_dbg(1, "%s(): sleeping...\n", __func__);
 			schedule();
 		} else
 			spin_unlock(&c->erase_completion_lock);
@@ -109,7 +110,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 		schedule_timeout_interruptible(msecs_to_jiffies(50));
 
 		if (kthread_should_stop()) {
-			D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread():  kthread_stop() called.\n"));
+			jffs2_dbg(1, "%s(): kthread_stop() called\n", __func__);
 			goto die;
 		}
 
@@ -126,26 +127,30 @@ static int jffs2_garbage_collect_thread(void *_c)
 
 			switch(signr) {
 			case SIGSTOP:
-				D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread(): SIGSTOP received.\n"));
+				jffs2_dbg(1, "%s(): SIGSTOP received\n",
+					  __func__);
 				set_current_state(TASK_STOPPED);
 				schedule();
 				break;
 
 			case SIGKILL:
-				D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread(): SIGKILL received.\n"));
+				jffs2_dbg(1, "%s(): SIGKILL received\n",
+					  __func__);
 				goto die;
 
 			case SIGHUP:
-				D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread(): SIGHUP received.\n"));
+				jffs2_dbg(1, "%s(): SIGHUP received\n",
+					  __func__);
 				break;
 			default:
-				D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread(): signal %ld received\n", signr));
+				jffs2_dbg(1, "%s(): signal %ld received\n",
+					  __func__, signr);
 			}
 		}
 		/* We don't want SIGHUP to interrupt us. STOP and KILL are OK though. */
 		disallow_signal(SIGHUP);
 
-		D1(printk(KERN_DEBUG "jffs2_garbage_collect_thread(): pass\n"));
+		jffs2_dbg(1, "%s(): pass\n", __func__);
 		if (jffs2_garbage_collect_pass(c) == -ENOSPC) {
 			printk(KERN_NOTICE "No space for garbage collection. Aborting GC thread\n");
 			goto die;
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index 96ed3c9..be8e493 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -309,7 +309,7 @@ int jffs2_register_compressor(struct jffs2_compressor *comp)
 	comp->stat_compr_new_size=0;
 	comp->stat_compr_blocks=0;
 	comp->stat_decompr_blocks=0;
-	D1(printk(KERN_DEBUG "Registering JFFS2 compressor \"%s\"\n", comp->name));
+	jffs2_dbg(1, "Registering JFFS2 compressor \"%s\"\n", comp->name);
 
 	spin_lock(&jffs2_compressor_list_lock);
 
@@ -332,9 +332,9 @@ out:
 
 int jffs2_unregister_compressor(struct jffs2_compressor *comp)
 {
-	D2(struct jffs2_compressor *this;)
+	D2(struct jffs2_compressor *this);
 
-	D1(printk(KERN_DEBUG "Unregistering JFFS2 compressor \"%s\"\n", comp->name));
+	jffs2_dbg(1, "Unregistering JFFS2 compressor \"%s\"\n", comp->name);
 
 	spin_lock(&jffs2_compressor_list_lock);
 
@@ -377,17 +377,17 @@ int __init jffs2_compressors_init(void)
 /* Setting default compression mode */
 #ifdef CONFIG_JFFS2_CMODE_NONE
 	jffs2_compression_mode = JFFS2_COMPR_MODE_NONE;
-	D1(printk(KERN_INFO "JFFS2: default compression mode: none\n");)
+	jffs2_dbg(1, "JFFS2: default compression mode: none\n");
 #else
 #ifdef CONFIG_JFFS2_CMODE_SIZE
 	jffs2_compression_mode = JFFS2_COMPR_MODE_SIZE;
-	D1(printk(KERN_INFO "JFFS2: default compression mode: size\n");)
+	jffs2_dbg(1, "JFFS2: default compression mode: size\n");
 #else
 #ifdef CONFIG_JFFS2_CMODE_FAVOURLZO
 	jffs2_compression_mode = JFFS2_COMPR_MODE_FAVOURLZO;
-	D1(printk(KERN_INFO "JFFS2: default compression mode: favourlzo\n");)
+	jffs2_dbg(1, "JFFS2: default compression mode: favourlzo\n");
 #else
-	D1(printk(KERN_INFO "JFFS2: default compression mode: priority\n");)
+	jffs2_dbg(1, "JFFS2: default compression mode: priority\n");
 #endif
 #endif
 #endif
diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 4e7a138..40979c9 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -45,13 +45,15 @@ static int __init alloc_workspaces(void)
 	if (!def_strm.workspace)
 		return -ENOMEM;
 
-	D1(printk(KERN_DEBUG "Allocated %d bytes for deflate workspace\n", zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL)));
+	jffs2_dbg(1, "Allocated %d bytes for deflate workspace\n",
+		  zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL));
 	inf_strm.workspace = vmalloc(zlib_inflate_workspacesize());
 	if (!inf_strm.workspace) {
 		vfree(def_strm.workspace);
 		return -ENOMEM;
 	}
-	D1(printk(KERN_DEBUG "Allocated %d bytes for inflate workspace\n", zlib_inflate_workspacesize()));
+	jffs2_dbg(1, "Allocated %d bytes for inflate workspace\n",
+		  zlib_inflate_workspacesize());
 	return 0;
 }
 
@@ -91,13 +93,14 @@ static int jffs2_zlib_compress(unsigned char *data_in,
 	while (def_strm.total_out < *dstlen - STREAM_END_SPACE && def_strm.total_in < *sourcelen) {
 		def_strm.avail_out = *dstlen - (def_strm.total_out + STREAM_END_SPACE);
 		def_strm.avail_in = min((unsigned)(*sourcelen-def_strm.total_in), def_strm.avail_out);
-		D1(printk(KERN_DEBUG "calling deflate with avail_in %d, avail_out %d\n",
-			  def_strm.avail_in, def_strm.avail_out));
+		jffs2_dbg(1, "calling deflate with avail_in %d, avail_out %d\n",
+			  def_strm.avail_in, def_strm.avail_out);
 		ret = zlib_deflate(&def_strm, Z_PARTIAL_FLUSH);
-		D1(printk(KERN_DEBUG "deflate returned with avail_in %d, avail_out %d, total_in %ld, total_out %ld\n",
-			  def_strm.avail_in, def_strm.avail_out, def_strm.total_in, def_strm.total_out));
+		jffs2_dbg(1, "deflate returned with avail_in %d, avail_out %d, total_in %ld, total_out %ld\n",
+			  def_strm.avail_in, def_strm.avail_out,
+			  def_strm.total_in, def_strm.total_out);
 		if (ret != Z_OK) {
-			D1(printk(KERN_DEBUG "deflate in loop returned %d\n", ret));
+			jffs2_dbg(1, "deflate in loop returned %d\n", ret);
 			zlib_deflateEnd(&def_strm);
 			mutex_unlock(&deflate_mutex);
 			return -1;
@@ -109,20 +112,20 @@ static int jffs2_zlib_compress(unsigned char *data_in,
 	zlib_deflateEnd(&def_strm);
 
 	if (ret != Z_STREAM_END) {
-		D1(printk(KERN_DEBUG "final deflate returned %d\n", ret));
+		jffs2_dbg(1, "final deflate returned %d\n", ret);
 		ret = -1;
 		goto out;
 	}
 
 	if (def_strm.total_out >= def_strm.total_in) {
-		D1(printk(KERN_DEBUG "zlib compressed %ld bytes into %ld; failing\n",
-			  def_strm.total_in, def_strm.total_out));
+		jffs2_dbg(1, "zlib compressed %ld bytes into %ld; failing\n",
+			  def_strm.total_in, def_strm.total_out);
 		ret = -1;
 		goto out;
 	}
 
-	D1(printk(KERN_DEBUG "zlib compressed %ld bytes into %ld\n",
-		  def_strm.total_in, def_strm.total_out));
+	jffs2_dbg(1, "zlib compressed %ld bytes into %ld\n",
+		  def_strm.total_in, def_strm.total_out);
 
 	*dstlen = def_strm.total_out;
 	*sourcelen = def_strm.total_in;
@@ -155,13 +158,13 @@ static int jffs2_zlib_decompress(unsigned char *data_in,
 	    ((data_in[0] & 0x0f) == Z_DEFLATED) &&
 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
 
-		D2(printk(KERN_DEBUG "inflate skipping adler32\n"));
+		jffs2_dbg(2, "inflate skipping adler32\n");
 		wbits = -((data_in[0] >> 4) + 8);
 		inf_strm.next_in += 2;
 		inf_strm.avail_in -= 2;
 	} else {
 		/* Let this remain D1 for now -- it should never happen */
-		D1(printk(KERN_DEBUG "inflate not skipping adler32\n"));
+		jffs2_dbg(1, "inflate not skipping adler32\n");
 	}
 
 
diff --git a/fs/jffs2/debug.h b/fs/jffs2/debug.h
index c4f8eef..7782c63 100644
--- a/fs/jffs2/debug.h
+++ b/fs/jffs2/debug.h
@@ -51,6 +51,7 @@
  * superseded by nicer dbg_xxx() macros...
  */
 #if CONFIG_JFFS2_FS_DEBUG > 0
+#define DEBUG
 #define D1(x) x
 #else
 #define D1(x)
@@ -62,6 +63,12 @@
 #define D2(x)
 #endif
 
+#define jffs2_dbg(level, fmt, ...)		\
+do {						\
+	if (CONFIG_JFFS2_FS_DEBUG >= level)	\
+		pr_debug(fmt, ##__VA_ARGS__);	\
+} while (0)
+
 /* The prefixes of JFFS2 messages */
 #define JFFS2_DBG_PREFIX	"[JFFS2 DBG]"
 #define JFFS2_ERR_PREFIX	"JFFS2 error:"
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 973ac58..01a07af 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -79,7 +79,7 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 	uint32_t ino = 0;
 	struct inode *inode = NULL;
 
-	D1(printk(KERN_DEBUG "jffs2_lookup()\n"));
+	jffs2_dbg(1, "jffs2_lookup()\n");
 
 	if (target->d_name.len > JFFS2_MAX_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -119,21 +119,22 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct jffs2_full_dirent *fd;
 	unsigned long offset, curofs;
 
-	D1(printk(KERN_DEBUG "jffs2_readdir() for dir_i #%lu\n", filp->f_path.dentry->d_inode->i_ino));
+	jffs2_dbg(1, "jffs2_readdir() for dir_i #%lu\n",
+		  filp->f_path.dentry->d_inode->i_ino);
 
 	f = JFFS2_INODE_INFO(inode);
 
 	offset = filp->f_pos;
 
 	if (offset == 0) {
-		D1(printk(KERN_DEBUG "Dirent 0: \".\", ino #%lu\n", inode->i_ino));
+		jffs2_dbg(1, "Dirent 0: \".\", ino #%lu\n", inode->i_ino);
 		if (filldir(dirent, ".", 1, 0, inode->i_ino, DT_DIR) < 0)
 			goto out;
 		offset++;
 	}
 	if (offset == 1) {
 		unsigned long pino = parent_ino(filp->f_path.dentry);
-		D1(printk(KERN_DEBUG "Dirent 1: \"..\", ino #%lu\n", pino));
+		jffs2_dbg(1, "Dirent 1: \"..\", ino #%lu\n", pino);
 		if (filldir(dirent, "..", 2, 1, pino, DT_DIR) < 0)
 			goto out;
 		offset++;
@@ -146,16 +147,18 @@ static int jffs2_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		curofs++;
 		/* First loop: curofs = 2; offset = 2 */
 		if (curofs < offset) {
-			D2(printk(KERN_DEBUG "Skipping dirent: \"%s\", ino #%u, type %d, because curofs %ld < offset %ld\n",
-				  fd->name, fd->ino, fd->type, curofs, offset));
+			jffs2_dbg(2, "Skipping dirent: \"%s\", ino #%u, type %d, because curofs %ld < offset %ld\n",
+				  fd->name, fd->ino, fd->type, curofs, offset);
 			continue;
 		}
 		if (!fd->ino) {
-			D2(printk(KERN_DEBUG "Skipping deletion dirent \"%s\"\n", fd->name));
+			jffs2_dbg(2, "Skipping deletion dirent \"%s\"\n",
+				  fd->name);
 			offset++;
 			continue;
 		}
-		D2(printk(KERN_DEBUG "Dirent %ld: \"%s\", ino #%u, type %d\n", offset, fd->name, fd->ino, fd->type));
+		jffs2_dbg(2, "Dirent %ld: \"%s\", ino #%u, type %d\n",
+			  offset, fd->name, fd->ino, fd->type);
 		if (filldir(dirent, fd->name, strlen(fd->name), offset, fd->ino, fd->type) < 0)
 			break;
 		offset++;
@@ -184,12 +187,12 @@ static int jffs2_create(struct inode *dir_i, struct dentry *dentry,
 
 	c = JFFS2_SB_INFO(dir_i->i_sb);
 
-	D1(printk(KERN_DEBUG "jffs2_create()\n"));
+	jffs2_dbg(1, "%s()\n", __func__);
 
 	inode = jffs2_new_inode(dir_i, mode, ri);
 
 	if (IS_ERR(inode)) {
-		D1(printk(KERN_DEBUG "jffs2_new_inode() failed\n"));
+		jffs2_dbg(1, "jffs2_new_inode() failed\n");
 		jffs2_free_raw_inode(ri);
 		return PTR_ERR(inode);
 	}
@@ -217,9 +220,9 @@ static int jffs2_create(struct inode *dir_i, struct dentry *dentry,
 
 	jffs2_free_raw_inode(ri);
 
-	D1(printk(KERN_DEBUG "jffs2_create: Created ino #%lu with mode %o, nlink %d(%d). nrpages %ld\n",
-		  inode->i_ino, inode->i_mode, inode->i_nlink,
-		  f->inocache->pino_nlink, inode->i_mapping->nrpages));
+	jffs2_dbg(1, "%s(): Created ino #%lu with mode %o, nlink %d(%d). nrpages %ld\n",
+		  __func__, inode->i_ino, inode->i_mode, inode->i_nlink,
+		  f->inocache->pino_nlink, inode->i_mapping->nrpages);
 
 	d_instantiate(dentry, inode);
 	unlock_new_inode(inode);
@@ -369,7 +372,8 @@ static int jffs2_symlink (struct inode *dir_i, struct dentry *dentry, const char
 		goto fail;
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_symlink: symlink's target '%s' cached\n", (char *)f->target));
+	jffs2_dbg(1, "%s(): symlink's target '%s' cached\n",
+		  __func__, (char *)f->target);
 
 	/* No data here. Only a metadata node, which will be
 	   obsoleted by the first data write
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index eafb8d3..ee1cd98 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -46,8 +46,9 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
 #else /* Linux */
 	struct erase_info *instr;
 
-	D1(printk(KERN_DEBUG "jffs2_erase_block(): erase block %#08x (range %#08x-%#08x)\n",
-				jeb->offset, jeb->offset, jeb->offset + c->sector_size));
+	jffs2_dbg(1, "%s(): erase block %#08x (range %#08x-%#08x)\n",
+		  __func__,
+		  jeb->offset, jeb->offset, jeb->offset + c->sector_size);
 	instr = kmalloc(sizeof(struct erase_info) + sizeof(struct erase_priv_struct), GFP_KERNEL);
 	if (!instr) {
 		printk(KERN_WARNING "kmalloc for struct erase_info in jffs2_erase_block failed. Refiling block for later\n");
@@ -84,7 +85,8 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
 
 	if (ret == -ENOMEM || ret == -EAGAIN) {
 		/* Erase failed immediately. Refile it on the list */
-		D1(printk(KERN_DEBUG "Erase at 0x%08x failed: %d. Refiling on erase_pending_list\n", jeb->offset, ret));
+		jffs2_dbg(1, "Erase at 0x%08x failed: %d. Refiling on erase_pending_list\n",
+			  jeb->offset, ret);
 		mutex_lock(&c->erase_free_sem);
 		spin_lock(&c->erase_completion_lock);
 		list_move(&jeb->list, &c->erase_pending_list);
@@ -125,13 +127,14 @@ int jffs2_erase_pending_blocks(struct jffs2_sb_info *c, int count)
 
 			work_done++;
 			if (!--count) {
-				D1(printk(KERN_DEBUG "Count reached. jffs2_erase_pending_blocks leaving\n"));
+				jffs2_dbg(1, "Count reached. jffs2_erase_pending_blocks leaving\n");
 				goto done;
 			}
 
 		} else if (!list_empty(&c->erase_pending_list)) {
 			jeb = list_entry(c->erase_pending_list.next, struct jffs2_eraseblock, list);
-			D1(printk(KERN_DEBUG "Starting erase of pending block 0x%08x\n", jeb->offset));
+			jffs2_dbg(1, "Starting erase of pending block 0x%08x\n",
+				  jeb->offset);
 			list_del(&jeb->list);
 			c->erasing_size += c->sector_size;
 			c->wasted_size -= jeb->wasted_size;
@@ -159,13 +162,13 @@ int jffs2_erase_pending_blocks(struct jffs2_sb_info *c, int count)
 	spin_unlock(&c->erase_completion_lock);
 	mutex_unlock(&c->erase_free_sem);
  done:
-	D1(printk(KERN_DEBUG "jffs2_erase_pending_blocks completed\n"));
+	jffs2_dbg(1, "jffs2_erase_pending_blocks completed\n");
 	return work_done;
 }
 
 static void jffs2_erase_succeeded(struct jffs2_sb_info *c, struct jffs2_eraseblock *jeb)
 {
-	D1(printk(KERN_DEBUG "Erase completed successfully at 0x%08x\n", jeb->offset));
+	jffs2_dbg(1, "Erase completed successfully at 0x%08x\n", jeb->offset);
 	mutex_lock(&c->erase_free_sem);
 	spin_lock(&c->erase_completion_lock);
 	list_move_tail(&jeb->list, &c->erase_complete_list);
@@ -269,8 +272,8 @@ static inline void jffs2_remove_node_refs_from_ino_list(struct jffs2_sb_info *c,
 		return;
 	}
 
-	D1(printk(KERN_DEBUG "Removed nodes in range 0x%08x-0x%08x from ino #%u\n",
-		  jeb->offset, jeb->offset + c->sector_size, ic->ino));
+	jffs2_dbg(1, "Removed nodes in range 0x%08x-0x%08x from ino #%u\n",
+		  jeb->offset, jeb->offset + c->sector_size, ic->ino);
 
 	D2({
 		int i=0;
@@ -310,7 +313,8 @@ static inline void jffs2_remove_node_refs_from_ino_list(struct jffs2_sb_info *c,
 void jffs2_free_jeb_node_refs(struct jffs2_sb_info *c, struct jffs2_eraseblock *jeb)
 {
 	struct jffs2_raw_node_ref *block, *ref;
-	D1(printk(KERN_DEBUG "Freeing all node refs for eraseblock offset 0x%08x\n", jeb->offset));
+	jffs2_dbg(1, "Freeing all node refs for eraseblock offset 0x%08x\n",
+		  jeb->offset);
 
 	block = ref = jeb->first_node;
 
@@ -342,12 +346,13 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
 			&ebuf, NULL);
 	if (ret != -EOPNOTSUPP) {
 		if (ret) {
-			D1(printk(KERN_DEBUG "MTD point failed %d\n", ret));
+			jffs2_dbg(1, "MTD point failed %d\n", ret);
 			goto do_flash_read;
 		}
 		if (retlen < c->sector_size) {
 			/* Don't muck about if it won't let us point to the whole erase sector */
-			D1(printk(KERN_DEBUG "MTD point returned len too short: 0x%zx\n", retlen));
+			jffs2_dbg(1, "MTD point returned len too short: 0x%zx\n",
+				  retlen);
 			mtd_unpoint(c->mtd, jeb->offset, retlen);
 			goto do_flash_read;
 		}
@@ -372,7 +377,7 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
 		return -EAGAIN;
 	}
 
-	D1(printk(KERN_DEBUG "Verifying erase at 0x%08x\n", jeb->offset));
+	jffs2_dbg(1, "Verifying erase at 0x%08x\n", jeb->offset);
 
 	for (ofs = jeb->offset; ofs < jeb->offset + c->sector_size; ) {
 		uint32_t readlen = min((uint32_t)PAGE_SIZE, jeb->offset + c->sector_size - ofs);
@@ -422,7 +427,7 @@ static void jffs2_mark_erased_block(struct jffs2_sb_info *c, struct jffs2_eraseb
 	}
 
 	/* Write the erase complete marker */
-	D1(printk(KERN_DEBUG "Writing erased marker to block at 0x%08x\n", jeb->offset));
+	jffs2_dbg(1, "Writing erased marker to block at 0x%08x\n", jeb->offset);
 	bad_offset = jeb->offset;
 
 	/* Cleanmarker in oob area or no cleanmarker at all ? */
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 61e6723..5ffc356 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -85,7 +85,8 @@ static int jffs2_do_readpage_nolock (struct inode *inode, struct page *pg)
 	unsigned char *pg_buf;
 	int ret;
 
-	D2(printk(KERN_DEBUG "jffs2_do_readpage_nolock(): ino #%lu, page at offset 0x%lx\n", inode->i_ino, pg->index << PAGE_CACHE_SHIFT));
+	jffs2_dbg(2, "%s(): ino #%lu, page at offset 0x%lx\n",
+		  __func__, inode->i_ino, pg->index << PAGE_CACHE_SHIFT);
 
 	BUG_ON(!PageLocked(pg));
 
@@ -105,7 +106,7 @@ static int jffs2_do_readpage_nolock (struct inode *inode, struct page *pg)
 	flush_dcache_page(pg);
 	kunmap(pg);
 
-	D2(printk(KERN_DEBUG "readpage finished\n"));
+	jffs2_dbg(2, "readpage finished\n");
 	return ret;
 }
 
@@ -144,7 +145,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		return -ENOMEM;
 	*pagep = pg;
 
-	D1(printk(KERN_DEBUG "jffs2_write_begin()\n"));
+	jffs2_dbg(1, "%s()\n", __func__);
 
 	if (pageofs > inode->i_size) {
 		/* Make new hole frag from old EOF to new page */
@@ -153,8 +154,8 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
 
-		D1(printk(KERN_DEBUG "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
-			  (unsigned int)inode->i_size, pageofs));
+		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
+			  (unsigned int)inode->i_size, pageofs);
 
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
@@ -198,7 +199,8 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			f->metadata = NULL;
 		}
 		if (ret) {
-			D1(printk(KERN_DEBUG "Eep. add_full_dnode_to_inode() failed in write_begin, returned %d\n", ret));
+			jffs2_dbg(1, "Eep. add_full_dnode_to_inode() failed in write_begin, returned %d\n",
+				  ret);
 			jffs2_mark_node_obsolete(c, fn->raw);
 			jffs2_free_full_dnode(fn);
 			jffs2_complete_reservation(c);
@@ -222,7 +224,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		if (ret)
 			goto out_page;
 	}
-	D1(printk(KERN_DEBUG "end write_begin(). pg->flags %lx\n", pg->flags));
+	jffs2_dbg(1, "end write_begin(). pg->flags %lx\n", pg->flags);
 	return ret;
 
 out_page:
@@ -248,8 +250,9 @@ static int jffs2_write_end(struct file *filp, struct address_space *mapping,
 	int ret = 0;
 	uint32_t writtenlen = 0;
 
-	D1(printk(KERN_DEBUG "jffs2_write_end(): ino #%lu, page at 0x%lx, range %d-%d, flags %lx\n",
-		  inode->i_ino, pg->index << PAGE_CACHE_SHIFT, start, end, pg->flags));
+	jffs2_dbg(1, "%s(): ino #%lu, page at 0x%lx, range %d-%d, flags %lx\n",
+		  __func__, inode->i_ino, pg->index << PAGE_CACHE_SHIFT,
+		  start, end, pg->flags);
 
 	/* We need to avoid deadlock with page_cache_read() in
 	   jffs2_garbage_collect_pass(). So the page must be
@@ -268,7 +271,8 @@ static int jffs2_write_end(struct file *filp, struct address_space *mapping,
 	ri = jffs2_alloc_raw_inode();
 
 	if (!ri) {
-		D1(printk(KERN_DEBUG "jffs2_write_end(): Allocation of raw inode failed\n"));
+		jffs2_dbg(1, "%s(): Allocation of raw inode failed\n",
+			  __func__);
 		unlock_page(pg);
 		page_cache_release(pg);
 		return -ENOMEM;
@@ -315,13 +319,14 @@ static int jffs2_write_end(struct file *filp, struct address_space *mapping,
 		/* generic_file_write has written more to the page cache than we've
 		   actually written to the medium. Mark the page !Uptodate so that
 		   it gets reread */
-		D1(printk(KERN_DEBUG "jffs2_write_end(): Not all bytes written. Marking page !uptodate\n"));
+		jffs2_dbg(1, "%s(): Not all bytes written. Marking page !uptodate\n",
+			__func__);
 		SetPageError(pg);
 		ClearPageUptodate(pg);
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_write_end() returning %d\n",
-					writtenlen > 0 ? writtenlen : ret));
+	jffs2_dbg(1, "%s() returning %d\n",
+		  __func__, writtenlen > 0 ? writtenlen : ret);
 	unlock_page(pg);
 	page_cache_release(pg);
 	return writtenlen > 0 ? writtenlen : ret;
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index c0d5c9d..aad632e 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -39,7 +39,7 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 	int ret;
 	int alloc_type = ALLOC_NORMAL;
 
-	D1(printk(KERN_DEBUG "jffs2_setattr(): ino #%lu\n", inode->i_ino));
+	jffs2_dbg(1, "%s(): ino #%lu\n", __func__, inode->i_ino);
 
 	/* Special cases - we don't want more than one data node
 	   for these types on the medium at any time. So setattr
@@ -50,7 +50,8 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 		/* For these, we don't actually need to read the old node */
 		mdatalen = jffs2_encode_dev(&dev, inode->i_rdev);
 		mdata = (char *)&dev;
-		D1(printk(KERN_DEBUG "jffs2_setattr(): Writing %d bytes of kdev_t\n", mdatalen));
+		jffs2_dbg(1, "%s(): Writing %d bytes of kdev_t\n",
+			  __func__, mdatalen);
 	} else if (S_ISLNK(inode->i_mode)) {
 		mutex_lock(&f->sem);
 		mdatalen = f->metadata->size;
@@ -66,7 +67,8 @@ int jffs2_do_setattr (struct inode *inode, struct iattr *iattr)
 			return ret;
 		}
 		mutex_unlock(&f->sem);
-		D1(printk(KERN_DEBUG "jffs2_setattr(): Writing %d bytes of symlink target\n", mdatalen));
+		jffs2_dbg(1, "%s(): Writing %d bytes of symlink target\n",
+			  __func__, mdatalen);
 	}
 
 	ri = jffs2_alloc_raw_inode();
@@ -233,7 +235,8 @@ void jffs2_evict_inode (struct inode *inode)
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 
-	D1(printk(KERN_DEBUG "jffs2_evict_inode(): ino #%lu mode %o\n", inode->i_ino, inode->i_mode));
+	jffs2_dbg(1, "%s(): ino #%lu mode %o\n",
+		  __func__, inode->i_ino, inode->i_mode);
 	truncate_inode_pages(&inode->i_data, 0);
 	end_writeback(inode);
 	jffs2_do_clear_inode(c, f);
@@ -249,7 +252,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 	dev_t rdev = 0;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_iget(): ino == %lu\n", ino));
+	jffs2_dbg(1, "%s(): ino == %lu\n", __func__, ino);
 
 	inode = iget_locked(sb, ino);
 	if (!inode)
@@ -320,7 +323,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 			printk(KERN_NOTICE "Device node has strange size %d\n", f->metadata->size);
 			goto error_io;
 		}
-		D1(printk(KERN_DEBUG "Reading device numbers from flash\n"));
+		jffs2_dbg(1, "Reading device numbers from flash\n");
 		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
 		if (ret < 0) {
 			/* Eep */
@@ -344,7 +347,7 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 
 	mutex_unlock(&f->sem);
 
-	D1(printk(KERN_DEBUG "jffs2_read_inode() returning\n"));
+	jffs2_dbg(1, "jffs2_read_inode() returning\n");
 	unlock_new_inode(inode);
 	return inode;
 
@@ -362,11 +365,13 @@ void jffs2_dirty_inode(struct inode *inode, int flags)
 	struct iattr iattr;
 
 	if (!(inode->i_state & I_DIRTY_DATASYNC)) {
-		D2(printk(KERN_DEBUG "jffs2_dirty_inode() not calling setattr() for ino #%lu\n", inode->i_ino));
+		jffs2_dbg(2, "%s(): not calling setattr() for ino #%lu\n",
+			  __func__, inode->i_ino);
 		return;
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_dirty_inode() calling setattr() for ino #%lu\n", inode->i_ino));
+	jffs2_dbg(1, "%s(): calling setattr() for ino #%lu\n",
+		  __func__, inode->i_ino);
 
 	iattr.ia_valid = ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_MTIME|ATTR_CTIME;
 	iattr.ia_mode = inode->i_mode;
@@ -414,7 +419,8 @@ struct inode *jffs2_new_inode (struct inode *dir_i, umode_t mode, struct jffs2_r
 	struct jffs2_inode_info *f;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_new_inode(): dir_i %ld, mode 0x%x\n", dir_i->i_ino, mode));
+	jffs2_dbg(1, "%s(): dir_i %ld, mode 0x%x\n",
+		  __func__, dir_i->i_ino, mode);
 
 	c = JFFS2_SB_INFO(sb);
 
@@ -550,17 +556,17 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	if ((ret = jffs2_do_mount_fs(c)))
 		goto out_inohash;
 
-	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): Getting root inode\n"));
+	jffs2_dbg(1, "%s(): Getting root inode\n", __func__);
 	root_i = jffs2_iget(sb, 1);
 	if (IS_ERR(root_i)) {
-		D1(printk(KERN_WARNING "get root inode failed\n"));
+		jffs2_dbg(1, "get root inode failed\n");
 		ret = PTR_ERR(root_i);
 		goto out_root;
 	}
 
 	ret = -ENOMEM;
 
-	D1(printk(KERN_DEBUG "jffs2_do_fill_super(): d_alloc_root()\n"));
+	jffs2_dbg(1, "%s(): d_alloc_root()\n", __func__);
 	sb->s_root = d_make_root(root_i);
 	if (!sb->s_root)
 		goto out_root;
@@ -618,20 +624,21 @@ struct jffs2_inode_info *jffs2_gc_fetch_inode(struct jffs2_sb_info *c,
 		*/
 		inode = ilookup(OFNI_BS_2SFFJ(c), inum);
 		if (!inode) {
-			D1(printk(KERN_DEBUG "ilookup() failed for ino #%u; inode is probably deleted.\n",
-				  inum));
+			jffs2_dbg(1, "ilookup() failed for ino #%u; inode is probably deleted.\n",
+				  inum);
 
 			spin_lock(&c->inocache_lock);
 			ic = jffs2_get_ino_cache(c, inum);
 			if (!ic) {
-				D1(printk(KERN_DEBUG "Inode cache for ino #%u is gone.\n", inum));
+				jffs2_dbg(1, "Inode cache for ino #%u is gone\n",
+					  inum);
 				spin_unlock(&c->inocache_lock);
 				return NULL;
 			}
 			if (ic->state != INO_STATE_CHECKEDABSENT) {
 				/* Wait for progress. Don't just loop */
-				D1(printk(KERN_DEBUG "Waiting for ino #%u in state %d\n",
-					  ic->ino, ic->state));
+				jffs2_dbg(1, "Waiting for ino #%u in state %d\n",
+					  ic->ino, ic->state);
 				sleep_on_spinunlock(&c->inocache_wq, &c->inocache_lock);
 			} else {
 				spin_unlock(&c->inocache_lock);
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 31dce61..85e703a 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -51,44 +51,44 @@ static struct jffs2_eraseblock *jffs2_find_gc_block(struct jffs2_sb_info *c)
 	   number of free blocks is low. */
 again:
 	if (!list_empty(&c->bad_used_list) && c->nr_free_blocks > c->resv_blocks_gcbad) {
-		D1(printk(KERN_DEBUG "Picking block from bad_used_list to GC next\n"));
+		jffs2_dbg(1, "Picking block from bad_used_list to GC next\n");
 		nextlist = &c->bad_used_list;
 	} else if (n < 50 && !list_empty(&c->erasable_list)) {
 		/* Note that most of them will have gone directly to be erased.
 		   So don't favour the erasable_list _too_ much. */
-		D1(printk(KERN_DEBUG "Picking block from erasable_list to GC next\n"));
+		jffs2_dbg(1, "Picking block from erasable_list to GC next\n");
 		nextlist = &c->erasable_list;
 	} else if (n < 110 && !list_empty(&c->very_dirty_list)) {
 		/* Most of the time, pick one off the very_dirty list */
-		D1(printk(KERN_DEBUG "Picking block from very_dirty_list to GC next\n"));
+		jffs2_dbg(1, "Picking block from very_dirty_list to GC next\n");
 		nextlist = &c->very_dirty_list;
 	} else if (n < 126 && !list_empty(&c->dirty_list)) {
-		D1(printk(KERN_DEBUG "Picking block from dirty_list to GC next\n"));
+		jffs2_dbg(1, "Picking block from dirty_list to GC next\n");
 		nextlist = &c->dirty_list;
 	} else if (!list_empty(&c->clean_list)) {
-		D1(printk(KERN_DEBUG "Picking block from clean_list to GC next\n"));
+		jffs2_dbg(1, "Picking block from clean_list to GC next\n");
 		nextlist = &c->clean_list;
 	} else if (!list_empty(&c->dirty_list)) {
-		D1(printk(KERN_DEBUG "Picking block from dirty_list to GC next (clean_list was empty)\n"));
+		jffs2_dbg(1, "Picking block from dirty_list to GC next (clean_list was empty)\n");
 
 		nextlist = &c->dirty_list;
 	} else if (!list_empty(&c->very_dirty_list)) {
-		D1(printk(KERN_DEBUG "Picking block from very_dirty_list to GC next (clean_list and dirty_list were empty)\n"));
+		jffs2_dbg(1, "Picking block from very_dirty_list to GC next (clean_list and dirty_list were empty)\n");
 		nextlist = &c->very_dirty_list;
 	} else if (!list_empty(&c->erasable_list)) {
-		D1(printk(KERN_DEBUG "Picking block from erasable_list to GC next (clean_list and {very_,}dirty_list were empty)\n"));
+		jffs2_dbg(1, "Picking block from erasable_list to GC next (clean_list and {very_,}dirty_list were empty)\n");
 
 		nextlist = &c->erasable_list;
 	} else if (!list_empty(&c->erasable_pending_wbuf_list)) {
 		/* There are blocks are wating for the wbuf sync */
-		D1(printk(KERN_DEBUG "Synching wbuf in order to reuse erasable_pending_wbuf_list blocks\n"));
+		jffs2_dbg(1, "Synching wbuf in order to reuse erasable_pending_wbuf_list blocks\n");
 		spin_unlock(&c->erase_completion_lock);
 		jffs2_flush_wbuf_pad(c);
 		spin_lock(&c->erase_completion_lock);
 		goto again;
 	} else {
 		/* Eep. All were empty */
-		D1(printk(KERN_NOTICE "jffs2: No clean, dirty _or_ erasable blocks to GC from! Where are they all?\n"));
+		jffs2_dbg(1, "jffs2: No clean, dirty _or_ erasable blocks to GC from! Where are they all?\n");
 		return NULL;
 	}
 
@@ -103,7 +103,8 @@ again:
 
 	/* Have we accidentally picked a clean block with wasted space ? */
 	if (ret->wasted_size) {
-		D1(printk(KERN_DEBUG "Converting wasted_size %08x to dirty_size\n", ret->wasted_size));
+		jffs2_dbg(1, "Converting wasted_size %08x to dirty_size\n",
+			  ret->wasted_size);
 		ret->dirty_size += ret->wasted_size;
 		c->wasted_size -= ret->wasted_size;
 		c->dirty_size += ret->wasted_size;
@@ -163,8 +164,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 		}
 
 		if (!ic->pino_nlink) {
-			D1(printk(KERN_DEBUG "Skipping check of ino #%d with nlink/pino zero\n",
-				  ic->ino));
+			jffs2_dbg(1, "Skipping check of ino #%d with nlink/pino zero\n",
+				  ic->ino);
 			spin_unlock(&c->inocache_lock);
 			jffs2_xattr_delete_inode(c, ic);
 			continue;
@@ -172,7 +173,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 		switch(ic->state) {
 		case INO_STATE_CHECKEDABSENT:
 		case INO_STATE_PRESENT:
-			D1(printk(KERN_DEBUG "Skipping ino #%u already checked\n", ic->ino));
+			jffs2_dbg(1, "Skipping ino #%u already checked\n",
+				  ic->ino);
 			spin_unlock(&c->inocache_lock);
 			continue;
 
@@ -186,7 +188,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 			/* We need to wait for it to finish, lest we move on
 			   and trigger the BUG() above while we haven't yet
 			   finished checking all its nodes */
-			D1(printk(KERN_DEBUG "Waiting for ino #%u to finish reading\n", ic->ino));
+			jffs2_dbg(1, "Waiting for ino #%u to finish reading\n",
+				  ic->ino);
 			/* We need to come back again for the _same_ inode. We've
 			 made no progress in this case, but that should be OK */
 			c->checked_ino--;
@@ -204,7 +207,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 		ic->state = INO_STATE_CHECKING;
 		spin_unlock(&c->inocache_lock);
 
-		D1(printk(KERN_DEBUG "jffs2_garbage_collect_pass() triggering inode scan of ino#%u\n", ic->ino));
+		jffs2_dbg(1, "%s(): triggering inode scan of ino#%u\n",
+			  __func__, ic->ino);
 
 		ret = jffs2_do_crccheck_inode(c, ic);
 		if (ret)
@@ -220,11 +224,11 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 	    !list_empty(&c->erase_pending_list)) {
 		spin_unlock(&c->erase_completion_lock);
 		mutex_unlock(&c->alloc_sem);
-		D1(printk(KERN_DEBUG "jffs2_garbage_collect_pass() erasing pending blocks\n"));
+		jffs2_dbg(1, "%s(): erasing pending blocks\n", __func__);
 		if (jffs2_erase_pending_blocks(c, 1))
 			return 0;
 
-		D1(printk(KERN_DEBUG "No progress from erasing blocks; doing GC anyway\n"));
+		jffs2_dbg(1, "No progress from erasing block; doing GC anyway\n");
 		spin_lock(&c->erase_completion_lock);
 		mutex_lock(&c->alloc_sem);
 	}
@@ -242,13 +246,14 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 			mutex_unlock(&c->alloc_sem);
 			return -EAGAIN;
 		}
-		D1(printk(KERN_NOTICE "jffs2: Couldn't find erase block to garbage collect!\n"));
+		jffs2_dbg(1, "jffs2: Couldn't find erase block to garbage collect!\n");
 		spin_unlock(&c->erase_completion_lock);
 		mutex_unlock(&c->alloc_sem);
 		return -EIO;
 	}
 
-	D1(printk(KERN_DEBUG "GC from block %08x, used_size %08x, dirty_size %08x, free_size %08x\n", jeb->offset, jeb->used_size, jeb->dirty_size, jeb->free_size));
+	jffs2_dbg(1, "GC from block %08x, used_size %08x, dirty_size %08x, free_size %08x\n",
+		  jeb->offset, jeb->used_size, jeb->dirty_size, jeb->free_size);
 	D1(if (c->nextblock)
 	   printk(KERN_DEBUG "Nextblock at  %08x, used_size %08x, dirty_size %08x, wasted_size %08x, free_size %08x\n", c->nextblock->offset, c->nextblock->used_size, c->nextblock->dirty_size, c->nextblock->wasted_size, c->nextblock->free_size));
 
@@ -261,7 +266,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 	gcblock_dirty = jeb->dirty_size;
 
 	while(ref_obsolete(raw)) {
-		D1(printk(KERN_DEBUG "Node at 0x%08x is obsolete... skipping\n", ref_offset(raw)));
+		jffs2_dbg(1, "Node at 0x%08x is obsolete... skipping\n",
+			  ref_offset(raw));
 		raw = ref_next(raw);
 		if (unlikely(!raw)) {
 			printk(KERN_WARNING "eep. End of raw list while still supposedly nodes to GC\n");
@@ -275,7 +281,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 	}
 	jeb->gc_node = raw;
 
-	D1(printk(KERN_DEBUG "Going to garbage collect node at 0x%08x\n", ref_offset(raw)));
+	jffs2_dbg(1, "Going to garbage collect node at 0x%08x\n",
+		  ref_offset(raw));
 
 	if (!raw->next_in_ino) {
 		/* Inode-less node. Clean marker, snapshot or something like that */
@@ -316,7 +323,9 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 
 	spin_unlock(&c->erase_completion_lock);
 
-	D1(printk(KERN_DEBUG "jffs2_garbage_collect_pass collecting from block @0x%08x. Node @0x%08x(%d), ino #%u\n", jeb->offset, ref_offset(raw), ref_flags(raw), ic->ino));
+	jffs2_dbg(1, "%s(): collecting from block @0x%08x. Node @0x%08x(%d), ino #%u\n",
+		  __func__, jeb->offset, ref_offset(raw), ref_flags(raw),
+		  ic->ino);
 
 	/* Three possibilities:
 	   1. Inode is already in-core. We must iget it and do proper
@@ -336,8 +345,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 		if (ref_flags(raw) == REF_PRISTINE)
 			ic->state = INO_STATE_GC;
 		else {
-			D1(printk(KERN_DEBUG "Ino #%u is absent but node not REF_PRISTINE. Reading.\n",
-				  ic->ino));
+			jffs2_dbg(1, "Ino #%u is absent but node not REF_PRISTINE. Reading.\n",
+				  ic->ino);
 		}
 		break;
 
@@ -367,8 +376,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 		   drop the alloc_sem before sleeping. */
 
 		mutex_unlock(&c->alloc_sem);
-		D1(printk(KERN_DEBUG "jffs2_garbage_collect_pass() waiting for ino #%u in state %d\n",
-			  ic->ino, ic->state));
+		jffs2_dbg(1, "%s(): waiting for ino #%u in state %d\n",
+			  __func__, ic->ino, ic->state);
 		sleep_on_spinunlock(&c->inocache_wq, &c->inocache_lock);
 		/* And because we dropped the alloc_sem we must start again from the
 		   beginning. Ponder chance of livelock here -- we're returning success
@@ -445,7 +454,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 
  eraseit:
 	if (c->gcblock && !c->gcblock->used_size) {
-		D1(printk(KERN_DEBUG "Block at 0x%08x completely obsoleted by GC. Moving to erase_pending_list\n", c->gcblock->offset));
+		jffs2_dbg(1, "Block at 0x%08x completely obsoleted by GC. Moving to erase_pending_list\n",
+			  c->gcblock->offset);
 		/* We're GC'ing an empty block? */
 		list_add_tail(&c->gcblock->list, &c->erase_pending_list);
 		c->gcblock = NULL;
@@ -475,12 +485,12 @@ static int jffs2_garbage_collect_live(struct jffs2_sb_info *c,  struct jffs2_era
 
 	if (c->gcblock != jeb) {
 		spin_unlock(&c->erase_completion_lock);
-		D1(printk(KERN_DEBUG "GC block is no longer gcblock. Restart\n"));
+		jffs2_dbg(1, "GC block is no longer gcblock. Restart\n");
 		goto upnout;
 	}
 	if (ref_obsolete(raw)) {
 		spin_unlock(&c->erase_completion_lock);
-		D1(printk(KERN_DEBUG "node to be GC'd was obsoleted in the meantime.\n"));
+		jffs2_dbg(1, "node to be GC'd was obsoleted in the meantime.\n");
 		/* They'll call again */
 		goto upnout;
 	}
@@ -562,7 +572,8 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 	uint32_t crc, rawlen;
 	int retried = 0;
 
-	D1(printk(KERN_DEBUG "Going to GC REF_PRISTINE node at 0x%08x\n", ref_offset(raw)));
+	jffs2_dbg(1, "Going to GC REF_PRISTINE node at 0x%08x\n",
+		  ref_offset(raw));
 
 	alloclen = rawlen = ref_totlen(c, c->gcblock, raw);
 
@@ -671,7 +682,7 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 
 			retried = 1;
 
-			D1(printk(KERN_DEBUG "Retrying failed write of REF_PRISTINE node.\n"));
+			jffs2_dbg(1, "Retrying failed write of REF_PRISTINE node.\n");
 
 			jffs2_dbg_acct_sanity_check(c,jeb);
 			jffs2_dbg_acct_paranoia_check(c, jeb);
@@ -681,14 +692,16 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 							it is only an upper estimation */
 
 			if (!ret) {
-				D1(printk(KERN_DEBUG "Allocated space at 0x%08x to retry failed write.\n", phys_ofs));
+				jffs2_dbg(1, "Allocated space at 0x%08x to retry failed write.\n",
+					  phys_ofs);
 
 				jffs2_dbg_acct_sanity_check(c,jeb);
 				jffs2_dbg_acct_paranoia_check(c, jeb);
 
 				goto retry;
 			}
-			D1(printk(KERN_DEBUG "Failed to allocate space to retry failed write: %d!\n", ret));
+			jffs2_dbg(1, "Failed to allocate space to retry failed write: %d!\n",
+				  ret);
 		}
 
 		if (!ret)
@@ -698,7 +711,8 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 	jffs2_add_physical_node_ref(c, phys_ofs | REF_PRISTINE, rawlen, ic);
 
 	jffs2_mark_node_obsolete(c, raw);
-	D1(printk(KERN_DEBUG "WHEEE! GC REF_PRISTINE node at 0x%08x succeeded\n", ref_offset(raw)));
+	jffs2_dbg(1, "WHEEE! GC REF_PRISTINE node at 0x%08x succeeded\n",
+		  ref_offset(raw));
 
  out_node:
 	kfree(node);
@@ -725,7 +739,8 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 		/* For these, we don't actually need to read the old node */
 		mdatalen = jffs2_encode_dev(&dev, JFFS2_F_I_RDEV(f));
 		mdata = (char *)&dev;
-		D1(printk(KERN_DEBUG "jffs2_garbage_collect_metadata(): Writing %d bytes of kdev_t\n", mdatalen));
+		jffs2_dbg(1, "%s(): Writing %d bytes of kdev_t\n",
+			  __func__, mdatalen);
 	} else if (S_ISLNK(JFFS2_F_I_MODE(f))) {
 		mdatalen = fn->size;
 		mdata = kmalloc(fn->size, GFP_KERNEL);
@@ -739,7 +754,8 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 			kfree(mdata);
 			return ret;
 		}
-		D1(printk(KERN_DEBUG "jffs2_garbage_collect_metadata(): Writing %d bites of symlink target\n", mdatalen));
+		jffs2_dbg(1, "%s(): Writing %d bites of symlink target\n",
+			  __func__, mdatalen);
 
 	}
 
@@ -887,7 +903,8 @@ static int jffs2_garbage_collect_deletion_dirent(struct jffs2_sb_info *c, struct
 			if (SECTOR_ADDR(raw->flash_offset) == SECTOR_ADDR(fd->raw->flash_offset))
 				continue;
 
-			D1(printk(KERN_DEBUG "Check potential deletion dirent at %08x\n", ref_offset(raw)));
+			jffs2_dbg(1, "Check potential deletion dirent at %08x\n",
+				  ref_offset(raw));
 
 			/* This is an obsolete node belonging to the same directory, and it's of the right
 			   length. We need to take a closer look...*/
@@ -923,8 +940,9 @@ static int jffs2_garbage_collect_deletion_dirent(struct jffs2_sb_info *c, struct
 			   a new deletion dirent to replace it */
 			mutex_unlock(&c->erase_free_sem);
 
-			D1(printk(KERN_DEBUG "Deletion dirent at %08x still obsoletes real dirent \"%s\" at %08x for ino #%u\n",
-				  ref_offset(fd->raw), fd->name, ref_offset(raw), je32_to_cpu(rd->ino)));
+			jffs2_dbg(1, "Deletion dirent at %08x still obsoletes real dirent \"%s\" at %08x for ino #%u\n",
+				  ref_offset(fd->raw), fd->name,
+				  ref_offset(raw), je32_to_cpu(rd->ino));
 			kfree(rd);
 
 			return jffs2_garbage_collect_dirent(c, jeb, f, fd);
@@ -964,8 +982,8 @@ static int jffs2_garbage_collect_hole(struct jffs2_sb_info *c, struct jffs2_eras
 	uint32_t alloclen, ilen;
 	int ret;
 
-	D1(printk(KERN_DEBUG "Writing replacement hole node for ino #%u from offset 0x%x to 0x%x\n",
-		  f->inocache->ino, start, end));
+	jffs2_dbg(1, "Writing replacement hole node for ino #%u from offset 0x%x to 0x%x\n",
+		  f->inocache->ino, start, end);
 
 	memset(&ri, 0, sizeof(ri));
 
@@ -1117,8 +1135,8 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 
 	memset(&ri, 0, sizeof(ri));
 
-	D1(printk(KERN_DEBUG "Writing replacement dnode for ino #%u from offset 0x%x to 0x%x\n",
-		  f->inocache->ino, start, end));
+	jffs2_dbg(1, "Writing replacement dnode for ino #%u from offset 0x%x to 0x%x\n",
+		  f->inocache->ino, start, end);
 
 	orig_end = end;
 	orig_start = start;
@@ -1149,15 +1167,15 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 			/* If the previous frag doesn't even reach the beginning, there's
 			   excessive fragmentation. Just merge. */
 			if (frag->ofs > min) {
-				D1(printk(KERN_DEBUG "Expanding down to cover partial frag (0x%x-0x%x)\n",
-					  frag->ofs, frag->ofs+frag->size));
+				jffs2_dbg(1, "Expanding down to cover partial frag (0x%x-0x%x)\n",
+					  frag->ofs, frag->ofs+frag->size);
 				start = frag->ofs;
 				continue;
 			}
 			/* OK. This frag holds the first byte of the page. */
 			if (!frag->node || !frag->node->raw) {
-				D1(printk(KERN_DEBUG "First frag in page is hole (0x%x-0x%x). Not expanding down.\n",
-					  frag->ofs, frag->ofs+frag->size));
+				jffs2_dbg(1, "First frag in page is hole (0x%x-0x%x). Not expanding down.\n",
+					  frag->ofs, frag->ofs+frag->size);
 				break;
 			} else {
 
@@ -1171,19 +1189,25 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 				jeb = &c->blocks[raw->flash_offset / c->sector_size];
 
 				if (jeb == c->gcblock) {
-					D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in gcblock at %08x\n",
-						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
+					jffs2_dbg(1, "Expanding down to cover frag (0x%x-0x%x) in gcblock at %08x\n",
+						  frag->ofs,
+						  frag->ofs + frag->size,
+						  ref_offset(raw));
 					start = frag->ofs;
 					break;
 				}
 				if (!ISDIRTY(jeb->dirty_size + jeb->wasted_size)) {
-					D1(printk(KERN_DEBUG "Not expanding down to cover frag (0x%x-0x%x) in clean block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+					jffs2_dbg(1, "Not expanding down to cover frag (0x%x-0x%x) in clean block %08x\n",
+						  frag->ofs,
+						  frag->ofs + frag->size,
+						  jeb->offset);
 					break;
 				}
 
-				D1(printk(KERN_DEBUG "Expanding down to cover frag (0x%x-0x%x) in dirty block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+				jffs2_dbg(1, "Expanding down to cover frag (0x%x-0x%x) in dirty block %08x\n",
+					  frag->ofs,
+					  frag->ofs + frag->size,
+					  jeb->offset);
 				start = frag->ofs;
 				break;
 			}
@@ -1199,15 +1223,15 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 			/* If the previous frag doesn't even reach the beginning, there's lots
 			   of fragmentation. Just merge. */
 			if (frag->ofs+frag->size < max) {
-				D1(printk(KERN_DEBUG "Expanding up to cover partial frag (0x%x-0x%x)\n",
-					  frag->ofs, frag->ofs+frag->size));
+				jffs2_dbg(1, "Expanding up to cover partial frag (0x%x-0x%x)\n",
+					  frag->ofs, frag->ofs+frag->size);
 				end = frag->ofs + frag->size;
 				continue;
 			}
 
 			if (!frag->node || !frag->node->raw) {
-				D1(printk(KERN_DEBUG "Last frag in page is hole (0x%x-0x%x). Not expanding up.\n",
-					  frag->ofs, frag->ofs+frag->size));
+				jffs2_dbg(1, "Last frag in page is hole (0x%x-0x%x). Not expanding up.\n",
+					  frag->ofs, frag->ofs+frag->size);
 				break;
 			} else {
 
@@ -1221,25 +1245,31 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 				jeb = &c->blocks[raw->flash_offset / c->sector_size];
 
 				if (jeb == c->gcblock) {
-					D1(printk(KERN_DEBUG "Expanding up to cover frag (0x%x-0x%x) in gcblock at %08x\n",
-						  frag->ofs, frag->ofs+frag->size, ref_offset(raw)));
+					jffs2_dbg(1, "Expanding up to cover frag (0x%x-0x%x) in gcblock at %08x\n",
+						  frag->ofs,
+						  frag->ofs + frag->size,
+						  ref_offset(raw));
 					end = frag->ofs + frag->size;
 					break;
 				}
 				if (!ISDIRTY(jeb->dirty_size + jeb->wasted_size)) {
-					D1(printk(KERN_DEBUG "Not expanding up to cover frag (0x%x-0x%x) in clean block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+					jffs2_dbg(1, "Not expanding up to cover frag (0x%x-0x%x) in clean block %08x\n",
+						  frag->ofs,
+						  frag->ofs + frag->size,
+						  jeb->offset);
 					break;
 				}
 
-				D1(printk(KERN_DEBUG "Expanding up to cover frag (0x%x-0x%x) in dirty block %08x\n",
-						  frag->ofs, frag->ofs+frag->size, jeb->offset));
+				jffs2_dbg(1, "Expanding up to cover frag (0x%x-0x%x) in dirty block %08x\n",
+					  frag->ofs,
+					  frag->ofs + frag->size,
+					  jeb->offset);
 				end = frag->ofs + frag->size;
 				break;
 			}
 		}
-		D1(printk(KERN_DEBUG "Expanded dnode to write from (0x%x-0x%x) to (0x%x-0x%x)\n",
-			  orig_start, orig_end, start, end));
+		jffs2_dbg(1, "Expanded dnode to write from (0x%x-0x%x) to (0x%x-0x%x)\n",
+			  orig_start, orig_end, start, end);
 
 		D1(BUG_ON(end > frag_last(&f->fragtree)->ofs + frag_last(&f->fragtree)->size));
 		BUG_ON(end < orig_end);
diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 694aa5b..d76a268 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -46,10 +46,10 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 	/* align it */
 	minsize = PAD(minsize);
 
-	D1(printk(KERN_DEBUG "jffs2_reserve_space(): Requested 0x%x bytes\n", minsize));
+	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
 	mutex_lock(&c->alloc_sem);
 
-	D1(printk(KERN_DEBUG "jffs2_reserve_space(): alloc sem got\n"));
+	jffs2_dbg(1, "%s(): alloc sem got\n", __func__);
 
 	spin_lock(&c->erase_completion_lock);
 
@@ -73,11 +73,13 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 			dirty = c->dirty_size + c->erasing_size - c->nr_erasing_blocks * c->sector_size + c->unchecked_size;
 			if (dirty < c->nospc_dirty_size) {
 				if (prio == ALLOC_DELETION && c->nr_free_blocks + c->nr_erasing_blocks >= c->resv_blocks_deletion) {
-					D1(printk(KERN_NOTICE "jffs2_reserve_space(): Low on dirty space to GC, but it's a deletion. Allowing...\n"));
+					jffs2_dbg(1, "%s(): Low on dirty space to GC, but it's a deletion. Allowing...\n",
+						  __func__);
 					break;
 				}
-				D1(printk(KERN_DEBUG "dirty size 0x%08x + unchecked_size 0x%08x < nospc_dirty_size 0x%08x, returning -ENOSPC\n",
-					  dirty, c->unchecked_size, c->sector_size));
+				jffs2_dbg(1, "dirty size 0x%08x + unchecked_size 0x%08x < nospc_dirty_size 0x%08x, returning -ENOSPC\n",
+					  dirty, c->unchecked_size,
+					  c->sector_size);
 
 				spin_unlock(&c->erase_completion_lock);
 				mutex_unlock(&c->alloc_sem);
@@ -96,12 +98,13 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 			avail = c->free_size + c->dirty_size + c->erasing_size + c->unchecked_size;
 			if ( (avail / c->sector_size) <= blocksneeded) {
 				if (prio == ALLOC_DELETION && c->nr_free_blocks + c->nr_erasing_blocks >= c->resv_blocks_deletion) {
-					D1(printk(KERN_NOTICE "jffs2_reserve_space(): Low on possibly available space, but it's a deletion. Allowing...\n"));
+					jffs2_dbg(1, "%s(): Low on possibly available space, but it's a deletion. Allowing...\n",
+						  __func__);
 					break;
 				}
 
-				D1(printk(KERN_DEBUG "max. available size 0x%08x  < blocksneeded * sector_size 0x%08x, returning -ENOSPC\n",
-					  avail, blocksneeded * c->sector_size));
+				jffs2_dbg(1, "max. available size 0x%08x  < blocksneeded * sector_size 0x%08x, returning -ENOSPC\n",
+					  avail, blocksneeded * c->sector_size);
 				spin_unlock(&c->erase_completion_lock);
 				mutex_unlock(&c->alloc_sem);
 				return -ENOSPC;
@@ -109,9 +112,14 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 
 			mutex_unlock(&c->alloc_sem);
 
-			D1(printk(KERN_DEBUG "Triggering GC pass. nr_free_blocks %d, nr_erasing_blocks %d, free_size 0x%08x, dirty_size 0x%08x, wasted_size 0x%08x, used_size 0x%08x, erasing_size 0x%08x, bad_size 0x%08x (total 0x%08x of 0x%08x)\n",
-				  c->nr_free_blocks, c->nr_erasing_blocks, c->free_size, c->dirty_size, c->wasted_size, c->used_size, c->erasing_size, c->bad_size,
-				  c->free_size + c->dirty_size + c->wasted_size + c->used_size + c->erasing_size + c->bad_size, c->flash_size));
+			jffs2_dbg(1, "Triggering GC pass. nr_free_blocks %d, nr_erasing_blocks %d, free_size 0x%08x, dirty_size 0x%08x, wasted_size 0x%08x, used_size 0x%08x, erasing_size 0x%08x, bad_size 0x%08x (total 0x%08x of 0x%08x)\n",
+				  c->nr_free_blocks, c->nr_erasing_blocks,
+				  c->free_size, c->dirty_size, c->wasted_size,
+				  c->used_size, c->erasing_size, c->bad_size,
+				  c->free_size + c->dirty_size +
+				  c->wasted_size + c->used_size +
+				  c->erasing_size + c->bad_size,
+				  c->flash_size);
 			spin_unlock(&c->erase_completion_lock);
 
 			ret = jffs2_garbage_collect_pass(c);
@@ -124,7 +132,8 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 					DECLARE_WAITQUEUE(wait, current);
 					set_current_state(TASK_UNINTERRUPTIBLE);
 					add_wait_queue(&c->erase_wait, &wait);
-					D1(printk(KERN_DEBUG "%s waiting for erase to complete\n", __func__));
+					jffs2_dbg(1, "%s waiting for erase to complete\n",
+						  __func__);
 					spin_unlock(&c->erase_completion_lock);
 
 					schedule();
@@ -144,7 +153,7 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 
 		ret = jffs2_do_reserve_space(c, minsize, len, sumsize);
 		if (ret) {
-			D1(printk(KERN_DEBUG "jffs2_reserve_space: ret is %d\n", ret));
+			jffs2_dbg(1, "%s(): ret is %d\n", __func__, ret);
 		}
 	}
 	spin_unlock(&c->erase_completion_lock);
@@ -161,13 +170,14 @@ int jffs2_reserve_space_gc(struct jffs2_sb_info *c, uint32_t minsize,
 	int ret = -EAGAIN;
 	minsize = PAD(minsize);
 
-	D1(printk(KERN_DEBUG "jffs2_reserve_space_gc(): Requested 0x%x bytes\n", minsize));
+	jffs2_dbg(1, "%s(): Requested 0x%x bytes\n", __func__, minsize);
 
 	spin_lock(&c->erase_completion_lock);
 	while(ret == -EAGAIN) {
 		ret = jffs2_do_reserve_space(c, minsize, len, sumsize);
 		if (ret) {
-			D1(printk(KERN_DEBUG "jffs2_reserve_space_gc: looping, ret is %d\n", ret));
+			jffs2_dbg(1, "%s(): looping, ret is %d\n",
+				  __func__, ret);
 		}
 	}
 	spin_unlock(&c->erase_completion_lock);
@@ -184,8 +194,8 @@ static void jffs2_close_nextblock(struct jffs2_sb_info *c, struct jffs2_eraseblo
 {
 
 	if (c->nextblock == NULL) {
-		D1(printk(KERN_DEBUG "jffs2_close_nextblock: Erase block at 0x%08x has already been placed in a list\n",
-		  jeb->offset));
+		jffs2_dbg(1, "%s(): Erase block at 0x%08x has already been placed in a list\n",
+			  __func__, jeb->offset);
 		return;
 	}
 	/* Check, if we have a dirty block now, or if it was dirty already */
@@ -195,17 +205,20 @@ static void jffs2_close_nextblock(struct jffs2_sb_info *c, struct jffs2_eraseblo
 		jeb->dirty_size += jeb->wasted_size;
 		jeb->wasted_size = 0;
 		if (VERYDIRTY(c, jeb->dirty_size)) {
-			D1(printk(KERN_DEBUG "Adding full erase block at 0x%08x to very_dirty_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
-			  jeb->offset, jeb->free_size, jeb->dirty_size, jeb->used_size));
+			jffs2_dbg(1, "Adding full erase block at 0x%08x to very_dirty_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
+				  jeb->offset, jeb->free_size, jeb->dirty_size,
+				  jeb->used_size);
 			list_add_tail(&jeb->list, &c->very_dirty_list);
 		} else {
-			D1(printk(KERN_DEBUG "Adding full erase block at 0x%08x to dirty_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
-			  jeb->offset, jeb->free_size, jeb->dirty_size, jeb->used_size));
+			jffs2_dbg(1, "Adding full erase block at 0x%08x to dirty_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
+				  jeb->offset, jeb->free_size, jeb->dirty_size,
+				  jeb->used_size);
 			list_add_tail(&jeb->list, &c->dirty_list);
 		}
 	} else {
-		D1(printk(KERN_DEBUG "Adding full erase block at 0x%08x to clean_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
-		  jeb->offset, jeb->free_size, jeb->dirty_size, jeb->used_size));
+		jffs2_dbg(1, "Adding full erase block at 0x%08x to clean_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
+			  jeb->offset, jeb->free_size, jeb->dirty_size,
+			  jeb->used_size);
 		list_add_tail(&jeb->list, &c->clean_list);
 	}
 	c->nextblock = NULL;
@@ -230,13 +243,14 @@ static int jffs2_find_nextblock(struct jffs2_sb_info *c)
 			list_move_tail(&ejeb->list, &c->erase_pending_list);
 			c->nr_erasing_blocks++;
 			jffs2_garbage_collect_trigger(c);
-			D1(printk(KERN_DEBUG "jffs2_find_nextblock: Triggering erase of erasable block at 0x%08x\n",
-				  ejeb->offset));
+			jffs2_dbg(1, "%s(): Triggering erase of erasable block at 0x%08x\n",
+				  __func__, ejeb->offset);
 		}
 
 		if (!c->nr_erasing_blocks &&
 			!list_empty(&c->erasable_pending_wbuf_list)) {
-			D1(printk(KERN_DEBUG "jffs2_find_nextblock: Flushing write buffer\n"));
+			jffs2_dbg(1, "%s(): Flushing write buffer\n",
+				  __func__);
 			/* c->nextblock is NULL, no update to c->nextblock allowed */
 			spin_unlock(&c->erase_completion_lock);
 			jffs2_flush_wbuf_pad(c);
@@ -278,7 +292,8 @@ static int jffs2_find_nextblock(struct jffs2_sb_info *c)
 		c->wbuf_ofs = 0xffffffff;
 #endif
 
-	D1(printk(KERN_DEBUG "jffs2_find_nextblock(): new nextblock = 0x%08x\n", c->nextblock->offset));
+	jffs2_dbg(1, "%s(): new nextblock = 0x%08x\n",
+		  __func__, c->nextblock->offset);
 
 	return 0;
 }
@@ -345,7 +360,8 @@ static int jffs2_do_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 
 			if (jffs2_wbuf_dirty(c)) {
 				spin_unlock(&c->erase_completion_lock);
-				D1(printk(KERN_DEBUG "jffs2_do_reserve_space: Flushing write buffer\n"));
+				jffs2_dbg(1, "%s(): Flushing write buffer\n",
+					  __func__);
 				jffs2_flush_wbuf_pad(c);
 				spin_lock(&c->erase_completion_lock);
 				jeb = c->nextblock;
@@ -408,8 +424,9 @@ static int jffs2_do_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 		spin_lock(&c->erase_completion_lock);
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_do_reserve_space(): Giving 0x%x bytes at 0x%x\n",
-		  *len, jeb->offset + (c->sector_size - jeb->free_size)));
+	jffs2_dbg(1, "%s(): Giving 0x%x bytes at 0x%x\n",
+		  __func__,
+		  *len, jeb->offset + (c->sector_size - jeb->free_size));
 	return 0;
 }
 
@@ -434,8 +451,8 @@ struct jffs2_raw_node_ref *jffs2_add_physical_node_ref(struct jffs2_sb_info *c,
 
 	jeb = &c->blocks[ofs / c->sector_size];
 
-	D1(printk(KERN_DEBUG "jffs2_add_physical_node_ref(): Node at 0x%x(%d), size 0x%x\n",
-		  ofs & ~3, ofs & 3, len));
+	jffs2_dbg(1, "%s(): Node at 0x%x(%d), size 0x%x\n",
+		  __func__, ofs & ~3, ofs & 3, len);
 #if 1
 	/* Allow non-obsolete nodes only to be added at the end of c->nextblock, 
 	   if c->nextblock is set. Note that wbuf.c will file obsolete nodes
@@ -457,8 +474,9 @@ struct jffs2_raw_node_ref *jffs2_add_physical_node_ref(struct jffs2_sb_info *c,
 
 	if (!jeb->free_size && !jeb->dirty_size && !ISDIRTY(jeb->wasted_size)) {
 		/* If it lives on the dirty_list, jffs2_reserve_space will put it there */
-		D1(printk(KERN_DEBUG "Adding full erase block at 0x%08x to clean_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
-			  jeb->offset, jeb->free_size, jeb->dirty_size, jeb->used_size));
+		jffs2_dbg(1, "Adding full erase block at 0x%08x to clean_list (free 0x%08x, dirty 0x%08x, used 0x%08x\n",
+			  jeb->offset, jeb->free_size, jeb->dirty_size,
+			  jeb->used_size);
 		if (jffs2_wbuf_dirty(c)) {
 			/* Flush the last write in the block if it's outstanding */
 			spin_unlock(&c->erase_completion_lock);
@@ -480,7 +498,7 @@ struct jffs2_raw_node_ref *jffs2_add_physical_node_ref(struct jffs2_sb_info *c,
 
 void jffs2_complete_reservation(struct jffs2_sb_info *c)
 {
-	D1(printk(KERN_DEBUG "jffs2_complete_reservation()\n"));
+	jffs2_dbg(1, "jffs2_complete_reservation()\n");
 	spin_lock(&c->erase_completion_lock);
 	jffs2_garbage_collect_trigger(c);
 	spin_unlock(&c->erase_completion_lock);
@@ -493,7 +511,7 @@ static inline int on_list(struct list_head *obj, struct list_head *head)
 
 	list_for_each(this, head) {
 		if (this == obj) {
-			D1(printk("%p is on list at %p\n", obj, head));
+			jffs2_dbg(1, "%p is on list at %p\n", obj, head);
 			return 1;
 
 		}
@@ -515,7 +533,8 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 		return;
 	}
 	if (ref_obsolete(ref)) {
-		D1(printk(KERN_DEBUG "jffs2_mark_node_obsolete called with already obsolete node at 0x%08x\n", ref_offset(ref)));
+		jffs2_dbg(1, "%s(): called with already obsolete node at 0x%08x\n",
+			  __func__, ref_offset(ref));
 		return;
 	}
 	blocknr = ref->flash_offset / c->sector_size;
@@ -546,7 +565,8 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 			       freed_len, blocknr, ref->flash_offset, jeb->used_size);
 			BUG();
 		})
-		D1(printk(KERN_DEBUG "Obsoleting previously unchecked node at 0x%08x of len %x: ", ref_offset(ref), freed_len));
+			jffs2_dbg(1, "Obsoleting previously unchecked node at 0x%08x of len %x\n",
+				  ref_offset(ref), freed_len);
 		jeb->unchecked_size -= freed_len;
 		c->unchecked_size -= freed_len;
 	} else {
@@ -555,14 +575,15 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 			       freed_len, blocknr, ref->flash_offset, jeb->used_size);
 			BUG();
 		})
-		D1(printk(KERN_DEBUG "Obsoleting node at 0x%08x of len %#x: ", ref_offset(ref), freed_len));
+			jffs2_dbg(1, "Obsoleting node at 0x%08x of len %#x: ",
+				  ref_offset(ref), freed_len);
 		jeb->used_size -= freed_len;
 		c->used_size -= freed_len;
 	}
 
 	// Take care, that wasted size is taken into concern
 	if ((jeb->dirty_size || ISDIRTY(jeb->wasted_size + freed_len)) && jeb != c->nextblock) {
-		D1(printk("Dirtying\n"));
+		jffs2_dbg(1, "Dirtying\n");
 		addedsize = freed_len;
 		jeb->dirty_size += freed_len;
 		c->dirty_size += freed_len;
@@ -570,12 +591,12 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 		/* Convert wasted space to dirty, if not a bad block */
 		if (jeb->wasted_size) {
 			if (on_list(&jeb->list, &c->bad_used_list)) {
-				D1(printk(KERN_DEBUG "Leaving block at %08x on the bad_used_list\n",
-					  jeb->offset));
+				jffs2_dbg(1, "Leaving block at %08x on the bad_used_list\n",
+					  jeb->offset);
 				addedsize = 0; /* To fool the refiling code later */
 			} else {
-				D1(printk(KERN_DEBUG "Converting %d bytes of wasted space to dirty in block at %08x\n",
-					  jeb->wasted_size, jeb->offset));
+				jffs2_dbg(1, "Converting %d bytes of wasted space to dirty in block at %08x\n",
+					  jeb->wasted_size, jeb->offset);
 				addedsize += jeb->wasted_size;
 				jeb->dirty_size += jeb->wasted_size;
 				c->dirty_size += jeb->wasted_size;
@@ -584,7 +605,7 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 			}
 		}
 	} else {
-		D1(printk("Wasting\n"));
+		jffs2_dbg(1, "Wasting\n");
 		addedsize = 0;
 		jeb->wasted_size += freed_len;
 		c->wasted_size += freed_len;
@@ -606,50 +627,57 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 	}
 
 	if (jeb == c->nextblock) {
-		D2(printk(KERN_DEBUG "Not moving nextblock 0x%08x to dirty/erase_pending list\n", jeb->offset));
+		jffs2_dbg(2, "Not moving nextblock 0x%08x to dirty/erase_pending list\n",
+			  jeb->offset);
 	} else if (!jeb->used_size && !jeb->unchecked_size) {
 		if (jeb == c->gcblock) {
-			D1(printk(KERN_DEBUG "gcblock at 0x%08x completely dirtied. Clearing gcblock...\n", jeb->offset));
+			jffs2_dbg(1, "gcblock at 0x%08x completely dirtied. Clearing gcblock...\n",
+				  jeb->offset);
 			c->gcblock = NULL;
 		} else {
-			D1(printk(KERN_DEBUG "Eraseblock at 0x%08x completely dirtied. Removing from (dirty?) list...\n", jeb->offset));
+			jffs2_dbg(1, "Eraseblock at 0x%08x completely dirtied. Removing from (dirty?) list...\n",
+				  jeb->offset);
 			list_del(&jeb->list);
 		}
 		if (jffs2_wbuf_dirty(c)) {
-			D1(printk(KERN_DEBUG "...and adding to erasable_pending_wbuf_list\n"));
+			jffs2_dbg(1, "...and adding to erasable_pending_wbuf_list\n");
 			list_add_tail(&jeb->list, &c->erasable_pending_wbuf_list);
 		} else {
 			if (jiffies & 127) {
 				/* Most of the time, we just erase it immediately. Otherwise we
 				   spend ages scanning it on mount, etc. */
-				D1(printk(KERN_DEBUG "...and adding to erase_pending_list\n"));
+				jffs2_dbg(1, "...and adding to erase_pending_list\n");
 				list_add_tail(&jeb->list, &c->erase_pending_list);
 				c->nr_erasing_blocks++;
 				jffs2_garbage_collect_trigger(c);
 			} else {
 				/* Sometimes, however, we leave it elsewhere so it doesn't get
 				   immediately reused, and we spread the load a bit. */
-				D1(printk(KERN_DEBUG "...and adding to erasable_list\n"));
+				jffs2_dbg(1, "...and adding to erasable_list\n");
 				list_add_tail(&jeb->list, &c->erasable_list);
 			}
 		}
-		D1(printk(KERN_DEBUG "Done OK\n"));
+		jffs2_dbg(1, "Done OK\n");
 	} else if (jeb == c->gcblock) {
-		D2(printk(KERN_DEBUG "Not moving gcblock 0x%08x to dirty_list\n", jeb->offset));
+		jffs2_dbg(2, "Not moving gcblock 0x%08x to dirty_list\n",
+			  jeb->offset);
 	} else if (ISDIRTY(jeb->dirty_size) && !ISDIRTY(jeb->dirty_size - addedsize)) {
-		D1(printk(KERN_DEBUG "Eraseblock at 0x%08x is freshly dirtied. Removing from clean list...\n", jeb->offset));
+		jffs2_dbg(1, "Eraseblock at 0x%08x is freshly dirtied. Removing from clean list...\n",
+			  jeb->offset);
 		list_del(&jeb->list);
-		D1(printk(KERN_DEBUG "...and adding to dirty_list\n"));
+		jffs2_dbg(1, "...and adding to dirty_list\n");
 		list_add_tail(&jeb->list, &c->dirty_list);
 	} else if (VERYDIRTY(c, jeb->dirty_size) &&
 		   !VERYDIRTY(c, jeb->dirty_size - addedsize)) {
-		D1(printk(KERN_DEBUG "Eraseblock at 0x%08x is now very dirty. Removing from dirty list...\n", jeb->offset));
+		jffs2_dbg(1, "Eraseblock at 0x%08x is now very dirty. Removing from dirty list...\n",
+			  jeb->offset);
 		list_del(&jeb->list);
-		D1(printk(KERN_DEBUG "...and adding to very_dirty_list\n"));
+		jffs2_dbg(1, "...and adding to very_dirty_list\n");
 		list_add_tail(&jeb->list, &c->very_dirty_list);
 	} else {
-		D1(printk(KERN_DEBUG "Eraseblock at 0x%08x not moved anywhere. (free 0x%08x, dirty 0x%08x, used 0x%08x)\n",
-			  jeb->offset, jeb->free_size, jeb->dirty_size, jeb->used_size));
+		jffs2_dbg(1, "Eraseblock at 0x%08x not moved anywhere. (free 0x%08x, dirty 0x%08x, used 0x%08x)\n",
+			  jeb->offset, jeb->free_size, jeb->dirty_size,
+			  jeb->used_size);
 	}
 
 	spin_unlock(&c->erase_completion_lock);
@@ -665,7 +693,8 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 	   the block hasn't _already_ been erased, and that 'ref' itself hasn't been freed yet
 	   by jffs2_free_jeb_node_refs() in erase.c. Which is nice. */
 
-	D1(printk(KERN_DEBUG "obliterating obsoleted node at 0x%08x\n", ref_offset(ref)));
+	jffs2_dbg(1, "obliterating obsoleted node at 0x%08x\n",
+		  ref_offset(ref));
 	ret = jffs2_flash_read(c, ref_offset(ref), sizeof(n), &retlen, (char *)&n);
 	if (ret) {
 		printk(KERN_WARNING "Read error reading from obsoleted node at 0x%08x: %d\n", ref_offset(ref), ret);
@@ -680,7 +709,8 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 		goto out_erase_sem;
 	}
 	if (!(je16_to_cpu(n.nodetype) & JFFS2_NODE_ACCURATE)) {
-		D1(printk(KERN_DEBUG "Node at 0x%08x was already marked obsolete (nodetype 0x%04x)\n", ref_offset(ref), je16_to_cpu(n.nodetype)));
+		jffs2_dbg(1, "Node at 0x%08x was already marked obsolete (nodetype 0x%04x)\n",
+			  ref_offset(ref), je16_to_cpu(n.nodetype));
 		goto out_erase_sem;
 	}
 	/* XXX FIXME: This is ugly now */
@@ -751,8 +781,8 @@ int jffs2_thread_should_wake(struct jffs2_sb_info *c)
 		return 1;
 
 	if (c->unchecked_size) {
-		D1(printk(KERN_DEBUG "jffs2_thread_should_wake(): unchecked_size %d, checked_ino #%d\n",
-			  c->unchecked_size, c->checked_ino));
+		jffs2_dbg(1, "jffs2_thread_should_wake(): unchecked_size %d, checked_ino #%d\n",
+			  c->unchecked_size, c->checked_ino);
 		return 1;
 	}
 
@@ -780,8 +810,9 @@ int jffs2_thread_should_wake(struct jffs2_sb_info *c)
 		}
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_thread_should_wake(): nr_free_blocks %d, nr_erasing_blocks %d, dirty_size 0x%x, vdirty_blocks %d: %s\n",
-		  c->nr_free_blocks, c->nr_erasing_blocks, c->dirty_size, nr_very_dirty, ret?"yes":"no"));
+	jffs2_dbg(1, "%s(): nr_free_blocks %d, nr_erasing_blocks %d, dirty_size 0x%x, vdirty_blocks %d: %s\n",
+		  __func__, c->nr_free_blocks, c->nr_erasing_blocks,
+		  c->dirty_size, nr_very_dirty, ret ? "yes" : "no");
 
 	return ret;
 }
diff --git a/fs/jffs2/read.c b/fs/jffs2/read.c
index 3f39be1..835dc5d 100644
--- a/fs/jffs2/read.c
+++ b/fs/jffs2/read.c
@@ -47,10 +47,10 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	}
 	crc = crc32(0, ri, sizeof(*ri)-8);
 
-	D1(printk(KERN_DEBUG "Node read from %08x: node_crc %08x, calculated CRC %08x. dsize %x, csize %x, offset %x, buf %p\n",
+	jffs2_dbg(1, "Node read from %08x: node_crc %08x, calculated CRC %08x. dsize %x, csize %x, offset %x, buf %p\n",
 		  ref_offset(fd->raw), je32_to_cpu(ri->node_crc),
 		  crc, je32_to_cpu(ri->dsize), je32_to_cpu(ri->csize),
-		  je32_to_cpu(ri->offset), buf));
+		  je32_to_cpu(ri->offset), buf);
 	if (crc != je32_to_cpu(ri->node_crc)) {
 		printk(KERN_WARNING "Node CRC %08x != calculated CRC %08x for node at %08x\n",
 		       je32_to_cpu(ri->node_crc), crc, ref_offset(fd->raw));
@@ -107,8 +107,8 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		decomprbuf = readbuf;
 	}
 
-	D2(printk(KERN_DEBUG "Read %d bytes to %p\n", je32_to_cpu(ri->csize),
-		  readbuf));
+	jffs2_dbg(2, "Read %d bytes to %p\n", je32_to_cpu(ri->csize),
+		  readbuf);
 	ret = jffs2_flash_read(c, (ref_offset(fd->raw)) + sizeof(*ri),
 			       je32_to_cpu(ri->csize), &readlen, readbuf);
 
@@ -124,10 +124,11 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		ret = -EIO;
 		goto out_decomprbuf;
 	}
-	D2(printk(KERN_DEBUG "Data CRC matches calculated CRC %08x\n", crc));
+	jffs2_dbg(2, "Data CRC matches calculated CRC %08x\n", crc);
 	if (ri->compr != JFFS2_COMPR_NONE) {
-		D2(printk(KERN_DEBUG "Decompress %d bytes from %p to %d bytes at %p\n",
-			  je32_to_cpu(ri->csize), readbuf, je32_to_cpu(ri->dsize), decomprbuf));
+		jffs2_dbg(2, "Decompress %d bytes from %p to %d bytes at %p\n",
+			  je32_to_cpu(ri->csize), readbuf,
+			  je32_to_cpu(ri->dsize), decomprbuf);
 		ret = jffs2_decompress(c, f, ri->compr | (ri->usercompr << 8), readbuf, decomprbuf, je32_to_cpu(ri->csize), je32_to_cpu(ri->dsize));
 		if (ret) {
 			printk(KERN_WARNING "Error: jffs2_decompress returned %d\n", ret);
@@ -157,8 +158,8 @@ int jffs2_read_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	struct jffs2_node_frag *frag;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_read_inode_range: ino #%u, range 0x%08x-0x%08x\n",
-		  f->inocache->ino, offset, offset+len));
+	jffs2_dbg(1, "%s(): ino #%u, range 0x%08x-0x%08x\n",
+		  __func__, f->inocache->ino, offset, offset + len);
 
 	frag = jffs2_lookup_node_frag(&f->fragtree, offset);
 
@@ -168,22 +169,27 @@ int jffs2_read_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	 * (or perhaps is before it, if we've been asked to read off the
 	 * end of the file). */
 	while(offset < end) {
-		D2(printk(KERN_DEBUG "jffs2_read_inode_range: offset %d, end %d\n", offset, end));
+		jffs2_dbg(2, "%s(): offset %d, end %d\n",
+			  __func__, offset, end);
 		if (unlikely(!frag || frag->ofs > offset ||
 			     frag->ofs + frag->size <= offset)) {
 			uint32_t holesize = end - offset;
 			if (frag && frag->ofs > offset) {
-				D1(printk(KERN_NOTICE "Eep. Hole in ino #%u fraglist. frag->ofs = 0x%08x, offset = 0x%08x\n", f->inocache->ino, frag->ofs, offset));
+				jffs2_dbg(1, "Eep. Hole in ino #%u fraglist. frag->ofs = 0x%08x, offset = 0x%08x\n",
+					  f->inocache->ino, frag->ofs, offset);
 				holesize = min(holesize, frag->ofs - offset);
 			}
-			D1(printk(KERN_DEBUG "Filling non-frag hole from %d-%d\n", offset, offset+holesize));
+			jffs2_dbg(1, "Filling non-frag hole from %d-%d\n",
+				  offset, offset + holesize);
 			memset(buf, 0, holesize);
 			buf += holesize;
 			offset += holesize;
 			continue;
 		} else if (unlikely(!frag->node)) {
 			uint32_t holeend = min(end, frag->ofs + frag->size);
-			D1(printk(KERN_DEBUG "Filling frag hole from %d-%d (frag 0x%x 0x%x)\n", offset, holeend, frag->ofs, frag->ofs + frag->size));
+			jffs2_dbg(1, "Filling frag hole from %d-%d (frag 0x%x 0x%x)\n",
+				  offset, holeend, frag->ofs,
+				  frag->ofs + frag->size);
 			memset(buf, 0, holeend - offset);
 			buf += holeend - offset;
 			offset = holeend;
@@ -195,20 +201,23 @@ int jffs2_read_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 
 			fragofs = offset - frag->ofs;
 			readlen = min(frag->size - fragofs, end - offset);
-			D1(printk(KERN_DEBUG "Reading %d-%d from node at 0x%08x (%d)\n",
-				  frag->ofs+fragofs, frag->ofs+fragofs+readlen,
-				  ref_offset(frag->node->raw), ref_flags(frag->node->raw)));
+			jffs2_dbg(1, "Reading %d-%d from node at 0x%08x (%d)\n",
+				  frag->ofs+fragofs,
+				  frag->ofs + fragofs+readlen,
+				  ref_offset(frag->node->raw),
+				  ref_flags(frag->node->raw));
 			ret = jffs2_read_dnode(c, f, frag->node, buf, fragofs + frag->ofs - frag->node->ofs, readlen);
-			D2(printk(KERN_DEBUG "node read done\n"));
+			jffs2_dbg(2, "node read done\n");
 			if (ret) {
-				D1(printk(KERN_DEBUG"jffs2_read_inode_range error %d\n",ret));
+				jffs2_dbg(1, "%s(): error %d\n",
+					  __func__, ret);
 				memset(buf, 0, readlen);
 				return ret;
 			}
 			buf += readlen;
 			offset += readlen;
 			frag = frag_next(frag);
-			D2(printk(KERN_DEBUG "node read was OK. Looping\n"));
+			jffs2_dbg(2, "node read was OK. Looping\n");
 		}
 	}
 	return 0;
diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index a06d47a..b6c3d88 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -100,12 +100,13 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 			(void **)&flashbuf, NULL);
 	if (!ret && pointlen < c->mtd->size) {
 		/* Don't muck about if it won't let us point to the whole flash */
-		D1(printk(KERN_DEBUG "MTD point returned len too short: 0x%zx\n", pointlen));
+		jffs2_dbg(1, "MTD point returned len too short: 0x%zx\n",
+			  pointlen);
 		mtd_unpoint(c->mtd, 0, pointlen);
 		flashbuf = NULL;
 	}
 	if (ret && ret != -EOPNOTSUPP)
-		D1(printk(KERN_DEBUG "MTD point failed %d\n", ret));
+		jffs2_dbg(1, "MTD point failed %d\n", ret);
 #endif
 	if (!flashbuf) {
 		/* For NAND it's quicker to read a whole eraseblock at a time,
@@ -115,15 +116,15 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 		else
 			try_size = PAGE_SIZE;
 
-		D1(printk(KERN_DEBUG "Trying to allocate readbuf of %zu "
-			"bytes\n", try_size));
+		jffs2_dbg(1, "Trying to allocate readbuf of %zu "
+			  "bytes\n", try_size);
 
 		flashbuf = mtd_kmalloc_up_to(c->mtd, &try_size);
 		if (!flashbuf)
 			return -ENOMEM;
 
-		D1(printk(KERN_DEBUG "Allocated readbuf of %zu bytes\n",
-			try_size));
+		jffs2_dbg(1, "Allocated readbuf of %zu bytes\n",
+			  try_size);
 
 		buf_size = (uint32_t)try_size;
 	}
@@ -176,7 +177,8 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 				c->nr_free_blocks++;
 			} else {
 				/* Dirt */
-				D1(printk(KERN_DEBUG "Adding all-dirty block at 0x%08x to erase_pending_list\n", jeb->offset));
+				jffs2_dbg(1, "Adding all-dirty block at 0x%08x to erase_pending_list\n",
+					  jeb->offset);
 				list_add(&jeb->list, &c->erase_pending_list);
 				c->nr_erasing_blocks++;
 			}
@@ -203,7 +205,8 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 				}
 				/* update collected summary information for the current nextblock */
 				jffs2_sum_move_collected(c, s);
-				D1(printk(KERN_DEBUG "jffs2_scan_medium(): new nextblock = 0x%08x\n", jeb->offset));
+				jffs2_dbg(1, "%s(): new nextblock = 0x%08x\n",
+					  __func__, jeb->offset);
 				c->nextblock = jeb;
 			} else {
 				ret = file_dirty(c, jeb);
@@ -215,13 +218,15 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 		case BLK_STATE_ALLDIRTY:
 			/* Nothing valid - not even a clean marker. Needs erasing. */
 			/* For now we just put it on the erasing list. We'll start the erases later */
-			D1(printk(KERN_NOTICE "JFFS2: Erase block at 0x%08x is not formatted. It will be erased\n", jeb->offset));
+			jffs2_dbg(1, "JFFS2: Erase block at 0x%08x is not formatted. It will be erased\n",
+				  jeb->offset);
 			list_add(&jeb->list, &c->erase_pending_list);
 			c->nr_erasing_blocks++;
 			break;
 
 		case BLK_STATE_BADBLOCK:
-			D1(printk(KERN_NOTICE "JFFS2: Block at 0x%08x is bad\n", jeb->offset));
+			jffs2_dbg(1, "JFFS2: Block at 0x%08x is bad\n",
+				  jeb->offset);
 			list_add(&jeb->list, &c->bad_list);
 			c->bad_size += c->sector_size;
 			c->free_size -= c->sector_size;
@@ -248,8 +253,8 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 
 		uint32_t skip = c->nextblock->free_size % c->wbuf_pagesize;
 
-		D1(printk(KERN_DEBUG "jffs2_scan_medium(): Skipping %d bytes in nextblock to ensure page alignment\n",
-			  skip));
+		jffs2_dbg(1, "%s(): Skipping %d bytes in nextblock to ensure page alignment\n",
+			  __func__, skip);
 		jffs2_prealloc_raw_node_refs(c, c->nextblock, 1);
 		jffs2_scan_dirty_space(c, c->nextblock, skip);
 	}
@@ -285,11 +290,13 @@ static int jffs2_fill_scan_buf(struct jffs2_sb_info *c, void *buf,
 
 	ret = jffs2_flash_read(c, ofs, len, &retlen, buf);
 	if (ret) {
-		D1(printk(KERN_WARNING "mtd->read(0x%x bytes from 0x%x) returned %d\n", len, ofs, ret));
+		jffs2_dbg(1, "mtd->read(0x%x bytes from 0x%x) returned %d\n",
+			  len, ofs, ret);
 		return ret;
 	}
 	if (retlen < len) {
-		D1(printk(KERN_WARNING "Read at 0x%x gave only 0x%zx bytes\n", ofs, retlen));
+		jffs2_dbg(1, "Read at 0x%x gave only 0x%zx bytes\n",
+			  ofs, retlen);
 		return -EIO;
 	}
 	return 0;
@@ -447,7 +454,7 @@ static int jffs2_scan_eraseblock (struct jffs2_sb_info *c, struct jffs2_eraseblo
 	ofs = jeb->offset;
 	prevofs = jeb->offset - 1;
 
-	D1(printk(KERN_DEBUG "jffs2_scan_eraseblock(): Scanning block at 0x%x\n", ofs));
+	jffs2_dbg(1, "%s(): Scanning block at 0x%x\n", __func__, ofs);
 
 #ifdef CONFIG_JFFS2_FS_WRITEBUFFER
 	if (jffs2_cleanmarker_oob(c)) {
@@ -457,7 +464,7 @@ static int jffs2_scan_eraseblock (struct jffs2_sb_info *c, struct jffs2_eraseblo
 			return BLK_STATE_BADBLOCK;
 
 		ret = jffs2_check_nand_cleanmarker(c, jeb);
-		D2(printk(KERN_NOTICE "jffs_check_nand_cleanmarker returned %d\n",ret));
+		jffs2_dbg(2, "jffs_check_nand_cleanmarker returned %d\n", ret);
 
 		/* Even if it's not found, we still scan to see
 		   if the block is empty. We use this information
@@ -559,7 +566,8 @@ static int jffs2_scan_eraseblock (struct jffs2_sb_info *c, struct jffs2_eraseblo
 		if (jffs2_cleanmarker_oob(c)) {
 			/* scan oob, take care of cleanmarker */
 			int ret = jffs2_check_oob_empty(c, jeb, cleanmarkerfound);
-			D2(printk(KERN_NOTICE "jffs2_check_oob_empty returned %d\n",ret));
+			jffs2_dbg(2, "jffs2_check_oob_empty returned %d\n",
+				  ret);
 			switch (ret) {
 			case 0:		return cleanmarkerfound ? BLK_STATE_CLEANMARKER : BLK_STATE_ALLFF;
 			case 1: 	return BLK_STATE_ALLDIRTY;
@@ -567,15 +575,16 @@ static int jffs2_scan_eraseblock (struct jffs2_sb_info *c, struct jffs2_eraseblo
 			}
 		}
 #endif
-		D1(printk(KERN_DEBUG "Block at 0x%08x is empty (erased)\n", jeb->offset));
+		jffs2_dbg(1, "Block at 0x%08x is empty (erased)\n",
+			  jeb->offset);
 		if (c->cleanmarker_size == 0)
 			return BLK_STATE_CLEANMARKER;	/* don't bother with re-erase */
 		else
 			return BLK_STATE_ALLFF;	/* OK to erase if all blocks are like this */
 	}
 	if (ofs) {
-		D1(printk(KERN_DEBUG "Free space at %08x ends at %08x\n", jeb->offset,
-			  jeb->offset + ofs));
+		jffs2_dbg(1, "Free space at %08x ends at %08x\n", jeb->offset,
+			  jeb->offset + ofs);
 		if ((err = jffs2_prealloc_raw_node_refs(c, jeb, 1)))
 			return err;
 		if ((err = jffs2_scan_dirty_space(c, jeb, ofs)))
@@ -616,8 +625,10 @@ scan_more:
 		prevofs = ofs;
 
 		if (jeb->offset + c->sector_size < ofs + sizeof(*node)) {
-			D1(printk(KERN_DEBUG "Fewer than %zd bytes left to end of block. (%x+%x<%x+%zx) Not reading\n", sizeof(struct jffs2_unknown_node),
-				  jeb->offset, c->sector_size, ofs, sizeof(*node)));
+			jffs2_dbg(1, "Fewer than %zd bytes left to end of block. (%x+%x<%x+%zx) Not reading\n",
+				  sizeof(struct jffs2_unknown_node),
+				  jeb->offset, c->sector_size, ofs,
+				  sizeof(*node));
 			if ((err = jffs2_scan_dirty_space(c, jeb, (jeb->offset + c->sector_size)-ofs)))
 				return err;
 			break;
@@ -625,8 +636,9 @@ scan_more:
 
 		if (buf_ofs + buf_len < ofs + sizeof(*node)) {
 			buf_len = min_t(uint32_t, buf_size, jeb->offset + c->sector_size - ofs);
-			D1(printk(KERN_DEBUG "Fewer than %zd bytes (node header) left to end of buf. Reading 0x%x at 0x%08x\n",
-				  sizeof(struct jffs2_unknown_node), buf_len, ofs));
+			jffs2_dbg(1, "Fewer than %zd bytes (node header) left to end of buf. Reading 0x%x at 0x%08x\n",
+				  sizeof(struct jffs2_unknown_node),
+				  buf_len, ofs);
 			err = jffs2_fill_scan_buf(c, buf, ofs, buf_len);
 			if (err)
 				return err;
@@ -643,7 +655,7 @@ scan_more:
 			ofs += 4;
 			scan_end = min_t(uint32_t, EMPTY_SCAN_SIZE(c->sector_size)/8, buf_len);
 
-			D1(printk(KERN_DEBUG "Found empty flash at 0x%08x\n", ofs));
+			jffs2_dbg(1, "Found empty flash at 0x%08x\n", ofs);
 		more_empty:
 			inbuf_ofs = ofs - buf_ofs;
 			while (inbuf_ofs < scan_end) {
@@ -659,13 +671,15 @@ scan_more:
 				ofs += 4;
 			}
 			/* Ran off end. */
-			D1(printk(KERN_DEBUG "Empty flash to end of buffer at 0x%08x\n", ofs));
+			jffs2_dbg(1, "Empty flash to end of buffer at 0x%08x\n",
+				  ofs);
 
 			/* If we're only checking the beginning of a block with a cleanmarker,
 			   bail now */
 			if (buf_ofs == jeb->offset && jeb->used_size == PAD(c->cleanmarker_size) &&
 			    c->cleanmarker_size && !jeb->dirty_size && !ref_next(jeb->first_node)) {
-				D1(printk(KERN_DEBUG "%d bytes at start of block seems clean... assuming all clean\n", EMPTY_SCAN_SIZE(c->sector_size)));
+				jffs2_dbg(1, "%d bytes at start of block seems clean... assuming all clean\n",
+					  EMPTY_SCAN_SIZE(c->sector_size));
 				return BLK_STATE_CLEANMARKER;
 			}
 			if (!buf_size && (scan_end != buf_len)) {/* XIP/point case */
@@ -678,13 +692,14 @@ scan_more:
 			if (!buf_len) {
 				/* No more to read. Break out of main loop without marking
 				   this range of empty space as dirty (because it's not) */
-				D1(printk(KERN_DEBUG "Empty flash at %08x runs to end of block. Treating as free_space\n",
-					  empty_start));
+				jffs2_dbg(1, "Empty flash at %08x runs to end of block. Treating as free_space\n",
+					  empty_start);
 				break;
 			}
 			/* point never reaches here */
 			scan_end = buf_len;
-			D1(printk(KERN_DEBUG "Reading another 0x%x at 0x%08x\n", buf_len, ofs));
+			jffs2_dbg(1, "Reading another 0x%x at 0x%08x\n",
+				  buf_len, ofs);
 			err = jffs2_fill_scan_buf(c, buf, ofs, buf_len);
 			if (err)
 				return err;
@@ -700,7 +715,7 @@ scan_more:
 			continue;
 		}
 		if (je16_to_cpu(node->magic) == JFFS2_DIRTY_BITMASK) {
-			D1(printk(KERN_DEBUG "Dirty bitmask at 0x%08x\n", ofs));
+			jffs2_dbg(1, "Dirty bitmask at 0x%08x\n", ofs);
 			if ((err = jffs2_scan_dirty_space(c, jeb, 4)))
 				return err;
 			ofs += 4;
@@ -756,7 +771,8 @@ scan_more:
 
 		if (!(je16_to_cpu(node->nodetype) & JFFS2_NODE_ACCURATE)) {
 			/* Wheee. This is an obsoleted node */
-			D2(printk(KERN_DEBUG "Node at 0x%08x is obsolete. Skipping\n", ofs));
+			jffs2_dbg(2, "Node at 0x%08x is obsolete. Skipping\n",
+				  ofs);
 			if ((err = jffs2_scan_dirty_space(c, jeb, PAD(je32_to_cpu(node->totlen)))))
 				return err;
 			ofs += PAD(je32_to_cpu(node->totlen));
@@ -767,8 +783,9 @@ scan_more:
 		case JFFS2_NODETYPE_INODE:
 			if (buf_ofs + buf_len < ofs + sizeof(struct jffs2_raw_inode)) {
 				buf_len = min_t(uint32_t, buf_size, jeb->offset + c->sector_size - ofs);
-				D1(printk(KERN_DEBUG "Fewer than %zd bytes (inode node) left to end of buf. Reading 0x%x at 0x%08x\n",
-					  sizeof(struct jffs2_raw_inode), buf_len, ofs));
+				jffs2_dbg(1, "Fewer than %zd bytes (inode node) left to end of buf. Reading 0x%x at 0x%08x\n",
+					  sizeof(struct jffs2_raw_inode),
+					  buf_len, ofs);
 				err = jffs2_fill_scan_buf(c, buf, ofs, buf_len);
 				if (err)
 					return err;
@@ -783,8 +800,9 @@ scan_more:
 		case JFFS2_NODETYPE_DIRENT:
 			if (buf_ofs + buf_len < ofs + je32_to_cpu(node->totlen)) {
 				buf_len = min_t(uint32_t, buf_size, jeb->offset + c->sector_size - ofs);
-				D1(printk(KERN_DEBUG "Fewer than %d bytes (dirent node) left to end of buf. Reading 0x%x at 0x%08x\n",
-					  je32_to_cpu(node->totlen), buf_len, ofs));
+				jffs2_dbg(1, "Fewer than %d bytes (dirent node) left to end of buf. Reading 0x%x at 0x%08x\n",
+					  je32_to_cpu(node->totlen), buf_len,
+					  ofs);
 				err = jffs2_fill_scan_buf(c, buf, ofs, buf_len);
 				if (err)
 					return err;
@@ -800,9 +818,9 @@ scan_more:
 		case JFFS2_NODETYPE_XATTR:
 			if (buf_ofs + buf_len < ofs + je32_to_cpu(node->totlen)) {
 				buf_len = min_t(uint32_t, buf_size, jeb->offset + c->sector_size - ofs);
-				D1(printk(KERN_DEBUG "Fewer than %d bytes (xattr node)"
-					  " left to end of buf. Reading 0x%x at 0x%08x\n",
-					  je32_to_cpu(node->totlen), buf_len, ofs));
+				jffs2_dbg(1, "Fewer than %d bytes (xattr node) left to end of buf. Reading 0x%x at 0x%08x\n",
+					  je32_to_cpu(node->totlen), buf_len,
+					  ofs);
 				err = jffs2_fill_scan_buf(c, buf, ofs, buf_len);
 				if (err)
 					return err;
@@ -817,9 +835,9 @@ scan_more:
 		case JFFS2_NODETYPE_XREF:
 			if (buf_ofs + buf_len < ofs + je32_to_cpu(node->totlen)) {
 				buf_len = min_t(uint32_t, buf_size, jeb->offset + c->sector_size - ofs);
-				D1(printk(KERN_DEBUG "Fewer than %d bytes (xref node)"
-					  " left to end of buf. Reading 0x%x at 0x%08x\n",
-					  je32_to_cpu(node->totlen), buf_len, ofs));
+				jffs2_dbg(1, "Fewer than %d bytes (xref node) left to end of buf. Reading 0x%x at 0x%08x\n",
+					  je32_to_cpu(node->totlen), buf_len,
+					  ofs);
 				err = jffs2_fill_scan_buf(c, buf, ofs, buf_len);
 				if (err)
 					return err;
@@ -834,7 +852,7 @@ scan_more:
 #endif	/* CONFIG_JFFS2_FS_XATTR */
 
 		case JFFS2_NODETYPE_CLEANMARKER:
-			D1(printk(KERN_DEBUG "CLEANMARKER node found at 0x%08x\n", ofs));
+			jffs2_dbg(1, "CLEANMARKER node found at 0x%08x\n", ofs);
 			if (je32_to_cpu(node->totlen) != c->cleanmarker_size) {
 				printk(KERN_NOTICE "CLEANMARKER node found at 0x%08x has totlen 0x%x != normal 0x%x\n",
 				       ofs, je32_to_cpu(node->totlen), c->cleanmarker_size);
@@ -878,14 +896,16 @@ scan_more:
 				return -EINVAL;
 
 			case JFFS2_FEATURE_RWCOMPAT_DELETE:
-				D1(printk(KERN_NOTICE "Unknown but compatible feature node (0x%04x) found at offset 0x%08x\n", je16_to_cpu(node->nodetype), ofs));
+				jffs2_dbg(1, "Unknown but compatible feature node (0x%04x) found at offset 0x%08x\n",
+					  je16_to_cpu(node->nodetype), ofs);
 				if ((err = jffs2_scan_dirty_space(c, jeb, PAD(je32_to_cpu(node->totlen)))))
 					return err;
 				ofs += PAD(je32_to_cpu(node->totlen));
 				break;
 
 			case JFFS2_FEATURE_RWCOMPAT_COPY: {
-				D1(printk(KERN_NOTICE "Unknown but compatible feature node (0x%04x) found at offset 0x%08x\n", je16_to_cpu(node->nodetype), ofs));
+				jffs2_dbg(1, "Unknown but compatible feature node (0x%04x) found at offset 0x%08x\n",
+					  je16_to_cpu(node->nodetype), ofs);
 
 				jffs2_link_node_ref(c, jeb, ofs | REF_PRISTINE, PAD(je32_to_cpu(node->totlen)), NULL);
 
@@ -906,8 +926,9 @@ scan_more:
 		}
 	}
 
-	D1(printk(KERN_DEBUG "Block at 0x%08x: free 0x%08x, dirty 0x%08x, unchecked 0x%08x, used 0x%08x, wasted 0x%08x\n",
-		  jeb->offset,jeb->free_size, jeb->dirty_size, jeb->unchecked_size, jeb->used_size, jeb->wasted_size));
+	jffs2_dbg(1, "Block at 0x%08x: free 0x%08x, dirty 0x%08x, unchecked 0x%08x, used 0x%08x, wasted 0x%08x\n",
+		  jeb->offset, jeb->free_size, jeb->dirty_size,
+		  jeb->unchecked_size, jeb->used_size, jeb->wasted_size);
 	
 	/* mark_node_obsolete can add to wasted !! */
 	if (jeb->wasted_size) {
@@ -952,7 +973,7 @@ static int jffs2_scan_inode_node(struct jffs2_sb_info *c, struct jffs2_erasebloc
 	struct jffs2_inode_cache *ic;
 	uint32_t crc, ino = je32_to_cpu(ri->ino);
 
-	D1(printk(KERN_DEBUG "jffs2_scan_inode_node(): Node at 0x%08x\n", ofs));
+	jffs2_dbg(1, "%s(): Node at 0x%08x\n", __func__, ofs);
 
 	/* We do very little here now. Just check the ino# to which we should attribute
 	   this node; we can do all the CRC checking etc. later. There's a tradeoff here --
@@ -987,10 +1008,10 @@ static int jffs2_scan_inode_node(struct jffs2_sb_info *c, struct jffs2_erasebloc
 	/* Wheee. It worked */
 	jffs2_link_node_ref(c, jeb, ofs | REF_UNCHECKED, PAD(je32_to_cpu(ri->totlen)), ic);
 
-	D1(printk(KERN_DEBUG "Node is ino #%u, version %d. Range 0x%x-0x%x\n",
+	jffs2_dbg(1, "Node is ino #%u, version %d. Range 0x%x-0x%x\n",
 		  je32_to_cpu(ri->ino), je32_to_cpu(ri->version),
 		  je32_to_cpu(ri->offset),
-		  je32_to_cpu(ri->offset)+je32_to_cpu(ri->dsize)));
+		  je32_to_cpu(ri->offset)+je32_to_cpu(ri->dsize));
 
 	pseudo_random += je32_to_cpu(ri->version);
 
@@ -1010,7 +1031,7 @@ static int jffs2_scan_dirent_node(struct jffs2_sb_info *c, struct jffs2_eraseblo
 	uint32_t crc;
 	int err;
 
-	D1(printk(KERN_DEBUG "jffs2_scan_dirent_node(): Node at 0x%08x\n", ofs));
+	jffs2_dbg(1, "%s(): Node at 0x%08x\n", __func__, ofs);
 
 	/* We don't get here unless the node is still valid, so we don't have to
 	   mask in the ACCURATE bit any more. */
@@ -1044,7 +1065,8 @@ static int jffs2_scan_dirent_node(struct jffs2_sb_info *c, struct jffs2_eraseblo
 	if (crc != je32_to_cpu(rd->name_crc)) {
 		printk(KERN_NOTICE "jffs2_scan_dirent_node(): Name CRC failed on node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
 		       ofs, je32_to_cpu(rd->name_crc), crc);
-		D1(printk(KERN_NOTICE "Name for which CRC failed is (now) '%s', ino #%d\n", fd->name, je32_to_cpu(rd->ino)));
+		jffs2_dbg(1, "Name for which CRC failed is (now) '%s', ino #%d\n",
+			  fd->name, je32_to_cpu(rd->ino));
 		jffs2_free_full_dirent(fd);
 		/* FIXME: Why do we believe totlen? */
 		/* We believe totlen because the CRC on the node _header_ was OK, just the name failed. */
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index f2d96b5..3600e3e 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -69,7 +69,7 @@ static void jffs2_write_super(struct super_block *sb)
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		D1(printk(KERN_DEBUG "jffs2_write_super()\n"));
+		jffs2_dbg(1, "%s()\n", __func__);
 		jffs2_flush_wbuf_gc(c, 0);
 	}
 
@@ -266,9 +266,9 @@ static int jffs2_fill_super(struct super_block *sb, void *data, int silent)
 	struct jffs2_sb_info *c;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_get_sb_mtd():"
+	jffs2_dbg(1, "jffs2_get_sb_mtd():"
 		  " New superblock for device %d (\"%s\")\n",
-		  sb->s_mtd->index, sb->s_mtd->name));
+		  sb->s_mtd->index, sb->s_mtd->name);
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c)
@@ -315,7 +315,7 @@ static void jffs2_put_super (struct super_block *sb)
 {
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(sb);
 
-	D2(printk(KERN_DEBUG "jffs2: jffs2_put_super()\n"));
+	jffs2_dbg(2, "%s()\n", __func__);
 
 	if (sb->s_dirt)
 		jffs2_write_super(sb);
@@ -336,7 +336,7 @@ static void jffs2_put_super (struct super_block *sb)
 	kfree(c->inocache_list);
 	jffs2_clear_xattr_subsystem(c);
 	mtd_sync(c->mtd);
-	D1(printk(KERN_DEBUG "jffs2_put_super returning\n"));
+	jffs2_dbg(1, "%s(): returning\n", __func__);
 }
 
 static void jffs2_kill_sb(struct super_block *sb)
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index e3035af..5188f4d 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -50,7 +50,8 @@ static void *jffs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 		printk(KERN_ERR "jffs2_follow_link(): can't find symlink target\n");
 		p = ERR_PTR(-EIO);
 	}
-	D1(printk(KERN_DEBUG "jffs2_follow_link(): target path is '%s'\n", (char *) f->target));
+	jffs2_dbg(1, "%s(): target path is '%s'\n",
+		  __func__, (char *)f->target);
 
 	nd_set_link(nd, p);
 
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index 30e8f47..d626eb2 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -91,7 +91,7 @@ static void jffs2_wbuf_dirties_inode(struct jffs2_sb_info *c, uint32_t ino)
 
 	new = kmalloc(sizeof(*new), GFP_KERNEL);
 	if (!new) {
-		D1(printk(KERN_DEBUG "No memory to allocate inodirty. Fallback to all considered dirty\n"));
+		jffs2_dbg(1, "No memory to allocate inodirty. Fallback to all considered dirty\n");
 		jffs2_clear_wbuf_ino_list(c);
 		c->wbuf_inodes = &inodirty_nomem;
 		return;
@@ -113,19 +113,20 @@ static inline void jffs2_refile_wbuf_blocks(struct jffs2_sb_info *c)
 	list_for_each_safe(this, next, &c->erasable_pending_wbuf_list) {
 		struct jffs2_eraseblock *jeb = list_entry(this, struct jffs2_eraseblock, list);
 
-		D1(printk(KERN_DEBUG "Removing eraseblock at 0x%08x from erasable_pending_wbuf_list...\n", jeb->offset));
+		jffs2_dbg(1, "Removing eraseblock at 0x%08x from erasable_pending_wbuf_list...\n",
+			  jeb->offset);
 		list_del(this);
 		if ((jiffies + (n++)) & 127) {
 			/* Most of the time, we just erase it immediately. Otherwise we
 			   spend ages scanning it on mount, etc. */
-			D1(printk(KERN_DEBUG "...and adding to erase_pending_list\n"));
+			jffs2_dbg(1, "...and adding to erase_pending_list\n");
 			list_add_tail(&jeb->list, &c->erase_pending_list);
 			c->nr_erasing_blocks++;
 			jffs2_garbage_collect_trigger(c);
 		} else {
 			/* Sometimes, however, we leave it elsewhere so it doesn't get
 			   immediately reused, and we spread the load a bit. */
-			D1(printk(KERN_DEBUG "...and adding to erasable_list\n"));
+			jffs2_dbg(1, "...and adding to erasable_list\n");
 			list_add_tail(&jeb->list, &c->erasable_list);
 		}
 	}
@@ -136,7 +137,7 @@ static inline void jffs2_refile_wbuf_blocks(struct jffs2_sb_info *c)
 
 static void jffs2_block_refile(struct jffs2_sb_info *c, struct jffs2_eraseblock *jeb, int allow_empty)
 {
-	D1(printk("About to refile bad block at %08x\n", jeb->offset));
+	jffs2_dbg(1, "About to refile bad block at %08x\n", jeb->offset);
 
 	/* File the existing block on the bad_used_list.... */
 	if (c->nextblock == jeb)
@@ -144,12 +145,14 @@ static void jffs2_block_refile(struct jffs2_sb_info *c, struct jffs2_eraseblock
 	else /* Not sure this should ever happen... need more coffee */
 		list_del(&jeb->list);
 	if (jeb->first_node) {
-		D1(printk("Refiling block at %08x to bad_used_list\n", jeb->offset));
+		jffs2_dbg(1, "Refiling block at %08x to bad_used_list\n",
+			  jeb->offset);
 		list_add(&jeb->list, &c->bad_used_list);
 	} else {
 		BUG_ON(allow_empty == REFILE_NOTEMPTY);
 		/* It has to have had some nodes or we couldn't be here */
-		D1(printk("Refiling block at %08x to erase_pending_list\n", jeb->offset));
+		jffs2_dbg(1, "Refiling block at %08x to erase_pending_list\n",
+			  jeb->offset);
 		list_add(&jeb->list, &c->erase_pending_list);
 		c->nr_erasing_blocks++;
 		jffs2_garbage_collect_trigger(c);
@@ -308,7 +311,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 	if (!first_raw) {
 		/* All nodes were obsolete. Nothing to recover. */
-		D1(printk(KERN_DEBUG "No non-obsolete nodes to be recovered. Just filing block bad\n"));
+		jffs2_dbg(1, "No non-obsolete nodes to be recovered. Just filing block bad\n");
 		c->wbuf_len = 0;
 		return;
 	}
@@ -406,8 +409,8 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 		unsigned char *rewrite_buf = buf?:c->wbuf;
 		uint32_t towrite = (end-start) - ((end-start)%c->wbuf_pagesize);
 
-		D1(printk(KERN_DEBUG "Write 0x%x bytes at 0x%08x in wbuf recover\n",
-			  towrite, ofs));
+		jffs2_dbg(1, "Write 0x%x bytes at 0x%08x in wbuf recover\n",
+			  towrite, ofs);
 
 #ifdef BREAKMEHEADER
 		static int breakme;
@@ -459,8 +462,8 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 		struct jffs2_raw_node_ref **adjust_ref = NULL;
 		struct jffs2_inode_info *f = NULL;
 
-		D1(printk(KERN_DEBUG "Refiling block of %08x at %08x(%d) to %08x\n",
-			  rawlen, ref_offset(raw), ref_flags(raw), ofs));
+		jffs2_dbg(1, "Refiling block of %08x at %08x(%d) to %08x\n",
+			  rawlen, ref_offset(raw), ref_flags(raw), ofs);
 
 		ic = jffs2_raw_ref_to_ic(raw);
 
@@ -540,7 +543,8 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 	/* Fix up the original jeb now it's on the bad_list */
 	if (first_raw == jeb->first_node) {
-		D1(printk(KERN_DEBUG "Failing block at %08x is now empty. Moving to erase_pending_list\n", jeb->offset));
+		jffs2_dbg(1, "Failing block at %08x is now empty. Moving to erase_pending_list\n",
+			  jeb->offset);
 		list_move(&jeb->list, &c->erase_pending_list);
 		c->nr_erasing_blocks++;
 		jffs2_garbage_collect_trigger(c);
@@ -554,7 +558,8 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 	spin_unlock(&c->erase_completion_lock);
 
-	D1(printk(KERN_DEBUG "wbuf recovery completed OK. wbuf_ofs 0x%08x, len 0x%x\n", c->wbuf_ofs, c->wbuf_len));
+	jffs2_dbg(1, "wbuf recovery completed OK. wbuf_ofs 0x%08x, len 0x%x\n",
+		  c->wbuf_ofs, c->wbuf_len);
 
 }
 
@@ -647,8 +652,9 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c, int pad)
 	if (pad) {
 		uint32_t waste = c->wbuf_pagesize - c->wbuf_len;
 
-		D1(printk(KERN_DEBUG "jffs2_flush_wbuf() adjusting free_size of %sblock at %08x\n",
-			  (wbuf_jeb==c->nextblock)?"next":"", wbuf_jeb->offset));
+		jffs2_dbg(1, "jffs2_flush_wbuf() adjusting free_size of %sblock at %08x\n",
+			  (wbuf_jeb == c->nextblock) ? "next" : "",
+			  wbuf_jeb->offset);
 
 		/* wbuf_pagesize - wbuf_len is the amount of space that's to be
 		   padded. If there is less free space in the block than that,
@@ -694,14 +700,14 @@ int jffs2_flush_wbuf_gc(struct jffs2_sb_info *c, uint32_t ino)
 	uint32_t old_wbuf_len;
 	int ret = 0;
 
-	D1(printk(KERN_DEBUG "jffs2_flush_wbuf_gc() called for ino #%u...\n", ino));
+	jffs2_dbg(1, "jffs2_flush_wbuf_gc() called for ino #%u...\n", ino);
 
 	if (!c->wbuf)
 		return 0;
 
 	mutex_lock(&c->alloc_sem);
 	if (!jffs2_wbuf_pending_for_ino(c, ino)) {
-		D1(printk(KERN_DEBUG "Ino #%d not pending in wbuf. Returning\n", ino));
+		jffs2_dbg(1, "Ino #%d not pending in wbuf. Returning\n", ino);
 		mutex_unlock(&c->alloc_sem);
 		return 0;
 	}
@@ -711,7 +717,8 @@ int jffs2_flush_wbuf_gc(struct jffs2_sb_info *c, uint32_t ino)
 
 	if (c->unchecked_size) {
 		/* GC won't make any progress for a while */
-		D1(printk(KERN_DEBUG "jffs2_flush_wbuf_gc() padding. Not finished checking\n"));
+		jffs2_dbg(1, "%s(): padding. Not finished checking\n",
+			  __func__);
 		down_write(&c->wbuf_sem);
 		ret = __jffs2_flush_wbuf(c, PAD_ACCOUNTING);
 		/* retry flushing wbuf in case jffs2_wbuf_recover
@@ -724,7 +731,7 @@ int jffs2_flush_wbuf_gc(struct jffs2_sb_info *c, uint32_t ino)
 
 		mutex_unlock(&c->alloc_sem);
 
-		D1(printk(KERN_DEBUG "jffs2_flush_wbuf_gc() calls gc pass\n"));
+		jffs2_dbg(1, "%s(): calls gc pass\n", __func__);
 
 		ret = jffs2_garbage_collect_pass(c);
 		if (ret) {
@@ -742,7 +749,7 @@ int jffs2_flush_wbuf_gc(struct jffs2_sb_info *c, uint32_t ino)
 		mutex_lock(&c->alloc_sem);
 	}
 
-	D1(printk(KERN_DEBUG "jffs2_flush_wbuf_gc() ends...\n"));
+	jffs2_dbg(1, "%s(): ends...\n", __func__);
 
 	mutex_unlock(&c->alloc_sem);
 	return ret;
@@ -811,9 +818,8 @@ int jffs2_flash_writev(struct jffs2_sb_info *c, const struct kvec *invecs,
 	if (SECTOR_ADDR(to) != SECTOR_ADDR(c->wbuf_ofs)) {
 		/* It's a write to a new block */
 		if (c->wbuf_len) {
-			D1(printk(KERN_DEBUG "jffs2_flash_writev() to 0x%lx "
-				  "causes flush of wbuf at 0x%08x\n",
-				  (unsigned long)to, c->wbuf_ofs));
+			jffs2_dbg(1, "%s(): to 0x%lx causes flush of wbuf at 0x%08x\n",
+				  __func__, (unsigned long)to, c->wbuf_ofs);
 			ret = __jffs2_flush_wbuf(c, PAD_NOACCOUNT);
 			if (ret)
 				goto outerr;
@@ -825,8 +831,8 @@ int jffs2_flash_writev(struct jffs2_sb_info *c, const struct kvec *invecs,
 
 	if (to != PAD(c->wbuf_ofs + c->wbuf_len)) {
 		/* We're not writing immediately after the writebuffer. Bad. */
-		printk(KERN_CRIT "jffs2_flash_writev(): Non-contiguous write "
-		       "to %08lx\n", (unsigned long)to);
+		printk(KERN_CRIT "%s(): Non-contiguous write to %08lx\n",
+		       __func__, (unsigned long)to);
 		if (c->wbuf_len)
 			printk(KERN_CRIT "wbuf was previously %08x-%08x\n",
 			       c->wbuf_ofs, c->wbuf_ofs+c->wbuf_len);
@@ -1048,8 +1054,8 @@ int jffs2_check_oob_empty(struct jffs2_sb_info *c,
 			continue;
 
 		if (ops.oobbuf[i] != 0xFF) {
-			D2(printk(KERN_DEBUG "Found %02x at %x in OOB for "
-				  "%08x\n", ops.oobbuf[i], i, jeb->offset));
+			jffs2_dbg(2, "Found %02x at %x in OOB for "
+				  "%08x\n", ops.oobbuf[i], i, jeb->offset);
 			return 1;
 		}
 	}
@@ -1134,7 +1140,8 @@ int jffs2_write_nand_badblock(struct jffs2_sb_info *c, struct jffs2_eraseblock *
 	ret = mtd_block_markbad(c->mtd, bad_offset);
 
 	if (ret) {
-		D1(printk(KERN_WARNING "jffs2_write_nand_badblock(): Write failed for block at %08x: error %d\n", jeb->offset, ret));
+		jffs2_dbg(1, "%s(): Write failed for block at %08x: error %d\n",
+			  __func__, jeb->offset, ret);
 		return ret;
 	}
 	return 1;
@@ -1155,7 +1162,7 @@ int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
 		return -EINVAL;
 	}
 
-	D1(printk(KERN_DEBUG "JFFS2 using OOB on NAND\n"));
+	jffs2_dbg(1, "JFFS2 using OOB on NAND\n");
 
 	c->oobavail = oinfo->oobavail;
 
diff --git a/fs/jffs2/write.c b/fs/jffs2/write.c
index 30d175b..e137839 100644
--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -36,7 +36,7 @@ int jffs2_do_new_inode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	f->inocache->state = INO_STATE_PRESENT;
 
 	jffs2_add_ino_cache(c, f->inocache);
-	D1(printk(KERN_DEBUG "jffs2_do_new_inode(): Assigned ino# %d\n", f->inocache->ino));
+	jffs2_dbg(1, "%s(): Assigned ino# %d\n", __func__, f->inocache->ino);
 	ri->ino = cpu_to_je32(f->inocache->ino);
 
 	ri->magic = cpu_to_je16(JFFS2_MAGIC_BITMASK);
@@ -95,9 +95,9 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 
 	if ((alloc_mode!=ALLOC_GC) && (je32_to_cpu(ri->version) < f->highest_version)) {
 		BUG_ON(!retried);
-		D1(printk(KERN_DEBUG "jffs2_write_dnode : dnode_version %d, "
-				"highest version %d -> updating dnode\n",
-				je32_to_cpu(ri->version), f->highest_version));
+		jffs2_dbg(1, "%s(): dnode_version %d, highest version %d -> updating dnode\n",
+			  __func__,
+			  je32_to_cpu(ri->version), f->highest_version);
 		ri->version = cpu_to_je32(++f->highest_version);
 		ri->node_crc = cpu_to_je32(crc32(0, ri, sizeof(*ri)-8));
 	}
@@ -127,7 +127,7 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 
 			retried = 1;
 
-			D1(printk(KERN_DEBUG "Retrying failed write.\n"));
+			jffs2_dbg(1, "Retrying failed write.\n");
 
 			jffs2_dbg_acct_sanity_check(c,jeb);
 			jffs2_dbg_acct_paranoia_check(c, jeb);
@@ -147,14 +147,16 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 
 			if (!ret) {
 				flash_ofs = write_ofs(c);
-				D1(printk(KERN_DEBUG "Allocated space at 0x%08x to retry failed write.\n", flash_ofs));
+				jffs2_dbg(1, "Allocated space at 0x%08x to retry failed write.\n",
+					  flash_ofs);
 
 				jffs2_dbg_acct_sanity_check(c,jeb);
 				jffs2_dbg_acct_paranoia_check(c, jeb);
 
 				goto retry;
 			}
-			D1(printk(KERN_DEBUG "Failed to allocate space to retry failed write: %d!\n", ret));
+			jffs2_dbg(1, "Failed to allocate space to retry failed write: %d!\n",
+				  ret);
 		}
 		/* Release the full_dnode which is now useless, and return */
 		jffs2_free_full_dnode(fn);
@@ -183,10 +185,10 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 	fn->size = je32_to_cpu(ri->dsize);
 	fn->frags = 0;
 
-	D1(printk(KERN_DEBUG "jffs2_write_dnode wrote node at 0x%08x(%d) with dsize 0x%x, csize 0x%x, node_crc 0x%08x, data_crc 0x%08x, totlen 0x%08x\n",
+	jffs2_dbg(1, "jffs2_write_dnode wrote node at 0x%08x(%d) with dsize 0x%x, csize 0x%x, node_crc 0x%08x, data_crc 0x%08x, totlen 0x%08x\n",
 		  flash_ofs & ~3, flash_ofs & 3, je32_to_cpu(ri->dsize),
 		  je32_to_cpu(ri->csize), je32_to_cpu(ri->node_crc),
-		  je32_to_cpu(ri->data_crc), je32_to_cpu(ri->totlen)));
+		  je32_to_cpu(ri->data_crc), je32_to_cpu(ri->totlen));
 
 	if (retried) {
 		jffs2_dbg_acct_sanity_check(c,NULL);
@@ -206,9 +208,10 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 	int retried = 0;
 	int ret;
 
-	D1(printk(KERN_DEBUG "jffs2_write_dirent(ino #%u, name at *0x%p \"%s\"->ino #%u, name_crc 0x%08x)\n",
+	jffs2_dbg(1, "%s(ino #%u, name at *0x%p \"%s\"->ino #%u, name_crc 0x%08x)\n",
+		  __func__,
 		  je32_to_cpu(rd->pino), name, name, je32_to_cpu(rd->ino),
-		  je32_to_cpu(rd->name_crc)));
+		  je32_to_cpu(rd->name_crc));
 
 	D1(if(je32_to_cpu(rd->hdr_crc) != crc32(0, rd, sizeof(struct jffs2_unknown_node)-4)) {
 		printk(KERN_CRIT "Eep. CRC not correct in jffs2_write_dirent()\n");
@@ -249,9 +252,9 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 
 	if ((alloc_mode!=ALLOC_GC) && (je32_to_cpu(rd->version) < f->highest_version)) {
 		BUG_ON(!retried);
-		D1(printk(KERN_DEBUG "jffs2_write_dirent : dirent_version %d, "
-				     "highest version %d -> updating dirent\n",
-				     je32_to_cpu(rd->version), f->highest_version));
+		jffs2_dbg(1, "%s(): dirent_version %d, highest version %d -> updating dirent\n",
+			  __func__,
+			  je32_to_cpu(rd->version), f->highest_version);
 		rd->version = cpu_to_je32(++f->highest_version);
 		fd->version = je32_to_cpu(rd->version);
 		rd->node_crc = cpu_to_je32(crc32(0, rd, sizeof(*rd)-8));
@@ -275,7 +278,7 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 
 			retried = 1;
 
-			D1(printk(KERN_DEBUG "Retrying failed write.\n"));
+			jffs2_dbg(1, "Retrying failed write.\n");
 
 			jffs2_dbg_acct_sanity_check(c,jeb);
 			jffs2_dbg_acct_paranoia_check(c, jeb);
@@ -295,12 +298,14 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 
 			if (!ret) {
 				flash_ofs = write_ofs(c);
-				D1(printk(KERN_DEBUG "Allocated space at 0x%08x to retry failed write.\n", flash_ofs));
+				jffs2_dbg(1, "Allocated space at 0x%08x to retry failed write\n",
+					  flash_ofs);
 				jffs2_dbg_acct_sanity_check(c,jeb);
 				jffs2_dbg_acct_paranoia_check(c, jeb);
 				goto retry;
 			}
-			D1(printk(KERN_DEBUG "Failed to allocate space to retry failed write: %d!\n", ret));
+			jffs2_dbg(1, "Failed to allocate space to retry failed write: %d!\n",
+				  ret);
 		}
 		/* Release the full_dnode which is now useless, and return */
 		jffs2_free_full_dirent(fd);
@@ -333,8 +338,8 @@ int jffs2_write_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	int ret = 0;
 	uint32_t writtenlen = 0;
 
-       	D1(printk(KERN_DEBUG "jffs2_write_inode_range(): Ino #%u, ofs 0x%x, len 0x%x\n",
-		  f->inocache->ino, offset, writelen));
+	jffs2_dbg(1, "%s(): Ino #%u, ofs 0x%x, len 0x%x\n",
+		  __func__, f->inocache->ino, offset, writelen);
 
 	while(writelen) {
 		struct jffs2_full_dnode *fn;
@@ -345,12 +350,13 @@ int jffs2_write_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		int retried = 0;
 
 	retry:
-		D2(printk(KERN_DEBUG "jffs2_commit_write() loop: 0x%x to write to 0x%x\n", writelen, offset));
+		jffs2_dbg(2, "jffs2_commit_write() loop: 0x%x to write to 0x%x\n",
+			  writelen, offset);
 
 		ret = jffs2_reserve_space(c, sizeof(*ri) + JFFS2_MIN_DATA_LEN,
 					&alloclen, ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
 		if (ret) {
-			D1(printk(KERN_DEBUG "jffs2_reserve_space returned %d\n", ret));
+			jffs2_dbg(1, "jffs2_reserve_space returned %d\n", ret);
 			break;
 		}
 		mutex_lock(&f->sem);
@@ -386,7 +392,7 @@ int jffs2_write_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 			if (!retried) {
 				/* Write error to be retried */
 				retried = 1;
-				D1(printk(KERN_DEBUG "Retrying node write in jffs2_write_inode_range()\n"));
+				jffs2_dbg(1, "Retrying node write in jffs2_write_inode_range()\n");
 				goto retry;
 			}
 			break;
@@ -399,7 +405,8 @@ int jffs2_write_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		}
 		if (ret) {
 			/* Eep */
-			D1(printk(KERN_DEBUG "Eep. add_full_dnode_to_inode() failed in commit_write, returned %d\n", ret));
+			jffs2_dbg(1, "Eep. add_full_dnode_to_inode() failed in commit_write, returned %d\n",
+				  ret);
 			jffs2_mark_node_obsolete(c, fn->raw);
 			jffs2_free_full_dnode(fn);
 
@@ -414,7 +421,7 @@ int jffs2_write_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 			ret = -EIO;
 			break;
 		}
-		D1(printk(KERN_DEBUG "increasing writtenlen by %d\n", datalen));
+		jffs2_dbg(1, "increasing writtenlen by %d\n", datalen);
 		writtenlen += datalen;
 		offset += datalen;
 		writelen -= datalen;
@@ -439,7 +446,7 @@ int jffs2_do_create(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 	 */
 	ret = jffs2_reserve_space(c, sizeof(*ri), &alloclen, ALLOC_NORMAL,
 				JFFS2_SUMMARY_INODE_SIZE);
-	D1(printk(KERN_DEBUG "jffs2_do_create(): reserved 0x%x bytes\n", alloclen));
+	jffs2_dbg(1, "%s(): reserved 0x%x bytes\n", __func__, alloclen);
 	if (ret)
 		return ret;
 
@@ -450,11 +457,11 @@ int jffs2_do_create(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 
 	fn = jffs2_write_dnode(c, f, ri, NULL, 0, ALLOC_NORMAL);
 
-	D1(printk(KERN_DEBUG "jffs2_do_create created file with mode 0x%x\n",
-		  jemode_to_cpu(ri->mode)));
+	jffs2_dbg(1, "jffs2_do_create created file with mode 0x%x\n",
+		  jemode_to_cpu(ri->mode));
 
 	if (IS_ERR(fn)) {
-		D1(printk(KERN_DEBUG "jffs2_write_dnode() failed\n"));
+		jffs2_dbg(1, "jffs2_write_dnode() failed\n");
 		/* Eeek. Wave bye bye */
 		mutex_unlock(&f->sem);
 		jffs2_complete_reservation(c);
@@ -480,7 +487,7 @@ int jffs2_do_create(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 
 	if (ret) {
 		/* Eep. */
-		D1(printk(KERN_DEBUG "jffs2_reserve_space() for dirent failed\n"));
+		jffs2_dbg(1, "jffs2_reserve_space() for dirent failed\n");
 		return ret;
 	}
 
@@ -597,8 +604,8 @@ int jffs2_do_unlink(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 			    !memcmp(fd->name, name, namelen) &&
 			    !fd->name[namelen]) {
 
-				D1(printk(KERN_DEBUG "Marking old dirent node (ino #%u) @%08x obsolete\n",
-					  fd->ino, ref_offset(fd->raw)));
+				jffs2_dbg(1, "Marking old dirent node (ino #%u) @%08x obsolete\n",
+					  fd->ino, ref_offset(fd->raw));
 				jffs2_mark_node_obsolete(c, fd->raw);
 				/* We don't want to remove it from the list immediately,
 				   because that screws up getdents()/seek() semantics even
@@ -630,8 +637,9 @@ int jffs2_do_unlink(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 					printk(KERN_WARNING "Deleting inode #%u with active dentry \"%s\"->ino #%u\n",
 					       dead_f->inocache->ino, fd->name, fd->ino);
 				} else {
-					D1(printk(KERN_DEBUG "Removing deletion dirent for \"%s\" from dir ino #%u\n",
-						fd->name, dead_f->inocache->ino));
+					jffs2_dbg(1, "Removing deletion dirent for \"%s\" from dir ino #%u\n",
+						  fd->name,
+						  dead_f->inocache->ino);
 				}
 				if (fd->raw)
 					jffs2_mark_node_obsolete(c, fd->raw);
-- 
1.7.8.111.gad25c.dirty

