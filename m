Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab1JXMrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1JXMr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/24] GFS2: Fix bug-trap in ail flush code
Date: Mon, 24 Oct 2011 13:48:17 +0100
Message-Id: <1319460518-9046-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The assert was being tested under the wrong lock, a
legacy of the original code. Also, if it does trigger,
the resulting information was not always a lot of help.

This moves the patch under the correct lock and also
prints out more useful information in tacking down the
source of the problem.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index da21eca..99df483 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -28,6 +28,17 @@
 #include "trans.h"
 #include "dir.h"
 
+static void gfs2_ail_error(struct gfs2_glock *gl, const struct buffer_head *bh)
+{
+	fs_err(gl->gl_sbd, "AIL buffer %p: blocknr %llu state 0x%08lx mapping %p page state 0x%lx\n",
+	       bh, (unsigned long long)bh->b_blocknr, bh->b_state,
+	       bh->b_page->mapping, bh->b_page->flags);
+	fs_err(gl->gl_sbd, "AIL glock %u:%llu mapping %p\n",
+	       gl->gl_name.ln_type, gl->gl_name.ln_number,
+	       gfs2_glock2aspace(gl));
+	gfs2_lm_withdraw(gl->gl_sbd, "AIL error\n");
+}
+
 /**
  * __gfs2_ail_flush - remove all buffers for a given lock from the AIL
  * @gl: the glock
@@ -41,20 +52,24 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl)
 	struct list_head *head = &gl->gl_ail_list;
 	struct gfs2_bufdata *bd;
 	struct buffer_head *bh;
+	sector_t blocknr;
 
 	spin_lock(&sdp->sd_ail_lock);
 	while (!list_empty(head)) {
 		bd = list_entry(head->next, struct gfs2_bufdata,
 				bd_ail_gl_list);
 		bh = bd->bd_bh;
-		gfs2_remove_from_ail(bd);
-		bd->bd_bh = NULL;
+		blocknr = bh->b_blocknr;
+		if (buffer_busy(bh))
+			gfs2_ail_error(gl, bh);
 		bh->b_private = NULL;
+		gfs2_remove_from_ail(bd); /* drops ref on bh */
 		spin_unlock(&sdp->sd_ail_lock);
 
-		bd->bd_blkno = bh->b_blocknr;
+		bd->bd_bh = NULL;
+		bd->bd_blkno = blocknr;
+
 		gfs2_log_lock(sdp);
-		gfs2_assert_withdraw(sdp, !buffer_busy(bh));
 		gfs2_trans_add_revoke(sdp, bd);
 		gfs2_log_unlock(sdp);
 
-- 
1.7.4.4

