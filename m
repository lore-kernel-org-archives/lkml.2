Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984Ab2CIEmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:08 -0500
Received: from ozlabs.org ([203.10.76.45]:40585 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758004Ab2CIEmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.5775.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 5/8] ARM: KVM: make emulation functions return bool.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

Simplifies error handling into the parent: all errors mean
"can't emulate".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/kvm/emulate.c |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index 88c6493..d386874 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -212,8 +212,8 @@ int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
  * @vcpu: The VCPU pointer
  * @p:    The coprocessor parameters struct pointer holding trap inst. details
  */
-static int emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
-				  const struct coproc_params *p)
+static bool emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
+				   const struct coproc_params *p)
 {
 	BUG_ON(p->CRn != 9);
 	BUG_ON(p->is_64bit);
@@ -223,7 +223,7 @@ static int emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
 		u32 l2ctlr, ncores;
 
 		if (p->is_write)
-			return 0;
+			return true;
 
 		asm volatile("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
 		l2ctlr &= ~(3 << 24);
@@ -231,13 +231,13 @@ static int emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
 		l2ctlr |= (ncores & 3) << 24;
 		*vcpu_reg(vcpu, p->Rt1) = l2ctlr;
 
-		return 0;
+		return true;
 	}
 
 	/* hack alert!!! */
 	if (!p->is_write)
 		*vcpu_reg(vcpu, p->Rt1) = 0;
-	return 0;
+	return true;
 }
 
 /**
@@ -250,8 +250,8 @@ static int emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
  * host/guest PRRR and NMRR memory remap registers and allow guest direct access
  * to these registers.
  */
-static int emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
-				   const struct coproc_params *p)
+static bool emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
+				    const struct coproc_params *p)
 {
 	BUG_ON(p->CRn != 10);
 	BUG_ON(p->is_64bit);
@@ -259,7 +259,7 @@ static int emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
 	if ((p->CRm == 0 || p->CRm == 1 || p->CRm == 4 || p->CRm == 8) &&
 	    (p->Op2 <= 7)) {
 		/* TLB Lockdown operations - ignored */
-		return 0;
+		return true;
 	}
 
 	/*
@@ -270,15 +270,15 @@ static int emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
 
 	if (p->CRm == 2 && p->Op1 == 0 && p->Op2 == 0) {
 		cp15_op(vcpu, p, c10_PRRR);
-		return 0;
+		return true;
 	}
 
 	if (p->CRm == 2 && p->Op1 == 0 && p->Op2 == 1) {
 		cp15_op(vcpu, p, c10_NMRR);
-		return 0;
+		return true;
 	}
 
-	return -EINVAL;
+	return false;
 }
 
 /**
@@ -292,8 +292,8 @@ static int emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
  *
  * This may need to be refined.
  */
-static int emulate_cp15_c15_access(struct kvm_vcpu *vcpu,
-				   const struct coproc_params *p)
+static bool emulate_cp15_c15_access(struct kvm_vcpu *vcpu,
+				    const struct coproc_params *p)
 {
 	trace_kvm_emulate_cp15_imp(p->Op1, p->Rt1, p->CRn, p->CRm,
 				   p->Op2, p->is_write);
@@ -301,14 +301,14 @@ static int emulate_cp15_c15_access(struct kvm_vcpu *vcpu,
 	if (!p->is_write)
 		*vcpu_reg(vcpu, p->Rt1) = 0;
 
-	return 0;
+	return true;
 }
 
 static int emulate_cp15(struct kvm_vcpu *vcpu,
 			const struct coproc_params *params)
 {
 	unsigned long instr_len;
-	int ret;
+	bool ok;
 
 	/* So far no mrrc/mcrr accesses are emulated */
 	if (params->is_64bit)
@@ -316,31 +316,31 @@ static int emulate_cp15(struct kvm_vcpu *vcpu,
 
 	switch (params->CRn) {
 	case 9:
-		ret = emulate_cp15_c9_access(vcpu, params);
+		ok = emulate_cp15_c9_access(vcpu, params);
 		break;
 	case 10:
-		ret = emulate_cp15_c10_access(vcpu, params);
+		ok = emulate_cp15_c10_access(vcpu, params);
 		break;
 	case 15:
-		ret = emulate_cp15_c15_access(vcpu, params);
+		ok = emulate_cp15_c15_access(vcpu, params);
 		break;
 	default:
-		ret = -EINVAL;
+		ok = false;
 	}
 
-	if (ret != 0)
+	if (!ok)
 		goto unsupp_err_out;
 
 	/* Skip instruction, since it was emulated */
 	instr_len = ((vcpu->arch.hsr >> 25) & 1) ? 4 : 2;
 	*vcpu_reg(vcpu, 15) += instr_len;
 
-	return ret;
+	return 0;
 
 unsupp_err_out:	
 	kvm_err("Unsupported guest CP15 access at: %08x\n", vcpu->arch.regs.pc);
 	print_cp_instr(params);
-	return ret;
+	return -EINVAL;
 }
 
 /**

