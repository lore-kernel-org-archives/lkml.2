Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab2C2Wtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:49:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56166 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760257Ab2C2WtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:49:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 6/6] x86,kgdb: Fix DEBUG_RODATA limitation using text_poke()
Date: Thu, 29 Mar 2012 17:49:02 -0500
Message-ID: <1333061342-10132-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
References: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has long been a limitation using software breakpoints with a
kernel compiled with CONFIG_DEBUG_RODATA going back to 2.6.26. For
this particular patch, it will apply cleanly and has been tested all
the way back to 2.6.36.

The kprobes code uses the text_poke() function which accommodates
writing a breakpoint into a read-only page.  The x86 kgdb code can
solve the problem similarly by overriding the default breakpoint
set/remove routines and using text_poke() directly.

The x86 kgdb code will first attempt to use the traditional
probe_kernel_write(), and next try using a the text_poke() function.
The break point install method is tracked such that the correct break
point removal routine will get called later on.

Cc: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: stable@vger.kernel.org # >= 2.6.36
Inspried-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/kgdb.h   |    3 ++-
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index fdc37b3..b9bd9d8 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -43,6 +43,8 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/uaccess.h>
+#include <linux/memory.h>
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
@@ -742,6 +744,64 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 	regs->ip = ip;
 }
 
+int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
+{
+	int err;
+	char opc[BREAK_INSTR_SIZE];
+
+	bpt->type = BP_BREAKPOINT;
+	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+				BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+	err = probe_kernel_write((char *)bpt->bpt_addr,
+				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
+#ifdef CONFIG_DEBUG_RODATA
+	if (!err)
+		return err;
+	/*
+	 * It is safe to call text_poke() because normal kernel execution
+	 * is stopped on all cores, so long as the text_mutex is not locked.
+	 */
+	if (mutex_is_locked(&text_mutex))
+		return -EBUSY;
+	text_poke((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
+		  BREAK_INSTR_SIZE);
+	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+	if (memcmp(opc, arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE))
+		return -EINVAL;
+	bpt->type = BP_POKE_BREAKPOINT;
+#endif /* CONFIG_DEBUG_RODATA */
+	return err;
+}
+
+int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
+{
+#ifdef CONFIG_DEBUG_RODATA
+	int err;
+	char opc[BREAK_INSTR_SIZE];
+
+	if (bpt->type != BP_POKE_BREAKPOINT)
+		goto knl_write;
+	/*
+	 * It is safe to call text_poke() because normal kernel execution
+	 * is stopped on all cores, so long as the text_mutex is not locked.
+	 */
+	if (mutex_is_locked(&text_mutex))
+		goto knl_write;
+	text_poke((void *)bpt->bpt_addr, bpt->saved_instr, BREAK_INSTR_SIZE);
+	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
+	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
+		goto knl_write;
+	return err;
+knl_write:
+#endif /* CONFIG_DEBUG_RODATA */
+	return probe_kernel_write((char *)bpt->bpt_addr,
+				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: */
 	.gdb_bpt_instr		= { 0xcc },
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index e5d689c..c4d2fc1 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -63,7 +63,8 @@ enum kgdb_bptype {
 	BP_HARDWARE_BREAKPOINT,
 	BP_WRITE_WATCHPOINT,
 	BP_READ_WATCHPOINT,
-	BP_ACCESS_WATCHPOINT
+	BP_ACCESS_WATCHPOINT,
+	BP_POKE_BREAKPOINT,
 };
 
 enum kgdb_bpstate {
-- 
1.7.9.4

