Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0IFP6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:58:02 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25080
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab0IFP53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:29 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-01-D1D-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/27] KVM: MMU: Add infrastructure for two-level page walker
Date: Mon, 6 Sep 2010 17:55:49 +0200
Message-ID: <1283788566-29186-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a mmu-callback to translate gpa
addresses in the walk_addr code. This is later used to
translate l2_gpa addresses into l1_gpa addresses.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    6 ++++++
 include/linux/kvm_host.h        |    5 +++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3fefcd8..af8cce3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -245,6 +245,7 @@ struct kvm_mmu {
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    u32 *error);
+	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error);
 	void (*prefetch_page)(struct kvm_vcpu *vcpu,
 			      struct kvm_mmu_page *page);
 	int (*sync_page)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f47db25..829efb0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3433,6 +3433,11 @@ void kvm_get_segment(struct kvm_vcpu *vcpu,
 	kvm_x86_ops->get_segment(vcpu, var, seg);
 }
 
+static gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 *error)
+{
+	return gpa;
+}
+
 gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva, u32 *error)
 {
 	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
@@ -5644,6 +5649,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.emulate_ctxt.ops = &emulate_ops;
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
+	vcpu->arch.mmu.translate_gpa = translate_gpa;
 	if (!irqchip_in_kernel(kvm) || kvm_vcpu_is_bsp(vcpu))
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 	else
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f2ecdd5..f2989a7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -534,6 +534,11 @@ static inline gpa_t gfn_to_gpa(gfn_t gfn)
 	return (gpa_t)gfn << PAGE_SHIFT;
 }
 
+static inline gfn_t gpa_to_gfn(gpa_t gpa)
+{
+	return (gfn_t)gpa >> PAGE_SHIFT;
+}
+
 static inline hpa_t pfn_to_hpa(pfn_t pfn)
 {
 	return (hpa_t)pfn << PAGE_SHIFT;
-- 
1.7.0.4


