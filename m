Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab2CIEnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:43:43 -0500
Received: from ozlabs.org ([203.10.76.45]:34138 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025Ab2CIEmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.23398.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 4/8] ARM: KVM: split cp15 mrc/mcr and mrrc/mcrr handling.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

The hardware has separate traps for the two cases, so don't prematurely
unify them.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/include/asm/kvm_emulate.h |    3 +
 arch/arm/kvm/arm.c                 |    4 +
 arch/arm/kvm/emulate.c             |  102 ++++++++++++++++++++----------------
 3 files changed, 62 insertions(+), 47 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 029f45f..fa54247 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -44,7 +44,8 @@ int kvm_handle_cp10_id(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp_0_13_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
-int kvm_handle_cp15_access(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_handle_wfi(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_emulate_mmio_ls(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			unsigned long instr);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f27a96b..a6cf02b 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -377,8 +377,8 @@ static int handle_dabt_hyp(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int (*arm_exit_handlers[])(struct kvm_vcpu *vcpu, struct kvm_run *r) = {
 	[HSR_EC_WFI]		= kvm_handle_wfi,
-	[HSR_EC_CP15_32]	= kvm_handle_cp15_access,
-	[HSR_EC_CP15_64]	= kvm_handle_cp15_access,
+	[HSR_EC_CP15_32]	= kvm_handle_cp15_32,
+	[HSR_EC_CP15_64]	= kvm_handle_cp15_64,
 	[HSR_EC_CP14_MR]	= kvm_handle_cp14_access,
 	[HSR_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[HSR_EC_CP14_64]	= kvm_handle_cp14_access,
diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index 87a1141..88c6493 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -304,62 +304,31 @@ static int emulate_cp15_c15_access(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-/**
- * kvm_handle_cp15_access -- handles a trap on a guest CP15 access
- * @vcpu: The VCPU pointer
- * @run:  The kvm_run struct
- *
- * Investigates the CRn/CRm and wether this was mcr/mrc or mcrr/mrrc and either
- * simply errors out if the operation was not supported (should maybe raise
- * undefined to guest instead?) and otherwise emulated access.
- */
-int kvm_handle_cp15_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
+static int emulate_cp15(struct kvm_vcpu *vcpu,
+			const struct coproc_params *params)
 {
-	unsigned long hsr_ec, instr_len;
-	struct coproc_params params;
-	int ret = 0;
-
-	hsr_ec = vcpu->arch.hsr >> HSR_EC_SHIFT;
-	params.CRm = (vcpu->arch.hsr >> 1) & 0xf;
-	params.Rt1 = (vcpu->arch.hsr >> 5) & 0xf;
-	BUG_ON(params.Rt1 >= 15);
-	params.is_write = ((vcpu->arch.hsr & 1) == 0);
-	params.is_64bit = (hsr_ec == HSR_EC_CP15_64);
-
-	if (params.is_64bit) {
-		/* mrrc, mccr operation */
-		params.Op1 = (vcpu->arch.hsr >> 16) & 0xf;
-		params.Op2 = 0;
-		params.Rt2 = (vcpu->arch.hsr >> 10) & 0xf;
-		BUG_ON(params.Rt2 >= 15);
-		params.CRn = 0;
-	} else {
-		params.CRn = (vcpu->arch.hsr >> 10) & 0xf;
-		params.Op1 = (vcpu->arch.hsr >> 14) & 0x7;
-		params.Op2 = (vcpu->arch.hsr >> 17) & 0x7;
-		params.Rt2 = 0;
-	}
+	unsigned long instr_len;
+	int ret;
 
 	/* So far no mrrc/mcrr accesses are emulated */
-	if (params.is_64bit)
+	if (params->is_64bit)
 		goto unsupp_err_out;
 
-	switch (params.CRn) {
+	switch (params->CRn) {
 	case 9:
-		ret = emulate_cp15_c9_access(vcpu, &params);
+		ret = emulate_cp15_c9_access(vcpu, params);
 		break;
 	case 10:
-		ret = emulate_cp15_c10_access(vcpu, &params);
+		ret = emulate_cp15_c10_access(vcpu, params);
 		break;
 	case 15:
-		ret = emulate_cp15_c15_access(vcpu, &params);
+		ret = emulate_cp15_c15_access(vcpu, params);
 		break;
 	default:
 		ret = -EINVAL;
-		break;
 	}
 
-	if (ret)
+	if (ret != 0)
 		goto unsupp_err_out;
 
 	/* Skip instruction, since it was emulated */
@@ -367,10 +336,55 @@ int kvm_handle_cp15_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	*vcpu_reg(vcpu, 15) += instr_len;
 
 	return ret;
-unsupp_err_out:
+
+unsupp_err_out:	
 	kvm_err("Unsupported guest CP15 access at: %08x\n", vcpu->arch.regs.pc);
-	print_cp_instr(&params);
-	return -EINVAL;
+	print_cp_instr(params);
+	return ret;
+}
+
+/**
+ * kvm_handle_cp15_64 -- handles a mrrc/mcrr trap on a guest CP15 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp15_64(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params;
+
+	params.CRm = (vcpu->arch.hsr >> 1) & 0xf;
+	params.Rt1 = (vcpu->arch.hsr >> 5) & 0xf;
+	params.is_write = ((vcpu->arch.hsr & 1) == 0);
+	params.is_64bit = true;
+
+	params.Op1 = (vcpu->arch.hsr >> 16) & 0xf;
+	params.Op2 = 0;
+	params.Rt2 = (vcpu->arch.hsr >> 10) & 0xf;
+	params.CRn = 0;
+
+	return emulate_cp15(vcpu, &params);
+}
+
+/**
+ * kvm_handle_cp15_32 -- handles a mrc/mcr trap on a guest CP15 access
+ * @vcpu: The VCPU pointer
+ * @run:  The kvm_run struct
+ */
+int kvm_handle_cp15_32(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct coproc_params params;
+
+	params.CRm = (vcpu->arch.hsr >> 1) & 0xf;
+	params.Rt1 = (vcpu->arch.hsr >> 5) & 0xf;
+	params.is_write = ((vcpu->arch.hsr & 1) == 0);
+	params.is_64bit = false;
+
+	params.CRn = (vcpu->arch.hsr >> 10) & 0xf;
+	params.Op1 = (vcpu->arch.hsr >> 14) & 0x7;
+	params.Op2 = (vcpu->arch.hsr >> 17) & 0x7;
+	params.Rt2 = 0;
+
+	return emulate_cp15(vcpu, &params);
 }
 
 /**

