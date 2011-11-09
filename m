Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1KIRwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:52:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1KIRwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:52:06 -0500
Date: Wed, 9 Nov 2011 17:52:01 +0000
From: Mel Gorman <mgorman@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, aarcange@redhat.com
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111109175201.GB3083@suse.de>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20111109170027.GB7495@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 06:00:27PM +0100, Jan Kara wrote:
>   I've added to CC some mm developers who know much more about transparent
> hugepages than I do because that is what seems to cause your problems...
> 

This has hit more than once recently.  It's not something I can
reproduce locally as such but the problem seems to be two-fold based

1. processes getting stuck in synchronous reclaim
2. processes faulting at the same time khugepaged is allocating a huge
   page with CONFIG_NUMA enabled

The first one is easily fixed, the second one not so much. I'm
prototyping two patches at the moment and sending them through tests.

> On Sun 06-11-11 20:59:28, Andy Isaacson wrote:
> > I am running 1a67a573b (3.1.0-09125 plus a small local patch) on a Core
> > i7, 8 GB RAM, writing a few GB of data to a slow SD card attached via
> > usb-storage with vfat.  I mounted without specifying any options,
> > 
> > /dev/sdb1 /mnt/usb vfat rw,nosuid,nodev,noexec,relatime,uid=22448,gid=22448,fmask=0022,dmask=0022,codepage=cp437,iocharset=utf8,shortname=mixed,errors=remount-ro 0 0
> > 
> > and I'm using rsync to write the data.
> > 

Sounds similar to the cases I'm hearing about - copying from NFS to USB
with applications freezing where disabling transparent hugepages
sometimes helps.

> > We end up in a fairly steady state with a half GB dirty:
> > 
> > Dirty:            612280 kB
> > 
> > The dirty count stays high despite running sync(1) in another xterm.
> > 
> > The bug is,
> > 
> > Firefox (iceweasel 7.0.1-4) hangs at random intervals.  One thread is
> > stuck in sleep_on_page
> > 
> > [<ffffffff810c50da>] sleep_on_page+0xe/0x12
> > [<ffffffff810c525b>] wait_on_page_bit+0x72/0x74
> > [<ffffffff811030f9>] migrate_pages+0x17c/0x36f
> > [<ffffffff810fa24a>] compact_zone+0x467/0x68b
> > [<ffffffff810fa6a7>] try_to_compact_pages+0x14c/0x1b3
> > [<ffffffff810cbda1>] __alloc_pages_direct_compact+0xa7/0x15a
> > [<ffffffff810cc4ec>] __alloc_pages_nodemask+0x698/0x71d
> > [<ffffffff810f89c2>] alloc_pages_vma+0xf5/0xfa
> > [<ffffffff8110683f>] do_huge_pmd_anonymous_page+0xbe/0x227
> > [<ffffffff810e2bf4>] handle_mm_fault+0x113/0x1ce
> > [<ffffffff8102fe3d>] do_page_fault+0x2d7/0x31e
> > [<ffffffff812fe535>] page_fault+0x25/0x30
> > [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > And it stays stuck there for long enough for me to find the thread and
> > attach strace.  Apparently it was stuck in
> > 
> > 1320640739.201474 munmap(0x7f5c06b00000, 2097152) = 0
> > 
> > for something between 20 and 60 seconds.
>
>   That's not nice. Apparently you are using transparent hugepages and the
> stuck application tried to allocate a hugepage. But to allocate a hugepage
> you need a physically continguous set of pages and try_to_compact_pages()
> is trying to achieve exactly that. But some of the pages that need moving
> around are stuck for a long time - likely are being submitted to your USB
> stick for writing. So all in all I'm not *that* surprised you see what you
> see.
> 

Neither am I. It matches other reports I've heard over the last week.

> > There's no reason to let a 6MB/sec high latency device lock up 600 MB of
> > dirty pages.  I'll have to wait a hundred seconds after my app exits
> > before the system will return to usability.
> > 
> > And there's no way, AFAICS, for me to work around this behavior in
> > userland.
>
>   There is - you can use /sys/block/<device>/bdi/max_ratio to tune how much
> of dirty cache that device can take. Dirty cache is set to 20% of your
> total memory by default so that amounts to ~1.6 GB. So if you tune
> max_ratio to say 5, you will get at most 80 MB of dirty pages agains your
> USB stick which should be about appropriate. You can even create a udev
> rule so that when an USB stick is inserted, it automatically sets
> max_ratio for it to 5...
> 

This kinda hacks around the problem although it should work.

You should also be able to "workaround" the problem by disabling
transparet hugepages.

Finally, can you give this patch a whirl? It's a bit rough and ready
and I'm trying to see a cleaner way of allowing khugepaged to use
sync compaction on CONFIG_NUMA but I'd be interesting in confirming
it's the right direction. I have tested it sortof but not against
mainline. In my tests though I found that time spend stalled in
compaction was reduced by 47 seconds during a test lasting 30 minutes.
There is a drop in the number of transparent hugepages used but it's
minor and could be within the noise as khugepaged is still able to
use sync compaction.

==== CUT HERE ====
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 3a76faf..e2fbfee 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -328,18 +328,22 @@ alloc_pages(gfp_t gfp_mask, unsigned int order)
 }
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
-			int node);
+			int node, bool drop_mmapsem);
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
-#define alloc_pages_vma(gfp_mask, order, vma, addr, node)	\
-	alloc_pages(gfp_mask, order)
+#define alloc_pages_vma(gfp_mask, order, vma, addr, node, drop_mmapsem)	\
+	({ 								\
+		if (drop_mmapsem)					\
+			up_read(&vma->vm_mm->mmap_sem);			\
+		alloc_pages(gfp_mask, order);				\
+	})
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id())
+	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id(), false)
 #define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
