Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1K2N2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 08:28:01 -0500
Received: from mga03.intel.com ([143.182.124.21]:46421 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab1K2N0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 08:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="80197570"
Message-Id: <20111129131456.145362960@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Nov 2011 21:09:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/9] readahead: snap readahead request to EOF
References: <20111129130900.628549879@intel.com>
Content-Disposition: inline; filename=readahead-eof
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the file size is 20kb and readahead request is [0, 16kb),
it's better to expand the readahead request to [0, 20kb), which will
likely save one followup I/O for [16kb, 20kb).

If the readahead request already covers EOF, trimm it down to EOF.
Also don't set the PG_readahead mark to avoid an unnecessary future
invocation of the readahead code.

This special handling looks worthwhile because small to medium sized
files are pretty common.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-next.orig/mm/readahead.c	2011-11-29 11:28:56.000000000 +0800
+++ linux-next/mm/readahead.c	2011-11-29 11:29:05.000000000 +0800
@@ -251,8 +251,16 @@ unsigned long max_sane_readahead(unsigne
 unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
+	pgoff_t eof = ((i_size_read(mapping->host)-1) >> PAGE_CACHE_SHIFT) + 1;
+	pgoff_t start = ra->start;
 	int actual;
 
+	/* snap to EOF */
+	if (start + ra->size + ra->size / 2 > eof) {
+		ra->size = eof - start;
+		ra->async_size = 0;
+	}
+
 	actual = __do_page_cache_readahead(mapping, filp,
 					ra->start, ra->size, ra->async_size);
 


