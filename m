Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1CJKWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:22:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1CJKWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:22:02 -0500
Message-ID: <4D78A642.8020708@redhat.com>
Date: Thu, 10 Mar 2011 12:21:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] KVM: MMU: cleanup pte write path
References: <4D772F10.3020302@cn.fujitsu.com> <4D772FB7.8060007@cn.fujitsu.com>
In-Reply-To: <4D772FB7.8060007@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 09:43 AM, Xiao Guangrong wrote:
> This patch does:
> - call vcpu->arch.mmu.update_pte directly
> - use gfn_to_pfn_atomic in update_pte path
>
> The suggestion is from Avi.
>
>
>
> -	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
> +	mmu_seq = vcpu->kvm->mmu_notifier_seq;
> +	smp_rmb();

smp_rmb() should come before, no? but the problem was present in the 
original code, too.

> +
>   	spin_lock(&vcpu->kvm->mmu_lock);
>   	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
>   		gentry = 0;
> @@ -3365,7 +3345,8 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   			if (gentry&&
>   			!((sp->role.word ^ vcpu->arch.mmu.base_role.word)
>   			&  mask.word))
> -				mmu_pte_write_new_pte(vcpu, sp, spte,&gentry);
> +				mmu_pte_write_new_pte(vcpu, sp, spte,&gentry,
> +						      mmu_seq);

Okay, we're only iterating over indirect pages, so we won't call 
nonpaging_update_pte().

-- 
error compiling committee.c: too many arguments to function

