Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2EBVLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2EBVLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:11:43 -0400
Date: Wed, 2 May 2012 18:07:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120502210701.GA12604@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
 <20120426234535.GA5057@amt.cnet>
 <4F9A3445.2060305@linux.vnet.ibm.com>
 <20120427145213.GB28796@amt.cnet>
 <4F9B89D9.9060307@linux.vnet.ibm.com>
 <20120501013459.GB10142@amt.cnet>
 <4FA0C607.5010002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA0C607.5010002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:28:39PM +0800, Xiao Guangrong wrote:
> On 05/01/2012 09:34 AM, Marcelo Tosatti wrote:
> 
> 
> > 
> > It is getting better, but not yet, there are still reads of sptep
> > scattered all over (as mentioned before, i think a pattern of read spte
> > once, work on top of that, atomically write and then deal with results
> > _everywhere_ (where mmu lock is held) is more consistent.
> > 
> 
> 
> But we only need care the path which depends on is_writable_pte(), no?

Yes.

> So, where call is_writable_pte() are spte_has_volatile_bits(),
> spte_write_protect() and set_spte().
> 
> I have changed these functions:
> In spte_has_volatile_bits():
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
> In spte_write_protect():
> 
> +	spte = mmu_spte_update(sptep, spte);
> +
> +	if (is_writable_pte(spte))
> +		*flush |= true;
> +
> The 'spte' is from atomically read-write (xchg).
> 
> in set_spte():
>  set_pte:
> -	mmu_spte_update(sptep, spte);
> +	entry = mmu_spte_update(sptep, spte);
>  	/*
>  	 * If we overwrite a writable spte with a read-only one we
>  	 * should flush remote TLBs. Otherwise rmap_write_protect
> The 'entry' is also the latest value.
> 
> >         /*
> >          * If we overwrite a writable spte with a read-only one we
> >          * should flush remote TLBs. Otherwise rmap_write_protect
> >          * will find a read-only spte, even though the writable spte
> >          * might be cached on a CPU's TLB.
> >          */
> >         if (is_writable_pte(entry) && !is_writable_pte(*sptep))
> >                 kvm_flush_remote_tlbs(vcpu->kvm);
> > 
> > This is inconsistent with the above obviously.
> > 
> 
> 
> 'entry' is not a problem since it is from atomically read-write as
> mentioned above, i need change this code to:
> 
> 		/*
> 		 * Optimization: for pte sync, if spte was writable the hash
> 		 * lookup is unnecessary (and expensive). Write protection
> 		 * is responsibility of mmu_get_page / kvm_sync_page.
> 		 * Same reasoning can be applied to dirty page accounting.
> 		 */
> 		if (!can_unsync && is_writable_pte(entry) /* Use 'entry' instead of '*sptep'. */
> 			goto set_pte
>    ......
> 
> 
>          if (is_writable_pte(entry) && !is_writable_pte(spte)) /* Use 'spte' instead of '*sptep'. */
>                  kvm_flush_remote_tlbs(vcpu->kvm);

What is of more importance than the ability to verify that this or that
particular case are ok at the moment is to write code in such a way that
its easy to verify that it is correct.

Thus the suggestion above:

"scattered all over (as mentioned before, i think a pattern of read spte
once, work on top of that, atomically write and then deal with results
_everywhere_ (where mmu lock is held) is more consistent."


