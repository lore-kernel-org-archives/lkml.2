Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab2DISNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:13:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56915 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab2DISNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:13:49 -0400
Message-ID: <4F8326D5.7060004@gmail.com>
Date: Tue, 10 Apr 2012 02:13:41 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet>
In-Reply-To: <20120409175829.GB21894@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 01:58 AM, Marcelo Tosatti wrote:

> On Mon, Apr 09, 2012 at 04:12:46PM +0300, Avi Kivity wrote:
>> On 03/29/2012 11:20 AM, Xiao Guangrong wrote:
>>> * Idea
>>> The present bit of page fault error code (EFEC.P) indicates whether the
>>> page table is populated on all levels, if this bit is set, we can know
>>> the page fault is caused by the page-protection bits (e.g. W/R bit) or
>>> the reserved bits.
>>>
>>> In KVM, in most cases, all this kind of page fault (EFEC.P = 1) can be
>>> simply fixed: the page fault caused by reserved bit
>>> (EFFC.P = 1 && EFEC.RSV = 1) has already been filtered out in fast mmio
>>> path. What we need do to fix the rest page fault (EFEC.P = 1 && RSV != 1)
>>> is just increasing the corresponding access on the spte.
>>>
>>> This pachset introduces a fast path to fix this kind of page fault: it
>>> is out of mmu-lock and need not walk host page table to get the mapping
>>> from gfn to pfn.
>>>
>>>
>>
>> This patchset is really worrying to me.
>>
>> It introduces a lot of concurrency into data structures that were not
>> designed for it.  Even if it is correct, it will be very hard to
>> convince ourselves that it is correct, and if it isn't, to debug those
>> subtle bugs.  It will also be much harder to maintain the mmu code than
>> it is now.
>>
>> There are a lot of things to check.  Just as an example, we need to be
>> sure that if we use rcu_dereference() twice in the same code path, that
>> any inconsistencies due to a write in between are benign.  Doing that is
>> a huge task.
>>
>> But I appreciate the performance improvement and would like to see a
>> simpler version make it in.  This needs to reduce the amount of data
>> touched in the fast path so it is easier to validate, and perhaps reduce
>> the number of cases that the fast path works on.
>>
>> I would like to see the fast path as simple as
>>
>>   rcu_read_lock();
>>
>>   (lockless shadow walk)
>>   spte = ACCESS_ONCE(*sptep);
>>
>>   if (!(spte & PT_MAY_ALLOW_WRITES))
>>         goto slow;
>>
>>   gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->sptes)
>>   mark_page_dirty(kvm, gfn);
>>
>>   new_spte = spte & ~(PT64_MAY_ALLOW_WRITES | PT_WRITABLE_MASK);
>>   if (cmpxchg(sptep, spte, new_spte) != spte)
>>        goto slow;
>>
>>   rcu_read_unlock();
>>   return;
>>
>> slow:
>>   rcu_read_unlock();
>>   slow_path();
>>
>> It now becomes the responsibility of the slow path to maintain *sptep &
>> PT_MAY_ALLOW_WRITES, but that path has a simpler concurrency model.  It
>> can be as simple as a clear_bit() before we update sp->gfns[] or if we
>> add host write protection.
>>
>> Sorry, it's too complicated for me.  Marcelo, what's your take?
> 
> The improvement is small and limited to special cases (migration should
> be rare and framebuffer memory accounts for a small percentage of total
> memory).
> 
> For one, how can this be safe against mmu notifier methods?
> 
> KSM			      |VCPU0		| VCPU1
> 		 	      | fault		| fault
> 			      | cow-page	|
> 			      |	set spte RW	|
> 			      |			|
> write protect host pte	      |			|
> grab mmu_lock		      |			|
> remove writeable bit in spte  |			|
> increase mmu_notifier_seq     |			|  spte = read-only spte
> release mmu_lock	      |			|  cmpxchg succeeds, RO->RW!
> 
> MMU notifiers rely on the fault path sequence being
> 
> read host pte
> read mmu_notifier_seq
> spin_lock(mmu_lock)
> if (mmu_notifier_seq changed)
> 	goodbye, host pte value is stale
> spin_unlock(mmu_lock)
> 
> By the example above, you cannot rely on the spte value alone,
> mmu_notifier_seq must be taken into account.


No.

When KSM change the host page to read-only, the HOST_WRITABLE bit
of spte should be removed, that means, the spte should be changed
that can be watched by cmpxchg.

Note: we mark spte to be writeable only if spte.HOST_WRITABLE is
set.
