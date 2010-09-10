Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0IJPcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:32:50 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:38830 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0IJPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:48 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF40-02-JQ2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/29] KVM: MMU: Track page fault data in struct vcpu
Date: Fri, 10 Sep 2010 17:30:46 +0200
Message-ID: <1284132667-18620-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a struct with two new fields in
vcpu_arch for x86:

	* fault.address
	* fault.error_code

This will be used to correctly propagate page faults back
into the guest when we could have either an ordinary page
fault or a nested page fault. In the case of a nested page
fault the fault-address is different from the original
address that should be walked. So we need to keep track
about the real fault-address.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 -
 arch/x86/include/asm/kvm_host.h    |   17 ++++++++++++-----
 arch/x86/kvm/emulate.c             |   30 ++++++++++++++----------------
 arch/x86/kvm/mmu.c                 |    6 ++----
 arch/x86/kvm/paging_tmpl.h         |    6 +++++-
 arch/x86/kvm/x86.c                 |    9 +++++----
 6 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 1bf1140..5187dd8 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -229,7 +229,6 @@ struct x86_emulate_ctxt {
 	int exception; /* exception that happens during emulation or -1 */
 	u32 error_code; /* error code for exception */
 	bool error_code_valid;
-	unsigned long cr2; /* faulted address in case of #PF */
 
 	/* decode cache */
 	struct decode_cache decode;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3fefcd8..235023e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -239,9 +239,7 @@ struct kvm_mmu {
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long root);
 	unsigned long (*get_cr3)(struct kvm_vcpu *vcpu);
 	int (*page_fault)(struct kvm_vcpu *vcpu, gva_t gva, u32 err);
-	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
-				  unsigned long addr,
-				  u32 error_code);
+	void (*inject_page_fault)(struct kvm_vcpu *vcpu);
 	void (*free)(struct kvm_vcpu *vcpu);
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t gva, u32 access,
 			    u32 *error);
@@ -288,6 +286,16 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	struct kvm_mmu mmu;
+
+	/*
+	 * This struct is filled with the necessary information to propagate a
+	 * page fault into the guest
+	 */
+	struct {
+		u64      address;
+		unsigned error_code;
+	} fault;
+
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
@@ -624,8 +632,7 @@ void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
-void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
-			   u32 error_code);
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 27d2c22..2b08b78 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -487,11 +487,9 @@ static void emulate_gp(struct x86_emulate_ctxt *ctxt, int err)
 	emulate_exception(ctxt, GP_VECTOR, err, true);
 }
 
-static void emulate_pf(struct x86_emulate_ctxt *ctxt, unsigned long addr,
-		       int err)
+static void emulate_pf(struct x86_emulate_ctxt *ctxt)
 {
-	ctxt->cr2 = addr;
-	emulate_exception(ctxt, PF_VECTOR, err, true);
+	emulate_exception(ctxt, PF_VECTOR, 0, true);
 }
 
 static void emulate_ud(struct x86_emulate_ctxt *ctxt)
@@ -834,7 +832,7 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
 		rc = ops->read_emulated(addr, mc->data + mc->end, n, &err,
 					ctxt->vcpu);
 		if (rc == X86EMUL_PROPAGATE_FAULT)
-			emulate_pf(ctxt, addr, err);
+			emulate_pf(ctxt);
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
 		mc->end += n;
@@ -921,7 +919,7 @@ static int read_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	addr = dt.address + index * 8;
 	ret = ops->read_std(addr, desc, sizeof *desc, ctxt->vcpu,  &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT)
-		emulate_pf(ctxt, addr, err);
+		emulate_pf(ctxt);
 
        return ret;
 }
@@ -947,7 +945,7 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	addr = dt.address + index * 8;
 	ret = ops->write_std(addr, desc, sizeof *desc, ctxt->vcpu, &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT)
-		emulate_pf(ctxt, addr, err);
+		emulate_pf(ctxt);
 
 	return ret;
 }
@@ -1117,7 +1115,7 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 					&err,
 					ctxt->vcpu);
 		if (rc == X86EMUL_PROPAGATE_FAULT)
