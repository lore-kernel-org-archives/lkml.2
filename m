Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab2CFS6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:58:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab2CFS6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:58:13 -0500
Date: Tue, 6 Mar 2012 13:57:17 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bug introduced in "mm: simplify find_vma_prev()"
In-Reply-To: <CA+55aFzX9Nj_jSdFR6PJO-G4MPi7R13TLHAxwzZo9C0MHNRBfw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1203061326120.22195@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com>
 <CA+55aFzX9Nj_jSdFR6PJO-G4MPi7R13TLHAxwzZo9C0MHNRBfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Mar 2012, Linus Torvalds wrote:

> On Sun, Mar 4, 2012 at 4:52 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > This patch fixes a bug introduced in "mm: simplify find_vma_prev()". You
> > can apply this, or alternatively revert the original patch.
> 
> Hmm.
> 
> I realize the patch is a bug-fix, but I do wonder if we shouldn't look
> at alternatives.
> 
> In particular, how about we just change the rule to be clearer, and
> make the rule be:
> 
>  - no more find_vma_prev() AT ALL.
> 
>  - callers get turned into "find_vma()" and then we have a
> "vma_prev()", which basically does your thing.
> 
>  - many of the callers seem to be interested in "prev" *only* if they
> found a vma. For example, the do_mlock() kind of logic seems to be
> common:
> 
>     vma = find_vma_prev(current->mm, start, &prev);
>     if (!vma || vma->vm_start > start)
>         return -ENOMEM;
> 
>    which implies that the current find_vma_prev() semantics are really
> wrong, because they force us to do extra work in this case where we
> really really don't care about the result.
> 
> So we could do an entirely mechanical conversion of
> 
>    vma = find_vma_prev(mm, address, &prev_vma);
> 
> into
> 
>    vma = find_vma(mm, address);
>    prev_vma = vma_prev(vma);
> 
> and then after we've done that conversion, it looks like the bulk of
> them will not care about "prev_vma" if vma is NULL, so they can then
> be replaced with a pure
> 
>    prev_vma = vma->vm_prev;
> 
> instead. Leaving just the (few) cases that may care about the
> "previous vma may be the last vma of the VM" case.
> 
> Hmm? And we'd get away from that horrible "find_vma_prev()" interface
> that uses pointers to vma pointers for return values. Ugh. There only
> seems to be nine callers in the whole kernel.
> 
>                  Linus

You can try this to remove most users of find_vma_prev (only three are 
left --- those dealing with up-growing stack). But the patch should be 
delayed until the next merge window.

Mikulas

---

mm: don't use find_vma_prev

Convert find_vma_prev callers to use find_vma. As we have vma->vm_prev field,
we no longer need to use find_vma_prev, we can use find_vma instead.

find_vma_prev is used only in cases where address may be above all existing
vmas and we need the last vma (it is returned in pprev pointer).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 arch/tile/mm/hugetlbpage.c |    4 +++-
 arch/x86/mm/hugetlbpage.c  |    4 +++-
 mm/madvise.c               |   10 +++++++---
 mm/mempolicy.c             |    4 +++-
 mm/mlock.c                 |    4 +++-
 mm/mprotect.c              |    4 +++-
 6 files changed, 22 insertions(+), 8 deletions(-)

Index: linux-3.3-rc6-fast/arch/tile/mm/hugetlbpage.c
===================================================================
--- linux-3.3-rc6-fast.orig/arch/tile/mm/hugetlbpage.c	2012-03-06 19:04:45.000000000 +0100
+++ linux-3.3-rc6-fast/arch/tile/mm/hugetlbpage.c	2012-03-06 19:05:05.000000000 +0100
@@ -226,12 +226,14 @@ try_again:
 		 * Lookup failure means no vma is above this address,
 		 * i.e. return with success:
 		 */
-		vma = find_vma_prev(mm, addr, &prev_vma);
+		vma = find_vma(mm, addr);
 		if (!vma) {
 			return addr;
 			break;
 		}
 
