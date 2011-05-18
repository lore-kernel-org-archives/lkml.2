Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1ERV0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:26:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41817 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab1ERVZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yEEDmJVquasTeogI2QbKcrHPSga5fmqk2wGnbiJmcOaQEehRUzHVHrzbN2ow3Z/D9o
         NhAOGQo9OiJkbNkBcTxHHW42mSM0CXnCmWXRr+KatIHAMMRsBXqFReVbB+rtic/QhQlM
         qF75kpxjFotWNvkKetPzAbYCNV3jlDKZl1U4s=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH 4/7] [RFC] enable L1_WRITETHROUGH mode for BG/P
Date: Wed, 18 May 2011 16:24:52 -0500
Message-Id: <1305753895-24845-4-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BG/P nodes need to be configured for writethrough to work in SMP
configurations.  This patch adds the right hooks in the MMU code
to make sure L1_WRITETHROUGH configurations are setup for BG/P.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/include/asm/mmu-44x.h     |    2 ++
 arch/powerpc/kernel/head_44x.S         |   24 ++++++++++++++++++++++--
 arch/powerpc/kernel/misc_32.S          |   15 +++++++++++++++
 arch/powerpc/lib/copy_32.S             |   10 ++++++++++
 arch/powerpc/mm/44x_mmu.c              |    7 +++++--
 arch/powerpc/platforms/Kconfig         |    5 +++++
 arch/powerpc/platforms/Kconfig.cputype |    4 ++++
 7 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu-44x.h b/arch/powerpc/include/asm/mmu-44x.h
index bf52d70..ca1b90c 100644
--- a/arch/powerpc/include/asm/mmu-44x.h
+++ b/arch/powerpc/include/asm/mmu-44x.h
@@ -8,6 +8,7 @@
 
 #define PPC44x_MMUCR_TID	0x000000ff
 #define PPC44x_MMUCR_STS	0x00010000
+#define PPC44x_MMUCR_U2		0x00200000
 
 #define	PPC44x_TLB_PAGEID	0
 #define	PPC44x_TLB_XLAT		1
@@ -32,6 +33,7 @@
 
 /* Storage attribute and access control fields */
 #define PPC44x_TLB_ATTR_MASK	0x0000ff80
+#define PPC44x_TLB_WL1		0x00100000	/* Write-through L1 */
 #define PPC44x_TLB_U0		0x00008000      /* User 0 */
 #define PPC44x_TLB_U1		0x00004000      /* User 1 */
 #define PPC44x_TLB_U2		0x00002000      /* User 2 */
diff --git a/arch/powerpc/kernel/head_44x.S b/arch/powerpc/kernel/head_44x.S
index 5e12b74..1f7ae60 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -429,7 +429,16 @@ finish_tlb_load_44x:
 	andi.	r10,r12,_PAGE_USER		/* User page ? */
 	beq	1f				/* nope, leave U bits empty */
 	rlwimi	r11,r11,3,26,28			/* yes, copy S bits to U */
-1:	tlbwe	r11,r13,PPC44x_TLB_ATTRIB	/* Write ATTRIB */
+1:
+#ifdef CONFIG_L1_WRITETHROUGH
+	andi.	r10, r11, PPC44x_TLB_I
+	bne	2f
+	oris    r11,r11,PPC44x_TLB_WL1@h	/* Add coherency for */
+						/* non-inhibited */
+	ori	r11,r11,PPC44x_TLB_U2|PPC44x_TLB_M
+2:
+#endif /* CONFIG_L1_WRITETHROUGH */
+	tlbwe	r11,r13,PPC44x_TLB_ATTRIB	/* Write ATTRIB */
 
 	/* Done...restore registers and get out of here.
 	*/
@@ -799,7 +808,11 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	sync
 
 	/* Initialize MMUCR */
+#ifdef CONFIG_L1_WRITETHROUGH
+	lis	r5, PPC44x_MMUCR_U2@h
+#else
 	li	r5,0
+#endif /* CONFIG_L1_WRITETHROUGH */
 	mtspr	SPRN_MMUCR,r5
 	sync
 
@@ -814,7 +827,14 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	/* attrib fields */
 	/* Added guarded bit to protect against speculative loads/stores */
 	li	r5,0
