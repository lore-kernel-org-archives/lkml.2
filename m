Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1HBLFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:05:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60411 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1HBLFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:05:33 -0400
Message-ID: <4E37DA73.7010908@cn.fujitsu.com>
Date: Tue, 02 Aug 2011 19:07:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 02/12] KVM: x86: tag the instructions which are used to
 write page table
References: <4E37DA49.1040000@cn.fujitsu.com>
In-Reply-To: <4E37DA49.1040000@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 19:04:32,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 19:04:33,
	Serialize complete at 2011-08-02 19:04:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is from Avi:
| tag instructions that are typically used to modify the page tables, and drop
| shadow if any other instruction is used
| The list would include, I'd guess, and, or, bts, btc, mov, xchg, cmpxchg, and
| cmpxchg8b

This patch is used to tag the instructions and in the later path, shadow page
is dropped if it is written by other instructions

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/kvm/emulate.c             |    8 ++++++++
 arch/x86/kvm/x86.c                 |    1 +
 arch/x86/kvm/x86.h                 |    5 +++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 6040d11..049a6f5 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -244,6 +244,7 @@ struct x86_emulate_ctxt {
 	bool guest_mode; /* guest running a nested guest */
 	bool perm_ok; /* do not check permissions if true */
 	bool only_vendor_specific_insn;
+	bool page_table_written_insn;
 
 	bool have_exception;
 	struct x86_exception exception;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 0453c07..3c027ac 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2516,6 +2516,7 @@ static int em_add(struct x86_emulate_ctxt *ctxt)
 static int em_or(struct x86_emulate_ctxt *ctxt)
 {
 	emulate_2op_SrcV("or", ctxt->src, ctxt->dst, ctxt->eflags);
+	tag_page_table_written_insn(ctxt);
 	return X86EMUL_CONTINUE;
 }
 
@@ -2534,6 +2535,7 @@ static int em_sbb(struct x86_emulate_ctxt *ctxt)
 static int em_and(struct x86_emulate_ctxt *ctxt)
 {
 	emulate_2op_SrcV("and", ctxt->src, ctxt->dst, ctxt->eflags);
+	tag_page_table_written_insn(ctxt);
 	return X86EMUL_CONTINUE;
 }
 
@@ -2572,6 +2574,7 @@ static int em_xchg(struct x86_emulate_ctxt *ctxt)
 	/* Write back the memory destination with implicit LOCK prefix. */
 	ctxt->dst.val = ctxt->src.orig_val;
 	ctxt->lock_prefix = 1;
+	tag_page_table_written_insn(ctxt);
 	return X86EMUL_CONTINUE;
 }
 
@@ -2610,6 +2613,7 @@ static int em_rdtsc(struct x86_emulate_ctxt *ctxt)
 static int em_mov(struct x86_emulate_ctxt *ctxt)
 {
 	ctxt->dst.val = ctxt->src.val;
+	tag_page_table_written_insn(ctxt);
 	return X86EMUL_CONTINUE;
 }
 
@@ -4135,6 +4139,7 @@ twobyte_insn:
 		break;
 	case 0xab:
 	      bts:		/* bts */
+		tag_page_table_written_insn(ctxt);
 		emulate_2op_SrcV_nobyte("bts", ctxt->src, ctxt->dst, ctxt->eflags);
 		break;
 	case 0xac: /* shrd imm8, r, r/m */
@@ -4148,6 +4153,7 @@ twobyte_insn:
 		 * Save real source value, then compare EAX against
 		 * destination.
 		 */
+		tag_page_table_written_insn(ctxt);
 		ctxt->src.orig_val = ctxt->src.val;
 		ctxt->src.val = ctxt->regs[VCPU_REGS_RAX];
 		emulate_2op_SrcV("cmp", ctxt->src, ctxt->dst, ctxt->eflags);
@@ -4192,6 +4198,7 @@ twobyte_insn:
 		break;
 	case 0xbb:
 	      btc:		/* btc */
+		tag_page_table_written_insn(ctxt);
 		emulate_2op_SrcV_nobyte("btc", ctxt->src, ctxt->dst, ctxt->eflags);
 		break;
 	case 0xbc: {		/* bsf */
@@ -4235,6 +4242,7 @@ twobyte_insn:
 							(u64) ctxt->src.val;
 		break;
 	case 0xc7:		/* Grp9 (cmpxchg8b) */
+		tag_page_table_written_insn(ctxt);
 		rc = em_grp9(ctxt);
 		break;
 	default:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ea8f9f0..cf6fb29 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4831,6 +4831,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		ctxt->interruptibility = 0;
 		ctxt->have_exception = false;
 		ctxt->perm_ok = false;
+		ctxt->page_table_written_insn = false;
 
 		ctxt->only_vendor_specific_insn
 			= emulation_type & EMULTYPE_TRAP_UD;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d36fe23..b6e868f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -111,6 +111,11 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
+static inline void tag_page_table_written_insn(struct x86_emulate_ctxt *ctxt)
+{
+	ctxt->page_table_written_insn = true;
+}
+
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
-- 
1.7.5.4

