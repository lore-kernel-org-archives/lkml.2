Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab0GTWWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:22:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:56018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab0GTWWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:22:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="819976856"
Subject: Re: [PATCH 06/10] x86, xsave: do not initialize xsave in fpu_init()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-7-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-7-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 15:21:51 -0700
Message-Id: <1279664511.2899.49.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> As xsave also supports other than fpu features, it should be
> initialized independently of the fpu. This patch moves this out of fpu
> initialization.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

As I mentioned in the previous patch, can we do xsave_init() after
fpu_init(). fpu_init() does some basic initialization like clearing TS
and EM bits etc. xsave_init() can be followed after this.

thanks.

> ---
>  arch/x86/include/asm/i387.h  |    1 -
>  arch/x86/kernel/cpu/common.c |    2 ++
>  arch/x86/kernel/i387.c       |   17 ++++++++++++++---
>  arch/x86/kernel/xsave.c      |    4 +---
>  4 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index 59bd93a..509ddab 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -31,7 +31,6 @@ extern void mxcsr_feature_mask_init(void);
>  extern int init_fpu(struct task_struct *child);
>  extern asmlinkage void math_state_restore(void);
>  extern void __math_state_restore(void);
> -extern void init_thread_xstate(void);
>  extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
>  
>  extern user_regset_active_fn fpregs_active, xfpregs_active;
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 1a053e0..d8eba22 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1209,6 +1209,7 @@ void __cpuinit cpu_init(void)
>  	clear_all_debug_regs();
>  	dbg_restore_debug_regs();
>  
> +	xsave_init();
>  	fpu_init();
>  
>  	raw_local_save_flags(kernel_eflags);
> @@ -1271,5 +1272,6 @@ void __cpuinit cpu_init(void)
>  	mxcsr_feature_mask_init();
>  
>  	xsave_init();
> +	fpu_init();
>  }
>  #endif
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 196b8c7..122a764 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -59,7 +59,7 @@ void __cpuinit mxcsr_feature_mask_init(void)
>  	stts();
>  }
>  
> -void __cpuinit init_thread_xstate(void)
> +static void __cpuinit init_thread_xstate(void)
>  {
>  	if (!HAVE_HWFP) {
>  		xstate_size = sizeof(struct i387_soft_struct);
> @@ -83,6 +83,7 @@ void __cpuinit init_thread_xstate(void)
>   * Called at bootup to set up the initial FPU state that is later cloned
>   * into all processes.
>   */
> +
>  void __cpuinit fpu_init(void)
>  {
>  	unsigned long oldcr0 = read_cr0();
> @@ -92,14 +93,24 @@ void __cpuinit fpu_init(void)
>  
>  	write_cr0(oldcr0 & ~(X86_CR0_TS|X86_CR0_EM)); /* clear TS and EM */
>  
> -	xsave_init();
> +	if (!smp_processor_id())
> +		init_thread_xstate();
>  
>  	mxcsr_feature_mask_init();
>  	/* clean state in init */
>  	current_thread_info()->status = 0;
>  	clear_used_math();
>  }
> -#endif	/* CONFIG_X86_64 */
> +
> +#else	/* CONFIG_X86_64 */
> +
> +void __cpuinit fpu_init(void)
> +{
> +	if (!smp_processor_id())
> +		init_thread_xstate();
> +}
> +
> +#endif	/* CONFIG_X86_32 */
>  
>  static void fpu_finit(struct fpu *fpu)
>  {
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index c46082d..a594f49 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -472,9 +472,7 @@ void __cpuinit xsave_init(void)
>  	/*
>  	 * Boot processor to setup the FP and extended state context info.
>  	 */
> -	if (!smp_processor_id()) {
> +	if (!smp_processor_id())
>  		xsave_cntxt_init();
> -		init_thread_xstate();
> -	}
>  	__xsave_init();
>  }

