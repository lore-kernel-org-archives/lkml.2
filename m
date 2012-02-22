Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab2BVQHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:07:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2BVQHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:07:41 -0500
Date: Wed, 22 Feb 2012 08:05:44 -0800
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-96379f60075c75b261328aa7830ef8aa158247ac@git.kernel.org>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, peterz@infradead.org,
        jolsa@redhat.com, anton@redhat.com, jkenisto@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        ananth@in.ibm.com, jistone@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, peterz@infradead.org, hch@infradead.org,
        jolsa@redhat.com, jistone@redhat.com, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        jkenisto@linux.vnet.ibm.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
In-Reply-To: <20120222091549.15880.67020.sendpatchset@srdronam.in.ibm.com>
References: <20120222091549.15880.67020.sendpatchset@srdronam.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/uprobes] uprobes/core: Remove uprobe_opcode_sz
Git-Commit-ID: 96379f60075c75b261328aa7830ef8aa158247ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:06:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96379f60075c75b261328aa7830ef8aa158247ac
Gitweb:     http://git.kernel.org/tip/96379f60075c75b261328aa7830ef8aa158247ac
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Wed, 22 Feb 2012 14:45:49 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Feb 2012 11:26:08 +0100

uprobes/core: Remove uprobe_opcode_sz

uprobe_opcode_sz refers to the smallest instruction size for
that architecture. UPROBES_BKPT_INSN_SIZE refers to the size of
the breakpoint instruction for that architecture.

For now we are assuming that both uprobe_opcode_sz and
UPROBES_BKPT_INSN_SIZE are the same for all archs and hence
removing uprobe_opcode_sz in favour of UPROBES_BKPT_INSN_SIZE.

However if we have to support architectures where the smallest
instruction size is different from the size of breakpoint
instruction, we may have to re-introduce uprobe_opcode_sz.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Josh Stone <jistone@redhat.com>
Link: http://lkml.kernel.org/r/20120222091549.15880.67020.sendpatchset@srdronam.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/uprobes.h |    2 --
 kernel/events/uprobes.c |    6 +++---
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
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 884817f..ee496ad 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
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
 
