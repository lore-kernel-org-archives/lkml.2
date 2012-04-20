Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2DUAMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:12:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2DUAMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:12:37 -0400
Date: Fri, 20 Apr 2012 18:39:25 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/9] KVM: MMU: introduce SPTE_ALLOW_WRITE bit
Message-ID: <20120420213925.GB13817@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
 <4F911BE7.30206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F911BE7.30206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 04:18:47PM +0800, Xiao Guangrong wrote:
> This bit indicates whether the spte is allow to be writable that
> means the gpte of this spte is writable and the pfn pointed by
> this spte is writable on host
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index e70ff38..dd984b6 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -145,7 +145,8 @@ module_param(dbg, bool, 0644);
>  #define CREATE_TRACE_POINTS
>  #include "mmutrace.h"
> 
> -#define SPTE_HOST_WRITEABLE (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
> +#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
> +#define SPTE_ALLOW_WRITE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
> 
>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> 
> @@ -1177,9 +1178,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
>  			new_spte |= (u64)new_pfn << PAGE_SHIFT;
> 
> -			new_spte &= ~PT_WRITABLE_MASK;
> -			new_spte &= ~SPTE_HOST_WRITEABLE;
> -			new_spte &= ~shadow_accessed_mask;
> +			new_spte &= ~(PT_WRITABLE_MASK | SPTE_HOST_WRITEABLE |
> +				      shadow_accessed_mask | SPTE_ALLOW_WRITE);

Each bit should have a distinct meaning. Here the host pte is being
write-protected, which means only the SPTE_HOST_WRITEABLE bit
should be cleared.
