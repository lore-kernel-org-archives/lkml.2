Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1H3CdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:33:01 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55165 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1H3Cc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:32:58 -0400
Message-ID: <4E5C4C5C.8030602@cn.fujitsu.com>
Date: Tue, 30 Aug 2011 10:35:08 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 03/11] KVM: x86: retry non-page-table writing instruction
References: <4E5C4C20.3000403@cn.fujitsu.com>
In-Reply-To: <4E5C4C20.3000403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:31:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-30 10:31:57,
	Serialize complete at 2011-08-30 10:31:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the emulation is caused by #PF and it is non-page_table writing instruction,
it means the VM-EXIT is caused by shadow page protected, we can zap the shadow
page and retry this instruction directly

The idea is from Avi

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/include/asm/kvm_host.h    |    5 ++++
 arch/x86/kvm/emulate.c             |    5 ++++
 arch/x86/kvm/mmu.c                 |   22 +++++++++++++----
 arch/x86/kvm/x86.c                 |   47 ++++++++++++++++++++++++++++++++++++
 5 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 6040d11..fa87b63 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -362,6 +362,7 @@ enum x86_intercept {
 #endif
 
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len);
+bool page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_FAILED -1
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6ab4241..27a25df 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -443,6 +443,9 @@ struct kvm_vcpu_arch {
 
 	cpumask_var_t wbinvd_dirty_mask;
 
+	unsigned long last_retry_eip;
+	unsigned long last_retry_addr;
+
 	struct {
 		bool halted;
 		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
@@ -689,6 +692,7 @@ enum emulation_result {
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
 #define EMULTYPE_SKIP		    (1 << 2)
+#define EMULTYPE_RETRY		    (1 << 3)
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
 			    int emulation_type, void *insn, int insn_len);
 
@@ -753,6 +757,7 @@ void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
 		       bool guest_initiated);
+int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e24c269..c62424e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3691,6 +3691,11 @@ done:
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
+bool page_table_writing_insn(struct x86_emulate_ctxt *ctxt)
+{
+	return ctxt->d & PageTable;
+}
+
 static bool string_insn_completed(struct x86_emulate_ctxt *ctxt)
 {
 	/* The second termination condition only applies for REPE
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b01afee..26aae11 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1997,7 +1997,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 	kvm->arch.n_max_mmu_pages = goal_nr_mmu_pages;
 }
 
-static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
+int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct hlist_node *node;
@@ -2007,6 +2007,7 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	pgprintk("%s: looking for gfn %llx\n", __func__, gfn);
 	r = 0;
 
+	spin_lock(&kvm->mmu_lock);
 	for_each_gfn_indirect_valid_sp(kvm, sp, gfn, node) {
 		pgprintk("%s: gfn %llx role %x\n", __func__, gfn,
 			 sp->role.word);
@@ -2014,8 +2015,10 @@ static int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	spin_unlock(&kvm->mmu_lock);
 	return r;
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page);
 
 static void mmu_unshadow(struct kvm *kvm, gfn_t gfn)
 {
@@ -3697,9 +3700,7 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-	spin_unlock(&vcpu->kvm->mmu_lock);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_unprotect_page_virt);
@@ -3720,10 +3721,18 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
 }
 
+static bool is_mmio_page_fault(struct kvm_vcpu *vcpu, gva_t addr)
+{
+	if (vcpu->arch.mmu.direct_map || mmu_is_nested(vcpu))
+		return vcpu_match_mmio_gpa(vcpu, addr);
+
+	return vcpu_match_mmio_gva(vcpu, addr);
+}
+
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
 		       void *insn, int insn_len)
 {
-	int r;
+	int r, emulation_type = EMULTYPE_RETRY;
 	enum emulation_result er;
 
 	r = vcpu->arch.mmu.page_fault(vcpu, cr2, error_code, false);
@@ -3735,7 +3744,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
 		goto out;
 	}
 
-	er = x86_emulate_instruction(vcpu, cr2, 0, insn, insn_len);
+	if (is_mmio_page_fault(vcpu, cr2))
+		emulation_type = 0;
+
+	er = x86_emulate_instruction(vcpu, cr2, emulation_type, insn, insn_len);
 
 	switch (er) {
 	case EMULATE_DONE:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b37f18..1afe59e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4814,6 +4814,50 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
 	return false;
 }
 
+static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
+			      unsigned long cr2,  int emulation_type)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	unsigned long last_retry_eip, last_retry_addr, gpa = cr2;
+
+	last_retry_eip = vcpu->arch.last_retry_eip;
+	last_retry_addr = vcpu->arch.last_retry_addr;
+
+	/*
+	 * If the emulation is caused by #PF and it is non-page_table
+	 * writing instruction, it means the VM-EXIT is caused by shadow
+	 * page protected, we can zap the shadow page and retry this
+	 * instruction directly.
+	 *
+	 * Note: if the guest uses a non-page-table modifying instruction
+	 * on the PDE that points to the instruction, then we will unmap
+	 * the instruction and go to an infinite loop. So, we cache the
+	 * last retried eip and the last fault address, if we meet the eip
+	 * and the address again, we can break out of the potential infinite
+	 * loop.
+	 */
+	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
+
+	if (!(emulation_type & EMULTYPE_RETRY))
+		return false;
+
+	if (page_table_writing_insn(ctxt))
+		return false;
+
+	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2)
+		return false;
+
+	vcpu->arch.last_retry_eip = ctxt->eip;
+	vcpu->arch.last_retry_addr = cr2;
+
+	if (!vcpu->arch.mmu.direct_map && !mmu_is_nested(vcpu))
+		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
+
+	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+
+	return true;
+}
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 			    unsigned long cr2,
 			    int emulation_type,
@@ -4855,6 +4899,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		return EMULATE_DONE;
 	}
 
+	if (retry_instruction(ctxt, cr2, emulation_type))
+		return EMULATE_DONE;
+
 	/* this is needed for vmware backdoor interface to work since it
 	   changes registers values  during IO operation */
 	if (vcpu->arch.emulate_regs_need_sync_from_vcpu) {
-- 
1.7.5.4

