Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964943Ab1C3VgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:36:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:49238 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964925Ab1C3VI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278168"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tristan.ye@oracle.com, jlbec@evilplan.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [159/275] Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.
Message-Id: <20110330210641.1DBA13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tristan Ye <tristan.ye@oracle.com>

commit acf3bb007e5636ef4c17505affb0974175108553 upstream.

Current refcounttree codes actually didn't writeback the new pages out in
write-back mode, due to a bug of always passing a ZERO number of clusters
to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ocfs2/refcounttree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/ocfs2/refcounttree.c
===================================================================
--- linux-2.6.35.y.orig/fs/ocfs2/refcounttree.c	2011-03-29 22:51:01.864675455 -0700
+++ linux-2.6.35.y/fs/ocfs2/refcounttree.c	2011-03-29 23:03:01.561260222 -0700
@@ -3215,7 +3215,7 @@
 					u32 num_clusters, unsigned int e_flags)
 {
 	int ret, delete, index, credits =  0;
-	u32 new_bit, new_len;
+	u32 new_bit, new_len, orig_num_clusters;
 	unsigned int set_len;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
@@ -3248,6 +3248,8 @@
 		goto out;
 	}
 
+	orig_num_clusters = num_clusters;
+
 	while (num_clusters) {
 		ret = ocfs2_get_refcount_rec(ref_ci, context->ref_root_bh,
 					     p_cluster, num_clusters,
@@ -3335,7 +3337,8 @@
 	 * in write-back mode.
 	 */
 	if (context->get_clusters == ocfs2_di_get_clusters) {
-		ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+		ret = ocfs2_cow_sync_writeback(sb, context, cpos,
+					       orig_num_clusters);
 		if (ret)
 			mlog_errno(ret);
 	}
