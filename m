Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0EWNvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab0EWNvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:51:31 -0400
Message-ID: <4BF932DD.5070900@redhat.com>
Date: Sun, 23 May 2010 16:51:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: MMU: allow more page become unsync at gfn mapping
 time
References: <4BF91C34.6020904@cn.fujitsu.com>
In-Reply-To: <4BF91C34.6020904@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 03:14 PM, Xiao Guangrong wrote:
> In current code, shadow page can become asynchronous only if one
> shadow page for a gfn, this rule is too strict, in fact, we can
> let all last mapping page(i.e, it's the pte page) become unsync,
> and sync them at invlpg or flush tlb time.
>
> This patch allow more page become asynchronous at gfn mapping time
>
>
> +
> +static void kvm_unsync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>   {
> -	unsigned index;
>   	struct hlist_head *bucket;
>   	struct kvm_mmu_page *s;
>   	struct hlist_node *node, *n;
> +	unsigned index;
>
> -	index = kvm_page_table_hashfn(sp->gfn);
> +	index = kvm_page_table_hashfn(gfn);
>   	bucket =&vcpu->kvm->arch.mmu_page_hash[index];
> -	/* don't unsync if pagetable is shadowed with multiple roles */
> +
>   	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
> -		if (s->gfn != sp->gfn || s->role.direct)
> +		if (s->gfn != gfn || s->role.direct || s->unsync)
>   			continue;
>    

role.invalid?

> -		if (s->role.word != sp->role.word)
> -			return 1;
> +		WARN_ON(s->role.level != PT_PAGE_TABLE_LEVEL);
> +		__kvm_unsync_page(vcpu, s);
>   	}
> -	trace_kvm_mmu_unsync_page(sp);
> -	++vcpu->kvm->stat.mmu_unsync;
> -	sp->unsync = 1;
> -
> -	kvm_mmu_mark_parents_unsync(sp);
> -
> -	mmu_convert_notrap(sp);
> -	return 0;
>   }
>
>   static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>   				  bool can_unsync)
>   {
> -	struct kvm_mmu_page *shadow;
> +	unsigned index;
> +	struct hlist_head *bucket;
> +	struct kvm_mmu_page *s;
> +	struct hlist_node *node, *n;
> +	bool need_unsync = false;
> +
> +	index = kvm_page_table_hashfn(gfn);
> +	bucket =&vcpu->kvm->arch.mmu_page_hash[index];
> +	hlist_for_each_entry_safe(s, node, n, bucket, hash_link) {
> +		if (s->gfn != gfn || s->role.direct)
> +			continue;
>
> -	shadow = kvm_mmu_lookup_page(vcpu->kvm, gfn);
> -	if (shadow) {
> -		if (shadow->role.level != PT_PAGE_TABLE_LEVEL)
> +		if (s->role.level != PT_PAGE_TABLE_LEVEL)
>   			return 1;
>    

role.invalid?

> -		if (shadow->unsync)
> -			return 0;
> -		if (can_unsync&&  oos_shadow)
> -			return kvm_unsync_page(vcpu, shadow);
> -		return 1;
> +
> +		if (!need_unsync&&  !s->unsync) {
> +			if (!can_unsync || !oos_shadow)
> +				return 1;
> +			need_unsync = true;
> +		}
>   	}
> +	if (need_unsync)
> +		kvm_unsync_pages(vcpu, gfn);
>   	return 0;
>   }
>
>    

Looks good, I'm just uncertain about role.invalid handling.  What's the 
reasoning here?

-- 
error compiling committee.c: too many arguments to function

