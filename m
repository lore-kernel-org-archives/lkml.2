Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2DISCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab2DISCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:02:17 -0400
Date: Mon, 9 Apr 2012 14:58:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-ID: <20120409175829.GB21894@amt.cnet>
References: <4F742951.7080003@linux.vnet.ibm.com>
 <4F82E04E.6000900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F82E04E.6000900@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 04:12:46PM +0300, Avi Kivity wrote:
> On 03/29/2012 11:20 AM, Xiao Guangrong wrote:
> > * Idea
> > The present bit of page fault error code (EFEC.P) indicates whether the
> > page table is populated on all levels, if this bit is set, we can know
> > the page fault is caused by the page-protection bits (e.g. W/R bit) or
> > the reserved bits.
> >
> > In KVM, in most cases, all this kind of page fault (EFEC.P = 1) can be
> > simply fixed: the page fault caused by reserved bit
> > (EFFC.P = 1 && EFEC.RSV = 1) has already been filtered out in fast mmio
> > path. What we need do to fix the rest page fault (EFEC.P = 1 && RSV != 1)
> > is just increasing the corresponding access on the spte.
> >
> > This pachset introduces a fast path to fix this kind of page fault: it
> > is out of mmu-lock and need not walk host page table to get the mapping
> > from gfn to pfn.
> >
> >
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
> Sorry, it's too complicated for me.  Marcelo, what's your take?

The improvement is small and limited to special cases (migration should
be rare and framebuffer memory accounts for a small percentage of total
memory).

For one, how can this be safe against mmu notifier methods?

KSM			      |VCPU0		| VCPU1
		 	      | fault		| fault
			      | cow-page	|
			      |	set spte RW	|
			      |			|
write protect host pte	      |			|
grab mmu_lock		      |			|
remove writeable bit in spte  |			|
increase mmu_notifier_seq     |			|  spte = read-only spte
release mmu_lock	      |			|  cmpxchg succeeds, RO->RW!

MMU notifiers rely on the fault path sequence being

read host pte
read mmu_notifier_seq
spin_lock(mmu_lock)
if (mmu_notifier_seq changed)
	goodbye, host pte value is stale
spin_unlock(mmu_lock)

By the example above, you cannot rely on the spte value alone,
mmu_notifier_seq must be taken into account.

