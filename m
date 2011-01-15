Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1AOS01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 13:26:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1AOS0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 13:26:23 -0500
Date: Sat, 15 Jan 2011 19:26:05 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        sparclinux <sparclinux@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck, Tony" <tony.luck@intel.com>, linux-arch@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: sparc32 build failure [Was: linux-next: build failure after
 merge of the final tree]
Message-ID: <20110115182605.GW9506@random.random>
References: <20110115131027.2c07ccb0.sfr@canb.auug.org.au>
 <20110115042753.GS9506@random.random>
 <20110115162019.GA8136@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115162019.GA8136@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

On Sat, Jan 15, 2011 at 05:20:20PM +0100, Sam Ravnborg wrote:
> Can we get the build fixed ASAP or do we wait for David to comment on this?

I think sparc32 problem is pmd is an array. So now I built a sparc64
compiler and built with ARCH=sparc32.

$ file vmlinux
vmlinux: ELF 32-bit MSB relocatable, SPARC, version 1 (SYSV), not stripped

I got it to build (the zImage won't build on my environment for some
assembly issue in arch/sparc/boot/btfix.S but that shall not be
related to this, all it matters is the final linking of vmlinux is
successful).

So to fix this once and for all, please apply this below patch. If
this works no change to any arch is required (ia64 could also revert
the __pmd definition if they prefer, not that it makes any relevant
difference for ia64 other than being more consistent with most other
archs).

Only the arm build fix from James most certainly is still needed in
addition to this.

Sorry again for this build issue.
Andrea

==========
Subject: remove pmdp_get_and_clear/pmdp_clear_flush/pmdp_splitting_flush methods when THP=n

From: Andrea Arcangeli <aarcange@redhat.com>

pmdp_get_and_clear/pmdp_clear_flush/pmdp_splitting_flush were trapped
as BUG() and they were defined only to diminish the risk of build
issues on not-x86 archs and to be consistent with the generic pte
methods previously defined in include/asm-generic/pgtable.h.

But they are causing more trouble than they were supposed to solve, so
it's simpler not to define them when THP is off.

This is also correcting the export of pmdp_splitting_flush which is
currently unused (x86 isn't using the generic implementation in
mm/pgtable-generic.c and no other arch needs that [yet]).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
deleted file mode 100644
index e69de29..0000000
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index f1eddf7..31b6188 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -87,14 +87,6 @@ static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
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
 
@@ -163,9 +155,9 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
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
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d030548..0369f5b 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -92,32 +92,29 @@ pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
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
