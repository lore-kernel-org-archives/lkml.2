Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab1JXMvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab1JXMrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:40 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 10/24] GFS2: Use rbtree for resource groups and clean up bitmap buffer ref count scheme
Date: Mon, 24 Oct 2011 13:48:24 +0100
Message-Id: <1319460518-9046-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Here is an update of Bob's original rbtree patch which, in addition, also
resolves the rather strange ref counting that was being done relating to
the bitmap blocks.

Originally we had a dual system for journaling resource groups. The metadata
blocks were journaled and also the rgrp itself was added to a list. The reason
for adding the rgrp to the list in the journal was so that the "repolish
clones" code could be run to update the free space, and potentially send any
discard requests when the log was flushed. This was done by comparing the
"cloned" bitmap with what had been written back on disk during the transaction
commit.

Due to this, there was a requirement to hang on to the rgrps' bitmap buffers
until the journal had been flushed. For that reason, there was a rather
complicated set up in the ->go_lock ->go_unlock functions for rgrps involving
both a mutex and a spinlock (the ->sd_rindex_spin) to maintain a reference
count on the buffers.

However, the journal maintains a reference count on the buffers anyway, since
they are being journaled as metadata buffers. So by moving the code which deals
with the post-journal accounting for bitmap blocks to the metadata journaling
code, we can entirely dispense with the rather strange buffer ref counting
scheme and also the requirement to journal the rgrps.

The net result of all this is that the ->sd_rindex_spin is left to do exactly
one job, and that is to look after the rbtree or rgrps.

This patch is designed to be a stepping stone towards using RCU for the rbtree
of resource groups, however the reduction in the number of uses of the
->sd_rindex_spin is likely to have benefits for multi-threaded workloads,
anyway.

The patch retains ->go_lock and ->go_unlock for rgrps, however these maybe also
be removed in future in favour of calling the functions directly where required
in the code. That will allow locking of resource groups without needing to
actually read them in - something that could be useful in speeding up statfs.

In the mean time though it is valid to dereference ->bi_bh only when the rgrp
is locked. This is basically the same rule as before, modulo the references not
being valid until the following journal flush.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0cc3ff4..6f82aac 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -134,6 +134,8 @@ void gfs2_ail_flush(struct gfs2_glock *gl)
 static void rgrp_go_sync(struct gfs2_glock *gl)
 {
 	struct address_space *metamapping = gfs2_glock2aspace(gl);
+	struct gfs2_rgrpd *rgd = gl->gl_object;
+	unsigned int x;
 	int error;
 
 	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
@@ -145,6 +147,15 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 	error = filemap_fdatawait(metamapping);
         mapping_set_error(metamapping, error);
 	gfs2_ail_empty_gl(gl);
+
+	if (!rgd)
+		return;
+
+	for (x = 0; x < rgd->rd_length; x++) {
+		struct gfs2_bitmap *bi = rgd->rd_bits + x;
+		kfree(bi->bi_clone);
+		bi->bi_clone = NULL;
+	}
 }
 
 /**
@@ -445,33 +456,6 @@ static int inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 }
 
 /**
- * rgrp_go_lock - operation done after an rgrp lock is locked by
- *    a first holder on this node.
- * @gl: the glock
- * @flags:
- *
- * Returns: errno
- */
-
-static int rgrp_go_lock(struct gfs2_holder *gh)
-{
-	return gfs2_rgrp_bh_get(gh->gh_gl->gl_object);
-}
-
-/**
- * rgrp_go_unlock - operation done before an rgrp lock is unlocked by
- *    a last holder on this node.
- * @gl: the glock
- * @flags:
- *
- */
-
-static void rgrp_go_unlock(struct gfs2_holder *gh)
-{
-	gfs2_rgrp_bh_put(gh->gh_gl->gl_object);
-}
-
-/**
  * trans_go_sync - promote/demote the transaction glock
  * @gl: the glock
  * @state: the requested state
@@ -573,8 +557,8 @@ const struct gfs2_glock_operations gfs2_inode_glops = {
 const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_xmote_th = rgrp_go_sync,
 	.go_inval = rgrp_go_inval,
-	.go_lock = rgrp_go_lock,
-	.go_unlock = rgrp_go_unlock,
+	.go_lock = gfs2_rgrp_go_lock,
+	.go_unlock = gfs2_rgrp_go_unlock,
 	.go_dump = gfs2_rgrp_dump,
 	.go_type = LM_TYPE_RGRP,
 	.go_flags = GLOF_ASPACE,
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index be5801a..9e753fc 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -18,6 +18,7 @@
 #include <linux/rcupdate.h>
 #include <linux/rculist_bl.h>
 #include <linux/completion.h>
+#include <linux/rbtree.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -78,8 +79,7 @@ struct gfs2_bitmap {
 };
 
 struct gfs2_rgrpd {
-	struct list_head rd_list;	/* Link with superblock */
-	struct list_head rd_list_mru;
+	struct rb_node rd_node;		/* Link with superblock */
 	struct gfs2_glock *rd_gl;	/* Glock for this rgrp */
 	u64 rd_addr;			/* grp block disk address */
 	u64 rd_data0;			/* first data location */
