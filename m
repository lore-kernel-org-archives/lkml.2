Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1HBLGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:06:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1HBLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:06:04 -0400
Message-ID: <4E37DA94.9060706@cn.fujitsu.com>
Date: Tue, 02 Aug 2011 19:08:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 03/12] zap sp if it is written by unaware instructions
References: <4E37DA49.1040000@cn.fujitsu.com>
In-Reply-To: <4E37DA49.1040000@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 19:05:05,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 19:05:05,
	Serialize complete at 2011-08-02 19:05:05
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the shadow page if it is written by the instructions which is not
typically used to modify the page table

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    4 ++--
 arch/x86/kvm/mmu.c              |    6 +++---
 arch/x86/kvm/paging_tmpl.h      |    3 ++-
 arch/x86/kvm/x86.c              |   11 +++++++----
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 307e3cf..a386755 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -664,7 +664,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			  const void *val, int bytes);
+			  const void *val, int bytes, bool page_table_written);
 int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret);
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
@@ -750,7 +750,7 @@ int fx_init(struct kvm_vcpu *vcpu);
 void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
-		       bool guest_initiated);
+		       bool guest_initiated, bool page_table_written);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 int kvm_mmu_load(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 28991b2..82d5d5a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3541,7 +3541,7 @@ static void kvm_mmu_access_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *new, int bytes,
-		       bool guest_initiated)
+		       bool guest_initiated, bool page_table_written)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	union kvm_mmu_page_role mask = { .word = 0 };
@@ -3627,7 +3627,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		pte_size = sp->role.cr4_pae ? 8 : 4;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
 		misaligned |= bytes < 4;
-		if (misaligned || flooded) {
+		if (misaligned || flooded || !page_table_written) {
 			/*
 			 * Misaligned accesses are too much trouble to fix
 			 * up; also, they usually indicate a page is not used
@@ -4008,7 +4008,7 @@ static int kvm_pv_mmu_write(struct kvm_vcpu *vcpu,
 	if (r)
 		return r;
 
-	if (!emulator_write_phys(vcpu, addr, &value, bytes))
+	if (!emulator_write_phys(vcpu, addr, &value, bytes, true))
 		return -EFAULT;
 
 	return 1;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 507e2b8..5edbba6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -710,7 +710,8 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva)
 
 	if (mmu_topup_memory_caches(vcpu))
 		return;
-	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t), 0);
+	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, sizeof(pt_element_t),
+			  false, true);
 }
 
 static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf6fb29..fbb3a44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4058,14 +4058,14 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 }
 
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			const void *val, int bytes)
+			const void *val, int bytes, bool page_table_written)
 {
 	int ret;
 
 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
 	if (ret < 0)
 		return 0;
-	kvm_mmu_pte_write(vcpu, gpa, val, bytes, 1);
+	kvm_mmu_pte_write(vcpu, gpa, val, bytes, true, page_table_written);
 	return 1;
 }
 
@@ -4103,7 +4103,10 @@ static int read_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 static int write_emulate(struct kvm_vcpu *vcpu, gpa_t gpa,
 			 void *val, int bytes)
 {
-	return emulator_write_phys(vcpu, gpa, val, bytes);
+	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+
+	return emulator_write_phys(vcpu, gpa, val, bytes,
+				   ctxt->page_table_written_insn);
 }
 
 static int write_mmio(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes, void *val)
@@ -4302,7 +4305,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
 
-	kvm_mmu_pte_write(vcpu, gpa, new, bytes, 1);
+	kvm_mmu_pte_write(vcpu, gpa, new, bytes, true, true);
 
 	return X86EMUL_CONTINUE;
 
-- 
1.7.5.4

