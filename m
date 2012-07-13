Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab2GMUqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:46:04 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3901 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab2GMUqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:46:01 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Al Cooper" <alcooperx@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
cc: "Al Cooper" <alcooperx@gmail.com>
Subject: [PATCH 2/5] MIPS: perf: Add cpu feature bit for PCI
 (performance counter interrupt)
Date: Fri, 13 Jul 2012 16:44:51 -0400
Message-ID: <1342212294-23014-2-git-send-email-alcooperx@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1342212294-23014-1-git-send-email-alcooperx@gmail.com>
References: <y> <1342212294-23014-1-git-send-email-alcooperx@gmail.com>
MIME-Version: 1.0
X-WSS-ID: 7C1E57523MK9973571-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI (Program Counter Interrupt) bit in the "cause" register
is mandatory for MIPS32R2 cores, but has also been added to some R1
cores (BMIPS5000). This change adds a cpu feature bit to make it
easier to check for and use this feature.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
---
 arch/mips/include/asm/cpu-features.h |    4 ++++
 arch/mips/include/asm/cpu.h          |    1 +
 arch/mips/include/asm/mipsregs.h     |    2 ++
 arch/mips/kernel/cpu-probe.c         |    5 ++++-
 arch/mips/kernel/perf_event_mipsxx.c |    2 +-
 5 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index ca400f7..55db8e1 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -252,4 +252,8 @@
 #define cpu_hwrena_impl_bits		0
 #endif
 
+#ifndef cpu_has_perf_cntr_intr_bit
+#define cpu_has_perf_cntr_intr_bit	(cpu_data[0].options & MIPS_CPU_PCI)
+#endif
+
 #endif /* __ASM_CPU_FEATURES_H */
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index f21b7c0..783e598 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -319,6 +319,7 @@ enum cpu_type_enum {
 #define MIPS_CPU_VINT		0x00080000 /* CPU supports MIPSR2 vectored interrupts */
 #define MIPS_CPU_VEIC		0x00100000 /* CPU supports MIPSR2 external interrupt controller mode */
 #define MIPS_CPU_ULRI		0x00200000 /* CPU has ULRI feature */
+#define MIPS_CPU_PCI		0x00400000 /* CPU has Perf Ctr Int indicator */
 
 /*
  * CPU ASE encodings
diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index 7f87d82..2b83c36 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -458,6 +458,8 @@
 #define  CAUSEF_IP7		(_ULCAST_(1)   << 15)
 #define  CAUSEB_IV		23
 #define  CAUSEF_IV		(_ULCAST_(1)   << 23)
+#define  CAUSEB_PCI		26
+#define  CAUSEF_PCI		(_ULCAST_(1)   << 26)
 #define  CAUSEB_CE		28
 #define  CAUSEF_CE		(_ULCAST_(3)   << 28)
 #define  CAUSEB_TI		30
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 1b51046..7ae3895 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1186,8 +1186,11 @@ __cpuinit void cpu_probe(void)
 		}
 	}
 
-	if (cpu_has_mips_r2)
+	if (cpu_has_mips_r2) {
 		c->srsets = ((read_c0_srsctl() >> 26) & 0x0f) + 1;
+		/* R2 has Performance Counter Interrupt indicator */
+		c->options |= MIPS_CPU_PCI;
+	}
 	else
 		c->srsets = 1;
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 8451f04..4ee1111 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1158,7 +1158,7 @@ static int mipsxx_pmu_handle_shared_irq(void)
 	int handled = IRQ_NONE;
 	struct pt_regs *regs;
 
-	if (cpu_has_mips_r2 && !(read_c0_cause() & (1 << 26)))
+	if (cpu_has_perf_cntr_intr_bit && !(read_c0_cause() & CAUSEF_PCI))
 		return handled;
 	/*
 	 * First we pause the local counters, so that when we are locked
-- 
1.7.6


