Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab0JHAId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:08:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42146 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0JHAIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:08:31 -0400
Date: Fri, 8 Oct 2010 11:08:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Elder <aelder@sgi.com>
Subject: linux-next: build failure after merge of the xfs tree
Message-Id: <20101008110828.1380e307.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

[I tried to cc this to Johannes Weiner <hannes@cmpxchg.org>, but that
domain does not current resolve :-(]

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/xfs/linux-2.6/xfs_sync.c:671: error: redefinition of '__xfs_inode_clear_reclaim_tag'
fs/xfs/linux-2.6/xfs_sync.c:623: note: previous definition of '__xfs_inode_clear_reclaim_tag' was here

Caused by a mismerge between commit
081003fff467ea0e727f66d5d435b4f473a789b3 ("xfs: properly account for
reclaimed inodes") from Linus' tree and commit
5ae4ef8313c85f443202aa04405fe178e6138a6a ("xfs: properly account for
reclaimed inodes") from the xfs tree.  The new function __xfs_inode_clear_reclaim_tag() was inserted in different places in each of those commits, so git inserted them both.

I applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 8 Oct 2010 11:00:58 +1100
Subject: [PATCH] xfs: fix up mismerge of __xfs_inode_clear_reclaim_tag

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/xfs/linux-2.6/xfs_sync.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 574fb71..37d3325 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -667,17 +667,6 @@ xfs_reclaim_inode_grab(
 	return 0;
 }
 
-void
-__xfs_inode_clear_reclaim_tag(
-	xfs_mount_t	*mp,
-	xfs_perag_t	*pag,
-	xfs_inode_t	*ip)
-{
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
-	__xfs_inode_clear_reclaim(pag, ip);
-}
-
 /*
  * Inodes in different states need to be treated differently, and the return
  * value of xfs_iflush is not sufficient to get this right. The following table
-- 
1.7.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
