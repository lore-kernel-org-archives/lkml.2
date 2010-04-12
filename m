Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0DLI43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:56:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53422 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab0DLI42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:56:28 -0400
Message-ID: <4BC2DFA0.6000609@cn.fujitsu.com>
Date: Mon, 12 Apr 2010 16:53:52 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] KVM MMU: fix kvm_mmu_zap_page() and its calling path
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D345.100@cn.fujitsu.com> <4BC2D8D6.6030306@redhat.com>
In-Reply-To: <4BC2D8D6.6030306@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

> 
>>           kvm->arch.n_free_mmu_pages = 0;
>> @@ -1589,7 +1589,8 @@ static void mmu_unshadow(struct kvm *kvm, gfn_t
>> gfn)
>>           &&  !sp->role.invalid) {
>>               pgprintk("%s: zap %lx %x\n",
>>                    __func__, gfn, sp->role.word);
>> -            kvm_mmu_zap_page(kvm, sp);
>> +            if (kvm_mmu_zap_page(kvm, sp))
>> +                nn = bucket->first;
>>           }
>>       }
>>    
> 
> I don't understand why this is needed.

There is the code segment in mmu_unshadow():

|hlist_for_each_entry_safe(sp, node, nn, bucket, hash_link) {
|		if (sp->gfn == gfn && !sp->role.direct
|		    && !sp->role.invalid) {
|			pgprintk("%s: zap %lx %x\n",
|				 __func__, gfn, sp->role.word);
|			kvm_mmu_zap_page(kvm, sp);
|		}
|	}

in the loop, if nn is zapped, hlist_for_each_entry_safe() access nn will
cause crash. and it's checked in other functions, such as kvm_mmu_zap_all(),
kvm_mmu_unprotect_page()...

Thanks,
Xiao

