Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1DRQHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:07:55 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65221 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1DRQHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:07:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=ksplice.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=M9MGu54DjjdZAllr51/t54VfZL5V+3YCN9CbPHeIutjpvrt5XFVWCDUwIsiYSrgdYY
         ps/C5wg/VLbZ0Ey3v9pM6ozFKFneA/3bPD0uxM2D7VEND35kEV1vderrLOxLPt031JMR
         K92giQoAsC6N3Gia/imzeNYTOcHOFpIZ4qbU8=
From: Nelson Elhage <nelhage@ksplice.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH v2] KVM: emulator: Use linearize() when fetching instructions.
Date: Mon, 18 Apr 2011 12:05:53 -0400
Message-Id: <1303142753-24562-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.4.44.gf9e72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since segments need to be handled slightly differently when fetching
instructions, we add a __linearize helper that accepts a new 'fetch' boolean.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 -
 arch/x86/kvm/emulate.c             |   26 ++++++++++++++++++--------
 2 files changed, 18 insertions(+), 9 deletions(-)

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
index a5f63d4..427d78a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -540,9 +540,9 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
 	return emulate_exception(ctxt, NM_VECTOR, 0, false);
 }
 
-static int linearize(struct x86_emulate_ctxt *ctxt,
+static int __linearize(struct x86_emulate_ctxt *ctxt,
 		     struct segmented_address addr,
-		     unsigned size, bool write,
+		     unsigned size, bool write, bool fetch,
 		     ulong *linear)
 {
 	struct decode_cache *c = &ctxt->decode;
@@ -569,7 +569,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 		if (((desc.type & 8) || !(desc.type & 2)) && write)
 			goto bad;
 		/* unreadable code segment */
-		if ((desc.type & 8) && !(desc.type & 2))
+		if (!fetch && (desc.type & 8) && !(desc.type & 2))
 			goto bad;
 		lim = desc_limit_scaled(&desc);
 		if ((desc.type & 8) || !(desc.type & 4)) {
@@ -602,7 +602,7 @@ static int linearize(struct x86_emulate_ctxt *ctxt,
 		}
 		break;
 	}
-	if (c->ad_bytes != 8)
+	if (fetch ? ctxt->mode != X86EMUL_MODE_PROT64 : c->ad_bytes != 8)
 		la &= (u32)-1;
 	*linear = la;
 	return X86EMUL_CONTINUE;
@@ -613,6 +613,15 @@ bad:
 		return emulate_gp(ctxt, addr.seg);
 }
 
+static int linearize(struct x86_emulate_ctxt *ctxt,
+		     struct segmented_address addr,
+		     unsigned size, bool write,
+		     ulong *linear)
+{
+	return __linearize(ctxt, addr, size, write, false, linear);
+}
+
+
 static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
 			      struct segmented_address addr,
 			      void *data,
@@ -637,11 +646,13 @@ static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
 	int size, cur_size;
 
 	if (eip == fc->end) {
-		unsigned long linear = eip + ctxt->cs_base;
-		if (ctxt->mode != X86EMUL_MODE_PROT64)
-			linear &= (u32)-1;
+		unsigned long linear;
+		struct segmented_address addr = {VCPU_SREG_CS, eip};
 		cur_size = fc->end - fc->start;
 		size = min(15UL - cur_size, PAGE_SIZE - offset_in_page(eip));
+		rc = __linearize(ctxt, addr, size, false, true, &linear);
+		if (rc != X86EMUL_CONTINUE)
+			return rc;
 		rc = ops->fetch(linear, fc->data + cur_size,
 				size, ctxt->vcpu, &ctxt->exception);
 		if (rc != X86EMUL_CONTINUE)
@@ -3154,7 +3165,6 @@ x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len)
 	c->fetch.end = c->fetch.start + insn_len;
 	if (insn_len > 0)
 		memcpy(c->fetch.data, insn, insn_len);
-	ctxt->cs_base = seg_base(ctxt, ops, VCPU_SREG_CS);
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
-- 
1.7.4.44.gf9e72

