Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1DOD2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:28:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63707 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1DOD2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fK/zqP4/VNXWdCk84I1YNHEYbIZlAQUk0ZYSseg5/vL1fbSn/Q9/9/0cNnjutGQSHf
         X8yTE8vpxo8DRJJ07sTlcT2/bDrDYteg1qEAJDaF+7Zu2YOaQiQRLgXgEtO3/PpPHObz
         77++EO6kCLzUSDSdKWEy1nXPTZkUBcf85INi8=
From: Nelson Elhage <nelhage@ksplice.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH] KVM: emulator: Use linearize() when fetching instructions.
Date: Thu, 14 Apr 2011 23:27:52 -0400
Message-Id: <1302838072-16717-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.2.43.g36c08.dirty
In-Reply-To: <4DA5CA0E.8050102@redhat.com>
References: <4DA5CA0E.8050102@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This means that the truncation behavior in linearize needs to grow an additional
slight piece of complexity: when fetching, truncation is dependent on the
execution mode, instead of the current address size.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 -
 arch/x86/kvm/emulate.c             |   23 ++++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 0818448..9b760c8 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -265,7 +265,6 @@ struct x86_emulate_ctxt {
 	unsigned long eip; /* eip before instruction emulation */
 	/* Emulated execution mode, represented by an X86EMUL_MODE value. */
 	int mode;
-	u32 cs_base;
 
 	/* interruptibility state, as a result of execution of STI or MOV SS */
 	int interruptibility;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index a5f63d4..d3d43a7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -542,7 +542,7 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
 
 static int linearize(struct x86_emulate_ctxt *ctxt,
 		     struct segmented_address addr,
-		     unsigned size, bool write,
+		     unsigned size, bool write, bool fetch,
 		     ulong *linear)
 {
 	struct decode_cache *c = &ctxt->decode;
@@ -602,7 +602,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 		}
 		break;
 	}
-	if (c->ad_bytes != 8)
+	if (fetch ? ctxt->mode != X86EMUL_MODE_PROT64 : c->ad_bytes != 8)
 		la &= (u32)-1;
 	*linear = la;
 	return X86EMUL_CONTINUE;
@@ -621,7 +621,7 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
 	int rc;
 	ulong linear;
 
-	rc = linearize(ctxt, addr, size, false, &linear);
+	rc = linearize(ctxt, addr, size, false, false, &linear);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	return ctxt->ops->read_std(linear, data, size, ctxt->vcpu,
@@ -637,11 +637,13 @@ static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 	int size, cur_size;
 
 	if (eip == fc->end) {
-		unsigned long linear = eip + ctxt->cs_base;
-		if (ctxt->mode != X86EMUL_MODE_PROT64)
-			linear &= (u32)-1;
+		unsigned long linear;
+		struct segmented_address addr = {VCPU_SREG_CS, eip};
 		cur_size = fc->end - fc->start;
 		size = min(15UL - cur_size, PAGE_SIZE - offset_in_page(eip));
+		rc = linearize(ctxt, addr, size, false, true, &linear);
+		f (rc != X86EMUL_CONTINUE)
+			return rc;
 		rc = ops->fetch(linear, fc->data + cur_size,
 				size, ctxt->vcpu, &ctxt->exception);
 		if (rc != X86EMUL_CONTINUE)
@@ -1047,7 +1049,7 @@ static int segmented_read(struct x86_emulate_ctxt *ctxt,
 	int rc;
 	ulong linear;
 
-	rc = linearize(ctxt, addr, size, false, &linear);
+	rc = linearize(ctxt, addr, size, false, false, &linear);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	return read_emulated(ctxt, ctxt->ops, linear, data, size);
@@ -1061,7 +1063,7 @@ static int segmented_write(struct x86_emulate_ctxt *ctxt,
 	int rc;
 	ulong linear;
 
-	rc = linearize(ctxt, addr, size, true, &linear);
+	rc = linearize(ctxt, addr, size, true, false, &linear);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	return ctxt->ops->write_emulated(linear, data, size,
@@ -1076,7 +1078,7 @@ static int segmented_cmpxchg(struct x86_emulate_ctxt *ctxt,
 	int rc;
 	ulong linear;
 
-	rc = linearize(ctxt, addr, size, true, &linear);
+	rc = linearize(ctxt, addr, size, true, false, &linear);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	return ctxt->ops->cmpxchg_emulated(linear, orig_data, data,
@@ -2576,7 +2578,7 @@ static int em_invlpg(struct x86_emulate_ctxt *ctxt)
 	int rc;
 	ulong linear;
 
-	rc = linearize(ctxt, c->src.addr.mem, 1, false, &linear);
+	rc = linearize(ctxt, c->src.addr.mem, 1, false, false, &linear);
 	if (rc == X86EMUL_CONTINUE)
 		emulate_invlpg(ctxt->vcpu, linear);
 	/* Disable writeback. */
@@ -3154,7 +3156,6 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	c->fetch.end = c->fetch.start + insn_len;
 	if (insn_len > 0)
 		memcpy(c->fetch.data, insn, insn_len);
-	ctxt->cs_base = seg_base(ctxt, ops, VCPU_SREG_CS);
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
-- 
1.7.2.43.g36c08.dirty

