Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1HNQJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:09:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab1HNQJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:09:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:58 2011
Message-Id: <20110812210558.603730835@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [74/90] sparc: Access kernel TSB using physical addressing when possible.
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 9076d0e7e02b98f7a65df10d1956326c8d8ba61a ]

On sun4v this is basically required since we point the hypervisor and
the TSB walking hardware at these tables using physical addressing
too.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/tsb.h    |   51 ++++++++++++++++++----------------------
 arch/sparc/kernel/ktlb.S        |   24 +++++++++---------
 arch/sparc/kernel/vmlinux.lds.S |   10 +++++++
 arch/sparc/mm/init_64.c         |   40 ++++++++++++++++++++++++++++++-
 4 files changed, 85 insertions(+), 40 deletions(-)

--- a/arch/sparc/include/asm/tsb.h
+++ b/arch/sparc/include/asm/tsb.h
@@ -133,29 +133,6 @@ extern struct tsb_phys_patch_entry __tsb
 	sub	TSB, 0x8, TSB;   \
 	TSB_STORE(TSB, TAG);
 
-#define KTSB_LOAD_QUAD(TSB, REG) \
-	ldda		[TSB] ASI_NUCLEUS_QUAD_LDD, REG;
-
-#define KTSB_STORE(ADDR, VAL) \
-	stxa		VAL, [ADDR] ASI_N;
-
-#define KTSB_LOCK_TAG(TSB, REG1, REG2)	\
-99:	lduwa	[TSB] ASI_N, REG1;	\
-	sethi	%hi(TSB_TAG_LOCK_HIGH), REG2;\
-	andcc	REG1, REG2, %g0;	\
-	bne,pn	%icc, 99b;		\
-	 nop;				\
-	casa	[TSB] ASI_N, REG1, REG2;\
-	cmp	REG1, REG2;		\
-	bne,pn	%icc, 99b;		\
-	 nop;				\
-
-#define KTSB_WRITE(TSB, TTE, TAG) \
-	add	TSB, 0x8, TSB;   \
-	stxa	TTE, [TSB] ASI_N;     \
-	sub	TSB, 0x8, TSB;   \
-	stxa	TAG, [TSB] ASI_N;
-
 	/* Do a kernel page table walk.  Leaves physical PTE pointer in
 	 * REG1.  Jumps to FAIL_LABEL on early page table walk termination.
 	 * VADDR will not be clobbered, but REG2 will.
@@ -239,6 +216,8 @@ extern struct tsb_phys_patch_entry __tsb
 	(KERNEL_TSB_SIZE_BYTES / 16)
 #define KERNEL_TSB4M_NENTRIES	4096
 
+#define KTSB_PHYS_SHIFT		15
+
 	/* Do a kernel TSB lookup at tl>0 on VADDR+TAG, branch to OK_LABEL
 	 * on TSB hit.  REG1, REG2, REG3, and REG4 are used as temporaries
 	 * and the found TTE will be left in REG1.  REG3 and REG4 must
@@ -247,13 +226,22 @@ extern struct tsb_phys_patch_entry __tsb
 	 * VADDR and TAG will be preserved and not clobbered by this macro.
 	 */
 #define KERN_TSB_LOOKUP_TL1(VADDR, TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
-	sethi		%hi(swapper_tsb), REG1; \
+661:	sethi		%hi(swapper_tsb), REG1;			\
 	or		REG1, %lo(swapper_tsb), REG1; \
