Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab1EFAZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:09 -0400
Received: from kroah.org ([198.145.64.141]:36836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab1EFAZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:03 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:11 2011
Message-Id: <20110506002211.620454534@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [065/143] GFS2: Clean up gfs2_adjust_quota() and do_glock()
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit 1e72c0f7c40e665d2ed40014750fdd2fa9968bcf upstream.

Both of these functions contained confusing and in one case
duplicate code. This patch adds a new check in do_glock()
so that we report -ENOENT if we are asked to sync a quota
entry which doesn't exist. Due to the previous patch this is
now reported correctly to userspace.

Also there are a few new comments, and I hope that the code
is easier to understand now.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/gfs2/quota.c |   82 +++++++++++++++++---------------------------------------
 1 file changed, 26 insertions(+), 56 deletions(-)

--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -15,7 +15,7 @@
  * fuzziness in the current usage value of IDs that are being used on different
  * nodes in the cluster simultaneously.  So, it is possible for a user on
  * multiple nodes to overrun their quota, but that overrun is controlable.
- * Since quota tags are part of transactions, there is no need to a quota check
+ * Since quota tags are part of transactions, there is no need for a quota check
  * program to be run on node crashes or anything like that.
  *
  * There are couple of knobs that let the administrator manage the quota
@@ -65,13 +65,6 @@
 #define QUOTA_USER 1
 #define QUOTA_GROUP 0
 
-struct gfs2_quota_host {
-	u64 qu_limit;
-	u64 qu_warn;
-	s64 qu_value;
-	u32 qu_ll_next;
-};
-
 struct gfs2_quota_change_host {
 	u64 qc_change;
 	u32 qc_flags; /* GFS2_QCF_... */
@@ -617,33 +610,19 @@ static void do_qc(struct gfs2_quota_data
 	mutex_unlock(&sdp->sd_quota_mutex);
 }
 
-static void gfs2_quota_in(struct gfs2_quota_host *qu, const void *buf)
-{
-	const struct gfs2_quota *str = buf;
-
-	qu->qu_limit = be64_to_cpu(str->qu_limit);
-	qu->qu_warn = be64_to_cpu(str->qu_warn);
-	qu->qu_value = be64_to_cpu(str->qu_value);
-	qu->qu_ll_next = be32_to_cpu(str->qu_ll_next);
-}
-
-static void gfs2_quota_out(const struct gfs2_quota_host *qu, void *buf)
-{
-	struct gfs2_quota *str = buf;
-
-	str->qu_limit = cpu_to_be64(qu->qu_limit);
-	str->qu_warn = cpu_to_be64(qu->qu_warn);
-	str->qu_value = cpu_to_be64(qu->qu_value);
-	str->qu_ll_next = cpu_to_be32(qu->qu_ll_next);
-	memset(&str->qu_reserved, 0, sizeof(str->qu_reserved));
-}
-
 /**
- * gfs2_adjust_quota
+ * gfs2_adjust_quota - adjust record of current block usage
+ * @ip: The quota inode
+ * @loc: Offset of the entry in the quota file
+ * @change: The amount of change to record
+ * @qd: The quota data
  *
  * This function was mostly borrowed from gfs2_block_truncate_page which was
  * in turn mostly borrowed from ext3
+ *
+ * Returns: 0 or -ve on error
  */
+
 static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 			     s64 change, struct gfs2_quota_data *qd)
 {
@@ -655,8 +634,7 @@ static int gfs2_adjust_quota(struct gfs2
 	struct buffer_head *bh;
 	struct page *page;
 	void *kaddr;
-	char *ptr;
-	struct gfs2_quota_host qp;
+	struct gfs2_quota *qp;
 	s64 value;
 	int err = -EIO;
 
@@ -700,18 +678,13 @@ static int gfs2_adjust_quota(struct gfs2
 	gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
 	kaddr = kmap_atomic(page, KM_USER0);
-	ptr = kaddr + offset;
-	gfs2_quota_in(&qp, ptr);
-	qp.qu_value += change;
-	value = qp.qu_value;
-	gfs2_quota_out(&qp, ptr);
+	qp = kaddr + offset;
+	value = (s64)be64_to_cpu(qp->qu_value) + change;
+	qp->qu_value = cpu_to_be64(value);
+	qd->qd_qb.qb_value = qp->qu_value;
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr, KM_USER0);
 	err = 0;
-	qd->qd_qb.qb_magic = cpu_to_be32(GFS2_MAGIC);
-	qd->qd_qb.qb_value = cpu_to_be64(value);
-	((struct gfs2_quota_lvb*)(qd->qd_gl->gl_lvb))->qb_magic = cpu_to_be32(GFS2_MAGIC);
-	((struct gfs2_quota_lvb*)(qd->qd_gl->gl_lvb))->qb_value = cpu_to_be64(value);
 unlock:
 	unlock_page(page);
 	page_cache_release(page);
@@ -740,8 +713,7 @@ static int do_sync(unsigned int num_qd,
 
 	sort(qda, num_qd, sizeof(struct gfs2_quota_data *), sort_qd, NULL);
 	for (qx = 0; qx < num_qd; qx++) {
-		error = gfs2_glock_nq_init(qda[qx]->qd_gl,
-					   LM_ST_EXCLUSIVE,
+		error = gfs2_glock_nq_init(qda[qx]->qd_gl, LM_ST_EXCLUSIVE,
 					   GL_NOCACHE, &ghs[qx]);
 		if (error)
 			goto out;
@@ -796,8 +768,7 @@ static int do_sync(unsigned int num_qd,
 		qd = qda[x];
 		offset = qd2offset(qd);
 		error = gfs2_adjust_quota(ip, offset, qd->qd_change_sync,
-					  (struct gfs2_quota_data *)
-					  qd);
+					  (struct gfs2_quota_data *)qd);
 		if (error)
 			goto out_end_trans;
 
@@ -828,8 +799,7 @@ static int do_glock(struct gfs2_quota_da
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_quota_inode);
 	struct gfs2_holder i_gh;
-	struct gfs2_quota_host q;
-	char buf[sizeof(struct gfs2_quota)];
+	struct gfs2_quota q;
 	int error;
 	struct gfs2_quota_lvb *qlvb;
 
@@ -853,22 +823,23 @@ restart:
 		if (error)
 			goto fail;
 
-		memset(buf, 0, sizeof(struct gfs2_quota));
+		memset(&q, 0, sizeof(struct gfs2_quota));
 		pos = qd2offset(qd);
-		error = gfs2_internal_read(ip, NULL, buf, &pos,
-					   sizeof(struct gfs2_quota));
+		error = gfs2_internal_read(ip, NULL, (char *)&q, &pos, sizeof(q));
 		if (error < 0)
 			goto fail_gunlock;
-
+		if ((error < sizeof(q)) && force_refresh) {
+			error = -ENOENT;
+			goto fail_gunlock;
+		}
 		gfs2_glock_dq_uninit(&i_gh);
 
-		gfs2_quota_in(&q, buf);
 		qlvb = (struct gfs2_quota_lvb *)qd->qd_gl->gl_lvb;
 		qlvb->qb_magic = cpu_to_be32(GFS2_MAGIC);
 		qlvb->__pad = 0;
-		qlvb->qb_limit = cpu_to_be64(q.qu_limit);
-		qlvb->qb_warn = cpu_to_be64(q.qu_warn);
-		qlvb->qb_value = cpu_to_be64(q.qu_value);
+		qlvb->qb_limit = q.qu_limit;
+		qlvb->qb_warn = q.qu_warn;
+		qlvb->qb_value = q.qu_value;
 		qd->qd_qb = *qlvb;
 
 		if (gfs2_glock_is_blocking(qd->qd_gl)) {
@@ -1127,7 +1098,6 @@ int gfs2_quota_refresh(struct gfs2_sbd *
 		gfs2_glock_dq_uninit(&q_gh);
 
 	qd_put(qd);
-
 	return error;
 }
 


