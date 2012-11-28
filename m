Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab2K1OC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:02:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab2K1OC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:02:57 -0500
Date: Wed, 28 Nov 2012 16:01:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
Message-ID: <20121128140155.GH928@redhat.com>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7CE.2050506@linux.vnet.ibm.com>
 <20121126223712.GA10634@amt.cnet>
 <50B42FC7.2080805@linux.vnet.ibm.com>
 <20121127233246.GB8295@amt.cnet>
 <50B581C1.2050406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B581C1.2050406@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 11:15:13AM +0800, Xiao Guangrong wrote:
> On 11/28/2012 07:32 AM, Marcelo Tosatti wrote:
> > On Tue, Nov 27, 2012 at 11:13:11AM +0800, Xiao Guangrong wrote:
> >>>> +static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
> >>>>  {
> >>>> -	gpa_t gpa;
> >>>> +	gpa_t gpa = cr2;
> >>>>  	pfn_t pfn;
> >>>>
> >>>> -	if (tdp_enabled)
> >>>> +	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> >>>>  		return false;
> >>>
> >>> How is indirect_shadow_pages protected? Why is ACCESS_ONCE() being used
> >>> to read it?
> >>
> >> Hi Marcelo,
> >>
> >> It is protected by mmu-lock for it only be changed when mmu-lock is hold. And
> >> ACCESS_ONCE is used on read path avoiding magic optimization from compiler.
> > 
> > Please switch to mmu_lock protection, there is no reason to have access
> > to this variable locklessly - not performance critical.
> > 
> > For example, there is no use of barriers when modifying the variable.
> 
> This is not bad, the worst case is, the direct mmu failed to unprotect the shadow
> pages, (meet indirect_shadow_pages = 0, but there has shadow pages being shadowed.),
> after enter to guest, we will go into reexecute_instruction again, then it will
> remove shadow pages.
> 
Isn't the same scenario can happen even with mmu lock around
indirect_shadow_pages access?

> But, i do not have strong opinion on it, i respect your idea! :)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
