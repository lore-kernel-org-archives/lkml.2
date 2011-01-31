Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1AaVdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:33:33 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63602 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab1AaVdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:33:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6243"; a="72480750"
Message-ID: <4D472AAA.501@codeaurora.org>
Date: Mon, 31 Jan 2011 13:33:30 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Fix SMP_ON_UP for non ARM ltd. implementations
References: <1296083052-20034-1-git-send-email-sboyd@codeaurora.org> <20110130122027.GA22677@n2100.arm.linux.org.uk> <1296404875.6192.10.camel@jazzbox> <20110130164007.GA27436@n2100.arm.linux.org.uk>
In-Reply-To: <20110130164007.GA27436@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 08:40 AM, Russell King - ARM Linux wrote:
> Ok, so with that added, it becomes:
>
>  arch/arm/kernel/head.S |   22 ++++++++++------------
>  1 files changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
> index f17d9a0..c0225da 100644
> --- a/arch/arm/kernel/head.S
> +++ b/arch/arm/kernel/head.S
> @@ -392,24 +392,22 @@ ENDPROC(__turn_mmu_on)
>  
>  #ifdef CONFIG_SMP_ON_UP
>  __fixup_smp:
> -	mov	r4, #0x00070000
> -	orr	r3, r4, #0xff000000	@ mask 0xff070000
> -	orr	r4, r4, #0x41000000	@ val 0x41070000
> -	and	r0, r9, r3
> -	teq	r0, r4			@ ARM CPU and ARMv6/v7?
> +	and	r3, r9, #0x000f0000	@ architecture version
> +	teq	r3, #0x000f0000		@ CPU ID supported?
>  	bne	__fixup_smp_on_up	@ no, assume UP
>  
> -	orr	r3, r3, #0x0000ff00
> -	orr	r3, r3, #0x000000f0	@ mask 0xff07fff0
> +	bic	r3, r9, #0x00ff0000
> +	bic	r3, r3, #0x0000000f	@ mask 0xff00fff0
> +	mov	r4, #0x41000000
>  	orr	r4, r4, #0x0000b000
> -	orr	r4, r4, #0x00000020	@ val 0x4107b020
> -	and	r0, r9, r3
> -	teq	r0, r4			@ ARM 11MPCore?
> +	orr	r4, r4, #0x00000020	@ val 0x4100b020
> +	teq	r3, r4			@ ARM 11MPCore?
>  	moveq	pc, lr			@ yes, assume SMP
>  
>  	mrc	p15, 0, r0, c0, c0, 5	@ read MPIDR
> -	tst	r0, #1 << 31
> -	movne	pc, lr			@ bit 31 => SMP
> +	and	r0, r0, #0xc0000000	@ multiprocessing extensions and
> +	teq	r0, #0x80000000		@ not part of a uniprocessor system?
> +	moveq	pc, lr			@ yes, assume SMP
>  
>  __fixup_smp_on_up:
>  	adr	r0, 1f

Great. Looks good to me too. If I had know that ARM 11MPCore had an 0xf
in the architecture bits I would have suggested this fix instead.

Also, I wasn't sure if we should send fixes for EXPERIMENTAL features to
the stable tree. If its appropriate, please Cc stable when the patch
goes in.

Reported-and-Tested-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

