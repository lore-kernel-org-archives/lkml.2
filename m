Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab0HXAkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:40:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:34401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab0HXAkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:40:37 -0400
Date: Tue, 24 Aug 2010 00:40:19 GMT
From: tip-bot for Alok Kataria <akataria@vmware.com>
Cc: jeremy@xensource.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, akataria@vmware.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jeremy@xensource.com, tglx@linutronix.de, akataria@vmware.com,
        hpa@linux.intel.com
In-Reply-To: <1282608357.19396.36.camel@ank32.eng.vmware.com>
References: <1282608357.19396.36.camel@ank32.eng.vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vmware] x86, paravirt: Remove alloc_pmd_clone hook, only used by VMI
Message-ID: <tip-b0f4c062fb6dd4c02b1fe6de73319ed50a09b27d@git.kernel.org>
Git-Commit-ID: b0f4c062fb6dd4c02b1fe6de73319ed50a09b27d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 24 Aug 2010 00:40:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0f4c062fb6dd4c02b1fe6de73319ed50a09b27d
Gitweb:     http://git.kernel.org/tip/b0f4c062fb6dd4c02b1fe6de73319ed50a09b27d
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Mon, 23 Aug 2010 17:05:57 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Aug 2010 17:09:44 -0700

x86, paravirt: Remove alloc_pmd_clone hook, only used by VMI

VMI was the only user of the alloc_pmd_clone hook, given that VMI
is now removed we can also remove this hook.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
LKML-Reference: <1282608357.19396.36.camel@ank32.eng.vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h       |    5 -----
 arch/x86/include/asm/paravirt_types.h |    1 -
 arch/x86/kernel/paravirt.c            |    1 -
 arch/x86/mm/pgtable.c                 |    4 ----
 arch/x86/xen/mmu.c                    |    1 -
 5 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5653f43..edecb4e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -416,11 +416,6 @@ static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
 	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
-static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
-					    unsigned long start, unsigned long count)
-{
-	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
-}
 static inline void paravirt_release_pmd(unsigned long pfn)
 {
 	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index db9ef55..b82bac9 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -255,7 +255,6 @@ struct pv_mmu_ops {
 	 */
 	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
 	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
-	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
 	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
 	void (*release_pte)(unsigned long pfn);
 	void (*release_pmd)(unsigned long pfn);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1db183e..c5b2500 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -413,7 +413,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 
 	.alloc_pte = paravirt_nop,
 	.alloc_pmd = paravirt_nop,
-	.alloc_pmd_clone = paravirt_nop,
 	.alloc_pud = paravirt_nop,
 	.release_pte = paravirt_nop,
 	.release_pmd = paravirt_nop,
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5c4ee42..a96023e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -98,10 +98,6 @@ static void pgd_ctor(pgd_t *pgd)
 		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
 				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
-		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
-					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
-					 KERNEL_PGD_BOUNDARY,
-					 KERNEL_PGD_PTRS);
 	}
 
 	/* list required to sync kernel mapping updates */
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 42086ac..b2363fc 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1969,7 +1969,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
 	.alloc_pmd = xen_alloc_pmd_init,
-	.alloc_pmd_clone = paravirt_nop,
 	.release_pmd = xen_release_pmd_init,
 
 #ifdef CONFIG_X86_64