@@ -91,10 +91,7 @@ struct gfs2_rgrpd {
 	u32 rd_dinodes;
 	u64 rd_igeneration;
 	struct gfs2_bitmap *rd_bits;
-	struct mutex rd_mutex;
-	struct gfs2_log_element rd_le;
 	struct gfs2_sbd *rd_sbd;
-	unsigned int rd_bh_count;
 	u32 rd_last_alloc;
 	u32 rd_flags;
 #define GFS2_RDF_CHECK		0x10000000 /* check for unlinked inodes */
@@ -575,9 +572,7 @@ struct gfs2_sbd {
 	int sd_rindex_uptodate;
 	spinlock_t sd_rindex_spin;
 	struct mutex sd_rindex_mutex;
-	struct list_head sd_rindex_list;
-	struct list_head sd_rindex_mru_list;
-	struct gfs2_rgrpd *sd_rindex_forward;
+	struct rb_root sd_rindex_tree;
 	unsigned int sd_rgrps;
 	unsigned int sd_max_rg_data;
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 05bbb12..de05b4d 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -60,6 +60,29 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	trace_gfs2_pin(bd, 1);
 }
 
+static bool buffer_is_rgrp(const struct gfs2_bufdata *bd)
+{
+	return bd->bd_gl->gl_name.ln_type == LM_TYPE_RGRP;
+}
+
+static void maybe_release_space(struct gfs2_bufdata *bd)
+{
+	struct gfs2_glock *gl = bd->bd_gl;
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct gfs2_rgrpd *rgd = gl->gl_object;
+	unsigned int index = bd->bd_bh->b_blocknr - gl->gl_name.ln_number;
+	struct gfs2_bitmap *bi = rgd->rd_bits + index;
+
+	if (bi->bi_clone == 0)
+		return;
+	if (sdp->sd_args.ar_discard)
+		gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bd->bd_bh, bi);
+	memcpy(bi->bi_clone + bi->bi_offset,
+	       bd->bd_bh->b_data + bi->bi_offset, bi->bi_len);
+	clear_bit(GBF_FULL, &bi->bi_flags);
+	rgd->rd_free_clone = rgd->rd_free;
+}
+
 /**
  * gfs2_unpin - Unpin a buffer
  * @sdp: the filesystem the buffer belongs to
@@ -81,6 +104,9 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	mark_buffer_dirty(bh);
 	clear_buffer_pinned(bh);
 
+	if (buffer_is_rgrp(bd))
+		maybe_release_space(bd);
+
 	spin_lock(&sdp->sd_ail_lock);
 	if (bd->bd_ail) {
 		list_del(&bd->bd_ail_st_list);
@@ -469,42 +495,6 @@ static void revoke_lo_after_scan(struct gfs2_jdesc *jd, int error, int pass)
 	gfs2_revoke_clean(sdp);
 }
 
-static void rg_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
-{
-	struct gfs2_rgrpd *rgd;
-	struct gfs2_trans *tr = current->journal_info;
-
-	tr->tr_touched = 1;
-
-	rgd = container_of(le, struct gfs2_rgrpd, rd_le);
-
-	gfs2_log_lock(sdp);
-	if (!list_empty(&le->le_list)){
-		gfs2_log_unlock(sdp);
-		return;
-	}
-	gfs2_rgrp_bh_hold(rgd);
-	sdp->sd_log_num_rg++;
-	list_add(&le->le_list, &sdp->sd_log_le_rg);
-	gfs2_log_unlock(sdp);
-}
-
-static void rg_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
-{
-	struct list_head *head = &sdp->sd_log_le_rg;
-	struct gfs2_rgrpd *rgd;
-
-	while (!list_empty(head)) {
-		rgd = list_entry(head->next, struct gfs2_rgrpd, rd_le.le_list);
-		list_del_init(&rgd->rd_le.le_list);
-		sdp->sd_log_num_rg--;
-
-		gfs2_rgrp_repolish_clones(rgd);
-		gfs2_rgrp_bh_put(rgd);
-	}
-	gfs2_assert_warn(sdp, !sdp->sd_log_num_rg);
-}
-
 /**
  * databuf_lo_add - Add a databuf to the transaction.
  *
@@ -771,8 +761,6 @@ const struct gfs2_log_operations gfs2_revoke_lops = {
 };
 
 const struct gfs2_log_operations gfs2_rg_lops = {
-	.lo_add = rg_lo_add,
-	.lo_after_commit = rg_lo_after_commit,
 	.lo_name = "rg",
 };
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 079587e..69166ff 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -77,8 +77,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	spin_lock_init(&sdp->sd_rindex_spin);
 	mutex_init(&sdp->sd_rindex_mutex);
-	INIT_LIST_HEAD(&sdp->sd_rindex_list);
-	INIT_LIST_HEAD(&sdp->sd_rindex_mru_list);
+	sdp->sd_rindex_tree.rb_node = NULL;
 
 	INIT_LIST_HEAD(&sdp->sd_jindex_list);
 	spin_lock_init(&sdp->sd_jindex_spin);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7f8af1e..00f6e3d 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -15,6 +15,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/prefetch.h>
 #include <linux/blkdev.h>
+#include <linux/rbtree.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -328,15 +329,25 @@ static inline int rgrp_contains_block(struct gfs2_rgrpd *rgd, u64 block)
 
 struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk)
 {
-	struct gfs2_rgrpd *rgd;
+	struct rb_node **newn, *parent = NULL;
 
 	spin_lock(&sdp->sd_rindex_spin);
 
-	list_for_each_entry(rgd, &sdp->sd_rindex_mru_list, rd_list_mru) {
-		if (rgrp_contains_block(rgd, blk)) {
-			list_move(&rgd->rd_list_mru, &sdp->sd_rindex_mru_list);
+	newn = &sdp->sd_rindex_tree.rb_node;
+
+	/* Figure out where to put new node */
+	while (*newn) {
+		struct gfs2_rgrpd *cur = rb_entry(*newn, struct gfs2_rgrpd,
+						  rd_node);
+
+		parent = *newn;
+		if (blk < cur->rd_addr)
+			newn = &((*newn)->rb_left);
+		else if (blk > cur->rd_data0 + cur->rd_data)
+			newn = &((*newn)->rb_right);
+		else {
 			spin_unlock(&sdp->sd_rindex_spin);
-			return rgd;
+			return cur;
 		}
 	}
 
