Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0JHWHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:07:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab0JHWHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:07:00 -0400
Date: Fri, 8 Oct 2010 17:25:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dean Nelson <dnelson@redhat.com>
Subject: Re: [PATCH 2/2] kvm, MCE, Send SRAR SIGBUS directly
Message-ID: <20101008202501.GA2291@amt.cnet>
References: <1286526255.7768.96.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286526255.7768.96.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:24:15PM +0800, Huang Ying wrote:
> Originally, SRAR SIGBUS is sent to QEMU-KVM via touching the poisoned
> page. But commit 96054569190bdec375fe824e48ca1f4e3b53dd36 prevents the
> signal from being sent. So now the signal is sent via
> force_sig_info_fault directly.
> 
> Reported-by: Dean Nelson <dnelson@redhat.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/include/asm/signal.h |    3 +++
>  arch/x86/kvm/mmu.c            |   15 +++------------
>  arch/x86/mm/fault.c           |    6 +++---
>  3 files changed, 9 insertions(+), 15 deletions(-)
> 
> --- a/arch/x86/include/asm/signal.h
> +++ b/arch/x86/include/asm/signal.h
> @@ -258,6 +258,9 @@ struct pt_regs;
>  
>  #define ptrace_signal_deliver(regs, cookie) do { } while (0)
>  
> +void force_sig_info_fault(int si_signo, int si_code, unsigned long address,
> +			  struct task_struct *tsk);
> +
>  #endif /* __KERNEL__ */
>  #endif /* __ASSEMBLY__ */
>  
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -158,9 +158,8 @@ is_prefetch(struct pt_regs *regs, unsign
>  	return prefetch;
>  }
>  
> -static void
> -force_sig_info_fault(int si_signo, int si_code, unsigned long address,
> -		     struct task_struct *tsk)
> +void force_sig_info_fault(int si_signo, int si_code, unsigned long address,
> +			  struct task_struct *tsk)
>  {
>  	siginfo_t info;
>  
> @@ -172,6 +171,7 @@ force_sig_info_fault(int si_signo, int s
>  
>  	force_sig_info(si_signo, &info, tsk);
>  }
> +EXPORT_SYMBOL_GPL(force_sig_info_fault);
>  
>  DEFINE_SPINLOCK(pgd_lock);
>  LIST_HEAD(pgd_list);
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -39,6 +39,7 @@
>  #include <asm/cmpxchg.h>
>  #include <asm/io.h>
>  #include <asm/vmx.h>
> +#include <asm/signal.h>
>  
>  /*
>   * When setting this variable to true it enables Two-Dimensional-Paging
> @@ -2104,22 +2105,12 @@ static int __direct_map(struct kvm_vcpu
>  	return pt_write;
>  }
>  
> -static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
> -{
> -	char buf[1];
> -	void __user *hva;
> -	int r;
> -
> -	/* Touch the page, so send SIGBUS */
> -	hva = (void __user *)gfn_to_hva(kvm, gfn);
> -	r = copy_from_user(buf, hva, 1);
> -}
> -
>  static int kvm_handle_bad_page(struct kvm *kvm, gfn_t gfn, pfn_t pfn)
>  {
>  	kvm_release_pfn_clean(pfn);
>  	if (is_hwpoison_pfn(pfn)) {
> -		kvm_send_hwpoison_signal(kvm, gfn);
> +		force_sig_info_fault(SIGBUS, BUS_MCEERR_AR,
> +				     gfn_to_hva(kvm, gfn), current);
>  		return 0;
>  	} else if (is_fault_pfn(pfn))
>  		return -EFAULT;

Better fill siginfo and use force_sig_info, which is already exported.
