Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525Ab0GTVtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:49:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:13062 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab0GTVtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:49:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="537306764"
Subject: Re: [PATCH 04/10] x86, xsave: moving boot cpu initialization to
 xsave_init()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-5-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 14:48:43 -0700
Message-Id: <1279662523.2899.16.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> This patch moves boot cpu initialization to xsave_init(). Now all cpus
> are initialized in one single function.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c |    6 ------
>  arch/x86/kernel/i387.c       |    5 -----
>  arch/x86/kernel/xsave.c      |   14 ++++++++++++--
>  3 files changed, 12 insertions(+), 13 deletions(-)

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 433afed..1a053e0 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1270,12 +1270,6 @@ void __cpuinit cpu_init(void)
>  	clear_used_math();
>  	mxcsr_feature_mask_init();
>  
> -	/*
> -	 * Boot processor to setup the FP and extended state context info.
> -	 */
> -	if (!smp_processor_id())
> -		init_thread_xstate();
> -
>  	xsave_init();
>  }
>  #endif
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 6106af9..2f32ef0 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -93,11 +93,6 @@ void __cpuinit fpu_init(void)
>  
>  	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
>  
> -	/*
> -	 * Boot processor to setup the FP and extended state context info.
> -	 */
> -	if (!smp_processor_id())
> -		init_thread_xstate();
>  	xsave_init();
>  
>  	mxcsr_feature_mask_init();
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index 368047c..ab9ad48 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -360,7 +360,7 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
>  /*
>   * Enable the extended processor state save/restore feature
>   */
> -void __cpuinit xsave_init(void)
> +static void __cpuinit __xsave_init(void)
>  {
>  	if (!cpu_has_xsave)
>  		return;
> @@ -446,7 +446,7 @@ void __ref xsave_cntxt_init(void)
>  	 * Support only the state known to OS.
>  	 */
>  	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
> -	xsave_init();
> +	__xsave_init();
>  
>  	/*
>  	 * Recompute the context size for enabled features
> @@ -463,3 +463,13 @@ void __ref xsave_cntxt_init(void)
>  	       "cntxt size 0x%x\n",
>  	       pcntxt_mask, xstate_size);
>  }
> +
> +void __cpuinit xsave_init(void)
> +{
> +	/*
> +	 * Boot processor to setup the FP and extended state context info.
> +	 */
> +	if (!smp_processor_id())
> +		init_thread_xstate();
> +	__xsave_init();
> +}

