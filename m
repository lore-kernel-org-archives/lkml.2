Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988Ab0J0J7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:59:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab0J0J7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:59:43 -0400
Date: Wed, 27 Oct 2010 11:59:37 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/8] KVM: fix tracing kvm_try_async_get_page
Message-ID: <20101027095937.GK26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EA7D.5020901@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:01:49PM +0800, Xiao Guangrong wrote:
> Tracing 'async' and *pfn is useless, since 'async' is always true,
> and '*pfn' is always "fault_pfn'
> 
> We can trace 'gva' and 'gfn' instead, it can help us to see the
> life-cycle of an async_pf
> 
Make sense. This is leftover from earlier patches iteration where this
trace function was called when async==false too.
 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |    2 +-
>  include/trace/events/kvm.h |   12 +++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 7ab734d..7449803 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2618,7 +2618,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
