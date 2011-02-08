Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1BHEar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:30:47 -0500
Received: from smtp-out.google.com ([74.125.121.67]:47387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1BHEaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=n8Gl9PpWWu8uhPsCcDo0OiwdklmYH9E52kbZdFKFXJLJSuW26i9Mz4edTRdfDiZ2rC
         IvTccvlKXlt/XR8cuGHg==
Date: Mon, 7 Feb 2011 20:30:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "J.H." <warthog9@kernel.org>
cc: linux-kernel@vger.kernel.org, hpa@kernel.org, dgc@kernel.org,
        elder@kernel.org, hch@kernel.org, akpm@linux-foundation.org,
        npiggin@kernel.dk
Subject: Re: do_raw_spin_lock using a lot of the system cpu time
In-Reply-To: <4D508BDC.1020309@kernel.org>
Message-ID: <alpine.LSU.2.00.1102072010080.1600@sister.anvils>
References: <4D508BDC.1020309@kernel.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, J.H. wrote:

> Week and a half ago, all of a sudden, kernel.org's two US mirror
> machines spiked in load.  While this does happen, this particular spike
> defied what we had seen before.  Specifically the machine seems to be
> CPU bound (specifically system cpu), as opposed to our more traditional
> I/O bound scenarios.  Doing the obvious things didn't clear the problem
> up, and even trying different kernels the problem would come back almost
> immediately.
> 
> Digging even further into the problem, more or less led me in circles,
> so I've been showing this around to HPA, Dave Chinner, Alex Elder and
> Christoph Hellwig, but everyone seems as stumped as me so far.  HPA
> noted the system is acting like it's run out of memory, when that is far
> from the case (machines have 144G of ram and something like +120G of
> cache to draw memory from).
> 
> The debugging that so far is (via perf top) claims that alloc_vmap_area,
> rb_next and do_raw_spin_lock are involved in some combination, with
> do_raw_spin_lock being the item taking up 80-90% of the time that perf
> top can see.
> 
> I'm also seeing this on 3 different kernels:
> 
> 2.6.34.7-61.korg.fc13.x86_64
> 	(which is the 34.7-61 kernel + two patches, one for xfs and one
> 	 to disable IMA)
> 2.6.35.10-74.fc14.x86_64
> 2.6.38-0.rc2.git5.1.fc14.x86_64
> 
> I have sysrq t + w from the 2.6.34 kernel at
> 
> http://userweb.kernel.org/~warthog9/messages.z2.cWpmrIf7
> 
> along with additional sysrq w's at
> 
> http://userweb.kernel.org/~warthog9/dmesg.output.sysrq.w.z1-nsUCsHUs
> http://userweb.kernel.org/~warthog9/dmesg.output.sysrq.w-nsUCsHUs
> 
> output from two perf top runs:
> 
> http://userweb.kernel.org/~warthog9/perf-top-output-48UMEhyx
> 
> We've tried artificially lowering the memory on the systems, this only
> lowered the load proportionally (seemingly) to the amount of ram, but
> the base symptom that the system cpu load was still high and seemingly
> spending all of it's time in a do_raw_spin_lock.
> 
> Tried disabling HT on the off chance that had something to do with it,
> this didn't seem to affect anything.
> 
> I've added, at HCH's request, printk's at the vmalloc calls in fs/file.c
> and fs/xfs/linux-2.6/xfs_buf.c.  The former is called on occasion, but
> not seemingly enough to warrant what I'm seeing, and the later has yet
> to be called on the system with that instrumented.
> 
> I've tried running debug kernels, with
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_LOCK_STAT=y
> 
> None of which complained about the locking that was occurring.
> 
> At one point when attempting to track down what was possibly going on
> with vmalloc cat /proc/vmallocinfo actually paniced both machines, hard.
>  They were each running different kernels (2.6.35-debug and 2.6.34
> respectively for zeus1 and zeus2), and had vastly different uptimes /
> system loads / running processes, etc.
> 
> Problem seems to be noticeable even when the systems are nearly idle,
> loading up an rsync or two shoots the load up a *LOT* more than it has
> in the past, with the system going from a load of near 0 with no rscyncs
> to a load of 5-10 with 1-2 rsyncs running, and that load seems to be
> coming from the system cpu usage.  (it was in the past not uncommon to
> see 40-50 rsyncs running in various states and the load be under 5)
> 
> I've hit a brick wall, and I haven't been able to figure out what's
> going on with the boxes.  Traffic / usage patterns have not increased,
> but almost instantly loads went up dramatically.  I've already tried a
> full OS upgrade on one machine, which didn't help, and I'm going to try
> changing the primary filesystem to see what happens, but I'm guessing
> I'm only going to rule out a specific code path as being the cause.
> 
> Does anyone have any suggestions on what's going on?  Like I said I've
> hit a brick wall and whatever is going on is making the boxes a lot less
> usable than they should be...
> 
> - John 'Warthog9' Hawley
> 
> Additional background:
> 
> Boxes in question are a DL380 G7 and DL380 G6 respectively, the former
> with a pair of E5640 processors, 144G of RAM.  The later has a pair of
> X5550 processors and 144G of ram.  They share identical storage
> configurations, comprising two P812 raid cards and a smaller 410i (the
> G7's is onboard, the G6's is a separate add-on card)


There's a patch from Nick in mmotm (languishing there since May, because
of a bug which I then hit and fixed a month ago), which might make a big
difference here - it showed 10x speedup on some simple tests.

