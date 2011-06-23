Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab1FWRhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:34748 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478Ab1FWRhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:01 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tristan Ye <tristan.ye@oracle.com>,
        Joel Becker <jlbec@evilplan.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 137/247] Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.
Date: Thu, 23 Jun 2011 13:33:25 -0400
Message-Id: <1308850515-15242-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tristan Ye <tristan.ye@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit acf3bb007e5636ef4c17505affb0974175108553 upstream.

Current refcounttree codes actually didn't writeback the new pages out in
write-back mode, due to a bug of always passing a ZERO number of clusters
to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ocfs2/refcounttree.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 9e6dc1d..fe8d576 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3223,7 +3223,7 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 					u32 num_clusters, unsigned int e_flags)
 {
 	int ret, delete, index, credits =  0;
-	u32 new_bit, new_len;
+	u32 new_bit, new_len, orig_num_clusters;
 	unsigned int set_len;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
@@ -3256,6 +3256,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 		goto out;
 	}
 
+	orig_num_clusters = num_clusters;
+
 	while (num_clusters) {
 		ret = ocfs2_get_refcount_rec(ref_ci, context->ref_root_bh,
 					     p_cluster, num_clusters,
@@ -3343,7 +3345,8 @@ static int ocfs2_make_clusters_writable(struct super_block *sb,
 	 * in write-back mode.
 	 */
 	if (context->get_clusters == ocfs2_di_get_clusters) {
-		ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+		ret = ocfs2_cow_sync_writeback(sb, context, cpos,
+					       orig_num_clusters);
 		if (ret)
 			mlog_errno(ret);
 	}
-- 
1.7.4.4

