Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0JZCyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284Ab0JZCyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 13/43] MN10300: Add CPU register bits for AM34
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Date: Tue, 26 Oct 2010 03:54:11 +0100
Message-ID: <20101026025411.23512.67442.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>

Add CPU register declarations for the AM34 subarch.

Signed-off-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig                |    7 +++
 arch/mn10300/include/asm/cpu-regs.h |   72 +++++++++++++++++++++++++++++++++--
 2 files changed, 74 insertions(+), 5 deletions(-)


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 275963e..eab0c2a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -17,6 +17,7 @@ config AM33_3
 
 config AM34_2
 	def_bool n
+	select MN10300_HAS_ATOMIC_OPS_UNIT
 
 config MMU
 	def_bool y
@@ -124,6 +125,12 @@ config MN10300_CPU_AM33V2
 
 endchoice
 
+config MN10300_HAS_ATOMIC_OPS_UNIT
+	def_bool n
+	help
+	  This should be enabled if the processor has an atomic ops unit
+	  capable of doing LL/SC equivalent operations.
+
 config FPU
 	bool "FPU present"
 	default y
diff --git a/arch/mn10300/include/asm/cpu-regs.h b/arch/mn10300/include/asm/cpu-regs.h
index 757e9b5..00e306c 100644
--- a/arch/mn10300/include/asm/cpu-regs.h
+++ b/arch/mn10300/include/asm/cpu-regs.h
@@ -15,7 +15,6 @@
 #include <linux/types.h>
 #endif
 
-#ifdef CONFIG_MN10300_CPU_AM33V2
 /* we tell the compiler to pretend to be AM33 so that it doesn't try and use
  * the FP regs, but tell the assembler that we're actually allowed AM33v2
  * instructions */
@@ -24,7 +23,6 @@ asm(" .am33_2\n");
 #else
 .am33_2
 #endif
-#endif
 
 #ifdef __KERNEL__
 
@@ -58,6 +56,9 @@ asm(" .am33_2\n");
 #define EPSW_nAR		0x00040000	/* register bank control */
 #define EPSW_ML			0x00080000	/* monitor level */
 #define EPSW_FE			0x00100000	/* FPU enable */
+#define EPSW_IM_SHIFT		8		/* EPSW_IM_SHIFT determines the interrupt mode */
+
+#define NUM2EPSW_IM(num)	((num) << EPSW_IM_SHIFT)
 
 /* FPU registers */
 #define FPCR_EF_I		0x00000001	/* inexact result FPU exception flag */
@@ -99,9 +100,11 @@ asm(" .am33_2\n");
 #define CPUREV			__SYSREGC(0xc0000050, u32)	/* CPU revision register */
 #define CPUREV_TYPE		0x0000000f	/* CPU type */
 #define CPUREV_TYPE_S		0
-#define CPUREV_TYPE_AM33V1	0x00000000	/* - AM33 V1 core, AM33/1.00 arch */
-#define CPUREV_TYPE_AM33V2	0x00000001	/* - AM33 V2 core, AM33/2.00 arch */
-#define CPUREV_TYPE_AM34V1	0x00000002	/* - AM34 V1 core, AM33/2.00 arch */
+#define CPUREV_TYPE_AM33_1	0x00000000	/* - AM33-1 core, AM33/1.00 arch */
+#define CPUREV_TYPE_AM33_2	0x00000001	/* - AM33-2 core, AM33/2.00 arch */
+#define CPUREV_TYPE_AM34_1	0x00000002	/* - AM34-1 core, AM33/2.00 arch */
+#define CPUREV_TYPE_AM33_3	0x00000003	/* - AM33-3 core, AM33/2.00 arch */
+#define CPUREV_TYPE_AM34_2	0x00000004	/* - AM34-2 core, AM33/3.00 arch */
 #define CPUREV_REVISION		0x000000f0	/* CPU revision */
 #define CPUREV_REVISION_S	4
 #define CPUREV_ICWAY		0x00000f00	/* number of instruction cache ways */
