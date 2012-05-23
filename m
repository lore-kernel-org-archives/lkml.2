Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab2EWKBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:01:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57173 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab2EWKBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:01:44 -0400
Date: Wed, 23 May 2012 12:01:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH] printk: ignore recursion_bug flag when MCE in progress
Message-ID: <20120523100138.GA13506@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>
References: <4FBC444A.6060500@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FBC444A.6060500@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony

On Wed, May 23, 2012 at 09:58:34AM +0800, ShuoX Liu wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
> 
> When MCE happens in printk, we ignore recursion_bug to make sure
> some MCE logs printed out. Re-use mce_entry variable.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
> I found mce_entry was introduced by commit 553f265f, but it's not
> used now. Why not removed?
> ---
>  arch/x86/include/asm/mce.h       |    2 --
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 --
>  include/linux/kernel.h           |    1 +
>  kernel/printk.c                  |    4 +++-
>  4 files changed, 4 insertions(+), 5 deletions(-)
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
> index 11c9166..6073354 100644
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
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 645231c..24af685 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -354,6 +354,7 @@ unsigned long int_sqrt(unsigned long);
>  extern void bust_spinlocks(int yes);
>  extern void wake_up_klogd(void);
>  extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
> +extern atomic_t mce_entry;
>  extern int panic_timeout;
>  extern int panic_on_oops;
>  extern int panic_on_unrecovered_nmi;
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 473afdb..2bae087 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -79,6 +79,7 @@ int console_printk[4] = {
>  int oops_in_progress;
>  EXPORT_SYMBOL(oops_in_progress);
>  
> +atomic_t mce_entry;
>  /*
>   * console_sem protects the console_drivers list, and also
>   * provides serialisation for access to the entire console
> @@ -864,7 +865,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
>  		 * recursion and return - but flag the recursion so that
>  		 * it can be printed at the next appropriate moment:
>  		 */
> -		if (!oops_in_progress && !lockdep_recursing(current)) {
> +		if (!oops_in_progress && !atomic_read(&mce_entry)

This is leaking x86-specific (MCE) stuff in generic kernel code. I think
it would be more appropriate to add a in_hw_error() helper or similar
and define it on each arch. I can very well imagine other architectures
would like to print hw error info too...

Hmmm.

-- 
Regards/Gruss,
Boris.
