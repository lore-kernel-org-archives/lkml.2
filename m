Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1FGVge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:36:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41328 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1FGVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DuVH0bOQQT1GOg0Z0bY/pVgN3WRnoQ7dOlzLbvzO6wMCE8UrrsDw8fu1c6449r6jDv
         Y3NT+AZY43gxG341IhBaNAOVAIVGA/Zqbsta9A/cqkB2zg0Uef2rgtthpF68luX7ZwTT
         U0l19iR30BgQPx/NkuRmAN5hV98DjkJlJ4STQ=
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, bg-linux@lists.anl-external.org,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] [RFC][V3] bluegene: use MMU feature flag to conditionalize L1 writethrough code
Date: Tue,  7 Jun 2011 16:36:13 -0500
Message-Id: <1307482573-25440-1-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BG/P nodes need to be configured for writethrough to work in SMP
configurations.  This patch adds the right hooks in the MMU code
to make sure BGP_L1_WRITETHROUGH configurations are setup for BG/P.

RFC note: this essentially just changes the ifdefs to use the
BEGIN_MMU_FTR_SECTION macros.  A couple of things that I really didn't
like about this:
  a) we introduced at least one extra op that isn't needed to get around
     otherwise having multiple labels
  b) we are introducting a bunch of no-ops in places that could be critical
     paths and jimix says this may not be the best thing for multiple reasons
     including having no-ops around the DCBZs is a bad thing
  c) the ELSE_MMU_FTR_SECTION stuff appears to be broken (or I don't know
     how to use it, it gave me the error:
       Error: non-constant expression in ".if" statement
     so I switched out the else clauses with redundant FTR_SECTIONS
     (one for IFSET and on for IFCLR).  Please someone throw me a clue
     as to what I was doing wrong.  I'm running gcc 4.3.2 from crosstools-ng
     if it has some sort of impact.

Jimix has thrown me some code to try and do a better job by branching
to stub code inside of the MMU_FTRs so I don't have so many no-ops.  I'm
open to alternatives.  jimix also suggested changing NEED_L1_WRITETHROUGH
to DCBZ_BROKEN, which I'm open to if you think appropriate, or maybe
DCBZ_BROKEN_DAMNIT would be more apt.

Thanks for any help.

Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 arch/powerpc/include/asm/mmu-44x.h |    2 ++
 arch/powerpc/kernel/head_44x.S     |   27 +++++++++++++++++++++++++--
 arch/powerpc/kernel/misc_32.S      |   24 +++++++++++++++++++++++-
 arch/powerpc/lib/copy_32.S         |   13 +++++++++++--
 arch/powerpc/mm/44x_mmu.c          |    7 +++++--
 5 files changed, 66 insertions(+), 7 deletions(-)

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
index 5e12b74..9a9a4ee 100644
--- a/arch/powerpc/kernel/head_44x.S
+++ b/arch/powerpc/kernel/head_44x.S
@@ -429,7 +429,17 @@ finish_tlb_load_44x:
 	andi.	r10,r12,_PAGE_USER		/* User page ? */
 	beq	1f				/* nope, leave U bits empty */
 	rlwimi	r11,r11,3,26,28			/* yes, copy S bits to U */
-1:	tlbwe	r11,r13,PPC44x_TLB_ATTRIB	/* Write ATTRIB */
+1:
+BEGIN_MMU_FTR_SECTION
+	andi.	r10, r11, PPC44x_TLB_I
+	bne	2f
+	oris    r11,r11,PPC44x_TLB_WL1@h	/* Add coherency for */
+						/* non-inhibited */
+	ori	r11,r11,PPC44x_TLB_U2|PPC44x_TLB_M
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
+
+2:
+	tlbwe	r11,r13,PPC44x_TLB_ATTRIB	/* Write ATTRIB */
 
 	/* Done...restore registers and get out of here.
 	*/
@@ -799,7 +809,12 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	sync
 
 	/* Initialize MMUCR */
+BEGIN_MMU_FTR_SECTION
+	lis	r5, PPC44x_MMUCR_U2@h
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
+BEGIN_MMU_FTR_SECTION
 	li	r5,0
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 	mtspr	SPRN_MMUCR,r5
 	sync
 
@@ -814,7 +829,15 @@ skpinv:	addi	r4,r4,1				/* Increment */
 	/* attrib fields */
 	/* Added guarded bit to protect against speculative loads/stores */
 	li	r5,0
-	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
+BEGIN_MMU_FTR_SECTION
+	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
+						PPC44x_TLB_G | PPC44x_TLB_U2)
+	oris	r5,r5,PPC44x_TLB_WL1@h
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
+BEGIN_MMU_FTR_SECTION
+	ori	r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
+			PPC44x_TLB_G)
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 
         li      r0,63                    /* TLB slot 63 */
 
diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
index 998a100..b54e2e8 100644
--- a/arch/powerpc/kernel/misc_32.S
+++ b/arch/powerpc/kernel/misc_32.S
@@ -506,7 +506,27 @@ _GLOBAL(clear_pages)
 	li	r0,PAGE_SIZE/L1_CACHE_BYTES
 	slw	r0,r0,r4
 	mtctr	r0
-1:	dcbz	0,r3
+	li      r4, 0
+1:
+BEGIN_MMU_FTR_SECTION
+	/* assuming 32 byte cacheline */
+	stw     r4, 0(r3)
+	stw     r4, 4(r3)
+	stw     r4, 8(r3)
+	stw     r4, 12(r3)
+	stw     r4, 16(r3)
+	stw     r4, 20(r3)
+	stw     r4, 24(r3)
+	stw     r4, 28(r3)
+END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
+/*
+ * would have used an ELSE_MMU_FTR_SECTION here but it
+ * broke the code with Error: non-constant expression in ".if" statement
+ *
+ */
+BEGIN_MMU_FTR_SECTION
+	dcbz	0,r3
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 	addi	r3,r3,L1_CACHE_BYTES
 	bdnz	1b
 	blr
@@ -550,7 +570,9 @@ _GLOBAL(copy_page)
 	mtctr	r0
 1:
 	dcbt	r11,r4
+BEGIN_MMU_FTR_SECTION
 	dcbz	r5,r3
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 	COPY_16_BYTES
 #if L1_CACHE_BYTES >= 32
 	COPY_16_BYTES
diff --git a/arch/powerpc/lib/copy_32.S b/arch/powerpc/lib/copy_32.S
index 55f19f9..2646838 100644
--- a/arch/powerpc/lib/copy_32.S
+++ b/arch/powerpc/lib/copy_32.S
@@ -12,6 +12,7 @@
 #include <asm/cache.h>
 #include <asm/errno.h>
 #include <asm/ppc_asm.h>
+#include <asm/mmu.h>
 
 #define COPY_16_BYTES		\
 	lwz	r7,4(r4);	\
@@ -98,7 +99,10 @@ _GLOBAL(cacheable_memzero)
 	bdnz	4b
 3:	mtctr	r9
 	li	r7,4
-10:	dcbz	r7,r6
+10:
+BEGIN_MMU_FTR_SECTION
+	dcbz	r7,r6
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 	addi	r6,r6,CACHELINE_BYTES
 	bdnz	10b
 	clrlwi	r5,r8,32-LG_CACHELINE_BYTES
@@ -187,7 +191,9 @@ _GLOBAL(cacheable_memcpy)
 	mtctr	r0
 	beq	63f
 53:
+BEGIN_MMU_FTR_SECTION
 	dcbz	r11,r6
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 	COPY_16_BYTES
 #if L1_CACHE_BYTES >= 32
 	COPY_16_BYTES
@@ -368,7 +374,10 @@ _GLOBAL(__copy_tofrom_user)
 	mtctr	r8
 
 53:	dcbt	r3,r4
-54:	dcbz	r11,r6
+54:
+BEGIN_MMU_FTR_SECTION
+	dcbz	r11,r6
+END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
 	.section __ex_table,"a"
 	.align	2
 	.long	54b,105f
diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index 024acab..f5c60b3 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -80,9 +80,12 @@ static void __init ppc44x_pin_tlb(unsigned int virt, unsigned int phys)
 	:
 #ifdef CONFIG_PPC47x
 	: "r" (PPC47x_TLB2_S_RWX),
-#else
+#elseif CONFIG_BGP_L1_WRITETHROUGH
+	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_WL1 \
+		| PPC44x_TLB_U2 | PPC44x_TLB_M),
+#else /* neither CONFIG_PPC47x or CONFIG_BGP_L1_WRITETHROUGH */
 	: "r" (PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G),
-#endif
+#endif /* CONFIG_PPC47x */
 	  "r" (phys),
 	  "r" (virt | PPC44x_TLB_VALID | PPC44x_TLB_256M),
 	  "r" (entry),
-- 
1.7.4.1

