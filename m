Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1ABHcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:32:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:37133 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab1ABHZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 238/260] KVM: Fix fs/gs reload oops with invalid ldt
Date: Sun,  2 Jan 2011 02:18:54 -0500
Message-Id: <1293952756-15010-239-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:30.0089 (UTC) FILETIME=[183B1F90:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

commit 9581d442b9058d3699b4be568b6e5eae38a41493 upstream.

kvm reloads the host's fs and gs blindly, however the underlying segment
descriptors may be invalid due to the user modifying the ldt after loading
them.

Fix by using the safe accessors (loadsegment() and load_gs_index()) instead
of home grown unsafe versions.

This is CVE-2010-3698.

KVM-Stable-Tag.
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/kvm_host.h |   24 ------------------------
 arch/x86/kvm/svm.c              |   15 ++++++++++-----
 arch/x86/kvm/vmx.c              |   24 +++++++++---------------
 3 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 63400e6..9a6c267 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -691,20 +691,6 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
 	return (struct kvm_mmu_page *)page_private(page);
 }
 
-static inline u16 kvm_read_fs(void)
-{
-	u16 seg;
-	asm("mov %%fs, %0" : "=g"(seg));
-	return seg;
-}
-
-static inline u16 kvm_read_gs(void)
-{
-	u16 seg;
-	asm("mov %%gs, %0" : "=g"(seg));
-	return seg;
-}
-
 static inline u16 kvm_read_ldt(void)
 {
 	u16 ldt;
@@ -712,16 +698,6 @@ static inline u16 kvm_read_ldt(void)
 	return ldt;
 }
 
-static inline void kvm_load_fs(u16 sel)
-{
-	asm("mov %0, %%fs" : : "rm"(sel));
-}
-
-static inline void kvm_load_gs(u16 sel)
-{
-	asm("mov %0, %%gs" : : "rm"(sel));
-}
-
 static inline void kvm_load_ldt(u16 sel)
 {
 	asm("lldt %0" : : "rm"(sel));
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 80453d4..0d93929 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2821,8 +2821,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	sync_lapic_to_cr8(vcpu);
 
 	save_host_msrs(vcpu);
-	fs_selector = kvm_read_fs();
-	gs_selector = kvm_read_gs();
+	savesegment(fs, fs_selector);
+	savesegment(gs, gs_selector);
 	ldt_selector = kvm_read_ldt();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
@@ -2909,10 +2909,15 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
-	kvm_load_fs(fs_selector);
-	kvm_load_gs(gs_selector);
-	kvm_load_ldt(ldt_selector);
 	load_host_msrs(vcpu);
+	loadsegment(fs, fs_selector);
+#ifdef CONFIG_X86_64
+	load_gs_index(gs_selector);
+	wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
+#else
+	loadsegment(gs, gs_selector);
+#endif
+	kvm_load_ldt(ldt_selector);
 
 	reload_tss(vcpu);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 11db911..2cfa656 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -651,7 +651,7 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 	 */
 	vmx->host_state.ldt_sel = kvm_read_ldt();
 	vmx->host_state.gs_ldt_reload_needed = vmx->host_state.ldt_sel;
-	vmx->host_state.fs_sel = kvm_read_fs();
+	savesegment(fs, vmx->host_state.fs_sel);
 	if (!(vmx->host_state.fs_sel & 7)) {
 		vmcs_write16(HOST_FS_SELECTOR, vmx->host_state.fs_sel);
 		vmx->host_state.fs_reload_needed = 0;
@@ -659,7 +659,7 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 		vmcs_write16(HOST_FS_SELECTOR, 0);
 		vmx->host_state.fs_reload_needed = 1;
 	}
-	vmx->host_state.gs_sel = kvm_read_gs();
+	savesegment(gs, vmx->host_state.gs_sel);
 	if (!(vmx->host_state.gs_sel & 7))
 		vmcs_write16(HOST_GS_SELECTOR, vmx->host_state.gs_sel);
 	else {
@@ -689,27 +689,21 @@ static void vmx_save_host_state(struct kvm_vcpu *vcpu)
 
 static void __vmx_load_host_state(struct vcpu_vmx *vmx)
 {
-	unsigned long flags;
-
 	if (!vmx->host_state.loaded)
 		return;
 
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
 	if (vmx->host_state.fs_reload_needed)
-		kvm_load_fs(vmx->host_state.fs_sel);
+		loadsegment(fs, vmx->host_state.fs_sel);
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
-		/*
-		 * If we have to reload gs, we must take care to
-		 * preserve our gs base.
-		 */
-		local_irq_save(flags);
-		kvm_load_gs(vmx->host_state.gs_sel);
 #ifdef CONFIG_X86_64
-		wrmsrl(MSR_GS_BASE, vmcs_readl(HOST_GS_BASE));
+		load_gs_index(vmx->host_state.gs_sel);
+		wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
+#else
+		loadsegment(gs, vmx->host_state.gs_sel);
 #endif
-		local_irq_restore(flags);
 	}
 	reload_tss();
 #ifdef CONFIG_X86_64
@@ -2414,8 +2408,8 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_CS_SELECTOR, __KERNEL_CS);  /* 22.2.4 */
 	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
-	vmcs_write16(HOST_FS_SELECTOR, kvm_read_fs());    /* 22.2.4 */
-	vmcs_write16(HOST_GS_SELECTOR, kvm_read_gs());    /* 22.2.4 */
+	vmcs_write16(HOST_FS_SELECTOR, 0);            /* 22.2.4 */
+	vmcs_write16(HOST_GS_SELECTOR, 0);            /* 22.2.4 */
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_FS_BASE, a);
-- 
1.7.3.3

