Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab0DJAAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:00:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756155Ab0DJAAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:00:45 -0400
Date: Fri, 9 Apr 2010 16:56:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic>
 <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
 <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Apr 2010, Linus Torvalds wrote:
> 
> Can we have some better high-level documentation on what happens for all 
> the cases.
> 
>  - split (mprotect, or munmap in the middle):
> 
> 	anon_vma_clone: the two vma's will have the same anon_vma, and the 
> 	anon_vma chains will be equivalent. 
> 
>  - merge (mprotect that creates a mergeable state):
> 
> 	anon_vma_merge: we're supposed to have a anon_vma_chain that is 
> 	a superset of the two chains of the merged entries.
> 
>  - fork:
> 
> 	anon_vma_fork: each new vma will have a _new_ anon_vma as it's 
> 	primary one, and will link to the old primary trough the 
> 	anon_vma_chain. It's doing this with a anon_vma_clone() followed 
> 	by adding an entra entry to the new anon_vma, and setting 
> 	vma->anon_vma to the new one.
> 
>  - create/mmap:
> 
> 	anon_vma_prepare: find a mergeable anon_vma and use that as a 
> 	singleton, because the other entries on the anon_vma chain won't 
> 	matter, since they cannot be associated with any pages associated 
> 	with the newly created vma..
> 
> Correct?

Ok, so I don't know if the above is correct, but if it is, let's ignore 
the "merge" case as being complex, and look at the other cases.

With fork, the main anon_vma becomes different, so let's ignore that. That 
always means that the resulting list is not comparable or compatible, and 
we'll never mix them up.

If we make one very _simple_ rule for the create/mmap case, namely that we 
only re-use another _singleton_ anon_vma, then split and create case will 
look exactly the same. And in particular, we get a very simple and 
powerful rule: if the anon_vma matches, then the _list_ will also always 
match.

And that, in turn, would make 'merge' trivial too: you really can always 
drop the side that goes away. There's never any question about how to 
merge the lists, or which to pick, because every single operation that 
leaves the anon_vma the same will guarantee that the list will be 
identical too.

So now the simple rule is that if the anon_vma is the same, then the list 
of associated anon_vma's will always be the same - across all of merge, 
split and create.

Isn't that a _much_ simpler model to think about?

So _instead_ of all the patches that have floated about, I would suggest 
this simple change to "find_mergeable_anon_vma()" instead..

Oh, and maybe it's the meds talking again. I'm feeling better than 
yesterday, but am still a bit lightheaded. 

		Linus

---
 mm/mmap.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 75557c6..462a8ca 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -850,7 +850,8 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
 	vm_flags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
 	vm_flags |= near->vm_flags & (VM_READ|VM_WRITE|VM_EXEC);
 
-	if (near->anon_vma && vma->vm_end == near->vm_start &&
+	if (near->anon_vma && list_is_singular(&near->anon_vma_chain) &&
+			vma->vm_end == near->vm_start &&
  			mpol_equal(vma_policy(vma), vma_policy(near)) &&
 			can_vma_merge_before(near, vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff +
@@ -871,7 +872,8 @@ try_prev:
 	vm_flags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
 	vm_flags |= near->vm_flags & (VM_READ|VM_WRITE|VM_EXEC);
 
-	if (near->anon_vma && near->vm_end == vma->vm_start &&
+	if (near->anon_vma && list_is_singular(&near->anon_vma_chain) &&
+			near->vm_end == vma->vm_start &&
   			mpol_equal(vma_policy(near), vma_policy(vma)) &&
 			can_vma_merge_after(near, vm_flags,
 				NULL, vma->vm_file, vma->vm_pgoff))
