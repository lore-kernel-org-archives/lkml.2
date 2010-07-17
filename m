Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab0GQMIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 08:08:16 -0400
Received: from smtp-out-005.synserver.de ([212.40.180.5]:1038 "HELO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1759879Ab0GQMIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 08:08:15 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 28959
From: Lars-Peter Clausen <lars@metafoo.de>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3] MIPS: Add base support for Ingenic JZ4740 System-on-a-Chip
Date: Sat, 17 Jul 2010 14:07:51 +0200
Message-Id: <1279368471-20307-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new cpu type for the JZ4740 to the Linux MIPS architecture code.
It also adds the iomem addresses for the different components found on a JZ4740
SoC.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

--
Changes since v1
- Use physical addresses for base addresses

Changes since v2
- Add cpu-feature-overrides.h
---
 arch/mips/include/asm/bootinfo.h                   |    6 ++
 arch/mips/include/asm/cpu.h                        |    9 +++-
 arch/mips/include/asm/mach-jz4740/base.h           |   26 ++++++++++
 .../asm/mach-jz4740/cpu-feature-overrides.h        |   51 ++++++++++++++++++++
 arch/mips/include/asm/mach-jz4740/war.h            |   25 ++++++++++
 arch/mips/kernel/cpu-probe.c                       |   20 ++++++++
 arch/mips/mm/tlbex.c                               |    5 ++
 7 files changed, 141 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-jz4740/base.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-jz4740/war.h

diff --git a/arch/mips/include/asm/bootinfo.h b/arch/mips/include/asm/bootinfo.h
index 09eee09..15a8ef0 100644
--- a/arch/mips/include/asm/bootinfo.h
+++ b/arch/mips/include/asm/bootinfo.h
@@ -71,6 +71,12 @@
 #define MACH_LEMOTE_LL2F       7
 #define MACH_LOONGSON_END      8
 
+/*
+ * Valid machtype for group INGENIC
+ */
+#define  MACH_INGENIC_JZ4730	0	/* JZ4730 SOC		*/
+#define  MACH_INGENIC_JZ4740	1	/* JZ4740 SOC		*/
+
 extern char *system_type;
 const char *get_system_type(void);
 
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index a5acda4..b201a8f 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -34,7 +34,7 @@
 #define PRID_COMP_LSI		0x080000
 #define PRID_COMP_LEXRA		0x0b0000
 #define PRID_COMP_CAVIUM	0x0d0000
-
+#define PRID_COMP_INGENIC	0xd00000
 
 /*
  * Assigned values for the product ID register.  In order to detect a
@@ -133,6 +133,12 @@
 #define PRID_IMP_CAVIUM_CN52XX 0x0700
 
 /*
+ * These are the PRID's for when 23:16 == PRID_COMP_INGENIC
+ */
+
+#define PRID_IMP_JZRISC        0x0200
+
+/*
  * Definitions for 7:0 on legacy processors
  */
 
