Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab0IFP5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:57:31 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:37973
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105Ab0IFP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:57:25 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-02-7A3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/27] KVM: X86: Propagate fetch faults
Date: Mon, 6 Sep 2010 17:55:58 +0200
Message-ID: <1283788566-29186-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
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
index 65b00f0..ca69dcc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4237,6 +4237,9 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 		vcpu->arch.emulate_ctxt.perm_ok = false;
 
 		r = x86_decode_insn(&vcpu->arch.emulate_ctxt);
+		if (r == X86EMUL_PROPAGATE_FAULT)
+			goto done;
+
 		trace_kvm_emulate_insn_start(vcpu);
 
 		/* Only allow emulation of specific instructions on #UD
@@ -4295,6 +4298,7 @@ restart:
 		return handle_emulation_failure(vcpu);
 	}
 
+done:
 	if (vcpu->arch.emulate_ctxt.exception >= 0) {
 		inject_emulated_exception(vcpu);
 		r = EMULATE_DONE;
-- 
1.7.0.4


