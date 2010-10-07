Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab0JGC1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:27:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:12494 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab0JGC1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:27:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,295,1283756400"; 
   d="scan'208";a="664897760"
Date: Thu, 7 Oct 2010 10:27:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "x86@kernel.org" <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] x86: HWPOISON: Report correct address granuality
 for huge hwpoison faults
Message-ID: <20101007022708.GD5482@localhost>
References: <1286398641-11862-1-git-send-email-andi@firstfloor.org>
 <1286398641-11862-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286398641-11862-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 04:57:21AM +0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> An earlier patch fixed the hwpoison fault handling to encode the
> huge page size in the fault code of the page fault handler.
> 
> This is needed to report this information in SIGBUS to user space.
> 
> This is a straight forward patch to pass this information
> through to the signal handling in the x86 specific fault.c
> 
> Cc: x86@kernel.org
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: fengguang.wu@intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/mm/fault.c |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 4c4508e..1d15a27 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -11,6 +11,7 @@
>  #include <linux/kprobes.h>		/* __kprobes, ...		*/
>  #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
>  #include <linux/perf_event.h>		/* perf_sw_event		*/
> +#include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
>  
>  #include <asm/traps.h>			/* dotraplinkage, ...		*/
>  #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
> @@ -160,15 +161,20 @@ is_prefetch(struct pt_regs *regs, unsigned long error_code, unsigned long addr)
>  
>  static void
>  force_sig_info_fault(int si_signo, int si_code, unsigned long address,
> -		     struct task_struct *tsk)
> +		     struct task_struct *tsk, int fault)
>  {
> +	unsigned lsb = 0;
>  	siginfo_t info;
>  
>  	info.si_signo	= si_signo;
>  	info.si_errno	= 0;
>  	info.si_code	= si_code;
>  	info.si_addr	= (void __user *)address;
> -	info.si_addr_lsb = si_code == BUS_MCEERR_AR ? PAGE_SHIFT : 0;

Ah you changed the conditional 0..

> +	if (fault & VM_FAULT_HWPOISON_LARGE)
> +		lsb = hstate_index_to_shift(VM_FAULT_GET_HINDEX(fault)); 
> +	if (fault & VM_FAULT_HWPOISON)
> +		lsb = PAGE_SHIFT;
> +	info.si_addr_lsb = lsb;
>  
>  	force_sig_info(si_signo, &info, tsk);
>  }
> @@ -731,7 +737,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
>  		tsk->thread.error_code	= error_code | (address >= TASK_SIZE);
>  		tsk->thread.trap_no	= 14;
>  
> -		force_sig_info_fault(SIGSEGV, si_code, address, tsk);
> +		force_sig_info_fault(SIGSEGV, si_code, address, tsk, 0);

..and it's sure reasonable.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang
