Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1LCOmB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 09:42:01 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:50617 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1LCOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 09:41:59 -0500
Date: Fri, 2 Dec 2011 18:31:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de
Cc: mingo@redhat.com, xen-devel@lists.xensource.com, stable@kernel.org
Subject: Re: [PATCH 2/3] x86/cpa: Use pte_attrs instead of pte_flags on
 CPA/set_p.._wb/wc operations.
Message-ID: <20111202233122.GA12556@phenom.dumpdata.com>
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com>
 <1320786914-10541-3-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <1320786914-10541-3-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EDA3515.006A,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> The fix, which this patch proposes, is to wrap the pte_pgprot in the CPA
> code with newly introduced pte_attrs which can go through the pvops interface
> to get the "emulated" value instead of the raw. Naturally if CONFIG_PARAVIRT is
> not set, it would end calling native_pte_val.
> 
> The other way to fix this is by wrapping pte_flags and go through the pvops
> interface and it really is the Right Thing to do.  The problem is, that past
> experience with mprotect stuff demonstrates that it be really expensive in inner
> loops, and pte_flags() is used in some very perf-critical areas.

I did not get to verify the mprotect stuff as I need to chase down the details of it,
but I did run some benchmarks using kernbench on three different boxes:

 AMD A8-3850 (8GB) - tst005
 Intel i3-2100 (8GB) - tst007
 Nehelem EX (32logical cpus) (32GB) - tst010

I've put all the kernebench results in https://www.dumpdata.com/results/baseline_pte_flags_pte_attrs/
(and the chart for the AMD is attached).

The boxes have a fresh install of F16, with a 3.2-rc3 variant kernel using the
.config that F16 came with. I just hit Enter when oldconfig asked me to choose.

The baseline is virgin v3.2-rc3. The pte_attrs is the patch that this email is
replaying too (on top of v3.2-rc3). The pte_flags are two patches that wrap pte_flags
in paravirt and use alternative_asm to patch the code (on top of v3.2-rc3).

The patches are in the URL mentioned or in my git branch as
devel/pte_attrs.v1 ( git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git).
I am also attaching them in this email.

The summary is that I could only get the numbers to show some difference when
the maximum load was run - and _only_ on the AMD machine. The small SandyBridge
and the big SandyBridge had no trouble with. The AMD machine the difference was
13% worst if pte_flags (so alternative_asm) was used instead of pte_attrs.

The way I did these tests is to bootup with 'init=/bin/bash', remount / as rw, activate
swap disk and run kernbench on the v3.2-rc3 linux tree. Then unplug the machine for a tea
break and then repeat the cycle with a different kernel.

--YiEDa0DAkWCtVeE4
Content-Type: image/png
Content-Disposition: attachment; filename="AMD-A8-3850.png"
Content-Transfer-Encoding: base64

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
XW/o2AIAAAAASUVORK5CYII=

--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-paravirt-xen-Introduce-pte_flags.patch"

>From 6f30ff305df4d36160641ad7232c39f58afc5c4a Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 28 Nov 2011 17:33:47 -0500
Subject: x86/paravirt/xen: Introduce pte_flags.

We are providing a version of pte_flags where the processing
under Xen goes couple of extra steps (if pat is enabled).

The baremetal version looks quite identical to the pte_val
one and the idea is to piggyback on the DEF_NATIVE/PTE_IDENT
mechanism that pte_val uses for baremetal.

Specifically we move the logical processing of "& PTE_FLAGS_MASK"
out of the functions to minimize the amount of operations
the paravirt operations have to do. This benefits us greatly
as this way we don't have do that logical operations in the function:
(native_pte_flags):

	pushq	%rbp
	movq	%rdi, %rax
	movabsq	$-70368744173569, %rdx
	andq	%rdx, %rax
	movq	%rsp, %rbp
	popq	%rbp
	ret

but instead the paravirt function ends up being:

	pushq	%rbp
	movq	%rdi, %rax
	movq	%rsp, %rbp
	popq	%rbp
	ret

and the logical "and" operation is done outside the call.

