Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0IJPeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:34:21 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:43632 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab0IJPdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:33:04 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF42-01-7OW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/29] KVM: X86: Add kvm_read_guest_page_mmu function
Date: Fri, 10 Sep 2010 17:30:51 +0200
Message-ID: <1284132667-18620-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function which can read from the guests
physical memory or from the guest's guest physical memory.
This will be used in the two-dimensional page table walker.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/x86.c              |   23 +++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10a5ddd..5d9e0bb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -657,6 +657,9 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu);
+int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gfn_t gfn, void *data, int offset, int len,
+			    u32 access);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1054519..34bc840 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -370,6 +370,29 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 EXPORT_SYMBOL_GPL(kvm_require_cpl);
 
 /*
+ * This function will be used to read from the physical memory of the currently
+ * running guest. The difference to kvm_read_guest_page is that this function
+ * can read from guest physical or from the guest's guest physical memory.
+ */
+int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gfn_t ngfn, void *data, int offset, int len,
+			    u32 access)
+{
+	gfn_t real_gfn;
+	gpa_t ngpa;
+
+	ngpa     = gfn_to_gpa(ngfn);
+	real_gfn = mmu->translate_gpa(vcpu, ngpa, access);
+	if (real_gfn == UNMAPPED_GVA)
+		return -EFAULT;
+
+	real_gfn = gpa_to_gfn(real_gfn);
+
+	return kvm_read_guest_page(vcpu->kvm, real_gfn, data, offset, len);
+}
+EXPORT_SYMBOL_GPL(kvm_read_guest_page_mmu);
+
+/*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
-- 
1.7.0.4


