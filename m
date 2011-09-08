Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab1IHXej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1IHXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:34:32 -0400
Subject: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 08 Sep 2011 20:22:04 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
    
This can be used to close a few corner cases in strace where we get
unwanted racy behavior after attach, but before we have a chance
to set options (the notorious post-execve SIGTRAP comes to mind),
and removes the need to track "did we set opts for this task" state
in strace internals.
    
While we are at it:
    
Make it possible to extend SEIZE in the future with more functionality
by passing non-zero 'addr' parameter.
To that end, error out if 'addr' is non-zero.
PTRACE_ATTACH did not (and still does not) have such check,
and users (strace) do pass garbage there... let's avoid repeating
this mistake with SEIZE.
    
Set all task->ptrace bits in one operation - before this change,
we were adding PT_SEIZED and PT_PTRACE_CAP with task->ptrace |= BIT ops.
This was probably ok (not a bug), but let's be on a safer side.

Changes since v2: use (unsigned long) casts instead of (long) ones,
move PTRACE_SEIZE_DEVEL-related code to separate lines of code.

    
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index dbc4a3e..166de95 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -212,6 +212,7 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 }
 
 static int ptrace_attach(struct task_struct *task, long request,
+			 unsigned long addr,
 			 unsigned long flags)
 {
 	bool seize = (request == PTRACE_SEIZE);
@@ -219,19 +220,29 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	/*
 	 * SEIZE will enable new ptrace behaviors which will be implemented
-	 * gradually.  SEIZE_DEVEL is used to prevent applications
+	 * gradually.  SEIZE_DEVEL bit is used to prevent applications
 	 * expecting full SEIZE behaviors trapping on kernel commits which
 	 * are still in the process of implementing them.
 	 *
 	 * Only test programs for new ptrace behaviors being implemented
 	 * should set SEIZE_DEVEL.  If unset, SEIZE will fail with -EIO.
 	 *
-	 * Once SEIZE behaviors are completely implemented, this flag and
-	 * the following test will be removed.
+	 * Once SEIZE behaviors are completely implemented, this flag
+	 * will be removed.
 	 */
 	retval = -EIO;
-	if (seize && !(flags & PTRACE_SEIZE_DEVEL))
-		goto out;
+	if (seize) {
+		if (addr != 0)
+			goto out;
+		if (!(flags & PTRACE_SEIZE_DEVEL))
+			goto out;
+		flags &= ~(unsigned long)PTRACE_SEIZE_DEVEL;
+		if (flags & ~(unsigned long)PTRACE_O_MASK)
+			goto out;
+		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
+	} else {
+		flags = PT_PTRACED;
+	}
 
 	audit_ptrace(task);
 
@@ -263,11 +274,10 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
-	if (seize)
-		task->ptrace |= PT_SEIZED;
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
-		task->ptrace |= PT_PTRACE_CAP;
+		flags |= PT_PTRACE_CAP;
+
+	task->ptrace = flags;
 
 	__ptrace_link(task, current);
 
@@ -865,7 +875,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	}
 
 	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
-		ret = ptrace_attach(child, request, data);
+		ret = ptrace_attach(child, request, addr, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.


