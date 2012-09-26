Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2IZIwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 04:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480Ab2IZIv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 04:51:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 20/27] GFS2: Improve block reservation tracing
Date: Wed, 26 Sep 2012 09:25:41 +0100
Message-Id: <1348647948-3219-21-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
References: <1348647948-3219-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the tracing of block reservations by
removing some corner cases and also providing more useful
detail in the traces.

A new field is added to the reservation structure to contain
the inode number. This is used since in certain contexts it is
not possible to access the inode itself to obtain this information.
As a result we can then display the inode number for all tracepoints
and also in case we dump the resource group.

The "del" tracepoint operation has been removed. This could be called
with the reservation rgrp set to NULL. That resulted in not printing
the device number, and thus making the information largely useless
anyway. Also, the conditional on the rgrp being NULL can then be
removed from the tracepoint. After this change, all the block
reservation tracepoint calls will be called with the rgrp information.

The existing ins,clm and tdel calls to the block reservation tracepoint
are sufficient to track the entire life of the block reservation.

In gfs2_block_alloc() the error detection is updated to print out
the inode number of the problematic inode. This can then be compared
against the information in the glock dump,tracepoints, etc.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 99d7c64..6aaa07c 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -268,13 +268,11 @@ struct gfs2_blkreserv {
 	/* components used during write (step 1): */
 	atomic_t rs_sizehint;         /* hint of the write size */
 
-	/* components used during get_local_rgrp (step 3): */
-	struct gfs2_rbm rs_rbm;
 	struct gfs2_holder rs_rgd_gh; /* Filled in by get_local_rgrp */
 	struct rb_node rs_node;       /* link to other block reservations */
-
-	/* components used during block searches and assignments (step 4): */
+	struct gfs2_rbm rs_rbm;       /* Start of reservation */
 	u32 rs_free;                  /* how many blocks are still free */
+	u64 rs_inum;                  /* Inode number for reservation */
 
 	/* ancillary quota stuff */
 	struct gfs2_quota_data *rs_qa_qd[2 * MAXQUOTAS];
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 30c864e..87ee0b7 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -448,10 +448,11 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	return error;
 }
 
-static void dump_rs(struct seq_file *seq, struct gfs2_blkreserv *rs)
+static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)
 {
-	gfs2_print_dbg(seq, "  r: %llu s:%llu b:%u f:%u\n",
-		       rs->rs_rbm.rgd->rd_addr, gfs2_rbm_to_block(&rs->rs_rbm),
+	gfs2_print_dbg(seq, "  B: n:%llu s:%llu b:%u f:%u\n",
+		       (unsigned long long)rs->rs_inum,
+		       (unsigned long long)gfs2_rbm_to_block(&rs->rs_rbm),
 		       rs->rs_rbm.offset, rs->rs_free);
 }
 
@@ -468,7 +469,7 @@ static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 		return;
 
 	rgd = rs->rs_rbm.rgd;
-	trace_gfs2_rs(ip, rs, TRACE_RS_TREEDEL);
+	trace_gfs2_rs(rs, TRACE_RS_TREEDEL);
 	rb_erase(&rs->rs_node, &rgd->rd_rstree);
 	RB_CLEAR_NODE(&rs->rs_node);
 	BUG_ON(!rgd->rd_rs_cnt);
@@ -511,7 +512,6 @@ void gfs2_rs_delete(struct gfs2_inode *ip)
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res) {
 		gfs2_rs_deltree(ip, ip->i_res);
-		trace_gfs2_rs(ip, ip->i_res, TRACE_RS_DELETE);
 		BUG_ON(ip->i_res->rs_free);
 		kmem_cache_free(gfs2_rsrv_cachep, ip->i_res);
 		ip->i_res = NULL;
@@ -1253,6 +1253,7 @@ static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
 	rs->rs_free = amount;
 	rs->rs_rbm.offset = biblk;
 	rs->rs_rbm.bi = bi;
+	rs->rs_inum = ip->i_no_addr;
 	rb_link_node(&rs->rs_node, parent, newn);
 	rb_insert_color(&rs->rs_node, &rgd->rd_rstree);
 
@@ -1260,7 +1261,7 @@ static struct gfs2_blkreserv *rs_insert(struct gfs2_bitmap *bi,
 	rgd->rd_reserved += amount; /* blocks reserved */
 	rgd->rd_rs_cnt++; /* number of in-tree reservations */
 	spin_unlock(&rgd->rd_rsspin);
-	trace_gfs2_rs(ip, rs, TRACE_RS_INSERT);
+	trace_gfs2_rs(rs, TRACE_RS_INSERT);
 	return rs;
 }
 
@@ -1966,7 +1967,7 @@ static void gfs2_adjust_reservation(struct gfs2_inode *ip,
 			rlen = min(rs->rs_free, len);
 			rs->rs_free -= rlen;
 			rgd->rd_reserved -= rlen;
-			trace_gfs2_rs(ip, rs, TRACE_RS_CLAIM);
+			trace_gfs2_rs(rs, TRACE_RS_CLAIM);
 			if (rs->rs_free && !ret)
 				goto out;
 		}
@@ -2005,10 +2006,6 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	else
 		goal = rbm.rgd->rd_last_alloc + rbm.rgd->rd_data0;
 
-	if ((goal < rbm.rgd->rd_data0) ||
-	    (goal >= rbm.rgd->rd_data0 + rbm.rgd->rd_data))
-		rbm.rgd = gfs2_blk2rgrpd(sdp, goal, 1);
-
 	gfs2_rbm_from_block(&rbm, goal);
 	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, ip, false);
 
