Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab0EFSCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:02:10 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38258 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab0EFSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:02:00 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 23:31:53 +0530
Message-Id: <20100506180153.28877.34636.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
References: <20100506180139.28877.81699.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v3 1/10] X86 instruction analysis: Move Macro W to insn.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move_W_to_insn.patch

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Move Macro W to asm/insn.h

Macro W used to know if the instructions are valid for
user-space/kernel space.  This macro is used by kprobes and
user_bkpt. (i.e user space breakpoint assistance layer.) So moving it
to a common header file asm/insn.h.

TODO: replace macro W with bits in inat table. (suggested by Masami Hiramatsu)

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/x86/include/asm/insn.h |    7 +++++++
 arch/x86/kernel/kprobes.c   |    7 -------
 2 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 96c2e0a..8586820 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -23,6 +23,13 @@
 /* insn_attr_t is defined in inat.h */
 #include <asm/inat.h>
 
+#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (row % 32))
+
 struct insn_field {
 	union {
 		insn_value_t value;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b43bbae..4379b40 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -66,12 +66,6 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 #define stack_addr(regs) ((unsigned long *)kernel_stack_pointer(regs))
 
-#define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (row % 32))
 	/*
 	 * Undefined/reserved opcodes, conditional jump, Opcode Extension
 	 * Groups, and some special opcodes can not boost.
@@ -98,7 +92,6 @@ static const u32 twobyte_is_boostable[256 / 32] = {
 	/*      -----------------------------------------------         */
 	/*      0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f          */
 };
-#undef W
 
 struct kretprobe_blackpoint kretprobe_blacklist[] = {
 	{"__switch_to", }, /* This function switches only current task, but