+	.section	.swapper_tsb_phys_patch, "ax"; \
+	.word		661b; \
+	.previous; \
+661:	nop; \
+	.section	.tsb_ldquad_phys_patch, "ax"; \
+	.word		661b; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	.previous; \
 	srlx		VADDR, PAGE_SHIFT, REG2; \
 	and		REG2, (KERNEL_TSB_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
 	add		REG1, REG2, REG2; \
-	KTSB_LOAD_QUAD(REG2, REG3); \
+	TSB_LOAD_QUAD(REG2, REG3); \
 	cmp		REG3, TAG; \
 	be,a,pt		%xcc, OK_LABEL; \
 	 mov		REG4, REG1;
@@ -263,12 +251,21 @@ extern struct tsb_phys_patch_entry __tsb
 	 * we can make use of that for the index computation.
 	 */
 #define KERN_TSB4M_LOOKUP_TL1(TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
-	sethi		%hi(swapper_4m_tsb), REG1; \
+661:	sethi		%hi(swapper_4m_tsb), REG1;	     \
 	or		REG1, %lo(swapper_4m_tsb), REG1; \
+	.section	.swapper_4m_tsb_phys_patch, "ax"; \
+	.word		661b; \
+	.previous; \
+661:	nop; \
+	.section	.tsb_ldquad_phys_patch, "ax"; \
+	.word		661b; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	sllx		REG1, KTSB_PHYS_SHIFT, REG1; \
+	.previous; \
 	and		TAG, (KERNEL_TSB4M_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
 	add		REG1, REG2, REG2; \
-	KTSB_LOAD_QUAD(REG2, REG3); \
+	TSB_LOAD_QUAD(REG2, REG3); \
 	cmp		REG3, TAG; \
 	be,a,pt		%xcc, OK_LABEL; \
 	 mov		REG4, REG1;
--- a/arch/sparc/kernel/ktlb.S
+++ b/arch/sparc/kernel/ktlb.S
@@ -47,16 +47,16 @@ kvmap_itlb_tsb_miss:
 kvmap_itlb_vmalloc_addr:
 	KERN_PGTABLE_WALK(%g4, %g5, %g2, kvmap_itlb_longpath)
 
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
 
 	/* Load and check PTE.  */
 	ldxa		[%g5] ASI_PHYS_USE_EC, %g5
 	mov		1, %g7
 	sllx		%g7, TSB_TAG_INVALID_BIT, %g7
 	brgez,a,pn	%g5, kvmap_itlb_longpath
-	 KTSB_STORE(%g1, %g7)
+	 TSB_STORE(%g1, %g7)
 
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
 
 	/* fallthrough to TLB load */
 
@@ -102,9 +102,9 @@ kvmap_itlb_longpath:
 kvmap_itlb_obp:
 	OBP_TRANS_LOOKUP(%g4, %g5, %g2, %g3, kvmap_itlb_longpath)
 
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
 
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
 
 	ba,pt		%xcc, kvmap_itlb_load
 	 nop
@@ -112,17 +112,17 @@ kvmap_itlb_obp:
 kvmap_dtlb_obp:
 	OBP_TRANS_LOOKUP(%g4, %g5, %g2, %g3, kvmap_dtlb_longpath)
 
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
 
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
 
 	ba,pt		%xcc, kvmap_dtlb_load
 	 nop
 
 	.align		32
 kvmap_dtlb_tsb4m_load:
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_WRITE(%g1, %g5, %g6)
 	ba,pt		%xcc, kvmap_dtlb_load
 	 nop
 
@@ -222,16 +222,16 @@ kvmap_linear_patch:
 kvmap_dtlb_vmalloc_addr:
 	KERN_PGTABLE_WALK(%g4, %g5, %g2, kvmap_dtlb_longpath)
 
-	KTSB_LOCK_TAG(%g1, %g2, %g7)
+	TSB_LOCK_TAG(%g1, %g2, %g7)
 
 	/* Load and check PTE.  */
 	ldxa		[%g5] ASI_PHYS_USE_EC, %g5
 	mov		1, %g7
 	sllx		%g7, TSB_TAG_INVALID_BIT, %g7
 	brgez,a,pn	%g5, kvmap_dtlb_longpath
-	 KTSB_STORE(%g1, %g7)
+	 TSB_STORE(%g1, %g7)
 
-	KTSB_WRITE(%g1, %g5, %g6)
+	TSB_WRITE(%g1, %g5, %g6)
 
 	/* fallthrough to TLB load */
 
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -107,6 +107,16 @@ SECTIONS
 		*(.sun4v_2insn_patch)
 		__sun4v_2insn_patch_end = .;
 	}
+	.swapper_tsb_phys_patch : {
+		__swapper_tsb_phys_patch = .;
+		*(.swapper_tsb_phys_patch)
+		__swapper_tsb_phys_patch_end = .;
+	}
+	.swapper_4m_tsb_phys_patch : {
+		__swapper_4m_tsb_phys_patch = .;
+		*(.swapper_4m_tsb_phys_patch)
+		__swapper_4m_tsb_phys_patch_end = .;
+	}
 	.popc_3insn_patch : {
 		__popc_3insn_patch = .;
 		*(.popc_3insn_patch)
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1597,6 +1597,42 @@ static void __init tsb_phys_patch(void)
 static struct hv_tsb_descr ktsb_descr[NUM_KTSB_DESCR];
 extern struct tsb swapper_tsb[KERNEL_TSB_NENTRIES];
 
+static void patch_one_ktsb_phys(unsigned int *start, unsigned int *end, unsigned long pa)
+{
+	pa >>= KTSB_PHYS_SHIFT;
+
+	while (start < end) {
+		unsigned int *ia = (unsigned int *)(unsigned long)*start;
+
+		ia[0] = (ia[0] & ~0x3fffff) | (pa >> 10);
+		__asm__ __volatile__("flush	%0" : : "r" (ia));
+
+		ia[1] = (ia[1] & ~0x3ff) | (pa & 0x3ff);
+		__asm__ __volatile__("flush	%0" : : "r" (ia + 1));
+
+		start++;
+	}
+}
+
+static void ktsb_phys_patch(void)
+{
+	extern unsigned int __swapper_tsb_phys_patch;
+	extern unsigned int __swapper_tsb_phys_patch_end;
+	extern unsigned int __swapper_4m_tsb_phys_patch;
+	extern unsigned int __swapper_4m_tsb_phys_patch_end;
+	unsigned long ktsb_pa;
+
+	ktsb_pa = kern_base + ((unsigned long)&swapper_tsb[0] - KERNBASE);
+	patch_one_ktsb_phys(&__swapper_tsb_phys_patch,
+			    &__swapper_tsb_phys_patch_end, ktsb_pa);
+#ifndef CONFIG_DEBUG_PAGEALLOC
+	ktsb_pa = (kern_base +
+		   ((unsigned long)&swapper_4m_tsb[0] - KERNBASE));
+	patch_one_ktsb_phys(&__swapper_4m_tsb_phys_patch,
+			    &__swapper_4m_tsb_phys_patch_end, ktsb_pa);
+#endif
+}
+
 static void __init sun4v_ktsb_init(void)
 {
 	unsigned long ktsb_pa;
@@ -1716,8 +1752,10 @@ void __init paging_init(void)
 		sun4u_pgprot_init();
 
 	if (tlb_type == cheetah_plus ||
-	    tlb_type == hypervisor)
+	    tlb_type == hypervisor) {
 		tsb_phys_patch();
+		ktsb_phys_patch();
+	}
 
 	if (tlb_type == hypervisor) {
 		sun4v_patch_tlb_handlers();


