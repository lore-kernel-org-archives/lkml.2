Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2GIJDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:03:00 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52342 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2GIJC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:02:58 -0400
Message-ID: <4FFA9E16.10001@linux.vnet.ibm.com>
Date: Mon, 09 Jul 2012 17:02:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12070909-2674-0000-0000-0000052E4203
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit f78146b0f9230765c6315b2e14f56112513389ad:

 KVM: Fix page-crossing MMIO

    MMIO that are split across a page boundary are currently broken - the
    code does not expect to be aborted by the exit to userspace for the
    first MMIO fragment.

    This patch fixes the problem by generalizing the current code for handling
    16-byte MMIOs to handle a number of "fragments", and changes the MMIO
    code to create those fragments.

    Signed-off-by: Avi Kivity <avi@redhat.com>
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Multiple MMIO reads can be merged into mmio_fragments, the read buffer is not
needed anymore

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 -
 arch/x86/kvm/emulate.c             |   43 ++++-------------------------------
 arch/x86/kvm/x86.c                 |    2 -
 3 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 1ac46c22..339d7c6 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -286,7 +286,6 @@ struct x86_emulate_ctxt {
 	struct operand *memopp;
 	struct fetch_cache fetch;
 	struct read_cache io_read;
-	struct read_cache mem_read;
 };

 /* Repeat String Operation Prefix */
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f95d242..aa455da 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1128,33 +1128,6 @@ static void fetch_bit_operand(struct x86_emulate_ctxt *ctxt)
 	ctxt->src.val &= (ctxt->dst.bytes << 3) - 1;
 }

-static int read_emulated(struct x86_emulate_ctxt *ctxt,
-			 unsigned long addr, void *dest, unsigned size)
-{
-	int rc;
-	struct read_cache *mc = &ctxt->mem_read;
-
-	while (size) {
-		int n = min(size, 8u);
-		size -= n;
-		if (mc->pos < mc->end)
-			goto read_cached;
-
-		rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, n,
-					      &ctxt->exception);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
-		mc->end += n;
-
-	read_cached:
-		memcpy(dest, mc->data + mc->pos, n);
-		mc->pos += n;
-		dest += n;
-		addr += n;
-	}
-	return X86EMUL_CONTINUE;
-}
-
 static int segmented_read(struct x86_emulate_ctxt *ctxt,
 			  struct segmented_address addr,
 			  void *data,
@@ -1166,7 +1139,9 @@ static int segmented_read(struct x86_emulate_ctxt *ctxt,
 	rc = linearize(ctxt, addr, size, false, &linear);
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
-	return read_emulated(ctxt, linear, data, size);
+
+	return ctxt->ops->read_emulated(ctxt, linear, data, size,
+					&ctxt->exception);
 }

 static int segmented_write(struct x86_emulate_ctxt *ctxt,
@@ -4122,8 +4097,6 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	int rc = X86EMUL_CONTINUE;
 	int saved_dst_type = ctxt->dst.type;

-	ctxt->mem_read.pos = 0;
-
 	if (ctxt->mode == X86EMUL_MODE_PROT64 && (ctxt->d & No64)) {
 		rc = emulate_ud(ctxt);
 		goto done;
@@ -4364,15 +4337,9 @@ writeback:
 			 * or, if it is not used, after each 1024 iteration.
 			 */
 			if ((r->end != 0 || ctxt->regs[VCPU_REGS_RCX] & 0x3ff) &&
-			    (r->end == 0 || r->end != r->pos)) {
-				/*
-				 * Reset read cache. Usually happens before
-				 * decode, but since instruction is restarted
-				 * we have to do it here.
-				 */
-				ctxt->mem_read.end = 0;
+			    (r->end == 0 || r->end != r->pos))
 				return EMULATION_RESTART;
-			}
+
 			goto done; /* skip rip writeback */
 		}
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a01a424..7445545 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4399,8 +4399,6 @@ static void init_decode_cache(struct x86_emulate_ctxt *ctxt,
 	ctxt->fetch.end = 0;
 	ctxt->io_read.pos = 0;
 	ctxt->io_read.end = 0;
-	ctxt->mem_read.pos = 0;
-	ctxt->mem_read.end = 0;
 }

 static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
-- 
1.7.7.6

