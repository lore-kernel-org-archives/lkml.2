Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2IFLbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 07:31:11 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:59506 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2IFLah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 07:30:37 -0400
X-AuditID: b753bd60-914c2ba0000047ca-88-504888c3e547
X-AuditID: b753bd60-914c2ba0000047ca-88-504888c3e547
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC v2 PATCH 07/21] KVM: handle page faults of slave guests on
 online CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 06 Sep 2012 20:27:55 +0900
Message-ID: <20120906112755.13320.52580.stgit@kvmdev>
In-Reply-To: <20120906112718.13320.8231.stgit@kvmdev>
References: <20120906112718.13320.8231.stgit@kvmdev>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page faults which occured by the guest running on slave CPUs cannot be
handled on slave CPUs because it is running on idle process context.

With this patch, the page fault happened in a slave CPU is notified to
online CPU using struct kvm_access_fault, and is handled after the
user-process for the guest is resumed on an online CPU.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |   15 +++++++++++++++
 arch/x86/kvm/mmu.c              |   13 +++++++++++++
 arch/x86/kvm/x86.c              |   10 ++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 72a0a64..8dc1a0a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -67,6 +67,11 @@
 
 #define UNMAPPED_GVA (~(gpa_t)0)
 
+#ifdef CONFIG_SLAVE_CPU
+/* Requests to handle VM exit on online cpu */
+#define KVM_REQ_HANDLE_PF	32
+#endif
+
 /* KVM Hugepage definitions for x86 */
 #define KVM_NR_PAGE_SIZES	3
 #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
@@ -413,6 +418,16 @@ struct kvm_vcpu_arch {
 		u8 nr;
 	} interrupt;
 
+#ifdef CONFIG_SLAVE_CPU
+	/* used for recording page fault on offline CPU */
+	struct kvm_access_fault {
+		gva_t cr2;
+		u32 error_code;
+		void *insn;
+		int insn_len;
+	} page_fault;
+#endif
+
 	int halt_request; /* real mode on Intel only */
 
 	int cpuid_nent;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7fbd0d2..eb1d397 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3946,6 +3946,19 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
 	int r, emulation_type = EMULTYPE_RETRY;
 	enum emulation_result er;
 
+#ifdef CONFIG_SLAVE_CPU
+	if (cpu_slave(smp_processor_id())) {
+		/* Page fault must be handled on user-process context. */
+		r = -EFAULT;
+		vcpu->arch.page_fault.cr2 = cr2;
+		vcpu->arch.page_fault.error_code = error_code;
+		vcpu->arch.page_fault.insn = insn;
+		vcpu->arch.page_fault.insn_len = insn_len;
+		kvm_make_request(KVM_REQ_HANDLE_PF, vcpu);
+		goto out;
+	}
+#endif
+
 	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
 	if (r < 0)
 		goto out;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 827b681..579c41c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5561,6 +5561,16 @@ static int vcpu_enter_guest_slave(struct kvm_vcpu *vcpu,
 	r = arg.ret;
 	*apf_pending = arg.apf_pending;
 
+	if (r == -EFAULT && kvm_check_request(KVM_REQ_HANDLE_PF, vcpu)) {
+		pr_debug("handling page fault request @%p\n",
+			 (void *)vcpu->arch.page_fault.cr2);
+		r = kvm_mmu_page_fault(vcpu,
+				       vcpu->arch.page_fault.cr2,
+				       vcpu->arch.page_fault.error_code,
+				       vcpu->arch.page_fault.insn,
+				       vcpu->arch.page_fault.insn_len);
+	}
+
 	return r;
 }
 


