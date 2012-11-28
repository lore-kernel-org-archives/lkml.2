Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2K1OMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:12:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab2K1OMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:12:54 -0500
Date: Wed, 28 Nov 2012 16:12:30 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: x86: improve reexecute_instruction
Message-ID: <20121128141230.GI928@redhat.com>
References: <50AAC77C.8040505@linux.vnet.ibm.com>
 <50AAC7F9.7050305@linux.vnet.ibm.com>
 <20121126224105.GB10634@amt.cnet>
 <50B433D0.8060107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B433D0.8060107@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 11:30:24AM +0800, Xiao Guangrong wrote:
> On 11/27/2012 06:41 AM, Marcelo Tosatti wrote:
> 
> >>
> >> -	return false;
> >> +again:
> >> +	page_fault_count = ACCESS_ONCE(vcpu->kvm->arch.page_fault_count);
> >> +
> >> +	/*
> >> +	 * if emulation was due to access to shadowed page table
> >> +	 * and it failed try to unshadow page and re-enter the
> >> +	 * guest to let CPU execute the instruction.
> >> +	 */
> >> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> >> +	emulate = vcpu->arch.mmu.page_fault(vcpu, cr3, PFERR_WRITE_MASK, false);
> > 
> > Can you explain what is the objective here?
> > 
> 
> Sure. :)
> 
> The instruction emulation is caused by fault access on cr3. After unprotect
> the target page, we call vcpu->arch.mmu.page_fault to fix the mapping of cr3.
> if it return 1, mmu can not fix the mapping, we should report the error,
> otherwise it is good to return to guest and let it re-execute the instruction
> again.
> 
> page_fault_count is used to avoid the race on other vcpus, since after we
> unprotect the target page, other cpu can enter page fault path and let the
> page be write-protected again.
> 
> This way can help us to detect all the case that mmu can not be fixed.
> 
Can you write this in a comment above vcpu->arch.mmu.page_fault()?

--
			Gleb.
