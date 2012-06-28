Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2F1GM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:12:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47718 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab2F1GIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:06 -0400
X-AuditID: b753bd60-9fe84ba000000655-9e-4febf4c4c69c
X-AuditID: b753bd60-9fe84ba000000655-9e-4febf4c4c69c
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 07/18] KVM: handle page faults occured in slave CPUs on
 online CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:07:56 +0900
Message-ID: <20120628060756.19298.42007.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
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
index 4291954..80f7b3b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -66,6 +66,11 @@
 
 #define UNMAPPED_GVA (~(gpa_t)0)
 
+#ifdef CONFIG_SLAVE_CPU
+/* Requests to handle VM exit on online cpu */
+#define KVM_REQ_HANDLE_PF	32
+#endif
+
 /* KVM Hugepage definitions for x86 */
 #define KVM_NR_PAGE_SIZES	3
 #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
@@ -405,6 +410,16 @@ struct kvm_vcpu_arch {
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
index 6139e1d..a179ebc 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3785,6 +3785,19 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
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
index ecd474a..7b9f2a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5552,6 +5552,16 @@ static int vcpu_enter_guest_slave(struct kvm_vcpu *vcpu,
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
 


