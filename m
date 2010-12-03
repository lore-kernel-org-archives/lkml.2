Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab0LCOZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:25:40 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:53422
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527Ab0LCOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:25:36 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCUW28-02-9EY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] KVM: SVM: Implement Flush-By-Asid feature
Date: Fri, 3 Dec 2010 15:25:16 +0100
Message-ID: <1291386316-6885-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
References: <1291386316-6885-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new flush-by-asid of upcoming AMD
processors to the KVM-AMD module.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |    2 ++
 arch/x86/kvm/svm.c         |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 11dbca7..f20ff4f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -87,6 +87,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 
 #define TLB_CONTROL_DO_NOTHING 0
 #define TLB_CONTROL_FLUSH_ALL_ASID 1
+#define TLB_CONTROL_FLUSH_ASID 3
+#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
 #define V_TPR_MASK 0x0f
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b70a1e8..cdc8ab9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3093,7 +3093,6 @@ static void pre_svm_run(struct vcpu_svm *svm)
 
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 
-	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
 	/* FIXME: handle wraparound of asid_generation */
 	if (svm->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
@@ -3237,7 +3236,12 @@ static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	to_svm(vcpu)->asid_generation--;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
+		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
+	else
+		svm->asid_generation--;
 }
 
 static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
@@ -3461,6 +3465,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm->next_rip = 0;
 
+	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+
 	/* if exit due to PF check for async PF */
 	if (svm->vmcb->control.exit_code == SVM_EXIT_EXCP_BASE + PF_VECTOR)
 		svm->apf_reason = kvm_read_and_reset_pf_reason();
-- 
1.7.1


