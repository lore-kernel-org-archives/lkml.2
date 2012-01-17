Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2AQUQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:16:10 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64140 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2AQUQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:16:09 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, Simon Glass <sjg@chromium.org>
Subject: [PATCH] ARM: Adjust backtrace messages to line up with x86 kernel
Date: Tue, 17 Jan 2012 12:16:01 -0800
Message-Id: <1326831362-28703-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is nice to print the backtrace message on its own line, and also
regardless of the setting of CONFIG_ARM_UNWIND. This means that tools
which parse the backtrace don't need a special case for the first line.
It also makes it more like the x86 kernel output.

I believe we should also put KERN_EMERG at the start of this. Otherwise
it won't appear in console output (although it will appear in the logs
after a reboot).

The impact of this change is that the log output changes from something
like:

[    2.861692] 7fe0: 01beb1b8 befcb7d4 0000aebb 40284334 80000010 01be4668 00000000 00000000
[    2.869866] Backtrace: [<c00bb3f4>] (module_put+0x44/0xc0) from [<c00bdd98>] (sys_init_module+0x186c/0x19c4)
[    2.881144] [<c00bdd98>] (sys_init_module+0x186c/0x19c4) from [<c0052e00>] (ret_fast_syscall+0x0/0x30)

to:

[    2.861692] 7fe0: 01beb1b8 befcb7d4 0000aebb 40284334 80000010 01be4668 00000000 00000000
[    2.869866] Backtrace:
[    2.872248] [<c00bb3f4>] (module_put+0x44/0xc0) from [<c00bdd98>] (sys_init_module+0x186c/0x19c4)
[    2.881144] [<c00bdd98>] (sys_init_module+0x186c/0x19c4) from [<c0052e00>] (ret_fast_syscall+0x0/0x30)

(although previously the Backtrace: line didn't appear with CONFIG_ARM_UNWIND
defined)

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 arch/arm/kernel/traps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 99a5727..78a5bbc 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -165,6 +165,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
 #ifdef CONFIG_ARM_UNWIND
 static inline void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 {
+	printk(KERN_EMERG "Backtrace:\n");
 	unwind_backtrace(regs, tsk);
 }
 #else
@@ -173,7 +174,7 @@ static void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
 	unsigned int fp, mode;
 	int ok = 1;
 
-	printk("Backtrace: ");
+	printkK(ERN_EMERG "Backtrace:\n");
 
 	if (!tsk)
 		tsk = current;
-- 
1.7.7.3

