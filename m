Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161Ab0GWOEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:04:45 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:57256 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760053Ab0GWOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:04:25 -0400
From: Dave Chinner <david@fromorbit.com>
To: npiggin@kernel.dk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, fmayhar@google.com, johnstul@us.ibm.com
Subject: [PATCH 2/2] xfs: shrinker should use a per-filesystem scan count
Date: Sat, 24 Jul 2010 00:04:02 +1000
Message-Id: <1279893842-4246-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100723111310.GI32635@dastard>
References: <20100723111310.GI32635@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The shrinker uses a global static to aggregate excess scan counts.
This should be per filesystem like all the other shrinker context to
operate correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |    5 ++---
 fs/xfs/xfs_mount.h          |    1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 05426bf..b0e6296 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -893,7 +893,6 @@ xfs_reclaim_inode_shrink(
 	unsigned long	global,
 	gfp_t		gfp_mask)
 {
-	static unsigned long nr_to_scan;
 	int		nr;
 	struct xfs_mount *mp;
 	struct xfs_perag *pag;
@@ -908,14 +907,14 @@ xfs_reclaim_inode_shrink(
 		nr_reclaimable += pag->pag_ici_reclaimable;
 		xfs_perag_put(pag);
 	}
-	shrinker_add_scan(&nr_to_scan, scanned, global, nr_reclaimable,
+	shrinker_add_scan(&mp->m_shrink_scan_nr, scanned, global, nr_reclaimable,
 				DEFAULT_SEEKS);
 	if (!(gfp_mask & __GFP_FS)) {
 		return 0;
 	}
 
 done:
-	nr = shrinker_do_scan(&nr_to_scan, SHRINK_BATCH);
+	nr = shrinker_do_scan(&mp->m_shrink_scan_nr, SHRINK_BATCH);
 	if (!nr)
 		return 0;
 	xfs_inode_ag_iterator(mp, xfs_reclaim_inode, 0,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 5761087..ed5531f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -260,6 +260,7 @@ typedef struct xfs_mount {
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
+	unsigned long		m_shrink_scan_nr; /* shrinker scan count */
 } xfs_mount_t;
 
 /*
-- 
1.7.1

