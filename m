Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1ESJOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab1ESJKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:25 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/32] GFS2: Fix ail list traversal
Date: Thu, 19 May 2011 09:47:11 +0100
Message-Id: <1305794847-3291-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the recent patches to update the AIL list code, I managed to
forget that the ail list lock got dropped, even though I
added a comment specifically to remind myself :(

Reported-by: Barry Marson <bmarson@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index ad1f188..cec26c0 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -89,9 +89,9 @@ void gfs2_remove_from_ail(struct gfs2_bufdata *bd)
  *
  */
 
-static void gfs2_ail1_start_one(struct gfs2_sbd *sdp,
-				struct writeback_control *wbc,
-				struct gfs2_ail *ai)
+static int gfs2_ail1_start_one(struct gfs2_sbd *sdp,
+			       struct writeback_control *wbc,
+			       struct gfs2_ail *ai)
 __releases(&sdp->sd_ail_lock)
 __acquires(&sdp->sd_ail_lock)
 {
@@ -100,7 +100,6 @@ __acquires(&sdp->sd_ail_lock)
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
 
-restart:
 	list_for_each_entry_safe_reverse(bd, s, &ai->ai_ail1_list, bd_ail_st_list) {
 		bh = bd->bd_bh;
 
@@ -120,13 +119,17 @@ restart:
 		gl = bd->bd_gl;
 		list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 		mapping = bh->b_page->mapping;
+		if (!mapping)
+			continue;
 		spin_unlock(&sdp->sd_ail_lock);
 		generic_writepages(mapping, wbc);
 		spin_lock(&sdp->sd_ail_lock);
 		if (wbc->nr_to_write <= 0)
 			break;
-		goto restart;
+		return 1;
 	}
+
+	return 0;
 }
 
 
@@ -146,10 +149,12 @@ void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc)
 
 	trace_gfs2_ail_flush(sdp, wbc, 1);
 	spin_lock(&sdp->sd_ail_lock);
+restart:
 	list_for_each_entry_reverse(ai, head, ai_list) {
 		if (wbc->nr_to_write <= 0)
 			break;
-		gfs2_ail1_start_one(sdp, wbc, ai); /* This may drop ail lock */
+		if (gfs2_ail1_start_one(sdp, wbc, ai))
+			goto restart;
 	}
 	spin_unlock(&sdp->sd_ail_lock);
 	trace_gfs2_ail_flush(sdp, wbc, 0);
-- 
1.7.4

