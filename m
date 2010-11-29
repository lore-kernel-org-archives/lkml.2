Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0K2QxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:53:04 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:46961
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab0K2QxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:53:02 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCNO6L-01-CRZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] KVM: X86: Don't report L2 emulation failures to user-space
Date: Mon, 29 Nov 2010 17:51:49 +0100
Message-ID: <1291049509-3430-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <4CF3D093.40604@redhat.com>
References: <4CF3D093.40604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents that emulation failures which result
from emulating an instruction for an L2-Guest results in
being reported to userspace.
Without this patch a malicious L2-Guest would be able to
kill the L1 by triggering a race-condition between an vmexit
and the instruction emulator.
With this patch the L2 will most likely only kill itself in
this situation.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/x86.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 410d2d1..4337a8b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4320,13 +4320,19 @@ EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
 static int handle_emulation_failure(struct kvm_vcpu *vcpu)
 {
+	int r = EMULATE_DONE;
+
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
+	if (!is_guest_mode(vcpu)) {
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+		vcpu->run->internal.ndata = 0;
+		r = EMULATE_FAIL;
+	}
 	kvm_queue_exception(vcpu, UD_VECTOR);
-	return EMULATE_FAIL;
+
+	return r;
 }
 
 static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
-- 
1.7.1


