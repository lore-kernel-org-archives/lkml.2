Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013Ab2DPEEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 00:04:11 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34761 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2DPEEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 00:04:09 -0400
Message-ID: <4F8B970C.9060001@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:50:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 00/16] KVM: MMU: fast page fault
References: <4F87FA69.5060106@linux.vnet.ibm.com> <20120414123722.a94af3adb4ca80a6a5f6b477@gmail.com>
In-Reply-To: <20120414123722.a94af3adb4ca80a6a5f6b477@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12041517-5140-0000-0000-00000111FCED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2012 11:37 AM, Takuya Yoshikawa wrote:

> On Fri, 13 Apr 2012 18:05:29 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Thanks for Avi and Marcelo's review, i have simplified the whole things
>> in this version:
>> - it only fix the page fault with PFEC.P = 1 && PFEC.W = 0 that means
>>   unlock set_spte path can be dropped.
>>
>> - it only fixes the page fault caused by dirty-log
>>
>> In this version, all the information we need is from spte, the
>> SPTE_ALLOW_WRITE bit and SPTE_WRITE_PROTECT bit:
>>    - SPTE_ALLOW_WRITE is set if the gpte is writable and the pfn pointed
>>      by the spte is writable on host.
>>    - SPTE_WRITE_PROTECT is set if the spte is write-protected by shadow
>>      page table protection.
>>
>> All these bits can be protected by cmpxchg, now, all the things is fairly
>> simple than before. :)
> 
> Well, could you remove cleanup patches not needed for "lock-less" from
> this patch series?
> 
> I want to see them separately.
> 
> Or everything was needed for "lock-less" ?
> 


The cleanup patches do the prepare work for fast page fault, the later path will
be easily implemented, for example, the for_each_spte_rmap patches make "store
more bits in rmap" patch doing little change since spte_list_walk is removed.

>> Performance test:
>>
>> autotest migration:
>> (Host: Intel(R) Xeon(R) CPU           X5690  @ 3.47GHz * 12 + 32G)
> 
> Please explain what this test result means, not just numbers.
> 
> There are many aspects:
> 	- how fast migration can converge/complete
> 	- how fast programs inside the guest can run during migration:
> 	  -- throughput
> 	  -- latency
> 	- ...
> 


The result is rather straightforward, i think explanation is not needed.

> I think lock-less will reduce latency a lot, but not sure about convergence:
> why it became fast?
> 


It is hard to understand? It is faster since it can be parallel.

>> - For ept:
>>
>> Before:
>>                     smp2.Fedora.16.64.migrate
>> Times   .unix      .with_autotest.dbench.unix     total
>>  1       104           214                         323
>>  2       68            238                         310
>>  3       68            242                         314
>>
>> After:
>>                     smp2.Fedora.16.64.migrate
>> Times   .unix      .with_autotest.dbench.unix     total
>>  1       101           190                         295
>>  2       67            188                         259
>>  3       66            217                         289
>>
> 
> As discussed on v1-threads, the main goal of this "lock-less" should be
> the elimination of mmu_lock contentions
> 
> So what we should measure is latency.
> 


I think the test of migration time is fairly enough to see the effect.

