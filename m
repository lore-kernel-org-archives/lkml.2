Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2HXH0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:26:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46508 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab2HXH0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:26:12 -0400
Date: Fri, 24 Aug 2012 12:56:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc: benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, peterz@infradead.org,
        michael@ellerman.id.au, Ingo Molnar <mingo@elte.hu>, oleg@redhat.com
Subject: [PATCH 1/3] powerpc: Consolidate *probe definitions
Message-ID: <20120824072602.GA32031@in.ibm.com>
Reply-To: ananth@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082407-8974-0000-0000-00000C861D83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Move is_trap() and relatives to a common file to be shared between *probes.
Code movement only; no change in functionality.

Suggested by Michael Ellerman.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 arch/powerpc/include/asm/kprobes.h |   15 +------------
 arch/powerpc/include/asm/probes.h  |   42 +++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 13 deletions(-)

Index: linux-tip-23aug/arch/powerpc/include/asm/kprobes.h
===================================================================
--- linux-tip-23aug.orig/arch/powerpc/include/asm/kprobes.h
+++ linux-tip-23aug/arch/powerpc/include/asm/kprobes.h
@@ -29,21 +29,16 @@
 #include <linux/types.h>
 #include <linux/ptrace.h>
 #include <linux/percpu.h>
+#include <asm/probes.h>
 
 #define  __ARCH_WANT_KPROBES_INSN_SLOT
 
 struct pt_regs;
 struct kprobe;
 
-typedef unsigned int kprobe_opcode_t;
-#define BREAKPOINT_INSTRUCTION	0x7fe00008	/* trap */
+typedef opcode_t kprobe_opcode_t;
 #define MAX_INSN_SIZE 1
 
-#define IS_TW(instr)		(((instr) & 0xfc0007fe) == 0x7c000008)
-#define IS_TD(instr)		(((instr) & 0xfc0007fe) == 0x7c000088)
-#define IS_TDI(instr)		(((instr) & 0xfc000000) == 0x08000000)
-#define IS_TWI(instr)		(((instr) & 0xfc000000) == 0x0c000000)
-
 #ifdef CONFIG_PPC64
 /*
  * 64bit powerpc uses function descriptors.
@@ -72,12 +67,6 @@ typedef unsigned int kprobe_opcode_t;
 		addr = (kprobe_opcode_t *)kallsyms_lookup_name(dot_name); \
 	}								\
 }
-
-#define is_trap(instr)	(IS_TW(instr) || IS_TD(instr) || \
-			IS_TWI(instr) || IS_TDI(instr))
-#else
-/* Use stock kprobe_lookup_name since ppc32 doesn't use function descriptors */
-#define is_trap(instr)	(IS_TW(instr) || IS_TWI(instr))
 #endif
 
 #define flush_insn_slot(p)	do { } while (0)
Index: linux-tip-23aug/arch/powerpc/include/asm/probes.h
===================================================================
--- /dev/null
+++ linux-tip-23aug/arch/powerpc/include/asm/probes.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_POWERPC_PROBES_H
+#define _ASM_POWERPC_PROBES_H
+#ifdef __KERNEL__
+/*
+ * Definitions common to probes files
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2012
+ */
+#include <linux/types.h>
+
+typedef u32 opcode_t;
+#define BREAKPOINT_INSTRUCTION	0x7fe00008	/* trap */
+
+/* Trap definitions per ISA */
+#define IS_TW(instr)		(((instr) & 0xfc0007fe) == 0x7c000008)
+#define IS_TD(instr)		(((instr) & 0xfc0007fe) == 0x7c000088)
+#define IS_TDI(instr)		(((instr) & 0xfc000000) == 0x08000000)
+#define IS_TWI(instr)		(((instr) & 0xfc000000) == 0x0c000000)
+
+#ifdef CONFIG_PPC64
+#define is_trap(instr)		(IS_TW(instr) || IS_TD(instr) || \
+				IS_TWI(instr) || IS_TDI(instr))
+#else
+#define is_trap(instr)		(IS_TW(instr) || IS_TWI(instr))
+#endif /* CONFIG_PPC64 */
+
+#endif /* __KERNEL__ */
+#endif	/* _ASM_POWERPC_PROBES_H */

