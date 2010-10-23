Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab0JWToN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:44:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:42180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab0JWToK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:44:10 -0400
Date: Sat, 23 Oct 2010 19:43:10 GMT
From: tip-bot for Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, jslaby@suse.cz, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, jslaby@suse.cz, mingo@elte.hu
In-Reply-To: <1287586131-16222-1-git-send-email-jslaby@suse.cz>
References: <1287586131-16222-1-git-send-email-jslaby@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, printk: Get rid of <0> from stack output
Message-ID: <tip-e4072a9a9d186fe86293effe8828faa4be75b4a4@git.kernel.org>
Git-Commit-ID: e4072a9a9d186fe86293effe8828faa4be75b4a4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 19:43:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e4072a9a9d186fe86293effe8828faa4be75b4a4
Gitweb:     http://git.kernel.org/tip/e4072a9a9d186fe86293effe8828faa4be75b4a4
Author:     Jiri Slaby <jslaby@suse.cz>
AuthorDate: Wed, 20 Oct 2010 16:48:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 Oct 2010 20:03:03 +0200

x86, printk: Get rid of <0> from stack output

The stack output currently looks like this:

 7fffffffffffffff 0000000a00000000 ffffffff81093341 0000000000000046
<0> ffff88003a545fd8 0000000000000000 0000000000000000 00007fffa39769c0
<0> ffff88003e403f58 ffffffff8102fc4c ffff88003e403f58 ffff88003e403f78

The superfluous <0> are caused by recent printk KERN_CONT
change. <*> is now ignored in printk unless some text follows
the level and even then it still has to be the first in the
format message.

Note that the log_lvl parameter is now completely ignored in
show_stack_log_lvl and the stack is dumped with the default
level (like for quite some time already). It behaves the same as
the rest of the dump, function traces are dumped in the very
same manner. Only Code and maybe some lines are printed with
EMERG level.

Unfortunately I see no way how to fix this conceptually to have
the whole oops/BUG/panic output with the same level, so this
removed only the superfluous characters for the time being.

Just for illustration:

<4>Process kworker/0:0 (pid: 0, threadinfo ffff88003c8a6000, task ffff88003c85c100)
<0>Stack:
<4> ffffffff818022c0 0000000a00000001 0000000000000001 0000000000000046
<4> ffff88003c8a7fd8 0000000000000001 ffff88003c8a7e58 0000000000000000
<4> ffff88003e503f48 ffffffff8102fc4c ffff88003e503f48 ffff88003e503f68
<0>Call Trace:
<0> <IRQ>
<4> [<ffffffff8102fc4c>] ? call_softirq+0x1c/0x30 ...
<0>Code: 00 01 00 00 65 8b 04 25 80 c5 00 00 c7 45 ...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1287586131-16222-1-git-send-email-jslaby@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/dumpstack_32.c |    6 +++---
 arch/x86/kernel/dumpstack_64.c |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 0f6376f..1bc7f75 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -82,11 +82,11 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("\n%s", log_lvl);
-		printk(" %08lx", *stack++);
+			printk(KERN_CONT "\n");
+		printk(KERN_CONT " %08lx", *stack++);
 		touch_nmi_watchdog();
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 57a21f1..6a34048 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -265,20 +265,20 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (stack >= irq_stack && stack <= irq_stack_end) {
 			if (stack == irq_stack_end) {
 				stack = (unsigned long *) (irq_stack_end[-1]);
-				printk(" <EOI> ");
+				printk(KERN_CONT " <EOI> ");
 			}
 		} else {
 		if (((long) stack & (THREAD_SIZE-1)) == 0)
 			break;
 		}
 		if (i && ((i % STACKSLOTS_PER_LINE) == 0))
-			printk("\n%s", log_lvl);
-		printk(" %016lx", *stack++);
+			printk(KERN_CONT "\n");
+		printk(KERN_CONT " %016lx", *stack++);
 		touch_nmi_watchdog();
 	}
 	preempt_enable();
 
-	printk("\n");
+	printk(KERN_CONT "\n");
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
