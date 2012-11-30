Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2K3KYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:24:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab2K3KSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:18:21 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/16] GFS2: Add test for resource group congestion status
Date: Fri, 30 Nov 2012 09:52:09 +0000
Message-Id: <1354269141-3311-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
References: <1354269141-3311-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses information gathered by the recent glock statistics
patch in order to derrive a boolean verdict on the congestion
status of a resource group. This is then used when making decisions
on which resource group to choose during block allocation.

The aim is to avoid resource groups which are heavily contended
by other nodes, while still ensuring locality of access wherever
possible.

Once a reservation has been made in a particular resource group
we continue to use that resource group until a new reservation is
required. This should help to ensure that we do not change resource
groups too often.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 669b89b..bdf3e64 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1681,6 +1681,88 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 	return;
 }
 
+/**
+ * gfs2_rgrp_congested - Use stats to figure out whether an rgrp is congested
+ * @rgd: The rgrp in question
+ * @loops: An indication of how picky we can be (0=very, 1=less so)
+ *
+ * This function uses the recently added glock statistics in order to
+ * figure out whether a parciular resource group is suffering from
+ * contention from multiple nodes. This is done purely on the basis
+ * of timings, since this is the only data we have to work with and
+ * our aim here is to reject a resource group which is highly contended
+ * but (very important) not to do this too often in order to ensure that
+ * we do not land up introducing fragmentation by changing resource
+ * groups when not actually required.
+ *
+ * The calculation is fairly simple, we want to know whether the SRTTB
+ * (i.e. smoothed round trip time for blocking operations) to acquire
+ * the lock for this rgrp's glock is significantly greater than the
+ * time taken for resource groups on average. We introduce a margin in
+ * the form of the variable @var which is computed as the sum of the two
+ * respective variences, and multiplied by a factor depending on @loops
+ * and whether we have a lot of data to base the decision on. This is
+ * then tested against the square difference of the means in order to
+ * decide whether the result is statistically significant or not.
+ *
+ * Returns: A boolean verdict on the congestion status
+ */
+
+static bool gfs2_rgrp_congested(const struct gfs2_rgrpd *rgd, int loops)
+{
+	const struct gfs2_glock *gl = rgd->rd_gl;
+	const struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct gfs2_lkstats *st;
+	s64 r_dcount, l_dcount;
+	s64 r_srttb, l_srttb;
+	s64 srttb_diff;
+	s64 sqr_diff;
+	s64 var;
+
+	preempt_disable();
+	st = &this_cpu_ptr(sdp->sd_lkstats)->lkstats[LM_TYPE_RGRP];
+	r_srttb = st->stats[GFS2_LKS_SRTTB];
+	r_dcount = st->stats[GFS2_LKS_DCOUNT];
+	var = st->stats[GFS2_LKS_SRTTVARB] +
+	      gl->gl_stats.stats[GFS2_LKS_SRTTVARB];
+	preempt_enable();
+
+	l_srttb = gl->gl_stats.stats[GFS2_LKS_SRTTB];
+	l_dcount = gl->gl_stats.stats[GFS2_LKS_DCOUNT];
+
+	if ((l_dcount < 1) || (r_dcount < 1) || (r_srttb == 0))
+		return false;
+
+	srttb_diff = r_srttb - l_srttb;
+	sqr_diff = srttb_diff * srttb_diff;
+
+	var *= 2;
+	if (l_dcount < 8 || r_dcount < 8)
+		var *= 2;
+	if (loops == 1)
+		var *= 2;
+
+	return ((srttb_diff < 0) && (sqr_diff > var));
+}
+
+/**
+ * gfs2_rgrp_used_recently
+ * @rs: The block reservation with the rgrp to test
+ * @msecs: The time limit in milliseconds
+ *
+ * Returns: True if the rgrp glock has been used within the time limit
+ */
+static bool gfs2_rgrp_used_recently(const struct gfs2_blkreserv *rs,
+				    u64 msecs)
+{
+	u64 tdiff;
+
+	tdiff = ktime_to_ns(ktime_sub(ktime_get_real(),
+                            rs->rs_rbm.rgd->rd_gl->gl_dstamp));
+
+	return tdiff > (msecs * 1000 * 1000);
+}
+
 static bool gfs2_select_rgrp(struct gfs2_rgrpd **pos, const struct gfs2_rgrpd *begin)
 {
 	struct gfs2_rgrpd *rgd = *pos;
@@ -1707,7 +1789,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_rgrpd *begin = NULL;
 	struct gfs2_blkreserv *rs = ip->i_res;
-	int error = 0, rg_locked, flags = LM_FLAG_TRY;
+	int error = 0, rg_locked, flags = 0;
 	u64 last_unlinked = NO_BLOCK;
 	int loops = 0;
 
@@ -1731,13 +1813,18 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested)
 
 		if (!gfs2_glock_is_locked_by_me(rs->rs_rbm.rgd->rd_gl)) {
 			rg_locked = 0;
+			if (!gfs2_rs_active(rs) && (loops < 2) &&
+			     gfs2_rgrp_used_recently(rs, 1000) &&
+			     gfs2_rgrp_congested(rs->rs_rbm.rgd, loops))
+				goto next_rgrp;
 			error = gfs2_glock_nq_init(rs->rs_rbm.rgd->rd_gl,
 						   LM_ST_EXCLUSIVE, flags,
 						   &rs->rs_rgd_gh);
-			if (error == GLR_TRYFAILED)
-				goto next_rgrp;
 			if (unlikely(error))
 				return error;
+			if (!gfs2_rs_active(rs) && (loops < 2) &&
+			    gfs2_rgrp_congested(rs->rs_rbm.rgd, loops))
+				goto skip_rgrp;
 			if (sdp->sd_args.ar_rgrplvb) {
 				error = update_rgrp_lvb(rs->rs_rbm.rgd);
 				if (unlikely(error)) {
@@ -1789,7 +1876,6 @@ next_rgrp:
 		 * then this checks for some less likely conditions before
 		 * trying again.
 		 */
-		flags &= ~LM_FLAG_TRY;
 		loops++;
 		/* Check that fs hasn't grown if writing to rindex */
 		if (ip == GFS2_I(sdp->sd_rindex) && !sdp->sd_rindex_uptodate) {
-- 
1.7.4

