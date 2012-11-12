Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2KLLv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:51:57 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:51557 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2KLLvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:51:53 -0500
From: <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC Patch v1 47/55] ARC: startup #2: Verbose Boot reporting / feature verification
Date: Mon, 12 Nov 2012 17:19:05 +0530
Message-ID: <1352720953-24321-17-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Makefile              |    2 +
 arch/arc/include/asm/arcregs.h |  122 ++++++++++++++++++++--
 arch/arc/include/asm/defines.h |   56 ++++++++++
 arch/arc/include/asm/setup.h   |   14 +++
 arch/arc/kernel/setup.c        |  223 +++++++++++++++++++++++++++++++++++++++-
 arch/arc/mm/cache_arc700.c     |   46 ++++++++
 arch/arc/mm/tlb.c              |   38 +++++++
 7 files changed, 490 insertions(+), 11 deletions(-)
 create mode 100644 arch/arc/include/asm/defines.h

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index a86e284..3de315e 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -20,6 +20,8 @@ export PLATFORM
 cflags-y	+= -Iarch/arc/plat-$(PLATFORM)/include
 cflags-y	+= -mA7 -fno-common -pipe -fno-builtin -D__linux__
 
+LINUXINCLUDE	+=  -include ${src}/arch/arc/include/asm/defines.h
+
 ifdef CONFIG_ARC_CURR_IN_REG
 # For a global register defintion, make sure it gets passed to every file
 # We had a customer reported bug where some code built in kernel was NOT using
diff --git a/arch/arc/include/asm/arcregs.h b/arch/arc/include/asm/arcregs.h
index 725b94c..bd126c9 100644
--- a/arch/arc/include/asm/arcregs.h
+++ b/arch/arc/include/asm/arcregs.h
@@ -12,8 +12,26 @@
 #ifdef __KERNEL__
 
 /* Build Configuration Registers */
+#define ARC_REG_DCCMBASE_BCR	0x61	/* DCCM Base Addr */
+#define ARC_REG_CRC_BCR		0x62
+#define ARC_REG_DVFB_BCR	0x64
+#define ARC_REG_EXTARITH_BCR	0x65
 #define ARC_REG_VECBASE_BCR	0x68
+#define ARC_REG_PERIBASE_BCR	0x69
+#define ARC_REG_FP_BCR		0x6B	/* Single-Precision FPU */
+#define ARC_REG_DPFP_BCR	0x6C	/* Dbl Precision FPU */
 #define ARC_REG_MMU_BCR		0x6f
+#define ARC_REG_DCCM_BCR	0x74	/* DCCM Present + SZ */
+#define ARC_REG_TIMERS_BCR	0x75
+#define ARC_REG_ICCM_BCR	0x78
+#define ARC_REG_XY_MEM_BCR	0x79
+#define ARC_REG_MAC_BCR		0x7a
+#define ARC_REG_MUL_BCR		0x7b
+#define ARC_REG_SWAP_BCR	0x7c
+#define ARC_REG_NORM_BCR	0x7d
+#define ARC_REG_MIXMAX_BCR	0x7e
+#define ARC_REG_BARREL_BCR	0x7f
+#define ARC_REG_D_UNCACH_BCR	0x6A
 
 /* status32 Bits Positions */
 #define STATUS_H_BIT		0	/* CPU Halted */
@@ -87,16 +105,6 @@
 #define TIMER_CTRL_IE		(1 << 0) /* Interupt when Count reachs limit */
 #define TIMER_CTRL_NH		(1 << 1) /* Count only when CPU NOT halted */
 
-#if defined(CONFIG_ARC_MMU_V1)
-#define CONFIG_ARC_MMU_VER 1
-#elif defined(CONFIG_ARC_MMU_V2)
-#define CONFIG_ARC_MMU_VER 2
-#elif defined(CONFIG_ARC_MMU_V3)
-#define CONFIG_ARC_MMU_VER 3
-#else
-#error "Error: MMU ver"
-#endif
-
 /* MMU Management regs */
 #define ARC_REG_TLBPD0		0x405
 #define ARC_REG_TLBPD1		0x406
