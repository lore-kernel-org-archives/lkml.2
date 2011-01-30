Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1A3QkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 11:40:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58969 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab1A3QkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 11:40:22 -0500
Date: Sun, 30 Jan 2011 16:40:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix SMP_ON_UP for non ARM ltd. implementations
Message-ID: <20110130164007.GA27436@n2100.arm.linux.org.uk>
References: <1296083052-20034-1-git-send-email-sboyd@codeaurora.org> <20110130122027.GA22677@n2100.arm.linux.org.uk> <1296404875.6192.10.camel@jazzbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296404875.6192.10.camel@jazzbox>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 04:27:55PM +0000, Will Deacon wrote:
> >         mrc     p15, 0, r0, c0, c0, 5   @ read MPIDR
> 
> 
> The code following this does:
> 
> tst     r0, #1 << 31
> movne   pc, lr                  @ bit 31 => SMP
> 
> As an optimisation, we could also check that bit 30 is zero so that
> we patch out the SMP stuff for single-core A5/A9/A15. Up to you.

Ok, so with that added, it becomes:

 arch/arm/kernel/head.S |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index f17d9a0..c0225da 100644
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
