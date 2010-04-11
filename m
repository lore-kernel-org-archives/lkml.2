Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab0DKRMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:12:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752380Ab0DKRMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:12:30 -0400
Date: Sun, 11 Apr 2010 10:07:24 -0700 (PDT)
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
In-Reply-To: <20100411130801.GA7189@a1.tnic>
Message-ID: <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <20100410185145.GB28952@a1.tnic> <20100410185839.GA32035@a1.tnic> <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org>
 <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic> <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Borislav Petkov wrote:
> 
> Ok, I could verify that the three patches we were talking about still
> can't fix the issue. However, just to make sure I'm sending the versions
> of the patches I used for you guys to check.

Yup, the patches are the ones I wanted you to try.

So either my fixes were buggy (possible, especially for the vma_adjust 
case), or there are other bugs still lurking.

The scary part is that the _old_ anon_vma code didn't really care about 
the anon_vma all that deeply. It was just a placeholder, if you got some 
of it wrong the worst that would probably happen would be that a page 
could never find all the mappings it had. So it was a possible swap 
efficiency problem when we cannot get rid of all mapped pages, but if it 
only happens for some small and unusual special case, nobody would ever 
have noticed.

With the new code, when you have a page that is associated with a stale 
anon_vma, you get the page_referenced() oops instead.

And I can't find the bug. Everything I've looked at looks fine. So I'm 
going to ask you to start applying "validation patches" - code to check 
some internal consistency, and seeing if we break that internal 
consistency somewhere.

It may be that Rik has some patches like this from his development work, 
but here's the first one. This patch should have caught the vma_adjust() 
problem, but all it caught for me was that "anon_vma_clone()" ended up 
cloning the avc entries in the wrong order so the lists didn't actually 
look exactly the same.

The patch fixes that case, so if this triggers any warnings for you, I 
think it's a real bug.

But I'm pretty sure that the problem is that we have a "page->mapping" 
that points to an anon_vma that no longer exists, and you can easily get 
that while still having valid vma chains - they just aren't necessarily 
the complete _set_ of chains they should be.

[ In particular, I think that the _real_ problem is that we don't clear 
  "page->mapping" when we unmap a page.

  See the comment at the end of page_remove_rmap(), and it also explains 
  the test for "page_mapped()" in page_lock_anon_vma().

  But I think the bug you see might be exactly the race between 
  page_mapped() and actually getting the anon_vma spinlock. I'd have 
  expected that window to be too small to ever hit, though, which is why I 
  find it a bit unlikely. But it would explain why you _sometimes_ 
  actually get a hung spinlock too - you never get the spinlock at all, 
  and somebody replaced the data with something that the spinlock code 
  thinks is a locked spinlock - but is no longer a spinlock at all ]

			Linus

---
 mm/mmap.c |   18 ++++++++++++++++++
 mm/rmap.c |    2 +-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f90ea92..890c169 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1565,6 +1565,22 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 EXPORT_SYMBOL(get_unmapped_area);
 
+static void verify_vma(struct vm_area_struct *vma)
+{
+	if (vma->anon_vma) {
+		struct anon_vma_chain *avc;
+		if (WARN_ONCE(list_empty(&vma->anon_vma_chain), "vma has anon_vma but empty chain"))
+			return;
+		/* The first entry of the avc chain should match! */
+		avc = list_entry(vma->anon_vma_chain.next, struct anon_vma_chain, same_vma);
+		WARN_ONCE(avc->anon_vma != vma->anon_vma, "anon_vma entry doesn't match anon_vma_chain");
+		WARN_ONCE(avc->vma != vma, "vma entry doesn't match anon_vma_chain");
+	} else {
+		WARN_ONCE(!list_empty(&vma->anon_vma_chain), "vma has no anon_vma but has chain");
+	}
+}
+
+
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
 struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
@@ -1598,6 +1614,8 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 				mm->mmap_cache = vma;
 		}
 	}
+	if (vma)
+		verify_vma(vma);
 	return vma;
 }
 
diff --git a/mm/rmap.c b/mm/rmap.c
index eaa7a09..ee97d38 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -182,7 +182,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
 
-	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		avc = anon_vma_chain_alloc();
 		if (!avc)
 			goto enomem_failure;
