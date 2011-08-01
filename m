Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1HAVbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:31:53 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:18224
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752243Ab1HAVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:31:50 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432N98dK4015Lzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP9QGU-02-EXM-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 23:31:42 +0200
From: Robert Richter <robert.richter@amd.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3] oprofile, x86: Convert memory allocation to static
 array
Message-ID: <20110801213142.GE11795@erda.amd.com>
References: <4E35A14E.90702@gmail.com>
 <20110801070742.GA11795@erda.amd.com>
 <4E36C18B.7050502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E36C18B.7050502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.08.11 11:08:59, Maarten Lankhorst wrote:
> On -rt, allocators don't work from atomic context any more,
> and the maximum size of the array is known at compile time.
> 
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

Applied to oprofile/core. Thanks, Maarten.

Ingo, Peter,

do you want this for 3.1 (perf/urgent) or 3.2?

-Robert

> 
> ---
> 
> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 94b7450..608874b 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -28,7 +28,7 @@ static int counter_width = 32;
>  
>  #define MSR_PPRO_EVENTSEL_RESERVED	((0xFFFFFFFFULL<<32)|(1ULL<<21))
>  
> -static u64 *reset_value;
> +static u64 reset_value[OP_MAX_COUNTER];
>  
>  static void ppro_shutdown(struct op_msrs const * const msrs)
>  {
> @@ -40,10 +40,6 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
>  		release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
>  		release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
>  	}
> -	if (reset_value) {
> -		kfree(reset_value);
> -		reset_value = NULL;
> -	}
>  }
>  
>  static int ppro_fill_in_addresses(struct op_msrs * const msrs)
> @@ -79,13 +75,6 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
>  	u64 val;
>  	int i;
>  
> -	if (!reset_value) {
> -		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
> -					GFP_ATOMIC);
> -		if (!reset_value)
> -			return;
> -	}
> -
>  	if (cpu_has_arch_perfmon) {
>  		union cpuid10_eax eax;
>  		eax.full = cpuid_eax(0xa);
> @@ -141,13 +130,6 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
>  	u64 val;
>  	int i;
>  
> -	/*
> -	 * This can happen if perf counters are in use when
> -	 * we steal the die notifier NMI.
> -	 */
> -	if (unlikely(!reset_value))
> -		goto out;
> -
>  	for (i = 0; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> @@ -179,8 +161,6 @@ static void ppro_start(struct op_msrs const * const msrs)
>  	u64 val;
>  	int i;
>  
> -	if (!reset_value)
> -		return;
>  	for (i = 0; i < num_counters; ++i) {
>  		if (reset_value[i]) {
>  			rdmsrl(msrs->controls[i].addr, val);
> @@ -196,8 +176,6 @@ static void ppro_stop(struct op_msrs const * const msrs)
>  	u64 val;
>  	int i;
>  
> -	if (!reset_value)
> -		return;
>  	for (i = 0; i < num_counters; ++i) {
>  		if (!reset_value[i])
>  			continue;
> 
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

