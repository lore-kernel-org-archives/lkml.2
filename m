Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2JJPMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:12:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab2JJPMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:12:23 -0400
Date: Wed, 10 Oct 2012 12:11:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] KVM: MMU: fix release noslot pfn
Message-ID: <20121010151125.GA28406@amt.cnet>
References: <50716EE0.6010504@linux.vnet.ibm.com>
 <50716F1E.90308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50716F1E.90308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 08:01:34PM +0800, Xiao Guangrong wrote:
> We can not directly call kvm_release_pfn_clean to release the pfn
> since we can meet noslot pfn which is used to cache mmio info into
> spte
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c  |    3 +--
>  virt/kvm/kvm_main.c |    4 +---
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index d289fee..6f85fe0 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2497,8 +2497,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		}
>  	}
> 
> -	if (!is_error_pfn(pfn))
> -		kvm_release_pfn_clean(pfn);
> +	kvm_release_pfn_clean(pfn);
>  }
> 
>  static void nonpaging_new_cr3(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cc3f6dc..b65ec97 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1322,9 +1322,7 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
> 
>  void kvm_release_pfn_clean(pfn_t pfn)
>  {
> -	WARN_ON(is_error_pfn(pfn));
> -
> -	if (!kvm_is_mmio_pfn(pfn))
> +	if (!is_error_pfn(pfn) && !kvm_is_mmio_pfn(pfn))
>  		put_page(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
> -- 
> 1.7.7.6

Why does is_error_pfn() return true for mmio spte? Its not an "error",
after all. 

Please kill is_invalid_pfn and use

-> is_error_pfn for checking for errors (mmio spte is not an error pfn,
its a special pfn)

-> add explicit is_noslot_pfn checks where necessary in the code
(say to avoid interpreting a noslot_pfn's pfn "address" bits).

(should have noticed this earlier, sorry).


