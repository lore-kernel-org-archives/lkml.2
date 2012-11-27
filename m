Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2K0Xmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:42:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2K0Xmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:42:54 -0500
Date: Tue, 27 Nov 2012 21:32:46 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
Message-ID: <20121127233246.GB8295@amt.cnet>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7CE.2050506@linux.vnet.ibm.com>
 <20121126223712.GA10634@amt.cnet>
 <50B42FC7.2080805@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B42FC7.2080805@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 11:13:11AM +0800, Xiao Guangrong wrote:
> >> +static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
> >>  {
> >> -	gpa_t gpa;
> >> +	gpa_t gpa = cr2;
> >>  	pfn_t pfn;
> >>
> >> -	if (tdp_enabled)
> >> +	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
> >>  		return false;
> > 
> > How is indirect_shadow_pages protected? Why is ACCESS_ONCE() being used
> > to read it?
> 
> Hi Marcelo,
> 
> It is protected by mmu-lock for it only be changed when mmu-lock is hold. And
> ACCESS_ONCE is used on read path avoiding magic optimization from compiler.

Please switch to mmu_lock protection, there is no reason to have access
to this variable locklessly - not performance critical.

For example, there is no use of barriers when modifying the variable.

