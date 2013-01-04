Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab3ADW2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab3ADW15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:27:57 -0500
Date: Fri, 4 Jan 2013 20:21:35 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] KVM: x86: clean up reexecute_instruction
Message-ID: <20130104222135.GA13481@amt.cnet>
References: <50E6DEDC.7040800@linux.vnet.ibm.com>
 <50E6DF5C.2000103@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E6DF5C.2000103@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 09:55:40PM +0800, Xiao Guangrong wrote:
> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
> retry_instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1c9c834..ad39018 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4761,19 +4761,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>  	if (tdp_enabled)
>  		return false;
> 
> +	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
> +	if (gpa == UNMAPPED_GVA)
> +		return true; /* let cpu generate fault */
> +

Why change from _system to _read here? Purely cleanup patch should
have no logical changes.

BTW, there is not much logic in using reexecute_instruction() at
for x86_decode_insn (checks in reexecute_instruction() assume 
write to the cr2, for instance).
Fault propagation for x86_decode_insn seems completly broken
(which is perhaps why reexecute_instruction() there survived).

>  	/*
>  	 * if emulation was due to access to shadowed page table
>  	 * and it failed try to unshadow page and re-enter the
>  	 * guest to let CPU execute the instruction.
>  	 */
> -	if (kvm_mmu_unprotect_page_virt(vcpu, gva))
> +	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
>  		return true;
> 
> -	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
> -
> -	if (gpa == UNMAPPED_GVA)
> -		return true; /* let cpu generate fault */
> -
>  	/*
>  	 * Do not retry the unhandleable instruction if it faults on the
>  	 * readonly host memory, otherwise it will goto a infinite loop:
> @@ -4828,7 +4827,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	if (!vcpu->arch.mmu.direct_map)
>  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> 
> -	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> 
>  	return true;
>  }
> -- 
> 1.7.7.6
