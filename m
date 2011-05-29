Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1E2XM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 19:12:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53557 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1E2XMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 19:12:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Q4OFYB0whzc9TZMN1IGwOgqutq9H7Tda6SkcsN3ZutJPEjRrL/9No77QkO3SrJuf0R
         vLmLAGIz+JCAWr7QRSlHcGNMUypZMhu4yoksP0FVJY5bJMWt/aMYYbl745RmWYjS0ire
         kXSPhmoCGwxwH4VAD9OmKE3jl91/y3qtGv2/A=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/17] ptrace: ptrace_check_attach(): rename @kill to @ignore_state and add comments
Date: Mon, 30 May 2011 01:12:26 +0200
Message-Id: <1306710760-16440-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306710760-16440-1-git-send-email-tj@kernel.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
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
index 9178d5c..e93ef1a 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -105,7 +105,7 @@ extern long arch_ptrace(struct task_struct *child, long request,
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
 extern void ptrace_disable(struct task_struct *);
-extern int ptrace_check_attach(struct task_struct *task, int kill);
+extern int ptrace_check_attach(struct task_struct *task, bool ignore_state);
 extern int ptrace_request(struct task_struct *child, long request,
 			  unsigned long addr, unsigned long data);
 extern void ptrace_notify(int exit_code);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index da14bd2..cbda3c2 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -97,10 +97,24 @@ void __ptrace_unlink(struct task_struct *child)
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
 
@@ -119,13 +133,13 @@ int ptrace_check_attach(struct task_struct *child, int kill)
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
1.7.5.2