@@ -180,6 +183,21 @@ asm(" .am33_2\n");
 #define CHCTR_ICWMD		0x0f00		/* instruction cache way mode */
 #define CHCTR_DCWMD		0xf000		/* data cache way mode */
 
+#ifdef CONFIG_AM34_2
+#define ICIVCR			__SYSREG(0xc0000c00, u32)	/* icache area invalidate control */
+#define ICIVCR_ICIVBSY		0x00000008			/* icache area invalidate busy */
+#define ICIVCR_ICI		0x00000001			/* icache area invalidate */
+
+#define ICIVMR			__SYSREG(0xc0000c04, u32)	/* icache area invalidate mask */
+
+#define	DCPGCR			__SYSREG(0xc0000c10, u32)	/* data cache area purge control */
+#define	DCPGCR_DCPGBSY		0x00000008			/* data cache area purge busy */
+#define	DCPGCR_DCP		0x00000002			/* data cache area purge */
+#define	DCPGCR_DCI		0x00000001			/* data cache area invalidate */
+
+#define	DCPGMR			__SYSREG(0xc0000c14, u32)	/* data cache area purge mask */
+#endif /* CONFIG_AM34_2 */
+
 /* MMU control registers */
 #define MMUCTR			__SYSREG(0xc0000090, u32)	/* MMU control register */
 #define MMUCTR_IRP		0x0000003f	/* instruction TLB replace pointer */
@@ -203,6 +221,9 @@ asm(" .am33_2\n");
 #define MMUCTR_DTL_LOCK0_3	0x03000000	/* - entry 0-3 locked */
 #define MMUCTR_DTL_LOCK0_7	0x04000000	/* - entry 0-7 locked */
 #define MMUCTR_DTL_LOCK0_15	0x05000000	/* - entry 0-15 locked */
+#ifdef CONFIG_AM34_2
+#define MMUCTR_WTE		0x80000000	/* write-through cache TLB entry bit enable */
+#endif
 
 #define PIDR			__SYSREG(0xc0000094, u16)	/* PID register */
 #define PIDR_PID		0x00ff		/* process identifier */
@@ -285,6 +306,47 @@ asm(" .am33_2\n");
 #define MMUFCR_xFC_PR_RWK_RWU	0x01c0		/* - R/W kernel and R/W user */
 #define MMUFCR_xFC_ILLADDR	0x0200		/* illegal address excep flag */
 
+#ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+/* atomic operation registers */
+#define AAR		__SYSREG(0xc0000a00, u32)	/* cacheable address */
+#define AAR2		__SYSREG(0xc0000a04, u32)	/* uncacheable address */
+#define ADR		__SYSREG(0xc0000a08, u32)	/* data */
+#define ASR		__SYSREG(0xc0000a0c, u32)	/* status */
+#define AARU		__SYSREG(0xd400aa00, u32)	/* user address */
+#define ADRU		__SYSREG(0xd400aa08, u32)	/* user data */
+#define ASRU		__SYSREG(0xd400aa0c, u32)	/* user status */
+
+#define ASR_RW		0x00000008	/* read */
+#define ASR_BW		0x00000004	/* bus error */
+#define ASR_IW		0x00000002	/* interrupt */
+#define ASR_LW		0x00000001	/* bus lock */
+
+#define ASRU_RW		ASR_RW		/* read */
+#define ASRU_BW		ASR_BW		/* bus error */
+#define ASRU_IW		ASR_IW		/* interrupt */
+#define ASRU_LW		ASR_LW		/* bus lock */
+
+/* in inline ASM, we stick the base pointer in to a reg and use offsets from
+ * it */
+#define ATOMIC_OPS_BASE_ADDR 0xc0000a00
+#ifndef __ASSEMBLY__
+asm(
+	"_AAR	= 0\n"
+	"_AAR2	= 4\n"
+	"_ADR	= 8\n"
+	"_ASR	= 12\n");
+#else
+#define _AAR		0
+#define _AAR2		4
+#define _ADR		8
+#define _ASR		12
+#endif
+
+/* physical page address for userspace atomic operations registers */
+#define USER_ATOMIC_OPS_PAGE_ADDR  0xd400a000
+
+#endif /* CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT */
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_CPU_REGS_H */

