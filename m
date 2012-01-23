Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2AWDkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 22:40:10 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:47495 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2AWDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 22:39:55 -0500
X-AuditID: b753bd60-9ea82ba000000655-57-4f1cd688199f
X-AuditID: b753bd60-9ea82ba000000655-57-4f1cd688199f
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH 3/3] xfs: cleanup quota check on disk blocks and inodes
 reservations
To: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Christoph Hellwig <hch@lst.de>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Date: Mon, 23 Jan 2012 12:45:43 +0900
Message-ID: <20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a cleanup of quota check on disk blocks and inodes
reservations.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
---

 fs/xfs/xfs_trans_dquot.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c4ba366..5e6cd1c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -605,7 +605,7 @@ xfs_trans_dqresv(
 	time_t		timer;
 	xfs_qwarncnt_t	warns;
 	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	count;
+	xfs_qcnt_t	tcount;
 	xfs_qcnt_t	*resbcountp;
 	xfs_quotainfo_t	*q = mp->m_quotainfo;
 
@@ -648,13 +648,12 @@ xfs_trans_dqresv(
 			 * hardlimit or exceed the timelimit if we allocate
 			 * nblks.
 			 */
-			if (hardlimit > 0ULL &&
-			    hardlimit < nblks + *resbcountp) {
+			tcount = *resbcountp + nblks;
+			if (hardlimit > 0ULL && tcount > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL &&
-			    softlimit < nblks + *resbcountp) {
+			if (softlimit > 0ULL && tcount > softlimit) {
 				if ((timer != 0 && get_seconds() > timer) ||
 				    (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,
@@ -666,7 +665,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			count = be64_to_cpu(dqp->q_core.d_icount);
+			tcount = be64_to_cpu(dqp->q_core.d_icount) + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
@@ -677,13 +676,11 @@ xfs_trans_dqresv(
 			if (!softlimit)
 				softlimit = q->qi_isoftlimit;
 
-			if (hardlimit > 0ULL &&
-			    hardlimit < ninos + count) {
+			if (hardlimit > 0ULL && tcount > hardlimit) {
 				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
 				goto error_return;
 			}
-			if (softlimit > 0ULL &&
-			    softlimit < ninos + count) {
+			if (softlimit > 0ULL && tcount > softlimit) {
 				if  ((timer != 0 && get_seconds() > timer) ||
 				     (warns != 0 && warns >= warnlimit)) {
 					xfs_quota_warn(mp, dqp,

