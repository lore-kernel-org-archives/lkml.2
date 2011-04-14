Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1DNVPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:15:38 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:53648 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1DNVPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:15:37 -0400
Date: Thu, 14 Apr 2011 17:14:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm/vmalloc: remove guard page from between vmap blocks
Message-ID: <20110414211441.GA1700@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmap allocator is used to, among other things, allocate per-cpu
vmap blocks, where each vmap block is naturally aligned to its own
size.  Obviously, leaving a guard page after each vmap area forbids
packing vmap blocks efficiently and can make the kernel run out of
possible vmap blocks long before overall vmap space is exhausted.

The new interface to map a user-supplied page array into linear
vmalloc space (vm_map_ram) insists on allocating from a vmap block
(instead of falling back to a custom area) when the area size is below
a certain threshold.  With heavy users of this interface (e.g. XFS)
and limited vmalloc space on 32-bit, vmap block exhaustion is a real
problem.

Remove the guard page from the core vmap allocator.  vmalloc and the
old vmap interface enforce a guard page on their own at a higher
level.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
 mm/vmalloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Note that without this patch, we had accidental guard pages after
those vm_map_ram areas that happened to be at the end of a vmap block,
but not between every area.  This patch removes this accidental guard
page only.

If we want guard pages after every vm_map_ram area, this should be
done separately.  And just like with vmalloc and the old interface on
a different level, not in the core allocator.

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index cbd9f9f..5d8666b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -307,7 +307,7 @@ nocache:
 	/* find starting point for our search */
 	if (free_vmap_cache) {
 		first = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
-		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		addr = ALIGN(first->va_end, align);
 		if (addr < vstart)
 			goto nocache;
 		if (addr + size - 1 < addr)
@@ -338,10 +338,10 @@ nocache:
 	}
 
 	/* from the starting point, walk areas until a suitable hole is found */
-	while (addr + size >= first->va_start && addr + size <= vend) {
+	while (addr + size > first->va_start && addr + size <= vend) {
 		if (addr + cached_hole_size < first->va_start)
 			cached_hole_size = first->va_start - addr;
-		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		addr = ALIGN(first->va_end, align);
 		if (addr + size - 1 < addr)
 			goto overflow;
 
-- 
1.7.4

