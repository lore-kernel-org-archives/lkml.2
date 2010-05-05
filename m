Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934634Ab0EEMbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:31:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab0EEMbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:31:10 -0400
Message-ID: <4BE1650B.7080809@redhat.com>
Date: Wed, 05 May 2010 15:31:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM MMU: fix race in invlpg code
References: <4BE16265.7060004@cn.fujitsu.com> <4BE162B9.201@cn.fujitsu.com>
In-Reply-To: <4BE162B9.201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 03:21 PM, Xiao Guangrong wrote:
> It has race in invlpg code, like below sequences:
>
> A: hold mmu_lock and get 'sp'
> B: release mmu_lock and do other things
> C: hold mmu_lock and continue use 'sp'
>
> if other path freed 'sp' in stage B, then kernel will crash
>
> This patch checks 'sp' whether lived before use 'sp' in stage C
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/paging_tmpl.h |   22 ++++++++++++++++++++--
>   1 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 624b38f..13ea675 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -462,11 +462,16 @@ out_unlock:
>
>   static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>   {
> -	struct kvm_mmu_page *sp = NULL;
> +	struct kvm_mmu_page *sp = NULL, *s;
>   	struct kvm_shadow_walk_iterator iterator;
> +	struct hlist_head *bucket;
> +	struct hlist_node *node, *tmp;
>   	gfn_t gfn = -1;
>   	u64 *sptep = NULL, gentry;
>   	int invlpg_counter, level, offset = 0, need_flush = 0;
> +	unsigned index;
> +	bool live = false;
> +	union kvm_mmu_page_role role;
>
>   	spin_lock(&vcpu->kvm->mmu_lock);
>
> @@ -480,7 +485,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>
>   			if (!sp->unsync)
>   				break;
> -
> +			role = sp->role;
>   			WARN_ON(level != PT_PAGE_TABLE_LEVEL);
>   			shift = PAGE_SHIFT -
>   				  (PT_LEVEL_BITS - PT64_LEVEL_BITS) * level;
> @@ -519,10 +524,23 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>
>   	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
>   	spin_lock(&vcpu->kvm->mmu_lock);
> +	index = kvm_page_table_hashfn(gfn);
> +	bucket =&vcpu->kvm->arch.mmu_page_hash[index];
> +	hlist_for_each_entry_safe(s, node, tmp, bucket, hash_link)
> +		if (s == sp) {
> +			if (s->gfn == gfn&&  s->role.word == role.word)
> +				live = true;
> +			break;
> +		}
> +
> +	if (!live)
> +		goto unlock_exit;
> +
>    

Did you try the root_count method?  I think it's cleaner.

-- 
error compiling committee.c: too many arguments to function

