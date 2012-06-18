Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2FRKkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:40:16 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42041 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2FRKkO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 18 Jun 2012 06:40:14 -0400
Message-Id: <4FDF21A4020000780008A67F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 18 Jun 2012 11:40:04 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move call to print_modules() out of show_regs()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Printing the list of loaded modules is really unrelated to what this
function is about, and is particularly unnecessary in the context of
the SysRQ key handling (gets printed so far over and over).

It should really be the caller of the function to decide whether this
piece of information is useful (and to avoid redundantly printing it).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/dumpstack.c    |    1 +
 arch/x86/kernel/dumpstack_32.c |    1 -
 arch/x86/kernel/dumpstack_64.c |    1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

--- 3.5-rc3/arch/x86/kernel/dumpstack.c
+++ 3.5-rc3-x86-show_regs-no-print-modules/arch/x86/kernel/dumpstack.c
@@ -271,6 +271,7 @@ int __kprobes __die(const char *str, str
 			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
 
+	print_modules();
 	show_regs(regs);
 #ifdef CONFIG_X86_32
 	if (user_mode_vm(regs)) {
--- 3.5-rc3/arch/x86/kernel/dumpstack_32.c
+++ 3.5-rc3-x86-show_regs-no-print-modules/arch/x86/kernel/dumpstack_32.c
@@ -86,7 +86,6 @@ void show_regs(struct pt_regs *regs)
 {
 	int i;
 
-	print_modules();
 	__show_regs(regs, !user_mode_vm(regs));
 
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
--- 3.5-rc3/arch/x86/kernel/dumpstack_64.c
+++ 3.5-rc3-x86-show_regs-no-print-modules/arch/x86/kernel/dumpstack_64.c
@@ -254,7 +254,6 @@ void show_regs(struct pt_regs *regs)
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
-	print_modules();
 	__show_regs(regs, 1);
 	printk("Process %s (pid: %d, threadinfo %p, task %p)\n",
 		cur->comm, cur->pid, task_thread_info(cur), cur);



