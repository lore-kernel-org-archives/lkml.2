Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab0HTOOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 10:14:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab0HTOOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 10:14:03 -0400
Date: Fri, 20 Aug 2010 16:14:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Make is_mem_section_removable more conformable with
 offlining code
Message-ID: <20100820141400.GD4636@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
what do you think about the patch below?

>From b983695b92b5be58f31c719fada1d3245f7b6768 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 20 Aug 2010 15:39:16 +0200
Subject: [PATCH] Make is_mem_section_removable more conformable with offlining code

Currently is_mem_section_removable checks whether each pageblock from
the given pfn range is of MIGRATE_MOVABLE type or if it is free. If both
are false then the range is considered non removable.

On the other hand, offlining code (more specifically
set_migratetype_isolate) doesn't care whether a page is free and instead
it just checks the migrate type of the page and whether the page's zone
is movable.

This can lead into a situation when a node is marked as removable even
though all pages are neither MIGRATE_MOVABLE nor the zone is
ZONE_MOVABLE.

Also we can mark a node as not removable just because a pageblock is
MIGRATE_RESERVE and not free (and this situation is much more probable).
---
 mm/memory_hotplug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a4cfcdc..da20568 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -611,10 +611,10 @@ int is_mem_section_removable(unsigned long start_pfn, unsigned long nr_pages)
 		type = get_pageblock_migratetype(page);
 
 		/*
-		 * A pageblock containing MOVABLE or free pages is considered
-		 * removable
+		 * A pageblock containing MOVABLE or page from movable
+		 * zone are considered removable
 		 */
-		if (type != MIGRATE_MOVABLE && !pageblock_free(page))
+		if (type != MIGRATE_MOVABLE && zone_idx(page) != ZONE_MOVABLE)
 			return 0;
 
 		/*
-- 
1.7.1


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
