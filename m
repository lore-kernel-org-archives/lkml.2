Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0IFPDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:03:02 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:4939 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0IFPCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:37 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2Q-01-AOH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <"http://kvm.qumranet.com"@osrc.amd.com>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/27] KVM: MMU: Track page fault data in struct vcpu
Date: Mon, 6 Sep 2010 17:01:52 +0200
Message-ID: <1283785322-26898-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
References: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
 arch/x86/include/asm/kvm_host.h    |    9 +++++++++
 arch/x86/kvm/emulate.c             |   30 ++++++++++++++----------------
 arch/x86/kvm/paging_tmpl.h         |    4 ++++
 arch/x86/kvm/x86.c                 |    3 ++-
 5 files changed, 29 insertions(+), 18 deletions(-)

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
index a338235..e5eb57c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -313,6 +313,15 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu *walk_mmu;
 
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
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a5b5759..20fc815 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -273,6 +273,10 @@ error:
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2fe9e7..38d482d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4130,7 +4130,8 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	if (ctxt->exception == PF_VECTOR)
-		kvm_inject_page_fault(vcpu, ctxt->cr2, ctxt->error_code);
+		kvm_inject_page_fault(vcpu, vcpu->arch.fault.address,
+					    vcpu->arch.fault.error_code);
 	else if (ctxt->error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception, ctxt->error_code);
 	else
-- 
1.7.0.4


