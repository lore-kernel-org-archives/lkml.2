Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2EWHpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:45:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43129 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2EWHpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:45:31 -0400
Date: Wed, 23 May 2012 09:45:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpu change for v3.5
Message-ID: <20120523074524.GA12058@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-debug-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-debug-for-linus

   HEAD: 57da8b960b9a25646a8ddb5a9c1d0b5978e69bec x86: Avoid double stack traces with show_regs()

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86: Avoid double stack traces with show_regs()


 arch/x86/include/asm/kdebug.h  | 1 -
 arch/x86/kernel/dumpstack.c    | 2 +-
 arch/x86/kernel/dumpstack_32.c | 2 +-
 arch/x86/kernel/dumpstack_64.c | 2 +-
 arch/x86/kernel/kprobes.c      | 4 ++--
 arch/x86/kernel/nmi.c          | 2 +-
 arch/x86/kernel/process.c      | 6 ------
 7 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index d73f157..2c37aad 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -24,7 +24,6 @@ enum die_val {
 extern void printk_address(unsigned long address, int reliable);
 extern void die(const char *, struct pt_regs *,long);
 extern int __must_check __die(const char *, struct pt_regs *, long);
-extern void show_registers(struct pt_regs *regs);
 extern void show_trace(struct task_struct *t, struct pt_regs *regs,
 		       unsigned long *sp, unsigned long bp);
 extern void __show_regs(struct pt_regs *regs, int all);
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1b81839..40989da 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -271,7 +271,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
 
-	show_registers(regs);
+	show_regs(regs);
 #ifdef CONFIG_X86_32
 	if (user_mode_vm(regs)) {
 		sp = regs->sp;
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 88ec912..e0b1d78 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -82,7 +82,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 }
 
 
-void show_registers(struct pt_regs *regs)
+void show_regs(struct pt_regs *regs)
 {
 	int i;
 
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 17107bd..791b761 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -245,7 +245,7 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
-void show_registers(struct pt_regs *regs)
+void show_regs(struct pt_regs *regs)
 {
 	int i;
 	unsigned long sp;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e213fc8..e2f751e 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1037,9 +1037,9 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 			       "current sp %p does not match saved sp %p\n",
 			       stack_addr(regs), kcb->jprobe_saved_sp);
 			printk(KERN_ERR "Saved registers for jprobe %p\n", jp);
-			show_registers(saved_regs);
+			show_regs(saved_regs);
 			printk(KERN_ERR "Current registers\n");
-			show_registers(regs);
+			show_regs(regs);
 			BUG();
 		}
 		*regs = kcb->jprobe_saved_regs;
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..03c1345 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -244,7 +244,7 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	pr_emerg(
 	"NMI: IOCK error (debug interrupt?) for reason %02x on CPU %d.\n",
 		 reason, smp_processor_id());
-	show_registers(regs);
+	show_regs(regs);
 
 	if (panic_on_io_nmi)
 		panic("NMI IOCK error: Not continuing");
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d92a5a..856d5bc 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -105,12 +105,6 @@ void exit_thread(void)
 	}
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	show_registers(regs);
-	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs), 0);
-}
-
 void show_regs_common(void)
 {
 	const char *vendor, *product, *board;
