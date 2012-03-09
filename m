Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab2CIEm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:56 -0500
Received: from ozlabs.org ([203.10.76.45]:50339 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063Ab2CIEmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.26948.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 7/8] ARM: KVM: guest_didnt_mean_it()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

Conditional instructions may trap even if the condition isn't true, so a good
hypervisor will check this.  The same can happen with undefined instructions,
so the kernel should be doing this dance already (it isn't).

(See p1206 of ARMv7-A ARM)

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/include/asm/kvm_arm.h     |    4 +++
 arch/arm/include/asm/kvm_emulate.h |    2 +
 arch/arm/kvm/Makefile              |    2 +
 arch/arm/kvm/arm.c                 |    3 ++
 arch/arm/kvm/emulate.c             |   41 +++++++++++++++++++++++++++
 arch/arm/kvm/kvm_cond_match.S      |   54 ++++++++++++++++++++++++++++++++++++
 6 files changed, 105 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/kvm/kvm_cond_match.S

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 1769187..156284a 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -107,6 +107,10 @@
 #define HSR_ISS		(HSR_IL - 1)
 #define HSR_ISV_SHIFT	(24)
 #define HSR_ISV		(1U << HSR_ISV_SHIFT)
+#define HSR_CV_SHIFT	(24)
+#define HSR_CV		(1U << HSR_CV_SHIFT)
+#define HSR_COND_SHIFT	(20)
+#define HSR_COND	(0xfU << HSR_COND_SHIFT)
 
 #define HSR_EC_UNKNOWN	(0x00)
 #define HSR_EC_WFI	(0x01)
diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index fa54247..fe21e86 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -49,6 +49,8 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_wfi(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_emulate_mmio_ls(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			unsigned long instr);
+bool kvm_should_not_have_trapped(struct kvm_vcpu *vcpu);
+bool kvm_cond_match(u32 flags, u32 cond);
 
 /*
  * Return the SPSR for the specified mode of the virtual CPU.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index e69a8e1..68f05b9 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -12,6 +12,6 @@ obj-$(CONFIG_KVM_ARM_HOST) += init.o interrupts.o exports.o
 
 kvm-arm-y += $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
 
-kvm-arm-y += arm.o guest.o mmu.o emulate.o
+kvm-arm-y += arm.o guest.o mmu.o emulate.o kvm_cond_match.o
 
 obj-$(CONFIG_KVM) += kvm-arm.o
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index a6cf02b..1724657 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -414,6 +414,9 @@ static inline int handle_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		BUG();
 	}
 
+	if (kvm_should_not_have_trapped(vcpu))
+		return 0;
+
 	return arm_exit_handlers[hsr_ec](vcpu, run);
 }
 
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index bd2c3dc..11e2dab 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -659,3 +659,44 @@ int kvm_emulate_mmio_ls(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	*vcpu_reg(vcpu, 15) += 4;
 	return 0;
 }
+
+/* Some implementations may not check condition codes before trapping! */
+bool kvm_should_not_have_trapped(struct kvm_vcpu *vcpu)
+{
+	unsigned long spsr, cond, flags;
+
+	/*
+	 * Exception Code 0 can only happen if we set HCR.TGE to 1, to
+	 * catch undefined instructions, and then we won't get past
+	 * the arm_exit_handlers test anyway.
+	 */
+	BUG_ON(((vcpu->arch.hsr & HSR_EC) >> HSR_EC_SHIFT) == 0);
+
+	/* Top two bits non-zero?  Unconditional. */
+	if (vcpu->arch.hsr >> 30)
+		return false;
+
+	spsr = *vcpu_spsr(vcpu);
+
+	/* Is condition field valid? */
+	if ((vcpu->arch.hsr & HSR_CV) >> HSR_CV_SHIFT)
+		cond = (vcpu->arch.hsr & HSR_COND) >> HSR_COND_SHIFT;
+	else {
+		/* This can happen in Thumb mode: examine IT state. */
+		unsigned long it;
+		
+		it = ((spsr >> 8) & 0xFC)
+			| ((spsr >> 25) & 0x3);
+
+		/* it == 0 => unconditional. */
+		if (it == 0)
+			return false;
+
+		/* The cond for this insn works out as the top 4 bits. */
+		cond = (it >> 4);
+	}
+
+	flags = spsr & ~0x07FFFFFF;
+
+	return !kvm_cond_match(flags, cond);
+}
diff --git a/arch/arm/kvm/kvm_cond_match.S b/arch/arm/kvm/kvm_cond_match.S
new file mode 100644
index 0000000..cf48786
--- /dev/null
+++ b/arch/arm/kvm/kvm_cond_match.S
@@ -0,0 +1,54 @@
+#include <linux/linkage.h>
+
+/* extern bool kvm_cond_match(u32 flags, u32 cond); */
+ENTRY(kvm_cond_match)
+.arm
+	/* First, set our condition flags to the arg. */
+	mrs	r2, cpsr
+	and	r2, r2, #0x07FFFFFF
+	orr	r2, r2, r0
+	msr	cpsr, r2
+
+	/* Now, jump to table depending on cond, return via there. */
+	mov	r0, #0
+	add	r2, r0, r1, LSL #3
+	sub	r2, #4
+	add	pc, r2
+
+/* This is "mov<cond>	r0, #1" */
+#define COND_MOVEQ_R0_1(cond) .word	((cond << 28) | 0x03a00001)
+
+cond_table:
+	COND_MOVEQ_R0_1(0)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(1)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(2)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(3)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(4)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(5)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(6)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(7)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(8)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(9)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(10)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(11)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(12)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(13)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(14)
+	mov	pc, lr
+	COND_MOVEQ_R0_1(15)
+	mov	pc, lr
+ENDPROC(kvm_cond_match)

