Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab2AUWJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 17:09:49 -0500
Received: from seven.medozas.de ([188.40.89.202]:46259 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2AUWJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 17:09:48 -0500
From: Jan Engelhardt <jengelh@medozas.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 2/2] treewide: avoid truncation of process name
Date: Sat, 21 Jan 2012 23:09:45 +0100
Message-Id: <1327183785-27023-2-git-send-email-jengelh@medozas.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
References: <1327183785-27023-1-git-send-email-jengelh@medozas.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While producing the previous commit, "treewide: fix memory corruptions
when TASK_COMM_LEN != 16", I noticed

1. the process name is truncated for no apparent reason in a number of
places by means of the precision for the %s specifier
(t->comm is always NUL-terminated).
2. padded with an odd size (8) in another
3. redundant instance of: t->tcomm ? t->comm : ""
(t->comm is always non-NULL because it is an array)

Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 arch/x86/kernel/dumpstack.c  |    2 +-
 arch/x86/kernel/process.c    |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 kernel/cred.c                |    4 ++--
 kernel/irq/manage.c          |    2 +-
 kernel/sched/core.c          |    2 +-
 net/dns_resolver/internal.h  |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1aae78f..88d1c92 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -185,7 +185,7 @@ void dump_stack(void)
 	unsigned long stack;
 
 	bp = stack_frame(current, NULL);
-	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
+	printk("Pid: %d, comm: %s %s %s %.*s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..c7a73ad 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -105,7 +105,7 @@ void show_regs_common(void)
 	board = dmi_get_system_info(DMI_BOARD_NAME);
 
 	printk(KERN_CONT "\n");
-	printk(KERN_DEFAULT "Pid: %d, comm: %.20s %s %s %.*s",
+	printk(KERN_DEFAULT "Pid: %d, comm: %s %s %s %.*s",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..075610b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -225,7 +225,7 @@ void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
 		if (dead_task->mm->context.size) {
-			printk("WARNING: dead process %8s still has LDT? <%p/%d>\n",
+			printk("WARNING: dead process %s still has LDT? <%p/%d>\n",
 					dead_task->comm,
 					dead_task->mm->context.ldt,
 					dead_task->mm->context.size);
diff --git a/kernel/cred.c b/kernel/cred.c
index 5791612..7f10154 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -20,10 +20,10 @@
 
 #if 0
 #define kdebug(FMT, ...) \
-	printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
+	printk("[%s/%u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
 #else
 #define kdebug(FMT, ...) \
-	no_printk("[%-5.5s%5u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
+	no_printk("[%s/%u] "FMT"\n", current->comm, current->pid ,##__VA_ARGS__)
 #endif
 
 static struct kmem_cache *cred_jar;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a9a9dbe..7de16ae 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -838,7 +838,7 @@ void exit_irq_thread(void)
 
 	printk(KERN_ERR
 	       "exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
-	       tsk->comm ? tsk->comm : "", tsk->pid, tsk->irqaction->irq);
+	       tsk->comm, tsk->pid, tsk->irqaction->irq);
 
 	desc = irq_to_desc(tsk->irqaction->irq);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c968185..6caf7cf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4769,7 +4769,7 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-15.15s %c", p->comm,
+	printk(KERN_INFO "%s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
diff --git a/net/dns_resolver/internal.h b/net/dns_resolver/internal.h
index 189ca9e..8341712 100644
--- a/net/dns_resolver/internal.h
+++ b/net/dns_resolver/internal.h
@@ -36,7 +36,7 @@ extern unsigned dns_resolver_debug;
 #define	kdebug(FMT, ...)				\
 do {							\
 	if (unlikely(dns_resolver_debug))		\
-		printk(KERN_DEBUG "[%-6.6s] "FMT"\n",	\
+		printk(KERN_DEBUG "[%s] "FMT"\n",	\
 		       current->comm, ##__VA_ARGS__);	\
 } while (0)
 
-- 
1.7.7

