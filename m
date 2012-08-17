Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030938Ab2HQIo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:44:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35967 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704Ab2HQIoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:44:02 -0400
From: Huacai Chen <chenhc@lemote.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: [PATCH V6 02/15] MIPS: Loongson: Add basic Loongson-3 CPU support
Date: Fri, 17 Aug 2012 16:43:22 +0800
Message-Id: <1345193015-3024-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1345193015-3024-1-git-send-email-chenhc@lemote.com>
References: <1345193015-3024-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic Loongson-3 CPU support include CPU probing and TLB/cache
initializing.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
---
 arch/mips/kernel/Makefile    |    1 +
 arch/mips/kernel/cpu-probe.c |   14 +++++++---
 arch/mips/lib/Makefile       |    1 +
 arch/mips/mm/Makefile        |    1 +
 arch/mips/mm/c-r4k.c         |   62 +++++++++++++++++++++++++++++++++++++++++-
 arch/mips/mm/tlb-r4k.c       |    2 +-
 arch/mips/mm/tlbex.c         |    1 +
 7 files changed, 76 insertions(+), 6 deletions(-)

diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index fdaf65e..a0fc07f 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
+obj-$(CONFIG_CPU_LOONGSON3)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS64)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_R3000)		+= r2300_fpu.o r2300_switch.o
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 8ea65c5..a0d2b32 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -767,17 +767,23 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			     MIPS_CPU_LLSC;
 		c->tlbsize = 64;
 		break;
-	case PRID_IMP_LOONGSON2:
-		c->cputype = CPU_LOONGSON2;
-		__cpu_name[cpu] = "ICT Loongson-2";
-
+	case PRID_IMP_LOONGSON2: /* Loongson-2/3 have the same PRID_IMP field */
 		switch (c->processor_id & PRID_REV_MASK) {
 		case PRID_REV_LOONGSON2E:
+			c->cputype = CPU_LOONGSON2;
+			__cpu_name[cpu] = "ICT Loongson-2";
 			set_elf_platform(cpu, "loongson2e");
 			break;
 		case PRID_REV_LOONGSON2F:
+			c->cputype = CPU_LOONGSON2;
+			__cpu_name[cpu] = "ICT Loongson-2";
 			set_elf_platform(cpu, "loongson2f");
 			break;
+		case PRID_REV_LOONGSON3A:
+			c->cputype = CPU_LOONGSON3;
+			__cpu_name[cpu] = "ICT Loongson-3";
+			set_elf_platform(cpu, "loongson3a");
+			break;
 		}
 
 		c->isa_level = MIPS_CPU_ISA_III;
diff --git a/arch/mips/lib/Makefile b/arch/mips/lib/Makefile
index 399a50a..2ef5535 100644
--- a/arch/mips/lib/Makefile
+++ b/arch/mips/lib/Makefile
@@ -9,6 +9,7 @@ obj-y			+= iomap.o
 obj-$(CONFIG_PCI)	+= iomap-pci.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= dump_tlb.o
+obj-$(CONFIG_CPU_LOONGSON3)	+= dump_tlb.o
 obj-$(CONFIG_CPU_MIPS32)	+= dump_tlb.o
 obj-$(CONFIG_CPU_MIPS64)	+= dump_tlb.o
 obj-$(CONFIG_CPU_NEVADA)	+= dump_tlb.o
diff --git a/arch/mips/mm/Makefile b/arch/mips/mm/Makefile
index fd6203f..a79b6d1 100644
--- a/arch/mips/mm/Makefile
+++ b/arch/mips/mm/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_HIGHMEM)		+= highmem.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= c-r4k.o cex-gen.o tlb-r4k.o
+obj-$(CONFIG_CPU_LOONGSON3)	+= c-r4k.o cex-gen.o tlb-r4k.o
 obj-$(CONFIG_CPU_MIPS32)	+= c-r4k.o cex-gen.o tlb-r4k.o
 obj-$(CONFIG_CPU_MIPS64)	+= c-r4k.o cex-gen.o tlb-r4k.o
 obj-$(CONFIG_CPU_NEVADA)	+= c-r4k.o cex-gen.o tlb-r4k.o
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index ce0dbee..5352387 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -952,6 +952,31 @@ static void __cpuinit probe_pcache(void)
 		c->dcache.waybit = 0;
 		break;
 
