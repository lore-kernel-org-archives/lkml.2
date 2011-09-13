Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1IMSVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:21:51 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59991 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab1IMSVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:21:49 -0400
Message-ID: <4E6F9FD2.4010407@cn.fujitsu.com>
Date: Wed, 14 Sep 2011 02:24:18 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 03/11] KVM: x86: retry non-page-table writing instruction
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C5C.8030602@cn.fujitsu.com> <4E6F34CF.1060302@redhat.com>
In-Reply-To: <4E6F34CF.1060302@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-14 02:20:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-14 02:20:35
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 06:47 PM, Avi Kivity wrote:
> On 08/30/2011 05:35 AM, Xiao Guangrong wrote:
>> If the emulation is caused by #PF and it is non-page_table writing instruction,
>> it means the VM-EXIT is caused by shadow page protected, we can zap the shadow
>> page and retry this instruction directly
>>
>> The idea is from Avi
>>
>>
>>   int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len);
>> +bool page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
> 
> Please use the usual x86_ prefix used in the emulator interface.
> 

OK, will fix.

>> @@ -3720,10 +3721,18 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
>>       kvm_mmu_commit_zap_page(vcpu->kvm,&invalid_list);
>>   }
>>
>> +static bool is_mmio_page_fault(struct kvm_vcpu *vcpu, gva_t addr)
>> +{
>> +    if (vcpu->arch.mmu.direct_map || mmu_is_nested(vcpu))
>> +        return vcpu_match_mmio_gpa(vcpu, addr);
>> +
>> +    return vcpu_match_mmio_gva(vcpu, addr);
>> +}
>> +
>>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>>                  void *insn, int insn_len)
>>   {
>> -    int r;
>> +    int r, emulation_type = EMULTYPE_RETRY;
>>       enum emulation_result er;
>>
>>       r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
>> @@ -3735,7 +3744,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>>           goto out;
>>       }
>>
>> -    er = x86_emulate_instruction(vcpu, cr2, 0, insn, insn_len);
>> +    if (is_mmio_page_fault(vcpu, cr2))
>> +        emulation_type = 0;
>> +
>> +    er = x86_emulate_instruction(vcpu, cr2, emulation_type, insn, insn_len);
>>
>>       switch (er) {
>>       case EMULATE_DONE:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6b37f18..1afe59e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4814,6 +4814,50 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>>       return false;
>>   }
>>
>> +static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>> +                  unsigned long cr2,  int emulation_type)
>> +{
>> +    if (!vcpu->arch.mmu.direct_map&&  !mmu_is_nested(vcpu))
>> +        gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> 
> If mmu_is_nested() cr2 is an ngpa, we have to translate it to a gpa, no?
> 

Yeah, will fix it.

And this bug also exists in the current code: it always uses L2 gpa to emulate
write operation.
I guess the reason that it is not triggered is: the gpa of L2's shadow page can
not be touched by L2, it means no page table is write-protected by L2.

> btw, I don't see mmu.direct_map initialized for nested npt?
> 

nested_svm_vmrun() -> nested_svm_init_mmu_context():
static int nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
{
	int r;

	r = kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);

	vcpu->arch.mmu.set_cr3           = nested_svm_set_tdp_cr3;
	vcpu->arch.mmu.get_cr3           = nested_svm_get_tdp_cr3;
	vcpu->arch.mmu.get_pdptr         = nested_svm_get_tdp_pdptr;
	vcpu->arch.mmu.inject_page_fault = nested_svm_inject_npf_exit;
	vcpu->arch.mmu.shadow_root_level = get_npt_level();
	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;

	return r;
}

It is initialized in kvm_init_shadow_mmu　:-)
