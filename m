Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab2AKQxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:53:51 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:54382 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab2AKQxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:53:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAJe9DU+ERM5e/2dsb2JhbABCrGuBBYIgUoECPBO/UIwdBKACh0g
X-IronPort-AV: E=Sophos;i="4.71,493,1320616800"; 
   d="scan'208";a="74150932"
From: Nadav Amit <namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH 1/2] KVM: Exception during emulation decode should propagate
Date: Wed, 11 Jan 2012 18:53:30 +0200
Message-Id: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An exception might occur during decode (e.g., #PF during fetch).
Currently, the exception is ignored and emulation is performed.
Instead, emulation should be skipped and the fault should be injected.
Skipping instruction should report a failure in this case.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 arch/x86/kvm/emulate.c |    3 +++
 arch/x86/kvm/x86.c     |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 05a562b..e06dc98 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3869,6 +3869,9 @@ done:
 	if (ctxt->memopp && ctxt->memopp->type == OP_MEM && ctxt->rip_relative)
 		ctxt->memopp->addr.mem.ea += ctxt->_eip;
 
+	if (rc == X86EMUL_PROPAGATE_FAULT)
+		ctxt->have_exception = true;
+
 	return (rc != X86EMUL_CONTINUE) ? EMULATION_FAILED : EMULATION_OK;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1171def..05fd3d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4443,10 +4443,17 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	}
 
 	if (emulation_type & EMULTYPE_SKIP) {
+		if (ctxt->have_exception)
+			return EMULATE_FAIL;
 		kvm_rip_write(vcpu, ctxt->_eip);
 		return EMULATE_DONE;
 	}
 
+	if (ctxt->have_exception) {
+		writeback = false;
+		goto post;
+	}
+
 	if (retry_instruction(ctxt, cr2, emulation_type))
 		return EMULATE_DONE;
 
@@ -4470,6 +4477,7 @@ restart:
 		return handle_emulation_failure(vcpu);
 	}
 
+post:
 	if (ctxt->have_exception) {
 		inject_emulated_exception(vcpu);
 		r = EMULATE_DONE;
-- 
1.7.4.1

