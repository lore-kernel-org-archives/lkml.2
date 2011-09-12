Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab1ILBPk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 21:15:40 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52540 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1ILBPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 21:15:38 -0400
Date: Mon, 12 Sep 2011 11:15:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-Id: <20110912111533.c263b24de84a824a813c8056@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Today's linux-next merge of the arm-lpae tree got a conflict in
arch/arm/kernel/sleep.S between commit 805f72ef00a4 ("ARM: pm:
preallocate a page table for suspend/resume") (and later ones) from the
arm tree and commit 787dad4a57fb ("ARM: LPAE: add ISBs around MMU
enabling code") from the arm-lpae tree.

I attempted to fix it up (see below) and can carry the fix as necessary.

There are also other conflicts due to the same changes existaing in each
of these trees as different commits.  Maybe some rebase or cleanup of the
arm-lpae tree is required.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/sleep.S
index 020e99c,ecece65..0000000
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@@ -52,17 -67,35 +52,19 @@@ ENDPROC(cpu_suspend_abort
  
  /*
   * r0 = control register value
 - * r1 = v:p offset (preserved by cpu_do_resume)
 - * r2 = phys page table base
 - * r3 = L1 section flags
   */
 +	.align	5
  ENTRY(cpu_resume_mmu)
 -	adr	r4, cpu_resume_turn_mmu_on
 -	mov	r4, r4, lsr #20
 -	orr	r3, r3, r4, lsl #20
 -	ldr	r5, [r2, r4, lsl #2]	@ save old mapping
 -	str	r3, [r2, r4, lsl #2]	@ setup 1:1 mapping for mmu code
 -	sub	r2, r2, r1
  	ldr	r3, =cpu_resume_after_mmu
 -	bic	r1, r0, #CR_C		@ ensure D-cache is disabled
 -	b	cpu_resume_turn_mmu_on
 -ENDPROC(cpu_resume_mmu)
 -	.ltorg
 -	.align	5
 -cpu_resume_turn_mmu_on:
+ 	instr_sync
 -	mcr	p15, 0, r1, c1, c0, 0	@ turn on MMU, I-cache, etc
 -	mrc	p15, 0, r1, c0, c0, 0	@ read id reg
 +	mcr	p15, 0, r0, c1, c0, 0	@ turn on MMU, I-cache, etc
 +	mrc	p15, 0, r0, c0, c0, 0	@ read id reg
+ 	instr_sync
 -	mov	r1, r1
 -	mov	r1, r1
 +	mov	r0, r0
 +	mov	r0, r0
  	mov	pc, r3			@ jump to virtual address
 -ENDPROC(cpu_resume_turn_mmu_on)
 +ENDPROC(cpu_resume_mmu)
  cpu_resume_after_mmu:
 -	str	r5, [r2, r4, lsl #2]	@ restore old mapping
 -	mcr	p15, 0, r0, c1, c0, 0	@ turn on D-cache
  	bl	cpu_init		@ restore the und/abt/irq banked regs
  	mov	r0, #0			@ return zero on success
  	ldmfd	sp!, {r4 - r11, pc}
