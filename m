Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1GZLYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:24:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1GZLYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:24:48 -0400
Message-ID: <4E2EA476.9070607@cn.fujitsu.com>
Date: Tue, 26 Jul 2011 19:26:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 03/11] KVM: x86: fast emulate repeat string write instructions
References: <4E2EA3DB.7040403@cn.fujitsu.com>
In-Reply-To: <4E2EA3DB.7040403@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:23:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 19:23:53,
	Serialize complete at 2011-07-26 19:23:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We usually use repeat string instructions to clear the page, for example,
we call memset to clear a page table, stosb is used in this function, and 
repeated for 1024 times, that means we should occupy mmu lock for 1024 times
and walking shadow page cache for 1024 times, it is terrible

In fact, if it is the repeat string instructions emulated and it is not a
IO/MMIO access, we can zap all the corresponding shadow pages and return to the
guest, then the mapping can became writable and directly write the page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/include/asm/kvm_host.h    |    2 +-
 arch/x86/kvm/emulate.c             |    5 +++--
 arch/x86/kvm/mmu.c                 |    4 ++--
 arch/x86/kvm/paging_tmpl.h         |    3 ++-
 arch/x86/kvm/x86.c                 |    9 +++++++--
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 6040d11..7e5c4d5 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -244,6 +244,7 @@ struct x86_emulate_ctxt {
 	bool guest_mode; /* guest running a nested guest */
 	bool perm_ok; /* do not check permissions if true */
 	bool only_vendor_specific_insn;
+	bool pio_mmio_emulate; /* it is the pio/mmio access if true */
 
 	bool have_exception;
 	struct x86_exception exception;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c00ec28..95f55a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -752,7 +752,7 @@ int fx_init(struct kvm_vcpu *vcpu);
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
-		       bool guest_initiated);
+		       bool guest_initiated, bool repeat_write);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 6f08bc9..36fbac6 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4009,8 +4009,9 @@ writeback:
 			 * Re-enter guest when pio read ahead buffer is empty
 			 * or, if it is not used, after each 1024 iteration.
 			 */
-			if ((r->end != 0 || ctxt->regs[VCPU_REGS_RCX] & 0x3ff) &&
-			    (r->end == 0 || r->end != r->pos)) {
+			if ((r->end != 0 || ctxt->regs[VCPU_REGS_RCX] & 0x3ff)
+			      && (r->end == 0 || r->end != r->pos) &&
+			      ctxt->pio_mmio_emulate) {
 				/*
 				 * Reset read cache. Usually happens before
 				 * decode, but since instruction is restarted
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 587695b..5193de8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3541,7 +3541,7 @@ static int get_free_pte_list_desc_nr(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
-		       bool guest_initiated)
+		       bool guest_initiated, bool repeat_write)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	union kvm_mmu_page_role mask = { .word = 0 };
@@ -3622,7 +3622,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
-		if (misaligned || flooded) {
+		if (misaligned || flooded || repeat_write) {
 			/*
 			 * Misaligned accesses are too much trouble to fix
 			 * up; also, they usually indicate a page is not used
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 507e2b8..02daac5 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -710,7 +710,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 	if (mmu_topup_memory_caches(vcpu))
 		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
+	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t),
+			  false, false);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5543f99..6fb9001 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4058,7 +4058,8 @@ int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
 	if (ret < 0)
 		return 0;
-	kvm_mmu_pte_write(vcpu, gpa, val, bytes, 1);
+	kvm_mmu_pte_write(vcpu, gpa, val, bytes, true,
+			  vcpu->arch.emulate_ctxt.rep_prefix);
 	return 1;
 }
 
@@ -4161,6 +4162,8 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
 		return X86EMUL_CONTINUE;
 
 mmio:
+	vcpu->arch.emulate_ctxt.pio_mmio_emulate = true;
+
 	/*
 	 * Is this MMIO handled locally?
 	 */
@@ -4295,7 +4298,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
 
-	kvm_mmu_pte_write(vcpu, gpa, new, bytes, 1);
+	kvm_mmu_pte_write(vcpu, gpa, new, bytes, true, false);
 
 	return X86EMUL_CONTINUE;
 
@@ -4326,6 +4329,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
 {
 	trace_kvm_pio(!in, port, size, count);
 
+	vcpu->arch.emulate_ctxt.pio_mmio_emulate = true;
 	vcpu->arch.pio.port = port;
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.count  = count;
@@ -4817,6 +4821,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		ctxt->interruptibility = 0;
 		ctxt->have_exception = false;
 		ctxt->perm_ok = false;
+		ctxt->pio_mmio_emulate = false;
 
 		ctxt->only_vendor_specific_insn
 			= emulation_type & EMULTYPE_TRAP_UD;
-- 
1.7.5.4

