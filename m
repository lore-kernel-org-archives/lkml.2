Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab1I3EtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:49:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61328 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1I3EtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:49:10 -0400
Message-ID: <1317358146.9597.11.camel@PavelComp>
Subject: [RFC PATCH] Allow for stack traces to be printed on serial console
From: Pavel Ivanov <paivanof@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 30 Sep 2011 00:49:06 -0400
In-Reply-To: <CAG1a4rtrh7=+gr=kUGO6y4wt926F8rBusOcFgvu4CmvrmR5PCw@mail.gmail.com>
References: <CAG1a4rtrh7=+gr=kUGO6y4wt926F8rBusOcFgvu4CmvrmR5PCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I tried to chase some mysterious lockup of my PC the only means to
see some error reports for me was serial console. But it looks like only
printk with KERN_ERR is sent to serial console. So when hung task
detector tried to show me stack traces for hung tasks I didn't see them
on serial console and I didn't see them after reboot as they couldn't be
saved to dmesg. Thus the following patch allowed me to actually see
those stack traces.

I believe kernel prints stack traces only in some serious cases and
expects that they would be actually seen, so KERN_ERR looks justified
for me in all changed places. I understand that patch is incomplete and
would need some other places to be changed for consistency (at least
other arch code). But first I want to hear comments on whether this
approach is good enough to be included in mainline or it should be left
for me as a hack.


Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
---

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1aae78f..52770aa 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -27,7 +27,7 @@ static int die_counter;
 
 void printk_address(unsigned long address, int reliable)
 {
-	printk(" [<%p>] %s%pB\n", (void *) address,
+	printk("[<%p>] %s%pB\n", (void *) address,
 			reliable ? "" : "? ", (void *) address);
 }
 
@@ -147,7 +147,7 @@ static int print_trace_stack(void *data, char *name)
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
 	touch_nmi_watchdog();
-	printk(data);
+	printk("%s ", (char*)data);
 	printk_address(addr, reliable);
 }
 
@@ -173,7 +173,7 @@ void show_trace(struct task_struct *task, struct pt_regs *regs,
 
 void show_stack(struct task_struct *task, unsigned long *sp)
 {
-	show_stack_log_lvl(task, NULL, sp, 0, "");
+	show_stack_log_lvl(task, NULL, sp, 0, KERN_ERR);
 }
 
 /*
@@ -281,7 +281,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 	printk(" SS:ESP %04x:%08lx\n", ss, sp);
 #else
 	/* Executive summary in case the oops scrolled away */
-	printk(KERN_ALERT "RIP ");
+	printk(KERN_ALERT "RIP  ");
 	printk_address(regs->ip, 1);
 	printk(" RSP <%016lx>\n", regs->sp);
 #endif
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 91d67ce..eb525ba 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -547,14 +547,14 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 	int i, depth = curr->lockdep_depth;
 
 	if (!depth) {
-		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
+		printk(KERN_ERR "no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
 		return;
 	}
-	printk("%d lock%s held by %s/%d:\n",
+	printk(KERN_ERR "%d lock%s held by %s/%d:\n",
 		depth, depth > 1 ? "s" : "", curr->comm, task_pid_nr(curr));
 
 	for (i = 0; i < depth; i++) {
-		printk(" #%d: ", i);
+		printk(KERN_ERR " #%d: ", i);
 		print_lock(curr->held_locks + i);
 	}
 }
@@ -3977,7 +3977,7 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
 void debug_show_held_locks(struct task_struct *task)
 {
 	if (unlikely(!debug_locks)) {
-		printk("INFO: lockdep is turned off.\n");
+		printk(KERN_ERR "INFO: lockdep is turned off.\n");
 		return;
 	}
 	lockdep_print_held_locks(task);
diff --git a/kernel/sched.c b/kernel/sched.c
index ec5f472..e05d443 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5865,7 +5865,7 @@ void sched_show_task(struct task_struct *p)
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk(KERN_INFO "%-15.15s %c", p->comm,
+	printk(KERN_ERR "%-15.15s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)


