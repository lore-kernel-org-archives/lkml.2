Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1KKSYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:24:35 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38054 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1KKSYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:24:33 -0500
Date: Fri, 11 Nov 2011 13:24:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v3 6/7] x86/i387.c: Thread xstate is initialized only on
 BSP once
Message-ID: <20111111182401.GB8615@phenom.dumpdata.com>
References: <1320885257-16647-1-git-send-email-fenghua.yu@intel.com>
 <1320885257-16647-7-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320885257-16647-7-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EBD684C.006E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 04:34:16PM -0800, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> init_thread_xstate() is only called on BSP once to avoid to override
> xstate_size.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/i387.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 739d859..f721a61 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -93,6 +93,7 @@ void __cpuinit fpu_init(void)
>  {
>  	unsigned long cr0;
>  	unsigned long cr4_mask = 0;
> +	static int once = 1;
>  
>  	if (cpu_has_fxsr)
>  		cr4_mask |= X86_CR4_OSFXSR;
> @@ -107,8 +108,14 @@ void __cpuinit fpu_init(void)
>  		cr0 |= X86_CR0_EM;
>  	write_cr0(cr0);
>  
> -	if (!smp_processor_id())
> +	/*
> +	 * init_thread_xstate is only called on BSP once to avoid to override

"to avoid overriding xstate_size"

> +	 * xstate_size.
> +	 */
> +	if (!smp_processor_id() && once) {
> +		once = 0;
>  		init_thread_xstate();
> +	}
>  
>  	mxcsr_feature_mask_init();
>  	/* clean state in init */
> -- 
> 1.6.0.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
