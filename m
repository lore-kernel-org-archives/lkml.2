Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0IFP7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:59:32 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:43233
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754770Ab0IFP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:58:28 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-02-7A0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 24/27] KVM: SVM: Implement MMU helper functions for Nested Nested Paging
Date: Mon, 6 Sep 2010 17:56:03 +0200
Message-ID: <1283788566-29186-25-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the helper functions which will be used in
the mmu context for handling nested nested page faults.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a98ac52..6e72ba9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -104,6 +104,8 @@ struct nested_state {
 	u32 intercept_exceptions;
 	u64 intercept;
 
+	/* Nested Paging related state */
+	u64 nested_cr3;
 };
 
 #define MSRPM_OFFSETS	16
@@ -1600,6 +1602,36 @@ static int vmmcall_interception(struct vcpu_svm *svm)
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


