Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468Ab1CEBAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:34 -0500
Received: from kroah.org ([198.145.64.141]:50303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760437Ab1CEBA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:28 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.576213840@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tristan Ye <tristan.ye@oracle.com>, Joel Becker <jlbec@evilplan.org>
Subject: [41/73] Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tristan Ye <tristan.ye@oracle.com>

commit acf3bb007e5636ef4c17505affb0974175108553 upstream.

Current refcounttree codes actually didn't writeback the new pages out in
write-back mode, due to a bug of always passing a ZERO number of clusters
to 'ocfs2_cow_sync_writeback', the patch tries to pass a proper one in.

Signed-off-by: Tristan Ye <tristan.ye@oracle.com>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/refcounttree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -3228,7 +3228,7 @@ static int ocfs2_make_clusters_writable(
 					u32 num_clusters, unsigned int e_flags)
 {
 	int ret, delete, index, credits =  0;
-	u32 new_bit, new_len;
+	u32 new_bit, new_len, orig_num_clusters;
 	unsigned int set_len;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	handle_t *handle;
@@ -3261,6 +3261,8 @@ static int ocfs2_make_clusters_writable(
 		goto out;
 	}
 
+	orig_num_clusters = num_clusters;
+
 	while (num_clusters) {
 		ret = ocfs2_get_refcount_rec(ref_ci, context->ref_root_bh,
 					     p_cluster, num_clusters,
@@ -3348,7 +3350,8 @@ static int ocfs2_make_clusters_writable(
 	 * in write-back mode.
 	 */
 	if (context->get_clusters == ocfs2_di_get_clusters) {
-		ret = ocfs2_cow_sync_writeback(sb, context, cpos, num_clusters);
+		ret = ocfs2_cow_sync_writeback(sb, context, cpos,
+					       orig_num_clusters);
 		if (ret)
 			mlog_errno(ret);
 	}


