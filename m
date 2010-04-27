Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0D0KjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:6377 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0D0KjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:04 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WS-01-331-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/22] KVM: X86: Propagate fetch faults
Date: Tue, 27 Apr 2010 12:38:28 +0200
Message-ID: <1272364712-17425-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0152 (UTC) FILETIME=[CA8DCF80:01CAE5F5]
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
 arch/x86/kvm/emulate.c |    2 +-
 arch/x86/kvm/x86.c     |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 171e1c7..bb90307 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1260,7 +1260,7 @@ done_prefixes:
 	}
 
 done:
-	return (rc == X86EMUL_UNHANDLEABLE) ? -1 : 0;
+	return rc;
 }
 
 static int pio_in_emulated(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4d3a698..d159319 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3856,6 +3856,10 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
 
 		r = x86_decode_insn(&vcpu->arch.emulate_ctxt, &emulate_ops);
+		if (r == X86EMUL_PROPAGATE_FAULT) {
+			kvm_propagate_fault(vcpu);
+			return EMULATE_DONE;
+		}
 		trace_kvm_emulate_insn_start(vcpu);
 
 		/* Only allow emulation of specific instructions on #UD
-- 
1.7.0.4