@@ -276,6 +284,13 @@ struct arc_fpu {
  ***************************************************************
  * Build Configuration Registers, with encoded hardware config
  */
+struct bcr_identity {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int chip_id:16, cpu_id:8, family:8;
+#else
+	unsigned int family:8, cpu_id:8, chip_id:16;
+#endif
+};
 
 struct bcr_mmu_1_2 {
 #ifdef CONFIG_CPU_BIG_ENDIAN
@@ -295,6 +310,38 @@ struct bcr_mmu_3 {
 #endif
 };
 
+#define EXTN_SWAP_VALID     0x1
+#define EXTN_NORM_VALID     0x2
+#define EXTN_MINMAX_VALID   0x2
+#define EXTN_BARREL_VALID   0x2
+
+struct bcr_extn {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int pad:20, crc:1, ext_arith:2, mul:2, barrel:2, minmax:2,
+		     norm:2, swap:1;
+#else
+	unsigned int swap:1, norm:2, minmax:2, barrel:2, mul:2, ext_arith:2,
+		     crc:1, pad:20;
+#endif
+};
+
+/* DSP Options Ref Manual */
+struct bcr_extn_mac_mul {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int pad:16, type:8, ver:8;
+#else
+	unsigned int ver:8, type:8, pad:16;
+#endif
+};
+
+struct bcr_extn_xymem {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int ram_org:2, num_banks:4, bank_sz:4, ver:8;
+#else
+	unsigned int ver:8, bank_sz:4, num_banks:4, ram_org:2;
+#endif
+};
+
 struct bcr_cache {
 #ifdef CONFIG_CPU_BIG_ENDIAN
 	unsigned int pad:12, line_len:4, sz:4, config:4, ver:8;
@@ -303,6 +350,48 @@ struct bcr_cache {
 #endif
 };
 
+struct bcr_perip {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int start:8, pad2:8, sz:8, pad:8;
+#else
+	unsigned int pad:8, sz:8, pad2:8, start:8;
+#endif
+};
+struct bcr_iccm {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int base:16, pad:5, sz:3, ver:8;
+#else
+	unsigned int ver:8, sz:3, pad:5, base:16;
+#endif
+};
+
+/* DCCM Base Address Register: ARC_REG_DCCMBASE_BCR */
+struct bcr_dccm_base {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int addr:24, ver:8;
+#else
+	unsigned int ver:8, addr:24;
+#endif
+};
+
+/* DCCM RAM Configuration Register: ARC_REG_DCCM_BCR */
+struct bcr_dccm {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int res:21, sz:3, ver:8;
+#else
+	unsigned int ver:8, sz:3, res:21;
+#endif
+};
+
+/* Both SP and DP FPU BCRs have same format */
+struct bcr_fp {
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	unsigned int fast:1, ver:8;
+#else
+	unsigned int ver:8, fast:1;
+#endif
+};
+
 /*
  *******************************************************************
  * Generic structures to hold build configuration used at runtime
@@ -316,9 +405,22 @@ struct cpuinfo_arc_cache {
 	unsigned int has_aliasing, sz, line_len, assoc, ver;
 };
 
+struct cpuinfo_arc_ccm {
+	unsigned int base_addr, sz;
+};
+
 struct cpuinfo_arc {
 	struct cpuinfo_arc_cache icache, dcache;
 	struct cpuinfo_arc_mmu mmu;
+	struct bcr_identity core;
+	unsigned int timers;
+	unsigned int vec_base;
+	unsigned int uncached_base;
+	struct cpuinfo_arc_ccm iccm, dccm;
+	struct bcr_extn extn;
+	struct bcr_extn_xymem extn_xymem;
+	struct bcr_extn_mac_mul extn_mac_mul;
+	struct bcr_fp fp, dpfp;
 };
 
 extern struct cpuinfo_arc cpuinfo_arc700[];
diff --git a/arch/arc/include/asm/defines.h b/arch/arc/include/asm/defines.h
new file mode 100644
index 0000000..6097bb4
--- /dev/null
+++ b/arch/arc/include/asm/defines.h
@@ -0,0 +1,56 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ARC_ASM_DEFINES_H__
+#define __ARC_ASM_DEFINES_H__
+
+#if defined(CONFIG_ARC_MMU_V1)
+#define CONFIG_ARC_MMU_VER 1
+#elif defined(CONFIG_ARC_MMU_V2)
+#define CONFIG_ARC_MMU_VER 2
+#elif defined(CONFIG_ARC_MMU_V3)
+#define CONFIG_ARC_MMU_VER 3
+#endif
+
+#ifdef CONFIG_ARC_HAS_LLSC
+#define __CONFIG_ARC_HAS_LLSC_VAL 1
+#else
+#define __CONFIG_ARC_HAS_LLSC_VAL 0
+#endif
+
+#ifdef CONFIG_ARC_HAS_SWAPE
+#define __CONFIG_ARC_HAS_SWAPE_VAL 1
+#else
+#define __CONFIG_ARC_HAS_SWAPE_VAL 0
+#endif
+
+#ifdef CONFIG_ARC_HAS_RTSC
+#define __CONFIG_ARC_HAS_RTSC_VAL 1
+#else
+#define __CONFIG_ARC_HAS_RTSC_VAL 0
+#endif
+
+#ifdef CONFIG_ARC_MMU_SASID
+#define __CONFIG_ARC_MMU_SASID_VAL 1
+#else
+#define __CONFIG_ARC_MMU_SASID_VAL 0
+#endif
+
+#ifdef CONFIG_ARC_HAS_ICACHE
+#define __CONFIG_ARC_HAS_ICACHE	1
+#else
+#define __CONFIG_ARC_HAS_ICACHE	0
+#endif
+
+#ifdef CONFIG_ARC_HAS_DCACHE
+#define __CONFIG_ARC_HAS_DCACHE	1
+#else
+#define __CONFIG_ARC_HAS_DCACHE	0
+#endif
+
+#endif /* __ARC_ASM_DEFINES_H__ */
diff --git a/arch/arc/include/asm/setup.h b/arch/arc/include/asm/setup.h
index ab427e6..fc97411 100644
--- a/arch/arc/include/asm/setup.h
+++ b/arch/arc/include/asm/setup.h
@@ -13,6 +13,20 @@
 
 #define COMMAND_LINE_SIZE 256
 
+/*
+ * Data structure to map a ID to string
+ * Used a lot for bootup reporting of hardware diversity
+ */
+struct id_to_str {
+	int id;
+	const char *str;
+};
+
+struct cpuinfo_data {
+	struct id_to_str info;
+	int up_range;
+};
+
 extern int root_mountflags, end_mem;
 extern int running_on_hw;
 
diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 34a2ff5..d470aa1 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -13,6 +13,7 @@
 #include <linux/console.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <asm/sections.h>
 #include <asm/arcregs.h>
 #include <asm/tlb.h>
 #include <asm/cache.h>
@@ -32,10 +33,205 @@ struct task_struct *_current_task[NR_CPUS];	/* For stack switching */
 
 struct cpuinfo_arc cpuinfo_arc700[NR_CPUS];
 
+
 void __init read_arc_build_cfg_regs(void)
 {
+	struct bcr_perip uncached_space;
+	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
+	FIX_PTR(cpu);
+
+	READ_BCR(AUX_IDENTITY, cpu->core);
+
+	cpu->timers = read_aux_reg(ARC_REG_TIMERS_BCR);
+
+	cpu->vec_base = read_aux_reg(AUX_INTR_VEC_BASE);
+	if (cpu->vec_base == 0)
+		cpu->vec_base = (unsigned int)_int_vec_base_lds;
+
+	READ_BCR(ARC_REG_D_UNCACH_BCR, uncached_space);
+	cpu->uncached_base = uncached_space.start << 24;
+
+	cpu->extn.mul = read_aux_reg(ARC_REG_MUL_BCR);
+	cpu->extn.swap = read_aux_reg(ARC_REG_SWAP_BCR);
+	cpu->extn.norm = read_aux_reg(ARC_REG_NORM_BCR);
+	cpu->extn.minmax = read_aux_reg(ARC_REG_MIXMAX_BCR);
+	cpu->extn.barrel = read_aux_reg(ARC_REG_BARREL_BCR);
+	READ_BCR(ARC_REG_MAC_BCR, cpu->extn_mac_mul);
+
+	cpu->extn.ext_arith = read_aux_reg(ARC_REG_EXTARITH_BCR);
+	cpu->extn.crc = read_aux_reg(ARC_REG_CRC_BCR);
+
+	READ_BCR(ARC_REG_XY_MEM_BCR, cpu->extn_xymem);
+
 	read_decode_mmu_bcr();
 	read_decode_cache_bcr();
+
+	READ_BCR(ARC_REG_FP_BCR, cpu->fp);
+	READ_BCR(ARC_REG_DPFP_BCR, cpu->dpfp);
+}
+
+static const struct cpuinfo_data arc_cpu_tbl[] = {
+	{ {0x10, "ARCTangent A5"}, 0x1F},
+	{ {0x20, "ARC 600"      }, 0x2F},
+	{ {0x30, "ARC 700"      }, 0x33},
+	{ {0x34, "ARC 700 R4.10"}, 0x34},
+	{ {0x00, NULL		} }
+};
+
+char *arc_cpu_mumbojumbo(int cpu_id, char *buf, int len)
+{
+	int n = 0;
+	struct cpuinfo_arc *cpu = &cpuinfo_arc700[cpu_id];
+	struct bcr_identity *core = &cpu->core;
+	const struct cpuinfo_data *tbl;
+	int be = 0;
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	be = 1;
+#endif
+	FIX_PTR(cpu);
+
+	n += scnprintf(buf + n, len - n,
+		       "\nARC IDENTITY\t: Family [%#02x]"
+		       " Cpu-id [%#02x] Chip-id [%#4x]\n",
+		       core->family, core->cpu_id,
+		       core->chip_id);
+
+	for (tbl = &arc_cpu_tbl[0]; tbl->info.id != 0; tbl++) {
+		if ((core->family >= tbl->info.id) &&
+		    (core->family <= tbl->up_range)) {
+			n += scnprintf(buf + n, len - n,
+				       "processor\t: %s %s\n",
+				       tbl->info.str,
+				       be ? "[Big Endian]" : "");
+			break;
+		}
+	}
+
+	if (tbl->info.id == 0)
+		n += scnprintf(buf + n, len - n, "UNKNOWN ARC Processor\n");
+
+	n += scnprintf(buf + n, len - n, "CPU speed\t: %u.%02u Mhz\n",
+		       (unsigned int)(CONFIG_ARC_PLAT_CLK / 1000000),
+		       (unsigned int)(CONFIG_ARC_PLAT_CLK / 10000) % 100);
+
+	n += scnprintf(buf + n, len - n, "Timers\t\t: %s %s\n",
+		       (cpu->timers & 0x200) ? "TIMER1" : "",
+		       (cpu->timers & 0x100) ? "TIMER0" : "");
+
+	n += scnprintf(buf + n, len - n, "Vect Tbl Base\t: %#x\n",
+		       cpu->vec_base);
+
+	n += scnprintf(buf + n, len - n, "UNCACHED Base\t: %#x\n",
+		       cpu->uncached_base);
+
+	return buf;
+}
+
+static const struct id_to_str mul_type_nm[] = {
+	{ 0x0, "N/A"},
+	{ 0x1, "32x32 (spl Result Reg)" },
+	{ 0x2, "32x32 (ANY Result Reg)" }
+};
+
+static const struct id_to_str mac_mul_nm[] = {
+	{0x0, "N/A"},
+	{0x1, "N/A"},
+	{0x2, "Dual 16 x 16"},
+	{0x3, "N/A"},
+	{0x4, "32x16"},
+	{0x5, "N/A"},
+	{0x6, "Dual 16x16 and 32x16"}
+};
+
+char *arc_extn_mumbojumbo(int cpu_id, char *buf, int len)
+{
+	int n = 0;
+	struct cpuinfo_arc *cpu = &cpuinfo_arc700[cpu_id];
+
+	FIX_PTR(cpu);
+#define IS_AVAIL1(var, str)	((var) ? str : "")
+#define IS_AVAIL2(var, str)	((var == 0x2) ? str : "")
+#define IS_USED(var)		((var) ? "(in-use)" : "(not used)")
+
+	n += scnprintf(buf + n, len - n,
+		       "Extn [700-Base]\t: %s %s %s %s %s %s\n",
+		       IS_AVAIL2(cpu->extn.norm, "norm,"),
+		       IS_AVAIL2(cpu->extn.barrel, "barrel-shift,"),
+		       IS_AVAIL1(cpu->extn.swap, "swap,"),
+		       IS_AVAIL2(cpu->extn.minmax, "minmax,"),
+		       IS_AVAIL1(cpu->extn.crc, "crc,"),
+		       IS_AVAIL2(cpu->extn.ext_arith, "ext-arith"));
+
+	n += scnprintf(buf + n, len - n, "Extn [700-MPY]\t: %s",
+		       mul_type_nm[cpu->extn.mul].str);
+
+	n += scnprintf(buf + n, len - n, "   MAC MPY: %s\n",
+		       mac_mul_nm[cpu->extn_mac_mul.type].str);
+
+	if (cpu->core.family == 0x34) {
+		n += scnprintf(buf + n, len - n,
+		"Extn [700-4.10]\t: LLOCK/SCOND %s, SWAPE %s, RTSC %s\n",
+			       IS_USED(__CONFIG_ARC_HAS_LLSC_VAL),
+			       IS_USED(__CONFIG_ARC_HAS_SWAPE_VAL),
+			       IS_USED(__CONFIG_ARC_HAS_RTSC_VAL));
+	}
+
+	n += scnprintf(buf + n, len - n, "Extn [CCM]\t: %s",
+		       !(cpu->dccm.sz || cpu->iccm.sz) ? "N/A" : "");
+
+	if (cpu->dccm.sz)
+		n += scnprintf(buf + n, len - n, "DCCM: @ %x, %d KB ",
+			       cpu->dccm.base_addr, TO_KB(cpu->dccm.sz));
+
+	if (cpu->iccm.sz)
+		n += scnprintf(buf + n, len - n, "ICCM: @ %x, %d KB",
+			       cpu->iccm.base_addr, TO_KB(cpu->iccm.sz));
+
+	n += scnprintf(buf + n, len - n, "\nExtn [FPU]\t: %s",
+		       !(cpu->fp.ver || cpu->dpfp.ver) ? "N/A" : "");
+
+	if (cpu->fp.ver)
+		n += scnprintf(buf + n, len - n, "SP [v%d] %s",
+			       cpu->fp.ver, cpu->fp.fast ? "(fast)" : "");
+
+	if (cpu->dpfp.ver)
+		n += scnprintf(buf + n, len - n, "DP [v%d] %s",
+			       cpu->dpfp.ver, cpu->dpfp.fast ? "(fast)" : "");
+
+	n += scnprintf(buf + n, len - n, "\n");
+
+#ifdef _ASM_GENERIC_UNISTD_H
+	n += scnprintf(buf + n, len - n,
+		       "OS ABI [v2]\t: asm-generic/{unistd,stat,fcntl}\n");
+#endif
+
+	return buf;
+}
+
+/*
+ * Ensure that FP hardware and kernel config match
+ * -If hardware contains DPFP, kernel needs to save/restore FPU state
+ *  across context switches
+ * -If hardware lacks DPFP, but kernel configured to save FPU state then
+ *  kernel trying to access non-existant DPFP regs will crash
+ *
+ * We only check for Dbl precision Floating Point, because only DPFP
+ * hardware has dedicated regs which need to be saved/restored on ctx-sw
+ * (Single Precision uses core regs), thus kernel is kind of oblivious to it
+ */
+void __init arc_chk_fpu(void)
+{
+	struct cpuinfo_arc *cpu = &cpuinfo_arc700[smp_processor_id()];
+
+	if (cpu->dpfp.ver) {
+#ifndef CONFIG_ARC_FPU_SAVE_RESTORE
+		pr_warn("DPFP support broken in this kernel...\n");
+#endif
+	} else {
+#ifdef CONFIG_ARC_FPU_SAVE_RESTORE
+		panic("H/w lacks DPFP support, apps won't work\n");
+#endif
+	}
 }
 
 /*
@@ -46,10 +242,25 @@ void __init read_arc_build_cfg_regs(void)
 
 void __init setup_processor(void)
 {
+	char str[512];
+	int cpu_id = smp_processor_id();
+
 	read_arc_build_cfg_regs();
 	arc_init_IRQ();
+
+	printk(arc_cpu_mumbojumbo(cpu_id, str, sizeof(str)));
+
 	arc_mmu_init();
 	arc_cache_init();
+
+
+	printk(arc_extn_mumbojumbo(cpu_id, str, sizeof(str)));
+
+#ifdef CONFIG_SMP
+	printk(arc_platform_smp_cpuinfo());
+#endif
+
+	arc_chk_fpu();
 }
 
 void __init __attribute__((weak)) arc_platform_early_init(void)
@@ -117,12 +328,22 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (!str)
 		goto done;
 
-	seq_printf(m, "ARC700 #%d\n", cpu_id);
+	seq_printf(m, arc_cpu_mumbojumbo(cpu_id, str, PAGE_SIZE));
 
 	seq_printf(m, "Bogo MIPS : \t%lu.%02lu\n",
 		   loops_per_jiffy / (500000 / HZ),
 		   (loops_per_jiffy / (5000 / HZ)) % 100);
 
+	seq_printf(m, arc_mmu_mumbojumbo(cpu_id, str, PAGE_SIZE));
+
+	seq_printf(m, arc_cache_mumbojumbo(cpu_id, str, PAGE_SIZE));
+
+	seq_printf(m, arc_extn_mumbojumbo(cpu_id, str, PAGE_SIZE));
+
+#ifdef CONFIG_SMP
+	seq_printf(m, arc_platform_smp_cpuinfo());
+#endif
+
 	free_page((unsigned long)str);
 done:
 	seq_printf(m, "\n\n");
diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
index 9f8f567..a50f947 100644
--- a/arch/arc/mm/cache_arc700.c
+++ b/arch/arc/mm/cache_arc700.c
@@ -82,6 +82,28 @@ static void __ic_line_inv_4_alias(unsigned long, int);
 static void (*___flush_icache_rtn) (unsigned long, int);
 #endif
 
+char *arc_cache_mumbojumbo(int cpu_id, char *buf, int len)
+{
+	int n = 0;
+	unsigned int c = smp_processor_id();
+
+#define PR_CACHE(p, enb, str)						\
+{									\
+	if (!(p)->ver)							\
+		n += scnprintf(buf + n, len - n, str"\t\t: N/A\n");	\
+	else								\
+		n += scnprintf(buf + n, len - n,			\
+			str"\t\t: (%uK) VIPT, %dway set-asc, %ub Line %s\n", \
+			TO_KB((p)->sz), (p)->assoc, (p)->line_len,	\
+			enb ?  "" : "DISABLED (kernel-build)");		\
+}
+
+	PR_CACHE(&cpuinfo_arc700[c].icache, __CONFIG_ARC_HAS_ICACHE, "I-Cache");
+	PR_CACHE(&cpuinfo_arc700[c].dcache, __CONFIG_ARC_HAS_DCACHE, "D-Cache");
+
+	return buf;
+}
+
 /*
  * Read the Cache Build Confuration Registers, Decode them and save into
  * the cpuinfo structure for later use.
@@ -132,10 +154,29 @@ void __init arc_cache_init(void)
 	struct cpuinfo_arc_cache *dc;
 #endif
 	int way_pg_ratio = way_pg_ratio;
+	char str[256];
+
+	printk(arc_cache_mumbojumbo(0, str, sizeof(str)));
 
 #ifdef CONFIG_ARC_HAS_ICACHE
 	ic = &cpuinfo_arc700[cpu].icache;
 
+	/* 1. Confirm some of I-cache params which Linux assumes */
+	if ((ic->assoc != ARC_ICACHE_WAYS) ||
+	    (ic->line_len != ARC_ICACHE_LINE_LEN)) {
+		panic("Cache H/W doesn't match kernel Config");
+	}
+#if (CONFIG_ARC_MMU_VER > 2)
+	if (ic->ver != 3) {
+		if (running_on_hw)
+			panic("Cache ver doesn't match MMU ver\n");
+
+		/* For ISS - suggest the toggles to use */
+		pr_err("Use -prop=icache_version=3,-prop=dcache_version=3\n");
+
+	}
+#endif
+
 	/*
 	 * if Cache way size is <= page size then no aliasing exhibited
 	 * otherwise ratio determines num of aliases.
@@ -175,6 +216,11 @@ void __init arc_cache_init(void)
 #ifdef CONFIG_ARC_HAS_DCACHE
 	dc = &cpuinfo_arc700[cpu].dcache;
 
+	if ((dc->assoc != ARC_DCACHE_WAYS) ||
+	    (dc->line_len != ARC_DCACHE_LINE_LEN)) {
+		panic("Cache H/W doesn't match kernel Config");
+	}
+
 	/* check for D-Cache aliasing */
 	if ((dc->sz / ARC_DCACHE_WAYS) > PAGE_SIZE)
 		panic("D$ aliasing not handled right now\n");
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index defa0c0..36bae47 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -451,8 +451,46 @@ void __init read_decode_mmu_bcr(void)
 	mmu->num_tlb = mmu->sets * mmu->ways;
 }
 
+char *arc_mmu_mumbojumbo(int cpu_id, char *buf, int len)
+{
+	int n = 0;
+	struct cpuinfo_arc_mmu *p_mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
+
+	n += scnprintf(buf + n, len - n, "ARC700 MMU [v%x]\t: %dk PAGE, ",
+		       p_mmu->ver, TO_KB(p_mmu->pg_sz));
+
+	n += scnprintf(buf + n, len - n,
+		       "J-TLB %d (%dx%d), uDTLB %d, uITLB %d, %s\n",
+		       p_mmu->num_tlb, p_mmu->sets, p_mmu->ways,
+		       p_mmu->u_dtlb, p_mmu->u_itlb,
+		       __CONFIG_ARC_MMU_SASID_VAL ? "SASID" : "");
+
+	return buf;
+}
+
 void __init arc_mmu_init(void)
 {
+	char str[256];
+	struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
+
+	printk(arc_mmu_mumbojumbo(0, str, sizeof(str)));
+
+	/* For efficiency sake, kernel is compile time built for a MMU ver
+	 * This must match the hardware it is running on.
+	 * Linux built for MMU V2, if run on MMU V1 will break down because V1
+	 *  hardware doesn't understand cmds such as WriteNI, or IVUTLB
+	 * On the other hand, Linux built for V1 if run on MMU V2 will do
+	 *   un-needed workarounds to prevent memcpy thrashing.
+	 * Similarly MMU V3 has new features which won't work on older MMU
+	 */
+	if (mmu->ver != CONFIG_ARC_MMU_VER) {
+		panic("MMU ver %d doesn't match kernel built for %d...\n",
+		      mmu->ver, CONFIG_ARC_MMU_VER);
+	}
+
+	if (mmu->pg_sz != PAGE_SIZE)
+		panic("MMU pg size != PAGE_SIZE (%luk)\n", TO_KB(PAGE_SIZE));
+
 	/*
 	 * ASID mgmt data structures are compile time init
 	 *  asid_cache = FIRST_ASID and asid_mm_map[] all zeroes
-- 
1.7.4.1

