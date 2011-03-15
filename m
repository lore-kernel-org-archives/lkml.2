Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1COJe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1COJeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:22 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 13/15] GFS2: Update to AIL list locking
Date: Tue, 15 Mar 2011 09:11:43 +0000
Message-Id: <1300180305-5993-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch missed a couple of places where the AIL list
needed locking, so this fixes up those places, plus a comment
is corrected too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4e3c044..e7ed31f 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -67,7 +67,7 @@ unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
  * @mapping: The associated mapping (maybe NULL)
  * @bd: The gfs2_bufdata to remove
  *
- * The log lock _must_ be held when calling this function
+ * The ail lock _must_ be held when calling this function
  *
  */
 
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 4295a6a..e919abf 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -51,8 +51,10 @@ static void gfs2_pin(struct gfs2_sbd *sdp, struct buffer_head *bh)
 	/* If this buffer is in the AIL and it has already been written
 	 * to in-place disk block, remove it from the AIL.
 	 */
+	spin_lock(&sdp->sd_ail_lock);
 	if (bd->bd_ail)
 		list_move(&bd->bd_ail_st_list, &bd->bd_ail->ai_ail2_list);
+	spin_unlock(&sdp->sd_ail_lock);
 	get_bh(bh);
 	atomic_inc(&sdp->sd_log_pinned);
 	trace_gfs2_pin(bd, 1);
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 939739c..01d97f4 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -326,6 +326,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 		brelse(bh);
 	}
 	if (bd) {
+		spin_lock(&sdp->sd_ail_lock);
 		if (bd->bd_ail) {
 			gfs2_remove_from_ail(bd);
 			bh->b_private = NULL;
@@ -333,6 +334,7 @@ void gfs2_remove_from_journal(struct buffer_head *bh, struct gfs2_trans *tr, int
 			bd->bd_blkno = bh->b_blocknr;
 			gfs2_trans_add_revoke(sdp, bd);
 		}
+		spin_unlock(&sdp->sd_ail_lock);
 	}
 	clear_buffer_dirty(bh);
 	clear_buffer_uptodate(bh);
-- 
1.7.4

