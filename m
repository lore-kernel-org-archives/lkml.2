Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541Ab1KJAJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 19:09:19 -0500
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:43613
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933416Ab1KJAJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 19:09:14 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Timur Tabi <B04825@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        Michael Neuling <mikey@neuling.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Paul Bolle <pebolle@tiscali.nl>,
        Sonny Rao <sonnyrao@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Subject: [RFC PATCH 15/17] powerpc/e500: Fix up all remaining code uses of CONFIG_E500
Date: Wed,  9 Nov 2011 19:07:13 -0500
Message-Id: <1320883635-17194-16-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4E42AB6F.1050900@freescale.com>
References: <4E42AB6F.1050900@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_E500 config option is ambiguous and used incorrectly in many
places to refer to some combination of e500v1/v2, e500mc, and e5500.

Fix up each reference to use the correct combinations of the following
config options:
  CONFIG_FSL_E500_V1_V2
  CONFIG_FSL_E500MC
  CONFIG_FSL_E5500

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/Kconfig                   |    2 +-
 arch/powerpc/include/asm/reg_booke.h   |   17 ++++++++++-------
 arch/powerpc/kernel/cputable.c         |    8 ++++----
 arch/powerpc/kernel/entry_32.S         |    8 +++++---
 arch/powerpc/kvm/Kconfig               |    3 ++-
 arch/powerpc/platforms/Kconfig.cputype |   22 ++++++++++------------
 6 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index e3412a1..53c5acf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -288,7 +288,7 @@ config HUGETLB_PAGE_SIZE_VARIABLE
 
 config MATH_EMULATION
 	bool "Math emulation"
-	depends on 4xx || 8xx || FSL_E200 || PPC_MPC832x || E500
+	depends on 4xx || 8xx || FSL_E200 || PPC_MPC832x || FSL_E500_V1_V2
 	---help---
 	  Some PowerPC chips designed for embedded applications do not have
 	  a floating-point unit and therefore do not implement the
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index 81cd987..845a069 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -206,12 +206,10 @@
 #define PPC47x_MCSR_FPR	0x00800000 /* FPR parity error */
 #define PPC47x_MCSR_IPR	0x00400000 /* Imprecise Machine Check Exception */
 
-#ifdef CONFIG_E500
-/* All e500 */
-#define MCSR_MCP 	0x80000000UL /* Machine Check Input Pin */
-#define MCSR_ICPERR 	0x40000000UL /* I-Cache Parity Error */
-
 /* e500v1/v2 */
+#ifdef CONFIG_FSL_E500_V1_V2
+#define MCSR_MCP	0x80000000UL /* Machine Check Input Pin */
+#define MCSR_ICPERR	0x40000000UL /* I-Cache Parity Error */
 #define MCSR_DCP_PERR 	0x20000000UL /* D-Cache Push Parity Error */
 #define MCSR_DCPERR 	0x10000000UL /* D-Cache Parity Error */
 #define MCSR_BUS_IAERR 	0x00000080UL /* Instruction Address Error */
@@ -222,8 +220,12 @@
 #define MCSR_BUS_WBERR 	0x00000004UL /* Write Data Bus Error */
 #define MCSR_BUS_IPERR 	0x00000002UL /* Instruction parity Error */
 #define MCSR_BUS_RPERR 	0x00000001UL /* Read parity Error */
+#endif
 
-/* e500mc */
+/* e500mc/e5500 */
+#if defined(CONFIG_FSL_E500MC) || defined(CONFIG_FSL_E5500)
+#define MCSR_MCP	0x80000000UL /* Machine Check Input Pin */
+#define MCSR_ICPERR	0x40000000UL /* I-Cache Parity Error */
 #define MCSR_DCPERR_MC	0x20000000UL /* D-Cache Parity Error */
 #define MCSR_L2MMU_MHIT	0x04000000UL /* Hit on multiple TLB entries */
 #define MCSR_NMI	0x00100000UL /* Non-Maskable Interrupt */
@@ -250,7 +252,8 @@
 #endif
 
 /* Bit definitions for the HID1 */
-#ifdef CONFIG_E500
+#if defined(CONFIG_FSL_E500_V1_V2) || defined(CONFIG_FSL_E500MC) \
+		|| defined(CONFIG_FSL_E5500)
 /* e500v1/v2 */
 #define HID1_PLL_CFG_MASK 0xfc000000	/* PLL_CFG input pins */
 #define HID1_RFXE	0x00020000	/* Read fault exception enable */
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index a6f2544..3fd01ca 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -69,10 +69,10 @@ extern void __setup_cpu_power7(unsigned long offset, struct cpu_spec* spec);
 extern void __restore_cpu_power7(void);
 extern void __restore_cpu_a2(void);
 #endif /* CONFIG_PPC64 */
