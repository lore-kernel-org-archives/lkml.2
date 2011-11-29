Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1K2Kxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:53:55 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54505 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1K2Kwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:52:39 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 5/7] mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup() only when necessary
Date: Tue, 29 Nov 2011 11:52:03 +0100
Message-Id: <1322563925-1667-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
References: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lookup_page_cgroup() is usually used only against pages that are used
in userspace.

The exception is the CONFIG_DEBUG_VM-only memcg check from the page
allocator: it can run on pages without page_cgroup descriptors
allocated when the pages are fed into the page allocator for the first
time during boot or memory hotplug.

Include the array check only when CONFIG_DEBUG_VM is set and save the
unnecessary check in production kernels.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/page_cgroup.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index a14655d..58405ca 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -28,9 +28,16 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
 	struct page_cgroup *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_cgroup;
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * The sanity checks the page allocator does upon freeing a
+	 * page can reach here before the page_cgroup arrays are
+	 * allocated when feeding a range of pages to the allocator
+	 * for the first time during bootup or memory hotplug.
+	 */
 	if (unlikely(!base))
 		return NULL;
-
+#endif
 	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
 	return base + offset;
 }
@@ -87,9 +94,16 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
-
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * The sanity checks the page allocator does upon freeing a
+	 * page can reach here before the page_cgroup arrays are
+	 * allocated when feeding a range of pages to the allocator
+	 * for the first time during bootup or memory hotplug.
+	 */
 	if (!section->page_cgroup)
 		return NULL;
+#endif
 	return section->page_cgroup + pfn;
 }
 
-- 
1.7.6.4

