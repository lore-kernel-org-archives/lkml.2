Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0GLNPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:15:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab0GLNPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:15:04 -0400
Message-ID: <4C3B1554.7000005@redhat.com>
Date: Mon, 12 Jul 2010 16:15:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/9] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C330918.6040709@cn.fujitsu.com> <4C39B81A.5080000@redhat.com> <4C3A7FEA.6030205@cn.fujitsu.com>
In-Reply-To: <4C3A7FEA.6030205@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 05:37 AM, Xiao Guangrong wrote:
>    
>>> +    if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
>>> +        gentry = 0;
>>> +
>>>
>>>        
>> That only works if the gpte is for the same mode as the current vcpu mmu
>> mode.  In some cases it is too strict (vcpu in pae mode writing a 32-bit
>> gpte), which is not too bad, in some cases it is too permissive (vcpu in
>> nonpae mode writing a pae gpte).
>>
>>      
> Avi, thanks for your review.
>
> Do you mean that the VM has many different mode vcpu? For example, both
> nonpae vcpu and pae vcpu are running in one VM? I forgot to consider this
> case.
>    

Yes.  This happens while the guest brings up other vcpus, and when using 
nested virtualization.

>> (once upon a time mixed modes were rare, only on OS setup, but with
>> nested virt they happen all the time).
>>      
> I'm afraid it's still has problem, it will cause access corruption:
> 1: if nonpae vcpu write pae gpte, it will miss NX bit
> 2: if pae vcpu write nonpae gpte, it will add NX bit that over gpte's width
>
> How about only update the shadow page which has the same pae set with the written
> vcpu? Just like this:
>
> @@ -3000,6 +3000,10 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>                  while (npte--) {
>                          entry = *spte;
>                          mmu_pte_write_zap_pte(vcpu, sp, spte);
> +
> +                       if (!!is_pae(vcpu) != sp->role.cr4_pae)
> +                               continue;
> +
>    

Not enough, one vcpu can have nx set while the other has it reset, etc.

-- 
error compiling committee.c: too many arguments to function

