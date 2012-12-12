Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2LLSUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:20:23 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55564 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752257Ab2LLSUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:20:21 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 05/26] avr32: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:18:54 -0800
Message-Id: <d5dada5852c5ec4ea88bb9d3c0df1361b0196890.1355335227.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Remove a couple of #ifdef CONFIG_KALLSYMS branches
that are now the same code.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/avr32/kernel/process.c |   25 +++++++------------------
 1 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index fd78f58..7a56e86 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -148,12 +148,7 @@ static void show_trace_log_lvl(struct task_struct *tsk, unsigned long *sp,
 		unsigned long new_fp;
 
 		lr = *(unsigned long *)fp;
-#ifdef CONFIG_KALLSYMS
-		printk("%s [<%08lx>] ", log_lvl, lr);
-#else
-		printk(" [<%08lx>] ", lr);
-#endif
-		print_symbol("%s\n", lr);
+		printk("%s [<%08lx>] %pSR\n", log_lvl, lr, (void *)lr);
 
 		new_fp = *(unsigned long *)(fp + 4);
 		if (new_fp <= fp)
@@ -172,14 +167,9 @@ static void show_trace_log_lvl(struct task_struct *tsk, unsigned long *sp,
 
 	while (!kstack_end(sp)) {
 		addr = *sp++;
-		if (kernel_text_address(addr)) {
-#ifdef CONFIG_KALLSYMS
-			printk("%s [<%08lx>] ", log_lvl, addr);
-#else
-			printk(" [<%08lx>] ", addr);
-#endif
-			print_symbol("%s\n", addr);
-		}
+		if (kernel_text_address(addr))
+			printk("%s [<%08lx>] %pSR\n",
+			       log_lvl, addr, (void *)addr);
 	}
 	printk("\n");
 }
@@ -235,10 +225,9 @@ void show_regs_log_lvl(struct pt_regs *regs, const char *log_lvl)
 	if (!user_mode(regs)) {
 		sp = (unsigned long)regs + FRAME_SIZE_FULL;
 
-		printk("%s", log_lvl);
-		print_symbol("PC is at %s\n", instruction_pointer(regs));
-		printk("%s", log_lvl);
-		print_symbol("LR is at %s\n", lr);
+		printk("%sPC is at %pSR\n",
+		       log_lvl, (void *)instruction_pointer(regs));
+		printk("%sLR is at %pSR\n", log_lvl, (void *)lr);
 	}
 
 	printk("%spc : [<%08lx>]    lr : [<%08lx>]    %s\n"
-- 
1.7.8.112.g3fd21

