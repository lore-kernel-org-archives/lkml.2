Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab2BJOn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:43:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55014 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406Ab2BJOn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:43:56 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 3/5] ptrace: make PTRACE_SEIZE set ptrace options specified in 'data' parameter
Date: Fri, 10 Feb 2012 15:43:09 +0100
Message-Id: <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328884991-23889-3-git-send-email-vda.linux@googlemail.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-3-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 kernel/ptrace.c |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 9acd07a..99a18a0 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -231,6 +231,7 @@ bool ptrace_may_access(struct task_struct *task, unsigned int mode)
 }
 
 static int ptrace_attach(struct task_struct *task, long request,
+			 unsigned long addr,
 			 unsigned long flags)
 {
 	bool seize = (request == PTRACE_SEIZE);
@@ -238,19 +239,29 @@ static int ptrace_attach(struct task_struct *task, long request,
 
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
 
@@ -282,11 +293,11 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
 	if (seize)
-		task->ptrace |= PT_SEIZED;
+		flags |= PT_SEIZED;
 	if (ns_capable(task_user_ns(task), CAP_SYS_PTRACE))
-		task->ptrace |= PT_PTRACE_CAP;
+		flags |= PT_PTRACE_CAP;
+	task->ptrace = flags;
 
 	__ptrace_link(task, current);
 
@@ -879,7 +890,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
 	}
 
 	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
-		ret = ptrace_attach(child, request, data);
+		ret = ptrace_attach(child, request, addr, data);
 		/*
 		 * Some architectures need to do book-keeping after
 		 * a ptrace attach.
-- 
1.7.7.6