@@ -354,8 +365,13 @@ struct gfs2_rgrpd *gfs2_blk2rgrpd(struct gfs2_sbd *sdp, u64 blk)
 
 struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp)
 {
-	gfs2_assert(sdp, !list_empty(&sdp->sd_rindex_list));
-	return list_entry(sdp->sd_rindex_list.next, struct gfs2_rgrpd, rd_list);
+	const struct rb_node *n;
+	struct gfs2_rgrpd *rgd;
+
+	n = rb_first(&sdp->sd_rindex_tree);
+	rgd = rb_entry(n, struct gfs2_rgrpd, rd_node);
+
+	return rgd;
 }
 
 /**
@@ -367,28 +383,34 @@ struct gfs2_rgrpd *gfs2_rgrpd_get_first(struct gfs2_sbd *sdp)
 
 struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd)
 {
-	if (rgd->rd_list.next == &rgd->rd_sbd->sd_rindex_list)
+	struct gfs2_sbd *sdp = rgd->rd_sbd;
+	const struct rb_node *n;
+
+	spin_lock(&sdp->sd_rindex_spin);
+	n = rb_next(&rgd->rd_node);
+	if (n == NULL)
+		n = rb_first(&sdp->sd_rindex_tree);
+
+	if (unlikely(&rgd->rd_node == n)) {
+		spin_unlock(&sdp->sd_rindex_spin);
 		return NULL;
-	return list_entry(rgd->rd_list.next, struct gfs2_rgrpd, rd_list);
+	}
+	rgd = rb_entry(n, struct gfs2_rgrpd, rd_node);
+	spin_unlock(&sdp->sd_rindex_spin);
+	return rgd;
 }
 
 static void clear_rgrpdi(struct gfs2_sbd *sdp)
 {
-	struct list_head *head;
+	struct rb_node *n;
 	struct gfs2_rgrpd *rgd;
 	struct gfs2_glock *gl;
 
-	spin_lock(&sdp->sd_rindex_spin);
-	sdp->sd_rindex_forward = NULL;
-	spin_unlock(&sdp->sd_rindex_spin);
-
-	head = &sdp->sd_rindex_list;
-	while (!list_empty(head)) {
-		rgd = list_entry(head->next, struct gfs2_rgrpd, rd_list);
+	while ((n = rb_first(&sdp->sd_rindex_tree))) {
+		rgd = rb_entry(n, struct gfs2_rgrpd, rd_node);
 		gl = rgd->rd_gl;
 
-		list_del(&rgd->rd_list);
-		list_del(&rgd->rd_list_mru);
+		rb_erase(n, &sdp->sd_rindex_tree);
 
 		if (gl) {
 			gl->gl_object = NULL;
@@ -535,6 +557,29 @@ static void gfs2_rindex_in(struct gfs2_rgrpd *rgd, const void *buf)
 	rgd->rd_bitbytes = be32_to_cpu(str->ri_bitbytes);
 }
 
+static void rgd_insert(struct gfs2_rgrpd *rgd)
+{
+	struct gfs2_sbd *sdp = rgd->rd_sbd;
+	struct rb_node **newn = &sdp->sd_rindex_tree.rb_node, *parent = NULL;
+
+	/* Figure out where to put new node */
+	while (*newn) {
+		struct gfs2_rgrpd *cur = rb_entry(*newn, struct gfs2_rgrpd,
+						  rd_node);
+
+		parent = *newn;
+		if (rgd->rd_addr < cur->rd_addr)
+			newn = &((*newn)->rb_left);
+		else if (rgd->rd_addr > cur->rd_addr)
+			newn = &((*newn)->rb_right);
+		else
+			return;
+	}
+
+	rb_link_node(&rgd->rd_node, parent, newn);
+	rb_insert_color(&rgd->rd_node, &sdp->sd_rindex_tree);
+}
+
 /**
  * read_rindex_entry - Pull in a new resource index entry from the disk
  * @gl: The glock covering the rindex inode
@@ -566,14 +611,11 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 	if (!rgd)
 		return error;
 
-	mutex_init(&rgd->rd_mutex);
-	lops_init_le(&rgd->rd_le, &gfs2_rg_lops);
 	rgd->rd_sbd = sdp;
 
-	list_add_tail(&rgd->rd_list, &sdp->sd_rindex_list);
-	list_add_tail(&rgd->rd_list_mru, &sdp->sd_rindex_mru_list);
-
 	gfs2_rindex_in(rgd, buf);
+	rgd_insert(rgd);
+
 	error = compute_bitstructs(rgd);
 	if (error)
 		return error;
@@ -585,6 +627,8 @@ static int read_rindex_entry(struct gfs2_inode *ip,
 
 	rgd->rd_gl->gl_object = rgd;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
+	if (rgd->rd_data > sdp->sd_max_rg_data)
+		sdp->sd_max_rg_data = rgd->rd_data;
 	return error;
 }
 
@@ -601,8 +645,6 @@ int gfs2_ri_update(struct gfs2_inode *ip)
 	struct inode *inode = &ip->i_inode;
 	struct file_ra_state ra_state;
 	u64 rgrp_count = i_size_read(inode);
-	struct gfs2_rgrpd *rgd;
-	unsigned int max_data = 0;
 	int error;
 
 	do_div(rgrp_count, sizeof(struct gfs2_rindex));
@@ -617,10 +659,6 @@ int gfs2_ri_update(struct gfs2_inode *ip)
 		}
 	}
 
-	list_for_each_entry(rgd, &sdp->sd_rindex_list, rd_list)
-		if (rgd->rd_data > max_data)
-			max_data = rgd->rd_data;
-	sdp->sd_max_rg_data = max_data;
 	sdp->sd_rindex_uptodate = 1;
 	return 0;
 }
@@ -694,7 +732,7 @@ static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
 }
 
 /**
- * gfs2_rgrp_bh_get - Read in a RG's header and bitmaps
+ * gfs2_rgrp_go_lock - Read in a RG's header and bitmaps
  * @rgd: the struct gfs2_rgrpd describing the RG to read in
  *
  * Read in all of a Resource Group's header and bitmap blocks.
@@ -703,8 +741,9 @@ static void gfs2_rgrp_out(struct gfs2_rgrpd *rgd, void *buf)
  * Returns: errno
  */
 
