Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0EQJKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:10:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:40345 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab0EQJKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:10:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,246,1272870000"; 
   d="scan'208";a="622224079"
From: Sheng Yang <sheng@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH][v2 3/3] KVM: x86: Use FPU API
Date: Mon, 17 May 2010 17:08:28 +0800
Message-Id: <1274087308-26676-4-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
References: <1274087308-26676-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert KVM to use generic FPU API.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |   17 +------------
 arch/x86/kvm/x86.c              |   52 ++++++++++++---------------------------
 2 files changed, 17 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d93601c..d08bb4a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -301,7 +301,7 @@ struct kvm_vcpu_arch {
 		unsigned long mmu_seq;
 	} update_pte;
 
-	struct i387_fxsave_struct guest_fx_image;
+	struct fpu guest_fpu;
 
 	gva_t mmio_fault_cr2;
 	struct kvm_pio_request pio;
@@ -708,21 +708,6 @@ static inline unsigned long read_msr(unsigned long msr)
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
index ba8c2d2..7be1d36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -53,6 +53,7 @@
 #include <asm/mtrr.h>
 #include <asm/mce.h>
 #include <asm/i387.h>
+#include <asm/xcr.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -5058,27 +5059,6 @@ out:
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
@@ -5101,7 +5081,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->arch.guest_fx_image;
+	struct i387_fxsave_struct *fxsave =
+			&vcpu->arch.guest_fpu.state->fxsave;
 
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
@@ -5117,7 +5098,8 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 {
-	struct fxsave *fxsave = (struct fxsave *)&vcpu->arch.guest_fx_image;
+	struct i387_fxsave_struct *fxsave =
+			&vcpu->arch.guest_fpu.state->fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
@@ -5133,22 +5115,18 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 void fx_init(struct kvm_vcpu *vcpu)
 {
-	unsigned after_mxcsr_mask;
-
-	/* Initialize guest FPU by resetting ours and saving into guest's */
-	preempt_disable();
-	kvm_fx_finit();
-	kvm_fx_save(&vcpu->arch.guest_fx_image);
-	preempt_enable();
+	fpu_alloc(&vcpu->arch.guest_fpu);
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
+	fpu_free(&vcpu->arch.guest_fpu);
+}
+
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->guest_fpu_loaded)
@@ -5156,7 +5134,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 1;
 	unlazy_fpu(current);
-	kvm_fx_restore(&vcpu->arch.guest_fx_image);
+	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
 
@@ -5166,7 +5144,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 		return;
 
 	vcpu->guest_fpu_loaded = 0;
-	kvm_fx_save(&vcpu->arch.guest_fx_image);
+	fpu_save_init(&vcpu->arch.guest_fpu);
 	++vcpu->stat.fpu_reload;
 	set_bit(KVM_REQ_DEACTIVATE_FPU, &vcpu->requests);
 	trace_kvm_fpu(0);
@@ -5179,6 +5157,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 		vcpu->arch.time_page = NULL;
 	}
 
+	fx_free(vcpu);
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
@@ -5213,6 +5192,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_unload(vcpu);
 	vcpu_put(vcpu);
 
+	fx_free(vcpu);
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
-- 
1.7.0.1

