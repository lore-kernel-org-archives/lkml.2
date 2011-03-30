Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643Ab1C3VLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:11:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:46600 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965353Ab1C3VKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279458"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mtosatti@redhat.com, avi@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [272/275] KVM: Fix fs/gs reload oops with invalid ldt
Message-Id: <20110330210840.08E153E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/kvm_host.h |   24 ------------------------
 arch/x86/kvm/svm.c              |   15 ++++++++++-----
 arch/x86/kvm/vmx.c              |   24 +++++++++---------------
 3 files changed, 19 insertions(+), 44 deletions(-)

Index: linux-2.6.35.y/arch/x86/include/asm/kvm_host.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/kvm_host.h	2011-03-29 23:47:05.643604770 -0700
+++ linux-2.6.35.y/arch/x86/include/asm/kvm_host.h	2011-03-29 23:53:08.794312651 -0700
@@ -673,20 +673,6 @@
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
@@ -694,16 +680,6 @@
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
Index: linux-2.6.35.y/arch/x86/kvm/svm.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/svm.c	2011-03-29 23:48:01.816167453 -0700
+++ linux-2.6.35.y/arch/x86/kvm/svm.c	2011-03-29 23:53:32.725700307 -0700
@@ -3096,8 +3096,8 @@
 	sync_lapic_to_cr8(vcpu);
 
 	save_host_msrs(vcpu);
-	fs_selector = kvm_read_fs();
-	gs_selector = kvm_read_gs();
+	savesegment(fs, fs_selector);
+	savesegment(gs, gs_selector);
 	ldt_selector = kvm_read_ldt();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 	/* required for live migration with NPT */
@@ -3184,10 +3184,15 @@
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
 
Index: linux-2.6.35.y/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/vmx.c	2011-03-29 23:48:01.817167428 -0700
+++ linux-2.6.35.y/arch/x86/kvm/vmx.c	2011-03-29 23:53:32.725700307 -0700
@@ -746,7 +746,7 @@
 	 */
 	vmx->host_state.ldt_sel = kvm_read_ldt();
 	vmx->host_state.gs_ldt_reload_needed = vmx->host_state.ldt_sel;
-	vmx->host_state.fs_sel = kvm_read_fs();
+	savesegment(fs, vmx->host_state.fs_sel);
 	if (!(vmx->host_state.fs_sel & 7)) {
 		vmcs_write16(HOST_FS_SELECTOR, vmx->host_state.fs_sel);
 		vmx->host_state.fs_reload_needed = 0;
@@ -754,7 +754,7 @@
 		vmcs_write16(HOST_FS_SELECTOR, 0);
 		vmx->host_state.fs_reload_needed = 1;
 	}
-	vmx->host_state.gs_sel = kvm_read_gs();
+	savesegment(gs, vmx->host_state.gs_sel);
 	if (!(vmx->host_state.gs_sel & 7))
 		vmcs_write16(HOST_GS_SELECTOR, vmx->host_state.gs_sel);
 	else {
@@ -784,27 +784,21 @@
 
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
@@ -2518,8 +2512,8 @@
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
