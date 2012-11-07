Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2KGJtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:49:00 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52596 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2KGJsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:40 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 17/31] ARC: Cache Flush Management
Date: Wed,  7 Nov 2012 10:47:40 +0100
Message-Id: <1352281674-2186-18-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ARC700 has VIPT L1 Caches (L1 only)
* Caches don't snoop and are not coherent
* Given the PAGE_SIZE and Cache associativity, we don't support aliasing
  D$ configurations, but so allow aliasing I$ configs

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/arcregs.h    |   80 ++++
 arch/arc/include/asm/cache.h      |   54 +++
 arch/arc/include/asm/cachectl.h   |   30 ++
 arch/arc/include/asm/cacheflush.h |   67 +++
 arch/arc/mm/cache_arc700.c        |  838 +++++++++++++++++++++++++++++++++++++
 5 files changed, 1069 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/cachectl.h
 create mode 100644 arch/arc/include/asm/cacheflush.h
 create mode 100644 arch/arc/mm/cache_arc700.c

diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index 5131bb3..c6e2805 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -58,6 +58,33 @@
 #define TIMER_CTRL_IE		(1 << 0) /* Interupt when Count reachs limit */
 #define TIMER_CTRL_NH		(1 << 1) /* Count only when CPU NOT halted */
 
+/* Instruction cache related Auxiliary registers */
+#define ARC_REG_IC_BCR		0x77	/* Build Config reg */
+#define ARC_REG_IC_IVIC		0x10
+#define ARC_REG_IC_CTRL		0x11
+#define ARC_REG_IC_IVIL		0x19
+#if (CONFIG_ARC_MMU_VER > 2)
+#define ARC_REG_IC_PTAG		0x1E
+#endif
+
+/* Bit val in IC_CTRL */
+#define IC_CTRL_CACHE_DISABLE   0x1
+
+/* Data cache related Auxiliary registers */
+#define ARC_REG_DC_BCR		0x72
+#define ARC_REG_DC_IVDC		0x47
+#define ARC_REG_DC_CTRL		0x48
+#define ARC_REG_DC_IVDL		0x4A
+#define ARC_REG_DC_FLSH		0x4B
+#define ARC_REG_DC_FLDL		0x4C
+#if (CONFIG_ARC_MMU_VER > 2)
+#define ARC_REG_DC_PTAG		0x5C
+#endif
+
+/* Bit val in DC_CTRL */
+#define DC_CTRL_INV_MODE_FLUSH  0x40
+#define DC_CTRL_FLUSH_STATUS    0x100
+
 /*
  * Floating Pt Registers
  * Status regs are read-only (build-time) so need not be saved/restored
@@ -132,6 +159,31 @@
 
 #endif
 
+#define READ_BCR(reg, into)				\
+{							\
+	unsigned int tmp;				\
+	tmp = read_aux_reg(reg);			\
+	if (sizeof(tmp) == sizeof(into)) {		\
+		into = *((typeof(into) *)&tmp);		\
+	} else {					\
+		extern void bogus_undefined(void);	\
+		bogus_undefined();			\
+	}						\
+}
+
+#define WRITE_BCR(reg, into)				\
+{							\
+	unsigned int tmp;				\
+	if (sizeof(tmp) == sizeof(into)) {		\
+		tmp = (*(unsigned int *)(into));	\
+		write_aux_reg(reg, tmp);		\
+	} else  {					\
+		extern void bogus_undefined(void);	\
+		bogus_undefined();			\
+	}						\
+}
+
+
 #ifdef CONFIG_ARC_FPU_SAVE_RESTORE
 /* These DPFP regs need to be saved/restored across ctx-sw */
 struct arc_fpu {
@@ -141,6 +193,34 @@ struct arc_fpu {
 };
 #endif
 
+/*
+ ***************************************************************
+ * Build Configuration Registers, with encoded hardware config
+ */
+
+struct bcr_cache {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int pad:12, line_len:4, sz:4, config:4, ver:8;
+#else
+	unsigned int ver:8, config:4, sz:4, line_len:4, pad:12;
+#endif
+};
+
+/*
+ *******************************************************************
+ * Generic structures to hold build configuration used at runtime
+ */
+
+struct cpuinfo_arc_cache {
+	unsigned int has_aliasing, sz, line_len, assoc, ver;
+};
+
+struct cpuinfo_arc {
+	struct cpuinfo_arc_cache icache, dcache;
+};
+
+extern struct cpuinfo_arc cpuinfo_arc700[];
+
 #endif /* __ASEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/arch/arc/include/asm/cache.h b/arch/arc/include/asm/cache.h
index 30c72a4..6632273 100644
--- a/arch/arc/include/asm/cache.h
+++ b/arch/arc/include/asm/cache.h
@@ -18,4 +18,58 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define ARC_ICACHE_WAYS	2
+#define ARC_DCACHE_WAYS	4
+
+/* Helpers */
+#define ARC_ICACHE_LINE_LEN	L1_CACHE_BYTES
+#define ARC_DCACHE_LINE_LEN	L1_CACHE_BYTES
+
+#define ICACHE_LINE_MASK	(~(ARC_ICACHE_LINE_LEN - 1))
+#define DCACHE_LINE_MASK	(~(ARC_DCACHE_LINE_LEN - 1))
+
+#if ARC_ICACHE_LINE_LEN != ARC_DCACHE_LINE_LEN
+#error "Need to fix some code as I/D cache lines not same"
+#else
+#define is_not_cache_aligned(p)	((unsigned long)p & (~DCACHE_LINE_MASK))
+#endif
+
+#ifndef __ASSEMBLY__
+
+/* Uncached access macros */
+#define arc_read_uncached_32(ptr)	\
+({					\
+	unsigned int __ret;		\
+	__asm__ __volatile__(		\
+	"	ld.di %0, [%1]	\n"	\
+	: "=r"(__ret)			\
+	: "r"(ptr));			\
+	__ret;				\
+})
+
+#define arc_write_uncached_32(ptr, data)\
+({					\
+	__asm__ __volatile__(		\
+	"	st.di %0, [%1]	\n"	\
+	:				\
+	: "r"(data), "r"(ptr));		\
+})
+
+/* used to give SHMLBA a value to avoid Cache Aliasing */
+extern unsigned int ARC_shmlba;
+
+#define ARCH_DMA_MINALIGN      L1_CACHE_BYTES
+
+/*
+ * ARC700 doesn't cache any access in top 256M.
+ * Ideal for wiring memory mapped peripherals as we don't need to do
+ * explicit uncached accesses (LD.di/ST.di) hence more portable drivers
+ */
+#define ARC_UNCACHED_ADDR_SPACE	0xc0000000
+
+extern void arc_cache_init(void);
+extern char *arc_cache_mumbojumbo(int cpu_id, char *buf, int len);
+extern void __init read_decode_cache_bcr(void);
+#endif
+
 #endif /* _ASM_CACHE_H */
diff --git a/arch/arc/include/asm/cachectl.h b/arch/arc/include/asm/cachectl.h
new file mode 100644
index 0000000..d0ba876
--- /dev/null
+++ b/arch/arc/include/asm/cachectl.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARC_ASM_CACHECTL_H
+#define __ARC_ASM_CACHECTL_H
+
+/*
+ * ARC ABI flags defined for Android's finegrained cacheflush requirements
+ */
+#define CF_I_INV	0x0002
+#define CF_D_FLUSH	0x0010
+#define CF_D_INV	0x0020
+#define CF_D_FLUSH_INV	0x0030
+#define CF_PHY_ADDR	0x1000
+
+#define CF_DEFAULT	(CF_I_INV | CF_D_FLUSH)
+
+/*
+ * Standard flags expected by cacheflush system call users
+ */
+#define ICACHE	CF_I_INV
+#define DCACHE	CF_D_FLUSH
+#define BCACHE	(CF_I_INV | CF_D_FLUSH)
+
+#endif
diff --git a/arch/arc/include/asm/cacheflush.h b/arch/arc/include/asm/cacheflush.h
new file mode 100644
index 0000000..97ee96f
--- /dev/null
+++ b/arch/arc/include/asm/cacheflush.h
@@ -0,0 +1,67 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  vineetg: May 2011: for Non-aliasing VIPT D-cache following can be NOPs
+ *   -flush_cache_dup_mm (fork)
+ *   -likewise for flush_cache_mm (exit/execve)
+ *   -likewise for flush_cache_{range,page} (munmap, exit, COW-break)
+ *
+ *  vineetg: April 2008
+ *   -Added a critical CacheLine flush to copy_to_user_page( ) which
+ *     was causing gdbserver to not setup breakpoints consistently
+ */
+
+#ifndef _ASM_CACHEFLUSH_H
+#define _ASM_CACHEFLUSH_H
+
+#include <linux/mm.h>
+
+void flush_cache_all(void);
+
+void flush_icache_range(unsigned long start, unsigned long end);
+void flush_icache_page(struct vm_area_struct *vma, struct page *page);
+void flush_icache_range_vaddr(unsigned long paddr, unsigned long u_vaddr,
+				     int len);
+
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
+
+void flush_dcache_page(struct page *page);
+
+void dma_cache_wback_inv(unsigned long start, unsigned long sz);
+void dma_cache_inv(unsigned long start, unsigned long sz);
+void dma_cache_wback(unsigned long start, unsigned long sz);
+
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+/* TBD: optimize this */
+#define flush_cache_vmap(start, end)		flush_cache_all()
+#define flush_cache_vunmap(start, end)		flush_cache_all()
+
+/*
+ * VM callbacks when entire/range of user-space V-P mappings are
+ * torn-down/get-invalidated
+ *
+ * Currently we don't support D$ aliasing configs for our VIPT caches
+ * NOPS for VIPT Cache with non-aliasing D$ configurations only
+ */
+#define flush_cache_dup_mm(mm)			/* called on fork */
+#define flush_cache_mm(mm)			/* called on munmap/exit */
+#define flush_cache_range(mm, u_vstart, u_vend)
+#define flush_cache_page(vma, u_vaddr, pfn)	/* PF handling/COW-break */
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)		\
+do {									\
+	memcpy(dst, src, len);						\
+	if (vma->vm_flags & VM_EXEC)					\
+		flush_icache_range_vaddr((unsigned long)(dst), vaddr, len);\
+} while (0)
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len)		\
+	memcpy(dst, src, len);						\
+
+#endif
diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
new file mode 100644
index 0000000..9f8f567
--- /dev/null
+++ b/arch/arc/mm/cache_arc700.c
@@ -0,0 +1,838 @@
+/*
+ * ARC700 VIPT Cache Management
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ *  vineetg: May 2011: for Non-aliasing VIPT D-cache following can be NOPs
+ *   -flush_cache_dup_mm (fork)
+ *   -likewise for flush_cache_mm (exit/execve)
+ *   -likewise for flush_cache_range,flush_cache_page (munmap, exit, COW-break)
+ *
+ * vineetg: Apr 2011
+ *  -Now that MMU can support larger pg sz (16K), the determiniation of
+ *   aliasing shd not be based on assumption of 8k pg
+ *
+ * vineetg: Mar 2011
+ *  -optimised version of flush_icache_range( ) for making I/D coherent
+ *   when vaddr is available (agnostic of num of aliases)
+ *
+ * vineetg: Mar 2011
+ *  -Added documentation about I-cache aliasing on ARC700 and the way it
+ *   was handled up until MMU V2.
+ *  -Spotted a three year old bug when killing the 4 aliases, which needs
+ *   bottom 2 bits, so we need to do paddr | {0x00, 0x01, 0x02, 0x03}
+ *                        instead of paddr | {0x00, 0x01, 0x10, 0x11}
+ *   (Rajesh you owe me one now)
+ *
+ * vineetg: Dec 2010
+ *  -Off-by-one error when computing num_of_lines to flush
+ *   This broke signal handling with bionic which uses synthetic sigret stub
+ *
+ * vineetg: Mar 2010
+ *  -GCC can't generate ZOL for core cache flush loops.
+ *   Conv them into iterations based as opposed to while (start < end) types
+ *
+ * Vineetg: July 2009
+ *  -In I-cache flush routine we used to chk for aliasing for every line INV.
+ *   Instead now we setup routines per cache geometry and invoke them
+ *   via function pointers.
+ *
+ * Vineetg: Jan 2009
+ *  -Cache Line flush routines used to flush an extra line beyond end addr
+ *   because check was while (end >= start) instead of (end > start)
+ *     =Some call sites had to work around by doing -1, -4 etc to end param
+ *     =Some callers didnt care. This was spec bad in case of INV routines
+ *      which would discard valid data (cause of the horrible ext2 bug
+ *      in ARC IDE driver)
+ *
+ * vineetg: June 11th 2008: Fixed flush_icache_range( )
+ *  -Since ARC700 caches are not coherent (I$ doesnt snoop D$) both need
+ *   to be flushed, which it was not doing.
+ *  -load_module( ) passes vmalloc addr (Kernel Virtual Addr) to the API,
+ *   however ARC cache maintenance OPs require PHY addr. Thus need to do
+ *   vmalloc_to_phy.
+ *  -Also added optimisation there, that for range > PAGE SIZE we flush the
+ *   entire cache in one shot rather than line by line. For e.g. a module
+ *   with Code sz 600k, old code flushed 600k worth of cache (line-by-line),
+ *   while cache is only 16 or 32k.
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/cache.h>
+#include <linux/mmu_context.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/cachectl.h>
+#include <asm/setup.h>
+
+
+#ifdef CONFIG_ARC_HAS_ICACHE
+static void __ic_line_inv_no_alias(unsigned long, int);
+static void __ic_line_inv_2_alias(unsigned long, int);
+static void __ic_line_inv_4_alias(unsigned long, int);
+
+/* Holds the ptr to flush routine, dependign on size due to aliasing issues */
+static void (*___flush_icache_rtn) (unsigned long, int);
+#endif
+
+/*
+ * Read the Cache Build Confuration Registers, Decode them and save into
+ * the cpuinfo structure for later use.
+ * No Validation done here, simply read/convert the BCRs
+ */
+void __init read_decode_cache_bcr(void)
+{
+	struct bcr_cache ibcr, dbcr;
+	struct cpuinfo_arc_cache *p_ic, *p_dc;
+	unsigned int cpu = smp_processor_id();
+
+	p_ic = &cpuinfo_arc700[cpu].icache;
+	READ_BCR(ARC_REG_IC_BCR, ibcr);
+
+	if (ibcr.config == 0x3)
+		p_ic->assoc = 2;
+	p_ic->line_len = 8 << ibcr.line_len;
+	p_ic->sz = 0x200 << ibcr.sz;
+	p_ic->ver = ibcr.ver;
+
+	p_dc = &cpuinfo_arc700[cpu].dcache;
+	READ_BCR(ARC_REG_DC_BCR, dbcr);
+
+	if (dbcr.config == 0x2)
+		p_dc->assoc = 4;
+	p_dc->line_len = 16 << dbcr.line_len;
+	p_dc->sz = 0x200 << dbcr.sz;
+	p_dc->ver = dbcr.ver;
+}
+
+/*
+ * 1. Validate the Cache Geomtery (compile time config matches hardware)
+ * 2. If I-cache suffers from aliasing, setup work arounds (difft flush rtn)
+ *    (aliasing D-cache configurations are not supported YET)
+ * 3. Enable the Caches, setup default flush mode for D-Cache
+ * 3. Calculate the SHMLBA used by user space
+ */
+void __init arc_cache_init(void)
+{
+	unsigned int temp;
+#ifdef CONFIG_ARC_CACHE
+	unsigned int cpu = smp_processor_id();
+#endif
+#ifdef CONFIG_ARC_HAS_ICACHE
+	struct cpuinfo_arc_cache *ic;
+#endif
+#ifdef CONFIG_ARC_HAS_DCACHE
+	struct cpuinfo_arc_cache *dc;
+#endif
+	int way_pg_ratio = way_pg_ratio;
+
+#ifdef CONFIG_ARC_HAS_ICACHE
+	ic = &cpuinfo_arc700[cpu].icache;
+
+	/*
+	 * if Cache way size is <= page size then no aliasing exhibited
+	 * otherwise ratio determines num of aliases.
+	 * e.g. 32K I$, 2 way set assoc, 8k pg size
+	 *       way-sz = 32k/2 = 16k
+	 *       way-pg-ratio = 16k/8k = 2, so 2 aliases possible
+	 *       (meaning 1 line could be in 2 possible locations).
+	 */
+	way_pg_ratio = ic->sz / ARC_ICACHE_WAYS / PAGE_SIZE;
+	switch (way_pg_ratio) {
+	case 0:
+	case 1:
+		___flush_icache_rtn = __ic_line_inv_no_alias;
+		break;
+	case 2:
+		___flush_icache_rtn = __ic_line_inv_2_alias;
+		break;
+	case 4:
+		___flush_icache_rtn = __ic_line_inv_4_alias;
+		break;
+	default:
+		panic("Unsupported I-Cache Sz\n");
+	}
+#endif
+
+	/* Enable/disable I-Cache */
+	temp = read_aux_reg(ARC_REG_IC_CTRL);
+
+#ifdef CONFIG_ARC_HAS_ICACHE
+	temp &= ~IC_CTRL_CACHE_DISABLE;
+#else
+	temp |= IC_CTRL_CACHE_DISABLE;
+#endif
+
+	write_aux_reg(ARC_REG_IC_CTRL, temp);
+
+#ifdef CONFIG_ARC_HAS_DCACHE
+	dc = &cpuinfo_arc700[cpu].dcache;
+
+	/* check for D-Cache aliasing */
+	if ((dc->sz / ARC_DCACHE_WAYS) > PAGE_SIZE)
+		panic("D$ aliasing not handled right now\n");
+#endif
+
+	/* Set the default Invalidate Mode to "simpy discard dirty lines"
+	 *  as this is more frequent then flush before invalidate
+	 * Ofcourse we toggle this default behviour when desired
+	 */
+	temp = read_aux_reg(ARC_REG_DC_CTRL);
+	temp &= ~DC_CTRL_INV_MODE_FLUSH;
+
+#ifdef CONFIG_ARC_HAS_DCACHE
+	/* Enable D-Cache: Clear Bit 0 */
+	write_aux_reg(ARC_REG_DC_CTRL, temp & ~IC_CTRL_CACHE_DISABLE);
+#else
+	/* Flush D cache */
+	write_aux_reg(ARC_REG_DC_FLSH, 0x1);
+	/* Disable D cache */
+	write_aux_reg(ARC_REG_DC_CTRL, temp | IC_CTRL_CACHE_DISABLE);
+#endif
+
+	return;
+}
+
+#define OP_INV		0x1
+#define OP_FLUSH	0x2
+#define OP_FLUSH_N_INV	0x3
+
+#ifdef CONFIG_ARC_HAS_DCACHE
+
+/***************************************************************
+ * Machine specific helpers for Entire D-Cache or Per Line ops
+ */
+
+static inline void wait_for_flush(void)
+{
+	while (read_aux_reg(ARC_REG_DC_CTRL) & DC_CTRL_FLUSH_STATUS)
+		;
+}
+
+/*
+ * Operation on Entire D-Cache
+ * @cacheop = {OP_INV, OP_FLUSH, OP_FLUSH_N_INV}
+ * Note that constant propagation ensures all the checks are gone
+ * in generated code
+ */
+static inline void __dc_entire_op(const int cacheop)
+{
+	unsigned long flags, tmp = tmp;
+	int aux;
+
+	local_irq_save(flags);
+
+	if (cacheop == OP_FLUSH_N_INV) {
+		/* Dcache provides 2 cmd: FLUSH or INV
+		 * INV inturn has sub-modes: DISCARD or FLUSH-BEFORE
+		 * flush-n-inv is achieved by INV cmd but with IM=1
+		 * Default INV sub-mode is DISCARD, which needs to be toggled
+		 */
+		tmp = read_aux_reg(ARC_REG_DC_CTRL);
+		write_aux_reg(ARC_REG_DC_CTRL, tmp | DC_CTRL_INV_MODE_FLUSH);
+	}
+
+	if (cacheop & OP_INV)	/* Inv or flush-n-inv use same cmd reg */
+		aux = ARC_REG_DC_IVDC;
+	else
+		aux = ARC_REG_DC_FLSH;
+
+	write_aux_reg(aux, 0x1);
+
+	if (cacheop & OP_FLUSH)	/* flush / flush-n-inv both wait */
+		wait_for_flush();
+
+	/* Switch back the DISCARD ONLY Invalidate mode */
+	if (cacheop == OP_FLUSH_N_INV)
+		write_aux_reg(ARC_REG_DC_CTRL, tmp & ~DC_CTRL_INV_MODE_FLUSH);
+
+	local_irq_restore(flags);
+}
+
+/*
+ * Per Line Operation on D-Cache
+ * Doesn't deal with type-of-op/IRQ-disabling/waiting-for-flush-to-complete
+ * It's sole purpose is to help gcc generate ZOL
+ */
+static inline void __dc_line_loop(unsigned long start, unsigned long sz,
+					  int aux_reg)
+{
+	int num_lines, slack;
+
+	/* Ensure we properly floor/ceil the non-line aligned/sized requests
+	 * and have @start - aligned to cache line and integral @num_lines.
+	 * This however can be avoided for page sized since:
+	 *  -@start will be cache-line aligned already (being page aligned)
+	 *  -@sz will be integral multiple of line size (being page sized).
+	 */
+	if (!(__builtin_constant_p(sz) && sz == PAGE_SIZE)) {
+		slack = start & ~DCACHE_LINE_MASK;
+		sz += slack;
+		start -= slack;
+	}
+
+	num_lines = DIV_ROUND_UP(sz, ARC_DCACHE_LINE_LEN);
+
+	while (num_lines-- > 0) {
+#if (CONFIG_ARC_MMU_VER > 2)
+		/*
+		 * Just as for I$, in MMU v3, D$ ops also require
+		 * "tag" bits in DC_PTAG, "index" bits in FLDL,IVDL ops
+		 * But we pass phy addr for both. This works since Linux
+		 * doesn't support aliasing configs for D$, yet.
+		 * Thus paddr is enough to provide both tag and index.
+		 */
+		write_aux_reg(ARC_REG_DC_PTAG, start);
+#endif
+		write_aux_reg(aux_reg, start);
+		start += ARC_DCACHE_LINE_LEN;
+	}
+}
+
+/*
+ * D-Cache : Per Line INV (discard or wback+discard) or FLUSH (wback)
+ */
+static inline void __dc_line_op(unsigned long start, unsigned long sz,
+					const int cacheop)
+{
+	unsigned long flags, tmp = tmp;
+	int aux;
+
+	local_irq_save(flags);
+
+	if (cacheop == OP_FLUSH_N_INV) {
+		/*
+		 * Dcache provides 2 cmd: FLUSH or INV
+		 * INV inturn has sub-modes: DISCARD or FLUSH-BEFORE
+		 * flush-n-inv is achieved by INV cmd but with IM=1
+		 * Default INV sub-mode is DISCARD, which needs to be toggled
+		 */
+		tmp = read_aux_reg(ARC_REG_DC_CTRL);
+		write_aux_reg(ARC_REG_DC_CTRL, tmp | DC_CTRL_INV_MODE_FLUSH);
+	}
+
+	if (cacheop & OP_INV)	/* Inv / flush-n-inv use same cmd reg */
+		aux = ARC_REG_DC_IVDL;
+	else
+		aux = ARC_REG_DC_FLDL;
+
+	__dc_line_loop(start, sz, aux);
+
+	if (cacheop & OP_FLUSH)	/* flush / flush-n-inv both wait */
+		wait_for_flush();
+
+	/* Switch back the DISCARD ONLY Invalidate mode */
+	if (cacheop == OP_FLUSH_N_INV)
+		write_aux_reg(ARC_REG_DC_CTRL, tmp & ~DC_CTRL_INV_MODE_FLUSH);
+
+	local_irq_restore(flags);
+}
+
+#else
+
+#define __dc_entire_op(cacheop)
+#define __dc_line_op(start, sz, cacheop)
+
+#endif /* CONFIG_ARC_HAS_DCACHE */
+
+
+#ifdef CONFIG_ARC_HAS_ICACHE
+
+/*
+ *		I-Cache Aliasing in ARC700 VIPT caches
+ *
+ * For fetching code from I$, ARC700 uses vaddr (embedded in program code)
+ * to "index" into SET of cache-line and paddr from MMU to match the TAG
+ * in the WAYS of SET.
+ *
+ * However the CDU iterface (to flush/inv) lines from software, only takes
+ * paddr (to have simpler hardware interface). For simpler cases, using paddr
+ * alone suffices.
+ * e.g. 2-way-set-assoc, 16K I$ (8k MMU pg sz, 32b cache line size):
+ *      way_sz = cache_sz / num_ways = 16k/2 = 8k
+ *      num_sets = way_sz / line_sz = 8k/32 = 256 => 8 bits
+ *   Ignoring the bottom 5 bits corresp to the off within a 32b cacheline,
+ *   bits req for calc set-index = bits 12:5 (0 based). Since this range fits
+ *   inside the bottom 13 bits of paddr, which are same for vaddr and paddr
+ *   (with 8k pg sz), paddr alone can be safely used by CDU to unambigously
+ *   locate a cache-line.
+ *
+ * However for a difft sized cache, say 32k I$, above math yields need
+ * for 14 bits of vaddr to locate a cache line, which can't be provided by
+ * paddr, since the bit 13 (0 based) might differ between the two.
+ *
+ * This lack of extra bits needed for correct line addressing, defines the
+ * classical problem of Cache aliasing with VIPT architectures
+ * num_aliases = 1 << extra_bits
+ * e.g. 2-way-set-assoc, 32K I$ with 8k MMU pg sz => 2 aliases
+ *      2-way-set-assoc, 64K I$ with 8k MMU pg sz => 4 aliases
+ *      2-way-set-assoc, 16K I$ with 8k MMU pg sz => NO aliases
+ *
+ * ------------------
+ * MMU v1/v2 (Fixed Page Size 8k)
+ * ------------------
+ * The solution was to provide CDU with these additonal vaddr bits. These
+ * would be bits [x:13], x would depend on cache-geom.
+ * H/w folks chose [17:13] to be a future safe range, and moreso these 5 bits
+ * of vaddr could easily be "stuffed" in the paddr as bits [4:0] since the
+ * orig 5 bits of paddr were anyways ignored by CDU line ops, as they
+ * represent the offset within cache-line. The adv of using this "clumsy"
+ * interface for additional info was no new reg was needed in CDU.
+ *
+ * 17:13 represented the max num of bits passable, actual bits needed were
+ * fewer, based on the num-of-aliases possible.
+ * -for 2 alias possibility, only bit 13 needed (32K cache)
+ * -for 4 alias possibility, bits 14:13 needed (64K cache)
+ *
+ * Since vaddr was not available for all instances of I$ flush req by core
+ * kernel, the only safe way (non-optimal though) was to kill all possible
+ * lines which could represent an alias (even if they didnt represent one
+ * in execution).
+ * e.g. for 64K I$, 4 aliases possible, so we did
+ *      flush start
+ *      flush start | 0x01
+ *      flush start | 0x2
+ *      flush start | 0x3
+ *
+ * The penalty was invoking the operation itself, since tag match is anyways
+ * paddr based, a line which didn't represent an alias would not match the
+ * paddr, hence wont be killed
+ *
+ * Note that aliasing concerns are independent of line-sz for a given cache
+ * geometry (size + set_assoc) because the extra bits required by line-sz are
+ * reduced from the set calc.
+ * e.g. 2-way-set-assoc, 32K I$ with 8k MMU pg sz and using math above
+ *  32b line-sz: 9 bits set-index-calc, 5 bits offset-in-line => 1 extra bit
+ *  64b line-sz: 8 bits set-index-calc, 6 bits offset-in-line => 1 extra bit
+ *
+ * ------------------
+ * MMU v3
+ * ------------------
+ * This ver of MMU supports var page sizes (1k-16k) - Linux will support
+ * 8k (default), 16k and 4k.
+ * However from hardware perspective, smaller page sizes aggrevate aliasing
+ * meaning more vaddr bits needed to disambiguate the cache-line-op ;
+ * the existing scheme of piggybacking won't work for certain configurations.
+ * Two new registers IC_PTAG and DC_PTAG inttoduced.
+ * "tag" bits are provided in PTAG, index bits in existing IVIL/IVDL/FLDL regs
+ */
+
+/***********************************************************
+ * Machine specific helpers for per line I-Cache invalidate.
+ * 3 routines to accpunt for 1, 2, 4 aliases possible
+ */
+
+static void __ic_line_inv_no_alias(unsigned long start, int num_lines)
+{
+	while (num_lines-- > 0) {
+#if (CONFIG_ARC_MMU_VER > 2)
+		write_aux_reg(ARC_REG_IC_PTAG, start);
+#endif
+		write_aux_reg(ARC_REG_IC_IVIL, start);
+		start += ARC_ICACHE_LINE_LEN;
+	}
+}
+
+static void __ic_line_inv_2_alias(unsigned long start, int num_lines)
+{
+	while (num_lines-- > 0) {
+
+#if (CONFIG_ARC_MMU_VER > 2)
+		/*
+		 *  MMU v3, CDU prog model (for line ops) now uses a new IC_PTAG
+		 * reg to pass the "tag" bits and existing IVIL reg only looks
+		 * at bits relevant for "index" (details above)
+		 * Programming Notes:
+		 * -when writing tag to PTAG reg, bit chopping can be avoided,
+		 *  CDU ignores non-tag bits.
+		 * -Ideally "index" must be computed from vaddr, but it is not
+		 *  avail in these rtns. So to be safe, we kill the lines in all
+		 *  possible indexes corresp to num of aliases possible for
+		 *  given cache config.
+		 */
+		write_aux_reg(ARC_REG_IC_PTAG, start);
+		write_aux_reg(ARC_REG_IC_IVIL,
+				  start & ~(0x1 << PAGE_SHIFT));
+		write_aux_reg(ARC_REG_IC_IVIL, start | (0x1 << PAGE_SHIFT));
+#else
+		write_aux_reg(ARC_REG_IC_IVIL, start);
+		write_aux_reg(ARC_REG_IC_IVIL, start | 0x01);
+#endif
+		start += ARC_ICACHE_LINE_LEN;
+	}
+}
+
+static void __ic_line_inv_4_alias(unsigned long start, int num_lines)
+{
+	while (num_lines-- > 0) {
+
+#if (CONFIG_ARC_MMU_VER > 2)
+		write_aux_reg(ARC_REG_IC_PTAG, start);
+
+		write_aux_reg(ARC_REG_IC_IVIL,
+				  start & ~(0x3 << PAGE_SHIFT));
+		write_aux_reg(ARC_REG_IC_IVIL,
+				  start & ~(0x2 << PAGE_SHIFT));
+		write_aux_reg(ARC_REG_IC_IVIL,
+				  start & ~(0x1 << PAGE_SHIFT));
+		write_aux_reg(ARC_REG_IC_IVIL, start | (0x3 << PAGE_SHIFT));
+#else
+		write_aux_reg(ARC_REG_IC_IVIL, start);
+		write_aux_reg(ARC_REG_IC_IVIL, start | 0x01);
+		write_aux_reg(ARC_REG_IC_IVIL, start | 0x02);
+		write_aux_reg(ARC_REG_IC_IVIL, start | 0x03);
+#endif
+		start += ARC_ICACHE_LINE_LEN;
+	}
+}
+
+static void __ic_line_inv(unsigned long start, unsigned long sz)
+{
+	unsigned long flags;
+	int num_lines, slack;
+
+	/*
+	 * Ensure we properly floor/ceil the non-line aligned/sized requests
+	 * and have @start - aligned to cache line, and integral @num_lines
+	 * However page sized flushes can be compile time optimised.
+	 *  -@start will be cache-line aligned already (being page aligned)
+	 *  -@sz will be integral multiple of line size (being page sized).
+	 */
+	if (!(__builtin_constant_p(sz) && sz == PAGE_SIZE)) {
+		slack = start & ~ICACHE_LINE_MASK;
+		sz += slack;
+		start -= slack;
+	}
+
+	num_lines = DIV_ROUND_UP(sz, ARC_ICACHE_LINE_LEN);
+
+	local_irq_save(flags);
+	(*___flush_icache_rtn) (start, num_lines);
+	local_irq_restore(flags);
+}
+
+/* Unlike routines above, having vaddr for flush op (along with paddr),
+ * prevents the need to speculatively kill the lines in multiple sets
+ * based on ratio of way_sz : pg_sz
+ */
+static void __ic_line_inv_vaddr(unsigned long phy_start,
+					 unsigned long vaddr, unsigned long sz)
+{
+	unsigned long flags;
+	int num_lines, slack;
+	unsigned int addr;
+
+	slack = phy_start & ~ICACHE_LINE_MASK;
+	sz += slack;
+	phy_start -= slack;
+	num_lines = DIV_ROUND_UP(sz, ARC_ICACHE_LINE_LEN);
+
+#if (CONFIG_ARC_MMU_VER > 2)
+	vaddr &= ~ICACHE_LINE_MASK;
+	addr = phy_start;
+#else
+	/* bits 17:13 of vaddr go as bits 4:0 of paddr */
+	addr = phy_start | ((vaddr >> 13) & 0x1F);
+#endif
+
+	local_irq_save(flags);
+	while (num_lines-- > 0) {
+#if (CONFIG_ARC_MMU_VER > 2)
+		/* tag comes from phy addr */
+		write_aux_reg(ARC_REG_IC_PTAG, addr);
+
+		/* index bits come from vaddr */
+		write_aux_reg(ARC_REG_IC_IVIL, vaddr);
+		vaddr += ARC_ICACHE_LINE_LEN;
+#else
+		/* this paddr contains vaddrs bits as needed */
+		write_aux_reg(ARC_REG_IC_IVIL, addr);
+#endif
+		addr += ARC_ICACHE_LINE_LEN;
+	}
+	local_irq_restore(flags);
+}
+
+#else
+
+#define __ic_line_inv(start, sz)
+#define __ic_line_inv_vaddr(pstart, vstart, sz)
+
+#endif /* CONFIG_ARC_HAS_ICACHE */
+
+
+/***********************************************************
+ * Exported APIs
+ */
+
+/* TBD: use pg_arch_1 to optimize this */
+void flush_dcache_page(struct page *page)
+{
+	__dc_line_op((unsigned long)page_address(page), PAGE_SIZE, OP_FLUSH);
+}
+EXPORT_SYMBOL(flush_dcache_page);
+
+
+void dma_cache_wback_inv(unsigned long start, unsigned long sz)
+{
+	__dc_line_op(start, sz, OP_FLUSH_N_INV);
+}
+EXPORT_SYMBOL(dma_cache_wback_inv);
+
+void dma_cache_inv(unsigned long start, unsigned long sz)
+{
+	__dc_line_op(start, sz, OP_INV);
+}
+EXPORT_SYMBOL(dma_cache_inv);
+
+void dma_cache_wback(unsigned long start, unsigned long sz)
+{
+	__dc_line_op(start, sz, OP_FLUSH);
+}
+EXPORT_SYMBOL(dma_cache_wback);
+
+/*
+ * This is API for making I/D Caches consistent when modifying code
+ * (loadable modules, kprobes,  etc)
+ * This is called on insmod, with kernel virtual address for CODE of
+ * the module. ARC cache maintenance ops require PHY address thus we
+ * need to convert vmalloc addr to PHY addr
+ */
+void flush_icache_range(unsigned long kstart, unsigned long kend)
+{
+	unsigned int tot_sz, off, sz;
+	unsigned long phy, pfn;
+	unsigned long flags;
+
+	/* printk("Kernel Cache Cohenercy: %lx to %lx\n",kstart, kend); */
+
+	/* This is not the right API for user virtual address */
+	if (kstart < TASK_SIZE) {
+		BUG_ON("Flush icache range for user virtual addr space");
+		return;
+	}
+
+	/* Shortcut for bigger flush ranges.
+	 * Here we don't care if this was kernel virtual or phy addr
+	 */
+	tot_sz = kend - kstart;
+	if (tot_sz > PAGE_SIZE) {
+		flush_cache_all();
+		return;
+	}
+
+	/* Case: Kernel Phy addr (0x8000_0000 onwards) */
+	if (likely(kstart > PAGE_OFFSET)) {
+		__ic_line_inv(kstart, kend - kstart);
+		__dc_line_op(kstart, kend - kstart, OP_FLUSH);
+		return;
+	}
+
+	/*
+	 * Case: Kernel Vaddr (0x7000_0000 to 0x7fff_ffff)
+	 * (1) ARC Cache Maintenance ops only take Phy addr, hence special
+	 *     handling of kernel vaddr.
+	 *
+	 * (2) Despite @tot_sz being < PAGE_SIZE (bigger cases handled already),
+	 *     it still needs to handle  a 2 page scenario, where the range
+	 *     straddles across 2 virtual pages and hence need for loop
+	 */
+	while (tot_sz > 0) {
+		off = kstart % PAGE_SIZE;
+		pfn = vmalloc_to_pfn((void *)kstart);
+		phy = (pfn << PAGE_SHIFT) + off;
+		sz = min_t(unsigned int, tot_sz, PAGE_SIZE - off);
+		local_irq_save(flags);
+		__dc_line_op(phy, sz, OP_FLUSH);
+		__ic_line_inv(phy, sz);
+		local_irq_restore(flags);
+		kstart += sz;
+		tot_sz -= sz;
+	}
+}
+
+/*
+ * Optimised ver of flush_icache_range() with spec callers: ptrace/signals
+ * where vaddr is also available. This allows passing both vaddr and paddr
+ * bits to CDU for cache flush, short-circuting the current pessimistic algo
+ * which kills all possible aliases.
+ * An added adv of knowing that vaddr is user-vaddr avoids various checks
+ * and handling for k-vaddr, k-paddr as done in orig ver above
+ */
+void flush_icache_range_vaddr(unsigned long paddr, unsigned long u_vaddr,
+			      int len)
+{
+	__ic_line_inv_vaddr(paddr, u_vaddr, len);
+	__dc_line_op(paddr, len, OP_FLUSH);
+}
+
+/*
+ * XXX: This also needs to be optim using pg_arch_1
+ * This is called when a page-cache page is about to be mapped into a
+ * user process' address space.  It offers an opportunity for a
+ * port to ensure d-cache/i-cache coherency if necessary.
+ */
+void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	if (!(vma->vm_flags & VM_EXEC))
+		return;
+
+	__ic_line_inv((unsigned long)page_address(page), PAGE_SIZE);
+}
+
+void flush_icache_all(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	write_aux_reg(ARC_REG_IC_IVIC, 1);
+
+	/* lr will not complete till the icache inv operation is not over */
+	read_aux_reg(ARC_REG_IC_CTRL);
+	local_irq_restore(flags);
+}
+
+noinline void flush_cache_all(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	flush_icache_all();
+	__dc_entire_op(OP_FLUSH_N_INV);
+
+	local_irq_restore(flags);
+
+}
+
+/* Helper functions for sys_cacheflush */
+
+
+static void __arc_cf_all(uint32_t flags)
+{
+	unsigned long irq_flags;
+
+	local_irq_save(irq_flags);
+
+	switch (flags & CF_D_FLUSH_INV) {
+	case CF_D_FLUSH:
+		__dc_entire_op(OP_FLUSH);
+		break;
+	case CF_D_INV:
+		__dc_entire_op(OP_INV);
+		break;
+	case CF_D_FLUSH_INV:
+		__dc_entire_op(OP_FLUSH_N_INV);
+		break;
+	}
+
+	if (flags & CF_I_INV)
+		flush_icache_all();
+
+	local_irq_restore(irq_flags);
+}
+
+static void __arc_cf_lines(uint32_t phy, uint32_t sz, uint32_t flags)
+{
+	unsigned long irq_flags;
+
+	local_irq_save(irq_flags);
+
+	switch (flags & CF_D_FLUSH_INV) {
+	case CF_D_FLUSH:
+		__dc_line_op(phy, sz, OP_FLUSH);
+		break;
+	case CF_D_INV:
+		__dc_line_op(phy, sz, OP_INV);
+		break;
+	case CF_D_FLUSH_INV:
+		__dc_line_op(phy, sz, OP_FLUSH_N_INV);
+		break;
+	default:
+		break;
+	}
+
+	if (flags & CF_I_INV)
+		__ic_line_inv(phy, sz);
+
+	local_irq_restore(irq_flags);
+}
+
+/**********************************************************************
+ * Explicit Cache flush request from user space via syscall
+ * Needed for JITs which generate code on the fly
+ */
+SYSCALL_DEFINE3(cacheflush, uint32_t, start, uint32_t, sz, uint32_t, flags)
+{
+	struct vm_area_struct *vma;
+	uint32_t end = start + sz;
+
+	if (!flags)
+		flags = CF_DEFAULT;
+
+	/* make sure that the address is valid, in case of virtual address */
+	if ((!(flags & CF_PHY_ADDR)) && access_ok(VERIFY_READ, start, sz))
+		return -EFAULT;
+
+	/* optimization for large areas: flush/inv entire D$ instead */
+	if (sz > PAGE_SIZE) {
+		__arc_cf_all(flags);
+		return 0;
+	}
+
+	if (flags & CF_PHY_ADDR) {
+		__arc_cf_lines(start, sz, flags);
+		return 0;
+	}
+
+	vma = find_vma(current->mm, start);
+	while ((vma) && (vma->vm_start < end)) {
+		uint32_t lstart, lend, laddr;
+		lstart = (vma->vm_start < start) ? start : vma->vm_start;
+		lend = (vma->vm_end > end) ? end : vma->vm_end;
+		lstart &= PAGE_MASK;
+
+		for (laddr = lstart; laddr <= lend; laddr += PAGE_SIZE) {
+			uint32_t pfn, lsz, phy;
+			pte_t *page_table, pte;
+
+			pgd_t *pgd = pgd_offset(current->mm, laddr);
+			pud_t *pud = pud_offset(pgd, laddr);
+			pmd_t *pmd = pmd_offset(pud, laddr);
+
+			/*
+			 * FIXME: some times these values are 0, not sure why,
+			 * but at least this prevents a crash
+			 */
+			if (!pmd)
+				return -EINVAL;
+
+			page_table = pte_offset_kernel(pmd, laddr);
+			if (!page_table)
+				return -EINVAL;
+
+			pte = *page_table;
+			pfn = pte_pfn(pte);
+			phy = pfn << PAGE_SHIFT;
+			lsz = (lend < (laddr + PAGE_SIZE)) ?
+			    (lend - laddr) : PAGE_SIZE;
+			if (start > laddr) {
+				phy += start - laddr;
+				lsz -= start - laddr;
+			}
+			__arc_cf_lines(phy, lsz, flags);
+		}
+		start = vma->vm_end;
+		vma = find_vma(current->mm, start);
+	}
+
+	return 0;
+}
-- 
1.7.4.1

