Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0IFPFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:05:01 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20610 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab0IFPCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:55 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2Q-01-AOF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/27] KVM: X86: Add kvm_read_guest_page_tdp function
Date: Mon, 6 Sep 2010 17:01:48 +0200
Message-ID: <1283785322-26898-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
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
 arch/x86/kvm/x86.c              |   24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9b9c096..38dc82e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -651,6 +651,9 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
+int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gfn_t gfn, void *data, int offset, int len,
+			    u32 *error);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5dcf7f..f1bdf4e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -369,6 +369,30 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 EXPORT_SYMBOL_GPL(kvm_require_cpl);
 
 /*
+ * This function will be used to read from the physical memory of the currently
+ * running guest. The difference to kvm_read_guest_page is that this function
+ * can read from guest physical or from the guest's guest physical memory.
+ */
+int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gfn_t ngfn, void *data, int offset, int len,
+			    u32 *error)
+{
+	gfn_t real_gfn;
+	gpa_t ngpa;
+
+	*error   = 0;
+	ngpa     = gfn_to_gpa(ngfn);
+	real_gfn = mmu->translate_gpa(vcpu, ngpa, error);
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


