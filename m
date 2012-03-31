Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab2CaMY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 08:24:58 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45884 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2CaMYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 08:24:54 -0400
Message-ID: <4F76F78F.2080101@linux.vnet.ibm.com>
Date: Sat, 31 Mar 2012 20:24:47 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/13] KVM: MMU: fast path of handling guest page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F742AE8.9020201@linux.vnet.ibm.com>
In-Reply-To: <4F742AE8.9020201@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12033102-6102-0000-0000-000001257FA3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 05:27 PM, Xiao Guangrong wrote:


> +static bool
> +FNAME(fast_pf_fetch_indirect_spte)(struct kvm_vcpu *vcpu, u64 *sptep,
> +				   u64 *new_spte, gfn_t gfn,
> +				   u32 expect_access, u64 spte)
> +
> +{
> +	struct kvm_mmu_page *sp = page_header(__pa(sptep));
> +	pt_element_t gpte;
> +	gpa_t pte_gpa;
> +	unsigned pte_access;
> +
> +	if (sp->role.direct)
> +		return fast_pf_fetch_direct_spte(vcpu, sptep, new_spte,
> +						 gfn, expect_access, spte);
> +
> +	pte_gpa = FNAME(get_sp_gpa)(sp);
> +	pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
> +
> +	if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &gpte,
> +				      sizeof(pt_element_t)))
> +		return false;
> +
> +	if (FNAME(invalid_gpte)(vcpu, gpte))
> +		return false;
> +
> +	if (gpte_to_gfn(gpte) != gfn)
> +		return false;
> +


Oh, it can not prevent the gpte has been changed, below case will be triggered:

      VCPU 0                       VCPU 1                          VCPU 2

gpte = gfn1 + RO + S + NX
spte = gfn1's pfn + RO + NX

                                modify gpte: gpte = gfn2 + W + U+ X
                                (due to unsync-sp or wirte emulation
                                 before calling kvm_mmu_pte_write())

                                                         page fault on gpte:
                                                               gfn = gfn2
                                                         fast page fault:
                                                               spte = gfn1's pfn + W + U + X
                                                 (It also can break shadow page table write-protect)
                                                          OOPS!!!

The issue is that gfn does not match with pfn in spte.

Maybe we can properly using sp->gfns[] to avoid it:
- sp->gfns is freed in the RCU context
- sp->gfns[] is initiated to INVALID_GFN
- while spte is dropped, set sp->gfns[] to INVALID_GFN

On fast page fault path, we can check sp->gfns[] with the gfn which is read from
gpte, then do cmpxchg if they are the same.

Then, the thing becomes safe since:
- we have set the identification in the spte before the check, that means we can
  perceive the spte change in the later cmpxchg.
- check sp->gfns[] can ensure spte is pointing to gfn's pfn.



