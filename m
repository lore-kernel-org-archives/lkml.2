Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2BOX5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:57:52 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38801 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755743Ab2BOX5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:57:49 -0500
From: Joe Perches <joe@perches.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] jffs2: Convert printks to pr_<level>
Date: Wed, 15 Feb 2012 15:56:44 -0800
Message-Id: <2448315ff184c1102616f79c23bc674b44a50f7a.1329349881.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1329349881.git.joe@perches.com>
References: <cover.1329349881.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more current logging style.

Coalesce formats, align arguments.
Convert uses of embedded function names to %s, __func__.

A couple of long line checkpatch errors I don't care about exist.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/jffs2/background.c |    5 +-
 fs/jffs2/compr.c      |   17 +++--
 fs/jffs2/compr_zlib.c |    6 +-
 fs/jffs2/debug.c      |   20 ++++---
 fs/jffs2/dir.c        |    7 +-
 fs/jffs2/erase.c      |   36 +++++++----
 fs/jffs2/fs.c         |   22 ++++---
 fs/jffs2/gc.c         |  158 +++++++++++++++++++++++++++---------------------
 fs/jffs2/nodelist.c   |   28 +++++----
 fs/jffs2/nodemgmt.c   |   51 ++++++++++------
 fs/jffs2/read.c       |   21 ++++---
 fs/jffs2/scan.c       |   84 ++++++++++++++------------
 fs/jffs2/summary.c    |   11 ++-
 fs/jffs2/super.c      |   18 +++---
 fs/jffs2/symlink.c    |    2 +-
 fs/jffs2/wbuf.c       |   83 +++++++++++++-------------
 fs/jffs2/write.c      |   37 +++++++-----
 17 files changed, 342 insertions(+), 264 deletions(-)

diff --git a/fs/jffs2/background.c b/fs/jffs2/background.c
index 26ce06c..63dafc6 100644
--- a/fs/jffs2/background.c
+++ b/fs/jffs2/background.c
@@ -42,7 +42,8 @@ int jffs2_start_garbage_collect_thread(struct jffs2_sb_info *c)
 
 	tsk = kthread_run(jffs2_garbage_collect_thread, c, "jffs2_gcd_mtd%d", c->mtd->index);
 	if (IS_ERR(tsk)) {
-		printk(KERN_WARNING "fork failed for JFFS2 garbage collect thread: %ld\n", -PTR_ERR(tsk));
+		pr_warn("fork failed for JFFS2 garbage collect thread: %ld\n",
+			-PTR_ERR(tsk));
 		complete(&c->gc_thread_exit);
 		ret = PTR_ERR(tsk);
 	} else {
@@ -152,7 +153,7 @@ static int jffs2_garbage_collect_thread(void *_c)
 
 		jffs2_dbg(1, "%s(): pass\n", __func__);
 		if (jffs2_garbage_collect_pass(c) == -ENOSPC) {
-			printk(KERN_NOTICE "No space for garbage collection. Aborting GC thread\n");
+			pr_notice("No space for garbage collection. Aborting GC thread\n");
 			goto die;
 		}
 	}
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index be8e493..ee9bf23 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -79,7 +79,7 @@ static int jffs2_selected_compress(u8 compr, unsigned char *data_in,
 
 	output_buf = kmalloc(*cdatalen, GFP_KERNEL);
 	if (!output_buf) {
-		printk(KERN_WARNING "JFFS2: No memory for compressor allocation. Compression failed.\n");
+		pr_warn("JFFS2: No memory for compressor allocation. Compression failed.\n");
 		return ret;
 	}
 	orig_slen = *datalen;
@@ -188,7 +188,8 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				tmp_buf = kmalloc(orig_slen, GFP_KERNEL);
 				spin_lock(&jffs2_compressor_list_lock);
 				if (!tmp_buf) {
-					printk(KERN_WARNING "JFFS2: No memory for compressor allocation. (%d bytes)\n", orig_slen);
+					pr_warn("JFFS2: No memory for compressor allocation. (%d bytes)\n",
+						orig_slen);
 					continue;
 				}
 				else {
@@ -235,7 +236,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				cpage_out, datalen, cdatalen);
 		break;
 	default:
-		printk(KERN_ERR "JFFS2: unknown compression mode.\n");
+		pr_err("JFFS2: unknown compression mode\n");
 	}
 
 	if (ret == JFFS2_COMPR_NONE) {
@@ -277,7 +278,8 @@ int jffs2_decompress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				ret = this->decompress(cdata_in, data_out, cdatalen, datalen);
 				spin_lock(&jffs2_compressor_list_lock);
 				if (ret) {
-					printk(KERN_WARNING "Decompressor \"%s\" returned %d\n", this->name, ret);
+					pr_warn("Decompressor \"%s\" returned %d\n",
+						this->name, ret);
 				}
 				else {
 					this->stat_decompr_blocks++;
@@ -287,7 +289,8 @@ int jffs2_decompress(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 				return ret;
 			}
 		}
-		printk(KERN_WARNING "JFFS2 compression type 0x%02x not available.\n", comprtype);
+		pr_warn("JFFS2 compression type 0x%02x not available\n",
+			comprtype);
 		spin_unlock(&jffs2_compressor_list_lock);
 		return -EIO;
 	}
@@ -299,7 +302,7 @@ int jffs2_register_compressor(struct jffs2_compressor *comp)
 	struct jffs2_compressor *this;
 
 	if (!comp->name) {
-		printk(KERN_WARNING "NULL compressor name at registering JFFS2 compressor. Failed.\n");
+		pr_warn("NULL compressor name at registering JFFS2 compressor. Failed.\n");
 		return -1;
 	}
 	comp->compr_buf_size=0;
@@ -340,7 +343,7 @@ int jffs2_unregister_compressor(struct jffs2_compressor *comp)
 
 	if (comp->usecount) {
 		spin_unlock(&jffs2_compressor_list_lock);
-		printk(KERN_WARNING "JFFS2: Compressor module is in use. Unregister failed.\n");
+		pr_warn("JFFS2: Compressor module is in use. Unregister failed.\n");
 		return -1;
 	}
 	list_del(&comp->list);
diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 40979c9..88529e4 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -79,7 +79,7 @@ static int jffs2_zlib_compress(unsigned char *data_in,
 	mutex_lock(&deflate_mutex);
 
 	if (Z_OK != zlib_deflateInit(&def_strm, 3)) {
-		printk(KERN_WARNING "deflateInit failed\n");
+		pr_warn("deflateInit failed\n");
 		mutex_unlock(&deflate_mutex);
 		return -1;
 	}
@@ -169,7 +169,7 @@ static int jffs2_zlib_decompress(unsigned char *data_in,
 
 
 	if (Z_OK != zlib_inflateInit2(&inf_strm, wbits)) {
-		printk(KERN_WARNING "inflateInit failed\n");
+		pr_warn("inflateInit failed\n");
 		mutex_unlock(&inflate_mutex);
 		return 1;
 	}
@@ -177,7 +177,7 @@ static int jffs2_zlib_decompress(unsigned char *data_in,
 	while((ret = zlib_inflate(&inf_strm, Z_FINISH)) == Z_OK)
 		;
 	if (ret != Z_STREAM_END) {
-		printk(KERN_NOTICE "inflate returned %d\n", ret);
+		pr_notice("inflate returned %d\n", ret);
 	}
 	zlib_inflateEnd(&inf_strm);
 	mutex_unlock(&inflate_mutex);
diff --git a/fs/jffs2/debug.c b/fs/jffs2/debug.c
index e0b76c8..6cac7d6 100644
--- a/fs/jffs2/debug.c
+++ b/fs/jffs2/debug.c
@@ -261,12 +261,15 @@ void __jffs2_dbg_superblock_counts(struct jffs2_sb_info *c)
 		bad += c->sector_size;
 	}
 
-#define check(sz) \
-	if (sz != c->sz##_size) {			\
-		printk(KERN_WARNING #sz "_size mismatch counted 0x%x, c->" #sz "_size 0x%x\n", \
-		       sz, c->sz##_size);		\
-		dump = 1;				\
-	}
+#define check(sz)							\
+do {									\
+	if (sz != c->sz##_size) {					\
+		pr_warn("%s_size mismatch counted 0x%x, c->%s_size 0x%x\n", \
+			#sz, #sz, sz, c->sz##_size);			\
+		dump = 1;						\
+	}								\
+} while (0)
+
 	check(free);
 	check(dirty);
 	check(used);
@@ -274,11 +277,12 @@ void __jffs2_dbg_superblock_counts(struct jffs2_sb_info *c)
 	check(unchecked);
 	check(bad);
 	check(erasing);
+
 #undef check
 
 	if (nr_counted != c->nr_blocks) {
-		printk(KERN_WARNING "%s counted only 0x%x blocks of 0x%x. Where are the others?\n",
-		       __func__, nr_counted, c->nr_blocks);
+		pr_warn("%s counted only 0x%x blocks of 0x%x. Where are the others?\n",
+			__func__, nr_counted, c->nr_blocks);
 		dump = 1;
 	}
 
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 01a07af..a7a3c1a 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -103,7 +103,7 @@ static struct dentry *jffs2_lookup(struct inode *dir_i, struct dentry *target,
 	if (ino) {
 		inode = jffs2_iget(dir_i->i_sb, ino);
 		if (IS_ERR(inode))
-			printk(KERN_WARNING "iget() failed for ino #%u\n", ino);
+			pr_warn("iget() failed for ino #%u\n", ino);
 	}
 
 	return d_splice_alias(inode, target);
@@ -365,7 +365,7 @@ static int jffs2_symlink (struct inode *dir_i, struct dentry *dentry, const char
 	/* We use f->target field to store the target path. */
 	f->target = kmemdup(target, targetlen + 1, GFP_KERNEL);
 	if (!f->target) {
-		printk(KERN_WARNING "Can't allocate %d bytes of memory\n", targetlen + 1);
+		pr_warn("Can't allocate %d bytes of memory\n", targetlen + 1);
 		mutex_unlock(&f->sem);
 		jffs2_complete_reservation(c);
 		ret = -ENOMEM;
@@ -860,7 +860,8 @@ static int jffs2_rename (struct inode *old_dir_i, struct dentry *old_dentry,
 			f->inocache->pino_nlink++;
 		mutex_unlock(&f->sem);
 
-		printk(KERN_NOTICE "jffs2_rename(): Link succeeded, unlink failed (err %d). You now have a hard link\n", ret);
+		pr_notice("%s(): Link succeeded, unlink failed (err %d). You now have a hard link\n",
+			  __func__, ret);
 		/* Might as well let the VFS know */
 		d_instantiate(new_dentry, old_dentry->d_inode);
 		ihold(old_dentry->d_inode);
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index ee1cd98..5f14309 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -51,7 +51,7 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
 		  jeb->offset, jeb->offset, jeb->offset + c->sector_size);
 	instr = kmalloc(sizeof(struct erase_info) + sizeof(struct erase_priv_struct), GFP_KERNEL);
 	if (!instr) {
-		printk(KERN_WARNING "kmalloc for struct erase_info in jffs2_erase_block failed. Refiling block for later\n");
+		pr_warn("kmalloc for struct erase_info in jffs2_erase_block failed. Refiling block for later\n");
 		mutex_lock(&c->erase_free_sem);
 		spin_lock(&c->erase_completion_lock);
 		list_move(&jeb->list, &c->erase_pending_list);
@@ -99,9 +99,11 @@ static void jffs2_erase_block(struct jffs2_sb_info *c,
 	}
 
 	if (ret == -EROFS)
-		printk(KERN_WARNING "Erase at 0x%08x failed immediately: -EROFS. Is the sector locked?\n", jeb->offset);
+		pr_warn("Erase at 0x%08x failed immediately: -EROFS. Is the sector locked?\n",
+			jeb->offset);
 	else
-		printk(KERN_WARNING "Erase at 0x%08x failed immediately: errno %d\n", jeb->offset, ret);
+		pr_warn("Erase at 0x%08x failed immediately: errno %d\n",
+			jeb->offset, ret);
 
 	jffs2_erase_failed(c, jeb, bad_offset);
 }
@@ -217,7 +219,7 @@ static void jffs2_erase_callback(struct erase_info *instr)
 	struct erase_priv_struct *priv = (void *)instr->priv;
 
 	if(instr->state != MTD_ERASE_DONE) {
-		printk(KERN_WARNING "Erase at 0x%08llx finished, but state != MTD_ERASE_DONE. State is 0x%x instead.\n",
+		pr_warn("Erase at 0x%08llx finished, but state != MTD_ERASE_DONE. State is 0x%x instead.\n",
 			(unsigned long long)instr->addr, instr->state);
 		jffs2_erase_failed(priv->c, priv->jeb, instr->fail_addr);
 	} else {
@@ -284,7 +286,7 @@ static inline void jffs2_remove_node_refs_from_ino_list(struct jffs2_sb_info *c,
 
 		printk(KERN_DEBUG);
 		while(this) {
-			printk(KERN_CONT "0x%08x(%d)->",
+			pr_cont("0x%08x(%d)->",
 			       ref_offset(this), ref_flags(this));
 			if (++i == 5) {
 				printk(KERN_DEBUG);
@@ -292,7 +294,7 @@ static inline void jffs2_remove_node_refs_from_ino_list(struct jffs2_sb_info *c,
 			}
 			this = this->next_in_ino;
 		}
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 	});
 
 	switch (ic->class) {
@@ -364,8 +366,10 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
 		} while(--retlen);
 		mtd_unpoint(c->mtd, jeb->offset, c->sector_size);
 		if (retlen) {
-			printk(KERN_WARNING "Newly-erased block contained word 0x%lx at offset 0x%08tx\n",
-			       *wordebuf, jeb->offset + c->sector_size-retlen*sizeof(*wordebuf));
+			pr_warn("Newly-erased block contained word 0x%lx at offset 0x%08tx\n",
+				*wordebuf,
+				jeb->offset +
+				c->sector_size-retlen * sizeof(*wordebuf));
 			return -EIO;
 		}
 		return 0;
@@ -373,7 +377,8 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
  do_flash_read:
 	ebuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!ebuf) {
-		printk(KERN_WARNING "Failed to allocate page buffer for verifying erase at 0x%08x. Refiling\n", jeb->offset);
+		pr_warn("Failed to allocate page buffer for verifying erase at 0x%08x. Refiling\n",
+			jeb->offset);
 		return -EAGAIN;
 	}
 
@@ -387,12 +392,14 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
 
 		ret = mtd_read(c->mtd, ofs, readlen, &retlen, ebuf);
 		if (ret) {
-			printk(KERN_WARNING "Read of newly-erased block at 0x%08x failed: %d. Putting on bad_list\n", ofs, ret);
+			pr_warn("Read of newly-erased block at 0x%08x failed: %d. Putting on bad_list\n",
+				ofs, ret);
 			ret = -EIO;
 			goto fail;
 		}
 		if (retlen != readlen) {
-			printk(KERN_WARNING "Short read from newly-erased block at 0x%08x. Wanted %d, got %zd\n", ofs, readlen, retlen);
+			pr_warn("Short read from newly-erased block at 0x%08x. Wanted %d, got %zd\n",
+				ofs, readlen, retlen);
 			ret = -EIO;
 			goto fail;
 		}
@@ -401,7 +408,8 @@ static int jffs2_block_check_erase(struct jffs2_sb_info *c, struct jffs2_erasebl
 			unsigned long *datum = ebuf + i;
 			if (*datum + 1) {
 				*bad_offset += i;
-				printk(KERN_WARNING "Newly-erased block contained word 0x%lx at offset 0x%08x\n", *datum, *bad_offset);
+				pr_warn("Newly-erased block contained word 0x%lx at offset 0x%08x\n",
+					*datum, *bad_offset);
 				ret = -EIO;
 				goto fail;
 			}
@@ -456,10 +464,10 @@ static void jffs2_mark_erased_block(struct jffs2_sb_info *c, struct jffs2_eraseb
 
 		if (ret || retlen != sizeof(marker)) {
 			if (ret)
-				printk(KERN_WARNING "Write clean marker to block at 0x%08x failed: %d\n",
+				pr_warn("Write clean marker to block at 0x%08x failed: %d\n",
 				       jeb->offset, ret);
 			else
-				printk(KERN_WARNING "Short write to newly-erased block at 0x%08x: Wanted %zd, got %zd\n",
+				pr_warn("Short write to newly-erased block at 0x%08x: Wanted %zd, got %zd\n",
 				       jeb->offset, sizeof(marker), retlen);
 
 			goto filebad;
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index aad632e..0da3ca3 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -320,14 +320,16 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		/* Read the device numbers from the media */
 		if (f->metadata->size != sizeof(jdev.old_id) &&
 		    f->metadata->size != sizeof(jdev.new_id)) {
-			printk(KERN_NOTICE "Device node has strange size %d\n", f->metadata->size);
+			pr_notice("Device node has strange size %d\n",
+				  f->metadata->size);
 			goto error_io;
 		}
 		jffs2_dbg(1, "Reading device numbers from flash\n");
 		ret = jffs2_read_dnode(c, f, f->metadata, (char *)&jdev, 0, f->metadata->size);
 		if (ret < 0) {
 			/* Eep */
-			printk(KERN_NOTICE "Read device numbers for inode %lu failed\n", (unsigned long)inode->i_ino);
+			pr_notice("Read device numbers for inode %lu failed\n",
+				  (unsigned long)inode->i_ino);
 			goto error;
 		}
 		if (f->metadata->size == sizeof(jdev.old_id))
@@ -342,7 +344,8 @@ struct inode *jffs2_iget(struct super_block *sb, unsigned long ino)
 		break;
 
 	default:
-		printk(KERN_WARNING "jffs2_read_inode(): Bogus imode %o for ino %lu\n", inode->i_mode, (unsigned long)inode->i_ino);
+		pr_warn("%s(): Bogus i_mode %o for ino %lu\n",
+			__func__, inode->i_mode, (unsigned long)inode->i_ino);
 	}
 
 	mutex_unlock(&f->sem);
@@ -510,11 +513,11 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 
 #ifndef CONFIG_JFFS2_FS_WRITEBUFFER
 	if (c->mtd->type == MTD_NANDFLASH) {
-		printk(KERN_ERR "jffs2: Cannot operate on NAND flash unless jffs2 NAND support is compiled in.\n");
+		pr_err("jffs2: Cannot operate on NAND flash unless jffs2 NAND support is compiled in.\n");
 		return -EINVAL;
 	}
 	if (c->mtd->type == MTD_DATAFLASH) {
-		printk(KERN_ERR "jffs2: Cannot operate on DataFlash unless jffs2 DataFlash support is compiled in.\n");
+		pr_err("jffs2: Cannot operate on DataFlash unless jffs2 DataFlash support is compiled in.\n");
 		return -EINVAL;
 	}
 #endif
@@ -528,12 +531,13 @@ int jffs2_do_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	if ((c->sector_size * blocks) != c->flash_size) {
 		c->flash_size = c->sector_size * blocks;
-		printk(KERN_INFO "jffs2: Flash size not aligned to erasesize, reducing to %dKiB\n",
+		pr_info("jffs2: Flash size not aligned to erasesize, reducing to %dKiB\n",
 			c->flash_size / 1024);
 	}
 
 	if (c->flash_size < 5*c->sector_size) {
-		printk(KERN_ERR "jffs2: Too few erase blocks (%d)\n", c->flash_size / c->sector_size);
+		pr_err("jffs2: Too few erase blocks (%d)\n",
+		       c->flash_size / c->sector_size);
 		return -EINVAL;
 	}
 
@@ -656,8 +660,8 @@ struct jffs2_inode_info *jffs2_gc_fetch_inode(struct jffs2_sb_info *c,
 			return ERR_CAST(inode);
 	}
 	if (is_bad_inode(inode)) {
-		printk(KERN_NOTICE "Eep. read_inode() failed for ino #%u. unlinked %d\n",
-		       inum, unlinked);
+		pr_notice("Eep. read_inode() failed for ino #%u. unlinked %d\n",
+			  inum, unlinked);
 		/* NB. This will happen again. We need to do something appropriate here. */
 		iput(inode);
 		return ERR_PTR(-EIO);
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 85e703a..d7936d0 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -97,7 +97,8 @@ again:
 	c->gcblock = ret;
 	ret->gc_node = ret->first_node;
 	if (!ret->gc_node) {
-		printk(KERN_WARNING "Eep. ret->gc_node for block at 0x%08x is NULL\n", ret->offset);
+		pr_warn("Eep. ret->gc_node for block at 0x%08x is NULL\n",
+			ret->offset);
 		BUG();
 	}
 
@@ -141,8 +142,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 
 		/* checked_ino is protected by the alloc_sem */
 		if (c->checked_ino > c->highest_ino && xattr) {
-			printk(KERN_CRIT "Checked all inodes but still 0x%x bytes of unchecked space?\n",
-			       c->unchecked_size);
+			pr_crit("Checked all inodes but still 0x%x bytes of unchecked space?\n",
+				c->unchecked_size);
 			jffs2_dbg_dump_block_lists_nolock(c);
 			spin_unlock(&c->erase_completion_lock);
 			mutex_unlock(&c->alloc_sem);
@@ -180,7 +181,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 
 		case INO_STATE_GC:
 		case INO_STATE_CHECKING:
-			printk(KERN_WARNING "Inode #%u is in state %d during CRC check phase!\n", ic->ino, ic->state);
+			pr_warn("Inode #%u is in state %d during CRC check phase!\n",
+				ic->ino, ic->state);
 			spin_unlock(&c->inocache_lock);
 			BUG();
 
@@ -212,7 +214,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 
 		ret = jffs2_do_crccheck_inode(c, ic);
 		if (ret)
-			printk(KERN_WARNING "Returned error for crccheck of ino #%u. Expect badness...\n", ic->ino);
+			pr_warn("Returned error for crccheck of ino #%u. Expect badness...\n",
+				ic->ino);
 
 		jffs2_set_inocache_state(c, ic, INO_STATE_CHECKEDABSENT);
 		mutex_unlock(&c->alloc_sem);
@@ -270,9 +273,10 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 			  ref_offset(raw));
 		raw = ref_next(raw);
 		if (unlikely(!raw)) {
-			printk(KERN_WARNING "eep. End of raw list while still supposedly nodes to GC\n");
-			printk(KERN_WARNING "erase block at 0x%08x. free_size 0x%08x, dirty_size 0x%08x, used_size 0x%08x\n",
-			       jeb->offset, jeb->free_size, jeb->dirty_size, jeb->used_size);
+			pr_warn("eep. End of raw list while still supposedly nodes to GC\n");
+			pr_warn("erase block at 0x%08x. free_size 0x%08x, dirty_size 0x%08x, used_size 0x%08x\n",
+				jeb->offset, jeb->free_size,
+				jeb->dirty_size, jeb->used_size);
 			jeb->gc_node = raw;
 			spin_unlock(&c->erase_completion_lock);
 			mutex_unlock(&c->alloc_sem);
@@ -362,8 +366,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
 		   we're holding the alloc_sem, no other garbage collection
 		   can happen.
 		*/
-		printk(KERN_CRIT "Inode #%u already in state %d in jffs2_garbage_collect_pass()!\n",
-		       ic->ino, ic->state);
+		pr_crit("Inode #%u already in state %d in jffs2_garbage_collect_pass()!\n",
+			ic->ino, ic->state);
 		mutex_unlock(&c->alloc_sem);
 		spin_unlock(&c->inocache_lock);
 		BUG();
@@ -442,7 +446,8 @@ int jffs2_garbage_collect_pass(struct jffs2_sb_info *c)
  test_gcnode:
 	if (jeb->dirty_size == gcblock_dirty && !ref_obsolete(jeb->gc_node)) {
 		/* Eep. This really should never happen. GC is broken */
-		printk(KERN_ERR "Error garbage collecting node at %08x!\n", ref_offset(jeb->gc_node));
+		pr_err("Error garbage collecting node at %08x!\n",
+		       ref_offset(jeb->gc_node));
 		ret = -ENOSPC;
 	}
  release_sem:
@@ -546,10 +551,10 @@ static int jffs2_garbage_collect_live(struct jffs2_sb_info *c,  struct jffs2_era
 	} else if (fd) {
 		ret = jffs2_garbage_collect_deletion_dirent(c, jeb, f, fd);
 	} else {
-		printk(KERN_WARNING "Raw node at 0x%08x wasn't in node lists for ino #%u\n",
-		       ref_offset(raw), f->inocache->ino);
+		pr_warn("Raw node at 0x%08x wasn't in node lists for ino #%u\n",
+			ref_offset(raw), f->inocache->ino);
 		if (ref_obsolete(raw)) {
-			printk(KERN_WARNING "But it's obsolete so we don't mind too much\n");
+			pr_warn("But it's obsolete so we don't mind too much\n");
 		} else {
 			jffs2_dbg_dump_node(c, ref_offset(raw));
 			BUG();
@@ -606,8 +611,8 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 
 	crc = crc32(0, node, sizeof(struct jffs2_unknown_node)-4);
 	if (je32_to_cpu(node->u.hdr_crc) != crc) {
-		printk(KERN_WARNING "Header CRC failed on REF_PRISTINE node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-		       ref_offset(raw), je32_to_cpu(node->u.hdr_crc), crc);
+		pr_warn("Header CRC failed on REF_PRISTINE node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+			ref_offset(raw), je32_to_cpu(node->u.hdr_crc), crc);
 		goto bail;
 	}
 
@@ -615,16 +620,18 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 	case JFFS2_NODETYPE_INODE:
 		crc = crc32(0, node, sizeof(node->i)-8);
 		if (je32_to_cpu(node->i.node_crc) != crc) {
-			printk(KERN_WARNING "Node CRC failed on REF_PRISTINE data node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-			       ref_offset(raw), je32_to_cpu(node->i.node_crc), crc);
+			pr_warn("Node CRC failed on REF_PRISTINE data node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+				ref_offset(raw), je32_to_cpu(node->i.node_crc),
+				crc);
 			goto bail;
 		}
 
 		if (je32_to_cpu(node->i.dsize)) {
 			crc = crc32(0, node->i.data, je32_to_cpu(node->i.csize));
 			if (je32_to_cpu(node->i.data_crc) != crc) {
-				printk(KERN_WARNING "Data CRC failed on REF_PRISTINE data node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-				       ref_offset(raw), je32_to_cpu(node->i.data_crc), crc);
+				pr_warn("Data CRC failed on REF_PRISTINE data node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+					ref_offset(raw),
+					je32_to_cpu(node->i.data_crc), crc);
 				goto bail;
 			}
 		}
@@ -633,21 +640,24 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 	case JFFS2_NODETYPE_DIRENT:
 		crc = crc32(0, node, sizeof(node->d)-8);
 		if (je32_to_cpu(node->d.node_crc) != crc) {
-			printk(KERN_WARNING "Node CRC failed on REF_PRISTINE dirent node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-			       ref_offset(raw), je32_to_cpu(node->d.node_crc), crc);
+			pr_warn("Node CRC failed on REF_PRISTINE dirent node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+				ref_offset(raw),
+				je32_to_cpu(node->d.node_crc), crc);
 			goto bail;
 		}
 
 		if (strnlen(node->d.name, node->d.nsize) != node->d.nsize) {
-			printk(KERN_WARNING "Name in dirent node at 0x%08x contains zeroes\n", ref_offset(raw));
+			pr_warn("Name in dirent node at 0x%08x contains zeroes\n",
+				ref_offset(raw));
 			goto bail;
 		}
 
 		if (node->d.nsize) {
 			crc = crc32(0, node->d.name, node->d.nsize);
 			if (je32_to_cpu(node->d.name_crc) != crc) {
-				printk(KERN_WARNING "Name CRC failed on REF_PRISTINE dirent node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-				       ref_offset(raw), je32_to_cpu(node->d.name_crc), crc);
+				pr_warn("Name CRC failed on REF_PRISTINE dirent node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+					ref_offset(raw),
+					je32_to_cpu(node->d.name_crc), crc);
 				goto bail;
 			}
 		}
@@ -655,8 +665,8 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 	default:
 		/* If it's inode-less, we don't _know_ what it is. Just copy it intact */
 		if (ic) {
-			printk(KERN_WARNING "Unknown node type for REF_PRISTINE node at 0x%08x: 0x%04x\n",
-			       ref_offset(raw), je16_to_cpu(node->u.nodetype));
+			pr_warn("Unknown node type for REF_PRISTINE node at 0x%08x: 0x%04x\n",
+				ref_offset(raw), je16_to_cpu(node->u.nodetype));
 			goto bail;
 		}
 	}
@@ -668,12 +678,13 @@ static int jffs2_garbage_collect_pristine(struct jffs2_sb_info *c,
 	ret = jffs2_flash_write(c, phys_ofs, rawlen, &retlen, (char *)node);
 
 	if (ret || (retlen != rawlen)) {
-		printk(KERN_NOTICE "Write of %d bytes at 0x%08x failed. returned %d, retlen %zd\n",
-		       rawlen, phys_ofs, ret, retlen);
+		pr_notice("Write of %d bytes at 0x%08x failed. returned %d, retlen %zd\n",
+			  rawlen, phys_ofs, ret, retlen);
 		if (retlen) {
 			jffs2_add_physical_node_ref(c, phys_ofs | REF_OBSOLETE, rawlen, NULL);
 		} else {
-			printk(KERN_NOTICE "Not marking the space at 0x%08x as dirty because the flash driver returned retlen zero\n", phys_ofs);
+			pr_notice("Not marking the space at 0x%08x as dirty because the flash driver returned retlen zero\n",
+				  phys_ofs);
 		}
 		if (!retried) {
 			/* Try to reallocate space and retry */
@@ -745,12 +756,13 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 		mdatalen = fn->size;
 		mdata = kmalloc(fn->size, GFP_KERNEL);
 		if (!mdata) {
-			printk(KERN_WARNING "kmalloc of mdata failed in jffs2_garbage_collect_metadata()\n");
+			pr_warn("kmalloc of mdata failed in jffs2_garbage_collect_metadata()\n");
 			return -ENOMEM;
 		}
 		ret = jffs2_read_dnode(c, f, fn, mdata, 0, mdatalen);
 		if (ret) {
-			printk(KERN_WARNING "read of old metadata failed in jffs2_garbage_collect_metadata(): %d\n", ret);
+			pr_warn("read of old metadata failed in jffs2_garbage_collect_metadata(): %d\n",
+				ret);
 			kfree(mdata);
 			return ret;
 		}
@@ -762,8 +774,8 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 	ret = jffs2_reserve_space_gc(c, sizeof(ri) + mdatalen, &alloclen,
 				JFFS2_SUMMARY_INODE_SIZE);
 	if (ret) {
-		printk(KERN_WARNING "jffs2_reserve_space_gc of %zd bytes for garbage_collect_metadata failed: %d\n",
-		       sizeof(ri)+ mdatalen, ret);
+		pr_warn("jffs2_reserve_space_gc of %zd bytes for garbage_collect_metadata failed: %d\n",
+			sizeof(ri) + mdatalen, ret);
 		goto out;
 	}
 
@@ -800,7 +812,7 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 	new_fn = jffs2_write_dnode(c, f, &ri, mdata, mdatalen, ALLOC_GC);
 
 	if (IS_ERR(new_fn)) {
-		printk(KERN_WARNING "Error writing new dnode: %ld\n", PTR_ERR(new_fn));
+		pr_warn("Error writing new dnode: %ld\n", PTR_ERR(new_fn));
 		ret = PTR_ERR(new_fn);
 		goto out;
 	}
@@ -843,14 +855,15 @@ static int jffs2_garbage_collect_dirent(struct jffs2_sb_info *c, struct jffs2_er
 	ret = jffs2_reserve_space_gc(c, sizeof(rd)+rd.nsize, &alloclen,
 				JFFS2_SUMMARY_DIRENT_SIZE(rd.nsize));
 	if (ret) {
-		printk(KERN_WARNING "jffs2_reserve_space_gc of %zd bytes for garbage_collect_dirent failed: %d\n",
-		       sizeof(rd)+rd.nsize, ret);
+		pr_warn("jffs2_reserve_space_gc of %zd bytes for garbage_collect_dirent failed: %d\n",
+			sizeof(rd)+rd.nsize, ret);
 		return ret;
 	}
 	new_fd = jffs2_write_dirent(c, f, &rd, fd->name, rd.nsize, ALLOC_GC);
 
 	if (IS_ERR(new_fd)) {
-		printk(KERN_WARNING "jffs2_write_dirent in garbage_collect_dirent failed: %ld\n", PTR_ERR(new_fd));
+		pr_warn("jffs2_write_dirent in garbage_collect_dirent failed: %ld\n",
+			PTR_ERR(new_fd));
 		return PTR_ERR(new_fd);
 	}
 	jffs2_add_fd_to_list(c, new_fd, &f->dents);
@@ -910,13 +923,15 @@ static int jffs2_garbage_collect_deletion_dirent(struct jffs2_sb_info *c, struct
 			   length. We need to take a closer look...*/
 			ret = jffs2_flash_read(c, ref_offset(raw), rawlen, &retlen, (char *)rd);
 			if (ret) {
-				printk(KERN_WARNING "jffs2_g_c_deletion_dirent(): Read error (%d) reading obsolete node at %08x\n", ret, ref_offset(raw));
+				pr_warn("%s(): Read error (%d) reading obsolete node at %08x\n",
+					__func__, ret, ref_offset(raw));
 				/* If we can't read it, we don't need to continue to obsolete it. Continue */
 				continue;
 			}
 			if (retlen != rawlen) {
-				printk(KERN_WARNING "jffs2_g_c_deletion_dirent(): Short read (%zd not %u) reading header from obsolete node at %08x\n",
-				       retlen, rawlen, ref_offset(raw));
+				pr_warn("%s(): Short read (%zd not %u) reading header from obsolete node at %08x\n",
+					__func__, retlen, rawlen,
+					ref_offset(raw));
 				continue;
 			}
 
@@ -965,7 +980,8 @@ static int jffs2_garbage_collect_deletion_dirent(struct jffs2_sb_info *c, struct
 		fdp = &(*fdp)->next;
 	}
 	if (!found) {
-		printk(KERN_WARNING "Deletion dirent \"%s\" not found in list for ino #%u\n", fd->name, f->inocache->ino);
+		pr_warn("Deletion dirent \"%s\" not found in list for ino #%u\n",
+			fd->name, f->inocache->ino);
 	}
 	jffs2_mark_node_obsolete(c, fd->raw);
 	jffs2_free_full_dirent(fd);
@@ -994,35 +1010,37 @@ static int jffs2_garbage_collect_hole(struct jffs2_sb_info *c, struct jffs2_eras
 		   write it out again with the _same_ version as before */
 		ret = jffs2_flash_read(c, ref_offset(fn->raw), sizeof(ri), &readlen, (char *)&ri);
 		if (readlen != sizeof(ri) || ret) {
-			printk(KERN_WARNING "Node read failed in jffs2_garbage_collect_hole. Ret %d, retlen %zd. Data will be lost by writing new hole node\n", ret, readlen);
+			pr_warn("Node read failed in jffs2_garbage_collect_hole. Ret %d, retlen %zd. Data will be lost by writing new hole node\n",
+				ret, readlen);
 			goto fill;
 		}
 		if (je16_to_cpu(ri.nodetype) != JFFS2_NODETYPE_INODE) {
-			printk(KERN_WARNING "jffs2_garbage_collect_hole: Node at 0x%08x had node type 0x%04x instead of JFFS2_NODETYPE_INODE(0x%04x)\n",
-			       ref_offset(fn->raw),
-			       je16_to_cpu(ri.nodetype), JFFS2_NODETYPE_INODE);
+			pr_warn("%s(): Node at 0x%08x had node type 0x%04x instead of JFFS2_NODETYPE_INODE(0x%04x)\n",
+				__func__, ref_offset(fn->raw),
+				je16_to_cpu(ri.nodetype), JFFS2_NODETYPE_INODE);
 			return -EIO;
 		}
 		if (je32_to_cpu(ri.totlen) != sizeof(ri)) {
-			printk(KERN_WARNING "jffs2_garbage_collect_hole: Node at 0x%08x had totlen 0x%x instead of expected 0x%zx\n",
-			       ref_offset(fn->raw),
-			       je32_to_cpu(ri.totlen), sizeof(ri));
+			pr_warn("%s(): Node at 0x%08x had totlen 0x%x instead of expected 0x%zx\n",
+				__func__, ref_offset(fn->raw),
+				je32_to_cpu(ri.totlen), sizeof(ri));
 			return -EIO;
 		}
 		crc = crc32(0, &ri, sizeof(ri)-8);
 		if (crc != je32_to_cpu(ri.node_crc)) {
-			printk(KERN_WARNING "jffs2_garbage_collect_hole: Node at 0x%08x had CRC 0x%08x which doesn't match calculated CRC 0x%08x\n",
-			       ref_offset(fn->raw),
-			       je32_to_cpu(ri.node_crc), crc);
+			pr_warn("%s: Node at 0x%08x had CRC 0x%08x which doesn't match calculated CRC 0x%08x\n",
+				__func__, ref_offset(fn->raw),
+				je32_to_cpu(ri.node_crc), crc);
 			/* FIXME: We could possibly deal with this by writing new holes for each frag */
-			printk(KERN_WARNING "Data in the range 0x%08x to 0x%08x of inode #%u will be lost\n",
-			       start, end, f->inocache->ino);
+			pr_warn("Data in the range 0x%08x to 0x%08x of inode #%u will be lost\n",
+				start, end, f->inocache->ino);
 			goto fill;
 		}
 		if (ri.compr != JFFS2_COMPR_ZERO) {
-			printk(KERN_WARNING "jffs2_garbage_collect_hole: Node 0x%08x wasn't a hole node!\n", ref_offset(fn->raw));
-			printk(KERN_WARNING "Data in the range 0x%08x to 0x%08x of inode #%u will be lost\n",
-			       start, end, f->inocache->ino);
+			pr_warn("%s(): Node 0x%08x wasn't a hole node!\n",
+				__func__, ref_offset(fn->raw));
+			pr_warn("Data in the range 0x%08x to 0x%08x of inode #%u will be lost\n",
+				start, end, f->inocache->ino);
 			goto fill;
 		}
 	} else {
@@ -1061,14 +1079,14 @@ static int jffs2_garbage_collect_hole(struct jffs2_sb_info *c, struct jffs2_eras
 	ret = jffs2_reserve_space_gc(c, sizeof(ri), &alloclen,
 				     JFFS2_SUMMARY_INODE_SIZE);
 	if (ret) {
-		printk(KERN_WARNING "jffs2_reserve_space_gc of %zd bytes for garbage_collect_hole failed: %d\n",
-		       sizeof(ri), ret);
+		pr_warn("jffs2_reserve_space_gc of %zd bytes for garbage_collect_hole failed: %d\n",
+			sizeof(ri), ret);
 		return ret;
 	}
 	new_fn = jffs2_write_dnode(c, f, &ri, NULL, 0, ALLOC_GC);
 
 	if (IS_ERR(new_fn)) {
-		printk(KERN_WARNING "Error writing new hole node: %ld\n", PTR_ERR(new_fn));
+		pr_warn("Error writing new hole node: %ld\n", PTR_ERR(new_fn));
 		return PTR_ERR(new_fn);
 	}
 	if (je32_to_cpu(ri.version) == f->highest_version) {
@@ -1088,9 +1106,9 @@ static int jffs2_garbage_collect_hole(struct jffs2_sb_info *c, struct jffs2_eras
 	 * above.)
 	 */
 	D1(if(unlikely(fn->frags <= 1)) {
-		printk(KERN_WARNING "jffs2_garbage_collect_hole: Replacing fn with %d frag(s) but new ver %d != highest_version %d of ino #%d\n",
-		       fn->frags, je32_to_cpu(ri.version), f->highest_version,
-		       je32_to_cpu(ri.ino));
+			pr_warn("%s(): Replacing fn with %d frag(s) but new ver %d != highest_version %d of ino #%d\n",
+				__func__, fn->frags, je32_to_cpu(ri.version),
+				f->highest_version, je32_to_cpu(ri.ino));
 	});
 
 	/* This is a partially-overlapped hole node. Mark it REF_NORMAL not REF_PRISTINE */
@@ -1107,11 +1125,11 @@ static int jffs2_garbage_collect_hole(struct jffs2_sb_info *c, struct jffs2_eras
 		}
 	}
 	if (fn->frags) {
-		printk(KERN_WARNING "jffs2_garbage_collect_hole: Old node still has frags!\n");
+		pr_warn("%s(): Old node still has frags!\n", __func__);
 		BUG();
 	}
 	if (!new_fn->frags) {
-		printk(KERN_WARNING "jffs2_garbage_collect_hole: New node has no frags!\n");
+		pr_warn("%s(): New node has no frags!\n", __func__);
 		BUG();
 	}
 
@@ -1286,7 +1304,8 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 	pg_ptr = jffs2_gc_fetch_page(c, f, start, &pg);
 
 	if (IS_ERR(pg_ptr)) {
-		printk(KERN_WARNING "read_cache_page() returned error: %ld\n", PTR_ERR(pg_ptr));
+		pr_warn("read_cache_page() returned error: %ld\n",
+			PTR_ERR(pg_ptr));
 		return PTR_ERR(pg_ptr);
 	}
 
@@ -1300,8 +1319,8 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 					&alloclen, JFFS2_SUMMARY_INODE_SIZE);
 
 		if (ret) {
-			printk(KERN_WARNING "jffs2_reserve_space_gc of %zd bytes for garbage_collect_dnode failed: %d\n",
-			       sizeof(ri)+ JFFS2_MIN_DATA_LEN, ret);
+			pr_warn("jffs2_reserve_space_gc of %zd bytes for garbage_collect_dnode failed: %d\n",
+				sizeof(ri) + JFFS2_MIN_DATA_LEN, ret);
 			break;
 		}
 		cdatalen = min_t(uint32_t, alloclen - sizeof(ri), end - offset);
@@ -1338,7 +1357,8 @@ static int jffs2_garbage_collect_dnode(struct jffs2_sb_info *c, struct jffs2_era
 		jffs2_free_comprbuf(comprbuf, writebuf);
 
 		if (IS_ERR(new_fn)) {
-			printk(KERN_WARNING "Error writing new dnode: %ld\n", PTR_ERR(new_fn));
+			pr_warn("Error writing new dnode: %ld\n",
+				PTR_ERR(new_fn));
 			ret = PTR_ERR(new_fn);
 			break;
 		}
diff --git a/fs/jffs2/nodelist.c b/fs/jffs2/nodelist.c
index 5e03233..fc16761 100644
--- a/fs/jffs2/nodelist.c
+++ b/fs/jffs2/nodelist.c
@@ -687,8 +687,8 @@ int jffs2_scan_dirty_space(struct jffs2_sb_info *c, struct jffs2_eraseblock *jeb
 	if (!size)
 		return 0;
 	if (unlikely(size > jeb->free_size)) {
-		printk(KERN_CRIT "Dirty space 0x%x larger then free_size 0x%x (wasted 0x%x)\n",
-		       size, jeb->free_size, jeb->wasted_size);
+		pr_crit("Dirty space 0x%x larger then free_size 0x%x (wasted 0x%x)\n",
+			size, jeb->free_size, jeb->wasted_size);
 		BUG();
 	}
 	/* REF_EMPTY_NODE is !obsolete, so that works OK */
@@ -726,8 +726,10 @@ static inline uint32_t __ref_totlen(struct jffs2_sb_info *c,
 
 		/* Last node in block. Use free_space */
 		if (unlikely(ref != jeb->last_node)) {
-			printk(KERN_CRIT "ref %p @0x%08x is not jeb->last_node (%p @0x%08x)\n",
-			       ref, ref_offset(ref), jeb->last_node, jeb->last_node?ref_offset(jeb->last_node):0);
+			pr_crit("ref %p @0x%08x is not jeb->last_node (%p @0x%08x)\n",
+				ref, ref_offset(ref), jeb->last_node,
+				jeb->last_node ?
+				ref_offset(jeb->last_node) : 0);
 			BUG();
 		}
 		ref_end = jeb->offset + c->sector_size - jeb->free_size;
@@ -747,16 +749,20 @@ uint32_t __jffs2_ref_totlen(struct jffs2_sb_info *c, struct jffs2_eraseblock *je
 		if (!jeb)
 			jeb = &c->blocks[ref->flash_offset / c->sector_size];
 
-		printk(KERN_CRIT "Totlen for ref at %p (0x%08x-0x%08x) miscalculated as 0x%x instead of %x\n",
-		       ref, ref_offset(ref), ref_offset(ref)+ref->__totlen,
-		       ret, ref->__totlen);
+		pr_crit("Totlen for ref at %p (0x%08x-0x%08x) miscalculated as 0x%x instead of %x\n",
+			ref, ref_offset(ref), ref_offset(ref) + ref->__totlen,
+			ret, ref->__totlen);
 		if (ref_next(ref)) {
-			printk(KERN_CRIT "next %p (0x%08x-0x%08x)\n", ref_next(ref), ref_offset(ref_next(ref)),
-			       ref_offset(ref_next(ref))+ref->__totlen);
+			pr_crit("next %p (0x%08x-0x%08x)\n",
+				ref_next(ref), ref_offset(ref_next(ref)),
+				ref_offset(ref_next(ref)) + ref->__totlen);
 		} else 
-			printk(KERN_CRIT "No next ref. jeb->last_node is %p\n", jeb->last_node);
+			pr_crit("No next ref. jeb->last_node is %p\n",
+				jeb->last_node);
 
-		printk(KERN_CRIT "jeb->wasted_size %x, dirty_size %x, used_size %x, free_size %x\n", jeb->wasted_size, jeb->dirty_size, jeb->used_size, jeb->free_size);
+		pr_crit("jeb->wasted_size %x, dirty_size %x, used_size %x, free_size %x\n",
+			jeb->wasted_size, jeb->dirty_size, jeb->used_size,
+			jeb->free_size);
 
 #if defined(JFFS2_DBG_DUMPS) || defined(JFFS2_DBG_PARANOIA_CHECKS)
 		__jffs2_dbg_dump_node_refs_nolock(c, jeb);
diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index d76a268..563a5f6 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -262,9 +262,11 @@ static int jffs2_find_nextblock(struct jffs2_sb_info *c)
 		if (!c->nr_erasing_blocks) {
 			/* Ouch. We're in GC, or we wouldn't have got here.
 			   And there's no space left. At all. */
-			printk(KERN_CRIT "Argh. No free space left for GC. nr_erasing_blocks is %d. nr_free_blocks is %d. (erasableempty: %s, erasingempty: %s, erasependingempty: %s)\n",
-				   c->nr_erasing_blocks, c->nr_free_blocks, list_empty(&c->erasable_list)?"yes":"no",
-				   list_empty(&c->erasing_list)?"yes":"no", list_empty(&c->erase_pending_list)?"yes":"no");
+			pr_crit("Argh. No free space left for GC. nr_erasing_blocks is %d. nr_free_blocks is %d. (erasableempty: %s, erasingempty: %s, erasependingempty: %s)\n",
+				c->nr_erasing_blocks, c->nr_free_blocks,
+				list_empty(&c->erasable_list) ? "yes" : "no",
+				list_empty(&c->erasing_list) ? "yes" : "no",
+				list_empty(&c->erase_pending_list) ? "yes" : "no");
 			return -ENOSPC;
 		}
 
@@ -403,7 +405,8 @@ static int jffs2_do_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 		jeb = c->nextblock;
 
 		if (jeb->free_size != c->sector_size - c->cleanmarker_size) {
-			printk(KERN_WARNING "Eep. Block 0x%08x taken from free_list had free_size of 0x%08x!!\n", jeb->offset, jeb->free_size);
+			pr_warn("Eep. Block 0x%08x taken from free_list had free_size of 0x%08x!!\n",
+				jeb->offset, jeb->free_size);
 			goto restart;
 		}
 	}
@@ -459,12 +462,14 @@ struct jffs2_raw_node_ref *jffs2_add_physical_node_ref(struct jffs2_sb_info *c,
 	   even after refiling c->nextblock */
 	if ((c->nextblock || ((ofs & 3) != REF_OBSOLETE))
 	    && (jeb != c->nextblock || (ofs & ~3) != jeb->offset + (c->sector_size - jeb->free_size))) {
-		printk(KERN_WARNING "argh. node added in wrong place at 0x%08x(%d)\n", ofs & ~3, ofs & 3);
+		pr_warn("argh. node added in wrong place at 0x%08x(%d)\n",
+			ofs & ~3, ofs & 3);
 		if (c->nextblock)
-			printk(KERN_WARNING "nextblock 0x%08x", c->nextblock->offset);
+			pr_warn("nextblock 0x%08x", c->nextblock->offset);
 		else
-			printk(KERN_WARNING "No nextblock");
-		printk(", expected at %08x\n", jeb->offset + (c->sector_size - jeb->free_size));
+			pr_warn("No nextblock");
+		pr_cont(", expected at %08x\n",
+			jeb->offset + (c->sector_size - jeb->free_size));
 		return ERR_PTR(-EINVAL);
 	}
 #endif
@@ -529,7 +534,7 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 	uint32_t freed_len;
 
 	if(unlikely(!ref)) {
-		printk(KERN_NOTICE "EEEEEK. jffs2_mark_node_obsolete called with NULL node\n");
+		pr_notice("EEEEEK. jffs2_mark_node_obsolete called with NULL node\n");
 		return;
 	}
 	if (ref_obsolete(ref)) {
@@ -539,7 +544,8 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 	}
 	blocknr = ref->flash_offset / c->sector_size;
 	if (blocknr >= c->nr_blocks) {
-		printk(KERN_NOTICE "raw node at 0x%08x is off the end of device!\n", ref->flash_offset);
+		pr_notice("raw node at 0x%08x is off the end of device!\n",
+			  ref->flash_offset);
 		BUG();
 	}
 	jeb = &c->blocks[blocknr];
@@ -561,8 +567,9 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 
 	if (ref_flags(ref) == REF_UNCHECKED) {
 		D1(if (unlikely(jeb->unchecked_size < freed_len)) {
-			printk(KERN_NOTICE "raw unchecked node of size 0x%08x freed from erase block %d at 0x%08x, but unchecked_size was already 0x%08x\n",
-			       freed_len, blocknr, ref->flash_offset, jeb->used_size);
+				pr_notice("raw unchecked node of size 0x%08x freed from erase block %d at 0x%08x, but unchecked_size was already 0x%08x\n",
+					  freed_len, blocknr,
+					  ref->flash_offset, jeb->used_size);
 			BUG();
 		})
 			jffs2_dbg(1, "Obsoleting previously unchecked node at 0x%08x of len %x\n",
@@ -571,8 +578,9 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 		c->unchecked_size -= freed_len;
 	} else {
 		D1(if (unlikely(jeb->used_size < freed_len)) {
-			printk(KERN_NOTICE "raw node of size 0x%08x freed from erase block %d at 0x%08x, but used_size was already 0x%08x\n",
-			       freed_len, blocknr, ref->flash_offset, jeb->used_size);
+				pr_notice("raw node of size 0x%08x freed from erase block %d at 0x%08x, but used_size was already 0x%08x\n",
+					  freed_len, blocknr,
+					  ref->flash_offset, jeb->used_size);
 			BUG();
 		})
 			jffs2_dbg(1, "Obsoleting node at 0x%08x of len %#x: ",
@@ -697,15 +705,18 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 		  ref_offset(ref));
 	ret = jffs2_flash_read(c, ref_offset(ref), sizeof(n), &retlen, (char *)&n);
 	if (ret) {
-		printk(KERN_WARNING "Read error reading from obsoleted node at 0x%08x: %d\n", ref_offset(ref), ret);
+		pr_warn("Read error reading from obsoleted node at 0x%08x: %d\n",
+			ref_offset(ref), ret);
 		goto out_erase_sem;
 	}
 	if (retlen != sizeof(n)) {
-		printk(KERN_WARNING "Short read from obsoleted node at 0x%08x: %zd\n", ref_offset(ref), retlen);
+		pr_warn("Short read from obsoleted node at 0x%08x: %zd\n",
+			ref_offset(ref), retlen);
 		goto out_erase_sem;
 	}
 	if (PAD(je32_to_cpu(n.totlen)) != PAD(freed_len)) {
-		printk(KERN_WARNING "Node totlen on flash (0x%08x) != totlen from node ref (0x%08x)\n", je32_to_cpu(n.totlen), freed_len);
+		pr_warn("Node totlen on flash (0x%08x) != totlen from node ref (0x%08x)\n",
+			je32_to_cpu(n.totlen), freed_len);
 		goto out_erase_sem;
 	}
 	if (!(je16_to_cpu(n.nodetype) & JFFS2_NODE_ACCURATE)) {
@@ -717,11 +728,13 @@ void jffs2_mark_node_obsolete(struct jffs2_sb_info *c, struct jffs2_raw_node_ref
 	n.nodetype = cpu_to_je16(je16_to_cpu(n.nodetype) & ~JFFS2_NODE_ACCURATE);
 	ret = jffs2_flash_write(c, ref_offset(ref), sizeof(n), &retlen, (char *)&n);
 	if (ret) {
-		printk(KERN_WARNING "Write error in obliterating obsoleted node at 0x%08x: %d\n", ref_offset(ref), ret);
+		pr_warn("Write error in obliterating obsoleted node at 0x%08x: %d\n",
+			ref_offset(ref), ret);
 		goto out_erase_sem;
 	}
 	if (retlen != sizeof(n)) {
-		printk(KERN_WARNING "Short write in obliterating obsoleted node at 0x%08x: %zd\n", ref_offset(ref), retlen);
+		pr_warn("Short write in obliterating obsoleted node at 0x%08x: %zd\n",
+			ref_offset(ref), retlen);
 		goto out_erase_sem;
 	}
 
diff --git a/fs/jffs2/read.c b/fs/jffs2/read.c
index 835dc5d..925ec65 100644
--- a/fs/jffs2/read.c
+++ b/fs/jffs2/read.c
@@ -36,13 +36,14 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	ret = jffs2_flash_read(c, ref_offset(fd->raw), sizeof(*ri), &readlen, (char *)ri);
 	if (ret) {
 		jffs2_free_raw_inode(ri);
-		printk(KERN_WARNING "Error reading node from 0x%08x: %d\n", ref_offset(fd->raw), ret);
+		pr_warn("Error reading node from 0x%08x: %d\n",
+			ref_offset(fd->raw), ret);
 		return ret;
 	}
 	if (readlen != sizeof(*ri)) {
 		jffs2_free_raw_inode(ri);
-		printk(KERN_WARNING "Short read from 0x%08x: wanted 0x%zx bytes, got 0x%zx\n",
-		       ref_offset(fd->raw), sizeof(*ri), readlen);
+		pr_warn("Short read from 0x%08x: wanted 0x%zx bytes, got 0x%zx\n",
+			ref_offset(fd->raw), sizeof(*ri), readlen);
 		return -EIO;
 	}
 	crc = crc32(0, ri, sizeof(*ri)-8);
@@ -52,8 +53,8 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		  crc, je32_to_cpu(ri->dsize), je32_to_cpu(ri->csize),
 		  je32_to_cpu(ri->offset), buf);
 	if (crc != je32_to_cpu(ri->node_crc)) {
-		printk(KERN_WARNING "Node CRC %08x != calculated CRC %08x for node at %08x\n",
-		       je32_to_cpu(ri->node_crc), crc, ref_offset(fd->raw));
+		pr_warn("Node CRC %08x != calculated CRC %08x for node at %08x\n",
+			je32_to_cpu(ri->node_crc), crc, ref_offset(fd->raw));
 		ret = -EIO;
 		goto out_ri;
 	}
@@ -66,8 +67,8 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 	}
 
 	D1(if(ofs + len > je32_to_cpu(ri->dsize)) {
-		printk(KERN_WARNING "jffs2_read_dnode() asked for %d bytes at %d from %d-byte node\n",
-		       len, ofs, je32_to_cpu(ri->dsize));
+			pr_warn("jffs2_read_dnode() asked for %d bytes at %d from %d-byte node\n",
+				len, ofs, je32_to_cpu(ri->dsize));
 		ret = -EINVAL;
 		goto out_ri;
 	});
@@ -119,8 +120,8 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 
 	crc = crc32(0, readbuf, je32_to_cpu(ri->csize));
 	if (crc != je32_to_cpu(ri->data_crc)) {
-		printk(KERN_WARNING "Data CRC %08x != calculated CRC %08x for node at %08x\n",
-		       je32_to_cpu(ri->data_crc), crc, ref_offset(fd->raw));
+		pr_warn("Data CRC %08x != calculated CRC %08x for node at %08x\n",
+			je32_to_cpu(ri->data_crc), crc, ref_offset(fd->raw));
 		ret = -EIO;
 		goto out_decomprbuf;
 	}
@@ -131,7 +132,7 @@ int jffs2_read_dnode(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 			  je32_to_cpu(ri->dsize), decomprbuf);
 		ret = jffs2_decompress(c, f, ri->compr | (ri->usercompr << 8), readbuf, decomprbuf, je32_to_cpu(ri->csize), je32_to_cpu(ri->dsize));
 		if (ret) {
-			printk(KERN_WARNING "Error: jffs2_decompress returned %d\n", ret);
+			pr_warn("Error: jffs2_decompress returned %d\n", ret);
 			goto out_decomprbuf;
 		}
 	}
diff --git a/fs/jffs2/scan.c b/fs/jffs2/scan.c
index b6c3d88..078cede 100644
--- a/fs/jffs2/scan.c
+++ b/fs/jffs2/scan.c
@@ -22,15 +22,15 @@
 
 #define DEFAULT_EMPTY_SCAN_SIZE 256
 
-#define noisy_printk(noise, args...) do { \
-	if (*(noise)) { \
-		printk(KERN_NOTICE args); \
-		 (*(noise))--; \
-		 if (!(*(noise))) { \
-			 printk(KERN_NOTICE "Further such events for this erase block will not be printed\n"); \
-		 } \
-	} \
-} while(0)
+#define noisy_printk(noise, fmt, ...)					\
+do {									\
+	if (*(noise)) {							\
+		pr_notice(fmt, ##__VA_ARGS__);				\
+		(*(noise))--;						\
+		if (!(*(noise)))					\
+			pr_notice("Further such events for this erase block will not be printed\n"); \
+	}								\
+} while (0)
 
 static uint32_t pseudo_random;
 
@@ -233,7 +233,7 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 			bad_blocks++;
 			break;
 		default:
-			printk(KERN_WARNING "jffs2_scan_medium(): unknown block state\n");
+			pr_warn("%s(): unknown block state\n", __func__);
 			BUG();
 		}
 	}
@@ -261,8 +261,9 @@ int jffs2_scan_medium(struct jffs2_sb_info *c)
 #endif
 	if (c->nr_erasing_blocks) {
 		if ( !c->used_size && ((c->nr_free_blocks+empty_blocks+bad_blocks)!= c->nr_blocks || bad_blocks == c->nr_blocks) ) {
-			printk(KERN_NOTICE "Cowardly refusing to erase blocks on filesystem with no valid JFFS2 nodes\n");
-			printk(KERN_NOTICE "empty_blocks %d, bad_blocks %d, c->nr_blocks %d\n",empty_blocks,bad_blocks,c->nr_blocks);
+			pr_notice("Cowardly refusing to erase blocks on filesystem with no valid JFFS2 nodes\n");
+			pr_notice("empty_blocks %d, bad_blocks %d, c->nr_blocks %d\n",
+				  empty_blocks, bad_blocks, c->nr_blocks);
 			ret = -EIO;
 			goto out;
 		}
@@ -611,12 +612,13 @@ scan_more:
 		cond_resched();
 
 		if (ofs & 3) {
-			printk(KERN_WARNING "Eep. ofs 0x%08x not word-aligned!\n", ofs);
+			pr_warn("Eep. ofs 0x%08x not word-aligned!\n", ofs);
 			ofs = PAD(ofs);
 			continue;
 		}
 		if (ofs == prevofs) {
-			printk(KERN_WARNING "ofs 0x%08x has already been seen. Skipping\n", ofs);
+			pr_warn("ofs 0x%08x has already been seen. Skipping\n",
+				ofs);
 			if ((err = jffs2_scan_dirty_space(c, jeb, 4)))
 				return err;
 			ofs += 4;
@@ -660,8 +662,8 @@ scan_more:
 			inbuf_ofs = ofs - buf_ofs;
 			while (inbuf_ofs < scan_end) {
 				if (unlikely(*(uint32_t *)(&buf[inbuf_ofs]) != 0xffffffff)) {
-					printk(KERN_WARNING "Empty flash at 0x%08x ends at 0x%08x\n",
-					       empty_start, ofs);
+					pr_warn("Empty flash at 0x%08x ends at 0x%08x\n",
+						empty_start, ofs);
 					if ((err = jffs2_scan_dirty_space(c, jeb, ofs-empty_start)))
 						return err;
 					goto scan_more;
@@ -708,7 +710,8 @@ scan_more:
 		}
 
 		if (ofs == jeb->offset && je16_to_cpu(node->magic) == KSAMTIB_CIGAM_2SFFJ) {
-			printk(KERN_WARNING "Magic bitmask is backwards at offset 0x%08x. Wrong endian filesystem?\n", ofs);
+			pr_warn("Magic bitmask is backwards at offset 0x%08x. Wrong endian filesystem?\n",
+				ofs);
 			if ((err = jffs2_scan_dirty_space(c, jeb, 4)))
 				return err;
 			ofs += 4;
@@ -722,8 +725,8 @@ scan_more:
 			continue;
 		}
 		if (je16_to_cpu(node->magic) == JFFS2_OLD_MAGIC_BITMASK) {
-			printk(KERN_WARNING "Old JFFS2 bitmask found at 0x%08x\n", ofs);
-			printk(KERN_WARNING "You cannot use older JFFS2 filesystems with newer kernels\n");
+			pr_warn("Old JFFS2 bitmask found at 0x%08x\n", ofs);
+			pr_warn("You cannot use older JFFS2 filesystems with newer kernels\n");
 			if ((err = jffs2_scan_dirty_space(c, jeb, 4)))
 				return err;
 			ofs += 4;
@@ -731,7 +734,8 @@ scan_more:
 		}
 		if (je16_to_cpu(node->magic) != JFFS2_MAGIC_BITMASK) {
 			/* OK. We're out of possibilities. Whinge and move on */
-			noisy_printk(&noise, "jffs2_scan_eraseblock(): Magic bitmask 0x%04x not found at 0x%08x: 0x%04x instead\n",
+			noisy_printk(&noise, "%s(): Magic bitmask 0x%04x not found at 0x%08x: 0x%04x instead\n",
+				     __func__,
 				     JFFS2_MAGIC_BITMASK, ofs,
 				     je16_to_cpu(node->magic));
 			if ((err = jffs2_scan_dirty_space(c, jeb, 4)))
@@ -746,7 +750,8 @@ scan_more:
 		hdr_crc = crc32(0, &crcnode, sizeof(crcnode)-4);
 
 		if (hdr_crc != je32_to_cpu(node->hdr_crc)) {
-			noisy_printk(&noise, "jffs2_scan_eraseblock(): Node at 0x%08x {0x%04x, 0x%04x, 0x%08x) has invalid CRC 0x%08x (calculated 0x%08x)\n",
+			noisy_printk(&noise, "%s(): Node at 0x%08x {0x%04x, 0x%04x, 0x%08x) has invalid CRC 0x%08x (calculated 0x%08x)\n",
+				     __func__,
 				     ofs, je16_to_cpu(node->magic),
 				     je16_to_cpu(node->nodetype),
 				     je32_to_cpu(node->totlen),
@@ -760,9 +765,9 @@ scan_more:
 
 		if (ofs + je32_to_cpu(node->totlen) > jeb->offset + c->sector_size) {
 			/* Eep. Node goes over the end of the erase block. */
-			printk(KERN_WARNING "Node at 0x%08x with length 0x%08x would run over the end of the erase block\n",
-			       ofs, je32_to_cpu(node->totlen));
-			printk(KERN_WARNING "Perhaps the file system was created with the wrong erase size?\n");
+			pr_warn("Node at 0x%08x with length 0x%08x would run over the end of the erase block\n",
+				ofs, je32_to_cpu(node->totlen));
+			pr_warn("Perhaps the file system was created with the wrong erase size?\n");
 			if ((err = jffs2_scan_dirty_space(c, jeb, 4)))
 				return err;
 			ofs += 4;
@@ -854,13 +859,15 @@ scan_more:
 		case JFFS2_NODETYPE_CLEANMARKER:
 			jffs2_dbg(1, "CLEANMARKER node found at 0x%08x\n", ofs);
 			if (je32_to_cpu(node->totlen) != c->cleanmarker_size) {
-				printk(KERN_NOTICE "CLEANMARKER node found at 0x%08x has totlen 0x%x != normal 0x%x\n",
-				       ofs, je32_to_cpu(node->totlen), c->cleanmarker_size);
+				pr_notice("CLEANMARKER node found at 0x%08x has totlen 0x%x != normal 0x%x\n",
+					  ofs, je32_to_cpu(node->totlen),
+					  c->cleanmarker_size);
 				if ((err = jffs2_scan_dirty_space(c, jeb, PAD(sizeof(struct jffs2_unknown_node)))))
 					return err;
 				ofs += PAD(sizeof(struct jffs2_unknown_node));
 			} else if (jeb->first_node) {
-				printk(KERN_NOTICE "CLEANMARKER node found at 0x%08x, not first node in block (0x%08x)\n", ofs, jeb->offset);
+				pr_notice("CLEANMARKER node found at 0x%08x, not first node in block (0x%08x)\n",
+					  ofs, jeb->offset);
 				if ((err = jffs2_scan_dirty_space(c, jeb, PAD(sizeof(struct jffs2_unknown_node)))))
 					return err;
 				ofs += PAD(sizeof(struct jffs2_unknown_node));
@@ -882,7 +889,8 @@ scan_more:
 		default:
 			switch (je16_to_cpu(node->nodetype) & JFFS2_COMPAT_MASK) {
 			case JFFS2_FEATURE_ROCOMPAT:
-				printk(KERN_NOTICE "Read-only compatible feature node (0x%04x) found at offset 0x%08x\n", je16_to_cpu(node->nodetype), ofs);
+				pr_notice("Read-only compatible feature node (0x%04x) found at offset 0x%08x\n",
+					  je16_to_cpu(node->nodetype), ofs);
 				c->flags |= JFFS2_SB_FLAG_RO;
 				if (!(jffs2_is_readonly(c)))
 					return -EROFS;
@@ -892,7 +900,8 @@ scan_more:
 				break;
 
 			case JFFS2_FEATURE_INCOMPAT:
-				printk(KERN_NOTICE "Incompatible feature node (0x%04x) found at offset 0x%08x\n", je16_to_cpu(node->nodetype), ofs);
+				pr_notice("Incompatible feature node (0x%04x) found at offset 0x%08x\n",
+					  je16_to_cpu(node->nodetype), ofs);
 				return -EINVAL;
 
 			case JFFS2_FEATURE_RWCOMPAT_DELETE:
@@ -954,7 +963,7 @@ struct jffs2_inode_cache *jffs2_scan_make_ino_cache(struct jffs2_sb_info *c, uin
 
 	ic = jffs2_alloc_inode_cache();
 	if (!ic) {
-		printk(KERN_NOTICE "jffs2_scan_make_inode_cache(): allocation of inode cache failed\n");
+		pr_notice("%s(): allocation of inode cache failed\n", __func__);
 		return NULL;
 	}
 	memset(ic, 0, sizeof(*ic));
@@ -987,9 +996,8 @@ static int jffs2_scan_inode_node(struct jffs2_sb_info *c, struct jffs2_erasebloc
 	/* Check the node CRC in any case. */
 	crc = crc32(0, ri, sizeof(*ri)-8);
 	if (crc != je32_to_cpu(ri->node_crc)) {
-		printk(KERN_NOTICE "jffs2_scan_inode_node(): CRC failed on "
-		       "node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-		       ofs, je32_to_cpu(ri->node_crc), crc);
+		pr_notice("%s(): CRC failed on node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+			  __func__, ofs, je32_to_cpu(ri->node_crc), crc);
 		/*
 		 * We believe totlen because the CRC on the node
 		 * _header_ was OK, just the node itself failed.
@@ -1038,8 +1046,8 @@ static int jffs2_scan_dirent_node(struct jffs2_sb_info *c, struct jffs2_eraseblo
 	crc = crc32(0, rd, sizeof(*rd)-8);
 
 	if (crc != je32_to_cpu(rd->node_crc)) {
-		printk(KERN_NOTICE "jffs2_scan_dirent_node(): Node CRC failed on node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-		       ofs, je32_to_cpu(rd->node_crc), crc);
+		pr_notice("%s(): Node CRC failed on node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+			  __func__, ofs, je32_to_cpu(rd->node_crc), crc);
 		/* We believe totlen because the CRC on the node _header_ was OK, just the node itself failed. */
 		if ((err = jffs2_scan_dirty_space(c, jeb, PAD(je32_to_cpu(rd->totlen)))))
 			return err;
@@ -1051,7 +1059,7 @@ static int jffs2_scan_dirent_node(struct jffs2_sb_info *c, struct jffs2_eraseblo
 	/* Should never happen. Did. (OLPC trac #4184)*/
 	checkedlen = strnlen(rd->name, rd->nsize);
 	if (checkedlen < rd->nsize) {
-		printk(KERN_ERR "Dirent at %08x has zeroes in name. Truncating to %d chars\n",
+		pr_err("Dirent at %08x has zeroes in name. Truncating to %d chars\n",
 		       ofs, checkedlen);
 	}
 	fd = jffs2_alloc_full_dirent(checkedlen+1);
@@ -1063,8 +1071,8 @@ static int jffs2_scan_dirent_node(struct jffs2_sb_info *c, struct jffs2_eraseblo
 
 	crc = crc32(0, fd->name, rd->nsize);
 	if (crc != je32_to_cpu(rd->name_crc)) {
-		printk(KERN_NOTICE "jffs2_scan_dirent_node(): Name CRC failed on node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
-		       ofs, je32_to_cpu(rd->name_crc), crc);
+		pr_notice("%s(): Name CRC failed on node at 0x%08x: Read 0x%08x, calculated 0x%08x\n",
+			  __func__, ofs, je32_to_cpu(rd->name_crc), crc);
 		jffs2_dbg(1, "Name for which CRC failed is (now) '%s', ino #%d\n",
 			  fd->name, je32_to_cpu(rd->ino));
 		jffs2_free_full_dirent(fd);
diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index e537fb0..0789e4e 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -442,13 +442,16 @@ static int jffs2_sum_process_sum_data(struct jffs2_sb_info *c, struct jffs2_eras
 				/* This should never happen, but https://dev.laptop.org/ticket/4184 */
 				checkedlen = strnlen(spd->name, spd->nsize);
 				if (!checkedlen) {
-					printk(KERN_ERR "Dirent at %08x has zero at start of name. Aborting mount.\n",
-					       jeb->offset + je32_to_cpu(spd->offset));
+					pr_err("Dirent at %08x has zero at start of name. Aborting mount.\n",
+					       jeb->offset +
+					       je32_to_cpu(spd->offset));
 					return -EIO;
 				}
 				if (checkedlen < spd->nsize) {
-					printk(KERN_ERR "Dirent at %08x has zeroes in name. Truncating to %d chars\n",
-					       jeb->offset + je32_to_cpu(spd->offset), checkedlen);
+					pr_err("Dirent at %08x has zeroes in name. Truncating to %d chars\n",
+					       jeb->offset +
+					       je32_to_cpu(spd->offset),
+					       checkedlen);
 				}
 
 
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 3600e3e..9e3ba7f 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -214,8 +214,8 @@ static int jffs2_parse_options(struct jffs2_sb_info *c, char *data)
 						JFFS2_COMPR_MODE_FORCEZLIB;
 #endif
 			else {
-				printk(KERN_ERR "JFFS2 Error: unknown compressor \"%s\"",
-						name);
+				pr_err("JFFS2 Error: unknown compressor \"%s\"",
+				       name);
 				kfree(name);
 				return -EINVAL;
 			}
@@ -223,8 +223,8 @@ static int jffs2_parse_options(struct jffs2_sb_info *c, char *data)
 			c->mount_opts.override_compr = true;
 			break;
 		default:
-			printk(KERN_ERR "JFFS2 Error: unrecognized mount option '%s' or missing value\n",
-					p);
+			pr_err("JFFS2 Error: unrecognized mount option '%s' or missing value\n",
+			       p);
 			return -EINVAL;
 		}
 	}
@@ -371,7 +371,7 @@ static int __init init_jffs2_fs(void)
 	BUILD_BUG_ON(sizeof(struct jffs2_raw_inode) != 68);
 	BUILD_BUG_ON(sizeof(struct jffs2_raw_summary) != 32);
 
-	printk(KERN_INFO "JFFS2 version 2.2."
+	pr_info("JFFS2 version 2.2."
 #ifdef CONFIG_JFFS2_FS_WRITEBUFFER
 	       " (NAND)"
 #endif
@@ -386,22 +386,22 @@ static int __init init_jffs2_fs(void)
 						SLAB_MEM_SPREAD),
 					     jffs2_i_init_once);
 	if (!jffs2_inode_cachep) {
-		printk(KERN_ERR "JFFS2 error: Failed to initialise inode cache\n");
+		pr_err("JFFS2 error: Failed to initialise inode cache\n");
 		return -ENOMEM;
 	}
 	ret = jffs2_compressors_init();
 	if (ret) {
-		printk(KERN_ERR "JFFS2 error: Failed to initialise compressors\n");
+		pr_err("JFFS2 error: Failed to initialise compressors\n");
 		goto out;
 	}
 	ret = jffs2_create_slab_caches();
 	if (ret) {
-		printk(KERN_ERR "JFFS2 error: Failed to initialise slab caches\n");
+		pr_err("JFFS2 error: Failed to initialise slab caches\n");
 		goto out_compressors;
 	}
 	ret = register_filesystem(&jffs2_fs_type);
 	if (ret) {
-		printk(KERN_ERR "JFFS2 error: Failed to register filesystem\n");
+		pr_err("JFFS2 error: Failed to register filesystem\n");
 		goto out_slab;
 	}
 	return 0;
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index 5188f4d..56eeed5 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -47,7 +47,7 @@ static void *jffs2_follow_link(struct dentry *dentry, struct nameidata *nd)
 	 */
 
 	if (!p) {
-		printk(KERN_ERR "jffs2_follow_link(): can't find symlink target\n");
+		pr_err("%s(): can't find symlink target\n", __func__);
 		p = ERR_PTR(-EIO);
 	}
 	jffs2_dbg(1, "%s(): target path is '%s'\n",
diff --git a/fs/jffs2/wbuf.c b/fs/jffs2/wbuf.c
index d626eb2..89a6ec0 100644
--- a/fs/jffs2/wbuf.c
+++ b/fs/jffs2/wbuf.c
@@ -233,10 +233,12 @@ static int jffs2_verify_write(struct jffs2_sb_info *c, unsigned char *buf,
 
 	ret = mtd_read(c->mtd, ofs, c->wbuf_pagesize, &retlen, c->wbuf_verify);
 	if (ret && ret != -EUCLEAN && ret != -EBADMSG) {
-		printk(KERN_WARNING "jffs2_verify_write(): Read back of page at %08x failed: %d\n", c->wbuf_ofs, ret);
+		pr_warn("%s(): Read back of page at %08x failed: %d\n",
+			__func__, c->wbuf_ofs, ret);
 		return ret;
 	} else if (retlen != c->wbuf_pagesize) {
-		printk(KERN_WARNING "jffs2_verify_write(): Read back of page at %08x gave short read: %zd not %d.\n", ofs, retlen, c->wbuf_pagesize);
+		pr_warn("%s(): Read back of page at %08x gave short read: %zd not %d\n",
+			__func__, ofs, retlen, c->wbuf_pagesize);
 		return -EIO;
 	}
 	if (!memcmp(buf, c->wbuf_verify, c->wbuf_pagesize))
@@ -249,12 +251,12 @@ static int jffs2_verify_write(struct jffs2_sb_info *c, unsigned char *buf,
 	else
 		eccstr = "OK or unused";
 
-	printk(KERN_WARNING "Write verify error (ECC %s) at %08x. Wrote:\n",
-	       eccstr, c->wbuf_ofs);
+	pr_warn("Write verify error (ECC %s) at %08x. Wrote:\n",
+		eccstr, c->wbuf_ofs);
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1,
 		       c->wbuf, c->wbuf_pagesize, 0);
 
-	printk(KERN_WARNING "Read back:\n");
+	pr_warn("Read back:\n");
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1,
 		       c->wbuf_verify, c->wbuf_pagesize, 0);
 
@@ -334,7 +336,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 		buf = kmalloc(end - start, GFP_KERNEL);
 		if (!buf) {
-			printk(KERN_CRIT "Malloc failure in wbuf recovery. Data loss ensues.\n");
+			pr_crit("Malloc failure in wbuf recovery. Data loss ensues.\n");
 
 			goto read_failed;
 		}
@@ -349,7 +351,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 			ret = 0;
 
 		if (ret || retlen != c->wbuf_ofs - start) {
-			printk(KERN_CRIT "Old data are already lost in wbuf recovery. Data loss ensues.\n");
+			pr_crit("Old data are already lost in wbuf recovery. Data loss ensues.\n");
 
 			kfree(buf);
 			buf = NULL;
@@ -383,7 +385,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 	/* ... and get an allocation of space from a shiny new block instead */
 	ret = jffs2_reserve_space_gc(c, end-start, &len, JFFS2_SUMMARY_NOSUM_SIZE);
 	if (ret) {
-		printk(KERN_WARNING "Failed to allocate space for wbuf recovery. Data loss ensues.\n");
+		pr_warn("Failed to allocate space for wbuf recovery. Data loss ensues.\n");
 		kfree(buf);
 		return;
 	}
@@ -393,7 +395,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 	ret = jffs2_prealloc_raw_node_refs(c, c->nextblock, nr_refile);
 	if (ret) {
-		printk(KERN_WARNING "Failed to allocate node refs for wbuf recovery. Data loss ensues.\n");
+		pr_warn("Failed to allocate node refs for wbuf recovery. Data loss ensues.\n");
 		kfree(buf);
 		return;
 	}
@@ -415,7 +417,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 #ifdef BREAKMEHEADER
 		static int breakme;
 		if (breakme++ == 20) {
-			printk(KERN_NOTICE "Faking write error at 0x%08x\n", ofs);
+			pr_notice("Faking write error at 0x%08x\n", ofs);
 			breakme = 0;
 			mtd_write(c->mtd, ofs, towrite, &retlen, brokenbuf);
 			ret = -EIO;
@@ -426,7 +428,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 		if (ret || retlen != towrite || jffs2_verify_write(c, rewrite_buf, ofs)) {
 			/* Argh. We tried. Really we did. */
-			printk(KERN_CRIT "Recovery of wbuf failed due to a second write error\n");
+			pr_crit("Recovery of wbuf failed due to a second write error\n");
 			kfree(buf);
 
 			if (retlen)
@@ -434,7 +436,7 @@ static void jffs2_wbuf_recover(struct jffs2_sb_info *c)
 
 			return;
 		}
-		printk(KERN_NOTICE "Recovery of wbuf succeeded to %08x\n", ofs);
+		pr_notice("Recovery of wbuf succeeded to %08x\n", ofs);
 
 		c->wbuf_len = (end - start) - towrite;
 		c->wbuf_ofs = ofs + towrite;
@@ -584,7 +586,7 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c, int pad)
 		return 0;
 
 	if (!mutex_is_locked(&c->alloc_sem)) {
-		printk(KERN_CRIT "jffs2_flush_wbuf() called with alloc_sem not locked!\n");
+		pr_crit("jffs2_flush_wbuf() called with alloc_sem not locked!\n");
 		BUG();
 	}
 
@@ -622,7 +624,7 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c, int pad)
 #ifdef BREAKME
 	static int breakme;
 	if (breakme++ == 20) {
-		printk(KERN_NOTICE "Faking write error at 0x%08x\n", c->wbuf_ofs);
+		pr_notice("Faking write error at 0x%08x\n", c->wbuf_ofs);
 		breakme = 0;
 		mtd_write(c->mtd, c->wbuf_ofs, c->wbuf_pagesize, &retlen,
 			  brokenbuf);
@@ -634,11 +636,11 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c, int pad)
 				&retlen, c->wbuf);
 
 	if (ret) {
-		printk(KERN_WARNING "jffs2_flush_wbuf(): Write failed with %d\n", ret);
+		pr_warn("jffs2_flush_wbuf(): Write failed with %d\n", ret);
 		goto wfail;
 	} else if (retlen != c->wbuf_pagesize) {
-		printk(KERN_WARNING "jffs2_flush_wbuf(): Write was short: %zd instead of %d\n",
-		       retlen, c->wbuf_pagesize);
+		pr_warn("jffs2_flush_wbuf(): Write was short: %zd instead of %d\n",
+			retlen, c->wbuf_pagesize);
 		ret = -EIO;
 		goto wfail;
 	} else if ((ret = jffs2_verify_write(c, c->wbuf, c->wbuf_ofs))) {
@@ -660,10 +662,10 @@ static int __jffs2_flush_wbuf(struct jffs2_sb_info *c, int pad)
 		   padded. If there is less free space in the block than that,
 		   something screwed up */
 		if (wbuf_jeb->free_size < waste) {
-			printk(KERN_CRIT "jffs2_flush_wbuf(): Accounting error. wbuf at 0x%08x has 0x%03x bytes, 0x%03x left.\n",
-			       c->wbuf_ofs, c->wbuf_len, waste);
-			printk(KERN_CRIT "jffs2_flush_wbuf(): But free_size for block at 0x%08x is only 0x%08x\n",
-			       wbuf_jeb->offset, wbuf_jeb->free_size);
+			pr_crit("jffs2_flush_wbuf(): Accounting error. wbuf at 0x%08x has 0x%03x bytes, 0x%03x left.\n",
+				c->wbuf_ofs, c->wbuf_len, waste);
+			pr_crit("jffs2_flush_wbuf(): But free_size for block at 0x%08x is only 0x%08x\n",
+				wbuf_jeb->offset, wbuf_jeb->free_size);
 			BUG();
 		}
 
@@ -831,11 +833,11 @@ int jffs2_flash_writev(struct jffs2_sb_info *c, const struct kvec *invecs,
 
 	if (to != PAD(c->wbuf_ofs + c->wbuf_len)) {
 		/* We're not writing immediately after the writebuffer. Bad. */
-		printk(KERN_CRIT "%s(): Non-contiguous write to %08lx\n",
-		       __func__, (unsigned long)to);
+		pr_crit("%s(): Non-contiguous write to %08lx\n",
+			__func__, (unsigned long)to);
 		if (c->wbuf_len)
-			printk(KERN_CRIT "wbuf was previously %08x-%08x\n",
-			       c->wbuf_ofs, c->wbuf_ofs+c->wbuf_len);
+			pr_crit("wbuf was previously %08x-%08x\n",
+				c->wbuf_ofs, c->wbuf_ofs + c->wbuf_len);
 		BUG();
 	}
 
@@ -963,8 +965,8 @@ int jffs2_flash_read(struct jffs2_sb_info *c, loff_t ofs, size_t len, size_t *re
 
 	if ( (ret == -EBADMSG || ret == -EUCLEAN) && (*retlen == len) ) {
 		if (ret == -EBADMSG)
-			printk(KERN_WARNING "mtd->read(0x%zx bytes from 0x%llx)"
-			       " returned ECC error\n", len, ofs);
+			pr_warn("mtd->read(0x%zx bytes from 0x%llx) returned ECC error\n",
+				len, ofs);
 		/*
 		 * We have the raw data without ECC correction in the buffer,
 		 * maybe we are lucky and all data or parts are correct. We
@@ -1040,9 +1042,8 @@ int jffs2_check_oob_empty(struct jffs2_sb_info *c,
 
 	ret = mtd_read_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
-		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
-				" bytes, read %zd bytes, error %d\n",
-				jeb->offset, ops.ooblen, ops.oobretlen, ret);
+		pr_err("cannot read OOB for EB at %08x, requested %zd bytes, read %zd bytes, error %d\n",
+		       jeb->offset, ops.ooblen, ops.oobretlen, ret);
 		if (!ret)
 			ret = -EIO;
 		return ret;
@@ -1083,9 +1084,8 @@ int jffs2_check_nand_cleanmarker(struct jffs2_sb_info *c,
 
 	ret = mtd_read_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
-		printk(KERN_ERR "cannot read OOB for EB at %08x, requested %zd"
-				" bytes, read %zd bytes, error %d\n",
-				jeb->offset, ops.ooblen, ops.oobretlen, ret);
+		pr_err("cannot read OOB for EB at %08x, requested %zd bytes, read %zd bytes, error %d\n",
+		       jeb->offset, ops.ooblen, ops.oobretlen, ret);
 		if (!ret)
 			ret = -EIO;
 		return ret;
@@ -1109,9 +1109,8 @@ int jffs2_write_nand_cleanmarker(struct jffs2_sb_info *c,
 
 	ret = mtd_write_oob(c->mtd, jeb->offset, &ops);
 	if (ret || ops.oobretlen != ops.ooblen) {
-		printk(KERN_ERR "cannot write OOB for EB at %08x, requested %zd"
-				" bytes, read %zd bytes, error %d\n",
-				jeb->offset, ops.ooblen, ops.oobretlen, ret);
+		pr_err("cannot write OOB for EB at %08x, requested %zd bytes, read %zd bytes, error %d\n",
+		       jeb->offset, ops.ooblen, ops.oobretlen, ret);
 		if (!ret)
 			ret = -EIO;
 		return ret;
@@ -1136,7 +1135,7 @@ int jffs2_write_nand_badblock(struct jffs2_sb_info *c, struct jffs2_eraseblock *
 	if( ++jeb->bad_count < MAX_ERASE_FAILURES)
 		return 0;
 
-	printk(KERN_WARNING "JFFS2: marking eraseblock at %08x\n as bad", bad_offset);
+	pr_warn("JFFS2: marking eraseblock at %08x as bad\n", bad_offset);
 	ret = mtd_block_markbad(c->mtd, bad_offset);
 
 	if (ret) {
@@ -1158,7 +1157,7 @@ int jffs2_nand_flash_setup(struct jffs2_sb_info *c)
 	c->cleanmarker_size = 0;
 
 	if (!oinfo || oinfo->oobavail == 0) {
-		printk(KERN_ERR "inconsistent device description\n");
+		pr_err("inconsistent device description\n");
 		return -EINVAL;
 	}
 
@@ -1229,7 +1228,7 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 
 	if ((c->flash_size % c->sector_size) != 0) {
 		c->flash_size = (c->flash_size / c->sector_size) * c->sector_size;
-		printk(KERN_WARNING "JFFS2 flash size adjusted to %dKiB\n", c->flash_size);
+		pr_warn("JFFS2 flash size adjusted to %dKiB\n", c->flash_size);
 	};
 
 	c->wbuf_ofs = 0xFFFFFFFF;
@@ -1246,7 +1245,8 @@ int jffs2_dataflash_setup(struct jffs2_sb_info *c) {
 	}
 #endif
 
-	printk(KERN_INFO "JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n", c->wbuf_pagesize, c->sector_size);
+	pr_info("JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n",
+		c->wbuf_pagesize, c->sector_size);
 
 	return 0;
 }
@@ -1304,7 +1304,8 @@ int jffs2_ubivol_setup(struct jffs2_sb_info *c) {
 	if (!c->wbuf)
 		return -ENOMEM;
 
-	printk(KERN_INFO "JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n", c->wbuf_pagesize, c->sector_size);
+	pr_info("JFFS2 write-buffering enabled buffer (%d) erasesize (%d)\n",
+		c->wbuf_pagesize, c->sector_size);
 
 	return 0;
 }
diff --git a/fs/jffs2/write.c b/fs/jffs2/write.c
index e137839..d98b220 100644
--- a/fs/jffs2/write.c
+++ b/fs/jffs2/write.c
@@ -68,7 +68,7 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 	unsigned long cnt = 2;
 
 	D1(if(je32_to_cpu(ri->hdr_crc) != crc32(0, ri, sizeof(struct jffs2_unknown_node)-4)) {
-		printk(KERN_CRIT "Eep. CRC not correct in jffs2_write_dnode()\n");
+		pr_crit("Eep. CRC not correct in jffs2_write_dnode()\n");
 		BUG();
 	}
 	   );
@@ -78,7 +78,9 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 	vecs[1].iov_len = datalen;
 
 	if (je32_to_cpu(ri->totlen) != sizeof(*ri) + datalen) {
-		printk(KERN_WARNING "jffs2_write_dnode: ri->totlen (0x%08x) != sizeof(*ri) (0x%08zx) + datalen (0x%08x)\n", je32_to_cpu(ri->totlen), sizeof(*ri), datalen);
+		pr_warn("%s(): ri->totlen (0x%08x) != sizeof(*ri) (0x%08zx) + datalen (0x%08x)\n",
+			__func__, je32_to_cpu(ri->totlen),
+			sizeof(*ri), datalen);
 	}
 
 	fn = jffs2_alloc_full_dnode();
@@ -106,8 +108,8 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 				 (alloc_mode==ALLOC_GC)?0:f->inocache->ino);
 
 	if (ret || (retlen != sizeof(*ri) + datalen)) {
-		printk(KERN_NOTICE "Write of %zd bytes at 0x%08x failed. returned %d, retlen %zd\n",
-		       sizeof(*ri)+datalen, flash_ofs, ret, retlen);
+		pr_notice("Write of %zd bytes at 0x%08x failed. returned %d, retlen %zd\n",
+			  sizeof(*ri) + datalen, flash_ofs, ret, retlen);
 
 		/* Mark the space as dirtied */
 		if (retlen) {
@@ -118,7 +120,8 @@ struct jffs2_full_dnode *jffs2_write_dnode(struct jffs2_sb_info *c, struct jffs2
 			   this node */
 			jffs2_add_physical_node_ref(c, flash_ofs | REF_OBSOLETE, PAD(sizeof(*ri)+datalen), NULL);
 		} else {
-			printk(KERN_NOTICE "Not marking the space at 0x%08x as dirty because the flash driver returned retlen zero\n", flash_ofs);
+			pr_notice("Not marking the space at 0x%08x as dirty because the flash driver returned retlen zero\n",
+				  flash_ofs);
 		}
 		if (!retried && alloc_mode != ALLOC_NORETRY) {
 			/* Try to reallocate space and retry */
@@ -214,17 +217,17 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 		  je32_to_cpu(rd->name_crc));
 
 	D1(if(je32_to_cpu(rd->hdr_crc) != crc32(0, rd, sizeof(struct jffs2_unknown_node)-4)) {
-		printk(KERN_CRIT "Eep. CRC not correct in jffs2_write_dirent()\n");
+		pr_crit("Eep. CRC not correct in jffs2_write_dirent()\n");
 		BUG();
 	   });
 
 	if (strnlen(name, namelen) != namelen) {
 		/* This should never happen, but seems to have done on at least one
 		   occasion: https://dev.laptop.org/ticket/4184 */
-		printk(KERN_CRIT "Error in jffs2_write_dirent() -- name contains zero bytes!\n");
-		printk(KERN_CRIT "Directory inode #%u, name at *0x%p \"%s\"->ino #%u, name_crc 0x%08x\n",
-		       je32_to_cpu(rd->pino), name, name, je32_to_cpu(rd->ino),
-		       je32_to_cpu(rd->name_crc));
+		pr_crit("Error in jffs2_write_dirent() -- name contains zero bytes!\n");
+		pr_crit("Directory inode #%u, name at *0x%p \"%s\"->ino #%u, name_crc 0x%08x\n",
+			je32_to_cpu(rd->pino), name, name, je32_to_cpu(rd->ino),
+			je32_to_cpu(rd->name_crc));
 		WARN_ON(1);
 		return ERR_PTR(-EIO);
 	}
@@ -263,13 +266,14 @@ struct jffs2_full_dirent *jffs2_write_dirent(struct jffs2_sb_info *c, struct jff
 	ret = jffs2_flash_writev(c, vecs, 2, flash_ofs, &retlen,
 				 (alloc_mode==ALLOC_GC)?0:je32_to_cpu(rd->pino));
 	if (ret || (retlen != sizeof(*rd) + namelen)) {
-		printk(KERN_NOTICE "Write of %zd bytes at 0x%08x failed. returned %d, retlen %zd\n",
-			       sizeof(*rd)+namelen, flash_ofs, ret, retlen);
+		pr_notice("Write of %zd bytes at 0x%08x failed. returned %d, retlen %zd\n",
+			  sizeof(*rd) + namelen, flash_ofs, ret, retlen);
 		/* Mark the space as dirtied */
 		if (retlen) {
 			jffs2_add_physical_node_ref(c, flash_ofs | REF_OBSOLETE, PAD(sizeof(*rd)+namelen), NULL);
 		} else {
-			printk(KERN_NOTICE "Not marking the space at 0x%08x as dirty because the flash driver returned retlen zero\n", flash_ofs);
+			pr_notice("Not marking the space at 0x%08x as dirty because the flash driver returned retlen zero\n",
+				  flash_ofs);
 		}
 		if (!retried) {
 			/* Try to reallocate space and retry */
@@ -417,7 +421,7 @@ int jffs2_write_inode_range(struct jffs2_sb_info *c, struct jffs2_inode_info *f,
 		mutex_unlock(&f->sem);
 		jffs2_complete_reservation(c);
 		if (!datalen) {
-			printk(KERN_WARNING "Eep. We didn't actually write any data in jffs2_write_inode_range()\n");
+			pr_warn("Eep. We didn't actually write any data in jffs2_write_inode_range()\n");
 			ret = -EIO;
 			break;
 		}
@@ -634,8 +638,9 @@ int jffs2_do_unlink(struct jffs2_sb_info *c, struct jffs2_inode_info *dir_f,
 				dead_f->dents = fd->next;
 
 				if (fd->ino) {
-					printk(KERN_WARNING "Deleting inode #%u with active dentry \"%s\"->ino #%u\n",
-					       dead_f->inocache->ino, fd->name, fd->ino);
+					pr_warn("Deleting inode #%u with active dentry \"%s\"->ino #%u\n",
+						dead_f->inocache->ino,
+						fd->name, fd->ino);
 				} else {
 					jffs2_dbg(1, "Removing deletion dirent for \"%s\" from dir ino #%u\n",
 						  fd->name,
-- 
1.7.8.111.gad25c.dirty

