Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab2DAQEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:04:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2DAQEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:04:05 -0400
Subject: [RFC PATCH -tip 10/16] x86/disasm: Indicate modified instructions
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:59 +0900
Message-ID: <20120401160359.4502.88900.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Show modified comment instead of disassembled code when
given instruction has been modified by kprobes or kdb.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/kernel/kdebugfs.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 5da917d..eccd718 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -296,13 +296,32 @@ static int disasm_seq_show(struct seq_file *m, void *v)
 	u8 kbuf[MAX_INSN_SIZE];
 	struct insn insn;
 	void *p;
+	int i, ret;
 
+	/* recover if the instruction is probed */
 	p = (void *)recover_probed_instruction(kbuf, (unsigned long)v);
 	kernel_insn_init(&insn, p);
 	insn_get_length(&insn);
 	insn.kaddr = v;
-	snprint_assembly(buf, DISASM_BUF_LEN, &insn, DISASM_PR_ALL);
-	seq_printf(m, "%s", buf);
+
+	seq_printf(m, "%p: ", v);
+	for (i = 0; i < MAX_INSN_SIZE / 2 && i < insn.length; i++)
+		seq_printf(m, "%02x ", ((u8 *)v)[i]);
+	if (i != MAX_INSN_SIZE / 2)
+		seq_printf(m, "%*s", 3 * (MAX_INSN_SIZE / 2 - i), " ");
+
+	/* print assembly code */
+	ret = disassemble(buf, DISASM_BUF_LEN, &insn);
+	if (ret < 0)
+		return ret;
+	seq_printf(m, "%s%s\n", (p != v) ? "(probed)" : "", buf);
+
+	if (i < insn.length) {
+		seq_printf(m, "%p: ", v + i);
+		for (; i < insn.length - 1; i++)
+			seq_printf(m, "%02x ", ((u8 *)v)[i]);
+		seq_printf(m, "%02x\n", ((u8 *)v)[i]);
+	}
 
 	return 0;
 }

