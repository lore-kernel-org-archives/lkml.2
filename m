Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0EQISi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:18:38 -0400
Received: from mga05.intel.com ([192.55.52.89]:21601 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260Ab0EQISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:18:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="799052707"
Message-ID: <4BF0FBDB.3090202@linux.intel.com>
Date: Mon, 17 May 2010 16:18:35 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] mem-hotplug: separate setup_per_cpu_pageset() into separate
 functions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

No behavior change here.

Move some of setup_per_cpu_pageset() code into a new function
setup_zone_pageset() that will be useful for memory hotplug.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Reviewed-by: Andi Kleen <andi.kleen@intel.com>
---
  mm/page_alloc.c |   37 ++++++++++++++++++++-----------------
  1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d03c946..3eb7c31 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3146,31 +3146,34 @@ static void setup_pagelist_highmark(struct per_cpu_pageset *p,
  		pcp->batch = PAGE_SHIFT * 8;
  }

+static __meminit void setup_zone_pageset(struct zone *zone)
+{
+	int cpu;
+
+	zone->pageset = alloc_percpu(struct per_cpu_pageset);
+
+	for_each_possible_cpu(cpu) {
+		struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
+
+		setup_pageset(pcp, zone_batchsize(zone));
+
+		if (percpu_pagelist_fraction)
+			setup_pagelist_highmark(pcp,
+				(zone->present_pages /
+					percpu_pagelist_fraction));
+	}
+}
+
  /*
   * Allocate per cpu pagesets and initialize them.
   * Before this call only boot pagesets were available.
- * Boot pagesets will no longer be used by this processorr
- * after setup_per_cpu_pageset().
   */
  void __init setup_per_cpu_pageset(void)
  {
  	struct zone *zone;
-	int cpu;

-	for_each_populated_zone(zone) {
-		zone->pageset = alloc_percpu(struct per_cpu_pageset);
-
-		for_each_possible_cpu(cpu) {
-			struct per_cpu_pageset *pcp = per_cpu_ptr(zone->pageset, cpu);
-
-			setup_pageset(pcp, zone_batchsize(zone));
-
-			if (percpu_pagelist_fraction)
-				setup_pagelist_highmark(pcp,
-					(zone->present_pages /
-						percpu_pagelist_fraction));
-		}
-	}
+	for_each_populated_zone(zone)
+		setup_zone_pageset(zone);
  }

  static noinline __init_refok
-- 
1.6.0.rc1

