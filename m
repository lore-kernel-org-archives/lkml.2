Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2FMKWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:22:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:28223 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2FMKWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:22:21 -0400
X-IronPort-AV: E=Sophos;i="4.75,762,1330923600"; 
   d="scan'208";a="27891525"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86/mm: remove arch-specific pmdp_get_and_clear() function
Date: Wed, 13 Jun 2012 11:20:45 +0100
Message-ID: <1339582845-25659-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
References: <1339582845-25659-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Similar to the removal of the x86 specific ptep_get_and_clear(), do
the same for pmdp_get_and_clear().  The reasoning for this is the
same.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/include/asm/pgtable-2level.h |    9 ---------
 arch/x86/include/asm/pgtable-3level.h |   23 -----------------------
 arch/x86/include/asm/pgtable.h        |   17 -----------------
 arch/x86/include/asm/pgtable_64.h     |   13 -------------
 4 files changed, 0 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index be7c20e..9b08339 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -37,15 +37,6 @@ static inline void native_pte_clear(struct mm_struct *mm,
 	*xp = native_make_pte(0);
 }
 
-#ifdef CONFIG_SMP
-static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
-{
-	return __pmd(xchg((pmdval_t *)xp, 0));
-}
-#else
-#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
-#endif
-
 /*
  * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
  * split up the 29 bits of offset into this range:
diff --git a/arch/x86/include/asm/pgtable-3level.h b/arch/x86/include/asm/pgtable-3level.h
index 42101e9..f081699 100644
--- a/arch/x86/include/asm/pgtable-3level.h
+++ b/arch/x86/include/asm/pgtable-3level.h
@@ -133,29 +133,6 @@ static inline void pud_clear(pud_t *pudp)
 	 */
 }
 
-#ifdef CONFIG_SMP
-union split_pmd {
-	struct {
-		u32 pmd_low;
-		u32 pmd_high;
-	};
-	pmd_t pmd;
-};
-static inline pmd_t native_pmdp_get_and_clear(pmd_t *pmdp)
-{
-	union split_pmd res, *orig = (union split_pmd *)pmdp;
-
-	/* xchg acts as a barrier before setting of the high bits */
-	res.pmd_low = xchg(&orig->pmd_low, 0);
-	res.pmd_high = orig->pmd_high;
-	orig->pmd_high = 0;
-
-	return res.pmd;
-}
-#else
-#define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
-#endif
-
 /*
  * Bits 0, 6 and 7 are taken in the low part of the pte,
  * put the 32 bits of offset into the high part.
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 4413bed..34f576c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -598,14 +598,6 @@ static inline int pgd_none(pgd_t pgd)
 
 extern int direct_gbpages;
 
-static inline pmd_t native_local_pmdp_get_and_clear(pmd_t *pmdp)
-{
-	pmd_t res = *pmdp;
-
-	native_pmd_clear(pmdp);
-	return res;
-}
-
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
@@ -694,15 +686,6 @@ static inline int pmd_write(pmd_t pmd)
 	return pmd_flags(pmd) & _PAGE_RW;
 }
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm, unsigned long addr,
-				       pmd_t *pmdp)
-{
-	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
-	pmd_update(mm, addr, pmdp);
-	return pmd;
-}
-
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pmd_t *pmdp)
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index cc12d27..92eb013 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -69,19 +69,6 @@ static inline void native_pmd_clear(pmd_t *pmd)
 	native_set_pmd(pmd, native_make_pmd(0));
 }
 
-static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
-{
-#ifdef CONFIG_SMP
-	return native_make_pmd(xchg(&xp->pmd, 0));
-#else
-	/* native_local_pmdp_get_and_clear,
-	   but duplicated because of cyclic dependency */
-	pmd_t ret = *xp;
-	native_pmd_clear(xp);
-	return ret;
-#endif
-}
-
 static inline void native_set_pud(pud_t *pudp, pud_t pud)
 {
 	*pudp = pud;
-- 
1.7.2.5

