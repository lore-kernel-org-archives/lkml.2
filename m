Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab2CIEmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:07 -0500
Received: from ozlabs.org ([203.10.76.45]:48887 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716Ab2CIEmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.29504.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 2/8] ARM: KVM: neaten offset calculations.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

If we do this the C-correct way, we use fewer casts and it's a bit clearer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/include/asm/kvm_host.h |    6 +++-
 arch/arm/kvm/emulate.c          |   60 ++++++++++++++++++++-------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8002903..e211d8e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -86,7 +86,11 @@ enum cp15_regs {
 };
 
 struct kvm_vcpu_arch {
-	struct kvm_vcpu_regs regs;
+	/* We sometimes access these as an array for simplicity. */
+	union {
+		struct kvm_vcpu_regs regs;
+		u32 reg_array[sizeof(struct kvm_vcpu_regs) / sizeof(u32)];
+	};
 
 	/* System control coprocessor (cp15) */
 	u32 cp15[nr_cp15_regs];
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index 4f5f2de..108db38 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -22,8 +22,10 @@
 
 #include "trace.h"
 
-#define USR_REG_OFFSET(_reg) \
-	offsetof(struct kvm_vcpu_arch, regs.usr_regs[_reg])
+#define REG_OFFSET(_reg) \
+	(offsetof(struct kvm_vcpu_regs, _reg) / sizeof(u32))
+
+#define USR_REG_OFFSET(_num) REG_OFFSET(usr_regs[_num])
 
 static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 	/* FIQ Registers */
@@ -31,14 +33,14 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(0), USR_REG_OFFSET(1), USR_REG_OFFSET(2),
 		USR_REG_OFFSET(3), USR_REG_OFFSET(4), USR_REG_OFFSET(5),
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7),
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[1]), /* r8 */
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[1]), /* r9 */
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[2]), /* r10 */
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[3]), /* r11 */
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[4]), /* r12 */
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[5]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.fiq_regs[6]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)		  /* r15 */
+		REG_OFFSET(fiq_regs[1]), /* r8 */
+		REG_OFFSET(fiq_regs[1]), /* r9 */
+		REG_OFFSET(fiq_regs[2]), /* r10 */
+		REG_OFFSET(fiq_regs[3]), /* r11 */
+		REG_OFFSET(fiq_regs[4]), /* r12 */
+		REG_OFFSET(fiq_regs[5]), /* r13 */
+		REG_OFFSET(fiq_regs[6]), /* r14 */
+		REG_OFFSET(pc)		 /* r15 */
 	},
 
 	/* IRQ Registers */
@@ -48,9 +50,9 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
 		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
 		USR_REG_OFFSET(12),
-		offsetof(struct kvm_vcpu_arch, regs.irq_regs[0]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.irq_regs[1]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)	          /* r15 */
+		REG_OFFSET(irq_regs[0]), /* r13 */
+		REG_OFFSET(irq_regs[1]), /* r14 */
+		REG_OFFSET(pc)	         /* r15 */
 	},
 
 	/* SVC Registers */
@@ -60,9 +62,9 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
 		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
 		USR_REG_OFFSET(12),
-		offsetof(struct kvm_vcpu_arch, regs.svc_regs[0]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.svc_regs[1]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)		  /* r15 */
+		REG_OFFSET(svc_regs[0]), /* r13 */
+		REG_OFFSET(svc_regs[1]), /* r14 */
+		REG_OFFSET(pc)		 /* r15 */
 	},
 
 	/* ABT Registers */
@@ -72,9 +74,9 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
 		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
 		USR_REG_OFFSET(12),
-		offsetof(struct kvm_vcpu_arch, regs.abt_regs[0]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.abt_regs[1]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)	          /* r15 */
+		REG_OFFSET(abt_regs[0]), /* r13 */
+		REG_OFFSET(abt_regs[1]), /* r14 */
+		REG_OFFSET(pc)	         /* r15 */
 	},
 
 	/* UND Registers */
@@ -84,9 +86,9 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
 		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
 		USR_REG_OFFSET(12),
-		offsetof(struct kvm_vcpu_arch, regs.und_regs[0]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.und_regs[1]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)	          /* r15 */
+		REG_OFFSET(und_regs[0]), /* r13 */
+		REG_OFFSET(und_regs[1]), /* r14 */
+		REG_OFFSET(pc)	         /* r15 */
 	},
 
 	/* USR Registers */
@@ -96,9 +98,9 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
 		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
 		USR_REG_OFFSET(12),
-		offsetof(struct kvm_vcpu_arch, regs.usr_regs[13]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.usr_regs[14]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)	           /* r15 */
+		REG_OFFSET(usr_regs[13]), /* r13 */
+		REG_OFFSET(usr_regs[14]), /* r14 */
+		REG_OFFSET(pc)	          /* r15 */
 	},
 
 	/* SYS Registers */
@@ -108,9 +110,9 @@ static const unsigned long vcpu_reg_offsets[MODE_SYS + 1][16] = {
 		USR_REG_OFFSET(6), USR_REG_OFFSET(7), USR_REG_OFFSET(8),
 		USR_REG_OFFSET(9), USR_REG_OFFSET(10), USR_REG_OFFSET(11),
 		USR_REG_OFFSET(12),
-		offsetof(struct kvm_vcpu_arch, regs.usr_regs[13]), /* r13 */
-		offsetof(struct kvm_vcpu_arch, regs.usr_regs[14]), /* r14 */
-		offsetof(struct kvm_vcpu_arch, regs.pc)	           /* r15 */
+		REG_OFFSET(usr_regs[13]), /* r13 */
+		REG_OFFSET(usr_regs[14]), /* r14 */
+		REG_OFFSET(pc)	          /* r15 */
 	},
 };
 
@@ -123,7 +125,7 @@ u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode)
 	BUG_ON(reg_num > 15);
 	BUG_ON(mode > MODE_SYS);
 
-	return (u32 *)((void *)&vcpu->arch + vcpu_reg_offsets[mode][reg_num]);
+	return &vcpu->arch.reg_array[vcpu_reg_offsets[mode][reg_num]];
 }
 
 /******************************************************************************