-int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
+int gfs2_rgrp_go_lock(struct gfs2_holder *gh)
 {
+	struct gfs2_rgrpd *rgd = gh->gh_gl->gl_object;
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	struct gfs2_glock *gl = rgd->rd_gl;
 	unsigned int length = rgd->rd_length;
@@ -712,17 +751,6 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 	unsigned int x, y;
 	int error;
 
-	mutex_lock(&rgd->rd_mutex);
-
-	spin_lock(&sdp->sd_rindex_spin);
-	if (rgd->rd_bh_count) {
-		rgd->rd_bh_count++;
-		spin_unlock(&sdp->sd_rindex_spin);
-		mutex_unlock(&rgd->rd_mutex);
-		return 0;
-	}
-	spin_unlock(&sdp->sd_rindex_spin);
-
 	for (x = 0; x < length; x++) {
 		bi = rgd->rd_bits + x;
 		error = gfs2_meta_read(gl, rgd->rd_addr + x, 0, &bi->bi_bh);
@@ -747,15 +775,9 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 			clear_bit(GBF_FULL, &rgd->rd_bits[x].bi_flags);
 		gfs2_rgrp_in(rgd, (rgd->rd_bits[0].bi_bh)->b_data);
 		rgd->rd_flags |= (GFS2_RDF_UPTODATE | GFS2_RDF_CHECK);
+		rgd->rd_free_clone = rgd->rd_free;
 	}
 
-	spin_lock(&sdp->sd_rindex_spin);
-	rgd->rd_free_clone = rgd->rd_free;
-	rgd->rd_bh_count++;
-	spin_unlock(&sdp->sd_rindex_spin);
-
-	mutex_unlock(&rgd->rd_mutex);
-
 	return 0;
 
 fail:
@@ -765,52 +787,32 @@ fail:
 		bi->bi_bh = NULL;
 		gfs2_assert_warn(sdp, !bi->bi_clone);
 	}
