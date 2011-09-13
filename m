Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1IMKr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 06:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1IMKry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 06:47:54 -0400
Message-ID: <4E6F34CF.1060302@redhat.com>
Date: Tue, 13 Sep 2011 13:47:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 03/11] KVM: x86: retry non-page-table writing instruction
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C5C.8030602@cn.fujitsu.com>
In-Reply-To: <4E5C4C5C.8030602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 05:35 AM, Xiao Guangrong wrote:
> If the emulation is caused by #PF and it is non-page_table writing instruction,
> it means the VM-EXIT is caused by shadow page protected, we can zap the shadow
> page and retry this instruction directly
>
> The idea is from Avi
>
>
>   int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len);
> +bool page_table_writing_insn(struct x86_emulate_ctxt *ctxt);

Please use the usual x86_ prefix used in the emulator interface.

> @@ -3720,10 +3721,18 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
>   	kvm_mmu_commit_zap_page(vcpu->kvm,&invalid_list);
>   }
>
> +static bool is_mmio_page_fault(struct kvm_vcpu *vcpu, gva_t addr)
> +{
> +	if (vcpu->arch.mmu.direct_map || mmu_is_nested(vcpu))
> +		return vcpu_match_mmio_gpa(vcpu, addr);
> +
> +	return vcpu_match_mmio_gva(vcpu, addr);
> +}
> +
>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>   		       void *insn, int insn_len)
>   {
> -	int r;
> +	int r, emulation_type = EMULTYPE_RETRY;
>   	enum emulation_result er;
>
>   	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
> @@ -3735,7 +3744,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>   		goto out;
>   	}
>
> -	er = x86_emulate_instruction(vcpu, cr2, 0, insn, insn_len);
> +	if (is_mmio_page_fault(vcpu, cr2))
> +		emulation_type = 0;
> +
> +	er = x86_emulate_instruction(vcpu, cr2, emulation_type, insn, insn_len);
>
>   	switch (er) {
>   	case EMULATE_DONE:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6b37f18..1afe59e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4814,6 +4814,50 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>   	return false;
>   }
>
> +static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> +			      unsigned long cr2,  int emulation_type)
> +{
> +	if (!vcpu->arch.mmu.direct_map&&  !mmu_is_nested(vcpu))
> +		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);

If mmu_is_nested() cr2 is an ngpa, we have to translate it to a gpa, no?

btw, I don't see mmu.direct_map initialized for nested npt?

> +
> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa>>  PAGE_SHIFT);
> +
> +	return true;
> +}
> +
>   int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>   			    unsigned long cr2,
>   			    int emulation_type,
> @@ -4855,6 +4899,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>   		return EMULATE_DONE;
>   	}
>
> +	if (retry_instruction(ctxt, cr2, emulation_type))
> +		return EMULATE_DONE;
> +
>   	/* this is needed for vmware backdoor interface to work since it
>   	   changes registers values  during IO operation */
>   	if (vcpu->arch.emulate_regs_need_sync_from_vcpu) {


-- 
error compiling committee.c: too many arguments to function

