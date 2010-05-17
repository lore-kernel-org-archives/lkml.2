Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0EQM6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab0EQM6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:58:12 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/11] GFS2: fix quota state reporting
Date: Mon, 17 May 2010 13:40:20 +0100
Message-Id: <1274100025-26629-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
References: <1274100025-26629-1-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-2-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-3-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-4-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-5-git-send-email-swhiteho@redhat.com>
 <1274100025-26629-6-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We need to report both the accounting and enforcing flags if we are
in enforcing mode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/quota.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6dbcbad..6ca0967 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1418,10 +1418,18 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
 
 	memset(fqs, 0, sizeof(struct fs_quota_stat));
 	fqs->qs_version = FS_QSTAT_VERSION;
-	if (sdp->sd_args.ar_quota == GFS2_QUOTA_ON)
-		fqs->qs_flags = (XFS_QUOTA_UDQ_ENFD | XFS_QUOTA_GDQ_ENFD);
-	else if (sdp->sd_args.ar_quota == GFS2_QUOTA_ACCOUNT)
-		fqs->qs_flags = (XFS_QUOTA_UDQ_ACCT | XFS_QUOTA_GDQ_ACCT);
+
+	switch (sdp->sd_args.ar_quota) {
+	case GFS2_QUOTA_ON:
+		fqs->qs_flags |= (XFS_QUOTA_UDQ_ENFD | XFS_QUOTA_GDQ_ENFD);
+		/*FALLTHRU*/
+	case GFS2_QUOTA_ACCOUNT:
+		fqs->qs_flags |= (XFS_QUOTA_UDQ_ACCT | XFS_QUOTA_GDQ_ACCT);
+		break;
+	case GFS2_QUOTA_OFF:
+		break;
+	}
+
 	if (sdp->sd_quota_inode) {
 		fqs->qs_uquota.qfs_ino = GFS2_I(sdp->sd_quota_inode)->i_no_addr;
 		fqs->qs_uquota.qfs_nblks = sdp->sd_quota_inode->i_blocks;
-- 
1.6.2.5

