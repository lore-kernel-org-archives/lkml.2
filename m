Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2JQFsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 01:48:23 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60292 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab2JQFsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 01:48:21 -0400
Message-ID: <507E4696.7020007@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 13:48:06 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/2] KVM: VMX: report internal error for MMIO #PF due to delivery
 event
References: <507E464C.3010108@linux.vnet.ibm.com>
In-Reply-To: <507E464C.3010108@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12101705-9574-0000-0000-000004E57EFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The #PF with PFEC.RSV = 1 indicates that the guest is accessing MMIO, we
can not fix it if it is caused by delivery event. Reporting internal error
for this case

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/vmx.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b8a0841..6599e45 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4287,16 +4287,6 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 	if (is_machine_check(intr_info))
 		return handle_machine_check(vcpu);

-	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
-	    !is_page_fault(intr_info)) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_SIMUL_EX;
-		vcpu->run->internal.ndata = 2;
-		vcpu->run->internal.data[0] = vect_info;
-		vcpu->run->internal.data[1] = intr_info;
-		return 0;
-	}
-
 	if ((intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR)
 		return 1;  /* already handled by vmx_vcpu_run() */

@@ -4315,6 +4305,22 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 	error_code = 0;
 	if (intr_info & INTR_INFO_DELIVER_CODE_MASK)
 		error_code = vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
+
+	/*
+	 * The #PF with PFEC.RSVD = 1 indicates the guest is accessing
+	 * MMIO, it is better to report an internal error.
+	 * See the comments in vmx_handle_exit.
+	 */
+	if ((vect_info & VECTORING_INFO_VALID_MASK) &&
+	    !(is_page_fault(intr_info) && !(error_code & PFERR_RSVD_MASK))) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_SIMUL_EX;
+		vcpu->run->internal.ndata = 2;
+		vcpu->run->internal.data[0] = vect_info;
+		vcpu->run->internal.data[1] = intr_info;
+		return 0;
+	}
+
 	if (is_page_fault(intr_info)) {
 		/* EPT won't cause page fault directly */
 		BUG_ON(enable_ept);
-- 
1.7.7.6

