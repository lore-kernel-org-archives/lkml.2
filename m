Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1LBIYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:24:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:60268 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1LBIYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:24:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,282,1320652800"; 
   d="scan'208";a="81430350"
From: Alex Shi <alex.shi@intel.com>
To: cl@linux.com, penberg@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/3] slub: fill per cpu partial only when free objects larger than one quarter
Date: Fri,  2 Dec 2011 16:23:09 +0800
Message-Id: <1322814189-17318-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1322814189-17318-2-git-send-email-alex.shi@intel.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
 <1322814189-17318-2-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alexs@intel.com>

Set selection criteria when fill per cpu partial in slow allocation path,
and check the PCP left space before filling, even maybe the data from another
CPU.
The patch can bring another 1.5% performance increase on netperf loopback
testing for our 4 or 2 sockets machines, include sandbridge, core2

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 mm/slub.c |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 65d901f..72df387 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1542,25 +1542,44 @@ static void *get_partial_node(struct kmem_cache *s,
 
 	spin_lock(&n->list_lock);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
-		void *t = acquire_slab(s, n, page, object == NULL);
 		int available;
+		void *t;
+		struct page *oldpage;
+		int pobjects;
 
-		if (!t)
-			break;
 
 		if (!object) {
-			c->page = page;
-			c->node = page_to_nid(page);
-			stat(s, ALLOC_FROM_PARTIAL);
-			object = t;
-			available =  page->objects - page->inuse;
+			t = acquire_slab(s, n, page, object == NULL);
+			if (!t)
+				break;
+			else {
+				c->page = page;
+				c->node = page_to_nid(page);
+				stat(s, ALLOC_FROM_PARTIAL);
+				object = t;
+			}
 		} else {
-			page->freelist = t;
-			available = put_cpu_partial(s, page, 0);
+			oldpage = this_cpu_read(s->cpu_slab->partial);
+			pobjects = oldpage ? oldpage->pobjects : 0;
+
+			if (pobjects > s->cpu_partial / 2)
+				break;
+
+			available =  page->objects - page->inuse;
+			if (available >= s->cpu_partial / 4) {
+				t = acquire_slab(s, n, page, object == NULL);
+				if (!t)
+					break;
+				else {
+					page->freelist = t;
+					if (put_cpu_partial(s, page, 0) >
+							s->cpu_partial / 2)
+						break;
+				}
+			}
 		}
-		if (kmem_cache_debug(s) || available > s->cpu_partial / 2)
+		if (kmem_cache_debug(s))
 			break;
-
 	}
 	spin_unlock(&n->list_lock);
 	return object;
-- 
1.7.0.1

