Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2CIEm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:42:57 -0500
Received: from ozlabs.org ([203.10.76.45]:54404 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758074Ab2CIEmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:42:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1331267212.16020.rusty@rustcorp.com.au>
Date: Fri, 09 Mar 2012 14:56:52 +1030
Subject: [PATCH 6/8] ARM: KVM: table-driven coprocessor emulation.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Rusty Russell <rusty@rustcorp.com.au>

To try to avoid encroaching ad-hoc emulation, drive it from
a single table, so it's clear exactly what we do and do not
emulate.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/arm/kvm/emulate.c |  255 ++++++++++++++++++++++++------------------------
 1 files changed, 130 insertions(+), 125 deletions(-)

diff --git a/arch/arm/kvm/emulate.c b/arch/arm/kvm/emulate.c
index d386874..bd2c3dc 100644
--- a/arch/arm/kvm/emulate.c
+++ b/arch/arm/kvm/emulate.c
@@ -165,25 +165,19 @@ struct coproc_params {
 	bool is_write;
 };
 
-static void cp15_op(struct kvm_vcpu *vcpu, const struct coproc_params *p,
-			   enum cp15_regs cp15_reg)
-{
-	if (p->is_write)
-		vcpu->arch.cp15[cp15_reg] = *vcpu_reg(vcpu, p->Rt1);
-	else
-		*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp15[cp15_reg];
-}
-
 static void print_cp_instr(const struct coproc_params *p)
 {
+	/* Look, we even formatted it for you to paste into the table! */
 	if (p->is_64bit) {
-		kvm_debug("%s\tp15, %lu, r%lu, r%lu, c%lu",
-			  (p->is_write) ? "mcrr" : "mrrc",
-			  p->Op1, p->Rt1, p->Rt2, p->CRm);
+		kvm_debug("{ .is_64bit = true, .is_write = %s, .param ="
+			  " { .CRm = %lu, .Op1 = %lu } }",
+			  p->is_write ? "true" : "false", p->CRm, p->Op1);
 	} else {
-		kvm_debug("%s\tp15, %lu, r%lu, c%lu, c%lu, %lu",
-			  (p->is_write) ? "mcr" : "mrc",
-			  p->Op1, p->Rt1, p->CRn, p->CRm, p->Op2);
+		kvm_debug("{ .is_64bit = false, .is_write = %s, .param ="
+			  " { .CRn = %lu, .CRm = %lu,"
+			  " .Op1 = %lu, .Op2 = %lu } }",
+			  p->is_write ? "true" : "false",
+			  p->CRn, p->CRm, p->Op1, p->Op2);
 	}
 }
 
@@ -207,139 +201,150 @@ int kvm_handle_cp14_access(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return -EINVAL;
 }
 
-/**
- * emulate_cp15_c9_access -- emulates cp15 accesses for CRn == 9
- * @vcpu: The VCPU pointer
- * @p:    The coprocessor parameters struct pointer holding trap inst. details
- */
-static bool emulate_cp15_c9_access(struct kvm_vcpu *vcpu,
-				   const struct coproc_params *p)
+static bool ignore_write(struct kvm_vcpu *vcpu,
+			 const struct coproc_params *p,
+			 unsigned long arg)
 {
-	BUG_ON(p->CRn != 9);
-	BUG_ON(p->is_64bit);
-
-	if (p->CRm == 0 && p->Op1 == 1 && p->Op2 == 2) {
-		/* Emulate L2CTLR access */
-		u32 l2ctlr, ncores;
+	if (arg)
+		trace_kvm_emulate_cp15_imp(p->Op1, p->Rt1, p->CRn, p->CRm,
+					   p->Op2, p->is_write);
+	return true;
+}
 
-		if (p->is_write)
-			return true;
+static bool read_zero(struct kvm_vcpu *vcpu,
+		      const struct coproc_params *p,
+		      unsigned long arg)
+{
+	if (arg)
+		trace_kvm_emulate_cp15_imp(p->Op1, p->Rt1, p->CRn, p->CRm,
+					   p->Op2, p->is_write);
+	*vcpu_reg(vcpu, p->Rt1) = 0;
+	return true;
+}
 
-		asm volatile("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
-		l2ctlr &= ~(3 << 24);
-		ncores = atomic_read(&vcpu->kvm->online_vcpus) - 1;
-		l2ctlr |= (ncores & 3) << 24;
-		*vcpu_reg(vcpu, p->Rt1) = l2ctlr;
+static bool read_l2ctlr(struct kvm_vcpu *vcpu,
+			const struct coproc_params *p,
+			unsigned long arg)
+{
+	u32 l2ctlr, ncores;
 
-		return true;
-	}
+	asm volatile("mrc p15, 1, %0, c9, c0, 2\n" : "=r" (l2ctlr));
+	l2ctlr &= ~(3 << 24);
+	ncores = atomic_read(&vcpu->kvm->online_vcpus) - 1;
+	l2ctlr |= (ncores & 3) << 24;
+	*vcpu_reg(vcpu, p->Rt1) = l2ctlr;
 
-	/* hack alert!!! */
-	if (!p->is_write)
-		*vcpu_reg(vcpu, p->Rt1) = 0;
 	return true;
 }
 
-/**
- * emulate_cp15_c10_access -- emulates cp15 accesses for CRn == 10
- * @vcpu: The VCPU pointer
- * @p:    The coprocessor parameters struct pointer holding trap inst. details
- *
- * This function may not need to exist - if we can ignore guest attempts to
- * tamper with TLB lockdowns then it should be enough to store/restore the
- * host/guest PRRR and NMRR memory remap registers and allow guest direct access
- * to these registers.
- */
-static bool emulate_cp15_c10_access(struct kvm_vcpu *vcpu,
-				    const struct coproc_params *p)
+static bool access_cp15_reg(struct kvm_vcpu *vcpu,
+			    const struct coproc_params *p,
+			    unsigned long cp15_reg)
 {
-	BUG_ON(p->CRn != 10);
-	BUG_ON(p->is_64bit);
-
-	if ((p->CRm == 0 || p->CRm == 1 || p->CRm == 4 || p->CRm == 8) &&
-	    (p->Op2 <= 7)) {
-		/* TLB Lockdown operations - ignored */
-		return true;
-	}
+	if (p->is_write)
+		vcpu->arch.cp15[cp15_reg] = *vcpu_reg(vcpu, p->Rt1);
+	else
+		*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp15[cp15_reg];
+	return true;
+}
 
-	/*
-	 * The role of these registers depends on whether LPAE is defined or
-	 * not, but there shouldn't be any breakage in any case - we may
-	 * simply not respect the nomenclature here.
-	 */
 
-	if (p->CRm == 2 && p->Op1 == 0 && p->Op2 == 0) {
-		cp15_op(vcpu, p, c10_PRRR);
-		return true;
-	}
+/* Any field which is 0xFFFFFFFF == any. */
+#define ANY (-1UL)
+struct coproc_emulate {
+	unsigned long is_64;
+	unsigned long is_w;
+	struct {
+		unsigned long CRm;
+		unsigned long CRn;
+		unsigned long Op1;
+		unsigned long Op2;
+	} param;
+
+	bool (*f)(struct kvm_vcpu *,
+		  const struct coproc_params *,
+		  unsigned long);
+	unsigned long arg;
+};
 
-	if (p->CRm == 2 && p->Op1 == 0 && p->Op2 == 1) {
-		cp15_op(vcpu, p, c10_NMRR);
-		return true;
-	}
 
-	return false;
-}
+static const struct coproc_emulate coproc_emulate[] = {
+	/* Ignore writes to L2CTLR access */
+	{ .is_64 = false, .is_w = true, .f = ignore_write,
+	  .param = { .CRn = 9, .CRm = 0, .Op1 = 1, .Op2 = 2 } },
+	{ .is_64 = false, .is_w = false, .f = read_l2ctlr,
+	  .param = { .CRn = 9, .CRm = 0, .Op1 = 1, .Op2 = 2 } },
+	/* Hack alert!!! */
+	{ .is_64 = false, .is_w = true, .f = ignore_write,
+	  .param = { .CRn = 9, .CRm = ANY, .Op1 = ANY, .Op2 = ANY } },
+	{ .is_64 = false, .is_w = false, .f = read_zero,
+	  .param = { .CRn = 9, .CRm = ANY, .Op1 = ANY, .Op2 = ANY } },
+
+	/* These CRn == 10 entries may not need to exist - if we can
+	 * ignore guest attempts to tamper with TLB lockdowns then it
+	 * should be enough to store/restore the host/guest PRRR and
+	 * NMRR memory remap registers and allow guest direct access
+	 * to these registers. */
+	/* TLB Lockdown operations - ignored */
+	{ .is_64 = false, .is_w = true, .f = ignore_write,
+	  .param = { .CRn = 10, .CRm = 0, .Op1 = ANY, .Op2 = ANY } },
+	{ .is_64 = false, .is_w = ANY, .f = access_cp15_reg,
+	  .arg = c10_PRRR,
+	  .param = { .CRn = 10, .CRm = 2, .Op1 = 0, .Op2 = 0 } },
+	{ .is_64 = false, .is_w = ANY, .f = access_cp15_reg,
+	  .arg = c10_NMRR,
+	  .param = { .CRn = 10, .CRm = 2, .Op1 = 0, .Op2 = 1 } },
+
+	/* The CP15 c15 register is architecturally implementation
+	 * defined, but some guest kernels attempt to read/write a
+	 * diagnostics register here. We always return 0 and ignore
+	 * writes and hope for the best. */
+	{ .is_64 = false, .is_w = true, .f = ignore_write, .arg = 1,
+	  .param = { .CRn = 15, .CRm = ANY, .Op1 = ANY, .Op2 = ANY } },
+	{ .is_64 = false, .is_w = false, .f = read_zero, .arg = 1,
+	  .param = { .CRn = 15, .CRm = ANY, .Op1 = ANY, .Op2 = ANY } },
+};
 
-/**
- * emulate_cp15_c15_access -- emulates cp15 accesses for CRn == 15
- * @vcpu: The VCPU pointer
- * @p:    The coprocessor parameters struct pointer holding trap inst. details
- *
- * The CP15 c15 register is architecturally implementation defined, but some
- * guest kernels attempt to read/write a diagnostics register here. We always
- * return 0 and ignore writes and hope for the best.
- *
- * This may need to be refined.
- */
-static bool emulate_cp15_c15_access(struct kvm_vcpu *vcpu,
-				    const struct coproc_params *p)
+static inline bool match(unsigned long val, unsigned long param)
 {
-	trace_kvm_emulate_cp15_imp(p->Op1, p->Rt1, p->CRn, p->CRm,
-				   p->Op2, p->is_write);
-
-	if (!p->is_write)
-		*vcpu_reg(vcpu, p->Rt1) = 0;
-
-	return true;
+	return param == ANY || val == param;
 }
 
 static int emulate_cp15(struct kvm_vcpu *vcpu,
 			const struct coproc_params *params)
 {
-	unsigned long instr_len;
-	bool ok;
-
-	/* So far no mrrc/mcrr accesses are emulated */
-	if (params->is_64bit)
-		goto unsupp_err_out;
-
-	switch (params->CRn) {
-	case 9:
-		ok = emulate_cp15_c9_access(vcpu, params);
-		break;
-	case 10:
-		ok = emulate_cp15_c10_access(vcpu, params);
-		break;
-	case 15:
-		ok = emulate_cp15_c15_access(vcpu, params);
-		break;
-	default:
-		ok = false;
+	unsigned long instr_len, i;
+
+	for (i = 0; i < ARRAY_SIZE(coproc_emulate); i++) {
+		const struct coproc_emulate *e = &coproc_emulate[i];
+
+		if (!match(params->is_64bit, e->is_64))
+			continue;
+		if (!match(params->is_write, e->is_w))
+			continue;
+		if (!match(params->CRn, e->param.CRn))
+			continue;
+		if (!match(params->CRm, e->param.CRm))
+			continue;
+		if (!match(params->Op1, e->param.Op1))
+			continue;
+		if (!match(params->Op2, e->param.Op2))
+			continue;
+
+		/* If function fails, it should complain. */
+		if (!e->f(vcpu, params, e->arg))
+			goto fail;
+
+		/* Skip instruction, since it was emulated */
+		instr_len = ((vcpu->arch.hsr >> 25) & 1) ? 4 : 2;
+		*vcpu_reg(vcpu, 15) += instr_len;
+		return 0;
 	}
 
-	if (!ok)
-		goto unsupp_err_out;
-
-	/* Skip instruction, since it was emulated */
-	instr_len = ((vcpu->arch.hsr >> 25) & 1) ? 4 : 2;
-	*vcpu_reg(vcpu, 15) += instr_len;
-
-	return 0;
-
-unsupp_err_out:	
-	kvm_err("Unsupported guest CP15 access at: %08x\n", vcpu->arch.regs.pc);
+	kvm_err("Unsupported guest CP15 access at: %08x\n",
+		vcpu->arch.regs.pc);
 	print_cp_instr(params);
+fail:
 	return -EINVAL;
 }
 

