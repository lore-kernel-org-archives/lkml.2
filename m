Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab0LHNia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:38:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0LHNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E8xl/FVVBQypB3HzD/iwN16LH1ojIMkB9t6GfLESHpSz6Re0hUadW34sYAboijulnj
         Vl1ga3o1XxNMxhZ+SvaCRkCzpnl/47jOfCvo2aTYU/WS4XvALiSSCNnGqZhxowQl6O4k
         W8abHkcQvoOOI2VsPmbzbhNitbG56Q7cbPSkU=
Subject: Re: [PATCH] x86: Replace uses of current_cpu_data with this_cpu ops
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4CFF8520.4020704@kernel.org>
References: <20101206171618.302060721@linux.com>
	 <20101206171638.595205962@linux.com> <4CFE41F8.7040400@kernel.org>
	 <4CFE4294.30001@kernel.org>
	 <alpine.DEB.2.00.1012070846050.25976@router.home>
	 <4CFE4BE0.9040203@kernel.org>
	 <alpine.DEB.2.00.1012070906290.26552@router.home>
	 <4CFE4E05.7070902@kernel.org>
	 <alpine.DEB.2.00.1012071020040.26552@router.home>
	 <4CFF8520.4020704@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 14:38:21 +0100
Message-ID: <1291815501.2883.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 08 décembre 2010 à 14:16 +0100, Tejun Heo a écrit :
> From 9e9b27bff0e2441512ec27d3a90b252ecdc6ec3e Mon Sep 17 00:00:00 2001
> From: Christoph Lameter <cl@linux.com>
> Date: Wed, 8 Dec 2010 14:11:07 +0100
> 
> Replace all uses of current_cpu_data with this_cpu operations on the
> per cpu structure cpu_info.  The scala accesses are replaced with the
> matching this_cpu ops which results in smaller and more efficient
> code.
> 
> In the long run, it might be a good idea to remove cpu_data() macro
> too and use per_cpu macro directly.
> 

or introduce this_cpu_has() to remove the adress computation

-	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {

+	if (this_cpu_has(X86_FEATURE_ARAT)) {

> tj: updated description
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Comitted with updated description.  Thanks.
> 
>  arch/x86/include/asm/processor.h          |    3 +--
>  arch/x86/kernel/apic/apic.c               |    2 +-
>  arch/x86/kernel/cpu/amd.c                 |    2 +-
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
>  arch/x86/kernel/cpu/intel_cacheinfo.c     |    4 ++--
>  arch/x86/kernel/cpu/mcheck/mce.c          |   14 +++++++-------
>  arch/x86/kernel/cpu/mcheck/mce_intel.c    |    2 +-
>  arch/x86/kernel/process.c                 |    4 ++--
>  arch/x86/kernel/smpboot.c                 |   12 ++++++------
>  arch/x86/oprofile/op_model_ppro.c         |    8 ++++----
>  drivers/staging/lirc/lirc_serial.c        |    4 ++--
>  11 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index cae9c3c..c6efecf 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -141,10 +141,9 @@ extern __u32			cpu_caps_set[NCAPINTS];
>  #ifdef CONFIG_SMP
>  DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
>  #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
> -#define current_cpu_data	__get_cpu_var(cpu_info)
>  #else
> +#define cpu_info		boot_cpu_data
>  #define cpu_data(cpu)		boot_cpu_data
> -#define current_cpu_data	boot_cpu_data
>  #endif
> 
>  extern const struct seq_operations cpuinfo_op;
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 3f838d5..8accfe3 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -516,7 +516,7 @@ static void __cpuinit setup_APIC_timer(void)
>  {
>  	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
> 
> -	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)) {
> +	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
>  		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
>  		/* Make LAPIC timer preferrable over percpu HPET */
>  		lapic_clockevent.rating = 150;

...


