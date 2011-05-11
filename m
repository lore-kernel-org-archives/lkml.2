Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab1EKQRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335Ab1EKQRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:17:07 -0400
Message-ID: <4DCA72C3.6050300@redhat.com>
Date: Wed, 11 May 2011 14:28:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: MMU: optimize pte write path if don't have protected
 sp
References: <4DC9F803.3050602@cn.fujitsu.com>
In-Reply-To: <4DC9F803.3050602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 05:44 AM, Xiao Guangrong wrote:
> Simply return from kvm_mmu_pte_write path if no shadow page is
> write-protected, then we can avoid to walk all shadow pages and hold
> mmu-lock
>
> @@ -1038,8 +1038,10 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>   	hlist_del(&sp->hash_link);
>   	list_del(&sp->link);
>   	free_page((unsigned long)sp->spt);
> -	if (!sp->role.direct)
> +	if (!sp->role.direct) {
>   		free_page((unsigned long)sp->gfns);
> +		atomic_dec(&kvm->arch.indirect_shadow_pages);
> +	}
>   	kmem_cache_free(mmu_page_header_cache, sp);
>   	kvm_mod_used_mmu_pages(kvm, -1);
>   }
> @@ -1536,6 +1538,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   			kvm_sync_pages(vcpu, gfn);
>
>   		account_shadowed(vcpu->kvm, gfn);
> +		atomic_inc(&vcpu->kvm->arch.indirect_shadow_pages);
>   	}

Better in account_shadowed()/unaccount_shadowed(), no?


-- 
error compiling committee.c: too many arguments to function

