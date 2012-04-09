Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2DINzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:55:35 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53034 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2DINze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:55:34 -0400
Message-ID: <4F82EA4C.1020507@linux.vnet.ibm.com>
Date: Mon, 09 Apr 2012 21:55:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com>
In-Reply-To: <4F82E04E.6000900@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12040903-7014-0000-0000-000000DD2E51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:12 PM, Avi Kivity wrote:

> On 03/29/2012 11:20 AM, Xiao Guangrong wrote:
>> * Idea
>> The present bit of page fault error code (EFEC.P) indicates whether the
>> page table is populated on all levels, if this bit is set, we can know
>> the page fault is caused by the page-protection bits (e.g. W/R bit) or
>> the reserved bits.
>>
>> In KVM, in most cases, all this kind of page fault (EFEC.P = 1) can be
>> simply fixed: the page fault caused by reserved bit
>> (EFFC.P = 1 && EFEC.RSV = 1) has already been filtered out in fast mmio
>> path. What we need do to fix the rest page fault (EFEC.P = 1 && RSV != 1)
>> is just increasing the corresponding access on the spte.
>>
>> This pachset introduces a fast path to fix this kind of page fault: it
>> is out of mmu-lock and need not walk host page table to get the mapping
>> from gfn to pfn.
>>
>>
> 
> This patchset is really worrying to me.
> 
> It introduces a lot of concurrency into data structures that were not
> designed for it.  Even if it is correct, it will be very hard to
> convince ourselves that it is correct, and if it isn't, to debug those
> subtle bugs.  It will also be much harder to maintain the mmu code than
> it is now.
> 
> There are a lot of things to check.  Just as an example, we need to be
> sure that if we use rcu_dereference() twice in the same code path, that
> any inconsistencies due to a write in between are benign.  Doing that is
> a huge task.
> 
> But I appreciate the performance improvement and would like to see a
> simpler version make it in.  This needs to reduce the amount of data
> touched in the fast path so it is easier to validate, and perhaps reduce
> the number of cases that the fast path works on.
> 
> I would like to see the fast path as simple as
> 
>   rcu_read_lock();
> 
>   (lockless shadow walk)
>   spte = ACCESS_ONCE(*sptep);
> 
>   if (!(spte & PT_MAY_ALLOW_WRITES))
>         goto slow;
> 
>   gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->sptes)
>   mark_page_dirty(kvm, gfn);
> 
>   new_spte = spte & ~(PT64_MAY_ALLOW_WRITES | PT_WRITABLE_MASK);
>   if (cmpxchg(sptep, spte, new_spte) != spte)
>        goto slow;
> 
>   rcu_read_unlock();
>   return;
> 
> slow:
>   rcu_read_unlock();
>   slow_path();
> 
> It now becomes the responsibility of the slow path to maintain *sptep &
> PT_MAY_ALLOW_WRITES, but that path has a simpler concurrency model.  It
> can be as simple as a clear_bit() before we update sp->gfns[] or if we
> add host write protection.
> 


Okay, let's simplify it as possible:

- let it only fix the page fault with PFEC.P == 1 && PFEC.W = 0, that means
  unlock set_spte path can be dropped

- let it just fixes the page fault caused by dirty-log that means we always
  skip the spte which write-protected by shadow page protection.

Then, things should be fair simper:

In set_spte path, if the spte can be writable, we set ALLOW_WRITE bit
In rmap_write_protect:
  if (spte.PT_WRITABLE_MASK) {
	WARN_ON(!(spte & ALLOW_WRITE));
	spte &= ~PT_WRITABLE_MASK;
	spte |= WRITE_PROTECT;
  }

in fast page fault:

if (spte & PT_WRITABLE_MASK)
	return_go_guest;

if ((spte & ALLOW_WRITE) && !(spte & WRITE_PROTECT))
	cmpxchg spte + PT_WRITABLE_MASK

The information all we needed comes from spte it is independence from other path,
and no barriers.


Hmm, how about this one?

