Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1KRLkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:40:18 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:53318 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1KRLkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:40:13 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 18 Nov 2011 16:42:39 +0530
Message-Id: <20111118111239.10512.46179.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 30/30] x86: skip singlestep where possible
x-cbid: 11111811-3864-0000-0000-00000024B3AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Check and skip singlestepping underlying instructions where possible.

For now handles single byte as well as few multibyte nop instructions.
However can be extended to other instructions too.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/kernel/uprobes.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3f0eb4e..f59053f 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -602,3 +602,47 @@ void abort_xol(struct pt_regs *regs, struct uprobe *uprobe)
 	handle_riprel_post_xol(uprobe, regs, NULL);
 	set_instruction_pointer(regs, utask->vaddr);
 }
+
+/*
+ * Skip these instructions:
+ *
+ * 0f 19 90 90 90 90 90		nopl   -0x6f6f6f70(%rax)
+ * 0f 1f 00			nopl (%rax)
+ * 0f 1f 40 00			nopl 0x0(%rax)
+ * 0f 1f 44 00 00		nopl 0x0(%rax,%rax,1)
+ * 0f 1f 80 00 00 00 00		nopl 0x0(%rax)
+ * 0f 1f 84 00 00 00 00		nopl 0x0(%rax,%rax,1)
+ * 66 0f 1f 44 00 00 00		nopw 0x0(%rax,%rax,1)
+ * 66 0f 1f 84 00 00 00		nopw 0x0(%rax,%rax,1)
+ * 66 87 c0			xchg %eax,%eax
+ * 66 90			nop
+ * 87 c0			xchg %eax,%eax
+ * 90 				nop
+ */
+
+bool can_skip_xol(struct pt_regs *regs, struct uprobe *u)
+{
+	int i;
+
+	for (i = 0; i < MAX_UINSN_BYTES; i++) {
+		if ((u->insn[i] == 0x66))
+			continue;
+
+		if (u->insn[i] == 0x90)
+			return true;
+
+		if ((u->insn[i] == 0x0f) && (u->insn[i+1] == 0x1f))
+			return true;
+
+		if ((u->insn[i] == 0x0f) && (u->insn[i+1] == 0x19))
+			return true;
+
+		if ((u->insn[i] == 0x87) && (u->insn[i+1] == 0xc0))
+			return true;
+
+		break;
+	}
+
+	u->flags &= ~UPROBES_SKIP_SSTEP;
+	return false;
+}

