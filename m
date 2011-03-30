Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab1C3VK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:17671 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965350Ab1C3VKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279446"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: mtosatti@redhat.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [271/275] Revert "KVM: Correct ordering of ldt reload wrt fs/gs reload"
Message-Id: <20110330210838.F06E23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
This reverts commit d3f813da18f83a31f2678988b450e6a1c94c95ed.
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/svm.c |    2 +-
 arch/x86/kvm/vmx.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/arch/x86/kvm/svm.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/svm.c	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/arch/x86/kvm/svm.c	2011-03-29 23:53:33.374683701 -0700
@@ -3184,9 +3184,9 @@
 	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
 	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
 
-	kvm_load_ldt(ldt_selector);
 	kvm_load_fs(fs_selector);
 	kvm_load_gs(gs_selector);
+	kvm_load_ldt(ldt_selector);
 	load_host_msrs(vcpu);
 
 	reload_tss(vcpu);
Index: linux-2.6.35.y/arch/x86/kvm/vmx.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kvm/vmx.c	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/arch/x86/kvm/vmx.c	2011-03-29 23:53:33.374683701 -0700
@@ -791,6 +791,8 @@
 
 	++vmx->vcpu.stat.host_state_reload;
 	vmx->host_state.loaded = 0;
+	if (vmx->host_state.fs_reload_needed)
+		kvm_load_fs(vmx->host_state.fs_sel);
 	if (vmx->host_state.gs_ldt_reload_needed) {
 		kvm_load_ldt(vmx->host_state.ldt_sel);
 		/*
@@ -804,8 +806,6 @@
 #endif
 		local_irq_restore(flags);
 	}
-	if (vmx->host_state.fs_reload_needed)
-		loadsegment(fs, vmx->host_state.fs_sel);
 	reload_tss();
 #ifdef CONFIG_X86_64
 	if (is_long_mode(&vmx->vcpu)) {