@@ -219,6 +225,7 @@ enum cpu_type_enum {
 	CPU_4KC, CPU_4KEC, CPU_4KSC, CPU_24K, CPU_34K, CPU_1004K, CPU_74K,
 	CPU_ALCHEMY, CPU_PR4450, CPU_BCM3302, CPU_BCM4710,
 	CPU_BCM6338, CPU_BCM6345, CPU_BCM6348, CPU_BCM6358,
+	CPU_JZRISC,
 
 	/*
 	 * MIPS64 class processors
diff --git a/arch/mips/include/asm/mach-jz4740/base.h b/arch/mips/include/asm/mach-jz4740/base.h
new file mode 100644
index 0000000..f373186
--- /dev/null
+++ b/arch/mips/include/asm/mach-jz4740/base.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_MACH_JZ4740_BASE_H__
+#define __ASM_MACH_JZ4740_BASE_H__
+
+#define JZ4740_CPM_BASE_ADDR	0x10000000
+#define JZ4740_INTC_BASE_ADDR	0x10001000
+#define JZ4740_WDT_BASE_ADDR	0x10002000
+#define JZ4740_TCU_BASE_ADDR	0x10002010
+#define JZ4740_RTC_BASE_ADDR	0x10003000
+#define JZ4740_GPIO_BASE_ADDR	0x10010000
+#define JZ4740_AIC_BASE_ADDR	0x10020000
+#define JZ4740_MSC_BASE_ADDR	0x10021000
+#define JZ4740_UART0_BASE_ADDR	0x10030000
+#define JZ4740_UART1_BASE_ADDR	0x10031000
+#define JZ4740_I2C_BASE_ADDR	0x10042000
+#define JZ4740_SSI_BASE_ADDR	0x10043000
+#define JZ4740_SADC_BASE_ADDR	0x10070000
+#define JZ4740_EMC_BASE_ADDR	0x13010000
+#define JZ4740_DMAC_BASE_ADDR	0x13020000
+#define JZ4740_UHC_BASE_ADDR	0x13030000
+#define JZ4740_UDC_BASE_ADDR	0x13040000
+#define JZ4740_LCD_BASE_ADDR	0x13050000
+#define JZ4740_SLCD_BASE_ADDR	0x13050000
+#define JZ4740_CIM_BASE_ADDR	0x13060000
+#define JZ4740_IPU_BASE_ADDR	0x13080000
+
+#endif
diff --git a/arch/mips/include/asm/mach-jz4740/cpu-feature-overrides.h b/arch/mips/include/asm/mach-jz4740/cpu-feature-overrides.h
new file mode 100644
index 0000000..d12e5c6
--- /dev/null
+++ b/arch/mips/include/asm/mach-jz4740/cpu-feature-overrides.h
@@ -0,0 +1,51 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ */
+#ifndef __ASM_MACH_JZ4740_CPU_FEATURE_OVERRIDES_H
+#define __ASM_MACH_JZ4740_CPU_FEATURE_OVERRIDES_H
+
+#define cpu_has_tlb 1
+#define cpu_has_4kex		1
+#define cpu_has_3k_cache	0
+#define cpu_has_4k_cache	1
+#define cpu_has_tx39_cache	0
+#define cpu_has_fpu		0
+#define cpu_has_32fpr	0
+#define cpu_has_counter		0
+#define cpu_has_watch		1
+#define cpu_has_divec		1
+#define cpu_has_vce		0
+#define cpu_has_cache_cdex_p	0
+#define cpu_has_cache_cdex_s	0
+#define cpu_has_prefetch	1
+#define cpu_has_mcheck 1
+#define cpu_has_ejtag 1
+#define cpu_has_llsc		1
+#define cpu_has_mips16 0
+#define cpu_has_mdmx 0
+#define cpu_has_mips3d 0
+#define cpu_has_smartmips 0
+#define kernel_uses_llsc	1
+#define cpu_has_vtag_icache	1
+#define cpu_has_dc_aliases	0
+#define cpu_has_ic_fills_f_dc	0
+#define cpu_has_pindexed_dcache 0
+#define cpu_has_mips32r1	1
+#define cpu_has_mips32r2	0
+#define cpu_has_mips64r1	0
+#define cpu_has_mips64r2	0
+#define cpu_has_dsp		0
+#define cpu_has_mipsmt		0
+#define cpu_has_userlocal	0
+#define cpu_has_nofpuex 0
+#define cpu_has_64bits		0
+#define cpu_has_64bit_zero_reg 0
+#define cpu_has_inclusive_pcaches 0
+
+#define cpu_dcache_line_size()	32
+#define cpu_icache_line_size()	32
+
+#endif
diff --git a/arch/mips/include/asm/mach-jz4740/war.h b/arch/mips/include/asm/mach-jz4740/war.h
new file mode 100644
index 0000000..3a5bc17
--- /dev/null
+++ b/arch/mips/include/asm/mach-jz4740/war.h
@@ -0,0 +1,25 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
+ */
+#ifndef __ASM_MIPS_MACH_JZ4740_WAR_H
+#define __ASM_MIPS_MACH_JZ4740_WAR_H
+
+#define R4600_V1_INDEX_ICACHEOP_WAR	0
+#define R4600_V1_HIT_CACHEOP_WAR	0
+#define R4600_V2_HIT_CACHEOP_WAR	0
+#define R5432_CP0_INTERRUPT_WAR		0
+#define BCM1250_M3_WAR			0
+#define SIBYTE_1956_WAR			0
+#define MIPS4K_ICACHE_REFILL_WAR	0
+#define MIPS_CACHE_SYNC_WAR		0
+#define TX49XX_ICACHE_INDEX_INV_WAR	0
+#define RM9000_CDEX_SMP_WAR		0
+#define ICACHE_REFILLS_WORKAROUND_WAR	0
+#define R10000_LLSC_WAR			0
+#define MIPS34K_MISSED_ITLB_WAR		0
+
+#endif /* __ASM_MIPS_MACH_JZ4740_WAR_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 3562b85..9b66331 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -187,6 +187,7 @@ void __init check_wait(void)
 	case CPU_BCM6358:
 	case CPU_CAVIUM_OCTEON:
 	case CPU_CAVIUM_OCTEON_PLUS:
+	case CPU_JZRISC:
 		cpu_wait = r4k_wait;
 		break;
 
@@ -956,6 +957,22 @@ platform:
 	}
 }
 
+static inline void cpu_probe_ingenic(struct cpuinfo_mips *c, unsigned int cpu)
+{
+	decode_configs(c);
+	/* JZRISC does not implement the CP0 counter. */
+	c->options &= ~MIPS_CPU_COUNTER;
+	switch (c->processor_id & 0xff00) {
+	case PRID_IMP_JZRISC:
+		c->cputype = CPU_JZRISC;
+		__cpu_name[cpu] = "Ingenic JZRISC";
+		break;
+	default:
+		panic("Unknown Ingenic Processor ID!");
+		break;
+	}
+}
+
 const char *__cpu_name[NR_CPUS];
 const char *__elf_platform;
 
@@ -994,6 +1011,9 @@ __cpuinit void cpu_probe(void)
 	case PRID_COMP_CAVIUM:
 		cpu_probe_cavium(c, cpu);
 		break;
+	case PRID_COMP_INGENIC:
+		cpu_probe_ingenic(c, cpu);
+		break;
 	}
 
 	BUG_ON(!__cpu_name[cpu]);
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 86f004d..4510e61 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -409,6 +409,11 @@ static void __cpuinit build_tlb_write_entry(u32 **p, struct uasm_label **l,
 		tlbw(p);
 		break;
 
+	case CPU_JZRISC:
+		tlbw(p);
+		uasm_i_nop(p);
+		break;
+
 	default:
 		panic("No TLB refill handler yet (CPU type: %d)",
 		      current_cpu_data.cputype);
-- 
1.5.6.5