-	mutex_unlock(&rgd->rd_mutex);
 
 	return error;
 }
 
-void gfs2_rgrp_bh_hold(struct gfs2_rgrpd *rgd)
-{
-	struct gfs2_sbd *sdp = rgd->rd_sbd;
-
-	spin_lock(&sdp->sd_rindex_spin);
-	gfs2_assert_warn(rgd->rd_sbd, rgd->rd_bh_count);
-	rgd->rd_bh_count++;
-	spin_unlock(&sdp->sd_rindex_spin);
-}
-
 /**
- * gfs2_rgrp_bh_put - Release RG bitmaps read in with gfs2_rgrp_bh_get()
+ * gfs2_rgrp_go_unlock - Release RG bitmaps read in with gfs2_rgrp_bh_get()
  * @rgd: the struct gfs2_rgrpd describing the RG to read in
  *
  */
 
-void gfs2_rgrp_bh_put(struct gfs2_rgrpd *rgd)
+void gfs2_rgrp_go_unlock(struct gfs2_holder *gh)
 {
-	struct gfs2_sbd *sdp = rgd->rd_sbd;
+	struct gfs2_rgrpd *rgd = gh->gh_gl->gl_object;
 	int x, length = rgd->rd_length;
 
-	spin_lock(&sdp->sd_rindex_spin);
-	gfs2_assert_warn(rgd->rd_sbd, rgd->rd_bh_count);
-	if (--rgd->rd_bh_count) {
-		spin_unlock(&sdp->sd_rindex_spin);
-		return;
-	}
-
 	for (x = 0; x < length; x++) {
 		struct gfs2_bitmap *bi = rgd->rd_bits + x;
-		kfree(bi->bi_clone);
-		bi->bi_clone = NULL;
 		brelse(bi->bi_bh);
 		bi->bi_bh = NULL;
 	}
 
-	spin_unlock(&sdp->sd_rindex_spin);
 }
 