-	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
+#ifdef CONFIG_L1_WRITETHROUGH
+	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
+						PPC44x_TLB_G | PPC44x_TLB_U2)
+	oris	r5,r5,PPC44x_TLB_WL1@h
+#else
+	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
+			PPC44x_TLB_G)
+#endif /* CONFIG_L1_WRITETHROUGH
 
         li      r0,63                    /* TLB slot 63 */
 
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 094bd98..d88369b 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -506,7 +506,20 @@ _GLOBAL(clear_pages)
 	li	r0,PAGE_SIZE/L1_CACHE_BYTES
 	slw	r0,r0,r4
 	mtctr	r0
+#ifdef CONFIG_L1_WRITETHROUGH
+	/* assuming 32 byte cacheline */
+	li      r4, 0
+1:	stw     r4, 0(r3)
+	stw     r4, 4(r3)
+	stw     r4, 8(r3)
+	stw     r4, 12(r3)
+	stw     r4, 16(r3)
+	stw     r4, 20(r3)
+	stw     r4, 24(r3)
+	stw     r4, 28(r3)
+#else
 1:	dcbz	0,r3
+#endif /* CONFIG_L1_WRITETHROUGH */
 	addi	r3,r3,L1_CACHE_BYTES
 	bdnz	1b
 	blr
@@ -550,7 +563,9 @@ _GLOBAL(copy_page)
 	mtctr	r0
 1:
 	dcbt	r11,r4
+#ifndef CONFIG_L1_WRITETHROUGH
 	dcbz	r5,r3
+#endif
 	COPY_16_BYTES
 #if L1_CACHE_BYTES >= 32
 	COPY_16_BYTES
diff --git a/arch/powerpc/lib/copy_32.S b/arch/powerpc/lib/copy_32.S
index 55f19f9..98a07e3 100644
--- a/arch/powerpc/lib/copy_32.S
+++ b/arch/powerpc/lib/copy_32.S
@@ -98,7 +98,11 @@ _GLOBAL(cacheable_memzero)
 	bdnz	4b
 3:	mtctr	r9
 	li	r7,4
+#ifdef CONFIG_L1_WRITETHROUGH
+10:
+#else
 10:	dcbz	r7,r6
+#endif /* CONFIG_L1_WRITETHROUGH */
 	addi	r6,r6,CACHELINE_BYTES
 	bdnz	10b
 	clrlwi	r5,r8,32-LG_CACHELINE_BYTES
@@ -187,7 +191,9 @@ _GLOBAL(cacheable_memcpy)
 	mtctr	r0
 	beq	63f
 53:
+#ifndef CONFIG_L1_WRITETHROUGH
 	dcbz	r11,r6
+#endif /* CONFIG_L1_WRITETHROUGH */
 	COPY_16_BYTES
 #if L1_CACHE_BYTES >= 32
 	COPY_16_BYTES
@@ -368,7 +374,11 @@ _GLOBAL(__copy_tofrom_user)
 	mtctr	r8
 
 53:	dcbt	r3,r4
+#ifdef CONFIG_L1_WRITETHROUGH
+54:
+#else
 54:	dcbz	r11,r6
+#endif
 	.section __ex_table,"a"
 	.align	2
 	.long	54b,105f
diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index 024acab..b684c8a 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -80,9 +80,12 @@ static void __init ppc44x_pin_tlb(unsigned int virt, unsigned int phys)
 	:
 #ifdef CONFIG_PPC47x
 	: "r" (PPC47x_TLB2_S_RWX),
-#else
+#elseif CONFIG_L1_WRITETHROUGH
+	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_WL1 \
+		| PPC44x_TLB_U2 | PPC44x_TLB_M),
+#else /* neither CONFIG_PPC47x or CONFIG_L1_WRITETHROUGH */
 	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
-#endif
+#endif /* CONFIG_PPC47x */
 	  "r" (phys),
 	  "r" (virt | PPC44x_TLB_VALID | PPC44x_TLB_256M),
 	  "r" (entry),
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index f7b0772..684a281 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -348,4 +348,9 @@ config XILINX_PCI
 	bool "Xilinx PCI host bridge support"
 	depends on PCI && XILINX_VIRTEX
 
+config L1_WRITETHROUGH
+	bool "Blue Gene/P enabled writethrough mode"
+	depends on BGP
+	default y
+
 endmenu
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 111138c..3a3c711 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -329,9 +329,13 @@ config NOT_COHERENT_CACHE
 	bool
 	depends on 4xx || 8xx || E200 || PPC_MPC512x || GAMECUBE_COMMON
 	default n if PPC_47x
+	default n if BGP
 	default y
 
 config CHECK_CACHE_COHERENCY
 	bool
 
+config L1_WRITETHROUGH
+	bool
+
 endmenu
-- 
1.7.4.1

