Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908Ab0J0KvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0J0KvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:51:01 -0400
Date: Wed, 27 Oct 2010 12:50:57 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/8] KVM: simply wakup async pf
Message-ID: <20101027105057.GP26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EBD4.6070105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EBD4.6070105@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:07:32PM +0800, Xiao Guangrong wrote:
> The current way is queued a complete async pf with:
> 	asyc_pf.page = bad_page
> 	async_pf.arch.gfn = 0
> 
> It has two problems while kvm_check_async_pf_completion handle this
> async_pf:
> - since !async_pf.page, it can retry a pseudo #PF
kvm_arch_async_page_ready checks for is_error_page()

> - it can delete gfn 0 from vcpu->arch.apf.gfns[]
kvm_arch_async_page_present() checks for is_error_page() too and,
in case of PV guest, injects special token if it is true. 

After your patch special token will not be injected and migration will
not work.

> Actually, we can simply record this wakeup request and let
> kvm_check_async_pf_completion simply break the wait
> 
May be wakeup_all function naming is misleading. It means wake up all PV
guest processes by sending broadcast async pf notification. It is not
about waking host vcpu thread.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  include/linux/kvm_host.h |    1 +
>  virt/kvm/async_pf.c      |   21 ++++++---------------
>  2 files changed, 7 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0c1b7c5..d91add9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -131,6 +131,7 @@ struct kvm_vcpu {
>  		struct list_head queue;
>  		struct list_head done;
>  		spinlock_t lock;
> +		bool wakeup;
>  	} async_pf;
>  #endif
>  
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 5307a32..0d1f6c4 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -124,6 +124,11 @@ bool kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_async_pf *work;
>  
> +	if (vcpu->async_pf.wakeup) {
> +		vcpu->async_pf.wakeup = false;
> +		return true;
> +	}
> +
>  	if (list_empty_careful(&vcpu->async_pf.done) ||
>  	    !kvm_arch_can_inject_async_page_present(vcpu))
>  		return false;
> @@ -197,20 +202,6 @@ retry_sync:
>  
>  int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_async_pf *work;
> -
> -	if (!list_empty(&vcpu->async_pf.done))
> -		return 0;
> -
> -	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
> -	if (!work)
> -		return -ENOMEM;
> -
> -	work->page = bad_page;
> -	get_page(bad_page);
> -	INIT_LIST_HEAD(&work->queue); /* for list_del to work */
> -
> -	list_add_tail(&work->link, &vcpu->async_pf.done);
> -	vcpu->async_pf.queued++;
> +	vcpu->async_pf.wakeup = true;
>  	return 0;
>  }
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
