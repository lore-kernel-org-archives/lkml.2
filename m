Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1BXNkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:40:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1BXNkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:40:49 -0500
Date: Thu, 24 Feb 2011 14:40:45 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM v2
Message-ID: <20110224134045.GA22122@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
 <1298485162.7236.4.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298485162.7236.4.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second version of the patch. I have used alloc_pages_exact
instead of the complex double array approach.

I still fallback to kmalloc/vmalloc because hotplug can happen quite
some time after boot and we can end up not having enough continuous
pages at that time. 

I am also thinking whether it would make sense to introduce
alloc_pages_exact_node function which would allocate pages from the
given node.

Any thoughts?
---
>From e8909bbd1d759de274a6ed7812530e576ad8bc44 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 24 Feb 2011 11:25:44 +0100
Subject: [PATCH] page_cgroup: Reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM

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

We can reduce the internal fragmentation either by imeplementing 2
dimensional array and allocate kmalloc aligned sizes for each entry (as
suggested in https://lkml.org/lkml/2011/2/23/232) or we can get rid of
kmalloc altogether and allocate directly from the buddy allocator (use
alloc_pages_exact) as suggested by Dave Hansen.

The later solution is much simpler and the internal fragmentation is
comparable (~1 page per section).

We still need a fallback to kmalloc/vmalloc because we have no
guarantees that we will have a continuous memory of that size (order-10)
later on the hotplug events.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/page_cgroup.c |   62 ++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada..eaae7de 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -105,7 +105,41 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
 	return section->page_cgroup + pfn;
 }
 
-/* __alloc_bootmem...() is protected by !slab_available() */
+static void *__init_refok alloc_mcg_table(size_t size, int nid)
+{
+	void *addr = NULL;
+	if((addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN)))
+		return addr;
+
+	if (node_state(nid, N_HIGH_MEMORY)) {
+		addr = kmalloc_node(size, GFP_KERNEL | __GFP_NOWARN, nid);
+		if (!addr)
+			addr = vmalloc_node(size, nid);
+	} else {
+		addr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!addr)
+			addr = vmalloc(size);
+	}
+
+	return addr;
+}
+
+static void *free__mcg_table(void *addr)
+{
+	if (is_vmalloc_addr(addr)) {
+		vfree(addr);
+	} else {
+		struct page *page = virt_to_page(addr);
+		if (!PageReserved(page)) { /* Is bootmem ? */
+			if (!PageSlab(page)) {
+				size_t table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+				free_pages_exact(addr, table_size);
+			} else
+				kfree(addr);
+		}
+	}
+}
+
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *section = __pfn_to_section(pfn);
@@ -114,19 +148,9 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
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
+		base = alloc_mcg_table(table_size, nid);
 		/*
 		 * The value stored in section->page_cgroup is (base - pfn)
 		 * and it does not point to the memory block allocated above,
@@ -170,16 +194,8 @@ void __free_page_cgroup(unsigned long pfn)
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
+	free__mcg_table(base);
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
