Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1BPAkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:40:14 -0500
Received: from kroah.org ([198.145.64.141]:49472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687Ab1BPAXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:40 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:44 2011
Message-Id: <20110216001444.832289749@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [197/272] ARM: smp_on_up: allow non-ARM SMP processors
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit e98ff0f55a0232b578c9aa7f1c245868277ac7bc upstream.

Allow non-ARM SMP processors to use the SMP_ON_UP feature.  CPUs
supporting SMP must have the new CPU ID format, so check for this first.
Then check for ARM11MPCore, which fails the MPIDR check.  Lastly check
the MPIDR reports multiprocessing extensions and that the CPU is part of
a multiprocessing system.

Reported-and-Tested-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/head.S |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -392,24 +392,22 @@ ENDPROC(__turn_mmu_on)
 
 #ifdef CONFIG_SMP_ON_UP
 __fixup_smp:
-	mov	r4, #0x00070000
-	orr	r3, r4, #0xff000000	@ mask 0xff070000
-	orr	r4, r4, #0x41000000	@ val 0x41070000
-	and	r0, r9, r3
-	teq	r0, r4			@ ARM CPU and ARMv6/v7?
+	and	r3, r9, #0x000f0000	@ architecture version
+	teq	r3, #0x000f0000		@ CPU ID supported?
 	bne	__fixup_smp_on_up	@ no, assume UP
 
-	orr	r3, r3, #0x0000ff00
-	orr	r3, r3, #0x000000f0	@ mask 0xff07fff0
+	bic	r3, r9, #0x00ff0000
+	bic	r3, r3, #0x0000000f	@ mask 0xff00fff0
+	mov	r4, #0x41000000
 	orr	r4, r4, #0x0000b000
-	orr	r4, r4, #0x00000020	@ val 0x4107b020
-	and	r0, r9, r3
-	teq	r0, r4			@ ARM 11MPCore?
+	orr	r4, r4, #0x00000020	@ val 0x4100b020
+	teq	r3, r4			@ ARM 11MPCore?
 	moveq	pc, lr			@ yes, assume SMP
 
 	mrc	p15, 0, r0, c0, c0, 5	@ read MPIDR
-	tst	r0, #1 << 31
-	movne	pc, lr			@ bit 31 => SMP
+	and	r0, r0, #0xc0000000	@ multiprocessing extensions and
+	teq	r0, #0x80000000		@ not part of a uniprocessor system?
+	moveq	pc, lr			@ yes, assume SMP
 
 __fixup_smp_on_up:
 	adr	r0, 1f


