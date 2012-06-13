Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2FMNup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:50:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37873 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2FMNuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <1339594110.8980.38.camel@twins>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	<1339502524-10265-5-git-send-email-vincent.guittot@linaro.org>
	<1339591819.8980.28.camel@twins>
	<CAKfTPtCERCDdCSLyPAYAhxAB4wkDMVfMbfecv+vOMbgUXvYwYg@mail.gmail.com>
	<1339594110.8980.38.camel@twins>
Date: Wed, 13 Jun 2012 15:50:43 +0200
Message-ID: <CAKfTPtAbmLy5hR-W7RMQpn1cf1jkirv0oNtS_h4dmPYx5gTm1w@mail.gmail.com>
Subject: Re: [RFC 4/4] sched: cpu_power: enable ARCH_POWER
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2012 15:28, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-06-13 at 15:20 +0200, Vincent Guittot wrote:
>>
>> In v3.4, x86 hasn't got any specific declaration for
>> arch_scale_freq_power so it would now use the weak
>> arch_scale_freq_power which calls default_scale_freq_power. Isn't it
>> enough ?
>
> ---
> Subject: sched, x86: Remove broken power estimation
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jun 13 15:24:45 CEST 2012
>
> The x86 sched power implementation has been broken forever and gets in
> the way of other stuff, remove it.
>
> For archaeological interest, fixing this code would require dealing with
> the cross-cpu calling of these functions and more importantly, we need
> to filter idle time out of the a/m-perf stuff because the ratio will go
> down to 0 when idle, giving a 0 capacity which is not what we'd want.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-wjjwelpti8f8k7i1pdnzmdr8@git.kernel.org
> ---
>  arch/x86/kernel/cpu/Makefile |    2 -
>  arch/x86/kernel/cpu/sched.c  |   55 -------------------------------------------
>  2 files changed, 1 insertion(+), 56 deletions(-)
>
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -14,7 +14,7 @@ CFLAGS_common.o               := $(nostackp)
>
>  obj-y                  := intel_cacheinfo.o scattered.o topology.o
>  obj-y                  += proc.o capflags.o powerflags.o common.o
> -obj-y                  += vmware.o hypervisor.o sched.o mshyperv.o
> +obj-y                  += vmware.o hypervisor.o mshyperv.o
>  obj-y                  += rdrand.o
>  obj-y                  += match.o
>
> --- a/arch/x86/kernel/cpu/sched.c
> +++ /dev/null
> @@ -1,55 +0,0 @@
> -#include <linux/sched.h>
> -#include <linux/math64.h>
> -#include <linux/percpu.h>
> -#include <linux/irqflags.h>
> -
> -#include <asm/cpufeature.h>
> -#include <asm/processor.h>
> -
> -#ifdef CONFIG_SMP
> -
> -static DEFINE_PER_CPU(struct aperfmperf, old_perf_sched);
> -
> -static unsigned long scale_aperfmperf(void)
> -{
> -       struct aperfmperf val, *old = &__get_cpu_var(old_perf_sched);
> -       unsigned long ratio, flags;
> -
> -       local_irq_save(flags);
> -       get_aperfmperf(&val);
> -       local_irq_restore(flags);
> -
> -       ratio = calc_aperfmperf_ratio(old, &val);
> -       *old = val;
> -
> -       return ratio;
> -}
> -
> -unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
> -{
> -       /*
> -        * do aperf/mperf on the cpu level because it includes things
> -        * like turbo mode, which are relevant to full cores.
> -        */
> -       if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> -               return scale_aperfmperf();
> -
> -       /*
> -        * maybe have something cpufreq here
> -        */
> -
> -       return default_scale_freq_power(sd, cpu);
> -}
> -
> -unsigned long arch_scale_smt_power(struct sched_domain *sd, int cpu)
> -{
> -       /*
> -        * aperf/mperf already includes the smt gain
> -        */
> -       if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> -               return SCHED_LOAD_SCALE;
> -
> -       return default_scale_smt_power(sd, cpu);
> -}
> -
> -#endif
>

Sorry for the misses, I need to update my tags because this has been filtered.
