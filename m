Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466Ab0LCKq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:46:29 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:38838
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224Ab0LCKqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:23 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWZ-01-H09-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/12] KVM: SVM: Add clean-bit for interrupt state
Date: Fri, 3 Dec 2010 11:45:52 +0100
Message-ID: <1291373159-4822-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the clean-bit for all interrupt
related state in the vmcb. This corresponds to vmcb offset
0x60-0x67.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8675048..b81d31a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -190,10 +190,12 @@ enum {
 			    pause filter count */
 	VMCB_PERM_MAP,   /* IOPM Base and MSRPM Base */
 	VMCB_ASID,	 /* ASID */
+	VMCB_INTR,	 /* int_ctl, int_vector */
 	VMCB_DIRTY_MAX,
 };
 
-#define VMCB_ALWAYS_DIRTY_MASK	0U
+/* TPR is always written before VMRUN */
+#define VMCB_ALWAYS_DIRTY_MASK	(1U << VMCB_INTR)
 
 static inline void mark_all_dirty(struct vmcb *vmcb)
 {
@@ -2507,6 +2509,8 @@ static int clgi_interception(struct vcpu_svm *svm)
 	svm_clear_vintr(svm);
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 
+	mark_dirty(svm->vmcb, VMCB_INTR);
+
 	return 1;
 }
 
@@ -2877,6 +2881,7 @@ static int interrupt_window_interception(struct vcpu_svm *svm)
 	kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 	svm_clear_vintr(svm);
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
+	mark_dirty(svm->vmcb, VMCB_INTR);
 	/*
 	 * If the user space waits to inject interrupts, exit as soon as
 	 * possible
@@ -3168,6 +3173,7 @@ static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
 	control->int_ctl |= V_IRQ_MASK |
 		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
+	mark_dirty(svm->vmcb, VMCB_INTR);
 }
 
 static void svm_set_irq(struct kvm_vcpu *vcpu)
-- 
1.7.1


