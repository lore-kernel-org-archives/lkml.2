Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab0DLJIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:08:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0DLJIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:08:24 -0400
Message-ID: <4BC2E2FF.9020005@redhat.com>
Date: Mon, 12 Apr 2010 12:08:15 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <4BC2D8D6.6030306@redhat.com> <4BC2DFA0.6000609@cn.fujitsu.com>
In-Reply-To: <4BC2DFA0.6000609@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 11:53 AM, Xiao Guangrong wrote:
>>
>>>            kvm->arch.n_free_mmu_pages = 0;
>>> @@ -1589,7 +1589,8 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t
>>> gfn)
>>>            &&   !sp->role.invalid) {
>>>                pgprintk("%s: zap %lx %x\n",
>>>                     __func__, gfn, sp->role.word);
>>> -            kvm_mmu_zap_page(kvm, sp);
>>> +            if (kvm_mmu_zap_page(kvm, sp))
>>> +                nn = bucket->first;
>>>            }
>>>        }
>>>
>>>        
>> I don't understand why this is needed.
>>      
> There is the code segment in mmu_unshadow():
>
> |hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
> |		if (sp->gfn == gfn&&  !sp->role.direct
> |		&&  !sp->role.invalid) {
> |			pgprintk("%s: zap %lx %x\n",
> |				 __func__, gfn, sp->role.word);
> |			kvm_mmu_zap_page(kvm, sp);
> |		}
> |	}
>
> in the loop, if nn is zapped, hlist_for_each_entry_safe() access nn will
> cause crash. and it's checked in other functions, such as kvm_mmu_zap_all(),
> kvm_mmu_unprotect_page()...
>    

hlist_for_each_entry_safe() is supposed to be be safe against removal of 
the element that is pointed to by the iteration cursor.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