+		prev_vma = vma->vm_prev;
+
 		/*
 		 * new region fits between prev_vma->vm_end and
 		 * vma->vm_start, use it:
Index: linux-3.3-rc6-fast/arch/x86/mm/hugetlbpage.c
===================================================================
--- linux-3.3-rc6-fast.orig/arch/x86/mm/hugetlbpage.c	2012-03-06 19:02:56.000000000 +0100
+++ linux-3.3-rc6-fast/arch/x86/mm/hugetlbpage.c	2012-03-06 19:04:10.000000000 +0100
@@ -333,9 +333,11 @@ try_again:
 		 * Lookup failure means no vma is above this address,
 		 * i.e. return with success:
 		 */
-		if (!(vma = find_vma_prev(mm, addr, &prev_vma)))
+		if (!(vma = find_vma(mm, addr)))
 			return addr;
 
+		prev_vma = vma->vm_prev;
+
 		/*
 		 * new region fits between prev_vma->vm_end and
 		 * vma->vm_start, use it:
Index: linux-3.3-rc6-fast/mm/madvise.c
===================================================================
--- linux-3.3-rc6-fast.orig/mm/madvise.c	2012-03-06 19:06:04.000000000 +0100
+++ linux-3.3-rc6-fast/mm/madvise.c	2012-03-06 19:07:21.000000000 +0100
@@ -385,9 +385,13 @@ SYSCALL_DEFINE3(madvise, unsigned long, 
 	 * ranges, just ignore them, but return -ENOMEM at the end.
 	 * - different from the way of handling in mlock etc.
 	 */
-	vma = find_vma_prev(current->mm, start, &prev);
-	if (vma && start > vma->vm_start)
-		prev = vma;
+	vma = find_vma(current->mm, start);
+	if (vma) {
+		if (start > vma->vm_start)
+			prev = vma;
+		else
+			prev = vma->vm_prev;
+	}
 
 	for (;;) {
 		/* Still start < end. */
Index: linux-3.3-rc6-fast/mm/mempolicy.c
===================================================================
--- linux-3.3-rc6-fast.orig/mm/mempolicy.c	2012-03-06 19:05:38.000000000 +0100
+++ linux-3.3-rc6-fast/mm/mempolicy.c	2012-03-06 19:05:58.000000000 +0100
@@ -640,10 +640,12 @@ static int mbind_range(struct mm_struct 
 	unsigned long vmstart;
 	unsigned long vmend;
 
-	vma = find_vma_prev(mm, start, &prev);
+	vma = find_vma(mm, start);
 	if (!vma || vma->vm_start > start)
 		return -EFAULT;
 
+	prev = vma->vm_prev;
+
 	if (start > vma->vm_start)
 		prev = vma;
 
Index: linux-3.3-rc6-fast/mm/mlock.c
===================================================================
--- linux-3.3-rc6-fast.orig/mm/mlock.c	2012-03-06 19:07:27.000000000 +0100
+++ linux-3.3-rc6-fast/mm/mlock.c	2012-03-06 19:07:50.000000000 +0100
@@ -385,12 +385,14 @@ static int do_mlock(unsigned long start,
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	vma = find_vma_prev(current->mm, start, &prev);
+	vma = find_vma(current->mm, start);
 	if (!vma || vma->vm_start > start)
 		return -ENOMEM;
 
 	if (start > vma->vm_start)
 		prev = vma;
+	else
+		prev = vma->vm_prev;
 
 	for (nstart = start ; ; ) {
 		vm_flags_t newflags;
Index: linux-3.3-rc6-fast/mm/mprotect.c
===================================================================
--- linux-3.3-rc6-fast.orig/mm/mprotect.c	2012-03-06 19:07:57.000000000 +0100
+++ linux-3.3-rc6-fast/mm/mprotect.c	2012-03-06 19:08:37.000000000 +0100
@@ -262,7 +262,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 
 	down_write(&current->mm->mmap_sem);
 
-	vma = find_vma_prev(current->mm, start, &prev);
+	vma = find_vma(current->mm, start);
 	error = -ENOMEM;
 	if (!vma)
 		goto out;
@@ -286,6 +286,8 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 	}
 	if (start > vma->vm_start)
 		prev = vma;
+	else
+		prev = vma->vm_prev;
 
 	for (nstart = start ; ; ) {
 		unsigned long newflags;
