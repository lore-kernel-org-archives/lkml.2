Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2BHMWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:22:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42417 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2BHMWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:22:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120208101956.GA1772@x1.osrc.amd.com>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
	<20120202193702.GA9502@elliptictech.com>
	<20120202202427.GA2234@x1.osrc.amd.com>
	<20120203191801.GA2846@x1.osrc.amd.com>
	<20120207095746.GH15359@elte.hu>
	<20120208101956.GA1772@x1.osrc.amd.com>
Date: Wed, 8 Feb 2012 08:22:11 -0400
Message-ID: <CAELBVzADZwY61+RWBudFqO7Sb6cs+1GoWe6k+-Zw+wP_Di46og@mail.gmail.com>
Subject: Re: MCE, AMD: Hide smp-only code around CONFIG_SMP
From: Kevin Winchester <kjwinchester@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        Nick Bowler <nbowler@elliptictech.com>,
        Randy Dunlap <rdunlap@xenotime.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kevin Winchester <kjwinchester@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2012 06:19, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Feb 07, 2012 at 10:57:46AM +0100, Ingo Molnar wrote:
>> Could we please just define an obvious cpu_llc_shared_mask on UP
>> (one bit long and set to 1) and not reintroduce the ugly
>> #ifdef CONFIG_SMP?
>
> Ok, here's a tentative proposed solution where I was trying not to
> fatfinger the cpumask magic. Let me know if this is similar to what you
> had in mind. The call to cpu_llc_shared_mask(int cpu) on UP might cause
> a problem if the cpu arg is not 0 but it should not happen anyway and
> there should be other problems with the caller side anyway.
>
> Thanks.
>
> --
> From: Borislav Petkov <bp@alien8.de>
> Date: Tue, 7 Feb 2012 21:40:22 +0100
> Subject: [PATCH] MCE, AMD: Fix !CONFIG_SMP build
>
> 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") removed a bunch of CONFIG_SMP ifdefs around
> code touching struct cpuinfo_x86 members but also caused the
> following build error with Randy's randconfigs:
>
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
>
> Fix that by adding a UP version of the cpu_llc_shared_map, as Ingo
> suggested.
>
> Cc: Kevin Winchester <kjwinchester@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Link: http://lkml.kernel.org/r/4F298A6C.6010101@xenotime.net
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  arch/x86/include/asm/smp.h |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 0434c40..118754f 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -33,8 +33,15 @@ static inline bool cpu_has_ht_siblings(void)
>
>  DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
>  DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
> -/* cpus sharing the last level cache: */
> +
> +#ifdef CONFIG_SMP
> +/* CPUs sharing the last level cache: */
>  DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
> +#else
> +static DECLARE_BITMAP(cpu_llc_shared_bits, NR_CPUS) __read_mostly = { [0] = 1UL };
> +static struct cpumask *const cpu_llc_shared_map = to_cpumask(cpu_llc_shared_bits);
> +#endif
> +
>  DECLARE_PER_CPU(u16, cpu_llc_id);
>  DECLARE_PER_CPU(int, cpu_number);
>
> --
> 1.7.9
>

Does this work?  arch/x86/kernel/cpu/mcheck/mce_amd.c includes
<linux/smp.h> rather than <asm/smp.h> directly.  And <linux/smp.h>
only includes <asm/smp.h> for the CONFIG_SMP case.  Or perhaps one of
the other includes in mce_amd.c includes <asm/smp.h>?

-- 
Kevin Winchester
