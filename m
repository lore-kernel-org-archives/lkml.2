Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab1BPAku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:40:50 -0500
Received: from kroah.org ([198.145.64.141]:49465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab1BPAXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:38 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:44 2011
Message-Id: <20110216001444.725158662@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [196/272] ARM: SMP: use more sane register allocation for __fixup_smp_on_up
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 0eb0511d176534674600a1986c3c766756288908 upstream.

Use r0,r3-r6 rather than r0,r3,r4,r6,r7, which makes it easier to
understand which registers can be modified.  Also document which
registers hold values which must be preserved.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/head.S |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -91,6 +91,11 @@ ENTRY(stext)
 	movs	r8, r5				@ invalid machine (r5=0)?
  THUMB( it	eq )		@ force fixup-able long branch encoding
 	beq	__error_a			@ yes, error 'a'
+
+	/*
+	 * r1 = machine no, r2 = atags,
+	 * r8 = machinfo, r9 = cpuid, r10 = procinfo
+	 */
 	bl	__vet_atags
 #ifdef CONFIG_SMP_ON_UP
 	bl	__fixup_smp
@@ -387,19 +392,19 @@ ENDPROC(__turn_mmu_on)
 
 #ifdef CONFIG_SMP_ON_UP
 __fixup_smp:
-	mov	r7, #0x00070000
-	orr	r6, r7, #0xff000000	@ mask 0xff070000
-	orr	r7, r7, #0x41000000	@ val 0x41070000
-	and	r0, r9, r6
-	teq	r0, r7			@ ARM CPU and ARMv6/v7?
+	mov	r4, #0x00070000
+	orr	r3, r4, #0xff000000	@ mask 0xff070000
+	orr	r4, r4, #0x41000000	@ val 0x41070000
+	and	r0, r9, r3
+	teq	r0, r4			@ ARM CPU and ARMv6/v7?
 	bne	__fixup_smp_on_up	@ no, assume UP
 
-	orr	r6, r6, #0x0000ff00
-	orr	r6, r6, #0x000000f0	@ mask 0xff07fff0
-	orr	r7, r7, #0x0000b000
-	orr	r7, r7, #0x00000020	@ val 0x4107b020
-	and	r0, r9, r6
-	teq	r0, r7			@ ARM 11MPCore?
+	orr	r3, r3, #0x0000ff00
+	orr	r3, r3, #0x000000f0	@ mask 0xff07fff0
+	orr	r4, r4, #0x0000b000
+	orr	r4, r4, #0x00000020	@ val 0x4107b020
+	and	r0, r9, r3
+	teq	r0, r4			@ ARM 11MPCore?
 	moveq	pc, lr			@ yes, assume SMP
 
 	mrc	p15, 0, r0, c0, c0, 5	@ read MPIDR
@@ -408,13 +413,13 @@ __fixup_smp:
 
 __fixup_smp_on_up:
 	adr	r0, 1f
-	ldmia	r0, {r3, r6, r7}
+	ldmia	r0, {r3 - r5}
 	sub	r3, r0, r3
-	add	r6, r6, r3
-	add	r7, r7, r3
-2:	cmp	r6, r7
-	ldmia	r6!, {r0, r4}
-	strlo	r4, [r0, r3]
+	add	r4, r4, r3
+	add	r5, r5, r3
+2:	cmp	r4, r5
+	ldmia	r4!, {r0, r6}
+	strlo	r6, [r0, r3]
 	blo	2b
 	mov	pc, lr
 ENDPROC(__fixup_smp)


