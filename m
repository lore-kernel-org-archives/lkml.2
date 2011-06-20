Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1FTWRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:17:43 -0400
Received: from claw.goop.org ([74.207.240.146]:53630 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755956Ab1FTWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:15:26 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <Xen-devel@lists.xensource.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/15] xen/trace: add mmu tracepoints
Date: Mon, 20 Jun 2011 15:15:01 -0700
Message-Id: <81e1942a6f60ee5760056b6f5a8054e8b379462b.1308607697.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1308607697.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c         |   26 +++++-
 include/trace/events/xen.h |  223 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 247 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index dc708dc..90101c5 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -48,6 +48,8 @@
 #include <linux/memblock.h>
 #include <linux/seq_file.h>
 
+#include <trace/events/xen.h>
+
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -193,6 +195,8 @@ void xen_set_domain_pte(pte_t *ptep, pte_t pteval, unsigned domid)
 	struct multicall_space mcs;
 	struct mmu_update *u;
 
+	trace_xen_mmu_set_domain_pte(ptep, pteval, domid);
+
 	mcs = xen_mc_entry(sizeof(*u));
 	u = mcs.args;
 
@@ -244,6 +248,8 @@ static void xen_set_pmd_hyper(pmd_t *ptr, pmd_t val)
 
 static void xen_set_pmd(pmd_t *ptr, pmd_t val)
 {
+	trace_xen_mmu_set_pmd(ptr, val);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!xen_page_pinned(ptr)) {
@@ -281,22 +287,30 @@ static bool xen_batched_set_pte(pte_t *ptep, pte_t pteval)
 	return true;
 }
 
-static void xen_set_pte(pte_t *ptep, pte_t pteval)
+static inline void __xen_set_pte(pte_t *ptep, pte_t pteval)
 {
 	if (!xen_batched_set_pte(ptep, pteval))
 		native_set_pte(ptep, pteval);
 }
 
+static void xen_set_pte(pte_t *ptep, pte_t pteval)
+{
+	trace_xen_mmu_set_pte(ptep, pteval);
+	__xen_set_pte(ptep, pteval);
+}
+
 static void xen_set_pte_at(struct mm_struct *mm, unsigned long addr,
 		    pte_t *ptep, pte_t pteval)
 {
-	xen_set_pte(ptep, pteval);
+	trace_xen_mmu_set_pte_at(mm, addr, ptep, pteval);
+	__xen_set_pte(ptep, pteval);
 }
 
 pte_t xen_ptep_modify_prot_start(struct mm_struct *mm,
 				 unsigned long addr, pte_t *ptep)
 {
 	/* Just return the pte as-is.  We preserve the bits on commit */
+	trace_xen_mmu_ptep_modify_prot_start(mm, addr, ptep, *ptep);
 	return *ptep;
 }
 
