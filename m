Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2EGGwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:52:40 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:48610 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2EGGwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:52:39 -0400
Message-ID: <4FA7712D.9070501@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 14:52:29 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
References: <4F9776D2.7020506@linux.vnet.ibm.com> <4F9777A4.208@linux.vnet.ibm.com> <20120426234535.GA5057@amt.cnet> <4F9A3445.2060305@linux.vnet.ibm.com> <20120427145213.GB28796@amt.cnet> <4F9B89D9.9060307@linux.vnet.ibm.com> <20120501013459.GB10142@amt.cnet> <4FA0C607.5010002@linux.vnet.ibm.com> <20120502210701.GA12604@amt.cnet> <4FA26B6E.408@linux.vnet.ibm.com> <20120505140836.GC11842@amt.cnet>
In-Reply-To: <20120505140836.GC11842@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12050706-2674-0000-0000-0000044CE750
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2012 10:08 PM, Marcelo Tosatti wrote:


>>
>> I am confused with ' _everywhere_ ', it means all of the path read/update
>> spte? why not only verify the path which depends on is_writable_pte()?
> 
> I meant any path that updates from present->present.
> 


OK, got it. So let us focus on mmu_spte_update() only. :)

>> For the reason of "its easy to verify that it is correct"? But these
>> paths are safe since it is not care PT_WRITABLE_MASK at all. What these
>> paths care is the Dirty-bit and Accessed-bit are not lost, that is why
>> we always treat the spte as "volatile" if it is can be updated out of
>> mmu-lock.
>>
>> For the further development? We can add the delta comment for
>> is_writable_pte() to warn the developer use it more carefully.
>>
>> It is also very hard to verify spte everywhere. :(
>>
>> Actually, the current code to care PT_WRITABLE_MASK is just for
>> tlb flush, may be we can fold it into mmu_spte_update.
>> [
>>   There are tree ways to modify spte, present -> nonpresent, nonpresent -> present,
>>   present -> present.
>>
>>   But we only need care present -> present for lockless.
>> ]
> 
> Also need to take memory ordering into account, which was not an issue
> before. So it is not only TLB flush.


It seems do not need explicit barrier, we always use atomic-xchg to update
spte, it has already guaranteed the memory ordering.

In mmu_spte_update():

/* the return value indicates wheater tlb need be flushed.*/
static bool mmu_spte_update(u64 *sptep, u64 new_spte)
{
	u64 old_spte = *sptep;
	bool flush = false;

	old_spte = xchg(sptep, new_spte);

	if (is_writable_pte(old_spte) && !is_writable_pte(spte) )
		flush = true;

	.....
}

> 
>> /*
>>  * return true means we need flush tlbs caused by changing spte from writeable
>>  * to read-only.
>>  */
>> bool mmu_update_spte(u64 *sptep, u64 spte)
>> {
>> 	u64 last_spte, old_spte = *sptep;
>> 	bool flush = false;
>>
>> 	last_spte = xchg(sptep, spte);
>>
>> 	if ((is_writable_pte(last_spte) ||
>> 	      spte_has_updated_lockless(old_spte, last_spte)) &&
>> 	         !is_writable_pte(spte) )
>> 		flush = true;
>>
>> 	.... track Drity/Accessed bit ...
>>
>>
>> 	return flush		
>> }
>>
>> Furthermore, the style of "if (spte-has-changed) goto beginning" is feasible
>> in set_spte since this path is a fast path. (i can speed up mmu_need_write_protect)
> 
> What you mean exactly?
> 
> It would be better if all these complications introduced by lockless
> updates can be avoided, say using A/D bits as Avi suggested.


Anyway, i do not object it if we have a better way to do these, but ......

