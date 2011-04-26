Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1DZJvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:51:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:46561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1DZJvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:51:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="634172778"
Message-Id: <20110426094859.463438303@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 26 Apr 2011 17:43:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Tim Chen <tim.c.chen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Li Shaohua <shaohua.li@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH 2/3] readahead: reduce unnecessary mmap_miss increases
References: <20110426094352.030753173@intel.com>
Content-Disposition: inline; filename=readahead-reduce-mmap_miss-increases.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The original INT_MAX is too large, reduce it to

- avoid unnecessarily dirtying/bouncing the cache line
- restore mmap read-around faster on changed access pattern

Tested-by: Tim Chen <tim.c.chen@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/filemap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next.orig/mm/filemap.c	2011-04-23 09:01:44.000000000 +0800
+++ linux-next/mm/filemap.c	2011-04-23 09:17:21.000000000 +0800
@@ -1538,7 +1538,8 @@ static void do_sync_mmap_readahead(struc
 		return;
 	}
 
-	if (ra->mmap_miss < INT_MAX)
+	/* Avoid banging the cache line if not needed */
+	if (ra->mmap_miss < MMAP_LOTSAMISS * 10)
 		ra->mmap_miss++;
 
 	/*


