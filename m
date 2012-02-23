Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2BWKXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:23:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60922 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2BWKXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:23:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel@numascale-asia.com designates 10.205.127.81 as permitted sender) smtp.mail=daniel@numascale-asia.com
Message-ID: <4F46138A.3030901@numascale-asia.com>
Date: Thu, 23 Feb 2012 10:23:06 +0000
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH] x86: Remove wrong error message in x86_default_fixup_cpu_id
References: <20120220171705.GA17069@alberich.amd.com> <20120221102725.GC14274@aftab> <4F437A71.6000402@numascale-asia.com> <20120222134707.GA9769@alberich.amd.com>
In-Reply-To: <20120222134707.GA9769@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/2012 13:47, Andreas Herrmann wrote:
> On Tue, Feb 21, 2012 at 11:05:21AM +0000, Daniel J Blueman wrote:
>> On 21/02/2012 10:27, Borislav Petkov wrote:
>>> On Mon, Feb 20, 2012 at 06:17:05PM +0100, Andreas Herrmann wrote:
> [snip]
>
>>> BTW, I wonder why the fixup code isn't called from the Intel path.  At
>>> least the mentioned patch suggests that something more generic was
>>> introduced here.
>>> Right, and I would remove the check in amd.c:srat_detect_node() instead
>>> of removing the printk statement in the default implementation.
>>>
>>> IOW, we need more info on why the check was added only to the AMD path?
>>> Daniel?
>> The check and fixup wasn't needed in the Intel path thus far, so wasn't
>> added.
>>
>> We could specialise the 'if (c->phys_proc_id != node)' test to check for
>> x86_cpuinit.fixup_cpu_id being NULL and drop the default override, if
>> that is preferred?
> It seems that all the stuff in x86_init.[ch] is using default/noop
> functions instead of NULL pointer checks. So we shouldn't deviate from
> this for x86_cpuinit.fixup_cpu_id.
>
> I think attached patch is more suitable to avoid the wrong warning
> message.
>
> Please review.

Yes, this looks reasonable and tests out successfully on systems with 
and without NumaConnect.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>

Thanks,
   Daniel

>
>
> Thanks,
>
> Andreas
>
> --
> x86: Remove wrong error message in x86_default_fixup_cpu_id
>
> It's only called from amd.c:srat_detect_node(). The introduced
> condition for calling the fixup code is true for all AMD multi-node
> processors, e.g. Magny-Cours and Interlagos. There we have 2 NUMA
> nodes on one socket. Thus there are cores having different
> numa-node-id but with equal phys_proc_id.
>
> There is no point to print error messages in such a situation.
>
> The confusing/misleading error message was introduced with commit
> 64be4c1c2428e148de6081af235e2418e6a66dda (x86: Add x86_init platform
> override to fix up NUMA core numbering).
>
> Change the default fixup function (remove the error message), move the
> Numascale-specific condition for calling the fixup into the
> fixup-function itself and slightly adapt the comment.
>
> Signed-off-by: Andreas Herrmann<andreas.herrmann3@amd.com>
> ---
>   arch/x86/include/asm/x86_init.h      |    2 +-
>   arch/x86/kernel/apic/apic_numachip.c |    7 +++++--
>   arch/x86/kernel/cpu/amd.c            |    8 ++++----
>   arch/x86/kernel/cpu/common.c         |    9 ---------
>   arch/x86/kernel/x86_init.c           |    1 +
>   5 files changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 517d476..1bcacef 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -189,6 +189,6 @@ extern struct x86_msi_ops x86_msi;
>
>   extern void x86_init_noop(void);
>   extern void x86_init_uint_noop(unsigned int unused);
> -extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
> +extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int n);
>
>   #endif
> diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
> index 09d3d8c..ade0182 100644
> --- a/arch/x86/kernel/apic/apic_numachip.c
> +++ b/arch/x86/kernel/apic/apic_numachip.c
> @@ -201,8 +201,11 @@ static void __init map_csrs(void)
>
>   static void fixup_cpu_id(struct cpuinfo_x86 *c, int node)
>   {
> -	c->phys_proc_id = node;
> -	per_cpu(cpu_llc_id, smp_processor_id()) = node;
> +
> +	if (c->phys_proc_id != node) {
> +		c->phys_proc_id = node;
> +		per_cpu(cpu_llc_id, smp_processor_id()) = node;
> +	}
>   }
>
>   static int __init numachip_system_init(void)
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index f4773f4..52b7287 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -352,11 +352,11 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
>   		node = per_cpu(cpu_llc_id, cpu);
>
>   	/*
> -	 * If core numbers are inconsistent, it's likely a multi-fabric platform,
> -	 * so invoke platform-specific handler
> +	 * On multi-fabric platform (e.g. Numascale NumaChip) a
> +	 * platform-specific handler needs to be called to fixup some
> +	 * IDs of the CPU.
>   	 */
> -	if (c->phys_proc_id != node)
> -		x86_cpuinit.fixup_cpu_id(c, node);
> +	x86_cpuinit.fixup_cpu_id(c, node);
>
>   	if (!node_online(node)) {
>   		/*
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index d43cad7..37da7a6 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1158,15 +1158,6 @@ static void dbg_restore_debug_regs(void)
>   #endif /* ! CONFIG_KGDB */
>
>   /*
> - * Prints an error where the NUMA and configured core-number mismatch and the
> - * platform didn't override this to fix it up
> - */
> -void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
> -{
> -	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
> -}
> -
> -/*
>    * cpu_init() initializes state that is per-CPU. Some data is already
>    * initialized (naturally) in the bootstrap process, such as the GDT
>    * and IDT. We reload them nevertheless, this function acts as a
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index 947a06c..67cf78a 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -90,6 +90,7 @@ struct x86_init_ops x86_init __initdata = {
>   	},
>   };
>
> +void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int n) { }
>   struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
>   	.setup_percpu_clockev		= setup_secondary_APIC_clock,
>   	.fixup_cpu_id			= x86_default_fixup_cpu_id,
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

