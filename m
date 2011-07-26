Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab1GZSYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:24:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50149 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1GZSYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:24:30 -0400
Date: Tue, 26 Jul 2011 14:24:26 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: ARM_PATCH_PHYS_VIRT_16BIT no longer depends
 on MSM
In-Reply-To: <4E2EFC0E.8020805@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1107261418250.12766@xanadu.home>
References: <1311614362-9011-1-git-send-email-sboyd@codeaurora.org> <1311614362-9011-2-git-send-email-sboyd@codeaurora.org> <alpine.LFD.2.00.1107251624560.12766@xanadu.home> <20110725203114.GF14955@n2100.arm.linux.org.uk> <4E2EFC0E.8020805@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, Stephen Boyd wrote:

> On 07/25/2011 01:31 PM, Russell King - ARM Linux wrote:
> > On Mon, Jul 25, 2011 at 04:25:26PM -0400, Nicolas Pitre wrote:
> >> On Mon, 25 Jul 2011, Stephen Boyd wrote:
> >>
> >>> MSM no longer requires the 16bit version of dynamic P2V. Drop the
> >>> dependency.
> >>>
> >>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >>> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> >>> Cc: David Brown <davidb@codeaurora.org>
> >> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> > As it's now unused, we can kill the additional code which makes things
> > needlessly more complex...
> 
> Ok. I'll remove the extra code in v3.

Something like this (untested):

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ec1c799..e4c784c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -208,14 +208,5 @@ config ARM_PATCH_PHYS_VIRT
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
 
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 005f884..c626a04 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -159,7 +159,6 @@
  * so that all we need to do is modify the 8-bit constant field.
  */
 #define __PV_BITS_31_24	0x81000000
-#define __PV_BITS_23_16	0x00810000
 
 extern unsigned long __pv_phys_offset;
 #define PHYS_OFFSET __pv_phys_offset
@@ -177,9 +176,6 @@ static inline unsigned long __virt_to_phys(unsigned long x)
 {
 	unsigned long t;
 	__pv_stub(x, t, "add", __PV_BITS_31_24);
-#ifdef CONFIG_ARM_PATCH_PHYS_VIRT_16BIT
-	__pv_stub(t, t, "add", __PV_BITS_23_16);
-#endif
 	return t;
 }
 
@@ -187,9 +183,6 @@ static inline unsigned long __phys_to_virt(unsigned long x)
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
index 278c1b0..3320a2d 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -480,13 +480,8 @@ __fixup_pv_table:
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
@@ -502,20 +497,8 @@ ENDPROC(__fixup_pv_table)
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
@@ -524,43 +507,25 @@ __fixup_a_pv_table:
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




> 
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
