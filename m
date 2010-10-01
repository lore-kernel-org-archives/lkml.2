Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0JAHIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:08:54 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44918 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab0JAHG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:27 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Torez Smith <lnxtorez@linux.vnet.ibm.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 06/18] powerpc 44x: Set E bit in TLBs and PTEs when CPU is in little endian mode
Date: Fri,  1 Oct 2010 17:05:59 +1000
Message-Id: <1285916771-18033-7-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The endianness on the 44x CPUs is controlled by the E bit in the TLB
entries. If the kernel has been compiled for little endian this patch
sets this E bit wherever they are set - in the PTE base flags, the early
debugging, and TLB pinning.

It defines some _PAGE_CPUENDIAN and ..._TLB_CPUE macros which are set
if the CPU is little endian or 0 if the CPU is big endian so these can
be used to easily set the E bit only if the CPU is little endian.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/mmu-44x.h    |   12 ++++++++++++
 arch/powerpc/include/asm/pte-44x.h    |    4 ++++
 arch/powerpc/include/asm/pte-common.h |    9 ++++++---
 arch/powerpc/kernel/head_44x.S        |    6 +++---
 arch/powerpc/mm/44x_mmu.c             |    4 ++--
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-44x.h b/arch/powerpc/include/asm/mmu-44x.h
index bf52d70..e96f5c3 100644
--- a/arch/powerpc/include/asm/mmu-44x.h
+++ b/arch/powerpc/include/asm/mmu-44x.h
@@ -42,6 +42,12 @@
 #define PPC44x_TLB_G		0x00000100      /* Memory is guarded */
 #define PPC44x_TLB_E		0x00000080      /* Memory is little endian */
 
+#ifdef __LITTLE_ENDIAN__
+#define PPC44x_TLB_CPUE		PPC44x_TLB_E
+#else
+#define PPC44x_TLB_CPUE		0
+#endif
+
 #define PPC44x_TLB_PERM_MASK	0x0000003f
 #define PPC44x_TLB_UX		0x00000020      /* User execution */
 #define PPC44x_TLB_UW		0x00000010      /* User write */
@@ -99,6 +105,12 @@
 #define PPC47x_TLB2_S_RW	(PPC47x_TLB2_SW | PPC47x_TLB2_SR)
 #define PPC47x_TLB2_IMG		(PPC47x_TLB2_I | PPC47x_TLB2_M | PPC47x_TLB2_G)
 
+#ifdef __LITTLE_ENDIAN__
+#define PPC47x_TLB2_CPUE	PPC47x_TLB2_E
+#else
+#define PPC47x_TLB2_CPUE	0
+#endif
+
 #ifndef __ASSEMBLY__
 
 extern unsigned int tlb_44x_hwater;
diff --git a/arch/powerpc/include/asm/pte-44x.h b/arch/powerpc/include/asm/pte-44x.h
index 4192b9b..9c79a85 100644
--- a/arch/powerpc/include/asm/pte-44x.h
+++ b/arch/powerpc/include/asm/pte-44x.h
@@ -89,6 +89,10 @@
 #define _PAGE_NO_CACHE	0x00000400		/* H: I bit */
 #define _PAGE_WRITETHRU	0x00000800		/* H: W bit */
 
+#ifdef __LITTLE_ENDIAN__
+#define _PAGE_CPUENDIAN	_PAGE_ENDIAN
+#endif
+
 /* TODO: Add large page lowmem mapping support */
 #define _PMD_PRESENT	0
 #define _PMD_PRESENT_MASK (PAGE_MASK)
diff --git a/arch/powerpc/include/asm/pte-common.h b/arch/powerpc/include/asm/pte-common.h
index f2b3701..b69609c 100644
--- a/arch/powerpc/include/asm/pte-common.h
+++ b/arch/powerpc/include/asm/pte-common.h
@@ -19,6 +19,9 @@
 #ifndef _PAGE_ENDIAN
 #define _PAGE_ENDIAN	0
 #endif
+#ifndef _PAGE_CPUENDIAN
+#define _PAGE_CPUENDIAN	0
+#endif
 #ifndef _PAGE_COHERENT
 #define _PAGE_COHERENT	0
 #endif
@@ -104,11 +107,11 @@ extern unsigned long bad_call_to_PMD_PAGE_SIZE(void);
  * pages. We always set _PAGE_COHERENT when SMP is enabled or
  * the processor might need it for DMA coherency.
  */
-#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE)
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE | _PAGE_CPUENDIAN)
 #if defined(CONFIG_SMP) || defined(CONFIG_PPC_STD_MMU)
-#define _PAGE_BASE	(_PAGE_BASE_NC | _PAGE_COHERENT)
+#define _PAGE_BASE	(_PAGE_BASE_NC | _PAGE_COHERENT | _PAGE_CPUENDIAN)
 #else
-#define _PAGE_BASE	(_PAGE_BASE_NC)
+#define _PAGE_BASE	(_PAGE_BASE_NC | _PAGE_CPUENDIAN)
 #endif
 
 /* Permission masks used to generate the __P and __S table,
diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index 562305b..6198733 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -813,7 +813,7 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	/* attrib fields */
 	/* Added guarded bit to protect against speculative loads/stores */
 	li	r5,0
-	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
+	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G | PPC44x_TLB_CPUE)
 
         li      r0,63                    /* TLB slot 63 */
 
@@ -850,7 +850,7 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	ori	r4,r4,CONFIG_PPC_EARLY_DEBUG_44x_PHYSHIGH
 
 	/* attrib fields */
-	li	r5,(PPC44x_TLB_SW|PPC44x_TLB_SR|PPC44x_TLB_I|PPC44x_TLB_G)
+	li	r5,(PPC44x_TLB_SW|PPC44x_TLB_SR|PPC44x_TLB_I|PPC44x_TLB_G|PPC44x_TLB_CPUE)
         li      r0,62                    /* TLB slot 0 */
 
 	tlbwe	r3,r0,PPC44x_TLB_PAGEID
@@ -1068,7 +1068,7 @@ clear_utlb_entry:
 	ori	r4,r4,CONFIG_PPC_EARLY_DEBUG_44x_PHYSHIGH
 
 	/* Word 2 */
-	li	r5,(PPC47x_TLB2_S_RW | PPC47x_TLB2_IMG)
+	li	r5,(PPC47x_TLB2_S_RW | PPC47x_TLB2_IMG | PPC47x_TLB2_CPUE)
 
 	/* Bolted in way 0, bolt slot 5, we -hope- we don't hit the same
 	 * congruence class as the kernel, we need to make sure of it at
diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index d8c6efb..70760e7 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -79,7 +79,7 @@ static void __init ppc44x_pin_tlb(unsigned int virt, unsigned int phys)
 #ifdef CONFIG_PPC47x
 	: "r" (PPC47x_TLB2_S_RWX),
 #else
-	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
+	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G | PPC44x_TLB_CPUE),
 #endif
 	  "r" (phys),
 	  "r" (virt | PPC44x_TLB_VALID | PPC44x_TLB_256M),
@@ -163,7 +163,7 @@ static void __cpuinit ppc47x_pin_tlb(unsigned int virt, unsigned int phys)
 		"tlbwe	%0,%3,2\n"
 		:
 		: "r" (PPC47x_TLB2_SW | PPC47x_TLB2_SR |
-		       PPC47x_TLB2_SX
+		       PPC47x_TLB2_SX |  PPC47x_TLB2_CPUE
 #ifdef CONFIG_SMP
 		       | PPC47x_TLB2_M
 #endif
-- 
1.7.1

