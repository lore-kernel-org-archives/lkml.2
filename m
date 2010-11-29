Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0K2Pii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:38:38 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:2156 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab0K2Pig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:38:36 -0500
X-SpamScore: 5
X-BigFish: VPS5(z1039ozbb2cKzz1202hzz8275bhz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCNKS3-01-73V-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] KVM: X86: Introduce generic guest-mode representation
Date: Mon, 29 Nov 2010 16:38:08 +0100
Message-ID: <1291045090-2714-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
References: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a generic representation of guest-mode
fpr a vcpu. This currently only exists in the SVM code.
Having this representation generic will help making the
non-svm code aware of nesting when this is necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/kvm_cache_regs.h   |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 54e42c8..d2a66be 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -784,6 +784,7 @@ enum {
 #define HF_VINTR_MASK		(1 << 2)
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
+#define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
 
 /*
  * Hardware virtualization extension instructions may fault if a
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 975bb45..7e7c52d 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -84,4 +84,19 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
 		| ((u64)(kvm_register_read(vcpu, VCPU_REGS_RDX) & -1u) << 32);
 }
 
+static inline void kvm_vcpu_enter_gm(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hflags |= HF_GUEST_MASK;
+}
+
+static inline void kvm_vcpu_leave_gm(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hflags &= ~HF_GUEST_MASK;
+}
+
+static inline bool kvm_vcpu_is_gm(struct kvm_vcpu *vcpu)
+{
+	return !!(vcpu->arch.hflags & HF_GUEST_MASK);
+}
+
 #endif
-- 
1.7.1


