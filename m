Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965392Ab1C3VLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:11:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:25196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965359Ab1C3VKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239665"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mtosatti@redhat.com, avi@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [274/275] KVM: VMX: Fix host userspace gsbase corruption
Message-Id: <20110330210842.1FFE93E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/vmx.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/vmx.c	2011-03-29 23:53:15.698136001 -0700
+++ linux-2.6.35.y/arch/x86/kvm/vmx.c	2011-03-29 23:53:23.475936985 -0700
@@ -771,10 +771,9 @@
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
@@ -789,11 +788,14 @@
 
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
@@ -802,10 +804,7 @@
 		loadsegment(fs, vmx->host_state.fs_sel);
 	reload_tss();
 #ifdef CONFIG_X86_64
-	if (is_long_mode(&vmx->vcpu)) {
-		rdmsrl(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);
-		wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
-	}
+	wrmsrl(MSR_KERNEL_GS_BASE, vmx->msr_host_kernel_gs_base);
 #endif
 	load_gdt(&__get_cpu_var(host_gdt));
 }