I hesitate to recommend it to you: so far as I know, Nick hasn't had a
moment to retest since I fiddled with it; and besides, it might in your
case just be papering over a more serious issue - I'm quite unsure.

So, please don't apply without taking a second opinion, but here it
is below (I've not checked if it applies cleanly to all your kernels).

Hugh

From: Nick Piggin <npiggin@suse.de>

Provide a free area cache for the vmalloc virtual address allocator, based
on the algorithm used by the user virtual memory allocator.

This reduces the number of rbtree operations and linear traversals over
the vmap extents in order to find a free area, by starting off at the last
point that a free area was found.

The free area cache is reset if areas are freed behind it, or if we are
searching for a smaller area or alignment than last time.  So allocation
patterns are not changed (verified by corner-case and random test cases in
userspace testing).

This solves a regression caused by lazy vunmap TLB purging introduced in
db64fe02 (mm: rewrite vmap layer).  That patch will leave extents in the
vmap allocator after they are vunmapped, and until a significant number
accumulate that can be flushed in a single batch.  So in a workload that
vmalloc/vfree frequently, a chain of extents will build up from
VMALLOC_START address, which have to be iterated over each time (giving an
O(n) type of behaviour).

After this patch, the search will start from where it left off, giving
closer to an amortized O(1).

This is verified to solve regressions reported Steven in GFS2, and Avi in
KVM.

Hugh's update:

: I tried out the recent mmotm, and on one machine was fortunate to hit
: the BUG_ON(first->va_start < addr) which seems to have been stalling
: your vmap area cache patch ever since May.

: I can get you addresses etc, I did dump a few out; but once I stared
: at them, it was easier just to look at the code: and I cannot see how
: you would be so sure that first->va_start < addr, once you've done
: that addr = ALIGN(max(...), align) above, if align is over 0x1000
: (align was 0x8000 or 0x4000 in the cases I hit: ioremaps like Steve).

: I originally got around it by just changing the
: 		if (first->va_start < addr) {
: to
: 		while (first->va_start < addr) {
: without thinking about it any further; but that seemed unsatisfactory,
: why would we want to loop here when we've got another very similar
: loop just below it?

: I am never going to admit how long I've spent trying to grasp your
: "while (n)" rbtree loop just above this, the one with the peculiar
: 		if (!first && tmp->va_start < addr + size)
: in.  That's unfamiliar to me, I'm guessing it's designed to save a
: subsequent rb_next() in a few circumstances (at risk of then setting
: a wrong cached_hole_size?); but they did appear few to me, and I didn't
: feel I could sign off something with that in when I don't grasp it,
: and it seems responsible for extra code and mistaken BUG_ON below it.

: I've reverted to the familiar rbtree loop that find_vma() does (but
: with va_end >= addr as you had, to respect the additional guard page):
: and then (given that cached_hole_size starts out 0) I don't see the
: need for any complications below it.  If you do want to keep that loop
: as you had it, please add a comment to explain what it's trying to do,
: and where addr is relative to first when you emerge from it.

: Aren't your tests "size <= cached_hole_size" and
: "addr + size > first->va_start" forgetting the guard page we want
: before the next area?  I've changed those.

: I have not changed your many "addr + size - 1 < addr" overflow tests,
: but have since come to wonder, shouldn't they be "addr + size < addr"
: tests - won't the vend checks go wrong if addr + size is 0?

: I have added a few comments - Wolfgang Wander's 2.6.13 description of
: 1363c3cd8603a913a27e2995dccbd70d5312d8e6 Avoiding mmap fragmentation
: helped me a lot, perhaps a pointer to that would be good too.  And I found
: it easier to understand when I renamed cached_start slightly and moved the
: overflow label down.

: This patch would go after your mm-vmap-area-cache.patch in mmotm. 
: Trivially, nobody is going to get that BUG_ON with this patch, and it
: appears to work fine on my machines; but I have not given it anything like
: the testing you did on your original, and may have broken all the
: performance you were aiming for.  Please take a look and test it out
: integrate with yours if you're satisfied - thanks.

[akpm@linux-foundation.org: add locking comment]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reported-and-tested-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-and-tested-by: Avi Kivity <avi@redhat.com>
Tested-by: "Barry J. Marson" <bmarson@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |  156 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 104 insertions(+), 52 deletions(-)

diff -puN mm/vmalloc.c~mm-vmap-area-cache mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmap-area-cache
+++ a/mm/vmalloc.c
@@ -261,8 +261,15 @@ struct vmap_area {
 };
 
 static DEFINE_SPINLOCK(vmap_area_lock);
-static struct rb_root vmap_area_root = RB_ROOT;
 static LIST_HEAD(vmap_area_list);
+static struct rb_root vmap_area_root = RB_ROOT;
+
+/* The vmap cache globals are protected by vmap_area_lock */
+static struct rb_node *free_vmap_cache;
+static unsigned long cached_hole_size;
+static unsigned long cached_vstart;
+static unsigned long cached_align;
+
 static unsigned long vmap_area_pcpu_hole;
 
 static struct vmap_area *__find_vmap_area(unsigned long addr)
@@ -331,9 +338,11 @@ static struct vmap_area *alloc_vmap_area
 	struct rb_node *n;
 	unsigned long addr;
 	int purged = 0;
+	struct vmap_area *first;
 
 	BUG_ON(!size);
 	BUG_ON(size & ~PAGE_MASK);
+	BUG_ON(!is_power_of_2(align));
 
 	va = kmalloc_node(sizeof(struct vmap_area),
 			gfp_mask & GFP_RECLAIM_MASK, node);
@@ -341,79 +350,106 @@ static struct vmap_area *alloc_vmap_area
 		return ERR_PTR(-ENOMEM);
 
 retry:
-	addr = ALIGN(vstart, align);
-
 	spin_lock(&vmap_area_lock);
-	if (addr + size - 1 < addr)
-		goto overflow;
+	/*
+	 * Invalidate cache if we have more permissive parameters.
+	 * cached_hole_size notes the largest hole noticed _below_
+	 * the vmap_area cached in free_vmap_cache: if size fits
+	 * into that hole, we want to scan from vstart to reuse
+	 * the hole instead of allocating above free_vmap_cache.
+	 * Note that __free_vmap_area may update free_vmap_cache
+	 * without updating cached_hole_size or cached_align.
+	 */
+	if (!free_vmap_cache ||
+			size < cached_hole_size ||
+			vstart < cached_vstart ||
+			align < cached_align) {
+nocache:
+		cached_hole_size = 0;
+		free_vmap_cache = NULL;
+	}
+	/* record if we encounter less permissive parameters */
+	cached_vstart = vstart;
+	cached_align = align;
+
+	/* find starting point for our search */
+	if (free_vmap_cache) {
+		first = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
+		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		if (addr < vstart)
+			goto nocache;
+		if (addr + size - 1 < addr)
+			goto overflow;
+
+	} else {
+		addr = ALIGN(vstart, align);
+		if (addr + size - 1 < addr)
+			goto overflow;
 
-	/* XXX: could have a last_hole cache */
-	n = vmap_area_root.rb_node;
-	if (n) {
-		struct vmap_area *first = NULL;
+		n = vmap_area_root.rb_node;
+		first = NULL;
 
-		do {
+		while (n) {
 			struct vmap_area *tmp;
 			tmp = rb_entry(n, struct vmap_area, rb_node);
 			if (tmp->va_end >= addr) {
-				if (!first && tmp->va_start < addr + size)
-					first = tmp;
-				n = n->rb_left;
-			} else {
 				first = tmp;
+				if (tmp->va_start <= addr)
+					break;
+				n = n->rb_left;
+			} else
 				n = n->rb_right;
-			}
-		} while (n);
+		}
 
 		if (!first)
 			goto found;
-
-		if (first->va_end < addr) {
-			n = rb_next(&first->rb_node);
-			if (n)
-				first = rb_entry(n, struct vmap_area, rb_node);
-			else
-				goto found;
-		}
-
-		while (addr + size > first->va_start && addr + size <= vend) {
-			addr = ALIGN(first->va_end + PAGE_SIZE, align);
-			if (addr + size - 1 < addr)
-				goto overflow;
-
-			n = rb_next(&first->rb_node);
-			if (n)
-				first = rb_entry(n, struct vmap_area, rb_node);
-			else
-				goto found;
-		}
 	}
-found:
-	if (addr + size > vend) {
-overflow:
-		spin_unlock(&vmap_area_lock);
-		if (!purged) {
-			purge_vmap_area_lazy();
-			purged = 1;
-			goto retry;
-		}
-		if (printk_ratelimit())
-			printk(KERN_WARNING
-				"vmap allocation for size %lu failed: "
-				"use vmalloc=<size> to increase size.\n", size);
-		kfree(va);
-		return ERR_PTR(-EBUSY);
+
+	/* from the starting point, walk areas until a suitable hole is found */
+	while (addr + size >= first->va_start && addr + size <= vend) {
+		if (addr + cached_hole_size < first->va_start)
+			cached_hole_size = first->va_start - addr;
+		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		if (addr + size - 1 < addr)
+			goto overflow;
+
+		n = rb_next(&first->rb_node);
+		if (n)
+			first = rb_entry(n, struct vmap_area, rb_node);
+		else
+			goto found;
 	}
 
-	BUG_ON(addr & (align-1));
+found:
+	if (addr + size > vend)
+		goto overflow;
 
 	va->va_start = addr;
 	va->va_end = addr + size;
 	va->flags = 0;
 	__insert_vmap_area(va);
+	free_vmap_cache = &va->rb_node;
 	spin_unlock(&vmap_area_lock);
 
+	BUG_ON(va->va_start & (align-1));
+	BUG_ON(va->va_start < vstart);
+	BUG_ON(va->va_end > vend);
+
 	return va;
+
+overflow:
+	spin_unlock(&vmap_area_lock);
+	if (!purged) {
+		purge_vmap_area_lazy();
+		purged = 1;
+		goto retry;
+	}
+	if (printk_ratelimit())
+		printk(KERN_WARNING
+			"vmap allocation for size %lu failed: "
+			"use vmalloc=<size> to increase size.\n", size);
+	kfree(va);
+	return ERR_PTR(-EBUSY);
 }
 
 static void rcu_free_va(struct rcu_head *head)
@@ -426,6 +462,22 @@ static void rcu_free_va(struct rcu_head 
 static void __free_vmap_area(struct vmap_area *va)
 {
 	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
+
+	if (free_vmap_cache) {
+		if (va->va_end < cached_vstart) {
+			free_vmap_cache = NULL;
+		} else {
+			struct vmap_area *cache;
+			cache = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
+			if (va->va_start <= cache->va_start) {
+				free_vmap_cache = rb_prev(&va->rb_node);
+				/*
+				 * We don't try to update cached_hole_size or
+				 * cached_align, but it won't go very wrong.
+				 */
+			}
+		}
+	}
 	rb_erase(&va->rb_node, &vmap_area_root);
 	RB_CLEAR_NODE(&va->rb_node);
 	list_del_rcu(&va->list);
_
