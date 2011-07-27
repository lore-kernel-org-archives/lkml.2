Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab1G0CVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 22:21:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8694 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1G0CU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 22:20:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6419"; a="106131149"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv3 2/2] ARM: P2V: Remove ARM_PATCH_PHYS_VIRT_16BIT
Date: Tue, 26 Jul 2011 19:20:55 -0700
Message-Id: <1311733255-25207-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.233.gd79bc
In-Reply-To: <1311733255-25207-1-git-send-email-sboyd@codeaurora.org>
References: <1311733255-25207-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

Now that MSM targets no longer need the 16-bit offsets for P2V, this
code can be removed.

Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Changes since v2:

 - Remove the 16bit p2v code

 arch/arm/Kconfig              |   11 +-------
 arch/arm/include/asm/memory.h |    7 -----
 arch/arm/kernel/head.S        |   61 +++++++++--------------------------------
 3 files changed, 14 insertions(+), 65 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 8944874..c856684 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -205,16 +205,7 @@ config ARM_PATCH_PHYS_VIRT
 	  kernel in system memory.
 
 	  This can only be used with non-XIP MMU kernels where the base
-	  of physical memory is at a 16MB boundary, or theoretically 64K
-	  for the MSM machine class.
-
-config ARM_PATCH_PHYS_VIRT_16BIT
-	def_bool y
-	depends on ARM_PATCH_PHYS_VIRT && ARCH_MSM
-	help
-	  This option extends the physical to virtual translation patching
-	  to allow physical memory down to a theoretical minimum of 64K
-	  boundaries.
+	  of physical memory is at a 16MB boundary.
 
 source "init/Kconfig"
 
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index b8de516..441fc4f 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -160,7 +160,6 @@
  * so that all we need to do is modify the 8-bit constant field.
  */
 #define __PV_BITS_31_24	0x81000000
-#define __PV_BITS_23_16	0x00810000
 
 extern unsigned long __pv_phys_offset;
 #define PHYS_OFFSET __pv_phys_offset
@@ -178,9 +177,6 @@ static inline unsigned long __virt_to_phys(unsigned long x)
 {
 	unsigned long t;
 	__pv_stub(x, t, "add", __PV_BITS_31_24);
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
-	__pv_stub(t, t, "add", __PV_BITS_23_16);
-#endif
 	return t;
 }
 
@@ -188,9 +184,6 @@ static inline unsigned long __phys_to_virt(unsigned long x)
 {
 	unsigned long t;
 	__pv_stub(x, t, "sub", __PV_BITS_31_24);
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
-	__pv_stub(t, t, "sub", __PV_BITS_23_16);
-#endif
 	return t;
 }
 #else
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 742b610..136abb6 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -488,13 +488,8 @@ __fixup_pv_table:
 	add	r5, r5, r3	@ adjust table end address
 	add	r7, r7, r3	@ adjust __pv_phys_offset address
 	str	r8, [r7]	@ save computed PHYS_OFFSET to __pv_phys_offset
-#ifndef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
 	mov	r6, r3, lsr #24	@ constant for add/sub instructions
 	teq	r3, r6, lsl #24 @ must be 16MiB aligned
-#else
-	mov	r6, r3, lsr #16	@ constant for add/sub instructions
-	teq	r3, r6, lsl #16	@ must be 64kiB aligned
-#endif
 THUMB(	it	ne		@ cross section branch )
 	bne	__error
 	str	r6, [r7, #4]	@ save to __pv_offset
@@ -510,20 +505,8 @@ ENDPROC(__fixup_pv_table)
 	.text
 __fixup_a_pv_table:
 #ifdef CONFIG_THUMB2_KERNEL
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
-	lsls	r0, r6, #24
-	lsr	r6, #8
-	beq	1f
-	clz	r7, r0
-	lsr	r0, #24
-	lsl	r0, r7
-	bic	r0, 0x0080
-	lsrs	r7, #1
-	orrcs   r0, #0x0080
-	orr	r0, r0, r7, lsl #12
-#endif
-1:	lsls	r6, #24
-	beq	4f
+	lsls	r6, #24
+	beq	2f
 	clz	r7, r6
 	lsr	r6, #24
 	lsl	r6, r7
@@ -532,43 +515,25 @@ __fixup_a_pv_table:
 	orrcs	r6, #0x0080
 	orr	r6, r6, r7, lsl #12
 	orr	r6, #0x4000
-	b	4f
-2:	@ at this point the C flag is always clear
-	add     r7, r3
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
-	ldrh	ip, [r7]
-	tst	ip, 0x0400	@ the i bit tells us LS or MS byte
-	beq	3f
-	cmp	r0, #0		@ set C flag, and ...
-	biceq	ip, 0x0400	@ immediate zero value has a special encoding
-	streqh	ip, [r7]	@ that requires the i bit cleared
-#endif
-3:	ldrh	ip, [r7, #2]
+	b	2f
+1:	add     r7, r3
+	ldrh	ip, [r7, #2]
 	and	ip, 0x8f00
-	orrcc	ip, r6	@ mask in offset bits 31-24
-	orrcs	ip, r0	@ mask in offset bits 23-16
+	orr	ip, r6	@ mask in offset bits 31-24
 	strh	ip, [r7, #2]
-4:	cmp	r4, r5
+2:	cmp	r4, r5
 	ldrcc	r7, [r4], #4	@ use branch for delay slot
-	bcc	2b
+	bcc	1b
 	bx	lr
 #else
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
-	and	r0, r6, #255	@ offset bits 23-16
-	mov	r6, r6, lsr #8	@ offset bits 31-24
-#else
-	mov	r0, #0		@ just in case...
-#endif
-	b	3f
-2:	ldr	ip, [r7, r3]
+	b	2f
+1:	ldr	ip, [r7, r3]
 	bic	ip, ip, #0x000000ff
-	tst	ip, #0x400	@ rotate shift tells us LS or MS byte
-	orrne	ip, ip, r6	@ mask in offset bits 31-24
-	orreq	ip, ip, r0	@ mask in offset bits 23-16
+	orr	ip, ip, r6	@ mask in offset bits 31-24
 	str	ip, [r7, r3]
-3:	cmp	r4, r5
+2:	cmp	r4, r5
 	ldrcc	r7, [r4], #4	@ use branch for delay slot
-	bcc	2b
+	bcc	1b
 	mov	pc, lr
 #endif
 ENDPROC(__fixup_a_pv_table)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

