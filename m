Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab1KCMe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:34:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933554Ab1KCMe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:34:29 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv2 9/9] KVM: x86 emulator: implement RDPMC (0F 33)
Date: Thu,  3 Nov 2011 14:33:38 +0200
Message-Id: <1320323618-10375-10-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323618-10375-1-git-send-email-gleb@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@redhat.com>

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/kvm/emulate.c             |   13 ++++++++++++-
 arch/x86/kvm/x86.c                 |    7 +++++++
 3 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 9a4acf4..ab4092e 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -181,6 +181,7 @@ struct x86_emulate_ops {
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
 	int (*set_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
+	int (*read_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc, u64 *pdata);
 	void (*halt)(struct x86_emulate_ctxt *ctxt);
 	void (*wbinvd)(struct x86_emulate_ctxt *ctxt);
 	int (*fix_hypercall)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c0ee85b..d76a852 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2623,6 +2623,17 @@ static int em_rdtsc(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
+static int em_rdpmc(struct x86_emulate_ctxt *ctxt)
+{
+	u64 pmc;
+
+	if (ctxt->ops->read_pmc(ctxt, ctxt->regs[VCPU_REGS_RCX], &pmc))
+		return emulate_gp(ctxt, 0);
+	ctxt->regs[VCPU_REGS_RAX] = (u32)pmc;
+	ctxt->regs[VCPU_REGS_RDX] = pmc >> 32;
+	return X86EMUL_CONTINUE;
+}
+
 static int em_mov(struct x86_emulate_ctxt *ctxt)
 {
 	ctxt->dst.val = ctxt->src.val;
@@ -3254,7 +3265,7 @@ static struct opcode twobyte_table[256] = {
 	DI(ImplicitOps | Priv, wrmsr),
 	IIP(ImplicitOps, em_rdtsc, rdtsc, check_rdtsc),
 	DI(ImplicitOps | Priv, rdmsr),
-	DIP(ImplicitOps, rdpmc, check_rdpmc),
+	IIP(ImplicitOps, em_rdpmc, rdpmc, check_rdpmc),
 	I(ImplicitOps | VendorSpecific, em_sysenter),
 	I(ImplicitOps | Priv | VendorSpecific, em_sysexit),
 	N, N,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c9c8c9..9ca94d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4655,6 +4655,12 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 	return kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
 }
 
+static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
+			     u32 pmc, u64 *pdata)
+{
+	return kvm_pmu_read_pmc(emul_to_vcpu(ctxt), pmc, pdata);
+}
+
 static void emulator_halt(struct x86_emulate_ctxt *ctxt)
 {
 	emul_to_vcpu(ctxt)->arch.halt_request = 1;
@@ -4707,6 +4713,7 @@ static struct x86_emulate_ops emulate_ops = {
 	.set_dr              = emulator_set_dr,
 	.set_msr             = emulator_set_msr,
 	.get_msr             = emulator_get_msr,
+	.read_pmc            = emulator_read_pmc,
 	.halt                = emulator_halt,
 	.wbinvd              = emulator_wbinvd,
 	.fix_hypercall       = emulator_fix_hypercall,
-- 
1.7.5.3

