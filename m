Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2KGJ5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:57:41 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:40386 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2KGJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:57:35 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 20/31] ARC: MMU Exception Handling
Date: Wed,  7 Nov 2012 10:47:43 +0100
Message-Id: <1352281674-2186-21-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* MMU I-TLB / D-TLB Miss Exceptions
  - Fast Path TLB Refill Handler
  - slowpath TLB creation via do_page_fault() -> update_mmu_cache()
* Duplicate PD Exception Handler

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h  |   90 ++++++++++
 arch/arc/include/asm/tlb-mmu1.h |  104 ++++++++++++
 arch/arc/include/asm/tlb.h      |   41 +++++
 arch/arc/mm/tlb.c               |  252 ++++++++++++++++++++++++++++
 arch/arc/mm/tlbex.S             |  351 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 838 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/tlb-mmu1.h
 create mode 100644 arch/arc/include/asm/tlb.h
 create mode 100644 arch/arc/mm/tlbex.S

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index c12eb9b..aedfbf1 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -13,6 +13,7 @@
 
 /* Build Configuration Registers */
 #define ARC_REG_VECBASE_BCR	0x68
+#define ARC_REG_MMU_BCR		0x6f
 
 /* status32 Bits Positions */
 #define STATUS_H_BIT		0	/* CPU Halted */
@@ -36,6 +37,34 @@
 #define STATUS_U_MASK		(1<<STATUS_U_BIT)
 #define STATUS_L_MASK		(1<<STATUS_L_BIT)
 
+/*
+ * ECR: Exception Cause Reg bits-n-pieces
+ * [23:16] = Exception Vector
+ * [15: 8] = Exception Cause Code
+ * [ 7: 0] = Exception Parameters (for certain types only)
+ */
+#define ECR_VEC_MASK			0xff0000
+#define ECR_CODE_MASK			0x00ff00
+#define ECR_PARAM_MASK			0x0000ff
+
+/* Exception Cause Vector Values */
+#define ECR_V_MACH_CHK			0x20
+#define ECR_V_ITLB_MISS			0x21
+#define ECR_V_DTLB_MISS			0x22
+#define ECR_V_PROTV			0x23
+
+/* Protection Violation Exception Cause Code Values */
+#define ECR_C_PROTV_INST_FETCH		0x00
+#define ECR_C_PROTV_LOAD		0x01
+#define ECR_C_PROTV_STORE		0x02
+#define ECR_C_PROTV_XCHG		0x03
+#define ECR_C_PROTV_MISALIG_DATA	0x04
+
+/* DTLB Miss Exception Cause Code Values */
+#define ECR_C_BIT_DTLB_LD_MISS		8
+#define ECR_C_BIT_DTLB_ST_MISS		9
+
+
 /* Auxiliary registers */
 #define AUX_IDENTITY		4
 #define AUX_INTR_VEC_BASE	0x25
@@ -58,6 +87,44 @@
 #define TIMER_CTRL_IE		(1 << 0) /* Interupt when Count reachs limit */
 #define TIMER_CTRL_NH		(1 << 1) /* Count only when CPU NOT halted */
 
+#if defined(CONFIG_ARC_MMU_V1)
+#define CONFIG_ARC_MMU_VER 1
+#elif defined(CONFIG_ARC_MMU_V2)
+#define CONFIG_ARC_MMU_VER 2
+#elif defined(CONFIG_ARC_MMU_V3)
+#define CONFIG_ARC_MMU_VER 3
+#else
+#error "Error: MMU ver"
+#endif
+
+/* MMU Management regs */
+#define ARC_REG_TLBPD0		0x405
+#define ARC_REG_TLBPD1		0x406
+#define ARC_REG_TLBINDEX	0x407
+#define ARC_REG_TLBCOMMAND	0x408
+#define ARC_REG_PID		0x409
+#define ARC_REG_SCRATCH_DATA0	0x418
+
+/* Bits in MMU PID register */
+#define MMU_ENABLE		(1 << 31)	/* Enable MMU for process */
+
+/* Error code if probe fails */
+#define TLB_LKUP_ERR		0x80000000
+
+/* TLB Commands */
+#define TLBWrite    0x1
+#define TLBRead     0x2
+#define TLBGetIndex 0x3
+#define TLBProbe    0x4
+
+#if (CONFIG_ARC_MMU_VER >= 2)
+#define TLBWriteNI  0x5		/* write JTLB without inv uTLBs */
+#define TLBIVUTLB   0x6		/* explicitly inv uTLBs */
+#else
+#undef TLBWriteNI		/* These cmds don't exist on older MMU */
+#undef TLBIVUTLB
+#endif
+
 /* Instruction cache related Auxiliary registers */
 #define ARC_REG_IC_BCR		0x77	/* Build Config reg */
 #define ARC_REG_IC_IVIC		0x10
