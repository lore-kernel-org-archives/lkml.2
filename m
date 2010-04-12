Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0DLBJK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 21:09:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab0DLBJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 21:09:06 -0400
Date: Sun, 11 Apr 2010 18:04:39 -0700 (PDT)
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
In-Reply-To: <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004101234210.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004101308250.3618@i5.linux-foundation.org> <20100410203628.GB32035@a1.tnic> <alpine.LFD.2.00.1004101336440.3618@i5.linux-foundation.org> <20100410212555.GA1797@a1.tnic>
 <alpine.LFD.2.00.1004101427090.3618@i5.linux-foundation.org> <20100410215115.GA2599@a1.tnic> <20100411130801.GA7189@a1.tnic> <alpine.LFD.2.00.1004110938570.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111010280.3514@i5.linux-foundation.org>
 <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Linus Torvalds wrote:
> 
> I'll see if I can come up with a patch to do the same kind of validation 
> on page->mapping as on the anon-vma chains themselves.

Ok, this may or may not work. It hasn't triggered for me, which may be 
because it's broken, but maybe it's because I'm not doing whatever it is 
you are doing to break our VM.

It checks each anonymous page at unmap time against the vma it gets 
unmapped from. It depends on the previous vma_verify debugging patch, and 
it would be interesting to hear whether this patch causes any new warnngs 
for you..

If the warnings do happen, they are not going to be printing out any 
hugely informative data apart from the fact that the bad case happened at 
all. But If they do trigger, I can try to improve on them - it's just not 
worth trying to make them any more interesting if they never trigger.

		Linus

---
 mm/memory.c |   21 +++++++++++++++++++++
 mm/mmap.c   |    2 +-
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 833952d..5d2df59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -890,6 +890,25 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	return ret;
 }
 
+extern void verify_vma(struct vm_area_struct *);
+
+static void verify_anon_page(struct vm_area_struct *vma, struct page *page)
+{
+	struct anon_vma *anon_vma = vma->anon_vma;
+	struct anon_vma *need_anon_vma = page_anon_vma(page);
+	struct anon_vma_chain *avc;
+
+	verify_vma(vma);
+	if (WARN_ONCE(!anon_vma, "anonymous page in vma without anon_vma"))
+		return;
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+		WARN_ONCE(avc->vma != vma, "anon_vma_chain vma entry doesn't match");
+		if (avc->anon_vma == need_anon_vma)
+			return;
+	}
+	WARN_ONCE(1, "page->mapping does not exist in vma chain");
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -940,6 +959,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 			tlb_remove_tlb_entry(tlb, pte, addr);
 			if (unlikely(!page))
 				continue;
+			if (PageAnon(page))
+				verify_anon_page(vma, page);
 			if (unlikely(details) && details->nonlinear_vma
 			    && linear_page_index(details->nonlinear_vma,
 						addr) != page->index)
diff --git a/mm/mmap.c b/mm/mmap.c
index 890c169..461f59c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1565,7 +1565,7 @@ get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 
 EXPORT_SYMBOL(get_unmapped_area);
 
-static void verify_vma(struct vm_area_struct *vma)
+void verify_vma(struct vm_area_struct *vma)
 {
 	if (vma->anon_vma) {
 		struct anon_vma_chain *avc;
