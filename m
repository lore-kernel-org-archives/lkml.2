Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab2FTRHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:07:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2FTRHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:07:21 -0400
Date: Wed, 20 Jun 2012 10:07:07 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-0fa0e2f02e8edfbdb5f86d1cab0fa6dc0517489f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FDF21A4020000780008A67F@nat28.tlf.novell.com>
References: <4FDF21A4020000780008A67F@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Move call to print_modules() out of show_regs
 ()
Git-Commit-ID: 0fa0e2f02e8edfbdb5f86d1cab0fa6dc0517489f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 10:07:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fa0e2f02e8edfbdb5f86d1cab0fa6dc0517489f
Gitweb:     http://git.kernel.org/tip/0fa0e2f02e8edfbdb5f86d1cab0fa6dc0517489f
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 18 Jun 2012 11:40:04 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Jun 2012 14:33:48 +0200

x86: Move call to print_modules() out of show_regs()

Printing the list of loaded modules is really unrelated to what
this function is about, and is particularly unnecessary in the
context of the SysRQ key handling (gets printed so far over and
over).

It should really be the caller of the function to decide whether
this piece of information is useful (and to avoid redundantly
printing it).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4FDF21A4020000780008A67F@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/dumpstack.c    |    1 +
 arch/x86/kernel/dumpstack_32.c |    1 -
 arch/x86/kernel/dumpstack_64.c |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 87d3b5d..ae42418b 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -271,6 +271,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
 			current->thread.trap_nr, SIGSEGV) == NOTIFY_STOP)
 		return 1;
 
+	print_modules();
 	show_regs(regs);
 #ifdef CONFIG_X86_32
 	if (user_mode_vm(regs)) {
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 3a8aced..1038a41 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -86,7 +86,6 @@ void show_regs(struct pt_regs *regs)
 {
 	int i;
 
-	print_modules();
 	__show_regs(regs, !user_mode_vm(regs));
 
 	pr_emerg("Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)\n",
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index c582e9c..b653675 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -254,7 +254,6 @@ void show_regs(struct pt_regs *regs)
 
 	sp = regs->sp;
 	printk("CPU %d ", cpu);
-	print_modules();
 	__show_regs(regs, 1);
 	printk(KERN_DEFAULT "Process %s (pid: %d, threadinfo %p, task %p)\n",
 	       cur->comm, cur->pid, task_thread_info(cur), cur);
