Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2EXGLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 02:11:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45468 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab2EXGLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 02:11:49 -0400
Date: Thu, 24 May 2012 08:11:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] printk: ignore recursion_bug flag in HW error handle
 process
Message-ID: <20120524061145.GA18284@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
References: <4FBC444A.6060500@intel.com>
 <20120523100138.GA13506@x1.osrc.amd.com>
 <4FBDCE4A.7050900@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBDCE4A.7050900@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:59:38PM +0800, ShuoX Liu wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> When MCE happens in printk, we ignore recursion_bug to make sure MCE logs printed out.
> 
> According to Boris' suggestion, we add some helper functions.
> 1) hw_error_enter: Call it when specific arch begins to process a hardware error.
> 2) hw_error_exit: Call it when specific arch finishes the processing of a hardware error.
> 3) in_hw_error():indicates whether HW error handling is in processing.
> 
> Each arch could call the helpers in their arch-dependent HW error handlers.

Yep, looks better, thanks. Design question though:

> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
>  arch/x86/include/asm/mce.h       |    2 --
>  arch/x86/kernel/cpu/mcheck/mce.c |    6 ++----
>  include/linux/cpu.h              |   17 +++++++++++++++++
>  kernel/cpu.c                     |    3 +++
>  kernel/printk.c                  |    3 ++-
>  5 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 441520e..aeda4cc 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -187,8 +187,6 @@ int mce_available(struct cpuinfo_x86 *c);
>  DECLARE_PER_CPU(unsigned, mce_exception_count);
>  DECLARE_PER_CPU(unsigned, mce_poll_count);
>  
> -extern atomic_t mce_entry;
> -
>  typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
>  DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
>  
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2afcbd2..aaf41d2 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -61,8 +61,6 @@ int mce_disabled __read_mostly;
>  
>  #define SPINUNIT 100	/* 100ns */
>  
> -atomic_t mce_entry;
> -
>  DEFINE_PER_CPU(unsigned, mce_exception_count);
>  
>  /*
> @@ -1015,7 +1013,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  	DECLARE_BITMAP(toclear, MAX_NR_BANKS);
>  	char *msg = "Unknown";
>  
> -	atomic_inc(&mce_entry);
> +	hw_error_enter();
>  
>  	this_cpu_inc(mce_exception_count);
>  
> @@ -1143,7 +1141,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		mce_report_event(regs);
>  	mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
>  out:
> -	atomic_dec(&mce_entry);
> +	hw_error_exit();
>  	sync_core();
>  }
>  EXPORT_SYMBOL_GPL(do_machine_check);
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 7230bb5..beb56d0 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -210,4 +210,21 @@ static inline int disable_nonboot_cpus(void) { return 0; }
>  static inline void enable_nonboot_cpus(void) {}
>  #endif /* !CONFIG_PM_SLEEP_SMP */
>  
> +/* HW error handle status helpers */
> +extern atomic_t hw_error;
> +static inline void hw_error_enter(void)
> +{
> +	atomic_inc(&hw_error);
> +}
> +
> +static inline void hw_error_exit(void)
> +{
> +	atomic_dec(&hw_error);
> +}
> +
> +static inline int in_hw_error(void)
> +{
> +	return atomic_read(&hw_error);
> +}

Shouldn't those be generic empty functions and each arch implement their
own with the stuff they want to do on the respective architecture when
they get a hardware error?

Andrew, Ingo?

Thanks.

-- 
Regards/Gruss,
    Boris.
