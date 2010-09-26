Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0IZNJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 09:09:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0IZNJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 09:09:14 -0400
Message-ID: <4C9F45F3.7000405@redhat.com>
Date: Sun, 26 Sep 2010 15:09:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: Don't touch unsync sp in kvm_mmu_pte_write()
References: <4C976D48.6020400@cn.fujitsu.com> <4C976DF6.1020905@cn.fujitsu.com> <4C977CBF.6030702@redhat.com> <4C9AC283.3000307@cn.fujitsu.com>
In-Reply-To: <4C9AC283.3000307@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/23/2010 04:59 AM, Xiao Guangrong wrote:
> On 09/20/2010 11:24 PM, Avi Kivity wrote:
> >   On 09/20/2010 04:21 PM, Xiao Guangrong wrote:
> >>  Gfn may have many shadow pages, when one sp need be synced, we write
> >>  protected sp->gfn and sync this sp but we keep other shadow pages
> >>  asynchronous
> >>
> >>  So, while gfn happen page fault, let it not touches unsync page, the
> >>  unsync
> >>  page only updated at invlpg/flush TLB time
> >>
> >>  @@ -3157,6 +3164,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu,
> >>  gpa_t gpa,
> >>
> >>        mask.cr0_wp = mask.cr4_pae = mask.nxe = 1;
> >>        for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn, node) {
> >>  +        if (sp->unsync)
> >>  +            continue;
> >>  +
> >>
> >
> >  Not sure this is a win.  If a gpte is updated from having p=0 to p=1 (or
> >  permissions upgraded), we may not have an invlpg to sync the spte, since
> >  the hardware doesn't require it.  With this change, we may get an extra
> >  #PF.
> >
>
> Avi,
>
> Thanks for your review, i think this case is not too bad since:
>
> 1: This case only impacts local vcpu since if permissions is increased, it's
>     no need send IPT to flush remote vcpu's tlb, so even if we update unsync
>     spte in kvm_mmu_pte_write() path, the #PF still occur on other vcpus.

IIRC, the cpu will re-validate the tlb entry from the page tables before 
issuing a fault, so we won't see a spurious fault.  Not 100% sure.

For !P -> P, there won't be a tlb entry, so 100% there won't be a 
spurious fault.

> 2: If the unsync sp which is updated in kvm_mmu_pte_write() is not using by the
>     vcpu, it will sync automatically after it's loaded.

True, and this is a likely case.

> 3: If the sp is using, update this sp in kvm_mmu_pte_write() will avoid extra #PF,
>     in this case, two(or more) sps have the same gfn, there are mapped in the same
>     page table and with different kinds(unsync/sync), i thinks this case is infrequency.
>     And even we updated it, we can not sure it can be accessed latter,

If it's infrequent, the why do we optimize it?

> So, i think it's better lazily update unsync sp until it's used or the flush time,
> your opinion? :-)
>

Any performance numbers?

To me it seems saving a possible exit is worth extra computation.

-- 
error compiling committee.c: too many arguments to function

