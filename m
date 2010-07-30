Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab0G3SEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:04:34 -0400
Received: from kroah.org ([198.145.64.141]:59308 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab0G3R6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:58:03 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:52 2010
Message-Id: <20100730175152.058981311@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tao Ma <tao.ma@oracle.com>, Joel Becker <joel.becker@oracle.com>
Subject: [200/205] ocfs2: make xattr extension work with new local alloc reservation.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tao Ma <tao.ma@oracle.com>

commit a78f9f4668949a6588b8872f162e86685c63d023 upstream.

The old ocfs2_xattr_extent_allocation is too optimistic about
the clusters we can get. So actually if the file system is
too fragmented, ocfs2_add_clusters_in_btree will return us
with EGAIN and we need to allocate clusters once again.

So this patch change it to a while loop so that we can allocate
clusters until we reach clusters_to_add.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/xattr.c |   88 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 36 deletions(-)

--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -708,7 +708,7 @@ static int ocfs2_xattr_extend_allocation
 					 struct ocfs2_xattr_value_buf *vb,
 					 struct ocfs2_xattr_set_ctxt *ctxt)
 {
-	int status = 0;
+	int status = 0, credits;
 	handle_t *handle = ctxt->handle;
 	enum ocfs2_alloc_restarted why;
 	u32 prev_clusters, logical_start = le32_to_cpu(vb->vb_xv->xr_clusters);
@@ -718,43 +718,59 @@ static int ocfs2_xattr_extend_allocation
 
 	ocfs2_init_xattr_value_extent_tree(&et, INODE_CACHE(inode), vb);
 
-	status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
-			      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
+	while (clusters_to_add) {
+		status = vb->vb_access(handle, INODE_CACHE(inode), vb->vb_bh,
+				       OCFS2_JOURNAL_ACCESS_WRITE);
+		if (status < 0) {
+			mlog_errno(status);
+			break;
+		}
+
+		prev_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
+		status = ocfs2_add_clusters_in_btree(handle,
+						     &et,
+						     &logical_start,
+						     clusters_to_add,
+						     0,
+						     ctxt->data_ac,
+						     ctxt->meta_ac,
+						     &why);
+		if ((status < 0) && (status != -EAGAIN)) {
+			if (status != -ENOSPC)
+				mlog_errno(status);
+			break;
+		}
+
+		status = ocfs2_journal_dirty(handle, vb->vb_bh);
+		if (status < 0) {
+			mlog_errno(status);
+			break;
+		}
+
+		clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) -
+					 prev_clusters;
+
+		if (why != RESTART_NONE && clusters_to_add) {
+			/*
+			 * We can only fail in case the alloc file doesn't give
+			 * up enough clusters.
+			 */
+			BUG_ON(why == RESTART_META);
+
+			mlog(0, "restarting xattr value extension for %u"
+			     " clusters,.\n", clusters_to_add);
+			credits = ocfs2_calc_extend_credits(inode->i_sb,
+							    &vb->vb_xv->xr_list,
+							    clusters_to_add);
+			status = ocfs2_extend_trans(handle, credits);
+			if (status < 0) {
+				status = -ENOMEM;
+				mlog_errno(status);
+				break;
+			}
+		}
 	}
 
-	prev_clusters = le32_to_cpu(vb->vb_xv->xr_clusters);
-	status = ocfs2_add_clusters_in_btree(handle,
-					     &et,
-					     &logical_start,
-					     clusters_to_add,
-					     0,
-					     ctxt->data_ac,
-					     ctxt->meta_ac,
-					     &why);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
-	status = ocfs2_journal_dirty(handle, vb->vb_bh);
-	if (status < 0) {
-		mlog_errno(status);
-		goto leave;
-	}
-
-	clusters_to_add -= le32_to_cpu(vb->vb_xv->xr_clusters) - prev_clusters;
-
-	/*
-	 * We should have already allocated enough space before the transaction,
-	 * so no need to restart.
-	 */
-	BUG_ON(why != RESTART_NONE || clusters_to_add);
-
-leave:
-
 	return status;
 }
 


