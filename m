Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2KTW2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:28:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2KTW2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:28:52 -0500
Date: Tue, 20 Nov 2012 20:18:53 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: simplify mmu_set_spte
Message-ID: <20121120221853.GA31427@amt.cnet>
References: <5097AC70.1080904@linux.vnet.ibm.com>
 <5097ACA0.7080408@linux.vnet.ibm.com>
 <20121112231223.GC5798@amt.cnet>
 <50A20750.8050808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A20750.8050808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 04:39:44PM +0800, Xiao Guangrong wrote:
> On 11/13/2012 07:12 AM, Marcelo Tosatti wrote:
> > On Mon, Nov 05, 2012 at 08:10:08PM +0800, Xiao Guangrong wrote:
> >> In order to detecting spte remapping, we can simply check whether the
> >> spte has already been pointing to the pfn even if the spte is not the
> >> last spte for middle spte is pointing to the kernel pfn which can not
> >> be mapped to userspace
> >>
> >> Also, update slot and stat.lpages iff the spte is not remapped
> >>
> >> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >> ---
> >>  arch/x86/kvm/mmu.c |   40 +++++++++++++---------------------------
> >>  1 files changed, 13 insertions(+), 27 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >> index 692ebb1..4ea731e 100644
> >> --- a/arch/x86/kvm/mmu.c
> >> +++ b/arch/x86/kvm/mmu.c
> >> @@ -2420,8 +2420,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >>  			 pfn_t pfn, bool speculative,
> >>  			 bool host_writable)
> >>  {
> >> -	int was_rmapped = 0;
> >> -	int rmap_count;
> >> +	bool was_rmapped = false;
> >>
> >>  	pgprintk("%s: spte %llx access %x write_fault %d"
> >>  		 " user_fault %d gfn %llx\n",
> >> @@ -2429,25 +2428,13 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> >>  		 write_fault, user_fault, gfn);
> >>
> >>  	if (is_rmap_spte(*sptep)) {
> >> -		/*
> >> -		 * If we overwrite a PTE page pointer with a 2MB PMD, unlink
> >> -		 * the parent of the now unreachable PTE.
> >> -		 */
> >> -		if (level > PT_PAGE_TABLE_LEVEL &&
> >> -		    !is_large_pte(*sptep)) {
> >> -			struct kvm_mmu_page *child;
> >> -			u64 pte = *sptep;
> >> +		if (pfn != spte_to_pfn(*sptep)) {
> >> +			struct kvm_mmu_page *sp = page_header(__pa(sptep));
> >>
> >> -			child = page_header(pte & PT64_BASE_ADDR_MASK);
> >> -			drop_parent_pte(child, sptep);
> >> -			kvm_flush_remote_tlbs(vcpu->kvm);
> > 
> > How come its safe to drop this case?
> 
> We use "if (pfn != spte_to_pfn(*sptep))" to simplify the thing.
> There are two cases:
> 1) the sptep is not the last mapping.
>    under this case, sptep must point to a shadow page table, that means
>    spte_to_pfn(*sptep)) is used by KVM module, and 'pfn' is used by userspace.
>    so, 'if' condition must be satisfied, the sptep will be dropped.
> 
>    Actually, This is the origin case:
>   | if (level > PT_PAGE_TABLE_LEVEL &&
>   |	    !is_large_pte(*sptep))"
> 
> 2) the sptep is the last mapping.
>    under this case, the level of spte (sp.level) must equal the 'level' which
>    we pass to mmu_set_spte. If they point to the same pfn, it is 'remap', otherwise
>    we drop it.
> 
> I think this is safe. :)

mmu_page_zap_pte takes care of it, OK.

What if was_rmapped=true but gfn is different? Say if the spte comes
from an unsync shadow page, the guest modifies that shadow page (but
does not invalidate it with invlpg), then faults. gfn can still point
to the same gfn (but in that case, with your patch,
page_header_update_slot is not called.

