Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab2EABjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 21:39:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab2EABju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 21:39:50 -0400
Date: Mon, 30 Apr 2012 22:34:59 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120501013459.GB10142@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
 <20120426234535.GA5057@amt.cnet>
 <4F9A3445.2060305@linux.vnet.ibm.com>
 <20120427145213.GB28796@amt.cnet>
 <4F9B89D9.9060307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9B89D9.9060307@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 02:10:33PM +0800, Xiao Guangrong wrote:
> On 04/27/2012 10:52 PM, Marcelo Tosatti wrote:
> 
> 
> >> Actually, in this patch, all the spte update is under mmu-lock, and we
> >> lockless-ly read spte , but the spte will be verified again after holding
> >> mmu-lock.
> > 
> > Yes but the objective you are aiming for is to read and write sptes
> > without mmu_lock. That is, i am not talking about this patch. 
> > Please read carefully the two examples i gave (separated by "example)").
> > 
> 
> 
> Thanks for your patience, Marcelo!
> 
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
> >>
> >> Is not the same as both read/update spte under mmu-lock?
> >>
> >> Hmm, this is what you want?
> > 
> > The rules for code under mmu_lock should be:
> > 
> > 1) Spte updates under mmu lock must always be atomic and 
> > with locked instructions.
> 
> 
> How about treating the spte is 'volatile' if the spte can be
> updated out of mmu-lock? In this case, the update is always
> atomic.
> 
> The piece of code:
> 
> +static bool spte_can_be_writable(u64 spte)
> +{
> +	u64 mask = SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE;
> +
> +	return (spte & mask) == mask;
> +}
> +
> +static bool spte_can_lockless_update(u64 spte)
> +{
> +	return  !is_writable_pte(spte) && spte_can_be_writable(spte);
> +}
> +
>  static bool spte_has_volatile_bits(u64 spte)
>  {
> +	/*
> +	 * Always atomicly update spte if it can be updated
> +	 * out of mmu-lock.
> +	 */
> +	if (spte_can_lockless_update(spte))
> +		return true;
> +
> 
> > 2) Spte values must be read once, and appropriate action
> > must be taken when writing them back in case their value 
> > has changed (remote TLB flush might be required).
> > 
> 
> 
> Okay, may be i get your idea now. :)
> 
> I will fix mmu_spte_update, let it to return the latest old value which
> will be checked in the caller before it is updated.
> 
> > The maintenance of:
> > 
> > - gpte writable bit 
> > - protected by dirty log
> > 
> > Bits is tricky. We should think of a way to simplify things 
> > and get rid of them (or at least one of them), if possible.
> > 
> 
> Maybe SPTE_MMU_WRITEABLE is sufficient, the second bit will be dropped.
> 
> Marcelo, do you satisfied with this patch?

It is getting better, but not yet, there are still reads of sptep
scattered all over (as mentioned before, i think a pattern of read spte
once, work on top of that, atomically write and then deal with results
_everywhere_ (where mmu lock is held) is more consistent.

        /*
         * If we overwrite a writable spte with a read-only one we
         * should flush remote TLBs. Otherwise rmap_write_protect
         * will find a read-only spte, even though the writable spte
         * might be cached on a CPU's TLB.
         */
        if (is_writable_pte(entry) && !is_writable_pte(*sptep))
                kvm_flush_remote_tlbs(vcpu->kvm);

This is inconsistent with the above obviously.

