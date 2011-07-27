Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1G0JXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1G0JXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:23:09 -0400
Message-ID: <4E2FD8F7.40303@redhat.com>
Date: Wed, 27 Jul 2011 12:23:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA5D2.8040804@cn.fujitsu.com>
In-Reply-To: <4E2EA5D2.8040804@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 02:32 PM, Xiao Guangrong wrote:
> Detecting write-flooding does not work well, when we handle page written, if
> the last speculative spte is not accessed, we treat the page is
> write-flooding, however, we can speculative spte on many path, such as pte
> prefetch, page synced, that means the last speculative spte may be not point
> to the written page and the written page can be accessed via other sptes, so
> depends on the Accessed bit of the last speculative spte is not enough
>
> Instead of detected page accessed, we can detect whether the spte is accessed
> or not, if the spte is not accessed but it is written frequently, we treat is
> not a page table or it not used for a long time
>
>   static int get_free_pte_list_desc_nr(struct kvm_vcpu *vcpu)
>   {
>   	struct kvm_mmu_memory_cache *cache;
> @@ -3565,22 +3547,14 @@ static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
>    * If we're seeing too many writes to a page, it may no longer be a page table,
>    * or we may be forking, in which case it is better to unmap the page.
>    */
> -static bool detect_write_flooding(struct kvm_vcpu *vcpu, gfn_t gfn)
> +static bool detect_write_flooding(struct kvm_mmu_page *sp, u64 *spte)
>   {
> -	bool flooded = false;
> -
> -	if (gfn == vcpu->arch.last_pt_write_gfn
> -	&&  !last_updated_pte_accessed(vcpu)) {
> -		++vcpu->arch.last_pt_write_count;
> -		if (vcpu->arch.last_pt_write_count>= 3)
> -			flooded = true;
> -	} else {
> -		vcpu->arch.last_pt_write_gfn = gfn;
> -		vcpu->arch.last_pt_write_count = 1;
> -		vcpu->arch.last_pte_updated = NULL;
> -	}
> +	if (spte&&  !(*spte&  shadow_accessed_mask))
> +		sp->write_flooding_count++;
> +	else
> +		sp->write_flooding_count = 0;
>
> -	return flooded;
> +	return sp->write_flooding_count>= 3;
>   }

I think this is a little dangerous.  A guest kernel may be instantiating 
multiple gptes on a page fault, but guest userspace hits only one of 
them (the one which caused the page fault) - I think Windows does this, 
but I'm not sure.

Maybe we should inspect parent_ptes instead?

-- 
error compiling committee.c: too many arguments to function

