Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab2HWMC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:02:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab2HWMC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:02:27 -0400
Date: Thu, 23 Aug 2012 06:24:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: trace the events of mmu_notifier
Message-ID: <20120823092405.GB32710@amt.cnet>
References: <50335A27.2070306@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50335A27.2070306@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 05:51:35PM +0800, Xiao Guangrong wrote:
> mmu_notifier is the interface to broadcast the mm events to KVM, the
> tracepoints introduced in this patch can trace all these events, it is
> very helpful for us to notice and fix the bug caused by mm
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  include/trace/events/kvm.h |  121 ++++++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c        |   19 +++++++
>  2 files changed, 140 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 7ef9e75..a855ff9 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -309,6 +309,127 @@ TRACE_EVENT(
> 
>  #endif
> 
> +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> +DECLARE_EVENT_CLASS(mmu_notifier_address_class,
> +
> +	TP_PROTO(struct kvm *kvm, unsigned long address),
> +
> +	TP_ARGS(kvm, address),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm *, kvm)
> +		__field(unsigned long, address)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->kvm = kvm;
> +		__entry->address = address;
> +	),
> +
> +	TP_printk("kvm %p address %lx", __entry->kvm, __entry->address)


Perhaps the pointer was useful for debugging, but otherwise, i don't
think it should be printed.

> +	TP_ARGS(kvm, address, pte),
> +
> +	TP_STRUCT__entry(
> +		__field(struct kvm *, kvm)
> +		__field(unsigned long, address)
> +		__field(unsigned long, pte)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->kvm = kvm;
> +		__entry->address = address;
> +		__entry->pte = pte.pte;
> +	),
> +
> +	TP_printk("kvm %p address %lx pte %lx", __entry->kvm, __entry->address,
> +		  __entry->pte)

The pte bits can be spelled out? (see __print_symbolic).

>  	spin_lock(&kvm->mmu_lock);
> 
> +	trace_kvm_mmu_notifier_clear_flush_young(kvm, address);
> +
>  	young = kvm_age_hva(kvm, address);
>  	if (young)
>  		kvm_flush_remote_tlbs(kvm);
> @@ -394,6 +407,9 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
> 
>  	idx = srcu_read_lock(&kvm->srcu);
>  	spin_lock(&kvm->mmu_lock);
> +
> +	trace_kvm_mmu_notifier_test_young(kvm, address);
> +

can print young information?

>  	young = kvm_test_age_hva(kvm, address);
>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, idx);
> @@ -408,6 +424,9 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>  	int idx;
> 
>  	idx = srcu_read_lock(&kvm->srcu);
> +
> +	trace_kvm_mmu_notifier_release(kvm);
> +
>  	kvm_arch_flush_shadow(kvm);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }


