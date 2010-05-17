Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab0EQJLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:11:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:40345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab0EQJKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:10:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="622224078"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH][v2 2/3] KVM: x86: Use unlazy_fpu() for host FPU
Date: Mon, 17 May 2010 17:08:27 +0800
Message-Id: <1274087308-26676-3-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
References: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can avoid unnecessary fpu load when userspace process
didn't use FPU frequently.

Derived from Avi's idea.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |    1 -
 arch/x86/kvm/x86.c              |   18 ++----------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0c06148..d93601c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -301,7 +301,6 @@ struct kvm_vcpu_arch {
 		unsigned long mmu_seq;
 	} update_pte;
 
-	struct i387_fxsave_struct host_fx_image;
 	struct i387_fxsave_struct guest_fx_image;
 
 	gva_t mmio_fault_cr2;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7500cba..ba8c2d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -52,6 +52,7 @@
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/i387.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -5134,21 +5135,10 @@ void fx_init(struct kvm_vcpu *vcpu)
 {
 	unsigned after_mxcsr_mask;
 
-	/*
-	 * Touch the fpu the first time in non atomic context as if
-	 * this is the first fpu instruction the exception handler
-	 * will fire before the instruction returns and it'll have to
-	 * allocate ram with GFP_KERNEL.
-	 */
-	if (!used_math())
-		kvm_fx_save(&vcpu->arch.host_fx_image);
-
 	/* Initialize guest FPU by resetting ours and saving into guest's */
 	preempt_disable();
-	kvm_fx_save(&vcpu->arch.host_fx_image);
 	kvm_fx_finit();
 	kvm_fx_save(&vcpu->arch.guest_fx_image);
-	kvm_fx_restore(&vcpu->arch.host_fx_image);
 	preempt_enable();
 
 	vcpu->arch.cr0 |= X86_CR0_ET;
@@ -5165,7 +5155,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 1;
-	kvm_fx_save(&vcpu->arch.host_fx_image);
+	unlazy_fpu(current);
 	kvm_fx_restore(&vcpu->arch.guest_fx_image);
 	trace_kvm_fpu(1);
 }
@@ -5177,7 +5167,6 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	kvm_fx_save(&vcpu->arch.guest_fx_image);
-	kvm_fx_restore(&vcpu->arch.host_fx_image);
 	++vcpu->stat.fpu_reload;
 	set_bit(KVM_REQ_DEACTIVATE_FPU, &vcpu->requests);
 	trace_kvm_fpu(0);
@@ -5203,9 +5192,6 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	/* We do fxsave: this must be aligned. */
-	BUG_ON((unsigned long)&vcpu->arch.host_fx_image & 0xF);
-
 	vcpu->arch.mtrr_state.have_fixed = 1;
 	vcpu_load(vcpu);
 	r = kvm_arch_vcpu_reset(vcpu);
-- 
1.7.0.1

