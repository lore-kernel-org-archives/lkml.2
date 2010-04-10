Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0DJUKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 16:10:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab0DJUKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 16:10:09 -0400
Date: Sat, 10 Apr 2010 13:05:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100410185839.GA32035@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org> <20100410003110.GI28964@cmpxchg.org> <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org> <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org> <20100410163828.GA25579@a1.tnic> <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic>
 <20100410185839.GA32035@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Apr 2010, Borislav Petkov wrote:
> From: Borislav Petkov <bp@alien8.de>
> Date: Sat, Apr 10, 2010 at 08:51:45PM +0200
> 
> > Anyways, testing...
> 
> Nope, still b0rked. And this time is not a funny pattern but
> ffffffffffffffe0 we had originally.

Ok, I think that just depends on who happens to re-use the allocation and 
how it does it.

I'm pretty sure it's a use-after-free issue, where we have free'd an 
anon_vma too early, even though it has pages associated with it.

If it wasn't the RCU case, it's just something else.

I think it's worth looking at "vma_adjust()", because as I already 
mentioned to Rik earlier - the code is very hard to understand, and it's 
accrued crud over many many years.

And vma_adjust is the one place that does that anon_vma_merge(), which is 
apart from the actual unmapping sequence the only other place that 
actually free's anon_vmas. So there are reasons to be very suspicious of 
that code.

And I think that code can actually lose an anon_vma chain. It's totally 
screwing up the "import anonvma" case: when it does

                        if (anon_vma_clone(importer, vma)) {
                                return -ENOMEM;
                        }
                        importer->anon_vma = anon_vma;

we can actually have "importer == vma", but "anon_vma = next->anon_vma". 

In which case we actually end up with an _empty_ chain (because importer 
didn't have a chain to begin with!) but "importer->anon_vma" points to an 
anon_vma.

And then when we do that "remove_next", we actually get rid of the only 
chain we ever had, and have lost all our references to the anon_vma.

That looks _horribly_ buggy.

Also, the conditional nesting makes no sense (the whole anon_vma_clone() 
only makes sense if importer is set, and it is only ever set _inside_ the 
earlier if-statement, so the whole code should be moved inside there), nor 
does some of the comments.

This patch is scary and untested, but the more I look at that code, the 
more convinced I am that vma_adjust was _really_ badly screwed up. The 
patch below may make things worse. I'll test it myself too, but I'm 
sending it out first, since I was writing the email as I was looking at 
the piece of cr*p.

		Linus

---
 mm/mmap.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index acb023e..f90ea92 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -507,11 +507,12 @@ int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	struct address_space *mapping = NULL;
 	struct prio_tree_root *root = NULL;
 	struct file *file = vma->vm_file;
-	struct anon_vma *anon_vma = NULL;
 	long adjust_next = 0;
 	int remove_next = 0;
 
 	if (next && !insert) {
+		struct vm_area_struct *exporter = NULL;
+
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
@@ -519,7 +520,7 @@ int vma_adjust(struct vm_area_struct *vma, unsigned long start,
 			 */
 again:			remove_next = 1 + (end > next->vm_end);
 			end = next->vm_end;
-			anon_vma = next->anon_vma;
+			exporter = next;
 			importer = vma;
 		} else if (end > next->vm_start) {
 			/*
@@ -527,7 +528,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 			 * mprotect case 5 shifting the boundary up.
 			 */
 			adjust_next = (end - next->vm_start) >> PAGE_SHIFT;
-			anon_vma = next->anon_vma;
+			exporter = next;
 			importer = vma;
 		} else if (end < vma->vm_end) {
 			/*
@@ -536,28 +537,19 @@ again:			remove_next = 1 + (end > next->vm_end);
 			 * mprotect case 4 shifting the boundary down.
 			 */
 			adjust_next = - ((vma->vm_end - end) >> PAGE_SHIFT);
-			anon_vma = next->anon_vma;
+			exporter = vma;
 			importer = next;
 		}
-	}
 
-	/*
-	 * When changing only vma->vm_end, we don't really need anon_vma lock.
-	 */
-	if (vma->anon_vma && (insert || importer || start != vma->vm_start))
-		anon_vma = vma->anon_vma;
-	if (anon_vma) {
 		/*
 		 * Easily overlooked: when mprotect shifts the boundary,
 		 * make sure the expanding vma has anon_vma set if the
 		 * shrinking vma had, to cover any anon pages imported.
 		 */
-		if (importer && !importer->anon_vma) {
-			/* Block reverse map lookups until things are set up. */
-			if (anon_vma_clone(importer, vma)) {
+		if (exporter && exporter->anon_vma && !importer->anon_vma) {
+			if (anon_vma_clone(importer, exporter))
 				return -ENOMEM;
-			}
-			importer->anon_vma = anon_vma;
+			importer->anon_vma = exporter->anon_vma;
 		}
 	}
 
