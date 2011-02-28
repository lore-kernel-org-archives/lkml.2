Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1B1KJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 05:09:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:57388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab1B1KJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 05:09:25 -0500
Date: Mon, 28 Feb 2011 11:09:20 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 1/2] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM
Message-ID: <20110228100920.GD4648@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
could you consider the patch bellow, please?
The patch was discussed at https://lkml.org/lkml/2011/2/23/232
---
>From 7e5b1e7043605891dacd9e32f19985bc675292f5 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 24 Feb 2011 11:25:44 +0100
Subject: [PATCH 1/2] page_cgroup: Reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM

Currently we are allocating a single page_cgroup array per memory
section (stored in mem_section->base) when CONFIG_SPARSEMEM is selected.
This is correct but memory inefficient solution because the allocated
memory (unless we fall back to vmalloc) is not kmalloc friendly:
        - 32b - 16384 entries (20B per entry) fit into 327680B so the
          524288B slab cache is used
        - 32b with PAE - 131072 entries with 2621440B fit into 4194304B
        - 64b - 32768 entries (40B per entry) fit into 2097152 cache

This is ~37% wasted space per memory section and it sumps up for the
whole memory. On a x86_64 machine it is something like 6MB per 1GB of
RAM.

We can reduce the internal fragmentation by using alloc_pages_exact
which allocates PAGE_SIZE aligned blocks so we will get down to <4kB
wasted memory per section which is much better.

We still need a fallback to vmalloc because we have no guarantees that
we will have a continuous memory of that size (order-10) later on during
the hotplug events.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |   54 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada..eae3cd2 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -105,7 +105,33 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
 	return section->page_cgroup + pfn;
 }
 
-/* __alloc_bootmem...() is protected by !slab_available() */
+static void *__init_refok alloc_page_cgroup(size_t size, int nid)
+{
+	void *addr = NULL;
+	if((addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN)))
+		return addr;
+
+	if (node_state(nid, N_HIGH_MEMORY))
+		addr = vmalloc_node(size, nid);
+	else
+		addr = vmalloc(size);
+
+	return addr;
+}
+
+static void free_page_cgroup(void *addr)
+{
+	if (is_vmalloc_addr(addr)) {
+		vfree(addr);
+	} else {
+		struct page *page = virt_to_page(addr);
+		if (!PageReserved(page)) { /* Is bootmem ? */
+			size_t table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+			free_pages_exact(addr, table_size);
+		}
+	}
+}
+
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *section = __pfn_to_section(pfn);
@@ -114,19 +140,9 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
 	int nid, index;
 
 	if (!section->page_cgroup) {
-		nid = page_to_nid(pfn_to_page(pfn));
 		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-		VM_BUG_ON(!slab_is_available());
-		if (node_state(nid, N_HIGH_MEMORY)) {
-			base = kmalloc_node(table_size,
-				GFP_KERNEL | __GFP_NOWARN, nid);
-			if (!base)
-				base = vmalloc_node(table_size, nid);
-		} else {
-			base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
-			if (!base)
-				base = vmalloc(table_size);
-		}
+		nid = page_to_nid(pfn_to_page(pfn));
+		base = alloc_page_cgroup(table_size, nid);
 		/*
 		 * The value stored in section->page_cgroup is (base - pfn)
 		 * and it does not point to the memory block allocated above,
@@ -170,16 +186,8 @@ void __free_page_cgroup(unsigned long pfn)
 	if (!ms || !ms->page_cgroup)
 		return;
 	base = ms->page_cgroup + pfn;
-	if (is_vmalloc_addr(base)) {
-		vfree(base);
-		ms->page_cgroup = NULL;
-	} else {
-		struct page *page = virt_to_page(base);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			kfree(base);
-			ms->page_cgroup = NULL;
-		}
-	}
+	free_page_cgroup(base);
+	ms->page_cgroup = NULL;
 }
 
 int __meminit online_page_cgroup(unsigned long start_pfn,
-- 
1.7.2.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