This means that the only real operation that native_pte_flags
is "movq %rdi, %rax" we can take advantage of the PTE_IDENT
functionality introduced in patch:
"x86/paravirt/xen: Optimize pte_flags by marking it as paravirt_ident_[32|64] type."

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/paravirt.h       |    5 +++++
 arch/x86/include/asm/paravirt_types.h |    1 +
 arch/x86/include/asm/pgtable.h        |    1 +
 arch/x86/include/asm/pgtable_types.h  |    4 ++--
 arch/x86/kernel/paravirt.c            |    1 +
 arch/x86/xen/mmu.c                    |   13 +++++++++++++
 6 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a7d2db9..6533409 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -462,6 +462,11 @@ static inline void pmd_update_defer(struct mm_struct *mm, unsigned long addr,
 	PVOP_VCALL3(pv_mmu_ops.pmd_update_defer, mm, addr, pmdp);
 }
 
+static inline pteval_t pte_flags(pte_t pte)
+{
+	return pv_mmu_ops.pte_flags(pte) & PTE_FLAGS_MASK;
+}
+
 static inline pte_t __pte(pteval_t val)
 {
 	pteval_t ret;
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 8e8b9a4..86bce9d 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -288,6 +288,7 @@ struct pv_mmu_ops {
 	void (*ptep_modify_prot_commit)(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, pte_t pte);
 
+	pteval_t (*pte_flags)(pte_t pte);
 	struct paravirt_callee_save pte_val;
 	struct paravirt_callee_save make_pte;
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 18601c8..eebf625 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -76,6 +76,7 @@ extern struct mm_struct *pgd_page_get_mm(struct page *page);
 #define __pmd(x)	native_make_pmd(x)
 #endif
 
+#define pte_flags(x)	(native_pte_val(x) & PTE_FLAGS_MASK)
 #define pte_val(x)	native_pte_val(x)
 #define __pte(x)	native_make_pte(x)
 
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 013286a..4c957e8 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -270,9 +270,9 @@ static inline pteval_t native_pte_val(pte_t pte)
 	return pte.pte;
 }
 
-static inline pteval_t pte_flags(pte_t pte)
+static inline pteval_t native_pte_flags(pte_t pte)
 {
-	return native_pte_val(pte) & PTE_FLAGS_MASK;
+	return pte.pte;
 }
 
 #define pgprot_val(x)	((x).pgprot)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index d90272e..4780367 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -462,6 +462,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 #endif
 #endif /* PAGETABLE_LEVELS >= 3 */
 
+	.pte_flags = native_pte_flags,
 	.pte_val = PTE_IDENT,
 	.pgd_val = PTE_IDENT,
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 87f6673..5b79048 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -412,6 +412,16 @@ static pteval_t iomap_pte(pteval_t val)
 	return val;
 }
 
