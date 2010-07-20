Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab0GTWVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:21:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:56948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819Ab0GTWVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="588120598"
Subject: Re: [PATCH 05/10] x86, xsave: make xsave_cntxt_init() static
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-6-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-6-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 15:20:24 -0700
Message-Id: <1279664424.2899.47.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> There is a lot of cross referencing between fpu and xsave code. This
> patch reduces this by making xsave_cntxt_init() a static function.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/include/asm/xsave.h |    1 -
>  arch/x86/kernel/i387.c       |    5 ++---
>  arch/x86/kernel/xsave.c      |    9 +++++++--
>  3 files changed, 9 insertions(+), 6 deletions(-)

Perhaps we can fold this patch into 
[PATCH 06/10] x86, xsave: do not initialize xsave in fpu_init()

and probably do  fpu_init() first followed by xsave_init() so that
fpu_init() will set xstate_size based on fpu features and xsave_init()
can later overwrite xstate_size based on xstate features.

thanks.

> 
> diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
> index 94d5f84..4d3b5d1 100644
> --- a/arch/x86/include/asm/xsave.h
> +++ b/arch/x86/include/asm/xsave.h
> @@ -28,7 +28,6 @@ extern u64 pcntxt_mask;
>  extern struct xsave_struct *init_xstate_buf;
>  extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
>  
> -extern void xsave_cntxt_init(void);
>  extern void xsave_init(void);
>  extern void update_regset_xstate_info(unsigned int size, u64 xstate_mask);
>  extern int init_fpu(struct task_struct *child);
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 2f32ef0..196b8c7 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -66,10 +66,9 @@ void __cpuinit init_thread_xstate(void)
>  		return;
>  	}
>  
> -	if (cpu_has_xsave) {
> -		xsave_cntxt_init();
> +	if (cpu_has_xsave)
> +		/* xstate_size was already initialized */
>  		return;
> -	}
>  
>  	if (cpu_has_fxsr)
>  		xstate_size = sizeof(struct i387_fxsave_struct);
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index ab9ad48..c46082d 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -429,10 +429,13 @@ static void __init setup_xstate_init(void)
>  /*
>   * Enable and initialize the xsave feature.
>   */
> -void __ref xsave_cntxt_init(void)
> +static void __cpuinit xsave_cntxt_init(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  
> +	if (!cpu_has_xsave)
> +		return;
> +
>  	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
>  	pcntxt_mask = eax + ((u64)edx << 32);
>  
> @@ -469,7 +472,9 @@ void __cpuinit xsave_init(void)
>  	/*
>  	 * Boot processor to setup the FP and extended state context info.
>  	 */
> -	if (!smp_processor_id())
> +	if (!smp_processor_id()) {
> +		xsave_cntxt_init();
>  		init_thread_xstate();
> +	}
>  	__xsave_init();
>  }

