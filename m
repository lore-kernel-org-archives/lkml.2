Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab2IKWO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:14:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130Ab2IKWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:14:23 -0400
From: raghu.prabhu13@gmail.com
To: xfs@oss.sgi.com
Cc: david@fromorbit.com, Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM),
        Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/3] XFS: Print error when unable to allocate inodes or out of free inodes.
Date: Wed, 12 Sep 2012 03:43:24 +0530
Message-Id: <93d9b37ce9ad720e14e2f9311e623a8e3e3139f5.1347396641.git.rprabhu@wnohang.net>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
In-Reply-To: <cover.1347396641.git.rprabhu@wnohang.net>
References: <cover.1347396641.git.rprabhu@wnohang.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

When xfs_dialloc is unable to allocate required number of inodes or there are no
AGs with free inodes, printk the error in ratelimited manner.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_ialloc.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index e75a39d..034131b 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -990,8 +990,11 @@ xfs_dialloc(
 				goto out_error;
 
 			xfs_perag_put(pag);
-			*inop = NULLFSINO;
-			return 0;
+
+			xfs_err_ratelimited(mp,
+				"Unable to allocate inodes in AG %d: Required %d, Current %llu, Maximum %llu",
+				agno, XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
+			goto out_spc;
 		}
 
 		if (ialloced) {
@@ -1016,11 +1019,19 @@ nextag:
 		if (++agno == mp->m_sb.sb_agcount)
 			agno = 0;
 		if (agno == start_agno) {
-			*inop = NULLFSINO;
-			return noroom ? ENOSPC : 0;
+			if (noroom) {
+				xfs_err_ratelimited(mp,
+					"Out of AGs with free inodes: Required %d, Current %llu, Maximum %llu",
+					 XFS_IALLOC_INODES(mp), mp->m_sb.sb_icount, mp->m_maxicount);
+				goto out_spc;
+			}
+			return 0;
 		}
 	}
 
+out_spc:
+	*inop = NULLFSINO;
+	return ENOSPC;
 out_alloc:
 	*IO_agbp = NULL;
 	return xfs_dialloc_ag(tp, agbp, parent, inop);
-- 
1.7.12

