Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab0JPVnx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 17:43:53 -0400
Received: from [69.28.251.93] ([69.28.251.93]:33655 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab0JPVnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 17:43:51 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <ffainelli@freebox.fr>, <mbizon@freebox.fr>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/9] MIPS: Decouple BMIPS CPU support from bcm47xx/bcm63xx SoC code
Date: Sat, 16 Oct 2010 14:22:30 -0700
Message-Id: <17ebecce124618ddf83ec6fe8e526f93@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BMIPS processor cores are used in 50+ different chipsets spread across
5+ product lines.  In many cases the chipsets do not share the same
peripheral register layouts, the same register blocks, the same
interrupt controllers, the same memory maps, or much of anything else.

But, across radically different SoCs that share nothing more than the
same BMIPS CPU, a few things are still mostly constant:

SMP operations
Access to performance counters
DMA cache coherency quirks
Cache and memory bus configuration

So, it makes sense to treat each BMIPS processor type as a generic
"building block," rather than tying it to a specific SoC.  This makes it
easier to support a large number of BMIPS-based chipsets without
unnecessary duplication of code, and provides the infrastructure needed
to support BMIPS-proprietary features.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 arch/mips/bcm63xx/cpu.c      |   30 ++++++++++----------
 arch/mips/include/asm/cpu.h  |   23 ++++++++-------
 arch/mips/kernel/cpu-probe.c |   62 ++++++++++++++++++++++-------------------
 arch/mips/mm/tlbex.c         |   11 +++----
 4 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/arch/mips/bcm63xx/cpu.c b/arch/mips/bcm63xx/cpu.c
index cbb7caf..7c7e4d4 100644
--- a/arch/mips/bcm63xx/cpu.c
+++ b/arch/mips/bcm63xx/cpu.c
@@ -10,7 +10,9 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/cpu.h>
+#include <asm/cpu.h>
 #include <asm/cpu-info.h>
+#include <asm/mipsregs.h>
 #include <bcm63xx_cpu.h>
 #include <bcm63xx_regs.h>
 #include <bcm63xx_io.h>
