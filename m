Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DLInO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:43:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651Ab0DLInN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:43:13 -0400
Message-ID: <4BC2DD1B.1030903@redhat.com>
Date: Mon, 12 Apr 2010 11:43:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] KVM MMU: optimize synchronization shadow pages
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D481.9060101@cn.fujitsu.com>
In-Reply-To: <4BC2D481.9060101@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 11:06 AM, Xiao Guangrong wrote:
> - chain all unsync shadow pages then we can fetch them quickly
> - flush local/remote tlb after all shadow page synced
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/include/asm/kvm_host.h |    1 +
>   arch/x86/kvm/mmu.c              |   82 ++++++++++++++++++---------------------
>   2 files changed, 39 insertions(+), 44 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d463bc6..ae543fb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -207,6 +207,7 @@ struct kvm_mmu_page {
>   	#define MMU_PAGE_UNSYNC 0x2
>   	unsigned int flags;
>   	unsigned int unsync_children;
> +	struct list_head unsync_link;
>   	union {
>   		u64 *parent_pte;               /* !multimapped */
>   		struct hlist_head parent_ptes; /* multimapped, kvm_pte_chain */
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 18eceb2..fcb6299 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -177,6 +177,8 @@ typedef int (*mmu_parent_walk_fn) (struct kvm_mmu_page *sp, u64 *spte);
>   static struct kmem_cache *pte_chain_cache;
>   static struct kmem_cache *rmap_desc_cache;
>   static struct kmem_cache *mmu_page_header_cache;
> +static struct list_head unsync_mmu_page_list =
> +			LIST_HEAD_INIT(unsync_mmu_page_list);
>
>    

Does this really need to be global?  Should be per guest.

>   static u64 __read_mostly shadow_trap_nonpresent_pte;
>   static u64 __read_mostly shadow_notrap_nonpresent_pte;
> @@ -950,6 +952,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
>   	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
>   	sp->flags = 0;
>   	sp->parent_pte = parent_pte;
> +	INIT_LIST_HEAD(&sp->unsync_link);
>   	--vcpu->kvm->arch.n_free_mmu_pages;
>   	return sp;
>   }
> @@ -1200,12 +1203,14 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>   {
>   	WARN_ON(!mmu_page_is_unsync(sp));
>   	mmu_page_clear_unsync(sp);
> +	list_del(&sp->unsync_link);
>   	--kvm->stat.mmu_unsync;
>   }
>    

Locking?

> -		if (protected)
> -			kvm_flush_remote_tlbs(vcpu->kvm);
> +	if (list_empty(&unsync_mmu_page_list))
> +		return;
>    

Will this ever happen?  In my experience we usually have a ton of 
unsyncs lying around.

> +	list_for_each_safe(p, next,&unsync_mmu_page_list) {
> +		struct kvm_mmu_page *sp;
> +		sp = list_entry(p, struct kvm_mmu_page, unsync_link);
> +		__kvm_sync_page(vcpu, sp,&flush_local_tlb,&flush_remote_tlb);
>   	}
>    

That's counter to the point of unsync.  We only want to sync the minimum 
number of pages - all pages reachable by the new root.  The others we 
want to keep writeable to reduce our fault count.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

