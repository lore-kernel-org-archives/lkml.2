Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1EYGz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:55:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48727 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab1EYGzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:55:25 -0400
Date: Wed, 25 May 2011 08:54:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525065451.GC429@elte.hu>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> I got a request to make it easier to determine the microcode update level
> on Intel CPUs. This patch adds a new "cpu update" field to /proc/cpuinfo,
> which I added at the end to minimize impact on parsers.

Agreed, that is a good idea, adding this to cpuinfo makes sense.

Your patch is rather messy though:

> The update level is also outputed on fatal machine checks together
> with the other CPUID model information.
> 
> I removed the respective code from the microcode update driver, it
> just reads the field from cpu_data. Also when the microcode is updated
> it fills in the new values too.
> 
> I had to add a memory barrier to native_cpuid to prevent it being
> optimized away when the result is not used.
> 
> This turns out to clean up further code which already got this
> information manually. This is done in followon patches.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/include/asm/processor.h  |    5 ++++-
>  arch/x86/kernel/cpu/intel.c       |   10 ++++++++++
>  arch/x86/kernel/cpu/mcheck/mce.c  |    5 +++--
>  arch/x86/kernel/cpu/proc.c        |    6 +++++-
>  arch/x86/kernel/microcode_intel.c |    9 +++------
>  5 files changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index 4c25ab4..23b7e26 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -111,6 +111,8 @@ struct cpuinfo_x86 {
>  	/* Index into per_cpu list: */
>  	u16			cpu_index;
>  #endif
> +	/* CPU update signature */
> +	u32			x86_cpu_update;

This should be cpu_microcode_version instead. We already know its x86 so the 
x86_ prefix is superfluous. 'cpu_update' is also rather ambigious and does not 
describe much.

> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1edf5ba..150623a 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -364,6 +364,16 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  
>  	early_init_intel(c);
>  
> +	/* Determine CPU update level */
> +	if (c->x86 >= 6 && !(cpu_has(c, X86_FEATURE_IA64))) {	
> +		unsigned lo;
> +
> +		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> +		/* The CPUID 1 fills in the MSR */
> +		cpuid_eax(1);
> +		rdmsr(MSR_IA32_UCODE_REV, lo, c->x86_cpu_update);
> +	}


So, during the course of developing this, did it occur to you that other x86 
CPUs should fill in this information as well?

If yes, did it occur to you to do the obvious git log 
arch/x86/kernel/microcode*.c command to figure out who else might be interested 
in this, and add them to the Cc: instead of forcing the maintainer to do that?

Also, and this is a repeat pattern from you Andi, you've silently made code worse
while moving it. You've changed this:

> -	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> -	/* see notes above for revision 1.07.  Apparent chip bug */
> -	sync_core();
> -	/* get the current revision from MSR 0x8B */
> -	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
> -

To:

> +		unsigned lo;
> +
> +		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> +		/* The CPUID 1 fills in the MSR */
> +		cpuid_eax(1);
> +		rdmsr(MSR_IA32_UCODE_REV, lo, c->x86_cpu_update);

Firstly, name 'lo' appropriately - 'lo' in itself says nothing and keeps the 
reader wondering about what recreational drugs the writer of this code was on.

Obviously Secondly you've removed the reference to this chip bug:

> -	/* see notes above for revision 1.07.  Apparent chip bug */

Why? If you think it's not a bug (but got documented meanwhile as the official 
way of updating the microcode and reading out the version) then update the 
comments in a *separate* patch, and update the *other* reference to it as well.

You are repeating the same mistakes again and again.

>  	intel_workarounds(c);
>  
>  	/*
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index ff1ae9b..e93c41f 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -220,8 +220,9 @@ static void print_mce(struct mce *m)
>  		pr_cont("MISC %llx ", m->misc);
>  
>  	pr_cont("\n");
> -	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
> -		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
> +	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x CPU-UPDATE %u\n",
> +		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid, 
> +		cpu_data(m->extcpu).x86_cpu_update);

This text too should be microcode-version or so. Also, while at it please fix 
that printk() to not shout at users needlessly.

> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> index 62ac8cb..cefcc27 100644
> --- a/arch/x86/kernel/cpu/proc.c
> +++ b/arch/x86/kernel/cpu/proc.c
> @@ -132,8 +132,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>  				seq_printf(m, " [%d]", i);
>  		}
>  	}
> +	seq_printf(m, "\n");
>  
> -	seq_printf(m, "\n\n");
> +	if (c->x86_cpu_update)
> +		seq_printf(m, "cpu update\t: %u\n", c->x86_cpu_update);
> +
> +	seq_printf(m, "\n");

This too should say microcode version.

Also, please move the field to the logical place, next to "stepping:". The 
argument about parsers is bogus - anyone parsing /proc/cpuinfo is not in a 
fastpath, full stop.

Also, the above sequence is rather suboptimal to begin with - we can and only 
want to execute a *single* seq_printf() there.

> --- a/arch/x86/kernel/microcode_intel.c
> +++ b/arch/x86/kernel/microcode_intel.c
> @@ -161,12 +161,7 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
>  		csig->pf = 1 << ((val[1] >> 18) & 7);
>  	}
>  
> -	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
> -	/* see notes above for revision 1.07.  Apparent chip bug */
> -	sync_core();
> -	/* get the current revision from MSR 0x8B */
> -	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
> -
> +	csig->rev = c->x86_cpu_update;
>  	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
>  		cpu_num, csig->sig, csig->pf, csig->rev);
>
>  
> @@ -300,6 +295,7 @@ static int apply_microcode(int cpu)
>  	struct ucode_cpu_info *uci;
>  	unsigned int val[2];
>  	int cpu_num;
> +	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
>  
>  	cpu_num = raw_smp_processor_id();
>  	uci = ucode_cpu_info + cpu;
> @@ -335,6 +331,7 @@ static int apply_microcode(int cpu)
>  		(mc_intel->hdr.date >> 16) & 0xff);
>  
>  	uci->cpu_sig.rev = val[1];
> +	c->x86_cpu_update = val[1];
>  
>  	return 0;

Please factor out the reading of the microcode version - you have now created 
two duplicated open-coded versions of it in cpu.c and microcode_intel.c, with 
mismatching comments - not good.

Also, in this branch:

        if (val[1] != mc_intel->hdr.rev) {
                pr_err("CPU%d update to revision 0x%x failed\n",
                       cpu_num, mc_intel->hdr.rev);
                return -1;
        }

it would be nice to put a check:

		WARN_ON_ONCE(val[1] != c->x86_cpu_update);

To make sure that our notion of the version is still in sync with what the 
hardware's notion is. (it should be)

Thanks,

	Ingo
