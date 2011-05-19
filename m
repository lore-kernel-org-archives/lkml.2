Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab1ESJQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:16:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764Ab1ESJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:10:11 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/32] GFS2: Use filemap_fdatawrite() to write back the AIL
Date: Thu, 19 May 2011 09:47:02 +0100
Message-Id: <1305794847-3291-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
References: <1305794847-3291-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to ensure that the mapping stats (and thus the bdi) are correctly
updated, this patch changes the AIL writeback to use the filemap_datawrite
function. This helps prevent stalls in balance_dirty_pages() due to
large amounts of dirty metadata when there is little or no dirty data
around.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 5b102c1..3ebafa1 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -91,6 +91,7 @@ static void gfs2_ail1_start_one(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
 __releases(&sdp->sd_ail_lock)
 __acquires(&sdp->sd_ail_lock)
 {
+	struct gfs2_glock *gl = NULL;
 	struct gfs2_bufdata *bd, *s;
 	struct buffer_head *bh;
 	int retry;
@@ -113,19 +114,13 @@ __acquires(&sdp->sd_ail_lock)
 
 			if (!buffer_dirty(bh))
 				continue;
-
+			if (gl == bd->bd_gl)
+				continue;
+			gl = bd->bd_gl;
 			list_move(&bd->bd_ail_st_list, &ai->ai_ail1_list);
 
-			get_bh(bh);
 			spin_unlock(&sdp->sd_ail_lock);
-			lock_buffer(bh);
-			if (test_clear_buffer_dirty(bh)) {
-				bh->b_end_io = end_buffer_write_sync;
-				submit_bh(WRITE_SYNC, bh);
-			} else {
-				unlock_buffer(bh);
-				brelse(bh);
-			}
+			filemap_fdatawrite(gfs2_glock2aspace(gl));
 			spin_lock(&sdp->sd_ail_lock);
 
 			retry = 1;
-- 
1.7.4

