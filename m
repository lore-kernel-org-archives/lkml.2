Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320Ab2D0Ozu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:55:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab2D0Ozt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:55:49 -0400
Date: Fri, 27 Apr 2012 11:52:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120427145213.GB28796@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
 <20120426234535.GA5057@amt.cnet>
 <4F9A3445.2060305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9A3445.2060305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 01:53:09PM +0800, Xiao Guangrong wrote:
> On 04/27/2012 07:45 AM, Marcelo Tosatti wrote:
> 
> 
> >> +static bool
> >> +fast_pf_fix_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >> +		  u64 *sptep, u64 spte)
> >> +{
> >> +	gfn_t gfn;
> >> +
> >> +	spin_lock(&vcpu->kvm->mmu_lock);
> >> +
> >> +	/* The spte has been changed. */
> >> +	if (*sptep != spte)
> >> +		goto exit;
> >> +
> >> +	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> >> +
> >> +	*sptep = spte | PT_WRITABLE_MASK;
> >> +	mark_page_dirty(vcpu->kvm, gfn);
> >> +
> >> +exit:
> >> +	spin_unlock(&vcpu->kvm->mmu_lock);
> > 
> > There was a misunderstanding. 
> 
> 
> Sorry, Marcelo! It is still not clear for me now. :(
> 
> > The suggestion is to change codepaths that
> > today assume that a side effect of holding mmu_lock is that sptes are
> > not updated or read before attempting to introduce any lockless spte
> > updates.
> > 
> > example)
> > 
> >         u64 mask, old_spte = *sptep;
> > 
> >         if (!spte_has_volatile_bits(old_spte) || (new_spte & mask) == mask)
> >                 __update_clear_spte_fast(sptep, new_spte);
> >         else
> >                 old_spte = __update_clear_spte_slow(sptep, new_spte);
> > 
> > The local old_spte copy might be stale by the
> > time "spte_has_volatile_bits(old_spte)" reads the writable bit.
> > 
> > example)
> > 
> > 
> > VCPU0                                       VCPU1
> > set_spte
> > mmu_spte_update decides fast write 
> > mov newspte to sptep
> > (non-locked write instruction)
> > newspte in store buffer
> > 
> >                                             lockless spte read path reads stale value
> > 
> > spin_unlock(mmu_lock) 
> > 
> > Depending on the what stale value CPU1 read and what decision it took
> > this can be a problem, say the new bits (and we do not want to verify
> > every single case). The spte write from inside mmu_lock should always be
> > atomic now?
> > 
> > So these details must be exposed to the reader, they are hidden now
> > (note mmu_spte_update is already a maze, its getting too deep).
> > 
> 
> 
> Actually, in this patch, all the spte update is under mmu-lock, and we
> lockless-ly read spte , but the spte will be verified again after holding
> mmu-lock.

Yes but the objective you are aiming for is to read and write sptes
without mmu_lock. That is, i am not talking about this patch. 
Please read carefully the two examples i gave (separated by "example)").

> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	/* The spte has been changed. */
> +	if (*sptep != spte)
> +		goto exit;
> +
> +	gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> +
> +	*sptep = spte | PT_WRITABLE_MASK;
> +	mark_page_dirty(vcpu->kvm, gfn);
> +
> +exit:
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> 
> Is not the same as both read/update spte under mmu-lock?
> 
> Hmm, this is what you want?

The rules for code under mmu_lock should be:

1) Spte updates under mmu lock must always be atomic and 
with locked instructions.
2) Spte values must be read once, and appropriate action
must be taken when writing them back in case their value 
has changed (remote TLB flush might be required).

The maintenance of:

- gpte writable bit 
- protected by dirty log

Bits is tricky. We should think of a way to simplify things 
and get rid of them (or at least one of them), if possible.

