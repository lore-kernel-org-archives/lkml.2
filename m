Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0F1Llj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:41:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0F1Llh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:41:37 -0400
Message-ID: <4C288A6E.6060500@redhat.com>
Date: Mon, 28 Jun 2010 14:41:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/10] KVM: MMU: fix writable sync sp mapping
References: <4C249B84.4080703@cn.fujitsu.com> <4C2704CF.6040401@cn.fujitsu.com> <4C2868C9.8040302@redhat.com> <4C286E1A.7070003@cn.fujitsu.com>
In-Reply-To: <4C286E1A.7070003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 12:40 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>>>        for_each_gfn_indirect_valid_sp(vcpu->kvm, s, gfn, node) {
>>> +        if (!can_unsync)
>>> +            return 1;
>>> +
>>>
>>>        
>> What if the page is already unsync?  We don't need write protection in
>> this case.
>>      
> Avi,
>
> The reason is when we sync children sps, we write-protected for all sps first,
> list relevant code:
>
> | static void mmu_sync_children(...)
> | {
> |	......
> |		for_each_sp(pages, sp, parents, i)
> |			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);<==== A
> |
> |		if (protected)
> |			kvm_flush_remote_tlbs(vcpu->kvm);
> |
> |		for_each_sp(pages, sp, parents, i) {
> |			kvm_sync_page(vcpu, sp,&invalid_list);<==== B
> |			mmu_pages_clear_parents(&parents);
> |		}
> |	......
> |}
>
> For example:
>
> SP1.pte[0] = P
> SP2.gfn's pfn = P
> [SP1.pte[0] = SP2.gfn's pfn]
>
> At A point, SP1.gfn and SP2.gfn are write-protected.
>
> At B point, if sync SP1 first, while it's synced. it will detect SP1.pte[0].gfn only has one unsync-sp,
> that is SP2, so it will mapping it writable, then we sync SP2, we will set SP2 to sync page.
>
> The final result is: SP2 is the sync page but SP2.gfn is writable.
>    


I think I see.  So, after A, the pages are write protected, but are 
still marked as unsync.  In B, we're testing SP2->unsync, which we plan 
to sync soon, but haven't yet.  So the test for s->unsync is incorrect.

So the patch is right.  Thanks for the explanation.  Please update the 
changelog to note that sp->unsync is not reliable during resync, this is 
tricky stuff.

-- 
error compiling committee.c: too many arguments to function

