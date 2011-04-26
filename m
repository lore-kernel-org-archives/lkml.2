Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1DZJvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:51:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:36124 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab1DZJvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:51:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="914478277"
Message-Id: <20110426094859.591091128@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 26 Apr 2011 17:43:55 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Tim Chen <tim.c.chen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>
cc: Li Shaohua <shaohua.li@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 3/3] readahead: trigger mmap sequential readahead on PG_readahead
References: <20110426094352.030753173@intel.com>
Content-Disposition: inline; filename=readahead-no-mmap-prev_pos.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously the mmap sequential readahead is triggered by updating
ra->prev_pos on each page fault and compare it with current page offset.

In the mosbench exim benchmark which does multi-threaded page faults on
shared struct file, this is found to cause excessive cache line bouncing
on tmpfs, which does not need readahead at all.

So remove the ra->prev_pos recording, and instead tag PG_readahead to
trigger the possible sequential readahead. It's not only more simple,
but also will work more reliably on concurrent reads on shared struct file.

Tested-by: Tim Chen <tim.c.chen@intel.com>
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-next.orig/mm/filemap.c	2011-04-23 16:52:21.000000000 +0800
+++ linux-next/mm/filemap.c	2011-04-24 09:59:08.000000000 +0800
@@ -1531,8 +1531,7 @@ static void do_sync_mmap_readahead(struc
 	if (!ra->ra_pages)
 		return;
 
-	if (VM_SequentialReadHint(vma) ||
-			offset - 1 == (ra->prev_pos >> PAGE_CACHE_SHIFT)) {
+	if (VM_SequentialReadHint(vma)) {
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1555,7 +1554,7 @@ static void do_sync_mmap_readahead(struc
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	ra->start = max_t(long, 0, offset - ra_pages / 2);
 	ra->size = ra_pages;
-	ra->async_size = 0;
+	ra->async_size = ra_pages / 4;
 	ra_submit(ra, mapping, file);
 }
 
@@ -1661,7 +1660,6 @@ retry_find:
 		return VM_FAULT_SIGBUS;
 	}
 
-	ra->prev_pos = (loff_t)offset << PAGE_CACHE_SHIFT;
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 


