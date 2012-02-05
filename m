Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2BEVXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 16:23:17 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25452 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab2BEVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 16:23:16 -0500
Date: Sun, 5 Feb 2012 22:23:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: xfs@oss.sgi.com
cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
 xfs_setattr_nonsize()
Message-ID: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In xfs_setattr_nonsize(), xfs_trans_alloc() gets its memory from
_xfs_trans_alloc() which gets it from kmem_zone_zalloc() which may
fail and return NULL. So this:

	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);

may result in a NULL 'tp'.
If it does, then the call:

	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);

with a NULL 'tp' will explode, since xfs_trans_reserve() dereferences
its first argument unconditionally.

And if the memory allocation for 'tp' goes well (and thus
xfs_trans_reserve() does not explode) then we may leak the memory
allocated to 'tp' if xfs_trans_reserve() returns error.

I believe this patch should fix both issues, but I'm not intimate with
the XFS code at all, so there can easily be something I overlooked or
something that should be done differently than what I did.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 fs/xfs/xfs_iops.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

 Note:
  Please review carefully before applying.
  Especially since I don't currently have any XFS filesystems to test
  this on, nor any clear idea of a good way to actually test this if I
  had. So this patch is compile tested only on my end.

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ab30253..194c9d7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -575,9 +575,14 @@ xfs_setattr_nonsize(
 	}
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
+	if (!tp)
+		goto out_dqrele;
+
 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
-	if (error)
+	if (error) {
+		xfs_trans_cancel(tp, 0);
 		goto out_dqrele;
+	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-- 
1.7.9


Please CC me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

