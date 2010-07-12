Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0GLCla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:41:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53347 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab0GLCl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:41:29 -0400
Message-ID: <4C3A7FEA.6030205@cn.fujitsu.com>
Date: Mon, 12 Jul 2010 10:37:30 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/9] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C330918.6040709@cn.fujitsu.com> <4C39B81A.5080000@redhat.com>
In-Reply-To: <4C39B81A.5080000@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:

>> +    if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
>> +        gentry = 0;
>> +
>>    
> 
> That only works if the gpte is for the same mode as the current vcpu mmu
> mode.  In some cases it is too strict (vcpu in pae mode writing a 32-bit
> gpte), which is not too bad, in some cases it is too permissive (vcpu in
> nonpae mode writing a pae gpte).
> 

Avi, thanks for your review.

Do you mean that the VM has many different mode vcpu? For example, both
nonpae vcpu and pae vcpu are running in one VM? I forgot to consider this
case.

> (once upon a time mixed modes were rare, only on OS setup, but with
> nested virt they happen all the time).

I'm afraid it's still has problem, it will cause access corruption:
1: if nonpae vcpu write pae gpte, it will miss NX bit
2: if pae vcpu write nonpae gpte, it will add NX bit that over gpte's width

How about only update the shadow page which has the same pae set with the written
vcpu? Just like this:

@@ -3000,6 +3000,10 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
                while (npte--) {
                        entry = *spte;
                        mmu_pte_write_zap_pte(vcpu, sp, spte);
+
+                       if (!!is_pae(vcpu) != sp->role.cr4_pae)
+                               continue;
+
                        if (gentry)
                                mmu_pte_write_new_pte(vcpu, sp, spte, &gentry);



> 
>>       mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
>>       spin_lock(&vcpu->kvm->mmu_lock);
>>       if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
>> index dfb2720..19f0077 100644
>> --- a/arch/x86/kvm/paging_tmpl.h
>> +++ b/arch/x86/kvm/paging_tmpl.h
>> @@ -628,7 +628,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu,
>> struct kvm_mmu_page *sp,
>>           pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
>>
>>           if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa,&gpte,
>> -                      sizeof(pt_element_t)))
>> +                      sizeof(pt_element_t)) ||
>> +              is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
>>               return -EINVAL;
>>    
> 
> This is better done a few lines down where we check for
> !is_present_gpte(), no?

Yeah, it's a better way, that will avoid zap whole shadow page if reserved bits set,
will fix it.

