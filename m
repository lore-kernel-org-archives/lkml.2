Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab0ITPUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0ITPUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:20:10 -0400
Message-ID: <4C977B9E.6030208@redhat.com>
Date: Mon, 20 Sep 2010 17:19:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: MMU: support unsync sp out of the protection
 of 'mmu_lock'
References: <4C976D48.6020400@cn.fujitsu.com> <4C976D7C.7090707@cn.fujitsu.com>
In-Reply-To: <4C976D7C.7090707@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/20/2010 04:19 PM, Xiao Guangrong wrote:
> It allows keep unsync sp alive while it's out of the protection, later we can use
> kvm_mmu_free_page() to free it if !sp->active_count

Don't understand.  Of course unsync pages exist outside mmu_lock...?


>   
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 839852d..4b7af3f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -996,7 +996,6 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
>   	ASSERT(is_empty_shadow_page(sp->spt));
>   	hlist_del(&sp->hash_link);
> -	list_del(&sp->link);
>   	__free_page(virt_to_page(sp->spt));
>   	if (!sp->role.direct)
>   		__free_page(virt_to_page(sp->gfns));
> @@ -1681,9 +1680,8 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>   	kvm_mmu_unlink_parents(kvm, sp);
>   	if (!sp->role.invalid&&  !sp->role.direct)
>   		unaccount_shadowed(kvm, sp->gfn);
> -	if (sp->unsync)
> -		kvm_unlink_unsync_page(kvm, sp);
> -	if (!sp->active_count) {
> +
> +	if (!sp->active_count || sp->unsync) {
>   		/* Count self */
>   		ret++;
>   		list_move(&sp->link, invalid_list);

How can you drop an active unsync page?

I'm missing something here.

> @@ -1692,6 +1690,8 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>   		kvm_reload_remote_mmus(kvm);
>   	}
>
> +	if (sp->unsync)
> +		kvm_unlink_unsync_page(kvm, sp);
>   	sp->role.invalid = 1;
>   	kvm_mmu_reset_last_pte_updated(kvm);
>   	return ret;
> @@ -1709,8 +1709,12 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>
>   	do {
>   		sp = list_first_entry(invalid_list, struct kvm_mmu_page, link);
> -		WARN_ON(!sp->role.invalid || sp->active_count);
> -		kvm_mmu_free_page(kvm, sp);
> +		WARN_ON(!sp->role.invalid);
> +		list_del(&sp->link);
> +		if (sp->active_count)
> +			WARN_ON(!sp->unsync);
> +		else
> +			kvm_mmu_free_page(kvm, sp);
>   	} while (!list_empty(invalid_list));
>
>   }


-- 
error compiling committee.c: too many arguments to function

