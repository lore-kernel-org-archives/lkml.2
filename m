Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2HSDBI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:44069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab2HSC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="210415458"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, jeremy@goop.org
Subject: [PATCH 53/74] x86, lto, paravirt: Make paravirt thunks global
Date: Sat, 18 Aug 2012 19:56:49 -0700
Message-Id: <1345345030-22211-54-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The paravirt thunks use a hack of using a static reference to a static
function to reference that function from the top level statement.

This assumes that gcc always generates static function names in a specific
format, which is not necessarily true.

Simply make these functions global and asmlinkage. This way the
static __used variables are not needed and everything works.

Changed in paravirt and in all users (Xen and vsmp)

Cc: jeremy@goop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h |    2 +-
 arch/x86/kernel/vsmp_64.c       |    8 ++++----
 arch/x86/xen/irq.c              |    8 ++++----
 arch/x86/xen/mmu.c              |   16 ++++++++--------
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..cc733a6 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -804,9 +804,9 @@ static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
  */
 #define PV_CALLEE_SAVE_REGS_THUNK(func)					\
 	extern typeof(func) __raw_callee_save_##func;			\
-	static void *__##func##__ __used = func;			\
 									\
 	asm(".pushsection .text;"					\
+	    ".globl __raw_callee_save_" #func " ; "			\
 	    "__raw_callee_save_" #func ": "				\
 	    PV_SAVE_ALL_CALLER_REGS					\
 	    "call " #func ";"						\
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 992f890..f393d6d 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -33,7 +33,7 @@
  * and vice versa.
  */
 
-static unsigned long vsmp_save_fl(void)
+asmlinkage unsigned long vsmp_save_fl(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -43,7 +43,7 @@ static unsigned long vsmp_save_fl(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_save_fl);
 
-static void vsmp_restore_fl(unsigned long flags)
+asmlinkage void vsmp_restore_fl(unsigned long flags)
 {
 	if (flags & X86_EFLAGS_IF)
 		flags &= ~X86_EFLAGS_AC;
@@ -53,7 +53,7 @@ static void vsmp_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_restore_fl);
 
-static void vsmp_irq_disable(void)
+asmlinkage void vsmp_irq_disable(void)
 {
 	unsigned long flags = native_save_fl();
 
@@ -61,7 +61,7 @@ static void vsmp_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_disable);
 
-static void vsmp_irq_enable(void)
+asmlinkage void vsmp_irq_enable(void)
 {
 	unsigned long flags = native_save_fl();
 
diff --git a/arch/x86/xen/irq.c b/arch/x86/xen/irq.c
index 1573376..3dd8831 100644
--- a/arch/x86/xen/irq.c
+++ b/arch/x86/xen/irq.c
@@ -21,7 +21,7 @@ void xen_force_evtchn_callback(void)
 	(void)HYPERVISOR_xen_version(0, NULL);
 }
 
-static unsigned long xen_save_fl(void)
+asmlinkage unsigned long xen_save_fl(void)
 {
 	struct vcpu_info *vcpu;
 	unsigned long flags;
@@ -39,7 +39,7 @@ static unsigned long xen_save_fl(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_save_fl);
 
-static void xen_restore_fl(unsigned long flags)
+asmlinkage void xen_restore_fl(unsigned long flags)
 {
 	struct vcpu_info *vcpu;
 
@@ -66,7 +66,7 @@ static void xen_restore_fl(unsigned long flags)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_restore_fl);
 
-static void xen_irq_disable(void)
+asmlinkage void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
 	   make sure we're don't switch CPUs between getting the vcpu
@@ -77,7 +77,7 @@ static void xen_irq_disable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_irq_disable);
 
-static void xen_irq_enable(void)
+asmlinkage void xen_irq_enable(void)
 {
 	struct vcpu_info *vcpu;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b65a761..9f82443 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -429,7 +429,7 @@ static pteval_t iomap_pte(pteval_t val)
 	return val;
 }
 
-static pteval_t xen_pte_val(pte_t pte)
+asmlinkage pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
 #if 0
@@ -446,7 +446,7 @@ static pteval_t xen_pte_val(pte_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pte_val);
 
-static pgdval_t xen_pgd_val(pgd_t pgd)
+asmlinkage pgdval_t xen_pgd_val(pgd_t pgd)
 {
 	return pte_mfn_to_pfn(pgd.pgd);
 }
@@ -477,7 +477,7 @@ void xen_set_pat(u64 pat)
 	WARN_ON(pat != 0x0007010600070106ull);
 }
 
-static pte_t xen_make_pte(pteval_t pte)
+asmlinkage pte_t xen_make_pte(pteval_t pte)
 {
 	phys_addr_t addr = (pte & PTE_PFN_MASK);
 #if 0
@@ -512,14 +512,14 @@ static pte_t xen_make_pte(pteval_t pte)
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pte);
 
-static pgd_t xen_make_pgd(pgdval_t pgd)
+asmlinkage pgd_t xen_make_pgd(pgdval_t pgd)
 {
 	pgd = pte_pfn_to_mfn(pgd);
 	return native_make_pgd(pgd);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pgd);
 
-static pmdval_t xen_pmd_val(pmd_t pmd)
+asmlinkage pmdval_t xen_pmd_val(pmd_t pmd)
 {
 	return pte_mfn_to_pfn(pmd.pmd);
 }
@@ -578,7 +578,7 @@ static void xen_pmd_clear(pmd_t *pmdp)
 }
 #endif	/* CONFIG_X86_PAE */
 
-static pmd_t xen_make_pmd(pmdval_t pmd)
+asmlinkage pmd_t xen_make_pmd(pmdval_t pmd)
 {
 	pmd = pte_pfn_to_mfn(pmd);
 	return native_make_pmd(pmd);
@@ -586,13 +586,13 @@ static pmd_t xen_make_pmd(pmdval_t pmd)
 PV_CALLEE_SAVE_REGS_THUNK(xen_make_pmd);
 
 #if PAGETABLE_LEVELS == 4
-static pudval_t xen_pud_val(pud_t pud)
+asmlinkage pudval_t xen_pud_val(pud_t pud)
 {
 	return pte_mfn_to_pfn(pud.pud);
 }
 PV_CALLEE_SAVE_REGS_THUNK(xen_pud_val);
 
-static pud_t xen_make_pud(pudval_t pud)
+asmlinkage pud_t xen_make_pud(pudval_t pud)
 {
 	pud = pte_pfn_to_mfn(pud);
 
-- 
1.7.7.6

