Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2BVJQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:16:34 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:33474 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2BVJQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:16:32 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>
Date: Wed, 22 Feb 2012 14:45:49 +0530
Message-Id: <20120222091549.15880.67020.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com>
References: <20120222091535.15880.12502.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 2/3] uprobes/core: remove uprobe_opcode_sz
x-cbid: 12022123-1618-0000-0000-000000DDC0F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

uprobe_opcode_sz refers to the smallest instruction size for that
architecture. UPROBES_BKPT_INSN_SIZE refers to the size of the breakpoint
instruction for that architecture.

For now we are assuming that both uprobe_opcode_sz and
UPROBES_BKPT_INSN_SIZE are the same for all archs and hence removing
uprobe_opcode_sz in favour of UPROBES_BKPT_INSN_SIZE.

However if we have to support architectures where the smallest instruction
size is different from the size of breakpoint instruction, we may have to
re-introduce uprobe_opcode_sz.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |    2 --
 kernel/uprobes.c        |    6 +++---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 64e45f1..fd45b70 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -37,8 +37,6 @@ struct uprobe_arch_info {};
 #define MAX_UINSN_BYTES 4
 #endif
 
-#define uprobe_opcode_sz sizeof(uprobe_opcode_t)
-
 /* flags that denote/change uprobes behaviour */
 
 /* Have a copy of original instruction */
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 884817f..ee496ad 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -244,8 +244,8 @@ static int write_opcode(struct mm_struct *mm, struct uprobe *uprobe,
 
 	/* poke the new insn in, ASSUMES we don't cross page boundary */
 	vaddr &= ~PAGE_MASK;
-	BUG_ON(vaddr + uprobe_opcode_sz > PAGE_SIZE);
-	memcpy(vaddr_new + vaddr, &opcode, uprobe_opcode_sz);
+	BUG_ON(vaddr + UPROBES_BKPT_INSN_SIZE > PAGE_SIZE);
+	memcpy(vaddr_new + vaddr, &opcode, UPROBES_BKPT_INSN_SIZE);
 
 	kunmap_atomic(vaddr_new);
 	kunmap_atomic(vaddr_old);
@@ -293,7 +293,7 @@ static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_
 	lock_page(page);
 	vaddr_new = kmap_atomic(page);
 	vaddr &= ~PAGE_MASK;
-	memcpy(opcode, vaddr_new + vaddr, uprobe_opcode_sz);
+	memcpy(opcode, vaddr_new + vaddr, UPROBES_BKPT_INSN_SIZE);
 	kunmap_atomic(vaddr_new);
 	unlock_page(page);
 


