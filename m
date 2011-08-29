Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab1H2KZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 06:25:00 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:56650 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab1H2KYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 06:24:54 -0400
Message-ID: <4E5B677F.4030302@gentoo.org>
Date: Mon, 29 Aug 2011 13:18:39 +0300
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, stable@kernel.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386/bigsmp: eliminate false warnings regarding logical
 APIC ID mismatches
References: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
In-Reply-To: <4E4D27B40200007800051D40@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Mon, 29 Aug 2011 13:19:43 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 03:54 PM, Jan Beulich wrote:
> These warnings (generally one per CPU) are a result of initializing
> x86_cpu_to_logical_apicid while apic_default is still in use, but the
> check in setup_local_APIC() being done when apic_bigsmp was already
> used as an override in default_setup_apic_routing():
>
> Overriding APIC driver with bigsmp
> Enabling APIC mode:  Physflat.  Using 5 I/O APICs
> ------------[ cut here ]------------
> WARNING: at .../arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+0x137/0x46b()
> Hardware name: ...
> CPU0 logical APIC ID: 1 != 0
> Pid: 1, comm: swapper Not tainted 3.0.1-2011-08-09-jb #2
> Call Trace:
>  [<c1005f91>] try_stack_unwind+0x1b1/0x1f0
>  [<c1004cc7>] dump_trace+0x47/0x110
>  [<c1005b0b>] show_trace_log_lvl+0x4b/0x60
>  [<c1005b38>] show_trace+0x18/0x20
>  [<c1261435>] dump_stack+0x6d/0x72
>  [<c10355f7>] warn_slowpath_common+0x77/0xb0
>  [<c10356c3>] warn_slowpath_fmt+0x33/0x40
>  [<c13fda81>] setup_local_APIC+0x137/0x46b
>  [<c13d1733>] native_smp_prepare_cpus+0x108/0x1cd
>  [<c13c61ff>] kernel_init+0x37/0x12c
>  [<c1264826>] kernel_thread_helper+0x6/0xd
> ---[ end trace 4eaa2a86a8e2da22 ]---
> ...
> CPU 1 irqstacks, hard=f1c9a000 soft=f1c9c000
> Booting Node   0, Processors  #1
> smpboot cpu 1: start_ip = 9e000
> Initializing CPU#1
> ------------[ cut here ]------------
> WARNING: at .../arch/x86/kernel/apic/apic.c:1239 setup_local_APIC+0x137/0x46b()
> Hardware name: ...
> CPU1 logical APIC ID: 2 != 8
> ...
>
> Fix this (for the time being, i.e. until x86_32_early_logical_apicid()
> will get removed again, as Tehun says ought to be possible) by
> overriding the previously stored values at the point where the APIC
> driver gets overridden.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: stable@kernel.org (2.6.39 and onwards)
>
> ---
>  arch/x86/kernel/apic/probe_32.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> --- 3.1-rc2/arch/x86/kernel/apic/probe_32.c
> +++ 3.1-rc2-i386-bigsmp-early-lapicid-override/arch/x86/kernel/apic/probe_32.c
> @@ -203,7 +203,18 @@ void __init default_setup_apic_routing(v
>  	if (!cmdline_apic && apic == &apic_default) {
>  		struct apic *bigsmp = generic_bigsmp_probe();
>  		if (bigsmp) {
> +			unsigned int cpu;
> +
>  			apic = bigsmp;
> +			for_each_possible_cpu(cpu) {
> +				if (early_per_cpu(x86_cpu_to_logical_apicid,
> +						  cpu) == BAD_APICID)
> +					continue;
> +				early_per_cpu(x86_cpu_to_logical_apicid,
> +					      cpu) =
> +					bigsmp->x86_32_early_logical_apicid
> +						(cpu);
> +			}
>  			printk(KERN_INFO "Overriding APIC driver with %s\n",
>  			       apic->name);
>  		}
Will this patch be included in 3.1 (so that it gets merged in 3.0-stable
kernels sooner too) or will it go for 3.2?

Thanks.

-- 
Stratos Psomadakis
<psomas@gentoo.org>

