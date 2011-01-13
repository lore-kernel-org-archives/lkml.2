Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab1AMPXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 10:23:19 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58156 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757104Ab1AMPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 10:23:08 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEYW2B-02-9KW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: SVM: Add support for perf-kvm
Date: Thu, 13 Jan 2011 16:22:58 +0100
Message-ID: <1294932178-26866-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
References: <1294932178-26866-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary code to run perf-kvm on AMD
machines.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8b9bc72..2415129 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3646,13 +3646,21 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	local_irq_disable();
 
-	stgi();
-
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
 	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
+	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
+		kvm_before_handle_nmi(&svm->vcpu);
+
+	stgi();
+
+	/* Any pending NMI will happen here */
+
+	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
+		kvm_after_handle_nmi(&svm->vcpu);
+
 	sync_cr8_to_lapic(vcpu);
 
 	svm->next_rip = 0;
-- 
1.7.1


