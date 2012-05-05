Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2EEONI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab2EEONG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:13:06 -0400
Date: Sat, 5 May 2012 11:08:36 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page fault
Message-ID: <20120505140836.GC11842@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
 <4F9777A4.208@linux.vnet.ibm.com>
 <20120426234535.GA5057@amt.cnet>
 <4F9A3445.2060305@linux.vnet.ibm.com>
 <20120427145213.GB28796@amt.cnet>
 <4F9B89D9.9060307@linux.vnet.ibm.com>
 <20120501013459.GB10142@amt.cnet>
 <4FA0C607.5010002@linux.vnet.ibm.com>
 <20120502210701.GA12604@amt.cnet>
 <4FA26B6E.408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA26B6E.408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 07:26:38PM +0800, Xiao Guangrong wrote:
> On 05/03/2012 05:07 AM, Marcelo Tosatti wrote:
> 
> 
> >> 'entry' is not a problem since it is from atomically read-write as
> >> mentioned above, i need change this code to:
> >>
> >> 		/*
> >> 		 * Optimization: for pte sync, if spte was writable the hash
> >> 		 * lookup is unnecessary (and expensive). Write protection
> >> 		 * is responsibility of mmu_get_page / kvm_sync_page.
> >> 		 * Same reasoning can be applied to dirty page accounting.
> >> 		 */
> >> 		if (!can_unsync && is_writable_pte(entry) /* Use 'entry' instead of '*sptep'. */
> >> 			goto set_pte
> >>    ......
> >>
> >>
> >>          if (is_writable_pte(entry) && !is_writable_pte(spte)) /* Use 'spte' instead of '*sptep'. */
> >>                  kvm_flush_remote_tlbs(vcpu->kvm);
> > 
> > What is of more importance than the ability to verify that this or that
> > particular case are ok at the moment is to write code in such a way that
> > its easy to verify that it is correct.
> > 
> > Thus the suggestion above:
> > 
> > "scattered all over (as mentioned before, i think a pattern of read spte
> > once, work on top of that, atomically write and then deal with results
> > _everywhere_ (where mmu lock is held) is more consistent."
> > 
> 
> 
> Marcelo, thanks for your time to patiently review/reply my mail.
> 
> I am confused with ' _everywhere_ ', it means all of the path read/update
> spte? why not only verify the path which depends on is_writable_pte()?

I meant any path that updates from present->present.

> For the reason of "its easy to verify that it is correct"? But these
> paths are safe since it is not care PT_WRITABLE_MASK at all. What these
> paths care is the Dirty-bit and Accessed-bit are not lost, that is why
> we always treat the spte as "volatile" if it is can be updated out of
> mmu-lock.
> 
> For the further development? We can add the delta comment for
> is_writable_pte() to warn the developer use it more carefully.
> 
> It is also very hard to verify spte everywhere. :(
> 
> Actually, the current code to care PT_WRITABLE_MASK is just for
> tlb flush, may be we can fold it into mmu_spte_update.
> [
>   There are tree ways to modify spte, present -> nonpresent, nonpresent -> present,
>   present -> present.
> 
>   But we only need care present -> present for lockless.
> ]

Also need to take memory ordering into account, which was not an issue
before. So it is not only TLB flush.

> /*
>  * return true means we need flush tlbs caused by changing spte from writeable
>  * to read-only.
>  */
> bool mmu_update_spte(u64 *sptep, u64 spte)
> {
> 	u64 last_spte, old_spte = *sptep;
> 	bool flush = false;
> 
> 	last_spte = xchg(sptep, spte);
> 
> 	if ((is_writable_pte(last_spte) ||
> 	      spte_has_updated_lockless(old_spte, last_spte)) &&
> 	         !is_writable_pte(spte) )
> 		flush = true;
> 
> 	.... track Drity/Accessed bit ...
> 
> 
> 	return flush		
> }
> 
> Furthermore, the style of "if (spte-has-changed) goto beginning" is feasible
> in set_spte since this path is a fast path. (i can speed up mmu_need_write_protect)

What you mean exactly?

It would be better if all these complications introduced by lockless
updates can be avoided, say using A/D bits as Avi suggested.

