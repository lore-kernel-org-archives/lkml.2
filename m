Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1EKPoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:44:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55119 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1EKPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:09 -0400
Message-ID: <4DCA7A9B.6060305@cn.fujitsu.com>
Date: Wed, 11 May 2011 20:01:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: MMU: optimize pte write path if don't have protected
 sp
References: <4DC9F803.3050602@cn.fujitsu.com> <4DCA72C3.6050300@redhat.com>
In-Reply-To: <4DCA72C3.6050300@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-11 19:59:57,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-11 19:59:57,
	Serialize complete at 2011-05-11 19:59:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2011 07:28 PM, Avi Kivity wrote:
> On 05/11/2011 05:44 AM, Xiao Guangrong wrote:
>> Simply return from kvm_mmu_pte_write path if no shadow page is
>> write-protected, then we can avoid to walk all shadow pages and hold
>> mmu-lock
>>
>> @@ -1038,8 +1038,10 @@ static void kvm_mmu_free_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>>       hlist_del(&sp->hash_link);
>>       list_del(&sp->link);
>>       free_page((unsigned long)sp->spt);
>> -    if (!sp->role.direct)
>> +    if (!sp->role.direct) {
>>           free_page((unsigned long)sp->gfns);
>> +        atomic_dec(&kvm->arch.indirect_shadow_pages);
>> +    }
>>       kmem_cache_free(mmu_page_header_cache, sp);
>>       kvm_mod_used_mmu_pages(kvm, -1);
>>   }
>> @@ -1536,6 +1538,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>>               kvm_sync_pages(vcpu, gfn);
>>
>>           account_shadowed(vcpu->kvm, gfn);
>> +        atomic_inc(&vcpu->kvm->arch.indirect_shadow_pages);
>>       }
> 
> Better in account_shadowed()/unaccount_shadowed(), no?
> 

Yes, will fix. thanks for your reminder!

