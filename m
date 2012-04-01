Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab2DAQDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:03:48 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DAQDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:03:45 -0400
Subject: [RFC PATCH -tip 08/16] x86/kprobes: Recover breakpoint instruction if
 KGDB knows
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:03:41 +0900
Message-ID: <20120401160341.4502.28323.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recover a breakpoint instruction which KGDB has put.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/kernel/kprobes.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e213fc8..ddd21b8 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -49,6 +49,7 @@
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
 #include <linux/ftrace.h>
+#include <linux/kgdb.h>
 
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
@@ -252,6 +253,14 @@ unsigned long recover_probed_instruction(kprobe_opcode_t *buf, unsigned long add
 {
 	unsigned long __addr;
 
+#ifdef CONFIG_KGDB
+	/* Recover if kgdb has put a breakpoint */
+	if (kgdb_get_saved_instr(addr, buf)) {
+		memcpy(buf + BREAK_INSTR_SIZE, (void *)addr + BREAK_INSTR_SIZE,
+			(MAX_INSN_SIZE - BREAK_INSTR_SIZE) * sizeof(kprobe_opcode_t));
+		return (unsigned long)buf;
+	}
+#endif
 	__addr = __recover_optprobed_insn(buf, addr);
 	if (__addr != addr)
 		return __addr;