-static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
-				    const struct gfs2_bitmap *bi)
+void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
+			     struct buffer_head *bh,
+			     const struct gfs2_bitmap *bi)
 {
 	struct super_block *sb = sdp->sd_vfs;
 	struct block_device *bdev = sb->s_bdev;
@@ -823,7 +825,7 @@ static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 	unsigned int x;
 
 	for (x = 0; x < bi->bi_len; x++) {
-		const u8 *orig = bi->bi_bh->b_data + bi->bi_offset + x;
+		const u8 *orig = bh->b_data + bi->bi_offset + x;
 		const u8 *clone = bi->bi_clone + bi->bi_offset + x;
 		u8 diff = ~(*orig | (*orig >> 1)) & (*clone | (*clone >> 1));
 		diff &= 0x55;
@@ -862,28 +864,6 @@ fail:
 	sdp->sd_args.ar_discard = 0;
 }
 
-void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd)
-{
-	struct gfs2_sbd *sdp = rgd->rd_sbd;
-	unsigned int length = rgd->rd_length;
-	unsigned int x;
-
-	for (x = 0; x < length; x++) {
-		struct gfs2_bitmap *bi = rgd->rd_bits + x;
-		if (!bi->bi_clone)
-			continue;
-		if (sdp->sd_args.ar_discard)
-			gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bi);
-		clear_bit(GBF_FULL, &bi->bi_flags);
-		memcpy(bi->bi_clone + bi->bi_offset,
-		       bi->bi_bh->b_data + bi->bi_offset, bi->bi_len);
-	}
-
-	spin_lock(&sdp->sd_rindex_spin);
-	rgd->rd_free_clone = rgd->rd_free;
-	spin_unlock(&sdp->sd_rindex_spin);
-}
-
 /**
  * gfs2_alloc_get - get the struct gfs2_alloc structure for an inode
  * @ip: the incore GFS2 inode structure
@@ -911,20 +891,15 @@ struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip)
 
 static int try_rgrp_fit(struct gfs2_rgrpd *rgd, struct gfs2_alloc *al)
 {
-	struct gfs2_sbd *sdp = rgd->rd_sbd;
-	int ret = 0;
-
 	if (rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
 		return 0;
 
-	spin_lock(&sdp->sd_rindex_spin);
 	if (rgd->rd_free_clone >= al->al_requested) {
 		al->al_rgd = rgd;
-		ret = 1;
+		return 1;
 	}
-	spin_unlock(&sdp->sd_rindex_spin);
 
-	return ret;
+	return 0;
 }
 
 /**
@@ -992,76 +967,6 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 }
 
 /**
- * recent_rgrp_next - get next RG from "recent" list
- * @cur_rgd: current rgrp
- *
- * Returns: The next rgrp in the recent list
- */
-
-static struct gfs2_rgrpd *recent_rgrp_next(struct gfs2_rgrpd *cur_rgd)
-{
-	struct gfs2_sbd *sdp = cur_rgd->rd_sbd;
-	struct list_head *head;
-	struct gfs2_rgrpd *rgd;
-
-	spin_lock(&sdp->sd_rindex_spin);
-	head = &sdp->sd_rindex_mru_list;
-	if (unlikely(cur_rgd->rd_list_mru.next == head)) {
-		spin_unlock(&sdp->sd_rindex_spin);
-		return NULL;
-	}
-	rgd = list_entry(cur_rgd->rd_list_mru.next, struct gfs2_rgrpd, rd_list_mru);
-	spin_unlock(&sdp->sd_rindex_spin);
-	return rgd;
-}
-
-/**
- * forward_rgrp_get - get an rgrp to try next from full list
- * @sdp: The GFS2 superblock
- *
- * Returns: The rgrp to try next
- */
-
-static struct gfs2_rgrpd *forward_rgrp_get(struct gfs2_sbd *sdp)
-{
-	struct gfs2_rgrpd *rgd;
-	unsigned int journals = gfs2_jindex_size(sdp);
-	unsigned int rg = 0, x;
-
-	spin_lock(&sdp->sd_rindex_spin);
-
-	rgd = sdp->sd_rindex_forward;
-	if (!rgd) {
-		if (sdp->sd_rgrps >= journals)
-			rg = sdp->sd_rgrps * sdp->sd_jdesc->jd_jid / journals;
-
-		for (x = 0, rgd = gfs2_rgrpd_get_first(sdp); x < rg;
-		     x++, rgd = gfs2_rgrpd_get_next(rgd))
-			/* Do Nothing */;
-
-		sdp->sd_rindex_forward = rgd;
-	}
-
-	spin_unlock(&sdp->sd_rindex_spin);
-
-	return rgd;
-}
-
-/**
- * forward_rgrp_set - set the forward rgrp pointer
- * @sdp: the filesystem
- * @rgd: The new forward rgrp
- *
- */
-
-static void forward_rgrp_set(struct gfs2_sbd *sdp, struct gfs2_rgrpd *rgd)
-{
-	spin_lock(&sdp->sd_rindex_spin);
-	sdp->sd_rindex_forward = rgd;
-	spin_unlock(&sdp->sd_rindex_spin);
-}
-
-/**
  * get_local_rgrp - Choose and lock a rgrp for allocation
  * @ip: the inode to reserve space for
  * @rgp: the chosen and locked rgrp
@@ -1076,14 +981,15 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *rgd, *begin = NULL;
 	struct gfs2_alloc *al = ip->i_alloc;
-	int flags = LM_FLAG_TRY;
-	int skipped = 0;
-	int loops = 0;
 	int error, rg_locked;
+	int loops = 0;
 
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_goal);
+	rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal);
 
-	while (rgd) {
+	if (rgd == NULL)
+		return -EBADSLT;
+
+	while (loops < 3) {
 		rg_locked = 0;
 
 		if (gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
@@ -1096,80 +1002,24 @@ static int get_local_rgrp(struct gfs2_inode *ip, u64 *last_unlinked)
 		switch (error) {
 		case 0:
 			if (try_rgrp_fit(rgd, al))
-				goto out;
+				return 0;
 			if (rgd->rd_flags & GFS2_RDF_CHECK)
 				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
 			if (!rg_locked)
 				gfs2_glock_dq_uninit(&al->al_rgd_gh);
 			/* fall through */
 		case GLR_TRYFAILED:
