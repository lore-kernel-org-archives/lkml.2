Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1KJBas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 20:30:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58984 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1KJBar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 20:30:47 -0500
X-AuditID: b753bd60-9fe84ba000000655-60-4ebb2944cdf6
X-AuditID: b753bd60-9fe84ba000000655-60-4ebb2944cdf6
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH] [BUGFIX] xfs: use doalloc flag in xfs_qm_dqattach_one()
To: Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@infradead.org>
Date: Thu, 10 Nov 2011 10:33:10 +0900
Message-ID: <20111110013310.3408.41745.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The doalloc arg in xfs_qm_dqattach_one() is a flag that indicates
whether a new area to handle quota information will be allocated
if needed. Originally, it was passed to xfs_qm_dqget(), but has
been removed by the following commit (probably by mistake):

	commit 8e9b6e7fa4544ea8a0e030c8987b918509c8ff47
	Author: Christoph Hellwig <hch@lst.de>
	Date:   Sun Feb 8 21:51:42 2009 +0100

	xfs: remove the unused XFS_QMOPT_DQLOCK flag

As the result, xfs_qm_dqget() called from xfs_qm_dqattach_one()
never allocates the new area even if it is needed.

This patch gives the doalloc arg to xfs_qm_dqget() in
xfs_qm_dqattach_one() to fix this problem.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>
---

 fs/xfs/xfs_qm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 9a0aa76..95ba6dc 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -674,7 +674,8 @@ xfs_qm_dqattach_one(
 	 * disk and we didn't ask it to allocate;
 	 * ESRCH if quotas got turned off suddenly.
 	 */
-	error = xfs_qm_dqget(ip->i_mount, ip, id, type, XFS_QMOPT_DOWARN, &dqp);
+	error = xfs_qm_dqget(ip->i_mount, ip, id, type,
+			     doalloc | XFS_QMOPT_DOWARN, &dqp);
 	if (error)
 		return error;
 

