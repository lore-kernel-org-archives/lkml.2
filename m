Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0KSVux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:50:53 -0500
Received: from kroah.org ([198.145.64.141]:51798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757339Ab0KSVpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:31 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:11 2010
Message-Id: <20101119214411.230948233@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com
Subject: [22/45] KVM: Fix fs/gs reload oops with invalid ldt
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 9581d442b9058d3699b4be568b6e5eae38a41493 upstream

kvm reloads the host's fs and gs blindly, however the underlying segment
descriptors may be invalid due to the user modifying the ldt after loading
them.

Fix by using the safe accessors (loadsegment() and load_gs_index()) instead
of home grown unsafe versions.

This is CVE-2010-3698.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/kvm_host.h |   24 ------------------------
 arch/x86/kvm/svm.c              |   15 ++++++++++-----
 arch/x86/kvm/vmx.c              |   24 +++++++++---------------
 3 files changed, 19 insertions(+), 44 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -674,20 +674,6 @@ static inline struct kvm_mmu_page *page_
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
@@ -695,16 +681,6 @@ static inline u16 kvm_read_ldt(void)
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
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2698,8 +2698,8 @@ static void svm_vcpu_run(struct kvm_vcpu
 	sync_lapic_to_cr8(vcpu);
 
 	save_host_msrs(vcpu);
-	fs_selector = kvm_read_fs();
-	gs_selector = kvm_read_gs();
+	savesegment(fs, fs_selector);
+	savesegment(gs, gs_selector);
 	ldt_selector = kvm_read_ldt();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
@@ -2786,10 +2786,15 @@ static void svm_vcpu_run(struct kvm_vcpu
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
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -629,7 +629,7 @@ static void vmx_save_host_state(struct k
 	 */
 	vmx->host_state.ldt_sel = kvm_read_ldt();
 	vmx->host_state.gs_ldt_reload_needed = vmx->host_state.ldt_sel;
-	vmx->host_state.fs_sel = kvm_read_fs();
+	savesegment(fs, vmx->host_state.fs_sel);
 	if (!(vmx->host_state.fs_sel & 7)) {
 		vmcs_write16(HOST_FS_SELECTOR, vmx->host_state.fs_sel);
 		vmx->host_state.fs_reload_needed = 0;
@@ -637,7 +637,7 @@ static void vmx_save_host_state(struct k
 		vmcs_write16(HOST_FS_SELECTOR, 0);
 		vmx->host_state.fs_reload_needed = 1;
 	}
-	vmx->host_state.gs_sel = kvm_read_gs();
+	savesegment(gs, vmx->host_state.gs_sel);
 	if (!(vmx->host_state.gs_sel & 7))
 		vmcs_write16(HOST_GS_SELECTOR, vmx->host_state.gs_sel);
 	else {
@@ -665,27 +665,21 @@ static void vmx_save_host_state(struct k
 
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
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
@@ -2342,8 +2336,8 @@ static int vmx_vcpu_setup(struct vcpu_vm
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


