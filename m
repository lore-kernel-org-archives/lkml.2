Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1EHPt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:49:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41864 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1EHPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:49:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=P5DZwcwd7F2Q7FaHg6DSwP3Z6yTzLLGUbEFHkr/NwYWO5lTqjcqSeT9WlEPzrvrCOg
         b2Oftp+zj+RpqLnjs6oy+IuEg6n8AqHU6wJHJXRwqXRSz6Fg1e4xOmcn/VFAYH+WqsaQ
         vTOJlIpF4SGqZNSvUR6MxqkAD7RQ67j0uYa4A=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/11] ptrace: ptrace_check_attach(): rename @kill to @ignore_state and add comments
Date: Sun,  8 May 2011 17:48:57 +0200
Message-Id: <1304869745-1073-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304869745-1073-1-git-send-email-tj@kernel.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTRACE_INTERRUPT is going to be added which should also skip
task_is_traced() check in ptrace_check_attach().  Rename @kill to
@ignore_state and make it bool.  Add function comment while at it.

This patch doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h |    2 +-
 kernel/ptrace.c        |   24 +++++++++++++++++++-----
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 705a47b..8de301a 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -112,7 +112,7 @@ extern long arch_ptrace(struct task_struct *child, long request,
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern void ptrace_disable(struct task_struct *);
-extern int ptrace_check_attach(struct task_struct *task, int kill);
+extern int ptrace_check_attach(struct task_struct *task, bool ignore_state);
 extern int ptrace_request(struct task_struct *child, long request,
 			  unsigned long addr, unsigned long data);
 extern void ptrace_notify(int exit_code);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d1e3740..0f0121a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -102,10 +102,24 @@ void __ptrace_unlink(struct task_struct *child)
 	spin_unlock(&child->sighand->siglock);
 }
 
-/*
- * Check that we have indeed attached to the thing..
+/**
+ * ptrace_check_attach - check whether ptracee is ready for ptrace operation
+ * @child: ptracee to check for
+ * @ignore_state: don't check whether @child is currently %TASK_TRACED
+ *
+ * Check whether @child is being ptraced by %current and ready for further
+ * ptrace operations.  If @ignore_state is %false, @child also should be in
+ * %TASK_TRACED state and on return the child is guaranteed to be traced
+ * and not executing.  If @ignore_state is %true, @child can be in any
+ * state.
+ *
+ * CONTEXT:
+ * Grabs and releases tasklist_lock and @child->sighand->siglock.
+ *
+ * RETURNS:
+ * 0 on success, -ESRCH if %child is not ready.
  */
-int ptrace_check_attach(struct task_struct *child, int kill)
+int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 {
 	int ret = -ESRCH;
 
@@ -124,13 +138,13 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 		 */
 		spin_lock_irq(&child->sighand->siglock);
 		WARN_ON_ONCE(task_is_stopped(child));
-		if (task_is_traced(child) || kill)
+		if (task_is_traced(child) || ignore_state)
 			ret = 0;
 		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
 
-	if (!ret && !kill)
+	if (!ret && !ignore_state)
 		ret = wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
 
 	/* All systems go.. */
-- 
1.7.1

