Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0DLRMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab0DLRMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:12:43 -0400
Date: Mon, 12 Apr 2010 14:10:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
Message-ID: <20100412171037.GB4976@amt.cnet>
References: <4BC2D2E2.1030604@cn.fujitsu.com>
 <4BC2D345.100@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC2D345.100@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 04:01:09PM +0800, Xiao Guangrong wrote:
> - calculate zapped page number properly in mmu_zap_unsync_children()
> - calculate freeed page number properly kvm_mmu_change_mmu_pages()
> - restart list walking if have children page zapped
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index a23ca75..8f4f781 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1483,8 +1483,8 @@ static int mmu_zap_unsync_children(struct kvm *kvm,
>  		for_each_sp(pages, sp, parents, i) {
>  			kvm_mmu_zap_page(kvm, sp);
>  			mmu_pages_clear_parents(&parents);
> +			zapped++;
>  		}
> -		zapped += pages.nr;
>  		kvm_mmu_pages_init(parent, &parents, &pages);
>  	}

Don't see why this is needed? The for_each_sp loop uses pvec.nr.

> @@ -1540,7 +1540,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages)
>  
>  			page = container_of(kvm->arch.active_mmu_pages.prev,
>  					    struct kvm_mmu_page, link);
> -			kvm_mmu_zap_page(kvm, page);
> +			used_pages -= kvm_mmu_zap_page(kvm, page);
>  			used_pages--;
>  		}
>  		kvm->arch.n_free_mmu_pages = 0;

Oops.

> @@ -1589,7 +1589,8 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
>  		    && !sp->role.invalid) {
>  			pgprintk("%s: zap %lx %x\n",
>  				 __func__, gfn, sp->role.word);
> -			kvm_mmu_zap_page(kvm, sp);
> +			if (kvm_mmu_zap_page(kvm, sp))
> +				nn = bucket->first;

Oops 2.
