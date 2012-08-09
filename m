Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2HIJKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2HIJIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:08:44 -0400
From: Tomas Racek <tracek@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>,
        Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM),
        Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM),
        xfs@oss.sgi.com (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] xfs: check for possible overflow in xfs_ioc_trim
Date: Thu,  9 Aug 2012 11:07:09 +0200
Message-Id: <1344503229-13022-1-git-send-email-tracek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If range.start or range.minlen is bigger than filesystem size, return
invalid value error. This fixes possible overflow in BTOBB macro when
passed value was nearly ULLONG_MAX.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/xfs/xfs_discard.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f9c3fe3..4e07a56 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,12 +179,14 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
+	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks) ||
+	    range.minlen > XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
+		return -XFS_ERROR(EINVAL);
+
 	start = BTOBB(range.start);
 	end = start + BTOBBT(range.len) - 1;
 	minlen = BTOBB(max_t(u64, granularity, range.minlen));
 
-	if (XFS_BB_TO_FSB(mp, start) >= mp->m_sb.sb_dblocks)
-		return -XFS_ERROR(EINVAL);
 	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
 		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
 
-- 
1.7.7.6

