Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab1IGVkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:40:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34813 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab1IGVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:40:34 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v2] Make PTRACE_SEIZE set ptrace options specified in 'data' parameter
Date: Wed, 7 Sep 2011 23:40:31 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Denys Vlasenko <vda.linux@googlemail.com>, dvlasenk@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109072340.31460.vda.linux@googlemail.com>
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
we were adding PT_SEIZED and PT_PTRACE_CAP with task->ptrace |= BIT.
This was probably ok (not a bug), but let's be on a safer side.
    
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 0316200..43aa09c 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -212,6 +212,7 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 }
 
 static int ptrace_attach(struct task_struct *task, long request,
+			 unsigned long addr,
 			 unsigned long flags)
 {
 	bool seize = (request == PTRACE_SEIZE);
@@ -219,19 +220,27 @@ static int ptrace_attach(struct task_struct *task, long request,
 
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
+		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
+			goto out;
+		flags &= ~PTRACE_SEIZE_DEVEL;
+		flags = PT_PTRACED | PT_SEIZED | (flags << PT_OPT_FLAG_SHIFT);
+	} else {
+		flags = PT_PTRACED;
+	}
 
 	audit_ptrace(task);
 
@@ -263,11 +272,9 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
-	if (seize)
-		task->ptrace |= PT_SEIZED;
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
-		task->ptrace |= PT_PTRACE_CAP;
+		flags |= PT_PTRACE_CAP;
+	task->ptrace = flags;
 
 	__ptrace_link(task, current);
 
@@ -865,7 +872,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	}
 
 	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
-		ret = ptrace_attach(child, request, data);
+		ret = ptrace_attach(child, request, addr, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
