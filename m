Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2DXAtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2DXAtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:49:46 -0400
Date: Mon, 23 Apr 2012 21:45:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
Message-ID: <20120424004507.GB14423@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
 <4F911C05.2070701@linux.vnet.ibm.com>
 <20120420215211.GC13817@amt.cnet>
 <20120421004030.GA16191@amt.cnet>
 <4F9230C0.5010100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9230C0.5010100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2012 at 12:00:00PM +0800, Xiao Guangrong wrote:
> On 04/21/2012 08:40 AM, Marcelo Tosatti wrote:
> 
> > On Fri, Apr 20, 2012 at 06:52:11PM -0300, Marcelo Tosatti wrote:
> >> On Fri, Apr 20, 2012 at 04:19:17PM +0800, Xiao Guangrong wrote:
> >>> If this bit is set, it means the W bit of the spte is cleared due
> >>> to shadow page table protection
> >>>
> >>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>> ---
> >>>  arch/x86/kvm/mmu.c |   56 ++++++++++++++++++++++++++++++++++-----------------
> >>>  1 files changed, 37 insertions(+), 19 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >>> index dd984b6..eb02fc4 100644
> >>> --- a/arch/x86/kvm/mmu.c
> >>> +++ b/arch/x86/kvm/mmu.c
> >>> @@ -147,6 +147,7 @@ module_param(dbg, bool, 0644);
> >>>
> >>>  #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
> >>>  #define SPTE_ALLOW_WRITE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
> >>> +#define SPTE_WRITE_PROTECT	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 2))
> >>>
> >>>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
> >>>
> >>> @@ -1042,36 +1043,51 @@ static void drop_spte(struct kvm *kvm, u64 *sptep)
> >>>  		rmap_remove(kvm, sptep);
> >>>  }
> >>>
> >>> +static bool spte_wp_by_dirty_log(u64 spte)
> >>> +{
> >>> +	WARN_ON(is_writable_pte(spte));
> >>> +
> >>> +	return (spte & SPTE_ALLOW_WRITE) && !(spte & SPTE_WRITE_PROTECT);
> >>> +}
> >>
> >> Is the information accurate? Say:
> >>
> >> - dirty log write protect, set SPTE_ALLOW_WRITE, clear WRITABLE.
> >> - shadow gfn, rmap_write_protect finds page not WRITABLE.
> >> - spte points to shadow gfn, but SPTE_WRITE_PROTECT is not set.
> >>
> >> BTW,
> >>
> >> "introduce SPTE_ALLOW_WRITE bit
> >>
> >> This bit indicates whether the spte is allow to be writable that
> >> means the gpte of this spte is writable and the pfn pointed by
> >> this spte is writable on host"
> >>
> >> Other than the fact that each bit should have one meaning, how
> >> can this bit be accurate without write protection of the gpte?
> >>
> >> As soon as guest writes to gpte, information in bit is outdated.
> > 
> > Ok, i found one example where mmu_lock was expecting sptes not 
> > to change:
> > 
> > 
> > VCPU0				VCPU1
> > 
> > - read-only gpte
> > - read-only spte
> > - write fault
> 
> 
> It is not true, gpte is read-only, and it is a write fault, then we
> should reject the page fault to guest, the fast page fault is not called. :)
> 
> > - spte = *sptep
> > 				guest write to gpte, set writable bit
> > 				spte writable
> > 				parent page unsync
> > 				guest write to gpte writable bit clear
> > 				guest invlpg updates spte to RO
> > 				sync_page
> > 				enter set_spte from sync_page
> > - cmpxchg(spte) is now writable
> > [window where another vcpu can
> > cache spte with writable bit
> > set]
> > 
> > 				if (is_writable_pte(entry) && !is_writable_pte(*sptep))
> > 					kvm_flush_remote_tlbs(vcpu->kvm);
> > 
> > The flush is not executed because spte was read-only (which is 
> > a correct assumption as long as sptes updates are protected
> > by mmu_lock).
> 
> 
> It is also not true, flush tlbs in set_sptes is used to ensure rmap_write_protect
> work correctly, but rmap_write_protect will flush tlbs even if the spte can be changed
> by fast page fault.
> 
> > So this is an example of implicit assumptions which break if you update
> > spte without mmu_lock. Certainly there are more cases. :(
> 
> 
> We only need care the path which is depends on spte.WRITEABLE == 0, since only
> these spte has chance to be changed out of mmu-lock.
> 
> The most trouble is in rmap_write_protect that need flush tlb to protect shadow
> page table.
> 
> I think it is not too hard to check. :)

You are minimizing the possible impact these modifications have.

Perhaps you should prepare code under mmu_lock to handle concurrent spte
R->W updates first, and then later introduce the concurrent updates. In
a way that its clear for somebody reading the code that parallel updates
can happen (say read spte once, work on local copy, later re-read spte).

I find it quite difficult to read the code as it is now. Now introduce a
parallel operation on top, complexity goes way up.



