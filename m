Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1G0KSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:18:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58943 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab1G0KSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:18:38 -0400
Message-ID: <4E2FE674.8070202@cn.fujitsu.com>
Date: Wed, 27 Jul 2011 18:20:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
References: <4E2EA3DB.7040403@cn.fujitsu.com> <4E2EA5D2.8040804@cn.fujitsu.com> <4E2FD8F7.40303@redhat.com>
In-Reply-To: <4E2FD8F7.40303@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:17:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-27 18:17:41,
	Serialize complete at 2011-07-27 18:17:41
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 05:23 PM, Avi Kivity wrote:
> On 07/26/2011 02:32 PM, Xiao Guangrong wrote:
>> Detecting write-flooding does not work well, when we handle page written, if
>> the last speculative spte is not accessed, we treat the page is
>> write-flooding, however, we can speculative spte on many path, such as pte
>> prefetch, page synced, that means the last speculative spte may be not point
>> to the written page and the written page can be accessed via other sptes, so
>> depends on the Accessed bit of the last speculative spte is not enough
>>
>> Instead of detected page accessed, we can detect whether the spte is accessed
>> or not, if the spte is not accessed but it is written frequently, we treat is
>> not a page table or it not used for a long time
>>
>>   static int get_free_pte_list_desc_nr(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm_mmu_memory_cache *cache;
>> @@ -3565,22 +3547,14 @@ static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
>>    * If we're seeing too many writes to a page, it may no longer be a page table,
>>    * or we may be forking, in which case it is better to unmap the page.
>>    */
>> -static bool detect_write_flooding(struct kvm_vcpu *vcpu, gfn_t gfn)
>> +static bool detect_write_flooding(struct kvm_mmu_page *sp, u64 *spte)
>>   {
>> -    bool flooded = false;
>> -
>> -    if (gfn == vcpu->arch.last_pt_write_gfn
>> -    &&  !last_updated_pte_accessed(vcpu)) {
>> -        ++vcpu->arch.last_pt_write_count;
>> -        if (vcpu->arch.last_pt_write_count>= 3)
>> -            flooded = true;
>> -    } else {
>> -        vcpu->arch.last_pt_write_gfn = gfn;
>> -        vcpu->arch.last_pt_write_count = 1;
>> -        vcpu->arch.last_pte_updated = NULL;
>> -    }
>> +    if (spte&&  !(*spte&  shadow_accessed_mask))
>> +        sp->write_flooding_count++;
>> +    else
>> +        sp->write_flooding_count = 0;
>>
>> -    return flooded;
>> +    return sp->write_flooding_count>= 3;
>>   }
> 
> I think this is a little dangerous.  A guest kernel may be instantiating multiple gptes on a page fault, but guest userspace hits only one of them (the one which caused the page fault) - I think Windows does this, but I'm not sure.
> 

I think this case is not bad: if the guest kernel need to write multiple gptes (>=3),
it will cause many page fault, we do better zap the shadow page and let it become writable as
soon as possible.
(And, we have pte-fetch, it can quickly establish the mapping for a new shadow page)

