Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1COJga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab1COJeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:07 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/15] GFS2: panics on quotacheck update
Date: Tue, 15 Mar 2011 09:11:35 +0000
Message-Id: <1300180305-5993-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

Handle block allocation for forceful unstuffing of quota dinode during quota
update using quotactl(). Also fix block reservation for special cases when
quotas cross over block boundaries and update 2 blocks instead of 1.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index a689901..6ec964c 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1587,6 +1587,8 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 
 	offset = qd2offset(qd);
 	alloc_required = gfs2_write_alloc_required(ip, offset, sizeof(struct gfs2_quota));
+	if (gfs2_is_stuffed(ip))
+		alloc_required = 1;
 	if (alloc_required) {
 		al = gfs2_alloc_get(ip);
 		if (al == NULL)
@@ -1600,7 +1602,9 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 		blocks += gfs2_rg_blocks(al);
 	}
 
-	error = gfs2_trans_begin(sdp, blocks + RES_DINODE + 1, 0);
+	/* Some quotas span block boundaries and can update two blocks,
+	   adding an extra block to the transaction to handle such quotas */
+	error = gfs2_trans_begin(sdp, blocks + RES_DINODE + 2, 0);
 	if (error)
 		goto out_release;
 
-- 
1.7.4