-			rgd = recent_rgrp_next(rgd);
-			break;
-
-		default:
-			return error;
-		}
-	}
-
-	/* Go through full list of rgrps */
-
-	begin = rgd = forward_rgrp_get(sdp);
-
-	for (;;) {
-		rg_locked = 0;
-
-		if (gfs2_glock_is_locked_by_me(rgd->rd_gl)) {
-			rg_locked = 1;
-			error = 0;
-		} else {
-			error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE, flags,
-						   &al->al_rgd_gh);
-		}
-		switch (error) {
-		case 0:
-			if (try_rgrp_fit(rgd, al))
-				goto out;
-			if (rgd->rd_flags & GFS2_RDF_CHECK)
-				try_rgrp_unlink(rgd, last_unlinked, ip->i_no_addr);
-			if (!rg_locked)
-				gfs2_glock_dq_uninit(&al->al_rgd_gh);
-			break;
-
-		case GLR_TRYFAILED:
-			skipped++;
+			rgd = gfs2_rgrpd_get_next(rgd);
+			if (rgd == begin)
+				loops++;
 			break;
 
 		default:
 			return error;
 		}
-
-		rgd = gfs2_rgrpd_get_next(rgd);
-		if (!rgd)
-			rgd = gfs2_rgrpd_get_first(sdp);
-
-		if (rgd == begin) {
-			if (++loops >= 3)
-				return -ENOSPC;
-			if (!skipped)
-				loops++;
-			flags = 0;
-			if (loops == 2)
-				gfs2_log_flush(sdp, NULL);
-		}
-	}
-
-out:
-	if (begin) {
-		spin_lock(&sdp->sd_rindex_spin);
-		list_move(&rgd->rd_list_mru, &sdp->sd_rindex_mru_list);
-		spin_unlock(&sdp->sd_rindex_spin);
-		rgd = gfs2_rgrpd_get_next(rgd);
-		if (!rgd)
-			rgd = gfs2_rgrpd_get_first(sdp);
-		forward_rgrp_set(sdp, rgd);
 	}
 
-	return 0;
+	return -ENOSPC;
 }
 
 /**
@@ -1352,6 +1202,7 @@ do_search:
 		/* The GFS2_BLKST_UNLINKED state doesn't apply to the clone
 		   bitmaps, so we must search the originals for that. */
 		buffer = bi->bi_bh->b_data + bi->bi_offset;
+		WARN_ON(!buffer_uptodate(bi->bi_bh));
 		if (old_state != GFS2_BLKST_UNLINKED && bi->bi_clone)
 			buffer = bi->bi_clone + bi->bi_offset;
 
@@ -1371,6 +1222,7 @@ skip:
 
 	if (blk == BFITNOENT)
 		return blk;
