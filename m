Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2DAQYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:24:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2DAQX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:23:58 -0400
Message-ID: <4F788119.6090401@redhat.com>
Date: Sun, 01 Apr 2012 19:23:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/13] KVM: MMU: fast path of handling guest page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742AE8.9020201@linux.vnet.ibm.com>
In-Reply-To: <4F742AE8.9020201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 11:27 AM, Xiao Guangrong wrote:
> If the the present bit of page fault error code is set, it indicates
> the shadow page is populated on all levels, it means what we do is only
> modify the access bit which can be done out of mmu-lock
>
> The tricks in this patch is avoiding the race between fast page fault
> path and write-protect path, write-protect path is a read-check-modify
> path:
> read spte, check W bit, then clear W bit. What we do is populating a
> identification in spte, if write-protect meets it, it modify the spte
> even if the spte is readonly. See the comment in the code to get more
> information
>
> +
> +static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, gfn_t gfn,
> +				   u32 error_code)
> +{
> +	unsigned long *rmap;
> +	bool write = error_code & PFERR_WRITE_MASK;
> +
> +	/*
> +	 * #PF can be fast only if the shadow page table is present, that
> +	 * means we just need change the access bits (e.g: R/W, U/S...)
> +	 * which can be done out of mmu-lock.
> +	 */
> +	if (!(error_code & PFERR_PRESENT_MASK))
> +		return false;
> +
> +	if (unlikely(vcpu->vcpu_id > max_vcpu_spte()))
> +		return false;
> +
> +	rmap = gfn_to_rmap(vcpu->kvm, gfn, PT_PAGE_TABLE_LEVEL);

What prevents sp->gfns from being freed while this is going on?  Did I
miss the patch that makes mmu pages freed by rcu?  Also need barriers in
kvm_mmu_get_page() to make sure sp->gfns is made visible before the page
is hashed in.

+ smp_rmb()

> +
> +	/* Quickly check the page can be writable. */
> +	if (write && (ACCESS_ONCE(*rmap) & PTE_LIST_WRITE_PROTECT))
> +		return false;
> +
> +	return true;
> +}
> +
> +typedef bool (*fast_pf_fetch_spte)(struct kvm_vcpu *vcpu, u64 *sptep,
> +				   u64 *new_spte, gfn_t gfn, u32 expect_access,
> +				   u64 spte);
> +
> +static bool
> +fast_pf_fetch_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 *new_spte,
> +			  gfn_t gfn, u32 expect_access, u64 spte)
> +{
> +	struct kvm_mmu_page *sp = page_header(__pa(sptep));
> +

Why is this stable?  Another cpu could have removed it.

>
> +	WARN_ON(!sp->role.direct);
> +
> +	if (kvm_mmu_page_get_gfn(sp, sptep - sp->spt) != gfn)
> +		return false;

Simpler to check if the page is sync; if it is, gfn has not changed.

(but the check for a sync page is itself unstable).

>
> +
> +	set_spte(vcpu, new_spte, sp->role.access,
> +		 expect_access & ACC_USER_MASK, expect_access & ACC_WRITE_MASK,
> +		 sp->role.level, gfn, spte_to_pfn(spte), false, false,
> +		 spte & SPTE_HOST_WRITEABLE, true);
> +

What if the conditions have changed meanwhile?  Should we set the spte
atomically via set_spte?  For example an mmu notifier clearing the spte
in parallel.

What if another code path has read *spte, and did not re-read it because
it holds the mmu lock and thinks only the guest can access it?

>
> +	return true;
> +}
> +
> +static bool
> +fast_page_fault_fix_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 spte,
> +			 gfn_t gfn, u32 expect_access,
> +			 fast_pf_fetch_spte fn)
> +{
> +	u64 new_spte = 0ull;
> +	int vcpu_id = vcpu->vcpu_id;
> +
> +	spte = mark_vcpu_id_spte(sptep, spte, vcpu_id);

What's the point of reading spte?  It can change any minute, so the
value is stale and we can't use it.  We have to read and lock it
atomically, no?

Your patches read the spte, then set the identity.  In between some
other path can change the spte.

-- 
error compiling committee.c: too many arguments to function

