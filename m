Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054Ab2JYPq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:46:58 -0400
Received: from mail.southpole.se ([193.12.106.18]:51627 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab2JYPq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:46:56 -0400
From: Jonas Bonn <jonas@southpole.se>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 2/2] openrisc: determine regs directly in copy_thread
Date: Thu, 25 Oct 2012 17:46:39 +0200
Message-Id: <1351179999-8376-3-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351179999-8376-1-git-send-email-jonas@southpole.se>
References: <1351179999-8376-1-git-send-email-jonas@southpole.se>
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 80015-10638
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_thread can use current_pt_regs() to get the pt_regs data that
it needs so there's no need to pass this in as an argument.

As do_fork() doesn't use the regs argument for anything other than
to pass it straight through to copy_thread, we just pass in a NULL
argument in its place.  The plan seems to be to eventually drop the
regs argument to do_fork altogether.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/kernel/entry.S    |    6 ++----
 arch/openrisc/kernel/process.c  |    3 ++-
 arch/openrisc/kernel/sys_or32.c |    9 ++++-----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/openrisc/kernel/entry.S b/arch/openrisc/kernel/entry.S
index cbd8f13..ea5439e 100644
--- a/arch/openrisc/kernel/entry.S
+++ b/arch/openrisc/kernel/entry.S
@@ -1073,15 +1073,13 @@ _fork_save_extra_regs_and_call:
 
 ENTRY(sys_clone)
 	l.movhi	r29,hi(_sys_clone)
-	l.ori	r29,r29,lo(_sys_clone)
 	l.j	_fork_save_extra_regs_and_call
-	 l.addi	r7,r1,0
+	 l.ori	r29,r29,lo(_sys_clone)
 
 ENTRY(sys_fork)
 	l.movhi	r29,hi(_sys_fork)
-	l.ori	r29,r29,lo(_sys_fork)
 	l.j	_fork_save_extra_regs_and_call
-	 l.addi	r3,r1,0
+	 l.ori	r29,r29,lo(_sys_fork)
 
 ENTRY(sys_vfork)
 	l.movhi	r29,hi(_sys_vfork)
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index efbe4f8..87ca585 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -142,8 +142,9 @@ extern asmlinkage void ret_from_fork(void);
 
 int
 copy_thread(unsigned long clone_flags, unsigned long usp,
-	    unsigned long arg, struct task_struct *p, struct pt_regs *regs)
+	    unsigned long arg, struct task_struct *p, struct pt_regs * unused)
 {
+	struct pt_regs *regs = current_pt_regs();
 	struct pt_regs *userregs;
 	struct pt_regs *kregs;
 	unsigned long sp = (unsigned long)task_stack_page(p) + THREAD_SIZE;
diff --git a/arch/openrisc/kernel/sys_or32.c b/arch/openrisc/kernel/sys_or32.c
index db46b82..a50826d 100644
--- a/arch/openrisc/kernel/sys_or32.c
+++ b/arch/openrisc/kernel/sys_or32.c
@@ -41,20 +41,19 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
  */
 
 asmlinkage long _sys_clone(unsigned long clone_flags, unsigned long newsp,
-			   int __user *parent_tid, int __user *child_tid,
-			   struct pt_regs *regs)
+			   int __user *parent_tid, int __user *child_tid)
 {
 	long ret;
 
-	ret = do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
+	ret = do_fork(clone_flags, newsp, 0, 0, parent_tid, child_tid);
 
 	return ret;
 }
 
-asmlinkage int _sys_fork(struct pt_regs *regs)
+asmlinkage int _sys_fork()
 {
 #ifdef CONFIG_MMU
-	return do_fork(SIGCHLD, 0, regs, 0, NULL, NULL);
+	return do_fork(SIGCHLD, 0, 0, 0, NULL, NULL);
 #else
 	return -EINVAL;
 #endif
-- 
1.7.9.5

