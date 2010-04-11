Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0DKNYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 09:24:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37831 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab0DKNYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 09:24:11 -0400
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH 2/3] mm: cleanup find_mergeable_anon_vma complexity
Date: Sun, 11 Apr 2010 15:19:57 +0200
Message-Id: <1270991999-4004-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1270991999-4004-1-git-send-email-bp@alien8.de>
References: <1270991999-4004-1-git-send-email-bp@alien8.de>
In-Reply-To: <20100411130801.GA7189@a1.tnic>
References: <20100411130801.GA7189@a1.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

On Sat, 10 Apr 2010, Linus Torvalds wrote:
>
> But I think the fact that you are apparently not able to get the list
> corruption is a good sign. Of course, it might just be harder to trigger,
> and these things could all be a sign of a different bug, but my gut feel
> is that we did fix something, and you are just damn good at stressing the
> new code. Kudos.

Btw, I do hate the current 'find_mergeable_anon_vma()' with its duplicated
checks for prev/next compatibility that I just made even more complex.

So I'm actually inclined to want to write my simple two-liner fix as a
rather more complex cleanup patch, below.

It adds way more lines than it deletes, but a lot of it is comments (and
some of it is just because one routine got split up into three), and I
think it makes the result a lot more readable.

It also splits off the decision of whether we can reuse an non_vma from
the decision of whether we can merge the vma's - the two are kind of
related, but they are not really the same, and they have different issues.
I think it's good to try to keep separate issues separate.

This is UNTESTED! It's meant to be an "obvious cleanup" with no real
semantic difference, but if I did something wrong it won't work. Also note
the comment about the lack of locking between two adjacent anon_vma's
taking a page fault at the same time: the ACCESS_ONCE() is unlikely to
ever matter (anon_vma's are stable once they are set, so it's really just
that you could first load a NULL, and then if you re-load the value you
might get a non-NULL thing).

Also note that when checking whether the anon_vma is a singleton, we don't
hold any lock that protects the list we are checking. But
"list_is_singular()" is safe and won't oops even if the pointers in the
list are crap, because it only _compares_ the prev/next pointers, it
doesn't dereference them.

In short, what I'm saying is that there is a pretty subtle race in the
very very unlikely case that two anon_vma's get prepared concurrently, but
from a correctness standpoint it doesn't matter. We might sometimes - once
in a blue moon - reject an anon_vma that could in theory have been merged,
but that won't hurt.

Comments? Rik, Johannes?

			Linus
---
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
1.7.0.3

