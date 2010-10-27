Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab0J0KLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436Ab0J0KK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:10:59 -0400
Date: Wed, 27 Oct 2010 12:10:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/8] KVM: cleanup aysnc_pf tracepoints
Message-ID: <20101027101055.GL26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EABA.3040302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EABA.3040302@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:02:50PM +0800, Xiao Guangrong wrote:
> Use 'DECLARE_EVENT_CLASS' to cleanup async_pf tracepoints
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Nice

Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  include/trace/events/kvm.h |   76 ++++++++++++++++++++-----------------------
>  1 files changed, 35 insertions(+), 41 deletions(-)
> 
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 30063c6..7bec396 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -186,59 +186,71 @@ TRACE_EVENT(kvm_age_page,
>  );
>  
>  #ifdef CONFIG_KVM_ASYNC_PF
> -TRACE_EVENT(
> -	kvm_try_async_get_page,
> +DECLARE_EVENT_CLASS(kvm_async_get_page_class,
> +
>  	TP_PROTO(u64 gva, u64 gfn),
> +
>  	TP_ARGS(gva, gfn),
>  
>  	TP_STRUCT__entry(
> -		__field(u64, gva)
> +		__field(__u64, gva)
>  		__field(u64, gfn)
> -		),
> +	),
>  
>  	TP_fast_assign(
>  		__entry->gva = gva;
>  		__entry->gfn = gfn;
> -		),
> +	),
>  
>  	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
>  );
>  
> -TRACE_EVENT(
> -	kvm_async_pf_not_present,
> +DEFINE_EVENT(kvm_async_get_page_class, kvm_try_async_get_page,
> +
> +	TP_PROTO(u64 gva, u64 gfn),
> +
> +	TP_ARGS(gva, gfn)
> +);
> +
> +DEFINE_EVENT(kvm_async_get_page_class, kvm_async_pf_doublefault,
> +
> +	TP_PROTO(u64 gva, u64 gfn),
> +
> +	TP_ARGS(gva, gfn)
> +);
> +
> +DECLARE_EVENT_CLASS(kvm_async_pf_nopresent_ready,
> +
>  	TP_PROTO(u64 token, u64 gva),
> +
>  	TP_ARGS(token, gva),
>  
>  	TP_STRUCT__entry(
>  		__field(__u64, token)
>  		__field(__u64, gva)
> -		),
> +	),
>  
>  	TP_fast_assign(
>  		__entry->token = token;
>  		__entry->gva = gva;
> -		),
> +	),
> +
> +	TP_printk("token %#llx gva %#llx", __entry->token, __entry->gva)
>  
> -	TP_printk("token %#llx gva %#llx not present", __entry->token,
> -		  __entry->gva)
>  );
>  
> -TRACE_EVENT(
> -	kvm_async_pf_ready,
> +DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_not_present,
> +
>  	TP_PROTO(u64 token, u64 gva),
> -	TP_ARGS(token, gva),
>  
> -	TP_STRUCT__entry(
> -		__field(__u64, token)
> -		__field(__u64, gva)
> -		),
> +	TP_ARGS(token, gva)
> +);
>  
> -	TP_fast_assign(
> -		__entry->token = token;
> -		__entry->gva = gva;
> -		),
> +DEFINE_EVENT(kvm_async_pf_nopresent_ready, kvm_async_pf_ready,
> +
> +	TP_PROTO(u64 token, u64 gva),
>  
> -	TP_printk("token %#llx gva %#llx ready", __entry->token, __entry->gva)
> +	TP_ARGS(token, gva)
>  );
>  
>  TRACE_EVENT(
> @@ -262,24 +274,6 @@ TRACE_EVENT(
>  		  __entry->address, __entry->pfn)
>  );
>  
> -TRACE_EVENT(
> -	kvm_async_pf_doublefault,
> -	TP_PROTO(u64 gva, u64 gfn),
> -	TP_ARGS(gva, gfn),
> -
> -	TP_STRUCT__entry(
> -		__field(u64, gva)
> -		__field(u64, gfn)
> -		),
> -
> -	TP_fast_assign(
> -		__entry->gva = gva;
> -		__entry->gfn = gfn;
> -		),
> -
> -	TP_printk("gva = %#llx, gfn = %#llx", __entry->gva, __entry->gfn)
> -);
> -
>  #endif
>  
>  #endif /* _TRACE_KVM_MAIN_H */
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
