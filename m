Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2A0Dlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:41:31 -0500
Received: from mga14.intel.com ([143.182.124.37]:41153 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab2A0Dki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:40:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100232691"
Message-Id: <20120127031327.567686120@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 11:05:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] readahead: snap readahead request to EOF
References: <20120127030524.854259561@intel.com>
Content-Disposition: inline; filename=readahead-eof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the file size is 20kb and readahead request is [0, 16kb),
it's better to expand the readahead request to [0, 20kb), which will
likely save one followup I/O for the ending [16kb, 20kb).

If the readahead request already covers EOF, trimm it down to EOF.
Also don't set the PG_readahead mark to avoid an unnecessary future
invocation of the readahead code.

This special handling looks worthwhile because small to medium sized
files are pretty common.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- linux-next.orig/mm/readahead.c	2012-01-25 15:57:58.000000000 +0800
+++ linux-next/mm/readahead.c	2012-01-25 15:57:59.000000000 +0800
@@ -466,6 +466,25 @@ unsigned long max_sane_readahead(unsigne
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
 
+static void snap_to_eof(struct file_ra_state *ra, struct address_space *mapping)
+{
+	pgoff_t eof = ((i_size_read(mapping->host)-1) >> PAGE_CACHE_SHIFT) + 1;
+	pgoff_t start = ra->start;
+	unsigned int size = ra->size;
+
+	/*
+	 * skip backwards and random reads
+	 */
+	if (ra->pattern > RA_PATTERN_MMAP_AROUND)
+		return;
+
+	size += min(size / 2, ra->ra_pages / 4);
+	if (start + size > eof) {
+		ra->size = eof - start;
+		ra->async_size = 0;
+	}
+}
+
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
@@ -477,6 +496,8 @@ unsigned long ra_submit(struct file_ra_s
 {
 	int actual;
 
+	snap_to_eof(ra, mapping);
+
 	actual = __do_page_cache_readahead(mapping, filp,
 					ra->start, ra->size, ra->async_size);
 


