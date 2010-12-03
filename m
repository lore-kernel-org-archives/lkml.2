Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab0LCKqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 05:46:23 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:13223
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757129Ab0LCKqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 05:46:21 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCULWX-02-1ES-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/12] KVM: SVM: Add clean-bit for intercetps, tsc-offset and pause filter count
Date: Fri, 3 Dec 2010 11:45:49 +0100
Message-ID: <1291373159-4822-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the clean-bit for intercepts-vectors, the
TSC offset and the pause-filter count to the appropriate
places. The IO and MSR permission bitmaps are not subject to
this bit.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3ee59b0..d8058c9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -186,6 +186,8 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
 
 enum {
+	VMCB_INTERCEPTS, /* Intercept vectors, TSC offset,
+			    pause filter count */
 	VMCB_DIRTY_MAX,
 };
 
@@ -217,6 +219,8 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	struct vmcb_control_area *c, *h;
 	struct nested_state *g;
 
+	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
+
 	if (!is_guest_mode(&svm->vcpu))
 		return;
 
@@ -854,6 +858,8 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	}
 
 	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
+
+	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
 static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
@@ -863,6 +869,7 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
 	svm->vmcb->control.tsc_offset += adjustment;
 	if (is_guest_mode(vcpu))
 		svm->nested.hsave->control.tsc_offset += adjustment;
+	mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
 }
 
 static void init_vmcb(struct vcpu_svm *svm)
-- 
1.7.1


