Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab2DTI5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:57:06 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44784 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2DTI5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:57:03 -0400
Message-ID: <4F911BCE.8030507@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 16:18:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 3/9] KVM: VMX: export PFEC.P bit on ept
References: <4F911B74.4040305@linux.vnet.ibm.com>
In-Reply-To: <4F911B74.4040305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042008-5564-0000-0000-00000247E41A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the present bit of page fault error code, the later patch
will use it

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 52f6856..2c98057 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4735,6 +4735,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification;
 	gpa_t gpa;
+	u32 error_code;
 	int gla_validity;

 	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
@@ -4759,7 +4760,13 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)

 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(gpa, exit_qualification);
-	return kvm_mmu_page_fault(vcpu, gpa, exit_qualification & 0x3, NULL, 0);
+
+	/* It is a write fault? */
+	error_code = exit_qualification & (1U << 1);
+	/* ept page table is present? */
+	error_code |= (exit_qualification >> 3) & 0x1;
+
+	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }

 static u64 ept_rsvd_mask(u64 spte, int level)
-- 
1.7.7.6

