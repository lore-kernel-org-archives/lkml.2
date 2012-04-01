Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab2DAQE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:04:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32815 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2DAQEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:04:24 -0400
Subject: [RFC PATCH -tip 12/16] x86: Merge code dump in show_registers
To: linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 02 Apr 2012 01:04:20 +0900
Message-ID: <20120401160420.4502.62302.stgit@shimauta>
In-Reply-To: <20120401160229.4502.2541.stgit@shimauta>
References: <20120401160229.4502.2541.stgit@shimauta>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the code dump part of show_registers() in
dumpstack_32/64.c is a dead copy. This should be
merged.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
---
 arch/x86/include/asm/kdebug.h  |    1 +
 arch/x86/kernel/dumpstack.c    |   31 +++++++++++++++++++++++++++++++
 arch/x86/kernel/dumpstack_32.c |   26 +-------------------------
 arch/x86/kernel/dumpstack_64.c |   25 +------------------------
 4 files changed, 34 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index d73f157..d0a0391 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -24,6 +24,7 @@ enum die_val {
 extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
+extern void show_code_dump(struct pt_regs *regs);
 extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1b81839..0d35e70 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -292,6 +292,37 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	return 0;
 }
 
+void __kprobes show_code_dump(struct pt_regs *regs)
+{
+	int i;
+	unsigned int code_prologue = code_bytes * 43 / 64;
+	unsigned int code_len = code_bytes;
+	unsigned char c;
+	u8 *ip;
+
+	ip = (u8 *)regs->ip - code_prologue;
+	if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
+		/* try starting at IP */
+		ip = (u8 *)regs->ip;
+		code_len = code_len - code_prologue + 1;
+	}
+	for (i = 0; i < code_len; i++, ip++) {
+		if (ip < (u8 *)PAGE_OFFSET ||
+				probe_kernel_address(ip, c)) {
+#ifdef CONFIG_X86_32
+			printk(KERN_CONT " Bad EIP value.");
+#else
+			printk(KERN_CONT " Bad RIP value.");
+#endif
+			break;
+		}
+		if (ip == (u8 *)regs->ip)
+			printk(KERN_CONT "<%02x> ", c);
+		else
+			printk(KERN_CONT "%02x ", c);
+	}
+}
+
 /*
  * This is gone through when something in the kernel has done something bad
  * and is about to be terminated:
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 88ec912..5c5b03f 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -84,8 +84,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 
 void show_registers(struct pt_regs *regs)
 {
-	int i;
-
 	print_modules();
 	__show_regs(regs, !user_mode_vm(regs));
 
@@ -97,33 +95,11 @@ void show_registers(struct pt_regs *regs)
 	 * time of the fault..
 	 */
 	if (!user_mode_vm(regs)) {
-		unsigned int code_prologue = code_bytes * 43 / 64;
-		unsigned int code_len = code_bytes;
-		unsigned char c;
-		u8 *ip;
-
 		printk(KERN_EMERG "Stack:\n");
 		show_stack_log_lvl(NULL, regs, &regs->sp, 0, KERN_EMERG);
 
 		printk(KERN_EMERG "Code: ");
-
-		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at IP */
-			ip = (u8 *)regs->ip;
-			code_len = code_len - code_prologue + 1;
-		}
-		for (i = 0; i < code_len; i++, ip++) {
-			if (ip < (u8 *)PAGE_OFFSET ||
-					probe_kernel_address(ip, c)) {
-				printk(KERN_CONT " Bad EIP value.");
-				break;
-			}
-			if (ip == (u8 *)regs->ip)
-				printk(KERN_CONT "<%02x> ", c);
-			else
-				printk(KERN_CONT "%02x ", c);
-		}
+		show_code_dump(regs);
 	}
 	printk(KERN_CONT "\n");
 }
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 17107bd..719c6bb 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -247,7 +247,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 
 void show_registers(struct pt_regs *regs)
 {
-	int i;
 	unsigned long sp;
 	const int cpu = smp_processor_id();
 	struct task_struct *cur = current;
@@ -264,34 +263,12 @@ void show_registers(struct pt_regs *regs)
 	 * time of the fault..
 	 */
 	if (!user_mode(regs)) {
-		unsigned int code_prologue = code_bytes * 43 / 64;
-		unsigned int code_len = code_bytes;
-		unsigned char c;
-		u8 *ip;
-
 		printk(KERN_DEFAULT "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
 				   0, KERN_DEFAULT);
 
 		printk(KERN_DEFAULT "Code: ");
-
-		ip = (u8 *)regs->ip - code_prologue;
-		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
-			/* try starting at IP */
-			ip = (u8 *)regs->ip;
-			code_len = code_len - code_prologue + 1;
-		}
-		for (i = 0; i < code_len; i++, ip++) {
-			if (ip < (u8 *)PAGE_OFFSET ||
-					probe_kernel_address(ip, c)) {
-				printk(KERN_CONT " Bad RIP value.");
-				break;
-			}
-			if (ip == (u8 *)regs->ip)
-				printk(KERN_CONT "<%02x> ", c);
-			else
-				printk(KERN_CONT "%02x ", c);
-		}
+		show_code_dump(regs);
 	}
 	printk(KERN_CONT "\n");
 }