@@ -2019,7 +2016,8 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (error) {
-		fs_warn(sdp, "error=%d, nblocks=%u, full=%d\n", error, *nblocks,
+		fs_warn(sdp, "inum=%llu error=%d, nblocks=%u, full=%d\n",
+			(unsigned long long)ip->i_no_addr, error, *nblocks,
 			test_bit(GBF_FULL, &rbm.rgd->rd_bits->bi_flags));
 		goto rgrp_error;
 	}
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index b947aa4..bbdc78a 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -509,10 +509,9 @@ TRACE_EVENT(gfs2_block_alloc,
 /* Keep track of multi-block reservations as they are allocated/freed */
 TRACE_EVENT(gfs2_rs,
 
-	TP_PROTO(const struct gfs2_inode *ip, const struct gfs2_blkreserv *rs,
-		 u8 func),
+	TP_PROTO(const struct gfs2_blkreserv *rs, u8 func),
 
-	TP_ARGS(ip, rs, func),
+	TP_ARGS(rs, func),
 
 	TP_STRUCT__entry(
 		__field(        dev_t,  dev                     )
@@ -526,18 +525,17 @@ TRACE_EVENT(gfs2_rs,
 	),
 
 	TP_fast_assign(
-		__entry->dev		= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_sbd->sd_vfs->s_dev : 0;
-		__entry->rd_addr	= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_addr : 0;
-		__entry->rd_free_clone	= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_free_clone : 0;
-		__entry->rd_reserved	= rs->rs_rbm.rgd ? rs->rs_rbm.rgd->rd_reserved : 0;
-		__entry->inum		= ip ? ip->i_no_addr : 0;
+		__entry->dev		= rs->rs_rbm.rgd->rd_sbd->sd_vfs->s_dev;
+		__entry->rd_addr	= rs->rs_rbm.rgd->rd_addr;
+		__entry->rd_free_clone	= rs->rs_rbm.rgd->rd_free_clone;
+		__entry->rd_reserved	= rs->rs_rbm.rgd->rd_reserved;
+		__entry->inum		= rs->rs_inum;
 		__entry->start		= gfs2_rbm_to_block(&rs->rs_rbm);
 		__entry->free		= rs->rs_free;
 		__entry->func		= func;
 	),
 
-	TP_printk("%u,%u bmap %llu resrv %llu rg:%llu rf:%lu rr:%lu %s "
-		  "f:%lu",
+	TP_printk("%u,%u bmap %llu resrv %llu rg:%llu rf:%lu rr:%lu %s f:%lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long long)__entry->inum,
 		  (unsigned long long)__entry->start,
-- 
1.7.4

