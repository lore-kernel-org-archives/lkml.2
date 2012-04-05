Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2DETjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:39:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33828 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2DETja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:39:30 -0400
Message-ID: <4F7DF4EB.8040708@gmail.com>
Date: Fri, 06 Apr 2012 03:39:23 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/13] KVM: MMU: fast path of handling guest page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742AE8.9020201@linux.vnet.ibm.com> <4F788119.6090401@redhat.com>
In-Reply-To: <4F788119.6090401@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 12:23 AM, Avi Kivity wrote:

> On 03/29/2012 11:27 AM, Xiao Guangrong wrote:
>> If the the present bit of page fault error code is set, it indicates
>> the shadow page is populated on all levels, it means what we do is only
>> modify the access bit which can be done out of mmu-lock
>>
>> The tricks in this patch is avoiding the race between fast page fault
>> path and write-protect path, write-protect path is a read-check-modify
>> path:
>> read spte, check W bit, then clear W bit. What we do is populating a
>> identification in spte, if write-protect meets it, it modify the spte
>> even if the spte is readonly. See the comment in the code to get more
>> information
>>
>> +
>> +static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
>> +				   u32 error_code)
>> +{
>> +	unsigned long *rmap;
>> +	bool write = error_code & PFERR_WRITE_MASK;
>> +
>> +	/*
>> +	 * #PF can be fast only if the shadow page table is present, that
>> +	 * means we just need change the access bits (e.g: R/W, U/S...)
>> +	 * which can be done out of mmu-lock.
>> +	 */
>> +	if (!(error_code & PFERR_PRESENT_MASK))
>> +		return false;
>> +
>> +	if (unlikely(vcpu->vcpu_id > max_vcpu_spte()))
>> +		return false;
>> +
>> +	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);
> 
> What prevents sp->gfns from being freed while this is going on?  Did I
> miss the patch that makes mmu pages freed by rcu?  


sp->gfns is not used here, what we are using is rmap which came from
memslot protected by srcu.

In this patch, we called kvm_mmu_page_get_gfn in fast_pf_fetch_direct_spte
which only used for direct sp, sp->gfns is also not touched in this case.

But, i want to use it in the next version, it should be freed in the
rcu context, see:
http://thread.gmane.org/gmane.comp.emulators.kvm.devel/88934

> Also need barriers in
> kvm_mmu_get_page() to make sure sp->gfns is made visible before the page
> is hashed in.
> 


We do not walk the hash tables of shadow page, we walk shadow page table
which currently is being used by vcpu, so we just need care the order
of setting spte and setting sp->gfns, but it has data dependence in
currently code:

set spte
if (is_shadow_present_pte(*sptep))
   set sp->gfns[]

setting sp->gfns can not be reordered to the head of set spte


> + smp_rmb()
> 


Actually, i do not want to use barrier here since a read barrier is
not a complier barrier on X86. And we just quickly check the page
can be writable before shadow page table walking. A real barrier is
used before updating spte.

>> +
>> +	/* Quickly check the page can be writable. */
>> +	if (write && (ACCESS_ONCE(*rmap) & PTE_LIST_WRITE_PROTECT))
>> +		return false;
>> +
>> +	return true;
>> +}
>> +
>> +typedef bool (*fast_pf_fetch_spte)(struct kvm_vcpu *vcpu, u64 *sptep,
>> +				   u64 *new_spte, gfn_t gfn, u32 expect_access,
>> +				   u64 spte);
>> +
>> +static bool
>> +fast_pf_fetch_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 *new_spte,
>> +			  gfn_t gfn, u32 expect_access, u64 spte)
>> +{
>> +	struct kvm_mmu_page *sp = page_header(__pa(sptep));
>> +
> 
> Why is this stable?  Another cpu could have removed it.
> 


It is ok for the removed sp since it is not freed on this path. And if the
sp is remove, cmpxchg can see this change since the spte is zapped.

>>
>> +	WARN_ON(!sp->role.direct);
>> +
>> +	if (kvm_mmu_page_get_gfn(sp, sptep - sp->spt) != gfn)
>> +		return false;
> 
> Simpler to check if the page is sync; if it is, gfn has not changed.
> 
> (but the check for a sync page is itself unstable).
> 


Checking sp.sync is unsafe since there has a window between guest page write
emulation and update spte:

At the Beginning:
gpte = gfn1
spte = gfn1's pfn
(gfn1 is write-protect, gfn2 is write-free)

VCPU 1                          VCPU 2

modify gpte and let it point to gfn2
page fault
write-emulation: gpte = gfn2

                             page fault on gpte:
                                 gfn = gfn2
                             fast page fault:
                                 sett gfn2 is write free and update spte:
                             spte = gfn1's pfn + W
                                 OOPS!!!
zap spte

>>
>> +
>> +	set_spte(vcpu, new_spte, sp->role.access,
>> +		 expect_access & ACC_USER_MASK, expect_access & ACC_WRITE_MASK,
>> +		 sp->role.level, gfn, spte_to_pfn(spte), false, false,
>> +		 spte & SPTE_HOST_WRITEABLE, true);
>> +
> 
> What if the conditions have changed meanwhile?  Should we set the spte
> atomically via set_spte?  For example an mmu notifier clearing the spte
> in parallel.
> 


All of these case are ok, we do not directly update spte and it is updated like
this:

new_spte = 0x0ull /* set it to nonpresent, so rmap path can not be touched. */
set_spte(vcpu, &new_spte, ......) /* the expected spte is temporarily saved to new_spte.*/
cmpxchg(spte, spte_old, new_spte)

It depends on cmpxchg.

> What if another code path has read *spte, and did not re-read it because
> it holds the mmu lock and thinks only the guest can access it?
> 


We just change access bits here and the mapped pfn is not changed. All the read
paths are ok except page write-protect path since its work depends on the W bit.

That it is why we introduce spte.identification.

>>
>> +	return true;
>> +}
>> +
>> +static bool
>> +fast_page_fault_fix_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte,
>> +			 gfn_t gfn, u32 expect_access,
>> +			 fast_pf_fetch_spte fn)
>> +{
>> +	u64 new_spte = 0ull;
>> +	int vcpu_id = vcpu->vcpu_id;
>> +
>> +	spte = mark_vcpu_id_spte(sptep, spte, vcpu_id);
> 
> What's the point of reading spte?  It can change any minute, so the
> value is stale and we can't use it.  We have to read and lock it
> atomically, no?
> 


No. :)

> Your patches read the spte, then set the identity.  In between some
> other path can change the spte.
> 


It can set the new identity (vcpu id) whatever the current identity is, cmpxchg can
see the change: it updates spte only when the identity is matched.

