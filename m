Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1GFTKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:10:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab1GFTKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:10:35 -0400
Message-ID: <4E14B39A.5020401@cn.fujitsu.com>
Date: Thu, 07 Jul 2011 03:12:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/19] KVM: MMU: optimize to handle dirty bit
References: <4E0C3178.2080603@cn.fujitsu.com> <4E0C320A.8080104@cn.fujitsu.com> <20110705192703.GB24417@amt.cnet> <4E13B8D4.3050704@cn.fujitsu.com> <20110706165134.GC24417@amt.cnet>
In-Reply-To: <20110706165134.GC24417@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:09:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-07 03:09:52,
	Serialize complete at 2011-07-07 03:09:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2011 12:51 AM, Marcelo Tosatti wrote:
> On Wed, Jul 06, 2011 at 09:22:28AM +0800, Xiao Guangrong wrote:
>> On 07/06/2011 03:27 AM, Marcelo Tosatti wrote:
>>> On Thu, Jun 30, 2011 at 04:21:30PM +0800, Xiao Guangrong wrote:
>>>> If dirty bit is not set, we can make the pte access read-only to avoid handing
>>>> dirty bit everywhere
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>>
>>>> -static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
>>>> +static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte,
>>>> +				   bool last)
>>>>  {
>>>>  	unsigned access;
>>>>  
>>>>  	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
>>>> +	if (last && !is_dirty_gpte(gpte))
>>>> +		access &= ~ACC_WRITE_MASK;
>>>> +
>>>
>>> What if the walker marks the dirty bit on the gpte?
>>>
>>
>> Actually, we get guest pte access after mark the dirty bit:
>>
>> 	if (write_fault && unlikely(!is_dirty_gpte(pte))) {
>> 		int ret;
>>
>> 		trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
>> 		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index,
>> 					  pte, pte|PT_DIRTY_MASK);
>> 		if (unlikely(ret < 0)) {
>> 			present = false;
>> 			goto error;
>> 		} else if (ret)
>> 			goto walk;
>>
>> 		mark_page_dirty(vcpu->kvm, table_gfn);
>> 		pte |= PT_DIRTY_MASK;
>> 		walker->ptes[walker->level - 1] = pte;
>> 	}
>>
>> 	pte_access = pt_access & FNAME(gpte_access)(vcpu, pte, true);
>>  
>> So, i think it works well :-)
> 
> I think you meant after marking the accessed bit. The dirty bit is set
> just before returning.
> 

In this patch, i moved getting pte_access to the behind of setting dirty bit set
