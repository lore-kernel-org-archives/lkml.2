Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab1COJeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1COJeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:34:11 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/15] GFS2: quota allows exceeding hard limit
Date: Tue, 15 Mar 2011 09:11:37 +0000
Message-Id: <1300180305-5993-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
References: <1300180305-5993-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

Immediately after being synced to disk, cached quotas are zeroed out and a
subsequent access of the cached quotas results in incorrect zero values. This
meant that gfs2 assumed the actual usage to be the zero (or near-zero) usage
values it found in the cached quotas and comparison against warn/limits never
triggered a quota violation.

This patch adds a new flag QDF_REFRESH that is set after a sync so that the
cached quotas are forcefully refreshed from disk on a subsequent access on
seeing this flag set.

Resolves: rhbz#675944
Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 720c1e6..59aaaa0 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -317,6 +317,7 @@ enum {
 	QDF_USER		= 0,
 	QDF_CHANGE		= 1,
 	QDF_LOCKED		= 2,
+	QDF_REFRESH		= 3,
 };
 
 struct gfs2_quota_data {
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6ec964c..e23d986 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -834,6 +834,7 @@ static int do_sync(unsigned int num_qd, struct gfs2_quota_data **qda)
 			goto out_end_trans;
 
 		do_qc(qd, -qd->qd_change_sync);
+		set_bit(QDF_REFRESH, &qd->qd_flags);
 	}
 
 	error = 0;
@@ -929,6 +930,7 @@ int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
 	struct gfs2_alloc *al = ip->i_alloc;
+	struct gfs2_quota_data *qd;
 	unsigned int x;
 	int error = 0;
 
@@ -942,7 +944,11 @@ int gfs2_quota_lock(struct gfs2_inode *ip, u32 uid, u32 gid)
 	     sort_qd, NULL);
 
 	for (x = 0; x < al->al_qd_num; x++) {
-		error = do_glock(al->al_qd[x], NO_FORCE, &al->al_qd_ghs[x]);
+		int force = NO_FORCE;
+		qd = al->al_qd[x];
+		if (test_and_clear_bit(QDF_REFRESH, &qd->qd_flags))
+			force = FORCE;
+		error = do_glock(qd, force, &al->al_qd_ghs[x]);
 		if (error)
 			break;
 	}
-- 
1.7.4

