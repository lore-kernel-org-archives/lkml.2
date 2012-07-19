Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2GSXe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:34:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:17652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab2GSXe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:34:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="174510183"
Subject: [PATCH] Cgroup: Fix memory accounting scalability in
 shrink_page_list
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andi.kleen" <andi.kleen@intel.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jul 2012 16:34:26 -0700
Message-ID: <1342740866.13492.50.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed in a multi-process parallel files reading benchmark I ran on a
8 socket machine,  throughput slowed down by a factor of 8 when I ran
the benchmark within a cgroup container.  I traced the problem to the
following code path (see below) when we are trying to reclaim memory
from file cache.  The res_counter_uncharge function is called on every
page that's reclaimed and created heavy lock contention.  The patch
below allows the reclaimed pages to be uncharged from the resource
counter in batch and recovered the regression. 

Tim

     40.67%           usemem  [kernel.kallsyms]                   [k] _raw_spin_lock
                      |
                      --- _raw_spin_lock
                         |
                         |--92.61%-- res_counter_uncharge
                         |          |
                         |          |--100.00%-- __mem_cgroup_uncharge_common
                         |          |          |
                         |          |          |--100.00%-- mem_cgroup_uncharge_cache_page
                         |          |          |          __remove_mapping
                         |          |          |          shrink_page_list
                         |          |          |          shrink_inactive_list
                         |          |          |          shrink_mem_cgroup_zone
                         |          |          |          shrink_zone
                         |          |          |          do_try_to_free_pages
                         |          |          |          try_to_free_pages
                         |          |          |          __alloc_pages_nodemask
                         |          |          |          alloc_pages_current


---
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33dc256..aac5672 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -779,6 +779,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 
 	cond_resched();
 
+	mem_cgroup_uncharge_start();
 	while (!list_empty(page_list)) {
 		enum page_references references;
 		struct address_space *mapping;
@@ -1026,6 +1027,7 @@ keep_lumpy:
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
+	mem_cgroup_uncharge_end();
 	*ret_nr_dirty += nr_dirty;
 	*ret_nr_writeback += nr_writeback;
 	return nr_reclaimed;


