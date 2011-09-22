Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab1IVIvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:51:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab1IVIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:51:35 -0400
Message-ID: <4E7AF79A.4060508@cn.fujitsu.com>
Date: Thu, 22 Sep 2011 16:53:46 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 02/11] KVM: x86: tag the instructions which are used to
 write page table
References: <4E7AF758.7060900@cn.fujitsu.com>
In-Reply-To: <4E7AF758.7060900@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:50:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-22 16:50:13,
	Serialize complete at 2011-09-22 16:50:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea is from Avi:
| tag instructions that are typically used to modify the page tables, and
| drop shadow if any other instruction is used.
| The list would include, I'd guess, and, or, bts, btc, mov, xchg, cmpxchg,
| and cmpxchg8b.

This patch is used to tag the instructions and in the later path, shadow page
is dropped if it is written by other instructions

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/emulate.c |   37 +++++++++++++++++++++----------------
 1 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f1e3be1..a10950a 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -125,8 +125,9 @@
 #define Lock        (1<<26) /* lock prefix is allowed for the instruction */
 #define Priv        (1<<27) /* instruction generates #GP if current CPL != 0 */
 #define No64	    (1<<28)
+#define PageTable   (1 << 29)   /* instruction used to write page table */
 /* Source 2 operand type */
-#define Src2Shift   (29)
+#define Src2Shift   (30)
 #define Src2None    (OpNone << Src2Shift)
 #define Src2CL      (OpCL << Src2Shift)
 #define Src2ImmByte (OpImmByte << Src2Shift)
