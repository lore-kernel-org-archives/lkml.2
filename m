Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1BIRbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:31:16 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:36756 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755153Ab1BIR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:29:55 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGD1XO-02-4UO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/6] KVM: SVM: Propagate requested TSC frequency on vcpu init
Date: Wed, 9 Feb 2011 18:29:42 +0100
Message-ID: <1297272584-22689-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
References: <1297272584-22689-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the propagation of the VM
virtual_tsc_khz into each vcpu data-structure to enable the
tsc-scaling feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f51f757..29833a7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -879,6 +879,35 @@ static u64 svm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
 	return _tsc;
 }
 
+static bool svm_vcpu_init_tsc(struct kvm *kvm, struct vcpu_svm *svm)
+{
+	u64 raw_tsc, tsc, new_tsc;
+	u64 ratio;
+	u64 khz;
+
+	/* TSC scaling supported? */
+	if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR))
+		goto out;
+
+	/* Guest tsc same frequency as host tsc? */
+	if (kvm->arch.virtual_tsc_khz == tsc_khz)
+		goto out;
+
+	khz = kvm->arch.virtual_tsc_khz;
+
+	/* TSC scaling required  - calculate ratio */
+	ratio = khz << 32;
+	do_div(ratio, tsc_khz);
+	if (ratio == 0 || ratio & TSC_RATIO_RSVD)
+		return false;
+
+	svm->tsc_scale.ratio   = ratio;
+	svm->tsc_scale.enabled = true;
+
+out:
+	return true;
+}
+
 static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1084,6 +1113,9 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (err)
 		goto free_svm;
 
+	if (!svm_vcpu_init_tsc(kvm, svm))
+		goto uninit;
+
 	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
-- 
1.7.1


