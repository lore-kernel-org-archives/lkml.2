Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0KANJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab0KANJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:09:47 -0400
Date: Mon, 1 Nov 2010 15:09:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] KVM: fix tracing kvm_try_async_get_page
Message-ID: <20101101130944.GF31722@redhat.com>
References: <4CCE8143.3090105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCE8143.3090105@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 04:58:43PM +0800, Xiao Guangrong wrote:
> Tracing 'async' and *pfn is useless, since 'async' is always true,
> and '*pfn' is always "fault_pfn'
> 
> We can trace 'gva' and 'gfn' instead, it can help us to see the
> life-cycle of an async_pf
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  arch/x86/kvm/mmu.c         |    2 +-
>  include/trace/events/kvm.h |   12 +++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 39cc0c6..5275c50 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2627,7 +2627,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
>  	put_page(pfn_to_page(*pfn));
>  
>  	if (!no_apf && can_do_async_pf(vcpu)) {
> -		trace_kvm_try_async_get_page(async, *pfn);
> +		trace_kvm_try_async_get_page(gva, gfn);
>  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
>  			trace_kvm_async_pf_doublefault(gva, gfn);
>  			kvm_make_request(KVM_REQ_APF_HALT, vcpu);
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 9c2cc6a..30063c6 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -188,18 +188,20 @@ TRACE_EVENT(kvm_age_page,
>  #ifdef CONFIG_KVM_ASYNC_PF
>  TRACE_EVENT(
>  	kvm_try_async_get_page,
> -	TP_PROTO(bool async, u64 pfn),
> -	TP_ARGS(async, pfn),
> +	TP_PROTO(u64 gva, u64 gfn),
> +	TP_ARGS(gva, gfn),
>  
>  	TP_STRUCT__entry(
> -		__field(__u64, pfn)
> +		__field(u64, gva)
> +		__field(u64, gfn)
>  		),
>  
>  	TP_fast_assign(
> -		__entry->pfn = (!async) ? pfn : (u64)-1;
> +		__entry->gva = gva;
> +		__entry->gfn = gfn;
>  		),
>  
> -	TP_printk("pfn %#llx", __entry->pfn)
> +	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
>  );
>  
>  TRACE_EVENT(
> -- 
> 1.7.0.4

--
			Gleb.
