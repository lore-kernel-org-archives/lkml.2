Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab1A3MU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:20:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab1A3MUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:20:55 -0500
Date: Sun, 30 Jan 2011 12:20:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>, Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix SMP_ON_UP for non ARM ltd. implementations
Message-ID: <20110130122027.GA22677@n2100.arm.linux.org.uk>
References: <1296083052-20034-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296083052-20034-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:04:12PM -0800, Stephen Boyd wrote:
> @@ -393,20 +393,25 @@ ENDPROC(__turn_mmu_on)
>  #ifdef CONFIG_SMP_ON_UP
>  __fixup_smp:
>  	mov	r4, #0x00070000
> -	orr	r3, r4, #0xff000000	@ mask 0xff070000
> -	orr	r4, r4, #0x41000000	@ val 0x41070000
> -	and	r0, r9, r3
> -	teq	r0, r4			@ ARM CPU and ARMv6/v7?
> +	and	r0, r9, r4
> +	teq	r0, r4			@ ARMv6/v7?
>  	bne	__fixup_smp_on_up	@ no, assume UP
>  
> +	orr	r3, r4, #0xff000000	@ mask 0xff070000
>  	orr	r3, r3, #0x0000ff00
>  	orr	r3, r3, #0x000000f0	@ mask 0xff07fff0
> +	orr	r4, r4, #0x41000000	@ val 0x41070000
>  	orr	r4, r4, #0x0000b000
>  	orr	r4, r4, #0x00000020	@ val 0x4107b020
>  	and	r0, r9, r3
>  	teq	r0, r4			@ ARM 11MPCore?
>  	moveq	pc, lr			@ yes, assume SMP
>  
> +	mov	r4, #0x00070000
> +	and	r0, r9, #0x000f0000
> +	teq	r0, r4			@ ARMv6?
> +	beq	__fixup_smp_on_up	@ yes, assume UP
> +

Wouldn't it be better to check for CPUID presence first, then ARM11MPcore,
and lastly preserve of MPIDR-flagged extensions?

Will - can you check whether the below is correct?

 arch/arm/kernel/head.S |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 17a97b5..f6b31c4 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -390,19 +390,16 @@ ENDPROC(__turn_mmu_on)
 
 #ifdef CONFIG_SMP_ON_UP
 __fixup_smp:
-	mov	r4, #0x00070000
-	orr	r3, r4, #0xff000000	@ mask 0xff070000
-	orr	r4, r4, #0x41000000	@ val 0x41070000
-	and	r0, r9, r3
-	teq	r0, r4			@ ARM CPU and ARMv6/v7?
+	and	r3, r9, #0x000f0000	@ architecture version
+	teq	r3, #0x000f00000	@ CPU ID supported?
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
