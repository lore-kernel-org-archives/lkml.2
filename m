Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab0LLXqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36157 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab0LLXqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:48 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: avi@redhat.com, mtosatti@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [106/223] KVM: Correct ordering of ldt reload wrt fs/gs reload
Message-Id: <20101212234646.D0CD1B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Avi Kivity <avi@redhat.com>

commit 0a77fe4c188e25917799f2356d4aa5e6d80c39a2 upstream.

If fs or gs refer to the ldt, they must be reloaded after the ldt.  Reorder
the code to that effect.

Userspace code that uses the ldt with kvm is nonexistent, so this doesn't fix
a user-visible bug.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/svm.c |    2 +-
 arch/x86/kvm/vmx.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kvm/svm.c
===================================================================
--- linux.orig/arch/x86/kvm/svm.c
+++ linux/arch/x86/kvm/svm.c
@@ -3184,9 +3184,9 @@ static void svm_vcpu_run(struct kvm_vcpu
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
+	kvm_load_ldt(ldt_selector);
 	kvm_load_fs(fs_selector);
 	kvm_load_gs(gs_selector);
-	kvm_load_ldt(ldt_selector);
 	load_host_msrs(vcpu);
 
 	reload_tss(vcpu);
Index: linux/arch/x86/kvm/vmx.c
===================================================================
--- linux.orig/arch/x86/kvm/vmx.c
+++ linux/arch/x86/kvm/vmx.c
@@ -791,8 +791,6 @@ static void __vmx_load_host_state(struct
 
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
-	if (vmx->host_state.fs_reload_needed)
-		kvm_load_fs(vmx->host_state.fs_sel);
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
 		/*
@@ -806,6 +804,8 @@ static void __vmx_load_host_state(struct
 #endif
 		local_irq_restore(flags);
 	}
+	if (vmx->host_state.fs_reload_needed)
+		loadsegment(fs, vmx->host_state.fs_sel);
 	reload_tss();
 #ifdef CONFIG_X86_64
 	if (is_long_mode(&vmx->vcpu)) {
