Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab1IGErt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 00:47:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38461 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab1IGErm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 00:47:42 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] Make PTRACE_SEIZE set ptrace options specified in data parameter
Date: Wed, 7 Sep 2011 06:47:40 +0200
User-Agent: KMail/1.8.2
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109070647.40850.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make PTRACE_SEIZE set ptrace options specified in data parameter
    
This can be used to close a few corner cases in strace where we get
unwanted behavior after attach, but before we have a chance
to set options (the notorious post-execve SIGTRAP comes to mind),
and removes the need to track "did we set opts for this task?" state
in strace internals.
    
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 665ee93..ea83195 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -219,19 +219,23 @@ static int ptrace_attach(struct task_struct *task, long request,
 
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
+		if ((flags & ~(long)PTRACE_O_MASK) != PTRACE_SEIZE_DEVEL)
+			goto out;
+		flags &= ~PTRACE_SEIZE_DEVEL;
+	} else
+		flags = 0;
 
 	audit_ptrace(task);
 
@@ -263,7 +267,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	task->ptrace = PT_PTRACED;
+	task->ptrace = PT_PTRACED | (flags << PT_OPT_FLAG_SHIFT);
 	if (seize)
 		task->ptrace |= PT_SEIZED;
 	if (task_ns_capable(task, CAP_SYS_PTRACE))
