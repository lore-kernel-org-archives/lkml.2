Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0LQMqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:46:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab0LQMqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:46:15 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/15] GFS2: Allow gfs2 to update quota usage values through the quotactl interface
Date: Fri, 17 Dec 2010 12:24:13 +0000
Message-Id: <1292588661-14350-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
References: <1292588661-14350-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

With this patch the gfs2_set_dqblk() function will be able to update the
quota usage block count (FS_DQ_BCOUNT) in addition to the already supported
FS_DQ_BHARD (limit) and FS_DQ_BSOFT (warn) fields of the dquot structure.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index f606baf..a689901 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -666,6 +666,10 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 			qp->qu_limit = cpu_to_be64(fdq->d_blk_hardlimit >> sdp->sd_fsb2bb_shift);
 			qd->qd_qb.qb_limit = qp->qu_limit;
 		}
+		if (fdq->d_fieldmask & FS_DQ_BCOUNT) {
+			qp->qu_value = cpu_to_be64(fdq->d_bcount >> sdp->sd_fsb2bb_shift);
+			qd->qd_qb.qb_value = qp->qu_value;
+		}
 	}
 
 	/* Write the quota into the quota file on disk */
@@ -1509,7 +1513,7 @@ out:
 }
 
 /* GFS2 only supports a subset of the XFS fields */
-#define GFS2_FIELDMASK (FS_DQ_BSOFT|FS_DQ_BHARD)
+#define GFS2_FIELDMASK (FS_DQ_BSOFT|FS_DQ_BHARD|FS_DQ_BCOUNT)
 
 static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 			  struct fs_disk_quota *fdq)
@@ -1569,9 +1573,15 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 	if ((fdq->d_fieldmask & FS_DQ_BSOFT) &&
 	    ((fdq->d_blk_softlimit >> sdp->sd_fsb2bb_shift) == be64_to_cpu(qd->qd_qb.qb_warn)))
 		fdq->d_fieldmask ^= FS_DQ_BSOFT;
+
 	if ((fdq->d_fieldmask & FS_DQ_BHARD) &&
 	    ((fdq->d_blk_hardlimit >> sdp->sd_fsb2bb_shift) == be64_to_cpu(qd->qd_qb.qb_limit)))
 		fdq->d_fieldmask ^= FS_DQ_BHARD;
+
+	if ((fdq->d_fieldmask & FS_DQ_BCOUNT) &&
+	    ((fdq->d_bcount >> sdp->sd_fsb2bb_shift) == be64_to_cpu(qd->qd_qb.qb_value)))
+		fdq->d_fieldmask ^= FS_DQ_BCOUNT;
+
 	if (fdq->d_fieldmask == 0)
 		goto out_i;
 
@@ -1620,4 +1630,3 @@ const struct quotactl_ops gfs2_quotactl_ops = {
 	.get_dqblk	= gfs2_get_dqblk,
 	.set_dqblk	= gfs2_set_dqblk,
 };
-
-- 
1.7.3.3

