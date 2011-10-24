Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1JXMwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932349Ab1JXMre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:34 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/24] GFS2: Fix bug trap and journaled data fsync
Date: Mon, 24 Oct 2011 13:48:20 +0100
Message-Id: <1319460518-9046-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Journaled data requires that a complete flush of all dirty data for
the file is done, in order that the ail flush which comes after
will succeed.

Also the recently enhanced bug trap can trigger falsely in case
an ail flush from fsync races with a page read. This updates the
bug trap such that it will ignore buffers which are locked and
only trigger on dirty and/or pinned buffers when the ail flush
is run from fsync. The original bug trap is retained when ail
flush is run from ->go_sync()

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 92c3db4..9d12286 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -590,6 +590,8 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 			mutex_unlock(&inode->i_mutex);
 			return ret;
 		}
+		if (gfs2_is_jdata(ip))
+			filemap_write_and_wait(mapping);
 		gfs2_ail_flush(ip->i_gl);
 		mutex_unlock(&inode->i_mutex);
 	}
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 99df483..0cc3ff4 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -46,7 +46,7 @@ static void gfs2_ail_error(struct gfs2_glock *gl, const struct buffer_head *bh)
  * None of the buffers should be dirty, locked, or pinned.
  */
 
-static void __gfs2_ail_flush(struct gfs2_glock *gl)
+static void __gfs2_ail_flush(struct gfs2_glock *gl, unsigned long b_state)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct list_head *head = &gl->gl_ail_list;
@@ -60,7 +60,7 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl)
 				bd_ail_gl_list);
 		bh = bd->bd_bh;
 		blocknr = bh->b_blocknr;
-		if (buffer_busy(bh))
+		if (bh->b_state & b_state)
 			gfs2_ail_error(gl, bh);
 		bh->b_private = NULL;
 		gfs2_remove_from_ail(bd); /* drops ref on bh */
@@ -99,7 +99,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	BUG_ON(current->journal_info);
 	current->journal_info = &tr;
 
-	__gfs2_ail_flush(gl);
+	__gfs2_ail_flush(gl, (1ul << BH_Dirty)|(1ul << BH_Pinned)|(1ul << BH_Lock));
 
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
@@ -117,7 +117,7 @@ void gfs2_ail_flush(struct gfs2_glock *gl)
 	ret = gfs2_trans_begin(sdp, 0, revokes);
 	if (ret)
 		return;
-	__gfs2_ail_flush(gl);
+	__gfs2_ail_flush(gl, (1ul << BH_Dirty)|(1ul << BH_Pinned));
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
 }
-- 
1.7.4.4

