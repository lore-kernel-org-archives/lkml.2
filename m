Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0ENDSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 23:18:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:3164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab0ENDSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 23:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="798332873"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 3/3] KVM: x86: Use FPU API
Date: Fri, 14 May 2010 11:16:53 +0800
Message-Id: <1273807013-4792-4-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
References: <1273807013-4792-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert KVM to use generic FPU API.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |   18 +---------
 arch/x86/kvm/x86.c              |   73 ++++++++++++---------------------------
 2 files changed, 23 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ed48904..beba6f5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -300,8 +300,7 @@ struct kvm_vcpu_arch {
 		unsigned long mmu_seq;
 	} update_pte;
 
-	struct i387_fxsave_struct host_fx_image;
-	struct i387_fxsave_struct guest_fx_image;
+	struct fpu host_fpu, guest_fpu;
 
 	gva_t mmio_fault_cr2;
 	struct kvm_pio_request pio;
@@ -709,21 +708,6 @@ static inline unsigned long read_msr(unsigned long msr)
 }
 #endif
 
-static inline void kvm_fx_save(struct i387_fxsave_struct *image)
-{
-	asm("fxsave (%0)":: "r" (image));
-}
-
-static inline void kvm_fx_restore(struct i387_fxsave_struct *image)
-{
-	asm("fxrstor (%0)":: "r" (image));
-}
-
-static inline void kvm_fx_finit(void)
-{
-	asm("finit");
-}
-
 static inline u32 get_rdx_init_val(void)
 {
 	return 0x600; /* P6 family */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd8a606..2313f76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -52,6 +52,8 @@
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/mce.h>
+#include <asm/i387.h>
+#include <asm/xcr.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -5069,27 +5071,6 @@ unlock_out:
 }
 
 /*
- * fxsave fpu state.  Taken from x86_64/processor.h.  To be killed when
- * we have asm/x86/processor.h
- */
-struct fxsave {
-	u16	cwd;
-	u16	swd;
-	u16	twd;
-	u16	fop;
-	u64	rip;
-	u64	rdp;
-	u32	mxcsr;
-	u32	mxcsr_mask;
-	u32	st_space[32];	/* 8*16 bytes for each FP-reg = 128 bytes */
-#ifdef CONFIG_X86_64
-	u32	xmm_space[64];	/* 16*16 bytes for each XMM-reg = 256 bytes */
-#else
-	u32	xmm_space[32];	/* 8*16 bytes for each XMM-reg = 128 bytes */
-#endif
-};
-
-/*
  * Translate a guest virtual address to a guest physical address.
  */
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
@@ -5114,7 +5095,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->arch.guest_fx_image;
+	struct i387_fxsave_struct *fxsave =
+			&vcpu->arch.guest_fpu.state->fxsave;
 
 	vcpu_load(vcpu);
 
@@ -5134,7 +5116,8 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->arch.guest_fx_image;
+	struct i387_fxsave_struct *fxsave =
+			&vcpu->arch.guest_fpu.state->fxsave;
 
 	vcpu_load(vcpu);
 
@@ -5154,41 +5137,30 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 void fx_init(struct kvm_vcpu *vcpu)
 {
-	unsigned after_mxcsr_mask;
-
-	/*
-	 * Touch the fpu the first time in non atomic context as if
-	 * this is the first fpu instruction the exception handler
-	 * will fire before the instruction returns and it'll have to
-	 * allocate ram with GFP_KERNEL.
-	 */
-	if (!used_math())
-		kvm_fx_save(&vcpu->arch.host_fx_image);
+	fpu_alloc(&vcpu->arch.host_fpu);
+	fpu_alloc(&vcpu->arch.guest_fpu);
 
-	/* Initialize guest FPU by resetting ours and saving into guest's */
-	preempt_disable();
-	kvm_fx_save(&vcpu->arch.host_fx_image);
-	kvm_fx_finit();
-	kvm_fx_save(&vcpu->arch.guest_fx_image);
-	kvm_fx_restore(&vcpu->arch.host_fx_image);
-	preempt_enable();
+	fpu_save(&vcpu->arch.host_fpu);
+	fpu_finit(&vcpu->arch.guest_fpu);
 
 	vcpu->arch.cr0 |= X86_CR0_ET;
-	after_mxcsr_mask = offsetof(struct i387_fxsave_struct, st_space);
-	vcpu->arch.guest_fx_image.mxcsr = 0x1f80;
-	memset((void *)&vcpu->arch.guest_fx_image + after_mxcsr_mask,
-	       0, sizeof(struct i387_fxsave_struct) - after_mxcsr_mask);
 }
 EXPORT_SYMBOL_GPL(fx_init);
 
+static void fx_free(struct kvm_vcpu *vcpu)
+{
+	fpu_free(&vcpu->arch.host_fpu);
+	fpu_free(&vcpu->arch.guest_fpu);
+}
+
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->guest_fpu_loaded)
 		return;
 
 	vcpu->guest_fpu_loaded = 1;
-	kvm_fx_save(&vcpu->arch.host_fx_image);
-	kvm_fx_restore(&vcpu->arch.guest_fx_image);
+	fpu_save(&vcpu->arch.host_fpu);
+	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
 
@@ -5198,8 +5170,8 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	kvm_fx_save(&vcpu->arch.guest_fx_image);
-	kvm_fx_restore(&vcpu->arch.host_fx_image);
+	fpu_save(&vcpu->arch.guest_fpu);
+	fpu_restore_checking(&vcpu->arch.host_fpu);
 	++vcpu->stat.fpu_reload;
 	set_bit(KVM_REQ_DEACTIVATE_FPU, &vcpu->requests);
 	trace_kvm_fpu(0);
@@ -5212,6 +5184,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 		vcpu->arch.time_page = NULL;
 	}
 
+	fx_free(vcpu);
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
@@ -5225,9 +5198,6 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	/* We do fxsave: this must be aligned. */
-	BUG_ON((unsigned long)&vcpu->arch.host_fx_image & 0xF);
-
 	vcpu->arch.mtrr_state.have_fixed = 1;
 	vcpu_load(vcpu);
 	r = kvm_arch_vcpu_reset(vcpu);
@@ -5249,6 +5219,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
 
+	fx_free(vcpu);
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
-- 
1.7.0.1

