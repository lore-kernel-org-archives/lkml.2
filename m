Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2HANqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab2HANqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:46:06 -0400
From: Tomas Racek <tracek@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>,
        Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM),
        Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM),
        xfs@oss.sgi.com (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] xfs: check for possible overflow in xfs_ioc_trim
Date: Wed,  1 Aug 2012 15:45:37 +0200
Message-Id: <1343828737-5324-1-git-send-email-tracek@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If range.start points behind the filesystem, return invalid value error.
This fixes possible overflow in

start = BTOBB(range.start)

when range.start is nearly ULLONG_MAX.

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 fs/xfs/xfs_discard.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index f9c3fe3..33d367f 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -179,12 +179,13 @@ xfs_ioc_trim(
 	 * used by the fstrim application.  In the end it really doesn't
 	 * matter as trimming blocks is an advisory interface.
 	 */
+	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
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

