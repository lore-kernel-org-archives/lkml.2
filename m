Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab0D0Kmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:42:46 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:59235 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0D0Kix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:53 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WG-02-NOO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/22] KVM: SVM: Implement MMU helper functions for Nested Nested Paging
Date: Tue, 27 Apr 2010 12:38:17 +0200
Message-ID: <1272364712-17425-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0761 (UTC) FILETIME=[CA522610:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the helper functions which will be used in
the mmu context for handling nested nested page faults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4aae4be..e31f601 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -92,6 +92,9 @@ struct nested_state {
 	u32 intercept_exceptions;
 	u64 intercept;
 
+	/* Nested Paging related state */
+	u64 nested_cr3;
+
 };
 
 #define MSRPM_OFFSETS	16
@@ -1490,6 +1493,36 @@ static int vmmcall_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return svm->nested.nested_cr3;
+}
+
+static void nested_svm_set_tdp_cr3(struct kvm_vcpu *vcpu,
+				   unsigned long root)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.nested_cr3 = root;
+	force_new_asid(vcpu);
+}
+
+static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
+				       unsigned long addr,
+				       u32 error_code)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.exit_code = SVM_EXIT_NPF;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1 = error_code;
+	svm->vmcb->control.exit_info_2 = addr;
+
+	nested_svm_vmexit(svm);
+}
+
 static int nested_svm_check_permissions(struct vcpu_svm *svm)
 {
 	if (!(svm->vcpu.arch.efer & EFER_SVME)
-- 
1.7.0.4


