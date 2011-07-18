Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1GREE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:04:57 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5341 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017Ab1GREEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:04:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcFACyuI055LCkBgWdsb2JhbABTmG6OfxUBARYmJcp5hjwEo00
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Date: Mon, 18 Jul 2011 14:04:44 +1000
Message-Id: <1310961884-11634-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1310961884-11634-1-git-send-email-david@fromorbit.com>
References: <1310961884-11634-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

lockdep reports splice vs direct-io write lock inversions due to
generic_file_splice_write() taking the inode->i_mutex inside
XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
deadlock.  Use generic_file_splice_write_unlocked() because the
i_mutex does not need to be held over the operations that are done
in the XFS splice write path.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_file.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index f51a384..1e641e6 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -463,7 +463,8 @@ xfs_file_splice_write(
 
 	trace_xfs_file_splice_write(ip, count, *ppos, ioflags);
 
-	ret = generic_file_splice_write(pipe, outfilp, ppos, count, flags);
+	ret = generic_file_splice_write_unlocked(pipe, outfilp, ppos,
+						count, flags);
 
 	xfs_aio_write_isize_update(inode, ppos, ret);
 	xfs_aio_write_newsize_update(ip);
-- 
1.7.5.1