@@ -3033,10 +3034,10 @@ static struct opcode group7_rm7[] = {
 
 static struct opcode group1[] = {
 	I(Lock, em_add),
-	I(Lock, em_or),
+	I(Lock | PageTable, em_or),
 	I(Lock, em_adc),
 	I(Lock, em_sbb),
-	I(Lock, em_and),
+	I(Lock | PageTable, em_and),
 	I(Lock, em_sub),
 	I(Lock, em_xor),
 	I(0, em_cmp),
@@ -3096,18 +3097,21 @@ static struct group_dual group7 = { {
 
 static struct opcode group8[] = {
 	N, N, N, N,
-	D(DstMem | SrcImmByte | ModRM), D(DstMem | SrcImmByte | ModRM | Lock),
-	D(DstMem | SrcImmByte | ModRM | Lock), D(DstMem | SrcImmByte | ModRM | Lock),
+	D(DstMem | SrcImmByte | ModRM),
+	D(DstMem | SrcImmByte | ModRM | Lock | PageTable),
+	D(DstMem | SrcImmByte | ModRM | Lock),
+	D(DstMem | SrcImmByte | ModRM | Lock | PageTable),
 };
 
 static struct group_dual group9 = { {
-	N, D(DstMem64 | ModRM | Lock), N, N, N, N, N, N,
+	N, D(DstMem64 | ModRM | Lock | PageTable), N, N, N, N, N, N,
 }, {
 	N, N, N, N, N, N, N, N,
 } };
 
 static struct opcode group11[] = {
-	I(DstMem | SrcImm | ModRM | Mov, em_mov), X7(D(Undefined)),
+	I(DstMem | SrcImm | ModRM | Mov | PageTable, em_mov),
+	X7(D(Undefined)),
 };
 
 static struct gprefix pfx_0f_6f_0f_7f = {
@@ -3120,7 +3124,7 @@ static struct opcode opcode_table[256] = {
 	I(ImplicitOps | Stack | No64 | Src2ES, em_push_sreg),
 	I(ImplicitOps | Stack | No64 | Src2ES, em_pop_sreg),
 	/* 0x08 - 0x0F */
-	I6ALU(Lock, em_or),
+	I6ALU(Lock | PageTable, em_or),
 	I(ImplicitOps | Stack | No64 | Src2CS, em_push_sreg),
 	N,
 	/* 0x10 - 0x17 */
@@ -3132,7 +3136,7 @@ static struct opcode opcode_table[256] = {
 	I(ImplicitOps | Stack | No64 | Src2DS, em_push_sreg),
 	I(ImplicitOps | Stack | No64 | Src2DS, em_pop_sreg),
 	/* 0x20 - 0x27 */
-	I6ALU(Lock, em_and), N, N,
+	I6ALU(Lock | PageTable, em_and), N, N,
 	/* 0x28 - 0x2F */
 	I6ALU(Lock, em_sub), N, I(ByteOp | DstAcc | No64, em_das),
 	/* 0x30 - 0x37 */
@@ -3165,11 +3169,11 @@ static struct opcode opcode_table[256] = {
 	G(ByteOp | DstMem | SrcImm | ModRM | No64 | Group, group1),
 	G(DstMem | SrcImmByte | ModRM | Group, group1),
 	I2bv(DstMem | SrcReg | ModRM, em_test),
-	I2bv(DstMem | SrcReg | ModRM | Lock, em_xchg),
+	I2bv(DstMem | SrcReg | ModRM | Lock | PageTable, em_xchg),
 	/* 0x88 - 0x8F */
-	I2bv(DstMem | SrcReg | ModRM | Mov, em_mov),
+	I2bv(DstMem | SrcReg | ModRM | Mov | PageTable, em_mov),
 	I2bv(DstReg | SrcMem | ModRM | Mov, em_mov),
-	I(DstMem | SrcNone | ModRM | Mov, em_mov_rm_sreg),
+	I(DstMem | SrcNone | ModRM | Mov | PageTable, em_mov_rm_sreg),
 	D(ModRM | SrcMem | NoAccess | DstReg),
 	I(ImplicitOps | SrcMem16 | ModRM, em_mov_sreg_rm),
 	G(0, group1A),
@@ -3182,7 +3186,7 @@ static struct opcode opcode_table[256] = {
 	II(ImplicitOps | Stack, em_popf, popf), N, N,
 	/* 0xA0 - 0xA7 */
 	I2bv(DstAcc | SrcMem | Mov | MemAbs, em_mov),
-	I2bv(DstMem | SrcAcc | Mov | MemAbs, em_mov),
+	I2bv(DstMem | SrcAcc | Mov | MemAbs | PageTable, em_mov),
 	I2bv(SrcSI | DstDI | Mov | String, em_mov),
 	I2bv(SrcSI | DstDI | String, em_cmp),
 	/* 0xA8 - 0xAF */
@@ -3280,12 +3284,13 @@ static struct opcode twobyte_table[256] = {
 	D(DstMem | SrcReg | Src2CL | ModRM), N, N,
 	/* 0xA8 - 0xAF */
 	I(Stack | Src2GS, em_push_sreg), I(Stack | Src2GS, em_pop_sreg),
-	DI(ImplicitOps, rsm), D(DstMem | SrcReg | ModRM | BitOp | Lock),
+	DI(ImplicitOps, rsm),
+	D(DstMem | SrcReg | ModRM | BitOp | Lock | PageTable),
 	D(DstMem | SrcReg | Src2ImmByte | ModRM),
 	D(DstMem | SrcReg | Src2CL | ModRM),
 	D(ModRM), I(DstReg | SrcMem | ModRM, em_imul),
 	/* 0xB0 - 0xB7 */
-	D2bv(DstMem | SrcReg | ModRM | Lock),
+	D2bv(DstMem | SrcReg | ModRM | Lock | PageTable),
 	I(DstReg | SrcMemFAddr | ModRM | Src2SS, em_lseg),
 	D(DstMem | SrcReg | ModRM | BitOp | Lock),
 	I(DstReg | SrcMemFAddr | ModRM | Src2FS, em_lseg),
@@ -3293,7 +3298,7 @@ static struct opcode twobyte_table[256] = {
 	D(ByteOp | DstReg | SrcMem | ModRM | Mov), D(DstReg | SrcMem16 | ModRM | Mov),
 	/* 0xB8 - 0xBF */
 	N, N,
-	G(BitOp, group8), D(DstMem | SrcReg | ModRM | BitOp | Lock),
+	G(BitOp, group8), D(DstMem | SrcReg | ModRM | BitOp | Lock | PageTable),
 	D(DstReg | SrcMem | ModRM), D(DstReg | SrcMem | ModRM),
 	D(ByteOp | DstReg | SrcMem | ModRM | Mov), D(DstReg | SrcMem16 | ModRM | Mov),
 	/* 0xC0 - 0xCF */
-- 
1.7.5.4

