Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1FJDse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:48:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56840 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab1FJDs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:48:28 -0400
Message-ID: <4DF19484.8000707@cn.fujitsu.com>
Date: Fri, 10 Jun 2011 11:50:28 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 09/15] KVM: MMU: split kvm_mmu_free_page
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE21AE.9050703@cn.fujitsu.com> <4DF0712B.5050400@redhat.com>
In-Reply-To: <4DF0712B.5050400@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 11:48:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-10 11:48:13,
	Serialize complete at 2011-06-10 11:48:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 03:07 PM, Avi Kivity wrote:
> On 06/07/2011 04:03 PM, Xiao Guangrong wrote:
>> Split kvm_mmu_free_page to kvm_mmu_free_lock_parts and
>> kvm_mmu_free_unlock_parts
>>
>> One is used to free the parts which is under mmu lock and the other is
>> used to free the parts which can allow be freed out of mmu lock
>>
>> It is used by later patch
> 
> Suggest kvm_mmu_isolate_page() and kvm_mmu_free_page().  Plus a comment explaining things, unless someone can come up with a better name.
> 

Good names, will fix.

>> -static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>> +static void kvm_mmu_free_lock_parts(struct kvm_mmu_page *sp)
>>   {
>>       ASSERT(is_empty_shadow_page(sp->spt));
>>       hlist_del(&sp->hash_link);
>> -    list_del(&sp->link);
>> -    free_page((unsigned long)sp->spt);
>>       if (!sp->role.direct)
>>           free_page((unsigned long)sp->gfns);
>> +}
>> +
>> +static void kvm_mmu_free_unlock_parts(struct kvm_mmu_page *sp)
>> +{
>> +    list_del(&sp->link);
>> +    free_page((unsigned long)sp->spt);
>>       kmem_cache_free(mmu_page_header_cache, sp);
>>   }
> 
> The list_del() must be run under a lock, no? it can access kvm->arch.active_mmu_pages.
> 

In prepare path, we have moved the sp from active_mmu_pages to invlaid_list.
