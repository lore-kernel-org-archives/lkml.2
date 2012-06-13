Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2FMKXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:23:11 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28223 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab2FMKWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:22:23 -0400
X-IronPort-AV: E=Sophos;i="4.75,762,1330923600"; 
   d="scan'208";a="27891526"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86/mm: remove arch-specific ptep_get_and_clear() function
Date: Wed, 13 Jun 2012 11:20:44 +0100
Message-ID: <1339582845-25659-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

x86 provides a ptep_get_and_clear() function instead of using the
generic implementation so it can atomically get and clear the PTE.

It is not clear why x86 has this requirement.  PTE updates are done
while the appropriate PTE lock are held, so presumably, it is an
attempt to ensure that the accessed and dirty bits of the PTE are
saved even if they have been updated by the hardware due to a
concurrent access on another CPU.

However, the atomic exchange is not sufficient for saving the dirty
bit as if there is a TLB entry for this page on another CPU then the
dirty bit may be written by that processor after the PTE is cleared
but before the TLB entry is flushed.  It is also not clear from the
Intel SDM[1] if the processor's read of the PTE and the write to set
the accessed bit are atomic or not.

With this patch the get/clear becomes a read of the PTE and call to
pte_clear() which allows the clears to be batched by some
paravirtualized guests (such as Xen guests).  This can lead to
significant performance improvements in munmap().  e.g., for Xen, a
trap-and-emulate[2] for every page becomes a hypercall for every 31
pages.

There should be no change in the performance on native or for KVM
guests.  There may be a performance regression with lguest guests as
an optimization for avoiding calling pte_update() when doing a full
teardown of an mm is removed.

As a consequence there is a slight increase of the window where a set
(by the processor) of the accessed or dirty bit may be lost.  This
shouldn't change the behaviour of user space in any meaningful way.
Any user space application accessing a mmap()'d region that is being
munmap()'d or mremap()'d is already going to have unpredicatable
behaviour -- the access may succeed, it may fault, or the write to the
mapped file may be lost.

[1] Intel Software Developer's Manual Vol 3A section 4.8 says nothing
on this.

[2] For 32-bit guests, two traps are required for every page to update
both halves of the PTE.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/pgtable-2level.h |    9 --------
 arch/x86/include/asm/pgtable-3level.h |   16 --------------
 arch/x86/include/asm/pgtable.h        |   37 ---------------------------------
 arch/x86/include/asm/pgtable_64.h     |   13 -----------
 4 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index 98391db..be7c20e 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -38,15 +38,6 @@ static inline void native_pte_clear(struct mm_struct *mm,
 }
 
 #ifdef CONFIG_SMP
-static inline pte_t native_ptep_get_and_clear(pte_t *xp)
-{
-	return __pte(xchg(&xp->pte_low, 0));
-}
-#else
-#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
-#endif
-
-#ifdef CONFIG_SMP
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
 	return __pmd(xchg((pmdval_t *)xp, 0));
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 43876f1..42101e9 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -134,22 +134,6 @@ static inline void pud_clear(pud_t *pudp)
 }
 
 #ifdef CONFIG_SMP
-static inline pte_t native_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res;
-
-	/* xchg acts as a barrier before the setting of the high bits */
-	res.pte_low = xchg(&ptep->pte_low, 0);
-	res.pte_high = ptep->pte_high;
-	ptep->pte_high = 0;
-
-	return res;
-}
-#else
-#define native_ptep_get_and_clear(xp) native_local_ptep_get_and_clear(xp)
-#endif
-
-#ifdef CONFIG_SMP
 union split_pmd {
 	struct {
 		u32 pmd_low;
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 49afb3f..4413bed 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -598,16 +598,6 @@ static inline int pgd_none(pgd_t pgd)
 
 extern int direct_gbpages;
 
-/* local pte updates need not use xchg for locking */
-static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
-{
-	pte_t res = *ptep;
-
-	/* Pure native function needs no input for mm, addr */
-	native_pte_clear(NULL, 0, ptep);
-	return res;
-}
-
 static inline pmd_t native_local_pmdp_get_and_clear(pmd_t *pmdp)
 {
 	pmd_t res = *pmdp;
@@ -668,33 +658,6 @@ extern int ptep_test_and_clear_young(struct vm_area_struct *vma,
 extern int ptep_clear_flush_young(struct vm_area_struct *vma,
 				  unsigned long address, pte_t *ptep);
 
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
-				       pte_t *ptep)
-{
-	pte_t pte = native_ptep_get_and_clear(ptep);
-	pte_update(mm, addr, ptep);
-	return pte;
-}
-
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
-static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
-					    unsigned long addr, pte_t *ptep,
-					    int full)
-{
-	pte_t pte;
-	if (full) {
-		/*
-		 * Full address destruction in progress; paravirt does not
-		 * care about updates and native needs no locking
-		 */
-		pte = native_local_ptep_get_and_clear(ptep);
-	} else {
-		pte = ptep_get_and_clear(mm, addr, ptep);
-	}
-	return pte;
-}
-
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 975f709..cc12d27 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -69,19 +69,6 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	native_set_pmd(pmd, native_make_pmd(0));
 }
 
-static inline pte_t native_ptep_get_and_clear(pte_t *xp)
-{
-#ifdef CONFIG_SMP
-	return native_make_pte(xchg(&xp->pte, 0));
-#else
-	/* native_local_ptep_get_and_clear,
-	   but duplicated because of cyclic dependency */
-	pte_t ret = *xp;
-	native_pte_clear(NULL, 0, xp);
-	return ret;
-#endif
-}
-
 static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 {
 #ifdef CONFIG_SMP
-- 
1.7.2.5

