Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab0EEOTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:19:05 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:45101
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760161Ab0EEOTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:19:01 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzz6ff19hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1Y9S1-01-1SQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
       <stable@kernel.org>
Subject: [PATCH 3/5] KVM: SVM: Fix wrong intercept masks on 32 bit
Date: Wed, 5 May 2010 16:04:43 +0200
Message-ID: <1273068285-3105-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes KVM on 32 bit SVM working again by
correcting the masks used for iret interception. With the
wrong masks the upper 32 bits of the intercepts are masked
out which leaves vmrun unintercepted. This is not legal on
svm and the vmrun fails.
Bug was introduced by commits 95ba827313 and 3cfc3092.

Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0201b06..74f7b9d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2290,7 +2290,7 @@ static int cpuid_interception(struct vcpu_svm *svm)
 static int iret_interception(struct vcpu_svm *svm)
 {
 	++svm->vcpu.stat.nmi_window_exits;
-	svm->vmcb->control.intercept &= ~(1UL << INTERCEPT_IRET);
+	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_IRET);
 	svm->vcpu.arch.hflags |= HF_IRET_MASK;
 	return 1;
 }
@@ -2824,7 +2824,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
-	svm->vmcb->control.intercept |= (1UL << INTERCEPT_IRET);
+	svm->vmcb->control.intercept |= (1ULL << INTERCEPT_IRET);
 	++vcpu->stat.nmi_injections;
 }
 
@@ -2891,10 +2891,10 @@ static void svm_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked)
 
 	if (masked) {
 		svm->vcpu.arch.hflags |= HF_NMI_MASK;
-		svm->vmcb->control.intercept |= (1UL << INTERCEPT_IRET);
+		svm->vmcb->control.intercept |= (1ULL << INTERCEPT_IRET);
 	} else {
 		svm->vcpu.arch.hflags &= ~HF_NMI_MASK;
-		svm->vmcb->control.intercept &= ~(1UL << INTERCEPT_IRET);
+		svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_IRET);
 	}
 }
 
-- 
1.7.1


