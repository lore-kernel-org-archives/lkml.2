Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1F3Fgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:36:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54020 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1F3Fgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:36:39 -0400
Date: Thu, 30 Jun 2011 15:36:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the kvm tree with the Linus' tree
Message-Id: <20110630153634.ec4cd661.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/kvm/emulate.c between commit cb16c348760a ("KVM: x86 emulator:
fix %rip-relative addressing with immediate source operand") from Linus'
tree and commits e120b4860acb ("KVM: x86 emulator: rename
decode_cache::eip to _eip") and 10fd484b79a8 ("KVM: x86 emulator: fold
decode_cache into x86_emulate_ctxt") from the kvm tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kvm/emulate.c
index adc9867,14891ad..0000000
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@@ -3372,13 -3342,13 +3342,13 @@@ int x86_decode_insn(struct x86_emulate_
  	int def_op_bytes, def_ad_bytes, goffset, simd_prefix;
  	bool op_prefix = false;
  	struct opcode opcode;
 -	struct operand memop = { .type = OP_NONE };
 +	struct operand memop = { .type = OP_NONE }, *memopp = NULL;
  
- 	c->eip = ctxt->eip;
- 	c->fetch.start = c->eip;
- 	c->fetch.end = c->fetch.start + insn_len;
+ 	ctxt->_eip = ctxt->eip;
+ 	ctxt->fetch.start = ctxt->_eip;
+ 	ctxt->fetch.end = ctxt->fetch.start + insn_len;
  	if (insn_len > 0)
- 		memcpy(c->fetch.data, insn, insn_len);
+ 		memcpy(ctxt->fetch.data, insn, insn_len);
  
  	switch (mode) {
  	case X86EMUL_MODE_REAL:
@@@ -3539,14 -3509,17 +3509,14 @@@ done_prefixes
  	if (rc != X86EMUL_CONTINUE)
  		goto done;
  
- 	if (!c->has_seg_override)
- 		set_seg_override(c, VCPU_SREG_DS);
+ 	if (!ctxt->has_seg_override)
+ 		set_seg_override(ctxt, VCPU_SREG_DS);
  
- 	memop.addr.mem.seg = seg_override(ctxt, c);
+ 	memop.addr.mem.seg = seg_override(ctxt);
  
- 	if (memop.type == OP_MEM && c->ad_bytes != 8)
+ 	if (memop.type == OP_MEM && ctxt->ad_bytes != 8)
  		memop.addr.mem.ea = (u32)memop.addr.mem.ea;
  
 -	if (memop.type == OP_MEM && ctxt->rip_relative)
 -		memop.addr.mem.ea += ctxt->_eip;
 -
  	/*
  	 * Decode and fetch the source operand: register, memory
  	 * or immediate.
@@@ -3564,53 -3537,52 +3534,53 @@@
  		memop.bytes = 4;
  		goto srcmem_common;
  	case SrcMem:
- 		memop.bytes = (c->d & ByteOp) ? 1 :
- 							   c->op_bytes;
+ 		memop.bytes = (ctxt->d & ByteOp) ? 1 :
+ 							   ctxt->op_bytes;
  	srcmem_common:
- 		c->src = memop;
- 		memopp = &c->src;
+ 		ctxt->src = memop;
++		memopp = &ctxt->src;
  		break;
  	case SrcImmU16:
- 		rc = decode_imm(ctxt, &c->src, 2, false);
+ 		rc = decode_imm(ctxt, &ctxt->src, 2, false);
  		break;
  	case SrcImm:
- 		rc = decode_imm(ctxt, &c->src, imm_size(c), true);
+ 		rc = decode_imm(ctxt, &ctxt->src, imm_size(ctxt), true);
  		break;
  	case SrcImmU:
- 		rc = decode_imm(ctxt, &c->src, imm_size(c), false);
+ 		rc = decode_imm(ctxt, &ctxt->src, imm_size(ctxt), false);
  		break;
  	case SrcImmByte:
- 		rc = decode_imm(ctxt, &c->src, 1, true);
+ 		rc = decode_imm(ctxt, &ctxt->src, 1, true);
  		break;
  	case SrcImmUByte:
- 		rc = decode_imm(ctxt, &c->src, 1, false);
+ 		rc = decode_imm(ctxt, &ctxt->src, 1, false);
  		break;
  	case SrcAcc:
- 		c->src.type = OP_REG;
- 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
- 		c->src.addr.reg = &c->regs[VCPU_REGS_RAX];
- 		fetch_register_operand(&c->src);
+ 		ctxt->src.type = OP_REG;
+ 		ctxt->src.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
+ 		ctxt->src.addr.reg = &ctxt->regs[VCPU_REGS_RAX];
+ 		fetch_register_operand(&ctxt->src);
  		break;
  	case SrcOne:
- 		c->src.bytes = 1;
- 		c->src.val = 1;
+ 		ctxt->src.bytes = 1;
+ 		ctxt->src.val = 1;
  		break;
  	case SrcSI:
- 		c->src.type = OP_MEM;
- 		c->src.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
- 		c->src.addr.mem.ea =
- 			register_address(c, c->regs[VCPU_REGS_RSI]);
- 		c->src.addr.mem.seg = seg_override(ctxt, c);
- 		c->src.val = 0;
+ 		ctxt->src.type = OP_MEM;
+ 		ctxt->src.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
+ 		ctxt->src.addr.mem.ea =
+ 			register_address(ctxt, ctxt->regs[VCPU_REGS_RSI]);
+ 		ctxt->src.addr.mem.seg = seg_override(ctxt);
+ 		ctxt->src.val = 0;
  		break;
  	case SrcImmFAddr:
- 		c->src.type = OP_IMM;
- 		c->src.addr.mem.ea = c->eip;
- 		c->src.bytes = c->op_bytes + 2;
- 		insn_fetch_arr(c->src.valptr, c->src.bytes, c->eip);
+ 		ctxt->src.type = OP_IMM;
+ 		ctxt->src.addr.mem.ea = ctxt->_eip;
+ 		ctxt->src.bytes = ctxt->op_bytes + 2;
+ 		insn_fetch_arr(ctxt->src.valptr, ctxt->src.bytes, ctxt->_eip);
  		break;
  	case SrcMemFAddr:
- 		memop.bytes = c->op_bytes + 2;
+ 		memop.bytes = ctxt->op_bytes + 2;
  		goto srcmem_common;
  		break;
  	case SrcDX:
@@@ -3664,48 -3636,44 +3634,48 @@@
  		break;
  	case DstMem:
  	case DstMem64:
- 		c->dst = memop;
- 		memopp = &c->dst;
- 		if ((c->d & DstMask) == DstMem64)
- 			c->dst.bytes = 8;
+ 		ctxt->dst = memop;
++		memopp = &ctxt->dst;
+ 		if ((ctxt->d & DstMask) == DstMem64)
+ 			ctxt->dst.bytes = 8;
  		else
- 			c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
- 		if (c->d & BitOp)
- 			fetch_bit_operand(c);
- 		c->dst.orig_val = c->dst.val;
+ 			ctxt->dst.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
+ 		if (ctxt->d & BitOp)
+ 			fetch_bit_operand(ctxt);
+ 		ctxt->dst.orig_val = ctxt->dst.val;
  		break;
  	case DstAcc:
- 		c->dst.type = OP_REG;
- 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
- 		c->dst.addr.reg = &c->regs[VCPU_REGS_RAX];
- 		fetch_register_operand(&c->dst);
- 		c->dst.orig_val = c->dst.val;
+ 		ctxt->dst.type = OP_REG;
+ 		ctxt->dst.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
+ 		ctxt->dst.addr.reg = &ctxt->regs[VCPU_REGS_RAX];
+ 		fetch_register_operand(&ctxt->dst);
+ 		ctxt->dst.orig_val = ctxt->dst.val;
  		break;
  	case DstDI:
- 		c->dst.type = OP_MEM;
- 		c->dst.bytes = (c->d & ByteOp) ? 1 : c->op_bytes;
- 		c->dst.addr.mem.ea =
- 			register_address(c, c->regs[VCPU_REGS_RDI]);
- 		c->dst.addr.mem.seg = VCPU_SREG_ES;
- 		c->dst.val = 0;
+ 		ctxt->dst.type = OP_MEM;
+ 		ctxt->dst.bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
+ 		ctxt->dst.addr.mem.ea =
+ 			register_address(ctxt, ctxt->regs[VCPU_REGS_RDI]);
+ 		ctxt->dst.addr.mem.seg = VCPU_SREG_ES;
+ 		ctxt->dst.val = 0;
  		break;
  	case DstDX:
- 		c->dst.type = OP_REG;
- 		c->dst.bytes = 2;
- 		c->dst.addr.reg = &c->regs[VCPU_REGS_RDX];
- 		fetch_register_operand(&c->dst);
+ 		ctxt->dst.type = OP_REG;
+ 		ctxt->dst.bytes = 2;
+ 		ctxt->dst.addr.reg = &ctxt->regs[VCPU_REGS_RDX];
+ 		fetch_register_operand(&ctxt->dst);
  		break;
  	case ImplicitOps:
  		/* Special instructions do their own operand decoding. */
  	default:
- 		c->dst.type = OP_NONE; /* Disable writeback. */
+ 		ctxt->dst.type = OP_NONE; /* Disable writeback. */
 -		return 0;
 +		break;
  	}
  
  done:
- 	if (memopp && memopp->type == OP_MEM && c->rip_relative)
- 		memopp->addr.mem.ea += c->eip;
++	if (memopp && memopp->type == OP_MEM && ctxt->rip_relative)
++		memopp->addr.mem.ea += ctxt->_eip;
 +
  	return (rc == X86EMUL_UNHANDLEABLE) ? EMULATION_FAILED : EMULATION_OK;
  }
  
