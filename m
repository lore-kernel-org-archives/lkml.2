Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0LHCL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:11:58 -0500
Received: from kroah.org ([198.145.64.141]:46087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab0LHArK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:10 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.893591835@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com
Subject: [046/127] KVM: VMX: Fix host userspace gsbase corruption
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit c8770e7ba63bb5dd8fe5f9d251275a8fa717fb78 upstream.

We now use load_gs_index() to load gs safely; unfortunately this also
changes MSR_KERNEL_GS_BASE, which we managed separately.  This resulted
in confusion and breakage running 32-bit host userspace on a 64-bit kernel.

Fix by
- saving guest MSR_KERNEL_GS_BASE before we we reload the host's gs
- doing the host save/load unconditionally, instead of only when in guest
  long mode

Things can be cleaned up further, but this is the minmal fix for now.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[bwh: Backport to 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -654,10 +654,7 @@ static void vmx_save_host_state(struct k
 #endif
 
 #ifdef CONFIG_X86_64
-	if (is_long_mode(&vmx->vcpu))
-		save_msrs(vmx->host_msrs +
-			  vmx->msr_offset_kernel_gs_base, 1);
-
+	save_msrs(vmx->host_msrs + vmx->msr_offset_kernel_gs_base, 1);
 #endif
 	load_msrs(vmx->guest_msrs, vmx->save_nmsrs);
 	load_transition_efer(vmx);
@@ -672,17 +669,26 @@ static void __vmx_load_host_state(struct
 	vmx->host_state.loaded = 0;
 	if (vmx->host_state.fs_reload_needed)
 		loadsegment(fs, vmx->host_state.fs_sel);
+#ifdef CONFIG_X86_64
+	if (is_long_mode(&vmx->vcpu))
+		save_msrs(vmx->guest_msrs + vmx->msr_offset_kernel_gs_base, 1);
+#endif
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
 #ifdef CONFIG_X86_64
 		load_gs_index(vmx->host_state.gs_sel);
-		wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
 #else
 		loadsegment(gs, vmx->host_state.gs_sel);
 #endif
 	}
 	reload_tss();
+#ifdef CONFIG_X86_64
+	save_msrs(vmx->guest_msrs, vmx->msr_offset_kernel_gs_base);
+	save_msrs(vmx->guest_msrs + vmx->msr_offset_kernel_gs_base + 1,
+		  vmx->save_nmsrs - vmx->msr_offset_kernel_gs_base - 1);
+#else
 	save_msrs(vmx->guest_msrs, vmx->save_nmsrs);
+#endif
 	load_msrs(vmx->host_msrs, vmx->save_nmsrs);
 	reload_host_efer(vmx);
 	load_gdt(&__get_cpu_var(host_gdt));


