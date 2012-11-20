Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2KTUNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:13:13 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36893 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2KTUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:13:12 -0500
Message-ID: <50ABE44E.9090307@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2012 04:13:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: x86: clean up reexecute_instruction
References: <50AAC77C.8040505@linux.vnet.ibm.com> <50AAC7A8.6010309@linux.vnet.ibm.com> <20121120121151.GH21208@redhat.com>
In-Reply-To: <20121120121151.GH21208@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112020-8256-0000-0000-0000051AF442
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 08:11 PM, Gleb Natapov wrote:
> On Tue, Nov 20, 2012 at 07:58:32AM +0800, Xiao Guangrong wrote:
>> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
>> retry_instruction
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/x86.c |   13 ++++++-------
>>  1 files changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 52ae8b5..7be8452 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4477,19 +4477,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>>  	if (tdp_enabled)
>>  		return false;
>>
>> +	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
>> +	if (gpa == UNMAPPED_GVA)
>> +		return true; /* let cpu generate fault */
>> +
>>  	/*
>>  	 * if emulation was due to access to shadowed page table
>>  	 * and it failed try to unshadow page and re-enter the
>>  	 * guest to let CPU execute the instruction.
>>  	 */
>> -	if (kvm_mmu_unprotect_page_virt(vcpu, gva))
>> +	if (kvm_mmu_unprotect_page(vcpu->kvm, c(gpa)))
> What's c()? Should be gpa_to_gfn(gpa)?

Yes. It is the stupid copy-paste error. Thanks you for pointing it out, Gleb!
This is the new one have fixed it.

Subject: [PATCH 1/3] KVM: x86: clean up reexecute_instruction

Little cleanup for reexecute_instruction, also use gpa_to_gfn in
retry_instruction

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 52ae8b5..7be8452 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4477,19 +4477,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 	if (tdp_enabled)
 		return false;

+	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
+	if (gpa == UNMAPPED_GVA)
+		return true; /* let cpu generate fault */
+
 	/*
 	 * if emulation was due to access to shadowed page table
 	 * and it failed try to unshadow page and re-enter the
 	 * guest to let CPU execute the instruction.
 	 */
-	if (kvm_mmu_unprotect_page_virt(vcpu, gva))
+	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
 		return true;

-	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
-
-	if (gpa == UNMAPPED_GVA)
-		return true; /* let cpu generate fault */
-
 	/*
 	 * Do not retry the unhandleable instruction if it faults on the
 	 * readonly host memory, otherwise it will goto a infinite loop:
@@ -4544,7 +4543,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	if (!vcpu->arch.mmu.direct_map)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);

-	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));

 	return true;
 }
-- 
1.7.7.6


