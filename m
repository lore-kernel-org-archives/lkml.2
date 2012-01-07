Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2AGUXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 15:23:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54688 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2AGUXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 15:23:15 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1251.1)
Subject: [PATCH] KVM: fix mov immediate emulation for 64-bit operands
From: Nadav Amit <nadav.amit@gmail.com>
Date: Sat, 7 Jan 2012 22:21:35 +0200
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <E0EE2EE9-96C1-4354-BDCE-19E3AF2C0F30@gmail.com>
References: <1325967346-12539-1-git-send-email-namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MOV immediate instruction (opcodes 0xB8-0xBF) may take 64-bit operand.
The previous emulation implementation assumes the operand is no longer than 32.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
arch/x86/kvm/emulate.c |    6 +++++-
1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 05a562b..65d1d31 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3502,7 +3502,8 @@ static unsigned imm_size(struct x86_emulate_ctxt *ctxt)
	unsigned size;

	size = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
-	if (size == 8)
+	/* Immediates are usually no longer than 4 bytes */
+	if (size == 8 && ((ctxt->b & 0xF8) != 0xB8 || ctxt->twobyte))
		size = 4;
	return size;
}
@@ -3526,6 +3527,9 @@ static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
	case 4:
		op->val = insn_fetch(s32, ctxt);
		break;
+	case 8:
+		op->val = insn_fetch(s64, ctxt);
+		break;
	}
	if (!sign_extension) {
		switch (op->bytes) {
-- 
1.7.4.1


