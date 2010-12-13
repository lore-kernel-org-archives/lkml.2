Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196Ab0LMPSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:18:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:24424 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab0LMPIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:08:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,336,1288594800"; 
   d="scan'208";a="583219895"
Message-Id: <20101213150326.733656527@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 22:46:49 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Dave Chinner <david@fromorbit.com>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Chris Mason <chris.mason@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Greg Thelen <gthelen@google.com>
CC: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/35] writeback: prevent duplicate balance_dirty_pages_ratelimited() calls
References: <20101213144646.341970461@intel.com>
Content-Disposition: inline; filename=writeback-fix-duplicate-bdp-calls.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dd in 512bytes, balance_dirty_pages_ratelimited() used to be called
8 times for the same page, even if the page is only dirtied once. Fix it
with a (slightly racy) PageDirty() test.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/filemap.c	2010-12-13 21:45:57.000000000 +0800
+++ linux-next/mm/filemap.c	2010-12-13 21:46:11.000000000 +0800
@@ -2244,6 +2244,7 @@ static ssize_t generic_perform_write(str
 	long status = 0;
 	ssize_t written = 0;
 	unsigned int flags = 0;
+	unsigned int dirty;
 
 	/*
 	 * Copies from kernel address space cannot fail (NFSD is a big user).
@@ -2292,6 +2293,7 @@ again:
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		dirty = PageDirty(page);
 		mark_page_accessed(page);
 		status = a_ops->write_end(file, mapping, pos, bytes, copied,
 						page, fsdata);
@@ -2318,7 +2320,8 @@ again:
 		pos += copied;
 		written += copied;
 
-		balance_dirty_pages_ratelimited(mapping);
+		if (!dirty)
+			balance_dirty_pages_ratelimited(mapping);
 
 	} while (iov_iter_count(i));
 


