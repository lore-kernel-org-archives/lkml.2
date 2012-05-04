Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2EDQOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:14:53 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:9890
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105Ab2EDQOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:14:51 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3IAGJ-01-9YV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] KVM: X86: Remove stale values from ctxt->memop before emulation
Date: Fri, 4 May 2012 18:14:16 +0200
Message-ID: <1336148056-15662-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When instruction decoding begins there could be stale values
in the ctxt->memop structure. This causes problems when an
instruction is emulated with more op-bytes then the guest
wants (like the bsr instruction which is always emulated
with 4 or 8 op-bytes).

The stale value in this structure causes the unit-test for
the bsrw instruction to fail. Initialize the memop.val with
0 to prevent such bugs (an alternative fix could be to
always emulate instructions with the number of op-bytes
requested by the guest).

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/emulate.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d4bf50c..1b516ec 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3937,6 +3937,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	struct opcode opcode;
 
 	ctxt->memop.type = OP_NONE;
+	ctxt->memop.val  = 0;
 	ctxt->memopp = NULL;
 	ctxt->_eip = ctxt->eip;
 	ctxt->fetch.start = ctxt->_eip;
-- 
1.7.9.5


