Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0LHBBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:51 -0500
Received: from kroah.org ([198.145.64.141]:49082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab0LHBBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:48 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.510141812@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [151/289] KVM: VMX: Fix host userspace gsbase corruption
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/vmx.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -828,10 +828,9 @@ static void vmx_save_host_state(struct k
 #endif
 
 #ifdef CONFIG_X86_64
-	if (is_long_mode(&vmx->vcpu)) {
-		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+	rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
+	if (is_long_mode(&vmx->vcpu))
 		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
-	}
 #endif
 	for (i = 0; i < vmx->save_nmsrs; ++i)
 		kvm_set_shared_msr(vmx->guest_msrs[i].index,
@@ -846,11 +845,14 @@ static void __vmx_load_host_state(struct
 
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
+#ifdef CONFIG_X86_64
+	if (is_long_mode(&vmx->vcpu))
+		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
+#endif
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
 #ifdef CONFIG_X86_64
 		load_gs_index(vmx->host_state.gs_sel);
-		wrmsrl(MSR_KERNEL_GS_BASE, current->thread.gs);
 #else
 		loadsegment(gs, vmx->host_state.gs_sel);
 #endif
@@ -859,10 +861,7 @@ static void __vmx_load_host_state(struct
 		loadsegment(fs, vmx->host_state.fs_sel);
 	reload_tss();
 #ifdef CONFIG_X86_64
-	if (is_long_mode(&vmx->vcpu)) {
-		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
-		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
-	}
+	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
 	if (current_thread_info()->status & TS_USEDFPU)
 		clts();