+static pteval_t xen_pte_flags(pte_t pte)
+{
+	pteval_t pteval = pte.pte;
+
+	/* If this is a WC pte, convert back from Xen WC to Linux WC */
+	if ((pteval & (_PAGE_PAT | _PAGE_PCD | _PAGE_PWT)) == _PAGE_PAT)
+		pteval = (pteval & ~_PAGE_PAT) | _PAGE_PWT;
+	return pteval;
+}
+
 static pteval_t xen_pte_val(pte_t pte)
 {
 	pteval_t pteval = pte.pte;
@@ -1975,6 +1985,8 @@ static void __init xen_post_allocator_init(void)
 	pv_mmu_ops.release_pud = xen_release_pud;
 #endif
 
+	if (!pat_enabled)
+		pv_mmu_ops.pte_flags = native_pte_flags;
 #ifdef CONFIG_X86_64
 	SetPagePinned(virt_to_page(level3_user_vsyscall));
 #endif
@@ -2023,6 +2035,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
+	.pte_flags = xen_pte_flags,
 	.pte_val = PV_CALLEE_SAVE(xen_pte_val),
 	.pgd_val = PV_CALLEE_SAVE(xen_pgd_val),
 
-- 
1.7.7.3


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch"

>From 7e218b96dc908362afb501755f3f4b8ec530b700 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 28 Nov 2011 17:58:38 -0500
Subject: x86/paravirt/xen: Optimize pte_flags by marking it as
 paravirt_ident_[32|64] type.

Which means that we have to use:
 __PV_IS_CALLEE_SAVE(_paravirt_ident_64)
which requires that the pte_flags on the 'pv_mmu_ops' structure
be defined as struct paravirt_callee_save. We end up using the
_paravirt_ident_64 function for both baremetal and for Xen guests
that have PAT disabled. For those that have pat_enabled, we end
up calling xen_pte_flags.

The big benefit of making the .pte_flags as struct paravirt_callee_save
and making it PTE_IDENT is that while the code looks as so when compiled:

  ff 14 25 e8 52 c1 81 	callq  *0xffffffff81c152e8

That however, on baremetal and under Xen when !pat_enable ends up
being patched over (by using the DEF_NATIVE macro) to be:

   48 89 f8             	mov    %rdi,%rax
   66 66 66 90          	data32 data32 xchg %ax,%ax

(the 32-bit version is of course different).
For details refer to 'paravirt_patch_ident_64' function.

The Xen version which requires pat_enable==1, ends up patched
to be:

	call xen_pte_flags;

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/paravirt.h       |   11 ++++++++++-
 arch/x86/include/asm/paravirt_types.h |    2 +-
 arch/x86/kernel/paravirt.c            |    2 +-
 arch/x86/xen/mmu.c                    |   11 +++++++++--
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6533409..b113feb 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -464,7 +464,16 @@ static inline void pmd_update_defer(struct mm_struct *mm, unsigned long addr,
 
 static inline pteval_t pte_flags(pte_t pte)
 {
-	return pv_mmu_ops.pte_flags(pte) & PTE_FLAGS_MASK;
+	pteval_t ret;
+
+	if (sizeof(pteval_t) > sizeof(long))
+		ret =  PVOP_CALLEE2(pteval_t, pv_mmu_ops.pte_flags,
+				    pte.pte, (u64)pte.pte >> 32);
+	else
+		ret =  PVOP_CALLEE1(pteval_t, pv_mmu_ops.pte_flags,
+				    pte.pte);
+
+	return ret & PTE_FLAGS_MASK;
 }
 
 static inline pte_t __pte(pteval_t val)
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 86bce9d..5890cd7c 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -288,7 +288,7 @@ struct pv_mmu_ops {
 	void (*ptep_modify_prot_commit)(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, pte_t pte);
 
-	pteval_t (*pte_flags)(pte_t pte);
+	struct paravirt_callee_save pte_flags;
 	struct paravirt_callee_save pte_val;
 	struct paravirt_callee_save make_pte;
 
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 4780367..ba22188 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -462,7 +462,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 #endif
 #endif /* PAGETABLE_LEVELS >= 3 */
 
-	.pte_flags = native_pte_flags,
+	.pte_flags = PTE_IDENT,
 	.pte_val = PTE_IDENT,
 	.pgd_val = PTE_IDENT,
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5b79048..24e275a 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1965,6 +1965,13 @@ void __init xen_ident_map_ISA(void)
 	xen_flush_tlb();
 }
 
+#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_PAE)
+/* 32-bit pagetable entries */
+#define PTE_IDENT	__PV_IS_CALLEE_SAVE(_paravirt_ident_32)
+#else
+/* 64-bit pagetable entries */
+#define PTE_IDENT	__PV_IS_CALLEE_SAVE(_paravirt_ident_64)
+#endif
 static void __init xen_post_allocator_init(void)
 {
 	pv_mmu_ops.set_pte = xen_set_pte;
@@ -1986,7 +1993,7 @@ static void __init xen_post_allocator_init(void)
 #endif
 
 	if (!pat_enabled)
-		pv_mmu_ops.pte_flags = native_pte_flags;
+		pv_mmu_ops.pte_flags = PTE_IDENT;
 #ifdef CONFIG_X86_64
 	SetPagePinned(virt_to_page(level3_user_vsyscall));
 #endif
@@ -2035,7 +2042,7 @@ static const struct pv_mmu_ops xen_mmu_ops __initconst = {
 	.ptep_modify_prot_start = __ptep_modify_prot_start,
 	.ptep_modify_prot_commit = __ptep_modify_prot_commit,
 
-	.pte_flags = xen_pte_flags,
+	.pte_flags = __PV_IS_CALLEE_SAVE(xen_pte_flags),
 	.pte_val = PV_CALLEE_SAVE(xen_pte_val),
 	.pgd_val = PV_CALLEE_SAVE(xen_pgd_val),
 
-- 
1.7.7.3


--YiEDa0DAkWCtVeE4--