-#if defined(CONFIG_E500)
+#ifdef CONFIG_FSL_E5500
 extern void __setup_cpu_e5500(unsigned long offset, struct cpu_spec* spec);
 extern void __restore_cpu_e5500(void);
-#endif /* CONFIG_E500 */
+#endif /* CONFIG_FSL_E5500 */
 
 /* This table only contains "desktop" CPUs, it need to be filled with embedded
  * ones as well...
@@ -1975,7 +1975,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.platform		= "ppce500mc",
 	},
 #endif /* CONFIG_FSL_E500MC */
-#ifdef CONFIG_E500 /* FIXME */
+#ifdef CONFIG_FSL_E5500
 	{	/* e5500 */
 		.pvr_mask		= 0xffff0000,
 		.pvr_value		= 0x80240000,
@@ -1994,7 +1994,7 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.machine_check		= machine_check_e500mc,
 		.platform		= "ppce5500",
 	},
-#endif /* CONFIG_E500 */
+#endif /* CONFIG_FSL_E5500 */
 
 #ifdef CONFIG_PPC_A2
 	{	/* Standard A2 (>= DD2) + FPU core */
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 56212bc..373cdc4 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -178,14 +178,15 @@ transfer_to_handler:
 	cmplw	r1,r9			/* if r1 <= ksp_limit */
 	ble-	stack_ovf		/* then the kernel stack overflowed */
 5:
-#if defined(CONFIG_6xx) || defined(CONFIG_E500)
+#if defined(CONFIG_6xx) || defined(CONFIG_FSL_E500_V1_V2) \
+		|| defined(CONFIG_FSL_E500MC)
 	rlwinm	r9,r1,0,0,31-THREAD_SHIFT
 	tophys(r9,r9)			/* check local flags */
 	lwz	r12,TI_LOCAL_FLAGS(r9)
 	mtcrf	0x01,r12
 	bt-	31-TLF_NAPPING,4f
 	bt-	31-TLF_SLEEPING,7f
-#endif /* CONFIG_6xx || CONFIG_E500 */
+#endif
 	.globl transfer_to_handler_cont
 transfer_to_handler_cont:
 3:
@@ -236,7 +237,8 @@ reenable_mmu:				/* re-enable mmu so we can */
 	RFI				/* jump to handler, enable MMU */
 #endif /* CONFIG_TRACE_IRQFLAGS */
 
-#if defined (CONFIG_6xx) || defined(CONFIG_E500)
+#if defined (CONFIG_6xx) || defined(CONFIG_FSL_E500_V1_V2) \
+		|| defined(CONFIG_FSL_E500MC)
 4:	rlwinm	r12,r12,0,~_TLF_NAPPING
 	stw	r12,TI_LOCAL_FLAGS(r9)
 	b	power_save_ppc32_restore
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 78133de..3f608bf 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -116,7 +116,8 @@ config KVM_EXIT_TIMING
 
 config KVM_E500
 	bool "KVM support for PowerPC E500 processors"
-	depends on EXPERIMENTAL && E500
+	depends on EXPERIMENTAL
+	depends on FSL_E500_V1_V2 || FSL_E500MC || FSL_E5500
 	select KVM
 	select KVM_MMIO
 	---help---
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index cff45e3..22df19d 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -159,7 +159,7 @@ config PPC_FPU
 
 config FSL_EMB_PERFMON
 	bool "Freescale Embedded Perfmon"
-	depends on E500 || PPC_83xx
+	depends on PPC_83xx || FSL_E500_V1_V2 || FSL_E500MC || FSL_E5500
 	help
 	  This is the Performance Monitor support found on the e500 core
 	  and some e300 cores (c3 and c4).  Select this only if your
@@ -171,25 +171,23 @@ config FSL_EMB_PERF_EVENT
 	default y
 
 config FSL_EMB_PERF_EVENT_E500
-	bool
-	depends on FSL_EMB_PERF_EVENT && E500
-	default y
+	def_bool y
+	depends on FSL_EMB_PERF_EVENT
+	depends on FSL_E500_V1_V2 || FSL_E500MC || FSL_E5500
 
 config 4xx
 	bool
 	depends on 40x || 44x
 	default y
 
-config BOOKE
-	bool
-	depends on FSL_E200 || E500 || 44x || PPC_BOOK3E
-	default y
-
 config FSL_BOOKE
-	bool
-	depends on FSL_E200 || (E500 && PPC32)
+	def_bool y
+	depends on FSL_E200 || FSL_E500_V1_V2 || FSL_E500MC
 	select SYS_SUPPORTS_HUGETLBFS if PHYS_64BIT
-	default y
+
+config BOOKE
+	def_bool y
+	depends on FSL_BOOKE || 44x || PPC_BOOK3E
 
 config FSL_CORENET
 	bool
-- 
1.7.2.5

