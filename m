Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0E3NQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 09:16:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0E3NQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 09:16:55 -0400
Message-ID: <4C026543.20608@redhat.com>
Date: Sun, 30 May 2010 16:16:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: split the operations of kvm_mmu_zap_page()
References: <4C025BDC.1020304@cn.fujitsu.com> <4C025C24.9010200@cn.fujitsu.com>
In-Reply-To: <4C025C24.9010200@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2010 03:37 PM, Xiao Guangrong wrote:
> Using kvm_mmu_prepare_zap_page() and kvm_mmu_commit_zap_page() to
> split kvm_mmu_zap_page() function, then we can:
>
> - traverse hlist safely
> - easily to gather remote tlb flush which occurs during page zapped
>
>
> +static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +	int ret;
> +
> +	trace_kvm_mmu_zap_page(sp);
> +	++kvm->stat.mmu_shadow_zapped;
> +	ret = mmu_zap_unsync_children(kvm, sp);
> +	kvm_mmu_page_unlink_children(kvm, sp);
> +	kvm_mmu_unlink_parents(kvm, sp);
> +	if (!sp->role.invalid&&  !sp->role.direct)
> +		unaccount_shadowed(kvm, sp->gfn);
> +	if (sp->unsync)
> +		kvm_unlink_unsync_page(kvm, sp);
> +	if (!sp->root_count)
> +		/* Count self */
> +		ret++;
> +	else
> +		kvm_reload_remote_mmus(kvm);
> +
> +	sp->role.invalid = 1;
> +	list_move(&sp->link,&kvm->arch.invalid_mmu_pages);
> +	kvm_mmu_reset_last_pte_updated(kvm);
> +	return ret;
> +}
> +
> +static void kvm_mmu_commit_zap_page(struct kvm *kvm)
> +{
> +	struct kvm_mmu_page *sp, *n;
> +
> +	if (list_empty(&kvm->arch.invalid_mmu_pages))
> +		return;
> +
> +	kvm_flush_remote_tlbs(kvm);
> +	list_for_each_entry_safe(sp, n,&kvm->arch.invalid_mmu_pages, link) {
> +		WARN_ON(!sp->role.invalid);
> +		if (!sp->root_count)
> +			kvm_mmu_free_page(kvm, sp);
> +	}
> +}
> +
>    

You're adding two new functions but not using them here?  Possibly in 
the old kvm_mmu_zap_page()?

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5e5cd8d..225c3c4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5331,6 +5331,7 @@ struct  kvm *kvm_arch_create_vm(void)
>   	}
>
>   	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> +	INIT_LIST_HEAD(&kvm->arch.invalid_mmu_pages);
>   	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
>    

This is a good idea, but belongs in a separate patch?  We can use it to 
reclaim invalid pages before allocating new ones.

-- 
error compiling committee.c: too many arguments to function

