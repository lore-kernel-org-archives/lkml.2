Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0LGQPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:15:47 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:15155
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564Ab0LGQPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:15:43 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LD2FTY-01-XMW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 1/2] KVM: SVM: Do not report xsave in supported cpuid
Date: Tue, 7 Dec 2010 17:15:05 +0100
Message-ID: <1291738506-16278-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101207161211.GD13125@amd.com>
References: <20101207161211.GD13125@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support xsave properly for the guest the SVM module need
software support for it. As long as this is not present do
not report the xsave as supported feature in cpuid.
As a side-effect this patch moves the bit() helper function
into the x86.h file so that it can be used in svm.c too.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    4 ++++
 arch/x86/kvm/vmx.c |    5 -----
 arch/x86/kvm/x86.c |    5 -----
 arch/x86/kvm/x86.h |    5 +++++
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ae943bb..8aeda9f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3556,6 +3556,10 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
+	case 0x00000001:
+		/* Mask out xsave bit as long as it is not supported by SVM */
+		entry->ecx &= ~(bit(X86_FEATURE_XSAVE));
+		break;
 	case 0x80000001:
 		if (nested)
 			entry->ecx |= (1 << 2); /* Set SVM bit */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 72cfdb7..f3693ca 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4247,11 +4247,6 @@ static int vmx_get_lpage_level(void)
 		return PT_PDPE_LEVEL;
 }
 
-static inline u32 bit(int bitno)
-{
-	return 1 << (bitno & 31);
-}
-
 static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed373ba..a85a989 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -163,11 +163,6 @@ static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 		vcpu->arch.apf.gfns[i] = ~0;
 }
 
-static inline u32 bit(int bitno)
-{
-	return 1 << (bitno & 31);
-}
-
 static void kvm_on_user_return(struct user_return_notifier *urn)
 {
 	unsigned slot;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2cea414..c600da8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -70,6 +70,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 }
 
+static inline u32 bit(int bitno)
+{
+	return 1 << (bitno & 31);
+}
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq);
-- 
1.7.1


