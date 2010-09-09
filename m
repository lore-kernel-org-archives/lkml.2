Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0IILLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:11:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57169 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0IILLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:11:47 -0400
Date: Thu, 9 Sep 2010 12:11:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: xfs@oss.sgi.com
Cc: Alex Elder <aelder@sgi.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH] fs,xfs: Use __GFP_MOVABLE for XFS buffers
Message-ID: <20100909111131.GO29263@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fragmentation avoidance in the kernel depends on reclaimable and movable
allocations being marked-up at page allocation time. Reclaimable allocations
refer to slab caches such as inode caches which can be reclaimed although
not necessarily in a targetted fashion. Movable pages are those pages that
can be moved to backing storage (during page reclaim) or migrated.

When testing against XFS, it was noticed that large page allocation rates
against XFS were far lower than expected in comparison to ext3. Investigation
showed that buffer pages allocated by XFS are placed on the LRU but not
marked __GFP_MOVABLE at allocation time.

This patch updates xb_to_gfp() to specify __GFP_MOVABLE and is correct iff
all pages allocated from a mask derived from xb_to_gfp() are guaranteed to
be movable be it via page reclaim or page migration. It needs an XFS expert
to make that determination but when applied, huge page allocation success
rates are similar to those seen on tests backed by ext3.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index ea79072..93f3fb0 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -67,7 +67,7 @@ struct workqueue_struct *xfsconvertd_workqueue;
 
 #define xb_to_gfp(flags) \
 	((((flags) & XBF_READ_AHEAD) ? __GFP_NORETRY : \
-	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN)
+	  ((flags) & XBF_DONT_BLOCK) ? GFP_NOFS : GFP_KERNEL) | __GFP_NOWARN | __GFP_MOVABLE)
 
 #define xb_to_km(flags) \
 	 (((flags) & XBF_DONT_BLOCK) ? KM_NOFS : KM_SLEEP)