-	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
+	alloc_pages_vma(gfp_mask, 0, vma, addr, node, false)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3a93f73..d5e7132 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -154,7 +154,7 @@ __alloc_zeroed_user_highpage(gfp_t movableflags,
 			unsigned long vaddr)
 {
 	struct page *page = alloc_page_vma(GFP_HIGHUSER | movableflags,
-			vma, vaddr);
+			vma, vaddr, false);
 
 	if (page)
 		clear_user_highpage(page, vaddr);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e2d1587..49449ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -655,10 +655,11 @@ static inline gfp_t alloc_hugepage_gfpmask(int defrag, gfp_t extra_gfp)
 static inline struct page *alloc_hugepage_vma(int defrag,
 					      struct vm_area_struct *vma,
 					      unsigned long haddr, int nd,
-					      gfp_t extra_gfp)
+					      gfp_t extra_gfp,
+					      bool drop_mmapsem)
 {
 	return alloc_pages_vma(alloc_hugepage_gfpmask(defrag, extra_gfp),
-			       HPAGE_PMD_ORDER, vma, haddr, nd);
+			       HPAGE_PMD_ORDER, vma, haddr, nd, drop_mmapsem);
 }
 
 #ifndef CONFIG_NUMA
@@ -683,7 +684,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					  vma, haddr, numa_node_id(), 0);
+					  vma, haddr, numa_node_id(), 0, false);
 		if (unlikely(!page)) {
 			count_vm_event(THP_FAULT_FALLBACK);
 			goto out;
@@ -911,7 +912,7 @@ int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
 		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
-					      vma, haddr, numa_node_id(), 0);
+					      vma, haddr, numa_node_id(), 0, false);
 	else
 		new_page = NULL;
 
@@ -1783,15 +1784,14 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 * the userland I/O paths.  Allocating memory with the
 	 * mmap_sem in read mode is good idea also to allow greater
 	 * scalability.
+	 *
+	 * alloc_pages_vma drops the mmap_sem so that if the process
+	 * faults or calls mmap then khugepaged will not stall it.
+	 * The mmap_sem is taken for write later to confirm the VMA
+	 * is still valid
 	 */
 	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address,
-				      node, __GFP_OTHER_NODE);
-
-	/*
-	 * After allocating the hugepage, release the mmap_sem read lock in
-	 * preparation for taking it in write mode.
-	 */
-	up_read(&mm->mmap_sem);
+				      node, __GFP_OTHER_NODE, true);
 	if (unlikely(!new_page)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		*hpage = ERR_PTR(-ENOMEM);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9c51f9f..1a8c676 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1832,7 +1832,7 @@ static struct page *alloc_page_interleave(gfp_t gfp, unsigned order,
  */
 struct page *
 alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
-		unsigned long addr, int node)
+		unsigned long addr, int node, bool drop_mmapsem)
 {
 	struct mempolicy *pol = get_vma_policy(current, vma, addr);
 	struct zonelist *zl;
@@ -1844,16 +1844,21 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT + order);
 		mpol_cond_put(pol);
+		if (drop_mmapsem)
+			up_read(&vma->vm_mm->mmap_sem);
 		page = alloc_page_interleave(gfp, order, nid);
 		put_mems_allowed();
 		return page;
 	}
 	zl = policy_zonelist(gfp, pol, node);
 	if (unlikely(mpol_needs_cond_ref(pol))) {
+		struct page *page;
 		/*
 		 * slow path: ref counted shared policy
 		 */
-		struct page *page =  __alloc_pages_nodemask(gfp, order,
+		if (drop_mmapsem)
+			up_read(&vma->vm_mm->mmap_sem);
+		page =  __alloc_pages_nodemask(gfp, order,
 						zl, policy_nodemask(gfp, pol));
 		__mpol_put(pol);
 		put_mems_allowed();
@@ -1862,6 +1867,8 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
 	/*
 	 * fast path:  default or task policy
 	 */
+	if (drop_mmapsem)
+		up_read(&vma->vm_mm->mmap_sem);
 	page = __alloc_pages_nodemask(gfp, order, zl,
 				      policy_nodemask(gfp, pol));
 	put_mems_allowed();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6e8ecb6..2f87f92 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2161,7 +2161,16 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-	sync_migration = true;
+
+	/*
+	 * Do not use sync migration for processes allocating transparent
+	 * hugepages as it could stall writing back pages which is far worse
+	 * than simply failing to promote a page. We still allow khugepaged
+	 * to allocate as it should drop the mmap_sem before trying to
+	 * allocate the page so it's acceptable for it to stall
+	 */
+	sync_migration = (current->flags & PF_KTHREAD) ||
+			 !(gfp_mask & __GFP_NO_KSWAPD);
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
