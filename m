Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2KTXw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:52:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab2KTXwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:52:24 -0500
Date: Tue, 20 Nov 2012 21:51:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: simplify mmu_set_spte
Message-ID: <20121120235147.GA12391@amt.cnet>
References: <5097AC70.1080904@linux.vnet.ibm.com>
 <5097ACA0.7080408@linux.vnet.ibm.com>
 <20121112231223.GC5798@amt.cnet>
 <50A20750.8050808@linux.vnet.ibm.com>
 <20121120221853.GA31427@amt.cnet>
 <50AC10EE.8000008@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AC10EE.8000008@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 07:23:26AM +0800, Xiao Guangrong wrote:
> On 11/21/2012 06:18 AM, Marcelo Tosatti wrote:
> 
> >>>> -			child = page_header(pte & PT64_BASE_ADDR_MASK);
> >>>> -			drop_parent_pte(child, sptep);
> >>>> -			kvm_flush_remote_tlbs(vcpu->kvm);
> >>>
> >>> How come its safe to drop this case?
> >>
> >> We use "if (pfn != spte_to_pfn(*sptep))" to simplify the thing.
> >> There are two cases:
> >> 1) the sptep is not the last mapping.
> >>    under this case, sptep must point to a shadow page table, that means
> >>    spte_to_pfn(*sptep)) is used by KVM module, and 'pfn' is used by userspace.
> >>    so, 'if' condition must be satisfied, the sptep will be dropped.
> >>
> >>    Actually, This is the origin case:
> >>   | if (level > PT_PAGE_TABLE_LEVEL &&
> >>   |	    !is_large_pte(*sptep))"
> >>
> >> 2) the sptep is the last mapping.
> >>    under this case, the level of spte (sp.level) must equal the 'level' which
> >>    we pass to mmu_set_spte. If they point to the same pfn, it is 'remap', otherwise
> >>    we drop it.
> >>
> >> I think this is safe. :)
> > 
> > mmu_page_zap_pte takes care of it, OK.
> > 
> > What if was_rmapped=true but gfn is different? Say if the spte comes
> > from an unsync shadow page, the guest modifies that shadow page (but
> > does not invalidate it with invlpg), then faults. gfn can still point
> > to the same gfn (but in that case, with your patch,
> > page_header_update_slot is not called.
> 
> Marcelo,
> 
> Page fault path and other sync/prefetch paths will reread guest page table,
> then it get a different target pfn.
> 
> The scenario is like this:
> 
> gfn1 = pfn1, gfn2 = pfn2
> gpte = pfn1, spte is shadowed by gpte and it is a unsync spte
> 
> Guest                               Host
>                                      spte = (gfn1, pfn1)
> 
> modify gpte to let it point to gfn2
>                                     spte = (gfn1, pfn1)
> page-fault on gpte
>                                     intercept the page-fault, then
>                                     want to update spte to (gfn2, pfn2)
> 
>                                     in mmu_set_spte, we can detect
>                                     pfn2 != pfn1, then drop it.
> 
> Hmm, the interesting thing is what if different gfns map to the same pfn.
> For example, spte1 is shadowed by gfn1 and spte2 is shadowed by pfn2, both
> gfn1 and gfn2 map to pfn, the code (including the current code) will set
> spte1 to the gfn2's rmap and spte2 to the gfn1's rmap. But i think it is ok.

Current code updates gfn properly in set_spte by
page_header_update_slot. 

Better keep state properly.

