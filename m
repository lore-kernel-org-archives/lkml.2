Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0D0Kmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:42:43 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:13960
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754591Ab0D0Kix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:38:53 -0400
X-SpamScore: 11
X-BigFish: VPS11(z1857rzab9bhzz1202hzz6ff19hz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WI-02-NOR-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/22] KVM: X86: Add kvm_read_guest_page_tdp function
Date: Tue, 27 Apr 2010 12:38:23 +0200
Message-ID: <1272364712-17425-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:35.0933 (UTC) FILETIME=[CA6C64D0:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
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
index 3cbfb51..7851bbc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -635,6 +635,9 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
+int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gfn_t gfn, void *data, int offset, int len,
+			    u32 *error);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b2ce1d..558d995 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -356,6 +356,30 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 EXPORT_SYMBOL_GPL(kvm_require_cpl);
 
 /*
+ * This function will be used to read from the physical memory of the currently
+ * running guest. The difference to kvm_read_guest_page ist that this function
+ * can read from guest physical or from the guest's guest physical memory.
+ */
+int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
+			    gfn_t gfn, void *data, int offset, int len,
+			    u32 *error)
+{
+	gfn_t real_gfn;
+	gpa_t gpa;
+
+	*error   = 0;
+	gpa      = gfn << PAGE_SHIFT;
+	real_gfn = mmu->translate_gpa(vcpu, gpa, error);
+	if (real_gfn == UNMAPPED_GVA)
+		return -EFAULT;
+
+	real_gfn >>= PAGE_SHIFT;
+
+	return kvm_read_guest_page(vcpu->kvm, real_gfn, data, offset, len);
+}
+EXPORT_SYMBOL_GPL(kvm_read_guest_page_tdp);
+
+/*
  * Load the pae pdptrs.  Return true is they are all valid.
  */
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
-- 
1.7.0.4


