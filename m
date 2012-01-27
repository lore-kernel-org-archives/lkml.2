Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab2A0Dkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:40:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:41153 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2A0Dkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:40:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100232689"
Message-Id: <20120127031326.469063803@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 11:05:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] readahead: make context readahead more conservative
References: <20120127030524.854259561@intel.com>
Content-Disposition: inline; filename=readahead-context-tt
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

--- linux-next.orig/mm/readahead.c	2012-01-25 15:57:47.000000000 +0800
+++ linux-next/mm/readahead.c	2012-01-25 15:57:49.000000000 +0800
@@ -369,10 +369,10 @@ static int try_context_readahead(struct 
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
@@ -383,8 +383,8 @@ static int try_context_readahead(struct 
 		size *= 2;
 
 	ra->start = offset;
-	ra->size = get_init_ra_size(size + req_size, max);
-	ra->async_size = ra->size;
+	ra->size = min(size + req_size, max);
+	ra->async_size = 1;
 
 	return 1;
 }


