Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1CLS6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 13:58:34 -0500
Received: from www.tglx.de ([62.245.132.106]:53368 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab1CLS6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 13:58:32 -0500
Date: Sat, 12 Mar 2011 19:58:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Bogus setting of CONSTANT TSC ?
In-Reply-To: <20110311212418.GA14784@redhat.com>
Message-ID: <alpine.LFD.2.00.1103121851390.2787@localhost6.localdomain6>
References: <20110311212418.GA14784@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Dave Jones wrote:

> [RFC because I'm not sure about this. Can any of the Intel people
> confirm/deny that there are recent CPUs without constant TSC ?
> I was under the belief that all current ones had this, but either
> this isn't the case, or cpuid is lying to me.
> 
> also: That hardcoded model check looks suspect to me. Shouldn't
> that be checking for extended models ? ]
> 
> 
> 
> I've got a core2 laptop that I noticed reports all zeros as a result of
> cpuid(0x80000007), indicating no constant TSC.  The flags field
> of /proc/cpuinfo seems to think otherwise however.  This looks to
> be because of this code in early_init_intel()
> 
>           if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
>                   (c->x86 == 0x6 && c->x86_model >= 0x0e))
>                   set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);

This was initially introduced with commit 39b3a7 ([PATCH] i386/x86-64:
Generalize X86_FEATURE_CONSTANT_TSC flag), though the changelog is
utterly useless. Andi ??

> We explicitly set X86_FEATURE_CONSTANT_TSC on certain steppings
> when we enter early_init_intel, and then later we check if cpuid
> reports this feature, and set it on any other CPUs that were missed.
> 
> I think there are two problems here:
> 1. The code doesn't validate that x86_power was set to something sane before
>    we trust it (it's only valid if cpuid_level is >= 0x80000007)
>    On cpu's that don't support this level, it /should/ return zeros, but
>    I'm not sure that's defined behaviour.
> 2. If x86_power was valid, but the CONSTANT_TSC bit was 0, we don't clear it
>    if it was mistakenly set by the hard-coded stepping check.
> 
> We need to add the first check, otherwise the fix for the second part would
> always clear it on the CPUs that were hardcoded that don't support cpuid 0x80000007
> 
> As a follow-up, perhaps we should move the hardcoding code to an } else arm here
> where we don't support that cpuid feature to keep all the relevant code that frobs
> this stuff in one place.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index d16c2c5..02c5357 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -88,11 +88,15 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>  	 * It is also reliable across cores and sockets. (but not across
>  	 * cabinets - we turn it off in that case explicitly.)
>  	 */
> -	if (c->x86_power & (1 << 8)) {
> -		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> -		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> -		if (!check_tsc_unstable())
> -			sched_clock_stable = 1;
> +	if (c->extended_cpuid_level >= 0x80000007) {
> +		if (c->x86_power & (1 << 8)) {
> +			set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> +			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
> +			if (!check_tsc_unstable())
> +				sched_clock_stable = 1;
> +		} else {
> +			clear_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
> +		}
>  	}
>  
>  	/*
> 
