Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1INJx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 05:53:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755127Ab1INJx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 05:53:26 -0400
Message-ID: <4E707991.10705@redhat.com>
Date: Wed, 14 Sep 2011 12:53:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 03/11] KVM: x86: retry non-page-table writing instruction
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C5C.8030602@cn.fujitsu.com> <4E6F34CF.1060302@redhat.com> <4E6F9FD2.4010407@cn.fujitsu.com>
In-Reply-To: <4E6F9FD2.4010407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 09:24 PM, Xiao Guangrong wrote:
> >>
> >>  +static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
> >>  +                  unsigned long cr2,  int emulation_type)
> >>  +{
> >>  +    if (!vcpu->arch.mmu.direct_map&&   !mmu_is_nested(vcpu))
> >>  +        gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> >
> >  If mmu_is_nested() cr2 is an ngpa, we have to translate it to a gpa, no?
> >
>
> Yeah, will fix it.
>
> And this bug also exists in the current code: it always uses L2 gpa to emulate
> write operation.

Can you please send this fix separately, so it can be backported if needed?

> I guess the reason that it is not triggered is: the gpa of L2's shadow page can
> not be touched by L2, it means no page table is write-protected by L2.

Yes.  All real guest hypervisors will do that.  But it is technically 
possible for a hypervisor to allow its guest access to the real page tables.

> >  btw, I don't see mmu.direct_map initialized for nested npt?
> >
>
> nested_svm_vmrun() ->  nested_svm_init_mmu_context():
> static int nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
> {
> 	int r;
>
> 	r = kvm_init_shadow_mmu(vcpu,&vcpu->arch.mmu);
>
> 	vcpu->arch.mmu.set_cr3           = nested_svm_set_tdp_cr3;
> 	vcpu->arch.mmu.get_cr3           = nested_svm_get_tdp_cr3;
> 	vcpu->arch.mmu.get_pdptr         = nested_svm_get_tdp_pdptr;
> 	vcpu->arch.mmu.inject_page_fault = nested_svm_inject_npf_exit;
> 	vcpu->arch.mmu.shadow_root_level = get_npt_level();
> 	vcpu->arch.walk_mmu              =&vcpu->arch.nested_mmu;
>
> 	return r;
> }
>
> It is initialized in kvm_init_shadow_mmu　:-)

Yes, need new eyeglasses.

-- 
error compiling committee.c: too many arguments to function

