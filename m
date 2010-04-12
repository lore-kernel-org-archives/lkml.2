Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab0DLU2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 16:28:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383Ab0DLU2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 16:28:00 -0400
Date: Mon, 12 Apr 2010 13:22:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH 1/4] Simplify and comment on anon_vma re-use for
 anon_vma_prepare()
In-Reply-To: <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004121320390.3683@i5.linux-foundation.org>
References: <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org> <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
 <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <4BC36916.3080005@redhat.com>
 <20100412190002.GA8595@a1.tnic> <alpine.LFD.2.00.1004121201480.3714@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Apr 2010 10:36:19 -0700
Subject: [PATCH 1/4] Simplify and comment on anon_vma re-use for anon_vma_prepare()

This changes the anon_vma reuse case to require that we only reuse
simple anon_vma's - ie the case when the vma only has a single anon_vma
associated with it.

This means that a reuse of an anon_vma from an adjacent vma will always
guarantee that both vma's are associated not onyl with the same
anon_vma, they will also have the same anon_vma chain (of just a single
entry in this case).

And since anon_vma re-use was the only case where the same anon_vma
might be associated with different chains of anon_vma's, we now have the
case that every vma that shares the same vma will always also have the
same chain.  That makes it much easier to think about merging vma's that
share the same anon_vma's: you can always just drop the other anon_vma
chain in anon_vma_merge() since you know that they are always identical.

This also splits up the function to validate the anon_vma re-use, and
adds a lot of commentary about the possible races.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Ok, so I'm sending out this series of four patches, in the (perhaps 
futile) hope that they will finally fix the problem that Borislav has been 
so great at reporting.

I'd like to gather ack's, nak's and perhaps changelog improvement 
suggestions while doing this.

 mm/mmap.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 62 insertions(+), 24 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 75557c6..acb023e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -825,6 +825,61 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 }
 
 /*
+ * Rough compatbility check to quickly see if it's even worth looking
+ * at sharing an anon_vma.
+ *
+ * They need to have the same vm_file, and the flags can only differ
+ * in things that mprotect may change.
+ *
+ * NOTE! The fact that we share an anon_vma doesn't _have_ to mean that
+ * we can merge the two vma's. For example, we refuse to merge a vma if
+ * there is a vm_ops->close() function, because that indicates that the
+ * driver is doing some kind of reference counting. But that doesn't
+ * really matter for the anon_vma sharing case.
+ */
+static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *b)
+{
+	return a->vm_end == b->vm_start &&
+		mpol_equal(vma_policy(a), vma_policy(b)) &&
+		a->vm_file == b->vm_file &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC)) &&
+		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
+}
+
+/*
+ * Do some basic sanity checking to see if we can re-use the anon_vma
+ * from 'old'. The 'a'/'b' vma's are in VM order - one of them will be
+ * the same as 'old', the other will be the new one that is trying
+ * to share the anon_vma.
+ *
+ * NOTE! This runs with mm_sem held for reading, so it is possible that
+ * the anon_vma of 'old' is concurrently in the process of being set up
+ * by another page fault trying to merge _that_. But that's ok: if it
+ * is being set up, that automatically means that it will be a singleton
+ * acceptable for merging, so we can do all of this optimistically. But
+ * we do that ACCESS_ONCE() to make sure that we never re-load the pointer.
+ *
+ * IOW: that the "list_is_singular()" test on the anon_vma_chain only
+ * matters for the 'stable anon_vma' case (ie the thing we want to avoid
+ * is to return an anon_vma that is "complex" due to having gone through
+ * a fork).
+ *
+ * We also make sure that the two vma's are compatible (adjacent,
+ * and with the same memory policies). That's all stable, even with just
+ * a read lock on the mm_sem.
+ */
+static struct anon_vma *reusable_anon_vma(struct vm_area_struct *old, struct vm_area_struct *a, struct vm_area_struct *b)
+{
+	if (anon_vma_compatible(a, b)) {
+		struct anon_vma *anon_vma = ACCESS_ONCE(old->anon_vma);
+
+		if (anon_vma && list_is_singular(&old->anon_vma_chain))
+			return anon_vma;
+	}
+	return NULL;
+}
+
+/*
  * find_mergeable_anon_vma is used by anon_vma_prepare, to check
  * neighbouring vmas for a suitable anon_vma, before it goes off
  * to allocate a new anon_vma.  It checks because a repetitive
@@ -834,28 +889,16 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
  */
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 {
+	struct anon_vma *anon_vma;
 	struct vm_area_struct *near;
-	unsigned long vm_flags;
 
 	near = vma->vm_next;
 	if (!near)
 		goto try_prev;
 
-	/*
-	 * Since only mprotect tries to remerge vmas, match flags
-	 * which might be mprotected into each other later on.
-	 * Neither mlock nor madvise tries to remerge at present,
-	 * so leave their flags as obstructing a merge.
-	 */
-	vm_flags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
-	vm_flags |= near->vm_flags & (VM_READ|VM_WRITE|VM_EXEC);
-
-	if (near->anon_vma && vma->vm_end == near->vm_start &&
- 			mpol_equal(vma_policy(vma), vma_policy(near)) &&
-			can_vma_merge_before(near, vm_flags,
-				NULL, vma->vm_file, vma->vm_pgoff +
-				((vma->vm_end - vma->vm_start) >> PAGE_SHIFT)))
-		return near->anon_vma;
+	anon_vma = reusable_anon_vma(near, vma, near);
+	if (anon_vma)
+		return anon_vma;
 try_prev:
 	/*
 	 * It is potentially slow to have to call find_vma_prev here.
@@ -868,14 +911,9 @@ try_prev:
 	if (!near)
 		goto none;
 
-	vm_flags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
-	vm_flags |= near->vm_flags & (VM_READ|VM_WRITE|VM_EXEC);
-
-	if (near->anon_vma && near->vm_end == vma->vm_start &&
-  			mpol_equal(vma_policy(near), vma_policy(vma)) &&
-			can_vma_merge_after(near, vm_flags,
-				NULL, vma->vm_file, vma->vm_pgoff))
-		return near->anon_vma;
+	anon_vma = reusable_anon_vma(near, near, vma);
+	if (anon_vma)
+		return anon_vma;
 none:
 	/*
 	 * There's no absolute need to look only at touching neighbours:
-- 
1.7.1.rc1.dirty

