Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2BLCS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 21:18:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48598 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2BLCSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 21:18:55 -0500
MIME-Version: 1.0
In-Reply-To: <1329006252-1684-1-git-send-email-kjwinchester@gmail.com>
References: <20120211140737.GA26637@elte.hu>
	<1329006252-1684-1-git-send-email-kjwinchester@gmail.com>
Date: Sat, 11 Feb 2012 22:18:53 -0400
Message-ID: <CAELBVzD8eZuxO0KLvZp8VuucoPxBNVsojO1NhC-pvr78Mg1v+w@mail.gmail.com>
Subject: Re: [PATCH] x86: Move per cpu cpu_llc_shared_map to a field in struct cpuinfo_x86
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 February 2012 20:24, Kevin Winchester <kjwinchester@gmail.com> wrote:
> Commit 141168c36cde ("x86: Simplify code by removing a !SMP #ifdefs from
> 'struct cpuinfo_x86'") caused the compilation error:
>
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to 'cpu_llc_shared_map'
>
> by removing an #ifdef CONFIG_SMP around a block containing a reference
> to cpu_llc_shared_map.  Rather than replace the #ifdef, move
> cpu_llc_shared_map to be a new field llc_shared_map in struct
> cpuinfo_x86 and adjust all references to cpu_llc_shared_map.
>
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/include/asm/processor.h      |    1 +
>  arch/x86/include/asm/smp.h            |    6 ------
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
>  arch/x86/kernel/cpu/mcheck/mce_amd.c  |    7 ++++---
>  arch/x86/kernel/smpboot.c             |   15 ++++++---------
>  arch/x86/xen/smp.c                    |    1 -
>  6 files changed, 13 insertions(+), 21 deletions(-)
>
>
>  static void impress_friends(void)
> @@ -1053,7 +1051,6 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>        for_each_possible_cpu(i) {
>                zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
>                zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> -               zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
>        }
>        set_cpu_sibling_map(0);
>
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 041d4fe..a898ed5 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -225,7 +225,6 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
>        for_each_possible_cpu(i) {
>                zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
>                zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> -               zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
>        }
>        set_cpu_sibling_map(0);
>

I just realized that I took out a couple of allocations here for
cpu_llc_shared_map, without replacing them.  Am I leaving
cpuinfo_x86.llc_shared_map unallocated then, and just writing to
whatever address that field happened to get?
