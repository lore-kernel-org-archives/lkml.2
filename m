Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0K2Nmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:42:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0K2Nmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:42:42 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 29 Nov 2010 13:42:56 +0000
Message-ID: <1291038176.2429.12.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following fix,

Steve.

-----------------------------------------------------------------------------
The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

  Linux 2.6.37-rc2 (2010-11-15 18:31:02 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Abhijith Das (1):
      GFS2: Userland expects quota limit/warn/usage in 512b blocks

 fs/gfs2/quota.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)
----------------------------------------------------------------------

>From 14870b457524e745f1a118e17873d104b1a47b70 Mon Sep 17 00:00:00 2001
From: Abhijith Das <adas@redhat.com>
Date: Thu, 18 Nov 2010 11:24:24 -0500
Subject: [PATCH] GFS2: Userland expects quota limit/warn/usage in 512b blocks

Userland programs using the quotactl() syscall assume limit/warn/usage
block counts in 512b basic blocks which were instead being read/written
in fs blocksize in gfs2. With this patch, gfs2 correctly interacts with
the syscall using 512b blocks.

Signed-off-by: Abhi Das <adas@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 58a9b99..f606baf 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -631,6 +631,7 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 			     struct fs_disk_quota *fdq)
 {
 	struct inode *inode = &ip->i_inode;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct address_space *mapping = inode->i_mapping;
 	unsigned long index = loc >> PAGE_CACHE_SHIFT;
 	unsigned offset = loc & (PAGE_CACHE_SIZE - 1);
@@ -658,11 +659,11 @@ static int gfs2_adjust_quota(struct gfs2_inode *ip, loff_t loc,
 	qd->qd_qb.qb_value = qp->qu_value;
 	if (fdq) {
 		if (fdq->d_fieldmask & FS_DQ_BSOFT) {
-			qp->qu_warn = cpu_to_be64(fdq->d_blk_softlimit);
+			qp->qu_warn = cpu_to_be64(fdq->d_blk_softlimit >> sdp->sd_fsb2bb_shift);
 			qd->qd_qb.qb_warn = qp->qu_warn;
 		}
 		if (fdq->d_fieldmask & FS_DQ_BHARD) {
-			qp->qu_limit = cpu_to_be64(fdq->d_blk_hardlimit);
+			qp->qu_limit = cpu_to_be64(fdq->d_blk_hardlimit >> sdp->sd_fsb2bb_shift);
 			qd->qd_qb.qb_limit = qp->qu_limit;
 		}
 	}
@@ -1497,9 +1498,9 @@ static int gfs2_get_dqblk(struct super_block *sb, int type, qid_t id,
 	fdq->d_version = FS_DQUOT_VERSION;
 	fdq->d_flags = (type == QUOTA_USER) ? FS_USER_QUOTA : FS_GROUP_QUOTA;
 	fdq->d_id = id;
-	fdq->d_blk_hardlimit = be64_to_cpu(qlvb->qb_limit);
-	fdq->d_blk_softlimit = be64_to_cpu(qlvb->qb_warn);
-	fdq->d_bcount = be64_to_cpu(qlvb->qb_value);
+	fdq->d_blk_hardlimit = be64_to_cpu(qlvb->qb_limit) << sdp->sd_fsb2bb_shift;
+	fdq->d_blk_softlimit = be64_to_cpu(qlvb->qb_warn) << sdp->sd_fsb2bb_shift;
+	fdq->d_bcount = be64_to_cpu(qlvb->qb_value) << sdp->sd_fsb2bb_shift;
 
 	gfs2_glock_dq_uninit(&q_gh);
 out:
@@ -1566,10 +1567,10 @@ static int gfs2_set_dqblk(struct super_block *sb, int type, qid_t id,
 
 	/* If nothing has changed, this is a no-op */
 	if ((fdq->d_fieldmask & FS_DQ_BSOFT) &&
-	    (fdq->d_blk_softlimit == be64_to_cpu(qd->qd_qb.qb_warn)))
+	    ((fdq->d_blk_softlimit >> sdp->sd_fsb2bb_shift) == be64_to_cpu(qd->qd_qb.qb_warn)))
 		fdq->d_fieldmask ^= FS_DQ_BSOFT;
 	if ((fdq->d_fieldmask & FS_DQ_BHARD) &&
-	    (fdq->d_blk_hardlimit == be64_to_cpu(qd->qd_qb.qb_limit)))
+	    ((fdq->d_blk_hardlimit >> sdp->sd_fsb2bb_shift) == be64_to_cpu(qd->qd_qb.qb_limit)))
 		fdq->d_fieldmask ^= FS_DQ_BHARD;
 	if (fdq->d_fieldmask == 0)
 		goto out_i;
-- 
1.7.2.3



