Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0HXLKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:10:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab0HXLKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:10:33 -0400
From: Avi Kivity <avi@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86 emulator: trap and propagate #DE from DIV and IDIV
Date: Tue, 24 Aug 2010 14:10:29 +0300
Message-Id: <1282648229-19575-4-git-send-email-avi@redhat.com>
In-Reply-To: <1282648229-19575-1-git-send-email-avi@redhat.com>
References: <1282648229-19575-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f82e43a..a7e26d0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -505,6 +505,12 @@ static void emulate_ts(struct x86_emulate_ctxt *ctxt, int err)
 	emulate_exception(ctxt, TS_VECTOR, err, true);
 }
 
+static int emulate_de(struct x86_emulate_ctxt *ctxt)
+{
+	emulate_exception(ctxt, DE_VECTOR, 0, false);
+	return X86EMUL_PROPAGATE_FAULT;
+}
+
 static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 			      struct x86_emulate_ops *ops,
 			      unsigned long eip, u8 *dest)
@@ -1459,6 +1465,7 @@ static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
 	struct decode_cache *c = &ctxt->decode;
 	unsigned long *rax = &c->regs[VCPU_REGS_RAX];
 	unsigned long *rdx = &c->regs[VCPU_REGS_RDX];
+	u8 de = 0;
 
 	switch (c->modrm_reg) {
 	case 0 ... 1:	/* test */
@@ -1477,14 +1484,18 @@ static inline int emulate_grp3(struct x86_emulate_ctxt *ctxt,
 		emulate_1op_rax_rdx("imul", c->src, *rax, *rdx, ctxt->eflags);
 		break;
 	case 6: /* div */
-		emulate_1op_rax_rdx("div", c->src, *rax, *rdx, ctxt->eflags);
+		emulate_1op_rax_rdx_ex("div", c->src, *rax, *rdx,
+				       ctxt->eflags, de);
 		break;
 	case 7: /* idiv */
-		emulate_1op_rax_rdx("idiv", c->src, *rax, *rdx, ctxt->eflags);
+		emulate_1op_rax_rdx_ex("idiv", c->src, *rax, *rdx,
+				       ctxt->eflags, de);
 		break;
 	default:
 		return X86EMUL_UNHANDLEABLE;
 	}
+	if (de)
+		return emulate_de(ctxt);
 	return X86EMUL_CONTINUE;
 }
 
@@ -3363,7 +3374,7 @@ special_insn:
 		break;
 	case 0xf6 ... 0xf7:	/* Grp3 */
 		if (emulate_grp3(ctxt, ops) != X86EMUL_CONTINUE)
-			goto cannot_emulate;
+			goto done;
 		break;
 	case 0xf8: /* clc */
 		ctxt->eflags &= ~EFLG_CF;
-- 
1.7.1

