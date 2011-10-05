Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522Ab1JESuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:50:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:34225 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933846Ab1JESuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:50:07 -0400
Date: Wed, 5 Oct 2011 20:49:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fenghua Yu <fenghua.yu@intel.com>
cc: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] x86, i387.c: thread xstate is initialized only on
 BSP once
In-Reply-To: <1317832759-10223-4-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.LFD.2.02.1110052048290.18778@ionos>
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-4-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Fenghua Yu wrote:

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
> index 739d859..de2b48a 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -93,6 +93,7 @@ void __cpuinit fpu_init(void)
>  {
>  	unsigned long cr0;
>  	unsigned long cr4_mask = 0;
> +	static int once;
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
> +	 * xstate_size.
> +	 */
> +	if (!smp_processor_id() && once) {

Brilliant change. Makes sure that init_thread_xstate() is NEVER
called. Was this crap tested at all?

> +		once = 0;
>  		init_thread_xstate();
> +	}
>  
>  	mxcsr_feature_mask_init();
>  	/* clean state in init */
> -- 
> 1.6.0.3
> 
> 
