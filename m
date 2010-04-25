Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0DYJ5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab0DYJ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:57:31 -0400
Message-ID: <4BD411F6.6030800@redhat.com>
Date: Sun, 25 Apr 2010 12:57:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 9/10] KVM MMU: separate invlpg code form kvm_mmu_pte_write()
References: <4BD3E306.4020202@cn.fujitsu.com> <4BD3E8EB.1010006@cn.fujitsu.com>
In-Reply-To: <4BD3E8EB.1010006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 10:02 AM, Xiao Guangrong wrote:
> Let invlpg not depends on kvm_mmu_pte_write path, later patch will need
> this feature
>
>
>   	if (mmu_topup_memory_caches(vcpu))
>   		return;
> -	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
> +
> +	kvm_read_guest_page(vcpu->kvm, gfn,&gentry, offset,
> +				sizeof(pt_element_t));
> +
>    

Need error check.

> +	mmu_guess_page_from_pte_write(vcpu, gfn_to_gpa(gfn) + offset, gentry);
>    

This needs an undo operation to drop the page if we don't update_pte(); 
see the end of kvm_mmu_pte_write().  That needs to go into a helper to 
avoid duplication.

> +	spin_lock(&vcpu->kvm->mmu_lock);
> +	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) == invlpg_counter&&
> +		sp->role.level == PT_PAGE_TABLE_LEVEL) {
> +		++vcpu->kvm->stat.mmu_pte_updated;
> +		FNAME(update_pte)(vcpu, sp, sptep,&gentry);
> +	}
> +
> +	spin_unlock(&vcpu->kvm->mmu_lock);
>   }
>
>   static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
>    


-- 
error compiling committee.c: too many arguments to function

