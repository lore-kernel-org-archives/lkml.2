Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab2AZVno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:43:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40491 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab2AZVnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:43:42 -0500
Date: Thu, 26 Jan 2012 13:43:26 -0800
From: tip-bot for Prarit Bhargava <prarit@redhat.com>
Message-ID: <tip-b0f4c4b32c8e3aa0d44fc4dd6c40a9a9a8d66b63@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, prarit@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de, prarit@redhat.com, mingo@elte.hu
In-Reply-To: <1327586134-11926-1-git-send-email-prarit@redhat.com>
References: <1327586134-11926-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] bugs, x86: Fix printk levels for panic,
  softlockups and stack dumps
Git-Commit-ID: b0f4c4b32c8e3aa0d44fc4dd6c40a9a9a8d66b63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 13:43:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0f4c4b32c8e3aa0d44fc4dd6c40a9a9a8d66b63
Gitweb:     http://git.kernel.org/tip/b0f4c4b32c8e3aa0d44fc4dd6c40a9a9a8d66b63
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Thu, 26 Jan 2012 08:55:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 21:28:45 +0100

bugs, x86: Fix printk levels for panic, softlockups and stack dumps

rsyslog will display KERN_EMERG messages on a connected
terminal.  However, these messages are useless/undecipherable
for a general user.

For example, after a softlockup we get:

 Message from syslogd@intel-s3e37-04 at Jan 25 14:18:06 ...
 kernel:Stack:

 Message from syslogd@intel-s3e37-04 at Jan 25 14:18:06 ...
 kernel:Call Trace:

 Message from syslogd@intel-s3e37-04 at Jan 25 14:18:06 ...
 kernel:Code: ff ff a8 08 75 25 31 d2 48 8d 86 38 e0 ff ff 48 89
 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> ea 69 dd ff 4c 29 e8 48 89 c7 e8 0f bc da ff 49 89 c4 49 89

This happens because the printk levels for these messages are
incorrect. Only an informational message should be displayed on
a terminal.

I modified the printk levels for various messages in the kernel
and tested the output by using the drivers/misc/lkdtm.c kernel
modules (ie, softlockups, panics, hard lockups, etc.) and
confirmed that the console output was still the same and that
the output to the terminals was correct.

For example, in the case of a softlockup we now see the much
more informative:

 Message from syslogd@intel-s3e37-04 at Jan 25 10:18:06 ...
 BUG: soft lockup - CPU4 stuck for 60s!

instead of the above confusing messages.

AFAICT, the messages no longer have to be KERN_EMERG.  In the
most important case of a panic we set console_verbose().  As for
the other less severe cases the correct data is output to the
console and /var/log/messages.

Successfully tested by me using the drivers/misc/lkdtm.c module.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: dzickus@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1327586134-11926-1-git-send-email-prarit@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
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
