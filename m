Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0LPKBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:01:18 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:52457 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0LPKBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:01:14 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:28:37 +0530
Message-Id: <20101216095837.23751.45271.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 7/20]  7: uprobes: store/restore original instruction.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On the first probe insertion, copy the original instruction and opcode.
If multiple vmas map the same text area corresponding to an inode, we
only need to copy the instruction just once.
The copied instruction is further copied to a designated slot on probe
hit.  Its also used at the time of probe removal to restore the original
instruction.
opcode is used to analyze the instruction and determine the fixups.
Determining fixups at probe hit time would result in doing the same
operation on every probe hit. Hence Instruction analysis using the
opcode is done at probe insertion time.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/Kconfig     |    1 +
 kernel/uprobes.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 6e8f26e..bba8108 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -65,6 +65,7 @@ config UPROBES
 	bool "User-space probes (EXPERIMENTAL)"
 	depends on ARCH_SUPPORTS_UPROBES
 	depends on MMU
+	select MM_OWNER
 	help
 	  Uprobes enables kernel subsystems to establish probepoints
 	  in user applications and execute handler functions when
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 8a5da38..858ddb1 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -448,21 +448,72 @@ static int del_consumer(struct uprobe *uprobe,
 	return ret;
 }
 
+static int copy_insn(struct task_struct *tsk, unsigned long vaddr,
+						struct uprobe *uprobe)
+{
+	int len;
+
+	len = uprobes_read_vm(tsk, (void __user *)vaddr, uprobe->insn,
+						MAX_UINSN_BYTES);
+	if (len < uprobe_opcode_sz) {
+		print_insert_fail(tsk, vaddr,
+				"error reading original instruction");
+		return -EINVAL;
+	}
+	memcpy(&uprobe->opcode, uprobe->insn, uprobe_opcode_sz);
+	if (is_bkpt_insn(uprobe)) {
+		print_insert_fail(tsk, vaddr,
+				"breakpoint instruction already exists");
+		return -EEXIST;
+	}
+	if (analyze_insn(tsk, uprobe)) {
+		print_insert_fail(tsk, vaddr,
+					"instruction type cannot be probed");
+		return -EINVAL;
+	}
+	uprobe->copy = 1;
+	return 0;
+}
+
 static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
 {
-	int ret = 0;
+	struct task_struct *tsk;
+	int ret = -EINVAL;
 
-	/*TODO: install breakpoint */
-	if (!ret)
+	get_task_struct(mm->owner);
+	tsk = mm->owner;
+	if (!tsk)
+		return ret;
+
+	if (!uprobe->copy) {
+		ret = copy_insn(tsk, mm->uprobes_vaddr, uprobe);
+		if (ret)
+			goto put_return;
+	}
+
+	ret = set_bkpt(tsk, mm->uprobes_vaddr);
+	if (ret < 0)
+		print_insert_fail(tsk, mm->uprobes_vaddr,
+					"failed to insert bkpt instruction");
+	else
 		atomic_inc(&mm->uprobes_count);
+
+put_return:
+	put_task_struct(tsk);
 	return ret;
 }
 
 static int remove_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
 {
-	int ret = 0;
+	struct task_struct *tsk;
+	int ret;
+
+	get_task_struct(mm->owner);
+	tsk = mm->owner;
+	if (!tsk)
+		return -EINVAL;
 
-	/*TODO: remove breakpoint */
+	ret = set_orig_insn(tsk, mm->uprobes_vaddr, true, uprobe);
 	if (!ret)
 		atomic_dec(&mm->uprobes_count);
 
