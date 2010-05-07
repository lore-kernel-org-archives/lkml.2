Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab0EGU44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 16:56:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757109Ab0EGU4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 16:56:54 -0400
Date: Fri, 7 May 2010 17:14:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm mmu: reduce 50% memory usage
Message-ID: <20100507201416.GA12974@amt.cnet>
References: <4BD8228D.7090708@cn.fujitsu.com>
 <20100429180955.GA17909@amt.cnet>
 <4BD9D35C.5090403@redhat.com>
 <20100430154427.GA32340@amt.cnet>
 <4BE269D4.9090108@cn.fujitsu.com>
 <20100506190402.GA3432@amt.cnet>
 <4BE3CE80.8050408@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE3CE80.8050408@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 04:25:36PM +0800, Lai Jiangshan wrote:
> Subject: [PATCH] kvm, tdp: calculate correct base gfn for non-DIR level
> 
> the base gfn calculation is incorrect in __direct_map(),
> it does not calculate correctly when level=3 or 4.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> ---
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index a5c6719..6986a6f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1955,7 +1956,10 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t v, int write,
>  		}
>  
>  		if (*iterator.sptep == shadow_trap_nonpresent_pte) {
> -			pseudo_gfn = (iterator.addr & PT64_DIR_BASE_ADDR_MASK) >> PAGE_SHIFT;
> +			u64 base_addr = iterator.addr;
> +
> +			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
> +			pseudo_gfn = base_addr >> PAGE_SHIFT;
>  			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
>  					      iterator.level - 1,
>  					      1, ACC_ALL, iterator.sptep);

Looks good, please resend the whole patch.
