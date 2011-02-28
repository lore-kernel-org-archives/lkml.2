Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab1B1JNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:13:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:54810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1B1JND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:13:03 -0500
Date: Mon, 28 Feb 2011 10:12:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM v4
Message-ID: <20110228091256.GA4648@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
 <1298485162.7236.4.camel@nimitz>
 <20110224134045.GA22122@tiehlicka.suse.cz>
 <20110225122522.8c4f1057.kamezawa.hiroyu@jp.fujitsu.com>
 <20110225095357.GA23241@tiehlicka.suse.cz>
 <20110228095347.7510b1d4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228095347.7510b1d4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-02-11 09:53:47, KAMEZAWA Hiroyuki wrote:
> On Fri, 25 Feb 2011 10:53:57 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Fri 25-02-11 12:25:22, KAMEZAWA Hiroyuki wrote:
> > > On Thu, 24 Feb 2011 14:40:45 +0100
[...]
> > > The patch itself is fine but please update the description.
> > 
> > I have updated the description but kept those parts which describe how
> > the memory is wasted for different configurations. Do you have any tips
> > how it can be improved?
> > 
> 
> This part was in your description.
> ==
> We can reduce the internal fragmentation either by imeplementing 2
> dimensional array and allocate kmalloc aligned sizes for each entry (as
> suggested in https://lkml.org/lkml/2011/2/23/232) or we can get rid of
> kmalloc altogether and allocate directly from the buddy allocator (use
> alloc_pages_exact) as suggested by Dave Hansen.
> ==
> 
> please remove 2 dimentional..... etc. That's just a history.

I just wanted to mention both approaches. OK, I can remove that, of
course.

> > > 
> > > But have some comments, below.
> > [...]
> > > > -/* __alloc_bootmem...() is protected by !slab_available() */
> > > > +static void *__init_refok alloc_mcg_table(size_t size, int nid)
> > > > +{
> > > > +	void *addr = NULL;
> > > > +	if((addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN)))
> > > > +		return addr;
> > > > +
> > > > +	if (node_state(nid, N_HIGH_MEMORY)) {
> > > > +		addr = kmalloc_node(size, GFP_KERNEL | __GFP_NOWARN, nid);
> > > > +		if (!addr)
> > > > +			addr = vmalloc_node(size, nid);
> > > > +	} else {
> > > > +		addr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> > > > +		if (!addr)
> > > > +			addr = vmalloc(size);
> > > > +	}
> > > > +
> > > > +	return addr;
> > > > +}
> > > 
> > > What is the case we need to call kmalloc_node() even when alloc_pages_exact() fails ?
> > > vmalloc() may need to be called when the size of chunk is larger than
> > > MAX_ORDER or there is fragmentation.....
> > 
> > I kept the original kmalloc with fallback to vmalloc because vmalloc is
> > more scarce resource (especially on i386 where we can have memory
> > hotplug configured as well).
> > 
> 
> My point is, if alloc_pages_exact() failes because of order of the page,
> kmalloc() will always fail. 

You are right. I thought that kmalloc can make a difference due to reclaim
but the reclaim is already triggered by alloc_pages_exact and if it doesn't
succeed there are not big chances to have those pages ready for kmalloc.

> Please remove kmalloc().

OK.

Thanks for the review again and the updated patch is bellow:

Change since v3
- updated changelog - to not mentioned 2dim. solution
- get rid of kmalloc fallback based on Kame's suggestion.
- free_page_cgroup accidentally returned void* (we do not need any return value
  there)

Changes since v2
- rename alloc_mcg_table to alloc_page_cgroup
- free__mcg_table renamed to free_page_cgroup
- get VM_BUG_ON(!slab_is_available()) back into the allocation path

---
>From 84a9555741b59cb2a0a67b023e4bd0f92c670ca1 Mon Sep 17 00:00:00 2001
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

We can reduce the internal fragmentation by using alloc_pages_exact
which allocates PAGE_SIZE aligned blocks so we will get down to <4kB
wasted memory per section which is much better.

We still need a fallback to vmalloc because we have no guarantees that
we will have a continuous memory of that size (order-10) later on during
the hotplug events.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
