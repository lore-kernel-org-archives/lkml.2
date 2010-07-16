Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0GQBr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:47:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab0GQBr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:47:27 -0400
Date: Fri, 16 Jul 2010 20:18:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 4/6] kvm: add host_writable parameter
Message-ID: <20100716231855.GA8946@amt.cnet>
References: <4C3FC030.2050301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3FC030.2050301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:13:04AM +0800, Lai Jiangshan wrote:
> add host_writable parameter for some functions,
> no functionality changed, prepare for using RO pages.
> 
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0867ced..8ba9b0d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1861,7 +1861,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		    unsigned pte_access, int user_fault,
>  		    int write_fault, int dirty, int level,
>  		    gfn_t gfn, pfn_t pfn, bool speculative,
> -		    bool can_unsync, bool reset_host_protection)
> +		    bool can_unsync, bool host_writable)
>  {
>  	u64 spte;
>  	int ret = 0;
> @@ -1888,8 +1888,10 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
>  			kvm_is_mmio_pfn(pfn));
>  
> -	if (reset_host_protection)
> +	if (host_writable)
>  		spte |= SPTE_HOST_WRITEABLE;
> +	else
> +		pte_access &= ~ACC_WRITE_MASK;

Two vcpus faulting the same address with different access type can 
now race:

vcpu0                               vcpu1

read fault                          write fault
gfn_to_pfn readonly
                                    gfn_to_pfn write, break COW
                                    set writable spte to COWed page
                                    vcpu writes to page
set spte to original page
vcpu reads stale content

Should not instantiate a new spte if (pfn != spte_to_pfn(*sptep)), to
cause a refault.

