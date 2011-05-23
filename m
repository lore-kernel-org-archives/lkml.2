Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1EWNBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:01:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1EWNBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:01:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 1/2] GFS2: Wipe directory hash table metadata when deallocating a directory
Date: Mon, 23 May 2011 13:39:18 +0100
Message-Id: <1306154359-7046-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1306154359-7046-1-git-send-email-swhiteho@redhat.com>
References: <1306154359-7046-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The deallocation code for directories in GFS2 is largely divided into
two parts. The first part deallocates any directory leaf blocks and
marks the directory as being a regular file when that is complete. The
second stage was identical to deallocating regular files.

Regular files have their data blocks in a different
address space to directories, and thus what would have been normal data
blocks in a regular file (the hash table in a GFS2 directory) were
deallocated correctly. However, a reference to these blocks was left in the
journal (assuming of course that some previous activity had resulted in
those blocks being in the journal or ail list).

This patch uses the i_depth as a test of whether the inode is an
exhash directory (we cannot test the inode type as that has already
been changed to a regular file at this stage in deallocation)

The original issue was reported by Chris Hertel as an issue he encountered
running bonnie++

Reported-by: Christopher R. Hertel <crh@samba.org>
Cc: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 74add2d..e65493a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -780,6 +780,8 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 	metadata = (height != ip->i_height - 1);
 	if (metadata)
 		revokes = (height) ? sdp->sd_inptrs : sdp->sd_diptrs;
+	else if (ip->i_depth)
+		revokes = sdp->sd_inptrs;
 
 	if (ip != GFS2_I(sdp->sd_rindex))
 		error = gfs2_rindex_hold(sdp, &ip->i_alloc->al_ri_gh);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7273ad3..9b780df 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1629,6 +1629,10 @@ void __gfs2_free_data(struct gfs2_inode *ip, u64 bstart, u32 blen)
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 
 	gfs2_trans_add_rg(rgd);
+
+	/* Directories keep their data in the metadata address space */
+	if (ip->i_depth)
+		gfs2_meta_wipe(ip, bstart, blen);
 }
 
 /**
-- 
1.7.4

