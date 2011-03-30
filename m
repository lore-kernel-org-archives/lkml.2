Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398Ab1C3VLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:11:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:14385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965357Ab1C3VKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279522"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mtosatti@redhat.com, avi@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [273/275] KVM: Correct ordering of ldt reload wrt fs/gs reload
Message-Id: <20110330210841.136E63E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:41 -0700 (PDT)
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

Index: linux-2.6.35.y/arch/x86/kvm/svm.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/svm.c	2011-03-29 23:53:08.796312600 -0700
+++ linux-2.6.35.y/arch/x86/kvm/svm.c	2011-03-29 23:53:15.697136026 -0700
@@ -3185,6 +3185,7 @@
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
 	load_host_msrs(vcpu);
+	kvm_load_ldt(ldt_selector);
 	loadsegment(fs, fs_selector);
 #ifdef CONFIG_X86_64
 	load_gs_index(gs_selector);
@@ -3192,7 +3193,6 @@
 #else
 	loadsegment(gs, gs_selector);
 #endif
-	kvm_load_ldt(ldt_selector);
 
 	reload_tss(vcpu);
 
Index: linux-2.6.35.y/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/vmx.c	2011-03-29 23:53:08.868310757 -0700
+++ linux-2.6.35.y/arch/x86/kvm/vmx.c	2011-03-29 23:53:32.094716453 -0700
@@ -789,8 +789,6 @@
 
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
-	if (vmx->host_state.fs_reload_needed)
-		loadsegment(fs, vmx->host_state.fs_sel);
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
 #ifdef CONFIG_X86_64
@@ -800,6 +798,8 @@
 		loadsegment(gs, vmx->host_state.gs_sel);
 #endif
 	}
+	if (vmx->host_state.fs_reload_needed)
+		loadsegment(fs, vmx->host_state.fs_sel);
 	reload_tss();
 #ifdef CONFIG_X86_64
 	if (is_long_mode(&vmx->vcpu)) {
