Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2BBJqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:46:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab2BBJqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:46:08 -0500
Date: Thu, 2 Feb 2012 10:45:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core kernel fix
Message-ID: <20120202094554.GA3378@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: b0f4c4b32c8e3aa0d44fc4dd6c40a9a9a8d66b63 bugs, x86: Fix printk levels for panic, softlockups and stack dumps

 Thanks,

	Ingo

------------------>
Prarit Bhargava (1):
      bugs, x86: Fix printk levels for panic, softlockups and stack dumps


 arch/x86/kernel/dumpstack.c    |    3 ++-
 arch/x86/kernel/dumpstack_64.c |    6 +++---
 arch/x86/mm/fault.c            |    4 ++--
 kernel/watchdog.c              |    2 +-
 lib/bug.c                      |    2 +-
 5 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1aae78f..4025fe4 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -252,7 +252,8 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	unsigned short ss;
 	unsigned long sp;
 #endif
-	printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
+	printk(KERN_DEFAULT
+	       "%s: %04lx [#%d] ", str, err & 0xffff, ++die_counter);
 #ifdef CONFIG_PREEMPT
 	printk("PREEMPT ");
 #endif
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6d728d9..42b2bca 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -269,11 +269,11 @@ void show_registers(struct pt_regs *regs)
 		unsigned char c;
 		u8 *ip;
 
-		printk(KERN_EMERG "Stack:\n");
+		printk(KERN_DEFAULT "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
-				   0, KERN_EMERG);
+				   0, KERN_DEFAULT);
 
-		printk(KERN_EMERG "Code: ");
+		printk(KERN_DEFAULT "Code: ");
 
 		ip = (u8 *)regs->ip - code_prologue;
 		if (ip < (u8 *)PAGE_OFFSET || probe_kernel_address(ip, c)) {
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9d74824..f0b4caf 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -673,7 +673,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 
 	stackend = end_of_stack(tsk);
 	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
-		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
+		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
 
 	tsk->thread.cr2		= address;
 	tsk->thread.trap_no	= 14;
@@ -684,7 +684,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		sig = 0;
 
 	/* Executive summary in case the body of the oops scrolled away */
-	printk(KERN_EMERG "CR2: %016lx\n", address);
+	printk(KERN_DEFAULT "CR2: %016lx\n", address);
 
 	oops_end(flags, regs, sig);
 }
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1d7bca7..d117262 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -296,7 +296,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
 
-		printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
+		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
 		print_modules();
diff --git a/lib/bug.c b/lib/bug.c
index 1955209..a28c141 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -169,7 +169,7 @@ enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 		return BUG_TRAP_TYPE_WARN;
 	}
 
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
+	printk(KERN_DEFAULT "------------[ cut here ]------------\n");
 
 	if (file)
 		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