@@ -296,26 +298,24 @@ void __init bcm63xx_cpu_init(void)
 	expected_cpu_id = 0;
 
 	switch (c->cputype) {
-	/*
-	 * BCM6338 as the same PrId as BCM3302 see arch/mips/kernel/cpu-probe.c
-	 */
-	case CPU_BCM3302:
-		__cpu_name[cpu] = "Broadcom BCM6338";
-		expected_cpu_id = BCM6338_CPU_ID;
-		bcm63xx_regs_base = bcm96338_regs_base;
-		bcm63xx_irqs = bcm96338_irqs;
+	case CPU_BMIPS3300:
+		if ((read_c0_prid() & 0xff00) == PRID_IMP_BMIPS3300_ALT) {
+			expected_cpu_id = BCM6348_CPU_ID;
+			bcm63xx_regs_base = bcm96348_regs_base;
+			bcm63xx_irqs = bcm96348_irqs;
+		} else {
+			__cpu_name[cpu] = "Broadcom BCM6338";
+			expected_cpu_id = BCM6338_CPU_ID;
+			bcm63xx_regs_base = bcm96338_regs_base;
+			bcm63xx_irqs = bcm96338_irqs;
+		}
 		break;
-	case CPU_BCM6345:
+	case CPU_BMIPS32:
 		expected_cpu_id = BCM6345_CPU_ID;
 		bcm63xx_regs_base = bcm96345_regs_base;
 		bcm63xx_irqs = bcm96345_irqs;
 		break;
-	case CPU_BCM6348:
-		expected_cpu_id = BCM6348_CPU_ID;
-		bcm63xx_regs_base = bcm96348_regs_base;
-		bcm63xx_irqs = bcm96348_irqs;
-		break;
-	case CPU_BCM6358:
+	case CPU_BMIPS4350:
 		expected_cpu_id = BCM6358_CPU_ID;
 		bcm63xx_regs_base = bcm96358_regs_base;
 		bcm63xx_irqs = bcm96358_irqs;
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index b201a8f..bd2033b 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -111,14 +111,16 @@
  * These are the PRID's for when 23:16 == PRID_COMP_BROADCOM
  */
 
-#define PRID_IMP_BCM4710	0x4000
-#define PRID_IMP_BCM3302	0x9000
-#define PRID_IMP_BCM6338	0x9000
-#define PRID_IMP_BCM6345	0x8000
-#define PRID_IMP_BCM6348	0x9100
-#define PRID_IMP_BCM4350	0xA000
-#define PRID_REV_BCM6358	0x0010
-#define PRID_REV_BCM6368	0x0030
+#define PRID_IMP_BMIPS4KC	0x4000
+#define PRID_IMP_BMIPS32	0x8000
+#define PRID_IMP_BMIPS3300	0x9000
+#define PRID_IMP_BMIPS3300_ALT	0x9100
+#define PRID_IMP_BMIPS3300_BUG	0x0000
+#define PRID_IMP_BMIPS43XX	0xa000
+#define PRID_IMP_BMIPS5000	0x5a00
+
+#define PRID_REV_BMIPS4380_LO	0x0040
+#define PRID_REV_BMIPS4380_HI	0x006f
 
 /*
  * These are the PRID's for when 23:16 == PRID_COMP_CAVIUM
@@ -223,9 +225,8 @@ enum cpu_type_enum {
 	 * MIPS32 class processors
 	 */
 	CPU_4KC, CPU_4KEC, CPU_4KSC, CPU_24K, CPU_34K, CPU_1004K, CPU_74K,
-	CPU_ALCHEMY, CPU_PR4450, CPU_BCM3302, CPU_BCM4710,
-	CPU_BCM6338, CPU_BCM6345, CPU_BCM6348, CPU_BCM6358,
-	CPU_JZRISC,
+	CPU_ALCHEMY, CPU_PR4450, CPU_BMIPS32, CPU_BMIPS3300, CPU_BMIPS4350,
+	CPU_BMIPS4380, CPU_BMIPS5000, CPU_JZRISC,
 
 	/*
 	 * MIPS64 class processors
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index b1b304e..259cbfa 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -181,10 +181,10 @@ void __init check_wait(void)
 	case CPU_5KC:
 	case CPU_25KF:
 	case CPU_PR4450:
-	case CPU_BCM3302:
-	case CPU_BCM6338:
-	case CPU_BCM6348:
-	case CPU_BCM6358:
+	case CPU_BMIPS3300:
+	case CPU_BMIPS4350:
+	case CPU_BMIPS4380:
+	case CPU_BMIPS5000:
 	case CPU_CAVIUM_OCTEON:
 	case CPU_CAVIUM_OCTEON_PLUS:
 	case CPU_JZRISC:
@@ -902,33 +902,37 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 {
 	decode_configs(c);
 	switch (c->processor_id & 0xff00) {
-	case PRID_IMP_BCM3302:
-	 /* same as PRID_IMP_BCM6338 */
-		c->cputype = CPU_BCM3302;
-		__cpu_name[cpu] = "Broadcom BCM3302";
-		break;
-	case PRID_IMP_BCM4710:
-		c->cputype = CPU_BCM4710;
-		__cpu_name[cpu] = "Broadcom BCM4710";
-		break;
-	case PRID_IMP_BCM6345:
-		c->cputype = CPU_BCM6345;
-		__cpu_name[cpu] = "Broadcom BCM6345";
+	case PRID_IMP_BMIPS32:
+		c->cputype = CPU_BMIPS32;
+		__cpu_name[cpu] = "Broadcom BMIPS32";
+		break;
+	case PRID_IMP_BMIPS3300:
+	case PRID_IMP_BMIPS3300_ALT:
+	case PRID_IMP_BMIPS3300_BUG:
+		c->cputype = CPU_BMIPS3300;
+		__cpu_name[cpu] = "Broadcom BMIPS3300";
+		break;
+	case PRID_IMP_BMIPS43XX: {
+		int rev = c->processor_id & 0xff;
+
+		if (rev >= PRID_REV_BMIPS4380_LO &&
+				rev <= PRID_REV_BMIPS4380_HI) {
+			c->cputype = CPU_BMIPS4380;
+			__cpu_name[cpu] = "Broadcom BMIPS4380";
+		} else {
+			c->cputype = CPU_BMIPS4350;
+			__cpu_name[cpu] = "Broadcom BMIPS4350";
+		}
 		break;
-	case PRID_IMP_BCM6348:
-		c->cputype = CPU_BCM6348;
-		__cpu_name[cpu] = "Broadcom BCM6348";
+	}
+	case PRID_IMP_BMIPS5000:
+		c->cputype = CPU_BMIPS5000;
+		__cpu_name[cpu] = "Broadcom BMIPS5000";
+		c->options |= MIPS_CPU_ULRI;
 		break;
-	case PRID_IMP_BCM4350:
-		switch (c->processor_id & 0xf0) {
-		case PRID_REV_BCM6358:
-			c->cputype = CPU_BCM6358;
-			__cpu_name[cpu] = "Broadcom BCM6358";
-			break;
-		default:
-			c->cputype = CPU_UNKNOWN;
-			break;
-		}
+	case PRID_IMP_BMIPS4KC:
+		c->cputype = CPU_4KC;
+		__cpu_name[cpu] = "MIPS 4Kc";
 		break;
 	}
 }
diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 4510e61..93816f3 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -338,13 +338,12 @@ static void __cpuinit build_tlb_write_entry(u32 **p, struct uasm_label **l,
 	case CPU_4KSC:
 	case CPU_20KC:
 	case CPU_25KF:
-	case CPU_BCM3302:
-	case CPU_BCM4710:
+	case CPU_BMIPS32:
+	case CPU_BMIPS3300:
+	case CPU_BMIPS4350:
+	case CPU_BMIPS4380:
+	case CPU_BMIPS5000:
 	case CPU_LOONGSON2:
-	case CPU_BCM6338:
-	case CPU_BCM6345:
-	case CPU_BCM6348:
-	case CPU_BCM6358:
 	case CPU_R5500:
 		if (m4kc_tlbp_war())
 			uasm_i_nop(p);
-- 
1.7.0.4