@@ -305,6 +319,7 @@ void xen_ptep_modify_prot_commit(struct mm_struct *mm, unsigned long addr,
 {
 	struct mmu_update u;
 
+	trace_xen_mmu_ptep_modify_prot_commit(mm, addr, ptep, pte);
 	xen_mc_batch();
 
 	u.ptr = virt_to_machine(ptep).maddr | MMU_PT_UPDATE_PRESERVE_AD;
@@ -529,6 +544,8 @@ static void xen_set_pud_hyper(pud_t *ptr, pud_t val)
 
 static void xen_set_pud(pud_t *ptr, pud_t val)
 {
+	trace_xen_mmu_set_pud(ptr, val);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!xen_page_pinned(ptr)) {
@@ -542,17 +559,20 @@ static void xen_set_pud(pud_t *ptr, pud_t val)
 #ifdef CONFIG_X86_PAE
 static void xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
+	trace_xen_mmu_set_pte_atomic(ptep, pte);
 	set_64bit((u64 *)ptep, native_pte_val(pte));
 }
 
 static void xen_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
+	trace_xen_mmu_pte_clear(mm, addr, ptep);
 	if (!xen_batched_set_pte(ptep, native_make_pte(0)))
 		native_pte_clear(mm, addr, ptep);
 }
 
 static void xen_pmd_clear(pmd_t *pmdp)
 {
+	trace_xen_mmu_pmd_clear(pmdp);
 	set_pmd(pmdp, __pmd(0));
 }
 #endif	/* CONFIG_X86_PAE */
@@ -628,6 +648,8 @@ static void xen_set_pgd(pgd_t *ptr, pgd_t val)
 {
 	pgd_t *user_ptr = xen_get_user_pgd(ptr);
 
+	trace_xen_mmu_set_pgd(ptr, user_ptr, val);
+
 	/* If page is not pinned, we can just update the entry
 	   directly */
 	if (!xen_page_pinned(ptr)) {
diff --git a/include/trace/events/xen.h b/include/trace/events/xen.h
index 54600a7..5c4e967 100644
--- a/include/trace/events/xen.h
+++ b/include/trace/events/xen.h
@@ -125,6 +125,229 @@ TRACE_EVENT(xen_mc_extend_args,
 		      __entry->res == XEN_MC_XE_BAD_OP ? "BAD_OP" :
 		      __entry->res == XEN_MC_XE_NO_SPACE ? "NO_SPACE" : "???")
 	);
+
+/* mmu */
+TRACE_EVENT(xen_mmu_set_pte,
+	    TP_PROTO(pte_t *ptep, pte_t pteval),
+	    TP_ARGS(ptep, pteval),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(__entry->ptep = ptep;
+			   __entry->pteval = pteval.pte),
+	    TP_printk("ptep %p pteval %0*llx (raw %0*llx)",
+		      __entry->ptep,
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(xen_mmu_set_pte_atomic,
+	    TP_PROTO(pte_t *ptep, pte_t pteval),
+	    TP_ARGS(ptep, pteval),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(__entry->ptep = ptep;
+			   __entry->pteval = pteval.pte),
+	    TP_printk("ptep %p pteval %0*llx (raw %0*llx)",
+		      __entry->ptep,
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(xen_mmu_set_domain_pte,
+	    TP_PROTO(pte_t *ptep, pte_t pteval, unsigned domid),
+	    TP_ARGS(ptep, pteval, domid),
+	    TP_STRUCT__entry(
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    __field(unsigned, domid)
+		    ),
+	    TP_fast_assign(__entry->ptep = ptep;
+			   __entry->pteval = pteval.pte;
+			   __entry->domid = domid),
+	    TP_printk("ptep %p pteval %0*llx (raw %0*llx) domid %u",
+		      __entry->ptep,
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval,
+		      __entry->domid)
+	);
+
+TRACE_EVENT(xen_mmu_set_pte_at,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
+		     pte_t *ptep, pte_t pteval),
+	    TP_ARGS(mm, addr, ptep, pteval),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(__entry->mm = mm;
+			   __entry->addr = addr;
+			   __entry->ptep = ptep;
+			   __entry->pteval = pteval.pte),
+	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(xen_mmu_pte_clear,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr, pte_t *ptep),
+	    TP_ARGS(mm, addr, ptep),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    ),
+	    TP_fast_assign(__entry->mm = mm;
+			   __entry->addr = addr;
+			   __entry->ptep = ptep),
+	    TP_printk("mm %p addr %lx ptep %p",
+		      __entry->mm, __entry->addr, __entry->ptep)
+	);
+
+TRACE_EVENT(xen_mmu_set_pmd,
+	    TP_PROTO(pmd_t *pmdp, pmd_t pmdval),
+	    TP_ARGS(pmdp, pmdval),
+	    TP_STRUCT__entry(
+		    __field(pmd_t *, pmdp)
+		    __field(pmdval_t, pmdval)
+		    ),
+	    TP_fast_assign(__entry->pmdp = pmdp;
+			   __entry->pmdval = pmdval.pmd),
+	    TP_printk("pmdp %p pmdval %0*llx (raw %0*llx)",
+		      __entry->pmdp,
+		      (int)sizeof(pmdval_t) * 2, (unsigned long long)pmd_val(native_make_pmd(__entry->pmdval)),
+		      (int)sizeof(pmdval_t) * 2, (unsigned long long)__entry->pmdval)
+	);
+
+TRACE_EVENT(xen_mmu_pmd_clear,
+	    TP_PROTO(pmd_t *pmdp),
+	    TP_ARGS(pmdp),
+	    TP_STRUCT__entry(
+		    __field(pmd_t *, pmdp)
+		    ),
+	    TP_fast_assign(__entry->pmdp = pmdp),
+	    TP_printk("pmdp %p", __entry->pmdp)
+	);
+
+#if PAGETABLE_LEVELS >= 4
+
+TRACE_EVENT(xen_mmu_set_pud,
+	    TP_PROTO(pud_t *pudp, pud_t pudval),
+	    TP_ARGS(pudp, pudval),
+	    TP_STRUCT__entry(
+		    __field(pud_t *, pudp)
+		    __field(pudval_t, pudval)
+		    ),
+	    TP_fast_assign(__entry->pudp = pudp;
+			   __entry->pudval = native_pud_val(pudval)),
+	    TP_printk("pudp %p pudval %0*llx (raw %0*llx)",
+		      __entry->pudp,
+		      (int)sizeof(pudval_t) * 2, (unsigned long long)pud_val(native_make_pud(__entry->pudval)),
+		      (int)sizeof(pudval_t) * 2, (unsigned long long)__entry->pudval)
+	);
+
+TRACE_EVENT(xen_mmu_set_pgd,
+	    TP_PROTO(pgd_t *pgdp, pgd_t *user_pgdp, pgd_t pgdval),
+	    TP_ARGS(pgdp, user_pgdp, pgdval),
+	    TP_STRUCT__entry(
+		    __field(pgd_t *, pgdp)
+		    __field(pgd_t *, user_pgdp)
+		    __field(pgdval_t, pgdval)
+		    ),
+	    TP_fast_assign(__entry->pgdp = pgdp;
+			   __entry->user_pgdp = user_pgdp;
+			   __entry->pgdval = pgdval.pgd),
+	    TP_printk("pgdp %p user_pgdp %p pgdval %0*llx (raw %0*llx)",
+		      __entry->pgdp, __entry->user_pgdp,
+		      (int)sizeof(pgdval_t) * 2, (unsigned long long)pgd_val(native_make_pgd(__entry->pgdval)),
+		      (int)sizeof(pgdval_t) * 2, (unsigned long long)__entry->pgdval)
+	);
+
+TRACE_EVENT(xen_mmu_pud_clear,
+	    TP_PROTO(pud_t *pudp),
+	    TP_ARGS(pudp),
+	    TP_STRUCT__entry(
+		    __field(pud_t *, pudp)
+		    ),
+	    TP_fast_assign(__entry->pudp = pudp),
+	    TP_printk("pudp %p", __entry->pudp)
+	);
+#else
+
+TRACE_EVENT(xen_mmu_set_pud,
+	    TP_PROTO(pud_t *pudp, pud_t pudval),
+	    TP_ARGS(pudp, pudval),
+	    TP_STRUCT__entry(
+		    __field(pud_t *, pudp)
+		    __field(pudval_t, pudval)
+		    ),
+	    TP_fast_assign(__entry->pudp = pudp;
+			   __entry->pudval = native_pud_val(pudval)),
+	    TP_printk("pudp %p pudval %0*llx (raw %0*llx)",
+		      __entry->pudp,
+		      (int)sizeof(pudval_t) * 2, (unsigned long long)pgd_val(native_make_pgd(__entry->pudval)),
+		      (int)sizeof(pudval_t) * 2, (unsigned long long)__entry->pudval)
+	);
+
+#endif
+
+TRACE_EVENT(xen_mmu_pgd_clear,
+	    TP_PROTO(pgd_t *pgdp),
+	    TP_ARGS(pgdp),
+	    TP_STRUCT__entry(
+		    __field(pgd_t *, pgdp)
+		    ),
+	    TP_fast_assign(__entry->pgdp = pgdp),
+	    TP_printk("pgdp %p", __entry->pgdp)
+	);
+
+TRACE_EVENT(xen_mmu_ptep_modify_prot_start,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
+		     pte_t *ptep, pte_t pteval),
+	    TP_ARGS(mm, addr, ptep, pteval),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(__entry->mm = mm;
+			   __entry->addr = addr;
+			   __entry->ptep = ptep;
+			   __entry->pteval = pteval.pte),
+	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
+	);
+
+TRACE_EVENT(xen_mmu_ptep_modify_prot_commit,
+	    TP_PROTO(struct mm_struct *mm, unsigned long addr,
+		     pte_t *ptep, pte_t pteval),
+	    TP_ARGS(mm, addr, ptep, pteval),
+	    TP_STRUCT__entry(
+		    __field(struct mm_struct *, mm)
+		    __field(unsigned long, addr)
+		    __field(pte_t *, ptep)
+		    __field(pteval_t, pteval)
+		    ),
+	    TP_fast_assign(__entry->mm = mm;
+			   __entry->addr = addr;
+			   __entry->ptep = ptep;
+			   __entry->pteval = pteval.pte),
+	    TP_printk("mm %p addr %lx ptep %p pteval %0*llx (raw %0*llx)",
+		      __entry->mm, __entry->addr, __entry->ptep,
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)pte_val(native_make_pte(__entry->pteval)),
+		      (int)sizeof(pteval_t) * 2, (unsigned long long)__entry->pteval)
+	);
+
+
 #endif /*  _TRACE_XEN_H */
 
 /* This part must be outside protection */
-- 
1.7.5.4