@@ -205,6 +272,24 @@ struct arc_fpu {
  * Build Configuration Registers, with encoded hardware config
  */
 
+struct bcr_mmu_1_2 {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int ver:8, ways:4, sets:4, u_itlb:8, u_dtlb:8;
+#else
+	unsigned int u_dtlb:8, u_itlb:8, sets:4, ways:4, ver:8;
+#endif
+};
+
+struct bcr_mmu_3 {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int ver:8, ways:4, sets:4, osm:1, reserv:3, pg_sz:4,
+		     u_itlb:4, u_dtlb:4;
+#else
+	unsigned int u_dtlb:4, u_itlb:4, pg_sz:4, reserv:3, osm:1, sets:4,
+		     ways:4, ver:8;
+#endif
+};
+
 struct bcr_cache {
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	unsigned int pad:12, line_len:4, sz:4, config:4, ver:8;
@@ -218,12 +303,17 @@ struct bcr_cache {
  * Generic structures to hold build configuration used at runtime
  */
 
+struct cpuinfo_arc_mmu {
+	unsigned int ver, pg_sz, sets, ways, u_dtlb, u_itlb, num_tlb;
+};
+
 struct cpuinfo_arc_cache {
 	unsigned int has_aliasing, sz, line_len, assoc, ver;
 };
 
 struct cpuinfo_arc {
 	struct cpuinfo_arc_cache icache, dcache;
+	struct cpuinfo_arc_mmu mmu;
 };
 
 extern struct cpuinfo_arc cpuinfo_arc700[];
diff --git a/arch/arc/include/asm/tlb-mmu1.h b/arch/arc/include/asm/tlb-mmu1.h
new file mode 100644
index 0000000..a5ff961
--- /dev/null
+++ b/arch/arc/include/asm/tlb-mmu1.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_TLB_MMU_V1_H__
+#define __ASM_TLB_MMU_V1_H__
+
+#if defined(__ASSEMBLY__) && defined(CONFIG_ARC_MMU_VER == 1)
+
+#include <asm/tlb.h>
+
+.macro TLB_WRITE_HEURISTICS
+
+#define JH_HACK1
+#undef JH_HACK2
+#undef JH_HACK3
+
+#ifdef JH_HACK3
+; Calculate set index for 2-way MMU
+; -avoiding use of GetIndex from MMU
+;   and its unpleasant LFSR pseudo-random sequence
+;
+; r1 = TLBPD0 from TLB_RELOAD above
+;
+; -- jh_ex_way_set not cleared on startup
+;    didn't want to change setup.c
+;    hence extra instruction to clean
+;
+; -- should be in cache since in same line
+;    as r0/r1 saves above
+;
+ld  r0,[jh_ex_way_sel]  ; victim pointer
+and r0,r0,1         ; clean
+xor.f   r0,r0,1         ; flip
+st  r0,[jh_ex_way_sel]  ; store back
+asr r0,r1,12        ; get set # <<1, note bit 12=R=0
+or.nz   r0,r0,1         ; set way bit
+and r0,r0,0xff      ; clean
+sr  r0,[ARC_REG_TLBINDEX]
+#endif
+
+#ifdef JH_HACK2
+; JH hack #2
+;  Faster than hack #1 in non-thrash case, but hard-coded for 2-way MMU
+;  Slower in thrash case (where it matters) because more code is executed
+;  Inefficient due to two-register paradigm of this miss handler
+;
+/* r1 = data TLBPD0 at this point */
+lr      r0,[eret]               /* instruction address */
+xor     r0,r0,r1                /* compare set #       */
+and.f   r0,r0,0x000fe000        /* 2-way MMU mask      */
+bne     88f                     /* not in same set - no need to probe */
+
+lr      r0,[eret]               /* instruction address */
+and     r0,r0,PAGE_MASK         /* VPN of instruction address */
+; lr  r1,[ARC_REG_TLBPD0]     /* Data VPN+ASID - already in r1 from TLB_RELOAD*/
+and     r1,r1,0xff              /* Data ASID */
+or      r0,r0,r1                /* Instruction address + Data ASID */
+
+lr      r1,[ARC_REG_TLBPD0]     /* save TLBPD0 containing data TLB*/
+sr      r0,[ARC_REG_TLBPD0]     /* write instruction address to TLBPD0 */
+sr      TLBProbe, [ARC_REG_TLBCOMMAND] /* Look for instruction */
+lr      r0,[ARC_REG_TLBINDEX]   /* r0 = index where instruction is, if at all */
+sr      r1,[ARC_REG_TLBPD0]     /* restore TLBPD0 */
+
+xor     r0,r0,1                 /* flip bottom bit of data index */
+b.d     89f
+sr      r0,[ARC_REG_TLBINDEX]   /* and put it back */
+88:
+sr  TLBGetIndex, [ARC_REG_TLBCOMMAND]
+89:
+#endif
+
+#ifdef JH_HACK1
+;
+; Always checks whether instruction will be kicked out by dtlb miss
+;
+mov_s   r3, r1                  ; save PD0 prepared by TLB_RELOAD in r3
+lr      r0,[eret]               /* instruction address */
+and     r0,r0,PAGE_MASK         /* VPN of instruction address */
+bmsk    r1,r3,7                 /* Data ASID, bits 7-0 */
+or_s    r0,r0,r1                /* Instruction address + Data ASID */
+
+sr      r0,[ARC_REG_TLBPD0]     /* write instruction address to TLBPD0 */
+sr      TLBProbe, [ARC_REG_TLBCOMMAND] /* Look for instruction */
+lr      r0,[ARC_REG_TLBINDEX]   /* r0 = index where instruction is, if at all */
+sr      r3,[ARC_REG_TLBPD0]     /* restore TLBPD0 */
+
+sr      TLBGetIndex, [ARC_REG_TLBCOMMAND]
+lr      r1,[ARC_REG_TLBINDEX]   /* r1 = index where MMU wants to put data */
+cmp     r0,r1                   /* if no match on indices, go around */
+xor.eq  r1,r1,1                 /* flip bottom bit of data index */
+sr      r1,[ARC_REG_TLBINDEX]   /* and put it back */
+#endif
+
+.endm
+
+#endif
+
+#endif
diff --git a/arch/arc/include/asm/tlb.h b/arch/arc/include/asm/tlb.h
new file mode 100644
index 0000000..b571e12
--- /dev/null
+++ b/arch/arc/include/asm/tlb.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ASM_ARC_TLB_H
+#define _ASM_ARC_TLB_H
+
+#ifdef __KERNEL__
+
+#include <asm/pgtable.h>
+
+/* Masks for actual TLB "PD"s */
+#define PTE_BITS_IN_PD0	(_PAGE_GLOBAL | _PAGE_PRESENT)
+#define PTE_BITS_IN_PD1	(PAGE_MASK | _PAGE_CACHEABLE | \
+			 _PAGE_EXECUTE | _PAGE_WRITE | _PAGE_READ | \
+			 _PAGE_K_EXECUTE | _PAGE_K_WRITE | _PAGE_K_READ)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/pagemap.h>
+#include <asm-generic/tlb.h>
+
+#ifdef CONFIG_ARC_DBG_TLB_PARANOIA
+void tlb_paranoid_check(unsigned int pid_sw, unsigned long address);
+#else
+#define tlb_paranoid_check(a, b)
+#endif
+
+void arc_mmu_init(void);
+extern char *arc_mmu_mumbojumbo(int cpu_id, char *buf, int len);
+void __init read_decode_mmu_bcr(void);
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* __KERNEL__ */
+
+#endif /* _ASM_ARC_TLB_H */
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index f1edae2..41afc84 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -21,3 +21,255 @@ int asid_cache = FIRST_ASID;
  * see get_new_mmu_context (asm-arc/mmu_context.h)
  */
 struct mm_struct *asid_mm_map[NUM_ASID + 1];
+
+
+/*
+ * Routine to create a TLB entry
+ */
+void create_tlb(struct vm_area_struct *vma, unsigned long address, pte_t *ptep)
+{
+	unsigned long flags;
+	unsigned int idx, asid_or_sasid;
+	unsigned long pd0_flags;
+
+	local_irq_save(flags);
+
+	tlb_paranoid_check(vma->vm_mm->context.asid, address);
+
+	address &= PAGE_MASK;
+
+	/* update this PTE credentials */
+	pte_val(*ptep) |= (_PAGE_PRESENT | _PAGE_ACCESSED);
+
+	/* Create HW TLB entry Flags (in PD0) from PTE Flags */
+#if (CONFIG_ARC_MMU_VER <= 2)
+	pd0_flags = ((pte_val(*ptep) & PTE_BITS_IN_PD0) >> 1);
+#else
+	pd0_flags = ((pte_val(*ptep) & PTE_BITS_IN_PD0));
+#endif
+
+	/* ASID for this task */
+	asid_or_sasid = read_aux_reg(ARC_REG_PID) & 0xff;
+
+	write_aux_reg(ARC_REG_TLBPD0, address | pd0_flags | asid_or_sasid);
+
+	/* Load remaining info in PD1 (Page Frame Addr and Kx/Kw/Kr Flags) */
+	write_aux_reg(ARC_REG_TLBPD1, (pte_val(*ptep) & PTE_BITS_IN_PD1));
+
+	/* First verify if entry for this vaddr+ASID already exists */
+	write_aux_reg(ARC_REG_TLBCOMMAND, TLBProbe);
+	idx = read_aux_reg(ARC_REG_TLBINDEX);
+
+	/*
+	 * If Not already present get a free slot from MMU.
+	 * Otherwise, Probe would have located the entry and set INDEX Reg
+	 * with existing location. This will cause Write CMD to over-write
+	 * existing entry with new PD0 and PD1
+	 */
+	if (likely(idx & TLB_LKUP_ERR))
+		write_aux_reg(ARC_REG_TLBCOMMAND, TLBGetIndex);
+
+	/*
+	 * Commit the Entry to MMU
+	 * It doesnt sound safe to use the TLBWriteNI cmd here
+	 * which doesn't flush uTLBs. I'd rather be safe than sorry.
+	 */
+	write_aux_reg(ARC_REG_TLBCOMMAND, TLBWrite);
+
+	local_irq_restore(flags);
+}
+
+/* arch hook called by core VM at the end of handle_mm_fault( ),
+ * when a new PTE is entered in Page Tables or an existing one
+ * is modified. We aggresively pre-install a TLB entry
+ */
+
+void update_mmu_cache(struct vm_area_struct *vma, unsigned long vaddress,
+		      pte_t *ptep)
+{
+	/* XXX: This definitely seems useless */
+#if 0
+	BUG_ON(!pfn_valid(pte_pfn(*ptep)));
+#endif
+
+	/* XXX: This is useful - but only once during execve - check why?
+	 *  handle_mm_fault()
+	 *      __get_user_pages
+	 *          copy_strings()
+	 *              do_execve()
+	 */
+	if (current->active_mm != vma->vm_mm)
+		return;
+
+	create_tlb(vma, vaddress, ptep);
+}
+
+/* Read the Cache Build Confuration Registers, Decode them and save into
+ * the cpuinfo structure for later use.
+ * No Validation is done here, simply read/convert the BCRs
+ */
+void __init read_decode_mmu_bcr(void)
+{
+	unsigned int tmp;
+	struct bcr_mmu_1_2 *mmu2;	/* encoded MMU2 attr */
+	struct bcr_mmu_3 *mmu3;		/* encoded MMU3 attr */
+	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
+
+	tmp = read_aux_reg(ARC_REG_MMU_BCR);
+	mmu->ver = (tmp >> 24);
+
+	if (mmu->ver <= 2) {
+		mmu2 = (struct bcr_mmu_1_2 *)&tmp;
+		mmu->pg_sz = PAGE_SIZE;
+		mmu->sets = 1 << mmu2->sets;
+		mmu->ways = 1 << mmu2->ways;
+		mmu->u_dtlb = mmu2->u_dtlb;
+		mmu->u_itlb = mmu2->u_itlb;
+	} else {
+		mmu3 = (struct bcr_mmu_3 *)&tmp;
+		mmu->pg_sz = 512 << mmu3->pg_sz;
+		mmu->sets = 1 << mmu3->sets;
+		mmu->ways = 1 << mmu3->ways;
+		mmu->u_dtlb = mmu3->u_dtlb;
+		mmu->u_itlb = mmu3->u_itlb;
+	}
+
+	mmu->num_tlb = mmu->sets * mmu->ways;
+}
+
+void __init arc_mmu_init(void)
+{
+	/*
+	 * ASID mgmt data structures are compile time init
+	 *  asid_cache = FIRST_ASID and asid_mm_map[] all zeroes
+	 */
+
+	local_flush_tlb_all();
+
+	/* Enable the MMU */
+	write_aux_reg(ARC_REG_PID, MMU_ENABLE);
+}
+
+/*
+ * TLB Programmer's Model uses Linear Indexes: 0 to {255, 511} for 128 x {2,4}
+ * The mapping is Column-first.
+ *		---------------------	-----------
+ *		|way0|way1|way2|way3|	|way0|way1|
+ *		---------------------	-----------
+ * [set0]	|  0 |  1 |  2 |  3 |	|  0 |  1 |
+ * [set1]	|  4 |  5 |  6 |  7 |	|  2 |  3 |
+ *		~		    ~	~	  ~
+ * [set127]	| 508| 509| 510| 511|	| 254| 255|
+ *		---------------------	-----------
+ * For normal operations we don't(must not) care how above works since
+ * MMU cmd getIndex(vaddr) abstracts that out.
+ * However for walking WAYS of a SET, we need to know this
+ */
+#define SET_WAY_TO_IDX(mmu, set, way)  ((set) * mmu->ways + (way))
+
+/* Handling of Duplicate PD (TLB entry) in MMU.
+ * -Could be due to buggy customer tapeouts or obscure kernel bugs
+ * -MMU complaints not at the time of duplicate PD installation, but at the
+ *      time of lookup matching multiple ways.
+ * -Ideally these should never happen - but if they do - workaround by deleting
+ *      the duplicate one.
+ * -Knob to be verbose abt it.(TODO: hook them up to debugfs)
+ */
+volatile int dup_pd_verbose = 1;/* Be slient abt it or complain (default) */
+
+void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
+			  struct pt_regs *regs)
+{
+	int set, way, n;
+	unsigned int pd0[4], pd1[4];	/* assume max 4 ways */
+	unsigned long flags, is_valid;
+	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
+
+	local_irq_save(flags);
+
+	/* re-enable the MMU */
+	write_aux_reg(ARC_REG_PID, MMU_ENABLE | read_aux_reg(ARC_REG_PID));
+
+	/* loop thru all sets of TLB */
+	for (set = 0; set < mmu->sets; set++) {
+
+		/* read out all the ways of current set */
+		for (way = 0, is_valid = 0; way < mmu->ways; way++) {
+			write_aux_reg(ARC_REG_TLBINDEX,
+					  SET_WAY_TO_IDX(mmu, set, way));
+			write_aux_reg(ARC_REG_TLBCOMMAND, TLBRead);
+			pd0[way] = read_aux_reg(ARC_REG_TLBPD0);
+			pd1[way] = read_aux_reg(ARC_REG_TLBPD1);
+			is_valid |= pd0[way] & _PAGE_PRESENT;
+		}
+
+		/* If all the WAYS in SET are empty, skip to next SET */
+		if (!is_valid)
+			continue;
+
+		/* Scan the set for duplicate ways: needs a nested loop */
+		for (way = 0; way < mmu->ways; way++) {
+			if (!pd0[way])
+				continue;
+
+			for (n = way + 1; n < mmu->ways; n++) {
+				if ((pd0[way] & PAGE_MASK) ==
+				    (pd0[n] & PAGE_MASK)) {
+
+					if (dup_pd_verbose) {
+						pr_info("Duplicate PD's @"
+							"[%d:%d]/[%d:%d]\n",
+						     set, way, set, n);
+						pr_info("TLBPD0[%u]: %08x\n",
+						     way, pd0[way]);
+					}
+
+					/*
+					 * clear entry @way and not @n. This is
+					 * critical to our optimised loop
+					 */
+					pd0[way] = pd1[way] = 0;
+					write_aux_reg(ARC_REG_TLBINDEX,
+						SET_WAY_TO_IDX(mmu, set, way));
+					__tlb_entry_erase();
+				}
+			}
+		}
+	}
+
+	local_irq_restore(flags);
+}
+
+/***********************************************************************
+ * Diagnostic Routines
+ *  -Called from Low Level TLB Hanlders if things don;t look good
+ **********************************************************************/
+
+#ifdef CONFIG_ARC_DBG_TLB_PARANOIA
+
+/*
+ * Low Level ASM TLB handler calls this if it finds that HW and SW ASIDS
+ * don't match
+ */
+void print_asid_mismatch(int is_fast_path)
+{
+	int pid_sw, pid_hw;
+	pid_sw = current->active_mm->context.asid;
+	pid_hw = read_aux_reg(ARC_REG_PID) & 0xff;
+
+	pr_emerg("ASID Mismatch in %s Path Handler: sw-pid=0x%x hw-pid=0x%x\n",
+	       is_fast_path ? "Fast" : "Slow", pid_sw, pid_hw);
+
+	__asm__ __volatile__("flag 1");
+}
+
+void tlb_paranoid_check(unsigned int pid_sw, unsigned long addr)
+{
+	unsigned int pid_hw;
+
+	pid_hw = read_aux_reg(ARC_REG_PID) & 0xff;
+
+	if (addr < 0x70000000 && ((pid_hw != pid_sw) || (pid_sw == NO_ASID)))
+		print_asid_mismatch(0);
+}
+#endif
diff --git a/arch/arc/mm/tlbex.S b/arch/arc/mm/tlbex.S
new file mode 100644
index 0000000..fc5b971
--- /dev/null
+++ b/arch/arc/mm/tlbex.S
@@ -0,0 +1,351 @@
+/*
+ * TLB Exception Handling for ARC
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Vineetg: April 2011 :
+ *  -MMU v1: moved out legacy code into a seperate file
+ *  -MMU v3: PD{0,1} bits layout changed: They don't overlap anymore,
+ *      helps avoid a shift when preparing PD0 from PTE
+ *
+ * Vineetg: July 2009
+ *  -For MMU V2, we need not do heuristics at the time of commiting a D-TLB
+ *   entry, so that it doesn't knock out it's I-TLB entry
+ *  -Some more fine tuning:
+ *   bmsk instead of add, asl.cc instead of branch, delay slot utilise etc
+ *
+ * Vineetg: July 2009
+ *  -Practically rewrote the I/D TLB Miss handlers
+ *   Now 40 and 135 instructions a peice as compared to 131 and 449 resp.
+ *   Hence Leaner by 1.5 K
+ *   Used Conditional arithmetic to replace excessive branching
+ *   Also used short instructions wherever possible
+ *
+ * Vineetg: Aug 13th 2008
+ *  -Passing ECR (Exception Cause REG) to do_page_fault( ) for printing
+ *   more information in case of a Fatality
+ *
+ * Vineetg: March 25th Bug #92690
+ *  -Added Debug Code to check if sw-ASID == hw-ASID
+
+ * Rahul Trivedi, Amit Bhor: Codito Technologies 2004
+ */
+
+	.cpu A7
+
+#include <linux/linkage.h>
+#include <asm/entry.h>
+#include <asm/tlb.h>
+#include <asm/pgtable.h>
+#include <asm/arcregs.h>
+#include <asm/cache.h>
+#include <asm/processor.h>
+#if (CONFIG_ARC_MMU_VER == 1)
+#include <asm/tlb-mmu1.h>
+#endif
+
+;--------------------------------------------------------------------------
+; scratch memory to save the registers (r0-r3) used to code TLB refill Handler
+; For details refer to comments before TLBMISS_FREEUP_REGS below
+;--------------------------------------------------------------------------
+
+	.section .data
+	.global ex_saved_reg1
+	.align 1 << L1_CACHE_SHIFT	; IMP: Must be Cache Line aligned
+	.type   ex_saved_reg1, @object
+	.size   ex_saved_reg1, 16
+ex_saved_reg1:
+	.zero 16
+
+;============================================================================
+;  Troubleshooting Stuff
+;============================================================================
+
+; Linux keeps ASID (Address Space ID) in task->active_mm->context.asid
+; When Creating TLB Entries, instead of doing 3 dependent loads from memory,
+; we use the MMU PID Reg to get current ASID.
+; In bizzare scenrios SW and HW ASID can get out-of-sync which is trouble.
+; So we try to detect this in TLB Mis shandler
+
+
+.macro DBG_ASID_MISMATCH
+
+#ifdef CONFIG_ARC_DBG_TLB_PARANOIA
+
+	; make sure h/w ASID is same as s/w ASID
+
+	GET_CURR_TASK_ON_CPU  r3
+	ld r0, [r3, TASK_ACT_MM]
+	ld r0, [r0, MM_CTXT+MM_CTXT_ASID]
+
+	lr r1, [ARC_REG_PID]
+	and r1, r1, 0xFF
+	breq r1, r0, 5f
+
+	; Error if H/w and S/w ASID don't match, but NOT if in kernel mode
+	lr  r0, [erstatus]
+	bbit0 r0, STATUS_U_BIT, 5f
+
+	; We sure are in troubled waters, Flag the error, but to do so
+	; need to switch to kernel mode stack to call error routine
+	GET_TSK_STACK_BASE   r3, sp
+
+	; Call printk to shoutout aloud
+	mov r0, 1
+	j print_asid_mismatch
+
+5:   ; ASIDs match so proceed normally
+	nop
+
+#endif
+
+.endm
+
+;============================================================================
+;TLB Miss handling Code
+;============================================================================
+
+;-----------------------------------------------------------------------------
+; This macro does the page-table lookup for the faulting address.
+; OUT: r0 = PTE faulted on, r1 = ptr to PTE, r2 = Faulting V-address
+.macro LOAD_FAULT_PTE
+
+	lr  r2, [efa]
+
+	lr  r1, [ARC_REG_SCRATCH_DATA0] ; current pgd
+
+	lsr     r0, r2, PGDIR_SHIFT     ; Bits for indexing into PGD
+	ld.as   r1, [r1, r0]            ; PGD entry corresp to faulting addr
+	and.f   r1, r1, PAGE_MASK       ; Ignoring protection and other flags
+	;   contains Ptr to Page Table
+	bz.d    do_slow_path_pf         ; if no Page Table, do page fault
+
+	; Get the PTE entry: The idea is
+	; (1) x = addr >> PAGE_SHIFT 	-> masks page-off bits from @fault-addr
+	; (2) y = x & (PTRS_PER_PTE - 1) -> to get index
+	; (3) z = pgtbl[y]
+	; To avoid the multiply by in end, we do the -2, <<2 below
+
+	lsr     r0, r2, (PAGE_SHIFT - 2)
+	and     r0, r0, ( (PTRS_PER_PTE - 1) << 2)
+	ld.aw   r0, [r1, r0]            ; get PTE and PTE ptr for fault addr
+
+.endm
+
+;-----------------------------------------------------------------
+; Convert Linux PTE entry into TLB entry
+; A one-word PTE entry is programmed as two-word TLB Entry [PD0:PD1] in mmu
+; IN: r0 = PTE, r1 = ptr to PTE
+
+.macro CONV_PTE_TO_TLB
+	and r3, r0, PTE_BITS_IN_PD1 ; Extract permission flags+PFN from PTE
+	sr  r3, [ARC_REG_TLBPD1]    ; these go in PD1
+
+	and r2, r0, PTE_BITS_IN_PD0 ; Extract other PTE flags: (V)alid, (G)lb
+#if (CONFIG_ARC_MMU_VER <= 2)   /* Neednot be done with v3 onwards */
+	lsr r2, r2                  ; shift PTE flags to match layout in PD0
+#endif
+
+	lr  r3,[ARC_REG_TLBPD0]     ; MMU prepares PD0 with vaddr and asid
+
+	or  r3, r3, r2              ; S | vaddr | {sasid|asid}
+	sr  r3,[ARC_REG_TLBPD0]     ; rewrite PD0
+.endm
+
+;-----------------------------------------------------------------
+; Commit the TLB entry into MMU
+
+.macro COMMIT_ENTRY_TO_MMU
+
+	/* Get free TLB slot: Set = computed from vaddr, way = random */
+	sr  TLBGetIndex, [ARC_REG_TLBCOMMAND]
+
+	/* Commit the Write */
+#if (CONFIG_ARC_MMU_VER >= 2)   /* introduced in v2 */
+	sr TLBWriteNI, [ARC_REG_TLBCOMMAND]
+#else
+	sr TLBWrite, [ARC_REG_TLBCOMMAND]
+#endif
+.endm
+
+;-----------------------------------------------------------------
+; ARC700 Exception Handling doesn't auto-switch stack and it only provides
+; ONE scratch AUX reg "ARC_REG_SCRATCH_DATA0"
+;
+; For Non-SMP, the scratch AUX reg is repurposed to cache task PGD, so a
+; "global" is used to free-up FIRST core reg to be able to code the rest of
+; exception prologue (IRQ auto-disabled on Exceptions, so it's IRQ-safe).
+; Since the Fast Path TLB Miss handler is coded with 4 regs, the remaining 3
+; need to be saved as well by extending the "global" to be 4 words. Hence
+;	".size   ex_saved_reg1, 16"
+; [All of this dance is to avoid stack switching for each TLB Miss, since we
+; only need to save only a handful of regs, as opposed to complete reg file]
+
+; As simple as that....
+
+.macro TLBMISS_FREEUP_REGS
+	st    r0, [@ex_saved_reg1]
+	mov_s r0, @ex_saved_reg1
+	st_s  r1, [r0, 4]
+	st_s  r2, [r0, 8]
+	st_s  r3, [r0, 12]
+
+	; VERIFY if the ASID in MMU-PID Reg is same as
+	; one in Linux data structures
+
+	DBG_ASID_MISMATCH
+.endm
+
+;-----------------------------------------------------------------
+.macro TLBMISS_RESTORE_REGS
+	mov_s r0, @ex_saved_reg1
+	ld_s  r3, [r0,12]
+	ld_s  r2, [r0, 8]
+	ld_s  r1, [r0, 4]
+	ld_s  r0, [r0]
+.endm
+
+.section .text, "ax",@progbits	;Fast Path Code, candidate for ICCM
+
+;-----------------------------------------------------------------------------
+; I-TLB Miss Exception Handler
+;-----------------------------------------------------------------------------
+
+ARC_ENTRY EV_TLBMissI
+
+	TLBMISS_FREEUP_REGS
+
+	;----------------------------------------------------------------
+	; Get the PTE corresponding to V-addr accessed
+	LOAD_FAULT_PTE
+
+	;----------------------------------------------------------------
+	; VERIFY_PTE: Check if PTE permissions approp for executing code
+	cmp_s   r2, VMALLOC_START
+	mov.lo  r2, (_PAGE_PRESENT | _PAGE_READ | _PAGE_EXECUTE)
+	mov.hs  r2, (_PAGE_PRESENT | _PAGE_K_READ | _PAGE_K_EXECUTE)
+
+	and     r3, r0, r2  ; Mask out NON Flag bits from PTE
+	xor.f   r3, r3, r2  ; check ( ( pte & flags_test ) == flags_test )
+	bnz     do_slow_path_pf
+
+	; Let Linux VM know that the page was accessed
+	or      r0, r0, (_PAGE_PRESENT | _PAGE_ACCESSED)  ; set Accessed Bit
+	st_s    r0, [r1]                                  ; Write back PTE
+
+	CONV_PTE_TO_TLB
+	COMMIT_ENTRY_TO_MMU
+	TLBMISS_RESTORE_REGS
+	rtie
+
+ARC_EXIT EV_TLBMissI
+
+;-----------------------------------------------------------------------------
+; D-TLB Miss Exception Handler
+;-----------------------------------------------------------------------------
+
+ARC_ENTRY EV_TLBMissD
+
+	TLBMISS_FREEUP_REGS
+
+	;----------------------------------------------------------------
+	; Get the PTE corresponding to V-addr accessed
+	; If PTE exists, it will setup, r0 = PTE, r1 = Ptr to PTE
+	LOAD_FAULT_PTE
+
+	;----------------------------------------------------------------
+	; VERIFY_PTE: Chk if PTE permissions approp for data access (R/W/R+W)
+
+	mov_s   r2, 0
+	lr      r3, [ecr]
+	btst_s  r3, ECR_C_BIT_DTLB_LD_MISS	; Read Access
+	or.nz   r2, r2, _PAGE_READ      	; chk for Read flag in PTE
+	btst_s  r3, ECR_C_BIT_DTLB_ST_MISS	; Write Access
+	or.nz   r2, r2, _PAGE_WRITE     	; chk for Write flag in PTE
+	; Above laddering takes care of XCHG access
+	;   which is both Read and Write
+
+	; If kernel mode access, ; make _PAGE_xx flags as _PAGE_K_xx
+	; For copy_(to|from)_user, despite exception taken in kernel mode,
+	; this code is not hit, because EFA would still be the user mode
+	; address (EFA < 0x6000_0000).
+	; This code is for legit kernel mode faults, vmalloc specifically
+	; (EFA: 0x7000_0000 to 0x7FFF_FFFF)
+
+	lr      r3, [efa]
+	cmp     r3, VMALLOC_START - 1   ; If kernel mode access
+	asl.hi  r2, r2, 3               ; make _PAGE_xx flags as _PAGE_K_xx
+	or      r2, r2, _PAGE_PRESENT   ; Common flag for K/U mode
+
+	; By now, r2 setup with all the Flags we need to check in PTE
+	and     r3, r0, r2              ; Mask out NON Flag bits from PTE
+	brne.d  r3, r2, do_slow_path_pf ; is ((pte & flags_test) == flags_test)
+
+	;----------------------------------------------------------------
+	; UPDATE_PTE: Let Linux VM know that page was accessed/dirty
+	lr      r3, [ecr]
+	or      r0, r0, (_PAGE_PRESENT | _PAGE_ACCESSED) ; Accessed bit always
+	btst_s  r3,  ECR_C_BIT_DTLB_ST_MISS   ; See if it was a Write Access ?
+	or.nz   r0, r0, _PAGE_MODIFIED        ; if Write, set Dirty bit as well
+	st_s    r0, [r1]                      ; Write back PTE
+
+	CONV_PTE_TO_TLB
+
+#if (CONFIG_ARC_MMU_VER == 1)
+	; MMU with 2 way set assoc J-TLB, needs some help in pathetic case of
+	; memcpy where 3 parties contend for 2 ways, ensuing a livelock.
+	; But only for old MMU or one with Metal Fix
+	TLB_WRITE_HEURISTICS
+#endif
+
+	COMMIT_ENTRY_TO_MMU
+	TLBMISS_RESTORE_REGS
+	rtie
+
+;-------- Common routine to call Linux Page Fault Handler -----------
+do_slow_path_pf:
+
+	; Restore the 4-scratch regs saved by fast path miss handler
+	TLBMISS_RESTORE_REGS
+
+	; Slow path TLB Miss handled as a regular ARC Exception
+	; (stack switching / save the complete reg-file).
+	; That requires freeing up r9
+	EXCPN_PROLOG_FREEUP_REG r9
+
+	lr  r9, [erstatus]
+
+	SWITCH_TO_KERNEL_STK
+	SAVE_ALL_SYS
+
+	; ------- setup args for Linux Page fault Hanlder ---------
+	mov_s r0, sp
+	lr  r2, [efa]
+	lr  r3, [ecr]
+
+	; Both st and ex imply WRITE access of some sort, hence do_page_fault( )
+	; invoked with write=1 for DTLB-st/ex Miss and write=0 for ITLB miss or
+	; DTLB-ld Miss
+	; DTLB Miss Cause code is ld = 0x01 , st = 0x02, ex = 0x03
+	; Following code uses that fact that st/ex have one bit in common
+
+	btst_s r3,  ECR_C_BIT_DTLB_ST_MISS
+	mov.z  r1, 0
+	mov.nz r1, 1
+
+	; We don't want exceptions to be disabled while the fault is handled.
+	; Now that we have saved the context we return from exception hence
+	; exceptions get re-enable
+
+	FAKE_RET_FROM_EXCPN  r9
+
+	bl  do_page_fault
+	b   ret_from_exception
+
+ARC_EXIT EV_TLBMissD
+
+ARC_ENTRY EV_TLBMissB   ; Bogus entry to measure sz of DTLBMiss hdlr
-- 
1.7.4.1