+
 	*n = 1;
 	if (old_state == new_state)
 		goto out;
@@ -1539,9 +1391,7 @@ int gfs2_alloc_block(struct gfs2_inode *ip, u64 *bn, unsigned int *n)
 	gfs2_statfs_change(sdp, 0, -(s64)*n, 0);
 	gfs2_quota_change(ip, *n, ip->i_inode.i_uid, ip->i_inode.i_gid);
 
-	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone -= *n;
-	spin_unlock(&sdp->sd_rindex_spin);
 	trace_gfs2_block_alloc(ip, block, *n, GFS2_BLKST_USED);
 	*bn = block;
 	return 0;
@@ -1594,9 +1444,7 @@ int gfs2_alloc_di(struct gfs2_inode *dip, u64 *bn, u64 *generation)
 	gfs2_statfs_change(sdp, 0, -1, +1);
 	gfs2_trans_add_unrevoke(sdp, block, 1);
 
-	spin_lock(&sdp->sd_rindex_spin);
 	rgd->rd_free_clone--;
-	spin_unlock(&sdp->sd_rindex_spin);
 	trace_gfs2_block_alloc(dip, block, 1, GFS2_BLKST_DINODE);
 	*bn = block;
 	return 0;
@@ -1629,8 +1477,6 @@ void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta)
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
-	gfs2_trans_add_rg(rgd);
-
 	/* Directories keep their data in the metadata address space */
 	if (meta || ip->i_depth)
 		gfs2_meta_wipe(ip, bstart, blen);
@@ -1666,7 +1512,6 @@ void gfs2_unlink_di(struct inode *inode)
 	trace_gfs2_block_alloc(ip, blkno, 1, GFS2_BLKST_UNLINKED);
 	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
-	gfs2_trans_add_rg(rgd);
 }
 
 static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
@@ -1688,7 +1533,6 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_statfs_change(sdp, 0, +1, -1);
-	gfs2_trans_add_rg(rgd);
 }
 
 
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index d253f9a..59b950f 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -25,11 +25,8 @@ struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd);
 extern void gfs2_clear_rgrpd(struct gfs2_sbd *sdp);
 extern int gfs2_rindex_hold(struct gfs2_sbd *sdp, struct gfs2_holder *ri_gh);
 
-extern int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd);
-extern void gfs2_rgrp_bh_hold(struct gfs2_rgrpd *rgd);
-extern void gfs2_rgrp_bh_put(struct gfs2_rgrpd *rgd);
-
-extern void gfs2_rgrp_repolish_clones(struct gfs2_rgrpd *rgd);
+extern int gfs2_rgrp_go_lock(struct gfs2_holder *gh);
+extern void gfs2_rgrp_go_unlock(struct gfs2_holder *gh);
 
 extern struct gfs2_alloc *gfs2_alloc_get(struct gfs2_inode *ip);
 static inline void gfs2_alloc_put(struct gfs2_inode *ip)
@@ -72,5 +69,8 @@ extern void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state);
 extern void gfs2_rlist_free(struct gfs2_rgrp_list *rlist);
 extern u64 gfs2_ri_total(struct gfs2_sbd *sdp);
 extern int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl);
+extern void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
+				    struct buffer_head *bh,
+				    const struct gfs2_bitmap *bi);
 
 #endif /* __RGRP_DOT_H__ */
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 9ec73a8..86ac75d 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -185,8 +185,3 @@ void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len)
 	gfs2_log_unlock(sdp);
 }
 
-void gfs2_trans_add_rg(struct gfs2_rgrpd *rgd)
-{
-	lops_add(rgd->rd_sbd, &rgd->rd_le);
-}
-
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index fb56b78..980c5c0 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -34,14 +34,12 @@ static inline unsigned int gfs2_rg_blocks(const struct gfs2_alloc *al)
 	       al->al_requested + 1 : al->al_rgd->rd_length;
 }
 
-int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
-		     unsigned int revokes);
+extern int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
+			    unsigned int revokes);
 
-void gfs2_trans_end(struct gfs2_sbd *sdp);
-
-void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta);
-void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
-void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len);
-void gfs2_trans_add_rg(struct gfs2_rgrpd *rgd);
+extern void gfs2_trans_end(struct gfs2_sbd *sdp);
+extern void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta);
+extern void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
+extern void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len);
 
 #endif /* __TRANS_DOT_H__ */
-- 
1.7.4.4

