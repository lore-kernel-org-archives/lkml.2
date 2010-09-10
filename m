Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0IJPgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:36:20 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:34901 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0IJPcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:45 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF40-02-JQ0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/29] KVM: X86: Propagate fetch faults
Date: Fri, 10 Sep 2010 17:30:56 +0200
Message-ID: <1284132667-18620-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM currently ignores fetch faults in the instruction
emulator. With nested-npt we could have such faults. This
patch adds the code to handle these.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/emulate.c |    3 +++
 arch/x86/kvm/x86.c     |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2b08b78..aead72e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1198,6 +1198,9 @@ static int emulate_popf(struct x86_emulate_ctxt *ctxt,
 	*(unsigned long *)dest =
 		(ctxt->eflags & ~change_mask) | (val & change_mask);
 
+	if (rc == X86EMUL_PROPAGATE_FAULT)
+		emulate_pf(ctxt);
+
 	return rc;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2816e5a..16c044b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4233,6 +4233,9 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		vcpu->arch.emulate_ctxt.perm_ok = false;
 
 		r = x86_decode_insn(&vcpu->arch.emulate_ctxt);
+		if (r == X86EMUL_PROPAGATE_FAULT)
+			goto done;
+
 		trace_kvm_emulate_insn_start(vcpu);
 
 		/* Only allow emulation of specific instructions on #UD
@@ -4291,6 +4294,7 @@ restart:
 		return handle_emulation_failure(vcpu);
 	}
 
+done:
 	if (vcpu->arch.emulate_ctxt.exception >= 0) {
 		inject_emulated_exception(vcpu);
 		r = EMULATE_DONE;
-- 
1.7.0.4


