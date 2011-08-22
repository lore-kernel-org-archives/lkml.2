Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1HVUCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:02:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab1HVUCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:02:10 -0400
Date: Mon, 22 Aug 2011 16:59:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/11] KVM: x86: retry non-page-table writing instruction
Message-ID: <20110822195929.GA2662@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A113F.5090404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4A113F.5090404@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 02:42:07PM +0800, Xiao Guangrong wrote:
> If the emulation is caused by #PF and it is non-page_table writing instruction,
> it means the VM-EXIT is caused by shadow page protected, we can zap the shadow
> page and retry this instruction directly
> 
> The idea is from Avi
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_emulate.h |    1 +
>  arch/x86/include/asm/kvm_host.h    |    5 +++
>  arch/x86/kvm/emulate.c             |    5 +++
>  arch/x86/kvm/mmu.c                 |   22 +++++++++++---
>  arch/x86/kvm/x86.c                 |   53 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 81 insertions(+), 5 deletions(-)
> 
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4814,6 +4814,56 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>  	return false;
>  }
>  
> +static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> +			      unsigned long cr2,  int emulation_type)
> +{
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +	unsigned long last_retry_eip, last_retry_addr, gpa = cr2;
> +
> +	last_retry_eip = vcpu->arch.last_retry_eip;
> +	last_retry_addr = vcpu->arch.last_retry_addr;
> +
> +	/*
> +	 * If the emulation is caused by #PF and it is non-page_table
> +	 * writing instruction, it means the VM-EXIT is caused by shadow
> +	 * page protected, we can zap the shadow page and retry this
> +	 * instruction directly.
> +	 *
> +	 * Note: if the guest uses a non-page-table modifying instruction
> +	 * on the PDE that points to the instruction, then we will unmap
> +	 * the instruction and go to an infinite loop. So, we cache the
> +	 * last retried eip and the last fault address, if we meet the eip
> +	 * and the address again, we can break out of the potential infinite
> +	 * loop.
> +	 */
> +	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
> +
> +	if (!(emulation_type & EMULTYPE_RETRY))
> +		return false;
> +
> +	if (page_table_writing_insn(ctxt))
> +		return false;
> +
> +	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2)
> +		return false;
> +
> +	vcpu->arch.last_retry_eip = ctxt->eip;
> +	vcpu->arch.last_retry_addr = cr2;
> +
> +	if (!vcpu->arch.mmu.direct_map && !mmu_is_nested(vcpu))
> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);

Why write? 

> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +
> +	/*
> +	 * The shadow pages have been zapped, then we call the page
> +	 * fault path to change the mapping to writable.
> +	 */
> +	vcpu->arch.mmu.page_fault(vcpu, cr2, PFERR_WRITE_MASK, true);

I don't see why is this necessary. Just allowing the instruction to
proceed should be enough?

Looks good otherwise.
