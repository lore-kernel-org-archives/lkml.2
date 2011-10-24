Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1JXMwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab1JXMrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:31 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/24] GFS2: Make atime checks more efficient
Date: Mon, 24 Oct 2011 13:48:18 +0100
Message-Id: <1319460518-9046-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to start a transaction unless the atime
check has proved positive. Also if we are going to flush
the complete ail list anyway, we might as well skip the
writeback for this specific inode's metadata, since that
will be done as part of the ail writeback process in an
order offering potentially more efficient I/O.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index b7beadd..afb8761 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -768,30 +768,30 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 			goto do_flush;
 		unlock_required = 1;
 	}
-	ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (ret)
-		goto do_unlock;
 	ret = gfs2_meta_inode_buffer(ip, &bh);
 	if (ret == 0) {
 		di = (struct gfs2_dinode *)bh->b_data;
 		atime.tv_sec = be64_to_cpu(di->di_atime);
 		atime.tv_nsec = be32_to_cpu(di->di_atime_nsec);
 		if (timespec_compare(&inode->i_atime, &atime) > 0) {
-			gfs2_trans_add_bh(ip->i_gl, bh, 1);
-			gfs2_dinode_out(ip, bh->b_data);
+			ret = gfs2_trans_begin(sdp, RES_DINODE, 0);
+			if (ret == 0) {
+				gfs2_trans_add_bh(ip->i_gl, bh, 1);
+				gfs2_dinode_out(ip, bh->b_data);
+				gfs2_trans_end(sdp);
+			}
 		}
 		brelse(bh);
 	}
-	gfs2_trans_end(sdp);
-do_unlock:
 	if (unlock_required)
 		gfs2_glock_dq_uninit(&gh);
 do_flush:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
-	filemap_fdatawrite(metamapping);
 	if (bdi->dirty_exceeded)
 		gfs2_ail1_flush(sdp, wbc);
+	else
+		filemap_fdatawrite(metamapping);
 	if (!ret && (wbc->sync_mode == WB_SYNC_ALL))
 		ret = filemap_fdatawait(metamapping);
 	if (ret)
-- 
1.7.4.4

