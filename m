Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2KSX6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:58:42 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50223 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab2KSX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:58:41 -0500
Message-ID: <50AAC7A8.6010309@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2012 07:58:32 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/3] KVM: x86: clean up reexecute_instruction
References: <50AAC77C.8040505@linux.vnet.ibm.com>
In-Reply-To: <50AAC77C.8040505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111923-9264-0000-0000-000002B82BBD
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00192796; UDB=6.00043684; UTC=2012-11-19
 23:53:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
+	if (kvm_mmu_unprotect_page(vcpu->kvm, c(gpa)))
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

