Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1LNGlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:41:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:20087 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab1LNGlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95956054"
Date: Wed, 14 Dec 2011 14:41:12 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Tao Ma <tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] readahead: make context readahead more conservative
Message-ID: <20111214064112.GA14266@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to prevent negatively impact moderately dense random reads on SSD.

Transaction-Per-Second numbers provided by Taobao:

		QPS	case
		-------------------------------------------------------
		7536	disable context readahead totally
w/ patch:	7129	slower size rampup and start RA on the 3rd read
		6717	slower size rampup
w/o patch:	5581	unmodified context readahead

Before, readahead will be started whenever reading page N+1 when it
happen to read N recently. After patch, we'll only start readahead
when *three* random reads happen to access pages N, N+1, N+2. The
probability of this happening is extremely low for pure random reads,
unless they are very dense, which actually deserves some readahead.

Also start with a smaller readahead window. The impact to interleaved
sequential reads should be small, because for a long run stream, the
the small readahead window rampup phase is negletable.

The context readahead actually benefits clustered random reads on HDD
whose seek cost is pretty high.  However as SSD is increasingly used for
random read workloads it's better for the context readahead to
concentrate on interleaved sequential reads.

Tested-by: Tao Ma <tm@tao.ma>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/readahead.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Post for review first, will include this in the next readahead series.

--- linux-next.orig/mm/readahead.c	2011-12-14 08:57:29.000000000 +0800
+++ linux-next/mm/readahead.c	2011-12-14 08:59:24.000000000 +0800
@@ -594,10 +594,10 @@ static int try_context_readahead(struct 
 	size = count_history_pages(mapping, ra, offset, max);
 
 	/*
-	 * no history pages:
+	 * not enough history pages:
 	 * it could be a random read
 	 */
-	if (!size)
+	if (size <= req_size)
 		return 0;
 
 	/*
@@ -609,8 +609,8 @@ static int try_context_readahead(struct 
 
 	ra->pattern = RA_PATTERN_CONTEXT;
 	ra->start = offset;
-	ra->size = get_init_ra_size(size + req_size, max);
-	ra->async_size = ra->size;
+	ra->size = min(size + req_size, max);
+	ra->async_size = 1;
 
 	return 1;
 }
