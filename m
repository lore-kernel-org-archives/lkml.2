Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2KSX7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:59:23 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:56516 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2KSX7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:59:21 -0500
Message-ID: <50AAC7CE.2050506@linux.vnet.ibm.com>
Date: Tue, 20 Nov 2012 07:59:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
References: <50AAC77C.8040505@linux.vnet.ibm.com>
In-Reply-To: <50AAC77C.8040505@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12111923-5490-0000-0000-00000282D958
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000295; HX=3.00000198; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00192796; UDB=6.00043684; UTC=2012-11-19
 23:55:48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, reexecute_instruction refused to retry all instructions. If
nested npt is used, the emulation may be caused by shadow page, it can
be fixed by dropping the shadow page

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7be8452..5fe72cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4469,17 +4469,19 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 	return r;
 }

-static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
+static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
 {
-	gpa_t gpa;
+	gpa_t gpa = cr2;
 	pfn_t pfn;

-	if (tdp_enabled)
+	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
 		return false;

-	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
-	if (gpa == UNMAPPED_GVA)
-		return true; /* let cpu generate fault */
+	if (!vcpu->arch.mmu.direct_map) {
+		gpa = kvm_mmu_gva_to_gpa_read(vcpu, cr2, NULL);
+		if (gpa == UNMAPPED_GVA)
+			return true; /* let cpu generate fault */
+	}

 	/*
 	 * if emulation was due to access to shadowed page table
-- 
1.7.7.6

