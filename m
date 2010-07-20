Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0GTWYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:24:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:7424 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0GTWYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:24:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="588121471"
Subject: Re: [PATCH 08/10] x86, xsave: introduce xstate enable functions
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-9-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-9-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 15:23:48 -0700
Message-Id: <1279664628.2899.51.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> The patch renames xsave_cntxt_init() and __xsave_init() into
> xstate_enable_boot_cpu() and xstate_enable() as this names are more
> meaningful.
> 
> It also removes the duplicate xcr setup for the boot cpu.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
>  arch/x86/kernel/xsave.c |   19 ++++++++-----------
>  1 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index 550bf45..2322f58 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -360,15 +360,10 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
>  /*
>   * Enable the extended processor state save/restore feature
>   */
> -static void __cpuinit __xsave_init(void)
> +static inline void xstate_enable(u64 mask)
>  {
>  	set_in_cr4(X86_CR4_OSXSAVE);
> -
> -	/*
> -	 * Enable all the features that the HW is capable of
> -	 * and the Linux kernel is aware of.
> -	 */
> -	xsetbv(XCR_XFEATURE_ENABLED_MASK, pcntxt_mask);
> +	xsetbv(XCR_XFEATURE_ENABLED_MASK, mask);
>  }
>  
>  /*
> @@ -426,7 +421,7 @@ static void __init setup_xstate_init(void)
>  /*
>   * Enable and initialize the xsave feature.
>   */
> -static void __cpuinit xsave_cntxt_init(void)
> +static void __cpuinit xstate_enable_boot_cpu(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  
> @@ -443,7 +438,8 @@ static void __cpuinit xsave_cntxt_init(void)
>  	 * Support only the state known to OS.
>  	 */
>  	pcntxt_mask = pcntxt_mask & XCNTXT_MASK;
> -	__xsave_init();
> +
> +	xstate_enable(pcntxt_mask);
>  
>  	/*
>  	 * Recompute the context size for enabled features
> @@ -470,6 +466,7 @@ void __cpuinit xsave_init(void)
>  	 * Boot processor to setup the FP and extended state context info.
>  	 */
>  	if (!smp_processor_id())
> -		xsave_cntxt_init();
> -	__xsave_init();
> +		xstate_enable_boot_cpu();
> +	else
> +		xstate_enable(pcntxt_mask);
>  }

