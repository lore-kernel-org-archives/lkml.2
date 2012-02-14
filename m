Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2BNSHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:07:32 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2BNSH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:07:29 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6620"; a="160791427"
Message-ID: <4F3AA2E0.2040500@codeaurora.org>
Date: Tue, 14 Feb 2012 10:07:28 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home> <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com> <alpine.LFD.2.02.1202131307430.24536@xanadu.home> <4F3952C7.3040502@codeaurora.org> <20120213181501.GD25655@n2100.arm.linux.org.uk> <4F398D61.9080501@codeaurora.org> <20120213232901.GG25655@n2100.arm.linux.org.uk> <20120214141524.GB3310@debian>
In-Reply-To: <20120214141524.GB3310@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/12 06:15, Rabin Vincent wrote:
> On Mon, Feb 13, 2012 at 11:29:01PM +0000, Russell King - ARM Linux wrote:
>> On Mon, Feb 13, 2012 at 02:23:29PM -0800, Stephen Boyd wrote:
>>> On 02/13/12 10:15, Russell King - ARM Linux wrote:
>>>> On Mon, Feb 13, 2012 at 10:13:27AM -0800, Stephen Boyd wrote:
>>>>> Thanks. Russell has already merged the original patch to the fixes
>>>>> branch. Hopefully he can fold this one in.
>>>> Nope, I've asked Linus to pull it.
>>>>
>>>> So do we conclude that the original patch wasn't properly tested? :P
>>> Sigh. Lockdep strikes again! I promise I tested it with lockdep disabled.
>>>
>>> It looks like Linus' hasn't pulled yet but maybe he just hasn't
>>> published it.
>> It's not nice to change something after you've sent a pull request -
>> there's no way of knowing when Linus actually pulls it before he's
>> published it, and if he gets something different then it can raise
>> questions.
>>
>> So, it's gone in as-is, and, as I'm now intending asking for another
>> pull request soo soon after my previous one, this is something that
>> we will have to live with probably for the remainder of the week.
> OK, since it can't be folded in, here is a proper patch:
>
> 8<---------
> From 26f02624a20a61ed1997a4e8648e4c766a54d91d Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Tue, 14 Feb 2012 19:22:07 +0530
> Subject: [PATCH] ARM: fix v7 boot with lockdep enabled
>
> Bootup with lockdep enabled has been broken on v7 since b46c0f74657d
> ("ARM: 7321/1: cache-v7: Disable preemption when reading CCSIDR").
>
> This is because v7_setup (which is called very early during boot) calls
> v7_flush_dcache_all, and the save_and_disable_irqs added by that patch
> ends up attempting to call into lockdep C code (trace_hardirqs_off())
> when we are in no position to execute it (no stack, MMU off).
>
> Fix this by using a notrace variant of save_and_disable_irqs.  The code
> already uses the notrace variant of restore_irqs.
>
> Cc: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Nicolas Pitre <nico@linaro.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  arch/arm/include/asm/assembler.h |    5 +++++
>  arch/arm/mm/cache-v7.S           |    2 +-
>  2 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index 62f8095..23371b1 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -137,6 +137,11 @@
>  	disable_irq
>  	.endm
>  
> +	.macro	save_and_disable_irqs_notrace, oldcpsr
> +	mrs	\oldcpsr, cpsr
> +	disable_irq_notrace
> +	.endm
> +
>  /*
>   * Restore interrupt state previously stored in a register.  We don't
>   * guarantee that this will preserve the flags.
> diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
> index 7a24d396..a655d3d 100644
> --- a/arch/arm/mm/cache-v7.S
> +++ b/arch/arm/mm/cache-v7.S
> @@ -55,7 +55,7 @@ loop1:
>  	cmp	r1, #2				@ see what cache we have at this level
>  	blt	skip				@ skip if no cache, or just i-cache
>  #ifdef CONFIG_PREEMPT
> -	save_and_disable_irqs r9		@ make cssr&csidr read atomic
> +	save_and_disable_irqs_notrace r9	@ make cssr&csidr read atomic
>  #endif
>  	mcr	p15, 2, r10, c0, c0, 0		@ select current cache level in cssr
>  	isb					@ isb to sych the new cssr&csidr


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