-			emulate_pf(ctxt, c->dst.addr.mem, err);
+			emulate_pf(ctxt);
 		if (rc != X86EMUL_CONTINUE)
 			return rc;
 		break;
@@ -1939,7 +1937,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		emulate_pf(ctxt, old_tss_base, err);
+		emulate_pf(ctxt);
 		return ret;
 	}
 
@@ -1949,7 +1947,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			     &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		emulate_pf(ctxt, old_tss_base, err);
+		emulate_pf(ctxt);
 		return ret;
 	}
 
@@ -1957,7 +1955,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		emulate_pf(ctxt, new_tss_base, err);
+		emulate_pf(ctxt);
 		return ret;
 	}
 
@@ -1970,7 +1968,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 				     ctxt->vcpu, &err);
 		if (ret == X86EMUL_PROPAGATE_FAULT) {
 			/* FIXME: need to provide precise fault address */
-			emulate_pf(ctxt, new_tss_base, err);
+			emulate_pf(ctxt);
 			return ret;
 		}
 	}
@@ -2081,7 +2079,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		emulate_pf(ctxt, old_tss_base, err);
+		emulate_pf(ctxt);
 		return ret;
 	}
 
@@ -2091,7 +2089,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			     &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		emulate_pf(ctxt, old_tss_base, err);
+		emulate_pf(ctxt);
 		return ret;
 	}
 
@@ -2099,7 +2097,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		emulate_pf(ctxt, new_tss_base, err);
+		emulate_pf(ctxt);
 		return ret;
 	}
 
@@ -2112,7 +2110,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 				     ctxt->vcpu, &err);
 		if (ret == X86EMUL_PROPAGATE_FAULT) {
 			/* FIXME: need to provide precise fault address */
-			emulate_pf(ctxt, new_tss_base, err);
+			emulate_pf(ctxt);
 			return ret;
 		}
 	}
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 86f7557..9936727 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2566,11 +2566,9 @@ static unsigned long get_cr3(struct kvm_vcpu *vcpu)
 	return vcpu->arch.cr3;
 }
 
-static void inject_page_fault(struct kvm_vcpu *vcpu,
-			      u64 addr,
-			      u32 err_code)
+static void inject_page_fault(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.mmu.inject_page_fault(vcpu, addr, err_code);
+	vcpu->arch.mmu.inject_page_fault(vcpu);
 }
 
 static void paging_free(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 68ee1b7..d07f48a 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -258,6 +258,10 @@ error:
 		walker->error_code |= PFERR_FETCH_MASK;
 	if (rsvd_fault)
 		walker->error_code |= PFERR_RSVD_MASK;
+
+	vcpu->arch.fault.address    = addr;
+	vcpu->arch.fault.error_code = walker->error_code;
+
 	trace_kvm_mmu_walker_error(walker->error_code);
 	return 0;
 }
@@ -521,7 +525,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	 */
 	if (!r) {
 		pgprintk("%s: guest page fault\n", __func__);
-		inject_page_fault(vcpu, addr, walker.error_code);
+		inject_page_fault(vcpu);
 		vcpu->arch.last_pt_write_count = 0; /* reset fork detector */
 		return 0;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f47db25..57c97a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -329,11 +329,12 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 }
 EXPORT_SYMBOL_GPL(kvm_requeue_exception);
 
-void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
-			   u32 error_code)
+void kvm_inject_page_fault(struct kvm_vcpu *vcpu)
 {
+	unsigned error_code = vcpu->arch.fault.error_code;
+
 	++vcpu->stat.pf_guest;
-	vcpu->arch.cr2 = addr;
+	vcpu->arch.cr2 = vcpu->arch.fault.address;
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
@@ -4066,7 +4067,7 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	if (ctxt->exception == PF_VECTOR)
-		kvm_inject_page_fault(vcpu, ctxt->cr2, ctxt->error_code);
+		kvm_inject_page_fault(vcpu);
 	else if (ctxt->error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception, ctxt->error_code);
 	else
-- 
1.7.0.4


