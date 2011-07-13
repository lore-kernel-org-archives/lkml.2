Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab1GMPdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:33:19 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:55350 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1GMPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:33:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37B-01-0C5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/7] KVM: SVM: Keep seperate pointer to host-vmcb
Date: Wed, 13 Jul 2011 17:32:19 +0200
Message-ID: <1310571145-28930-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joro@8bytes.org>

This patch introduces a new pointer which always points to
the VMCB used for running the L1 guest.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/svm.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 475d1c9..3d5990f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -113,7 +113,9 @@ static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
+	struct vmcb *host_vmcb;
 	unsigned long vmcb_pa;
+	unsigned long host_vmcb_pa;
 	struct svm_cpu_data *svm_data;
 	uint64_t asid_generation;
 	uint64_t sysenter_esp;
@@ -1171,9 +1173,11 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
 	svm_vcpu_init_msrpm(svm->nested.msrpm);
 
-	svm->vmcb = page_address(page);
+	svm->host_vmcb = page_address(page);
+	svm->vmcb = svm->host_vmcb;
 	clear_page(svm->vmcb);
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
+	svm->host_vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	svm->asid_generation = 0;
 	init_vmcb(svm);
 	kvm_write_tsc(&svm->vcpu, 0);
-- 
1.7.4.1


