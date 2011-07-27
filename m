Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1G0JAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab1G0JAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:00:40 -0400
Message-ID: <4E2FD3AC.1000701@redhat.com>
Date: Wed, 27 Jul 2011 12:00:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 01/11] KVM: MMU: avoid pte_list_desc run out in kvm_mmu_pte_write
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA41A.3080606@cn.fujitsu.com>
In-Reply-To: <4E2EA41A.3080606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 02:25 PM, Xiao Guangrong wrote:
> kvm_mmu_pte_write is unsafe since we need to alloc pte_list_desc in the
> function when spte is prefetched, unfortunately, we can not know how many
> spte need to be prefetched on this path, that means we can use out of the
> free  pte_list_desc object in the cache, and BUG_ON() is triggered, also some
> path does not fill the cache, such as INS instruction emulated that does not
> trigger page fault
>
>
>   void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		       const u8 *new, int bytes,
>   		       bool guest_initiated)
> @@ -3583,6 +3596,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		break;
>   	}
>
> +	mmu_topup_memory_caches(vcpu);

Please add a comment here describing why it's okay to ignore the error 
return.

>   	spin_lock(&vcpu->kvm->mmu_lock);
>   	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
>   		gentry = 0;
> @@ -3653,7 +3667,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   			mmu_page_zap_pte(vcpu->kvm, sp, spte);
>   			if (gentry&&
>   			!((sp->role.word ^ vcpu->arch.mmu.base_role.word)
> -			&  mask.word))
> +			&  mask.word)&&  get_free_pte_list_desc_nr(vcpu))
>   				mmu_pte_write_new_pte(vcpu, sp, spte,&gentry);

Wow, this bug was here since 2.6.23.  Good catch.

Please wrap or rename get_free_pte_list_desc_nr() in rmap_can_add(vcpu) 
so it's clearer why we're doing this.


-- 
error compiling committee.c: too many arguments to function

