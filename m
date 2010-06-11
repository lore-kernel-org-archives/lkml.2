Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab0FKUfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab0FKUfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:35:18 -0400
Date: Fri, 11 Jun 2010 16:50:53 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kvm, ept: remove the default write bit
Message-ID: <20100611195052.GC12317@amt.cnet>
References: <4C121E6A.9000009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C121E6A.9000009@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 07:30:50PM +0800, Lai Jiangshan wrote:
> When ept enabled, current code set shadow_base_present_pte
> including the write bit, thus all pte entries have
> writabe bit, and it means guest os can always
> write to any mapped page (even VMM maps RO pages for
> the guest.)
> 
> We always use get_user_pages(write=1), so this bad code does not
> cause any bad result currently.
> 
> But it is really bad, so fix it, and we will use RO pages future.
> 
> We will set writabe bit when it is really writable (determined by
> the parameters of the set_spte())
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index fdb18cf..c7565ea 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4365,8 +4365,7 @@ static int __init vmx_init(void)
>  
>  	if (enable_ept) {
>  		bypass_guest_pf = 0;
> -		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
> -			VMX_EPT_WRITABLE_MASK);
> +		kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK);
>  		kvm_mmu_set_mask_ptes(0ull, 0ull, 0ull, 0ull,
>  				VMX_EPT_EXECUTABLE_MASK);
>  		kvm_enable_tdp();

You can remove the call to kvm_mmu_set_base_ptes entirely, because
VMX_EPT_READABLE_MASK == PT_PRESENT_MASK.

