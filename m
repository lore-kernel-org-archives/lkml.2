Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1JXMsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab1JXMr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:47:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 22/24] GFS2: Misc fixes
Date: Mon, 24 Oct 2011 13:48:36 +0100
Message-Id: <1319460518-9046-23-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
References: <1319460518-9046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some items picked up through automated code analysis. A few bits
of unreachable code and two unchecked return values.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index de05b4d..0301be6 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -695,8 +695,6 @@ static int databuf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 
 		brelse(bh_log);
 		brelse(bh_ip);
-		if (error)
-			break;
 
 		sdp->sd_replayed_blocks++;
 	}
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 69166ff..7e823bb 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -651,7 +651,6 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 		fs_err(sdp, "can't lookup journal index: %d\n", error);
 		return PTR_ERR(sdp->sd_jindex);
 	}
-	ip = GFS2_I(sdp->sd_jindex);
 
 	/* Load in the journal index special file */
 
@@ -763,7 +762,6 @@ fail:
 static int init_inodes(struct gfs2_sbd *sdp, int undo)
 {
 	int error = 0;
-	struct gfs2_inode *ip;
 	struct inode *master = sdp->sd_master_dir->d_inode;
 
 	if (undo)
@@ -788,7 +786,6 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 		fs_err(sdp, "can't get resource index inode: %d\n", error);
 		goto fail_statfs;
 	}
-	ip = GFS2_I(sdp->sd_rindex);
 	sdp->sd_rindex_uptodate = 0;
 
 	/* Read in the quota inode */
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 10a59cd..7e528dc 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -645,8 +645,11 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	int err, nbytes;
 	u64 size;
 
-	if (gfs2_is_stuffed(ip))
-		gfs2_unstuff_dinode(ip, NULL);
+	if (gfs2_is_stuffed(ip)) {
+		err = gfs2_unstuff_dinode(ip, NULL);
+		if (err)
+			return err;
+	}
 
 	memset(&q, 0, sizeof(struct gfs2_quota));
 	err = gfs2_internal_read(ip, NULL, (char *)&q, &loc, sizeof(q));
@@ -927,7 +930,9 @@ int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 	unsigned int x;
 	int error = 0;
 
-	gfs2_quota_hold(ip, uid, gid);
+	error = gfs2_quota_hold(ip, uid, gid);
+	if (error)
+		return error;
 
 	if (capable(CAP_SYS_RESOURCE) ||
 	    sdp->sd_args.ar_quota != GFS2_QUOTA_ON)
-- 
1.7.4.4