+	case CPU_LOONGSON3:
+		config1 = read_c0_config1();
+		if ((lsize = ((config1 >> 19) & 7)))
+			c->icache.linesz = 2 << lsize;
+		else
+			c->icache.linesz = lsize;
+		c->icache.sets = 64 << ((config1 >> 22) & 7);
+		c->icache.ways = 1 + ((config1 >> 16) & 7);
+		icache_size = c->icache.sets *
+					  c->icache.ways *
+					  c->icache.linesz;
+		c->icache.waybit = 0;
+
+		if ((lsize = ((config1 >> 10) & 7)))
+			c->dcache.linesz = 2 << lsize;
+		else
+			c->dcache.linesz = lsize;
+		c->dcache.sets = 64 << ((config1 >> 13) & 7);
+		c->dcache.ways = 1 + ((config1 >> 7) & 7);
+		dcache_size = c->dcache.sets *
+					  c->dcache.ways *
+					  c->dcache.linesz;
+		c->dcache.waybit = 0;
+		break;
+
 	default:
 		if (!(config & MIPS_CONF_M))
 			panic("Don't know how to probe P-caches on this cpu.");
@@ -1170,6 +1195,34 @@ static void __init loongson2_sc_init(void)
 }
 #endif
 
+#if defined(CONFIG_CPU_LOONGSON3)
+static void __init loongson3_sc_init(void)
+{
+	struct cpuinfo_mips *c = &current_cpu_data;
+	unsigned int config2, lsize;
+
+	config2 = read_c0_config2();
+	if ((lsize = ((config2 >> 4) & 15)))
+		c->scache.linesz = 2 << lsize;
+	else
+		c->scache.linesz = lsize;
+	c->scache.sets = 64 << ((config2 >> 8) & 15);
+	c->scache.ways = 1 + (config2 & 15);
+
+	scache_size = c->scache.sets *
+				  c->scache.ways *
+				  c->scache.linesz;
+	/* Loongson-3 has 4 cores, 1MB scache for each. scaches are shared */
+	scache_size *= 4;
+	c->scache.waybit = 0;
+	pr_info("Unified secondary cache %ldkB %s, linesize %d bytes.\n",
+	       scache_size >> 10, way_string[c->scache.ways], c->scache.linesz);
+	if (scache_size)
+		c->options |= MIPS_CPU_INCLUSIVE_CACHES;
+	return;
+}
+#endif
+
 extern int r5k_sc_init(void);
 extern int rm7k_sc_init(void);
 extern int mips_sc_init(void);
@@ -1219,11 +1272,18 @@ static void __cpuinit setup_scache(void)
 #endif
 		return;
 
-#if defined(CONFIG_CPU_LOONGSON2)
 	case CPU_LOONGSON2:
+#if defined(CONFIG_CPU_LOONGSON2)
 		loongson2_sc_init();
+#endif
 		return;
+
+	case CPU_LOONGSON3:
+#if defined(CONFIG_CPU_LOONGSON3)
+		loongson3_sc_init();
 #endif
+		return;
+
 	case CPU_XLP:
 		/* don't need to worry about L2, fully coherent */
 		return;
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index d2572cb..11b9c88 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -50,7 +50,7 @@ extern void build_tlb_refill_handler(void);
 
 #endif /* CONFIG_MIPS_MT_SMTC */
 
-#if defined(CONFIG_CPU_LOONGSON2)
+#if defined(CONFIG_CPU_LOONGSON2) || defined(CONFIG_CPU_LOONGSON3)
 /*
  * LOONGSON2 has a 4 entry itlb which is a subset of dtlb,
  * unfortrunately, itlb is not totally transparent to software.
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 03eb0ef..4420250 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -507,6 +507,7 @@ static void __cpuinit build_tlb_write_entry(u32 **p, struct uasm_label **l,
 	case CPU_BMIPS4380:
 	case CPU_BMIPS5000:
 	case CPU_LOONGSON2:
+	case CPU_LOONGSON3:
 	case CPU_R5500:
 		if (m4kc_tlbp_war())
 			uasm_i_nop(p);
-- 
1.7.7.3

