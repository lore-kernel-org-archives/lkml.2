Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1ELG7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:59:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38278 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1ELG7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:59:41 -0400
Date: Thu, 12 May 2011 08:59:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Bruce Schlobohm <bruce.schlobohm@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] x86, cpu: Enable/disable SMEP
Message-ID: <20110512065923.GL3191@elte.hu>
References: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
 <1305141480-843-4-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305141480-843-4-git-send-email-fenghua.yu@intel.com>
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


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Enable/disable newly documented SMEP (Supervisor Mode Execution Protection) CPU
> feature in kernel. CR4.SMEP (bit 20) is 0 at power-on. If the feature is
> supported by CPU (X86_FEATURE_SMEP), enable SMEP by setting CR4.SMEP. New kernel
> option nosmep disables the feature even if the feature is supported by CPU.

Please add a clearer explanation to the changelog and the code as well, 
something like:

   SMEP prevents the CPU in kernel-mode to jump to an executable page that does
   not have the kernel/system flag set in the pte. This prevents the kernel
   from executing user-space code accidentally or maliciously, so it for 
   example prevents kernel exploits from jumping to specially prepared 
   user-mode shell code.

> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  arch/x86/kernel/cpu/common.c        |   21 +++++++++++++++++++++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index cc85a92..56fb8c1 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1664,6 +1664,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			noexec=on: enable non-executable mappings (default)
>  			noexec=off: disable non-executable mappings
>  
> +	nosmep		[X86]
> +			Disable SMEP (Supervisor Mode Execution Protection)
> +			even if it is supported by processor.

Typo: s/by processor/by the processor

> +
>  	noexec32	[X86-64]
>  			This affects only 32-bit executables.
>  			noexec32=on: enable non-executable mappings (default)
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index e2ced00..f06b2d5 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -254,6 +254,25 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
>  }
>  #endif
>  
> +static int disable_smep;
> +static __init int setup_disable_smep(char *arg)

Nit: please put a newline between variables and the next function.

Also, since setup_smep() is __init this could be __initdata.

> +{
> +	disable_smep = 1;
> +	return 1;
> +}
> +__setup("nosmep", setup_disable_smep);

Naming nit: s/setup_disable_smep/setup_nosmep

> +static __init void setup_smep(struct cpuinfo_x86 *c)
> +{
> +	if (cpu_has(c, X86_FEATURE_SMEP)) {
> +		if (unlikely(disable_smep)) {
> +			setup_clear_cpu_cap(X86_FEATURE_SMEP);
> +			clear_in_cr4(X86_CR4_SMEP);
> +		} else
> +			set_in_cr4(X86_CR4_SMEP);

Nit: Please use symmetric curly braces.

> +	}
> +}
> +
>  /*
>   * Some CPU features depend on higher CPUID levels, which may not always
>   * be available due to CPUID level capping or broken virtualization
> @@ -867,6 +886,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
>  	/* Init Machine Check Exception if available. */
>  	mcheck_cpu_init(c);
>  
> +	setup_smep(c);
> +
>  	select_idle_routine(c);

The other option would be to enable SMEP in arch/x86/kernel/head_32/64.S where 
we twiddle the cr4 anyway and enable PAE and PGE, and where we do a cpuid to 
check whether the CPU supports NX.

This means we enable SMEP unconditionally on all CPUs that support it, the 
nosmep boot option would turn it off shortly afterwards.

Also, is there some KVM impact of this CPU feature? If the hypervisor can pass 
this to the guest kernel as well then we want to add support there as well, and 
probably want to turn it on by default. (unless it breaks something in a bad 
way)

Thanks,

	Ingo
