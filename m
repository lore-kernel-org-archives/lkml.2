Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1DMJGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 05:06:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:1489 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909Ab1DMJGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 05:06:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,203,1301900400"; 
   d="scan'208";a="678447181"
Message-Id: <20110413090415.511675208@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 13 Apr 2011 16:59:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Jan Kara <jack@suse.cz>
cc: Dave Chinner <david@fromorbit.com>
cc: Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/4] writeback: avoid duplicate balance_dirty_pages_ratelimited() calls
References: <20110413085937.981293444@intel.com>
Content-Disposition: inline; filename=writeback-fix-duplicate-bdp-calls.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dd in 512bytes, balance_dirty_pages_ratelimited() could be called 8
times for the same page, but obviously the page is only dirtied once.

Fix it with a (slightly racy) PageDirty() test.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/filemap.c	2011-04-13 16:46:01.000000000 +0800
+++ linux-next/mm/filemap.c	2011-04-13 16:47:26.000000000 +0800
@@ -2313,6 +2313,7 @@ static ssize_t generic_perform_write(str
 	long status = 0;
 	ssize_t written = 0;
 	unsigned int flags = 0;
+	unsigned int dirty;
 
 	/*
 	 * Copies from kernel address space cannot fail (NFSD is a big user).
@@ -2361,6 +2362,7 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		dirty = PageDirty(page);
 		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
@@ -2387,7 +2389,8 @@ again:
 		pos += copied;
 		written += copied;
 
-		balance_dirty_pages_ratelimited(mapping);
+		if (!dirty)
+			balance_dirty_pages_ratelimited(mapping);
 
 	} while (iov_iter_count(i));
 


