Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab1APVLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:11:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753666Ab1APVLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:11:12 -0500
Date: Sun, 16 Jan 2011 13:10:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: ia64 broken by transparent huge pages - other arches too?
Message-Id: <20110116131039.0f0a9359.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikZ+MmM9f0tidpccDAimtUkDvJ3N=3KE+xFxc63@mail.gmail.com>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
	<1295076096.4875.60.camel@pasglop>
	<AANLkTikZ+MmM9f0tidpccDAimtUkDvJ3N=3KE+xFxc63@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011 13:05:15 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jan 14, 2011 at 11:21 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > This is insane. Having such a massively invasive change to the whole mm,
> > barely tested on most architecture, and last I heard still generally
> > controversial being merged like that without even some integration
> > testing via -next makes no sense.
> >
> > Linus, wtf is going on ?
> 
> I pretty much take anything from Andrew, unless I hate it (and the
> latest version of the transparent huge-page was ok).
> 
> That said, I did think that Andrew's -mm tree was in -next, and there
> clearly is some serious problem wrt -mm and -next if this wasn't
> caught earlier there.

It's taking a while - Stephen and I are discussing a plan.

These problems were caused by a last-minute fixup which was more of a
breakup.

> I was also expecting the fixups to come through Andrew, and they
> haven't.

You've applied a couple directly, but this one is still outstanding.

> I can apply whatever people agree is sane, but right now I
> don't even know what the final patch for this problem is.

I believe it's the below.  I haven't tested it yet and nor has anyone
else apart from Andrea, afaik.


From: Andrea Arcangeli <aarcange@redhat.com>

pmdp_get_and_clear/pmdp_clear_flush/pmdp_splitting_flush were trapped as
BUG() and they were defined only to diminish the risk of build issues on
not-x86 archs and to be consistent with the generic pte methods previously
defined in include/asm-generic/pgtable.h.

But they are causing more trouble than they were supposed to solve, so
it's simpler not to define them when THP is off.

This is also correcting the export of pmdp_splitting_flush which is
currently unused (x86 isn't using the generic implementation in
mm/pgtable-generic.c and no other arch needs that [yet]).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |   14 +++-----------
 mm/pgtable-generic.c          |   11 ++++-------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n
+++ a/include/asm-generic/pgtable.h
@@ -87,14 +87,6 @@ static inline pmd_t pmdp_get_and_clear(s
 	pmd_clear(mm, address, pmdp);
 	return pmd;
 })
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long address,
-				       pmd_t *pmdp)
-{
-	BUG();
-	return __pmd(0);
-}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
@@ -163,9 +155,9 @@ static inline void pmdp_set_wrprotect(st
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
-			      unsigned long address,
-			      pmd_t *pmdp);
+extern pmd_t pmdp_splitting_flush(struct vm_area_struct *vma,
+				  unsigned long address,
+				  pmd_t *pmdp);
 #endif
 
 #ifndef __HAVE_ARCH_PTE_SAME
diff -puN mm/pgtable-generic.c~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-remove-pmdp_get_and_clear-pmdp_clear_flush-pmdp_splitting_flush-methods-when-thp=n
+++ a/mm/pgtable-generic.c
@@ -92,32 +92,29 @@ pte_t ptep_clear_flush(struct vm_area_st
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_CLEAR_FLUSH
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 pmd_t pmdp_clear_flush(struct vm_area_struct *vma, unsigned long address,
 		       pmd_t *pmdp)
 {
 	pmd_t pmd;
-#ifndef CONFIG_TRANSPARENT_HUGEPAGE
-	BUG();
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 pmd_t pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmdp)
 {
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	pmd_t pmd = pmd_mksplitting(*pmdp);
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
 	/* tlb flush only to serialize against gup-fast */
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-#else /* CONFIG_TRANSPARENT_HUGEPAGE */
-	BUG();
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
_

