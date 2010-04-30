Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab0D3RYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:24:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758645Ab0D3RXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:23:49 -0400
Message-ID: <4BDAA85F.3020501@redhat.com>
Date: Fri, 30 Apr 2010 12:52:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM MMU: fix race in invlpg code
References: <4BDA9C37.9070602@cn.fujitsu.com>
In-Reply-To: <4BDA9C37.9070602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2010 12:00 PM, Xiao Guangrong wrote:
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
>   arch/x86/kvm/paging_tmpl.h |   18 +++++++++++++++++-
>   1 files changed, 17 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 624b38f..641d844 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -462,11 +462,15 @@ out_unlock:
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
>
>   	spin_lock(&vcpu->kvm->mmu_lock);
>
> @@ -519,10 +523,22 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
>
>   	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
>   	spin_lock(&vcpu->kvm->mmu_lock);
> +	index = kvm_page_table_hashfn(gfn);
> +	bucket =&vcpu->kvm->arch.mmu_page_hash[index];
> +	hlist_for_each_entry_safe(s, node, tmp, bucket, hash_link)
> +		if (s == sp) {
>    

At this point, sp might have been freed and re-allocated, now pointing 
at something completely different.  So need to check role etc.

Alternatively, increase root_count.  Then sp is guaranteed to be live 
(though it may have role.invalid set).

> +			live = true;
> +			break;
> +		}
> +
> +	if (!live)
> +		goto unlock_exit;
> +
>   	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter) {
>   		++vcpu->kvm->stat.mmu_pte_updated;
>   		FNAME(update_pte)(vcpu, sp, sptep,&gentry);
>   	}
> +unlock_exit:
>   	spin_unlock(&vcpu->kvm->mmu_lock);
>   	mmu_release_page_from_pte_write(vcpu);
>   }
>    


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

