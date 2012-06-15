Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2FOKyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:54:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37788 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2FOKyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:54:18 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Cc: wuzhangjin@gmail.com, zhzhl555@gmail.com,
        Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH V7 1/4] MIPS: Add CPU support for Loongson1B
Date: Fri, 15 Jun 2012 18:53:34 +0800
Message-Id: <1339757617-2187-2-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339757617-2187-1-git-send-email-keguang.zhang@gmail.com>
References: <1339757617-2187-1-git-send-email-keguang.zhang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CPU support for Loongson1B.

Loongson 1B is a 32-bit SoC designed by Institute of
Computing Technology (ICT), Chinese Academy of Sciences (CAS),
which implements the MIPS32 release 2 instruction set.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/include/asm/cpu.h          |    3 ++-
 arch/mips/include/asm/module.h       |    2 ++
 arch/mips/kernel/cpu-probe.c         |   15 +++++++++++++++
 arch/mips/kernel/perf_event_mipsxx.c |    5 +++++
 arch/mips/kernel/traps.c             |    1 +
 arch/mips/oprofile/common.c          |    1 +
 arch/mips/oprofile/op_model_mipsxx.c |    4 ++++
 7 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 95e40c1..d9a6b84 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -199,6 +199,7 @@
 #define PRID_REV_34K_V1_0_2	0x0022
 #define PRID_REV_LOONGSON2E	0x0002
 #define PRID_REV_LOONGSON2F	0x0003
+#define PRID_REV_LOONGSON1B	0x0020
 
 /*
  * Older processors used to encode processor version and revision in two
@@ -261,7 +262,7 @@ enum cpu_type_enum {
 	 */
 	CPU_4KC, CPU_4KEC, CPU_4KSC, CPU_24K, CPU_34K, CPU_1004K, CPU_74K,
 	CPU_ALCHEMY, CPU_PR4450, CPU_BMIPS32, CPU_BMIPS3300, CPU_BMIPS4350,
-	CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC, CPU_M14KC,
+	CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC, CPU_M14KC, CPU_LOONGSON1,
 
 	/*
 	 * MIPS64 class processors
diff --git a/arch/mips/include/asm/module.h b/arch/mips/include/asm/module.h
index 5300080..30db31b 100644
--- a/arch/mips/include/asm/module.h
+++ b/arch/mips/include/asm/module.h
@@ -119,6 +119,8 @@ search_module_dbetables(unsigned long addr)
 #define MODULE_PROC_FAMILY "SB1 "
 #elif defined CONFIG_CPU_LOONGSON2
 #define MODULE_PROC_FAMILY "LOONGSON2 "
+#elif defined CONFIG_CPU_LOONGSON1
+#define MODULE_PROC_FAMILY "LOONGSON1 "
 #elif defined CONFIG_CPU_CAVIUM_OCTEON
 #define MODULE_PROC_FAMILY "OCTEON "
 #elif defined CONFIG_CPU_XLR
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index f4630e1..0a281c6 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -37,6 +37,8 @@
 void (*cpu_wait)(void);
 EXPORT_SYMBOL(cpu_wait);
 
+static void __cpuinit decode_configs(struct cpuinfo_mips *c);
+
 static void r3081_wait(void)
 {
 	unsigned long cfg = read_c0_conf();
@@ -192,6 +194,7 @@ void __init check_wait(void)
 	case CPU_JZRISC:
 	case CPU_XLR:
 	case CPU_XLP:
+	case CPU_LOONGSON1:
 		cpu_wait = r4k_wait;
 		break;
 
@@ -638,6 +641,18 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			     MIPS_CPU_32FPR;
 		c->tlbsize = 64;
 		break;
+	case PRID_IMP_LOONGSON1:
+		decode_configs(c);
+
+		c->cputype = CPU_LOONGSON1;
+
+		switch (c->processor_id & PRID_REV_MASK) {
+		case PRID_REV_LOONGSON1B:
+			__cpu_name[cpu] = "Loongson 1B";
+			break;
+		}
+
+		break;
 	}
 }
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index eb5e394..2f28d3b 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1559,6 +1559,11 @@ init_hw_perf_events(void)
 		mipspmu.general_event_map = &mipsxxcore_event_map;
 		mipspmu.cache_event_map = &mipsxxcore_cache_map;
 		break;
+	case CPU_LOONGSON1:
+		mipspmu.name = "mips/loongson1";
+		mipspmu.general_event_map = &mipsxxcore_event_map;
+		mipspmu.cache_event_map = &mipsxxcore_cache_map;
+		break;
 	case CPU_CAVIUM_OCTEON:
 	case CPU_CAVIUM_OCTEON_PLUS:
 	case CPU_CAVIUM_OCTEON2:
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index c3c2935..9be3df1 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1253,6 +1253,7 @@ static inline void parity_protection_init(void)
 
 	case CPU_5KC:
 	case CPU_5KE:
+	case CPU_LOONGSON1:
 		write_c0_ecc(0x80000000);
 		back_to_back_c0_hazard();
 		/* Set the PE bit (bit 31) in the c0_errctl register. */
diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
index b6e3782..65420c8 100644
--- a/arch/mips/oprofile/common.c
+++ b/arch/mips/oprofile/common.c
@@ -90,6 +90,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	case CPU_R10000:
 	case CPU_R12000:
 	case CPU_R14000:
+	case CPU_LOONGSON1:
 		lmodel = &op_model_mipsxx_ops;
 		break;
 
diff --git a/arch/mips/oprofile/op_model_mipsxx.c b/arch/mips/oprofile/op_model_mipsxx.c
index 52da646..28ea1a4 100644
--- a/arch/mips/oprofile/op_model_mipsxx.c
+++ b/arch/mips/oprofile/op_model_mipsxx.c
@@ -368,6 +368,10 @@ static int __init mipsxx_init(void)
 		op_model_mipsxx_ops.cpu_type = "mips/sb1";
 		break;
 
+	case CPU_LOONGSON1:
+		op_model_mipsxx_ops.cpu_type = "mips/loongson1";
+		break;
+
 	default:
 		printk(KERN_ERR "Profiling unsupported for this CPU\n");
 
-- 
1.7.1

