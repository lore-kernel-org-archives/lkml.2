Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2K1WHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:07:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab2K1WHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:07:05 -0500
Date: Wed, 28 Nov 2012 20:07:00 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
Message-ID: <20121128220700.GB10039@amt.cnet>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7CE.2050506@linux.vnet.ibm.com>
 <20121126223712.GA10634@amt.cnet>
 <50B42FC7.2080805@linux.vnet.ibm.com>
 <20121127233246.GB8295@amt.cnet>
 <50B581C1.2050406@linux.vnet.ibm.com>
 <20121128140155.GH928@redhat.com>
 <50B625DE.5070001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B625DE.5070001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:55:26PM +0800, Xiao Guangrong wrote:
> On 11/28/2012 10:01 PM, Gleb Natapov wrote:
> > On Wed, Nov 28, 2012 at 11:15:13AM +0800, Xiao Guangrong wrote:
> >> On 11/28/2012 07:32 AM, Marcelo Tosatti wrote:
> >>> On Tue, Nov 27, 2012 at 11:13:11AM +0800, Xiao Guangrong wrote:
> >>>>>> +static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
> >>>>>>  {
> >>>>>> -	gpa_t gpa;
> >>>>>> +	gpa_t gpa = cr2;
> >>>>>>  	pfn_t pfn;
> >>>>>>
> >>>>>> -	if (tdp_enabled)
> >>>>>> +	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> >>>>>>  		return false;
> >>>>>
> >>>>> How is indirect_shadow_pages protected? Why is ACCESS_ONCE() being used
> >>>>> to read it?
> >>>>
> >>>> Hi Marcelo,
> >>>>
> >>>> It is protected by mmu-lock for it only be changed when mmu-lock is hold. And
> >>>> ACCESS_ONCE is used on read path avoiding magic optimization from compiler.
> >>>
> >>> Please switch to mmu_lock protection, there is no reason to have access
> >>> to this variable locklessly - not performance critical.
> >>>
> >>> For example, there is no use of barriers when modifying the variable.
> >>
> >> This is not bad, the worst case is, the direct mmu failed to unprotect the shadow
> >> pages, (meet indirect_shadow_pages = 0, but there has shadow pages being shadowed.),
> >> after enter to guest, we will go into reexecute_instruction again, then it will
> >> remove shadow pages.
> >>
> > Isn't the same scenario can happen even with mmu lock around
> > indirect_shadow_pages access?
> 
> Hmm..., i also think it is no different. Even using mmu-lock, we can not
> prevent the target pfn can not be write-protected later. Marcelo?

In this particular case, it appears to be harmless (unsure if
kvm_mmu_pte_write one is safe). The point is, lockless access should not
be special.

Lockless access must be carefully documented (access protocol to
variables documented, all possible cases listed), and done when
necessary due to performance. Otherwise, don't do it.

On this case, its not necessary.

