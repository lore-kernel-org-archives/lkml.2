Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab1B1KLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:11:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:57455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1B1KLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:11:31 -0500
Date: Mon, 28 Feb 2011 11:11:29 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 2/2] page_cgroup array is never stored on reserved pages
Message-ID: <20110228101129.GE4648@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follow up patch to clean up up PageReserved left overs.
--- 
>From b458b849767e41038adce81e59ff30d7d42d7321 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 28 Feb 2011 10:43:12 +0100
Subject: [PATCH 2/2] page_cgroup array is never stored on reserved pages

KAMEZAWA Hiroyuki noted that free_pages_cgroup doesn't have to check for
PageReserved because we never store the array on reserved pages
(neither alloc_pages_exact nor vmalloc use those pages).

So we can replace the check by a BUG_ON.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index eae3cd2..dd5f789 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -125,10 +125,10 @@ static void free_page_cgroup(void *addr)
 		vfree(addr);
 	} else {
 		struct page *page = virt_to_page(addr);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			size_t table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-			free_pages_exact(addr, table_size);
-		}
+		size_t table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+
+		BUG_ON(PageReserved(page));
+		free_pages_exact(addr, table_size);
 	}
 }
 
-- 
1.7.2.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
