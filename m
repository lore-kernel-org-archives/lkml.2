Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0LXOC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 09:02:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33324 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab0LXOBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 09:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=T00QNQDije6Fgh90LO99pwH9QCmhD7Ezqnqd+w/lKKnQa2FT6cVx85QYLx5UQ9TIso
         +C4a4Qpzy6GRsyxIJdGkaZBWLuVJizITt1w0IEW4G/s3jTWyf6cSWXkmQ21o/wXdghf4
         +jgd6LhDX4QHd8qtxLSUyvoeLvjnrOPpODe+U=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] clone: kill CLONE_STOPPED
Date: Fri, 24 Dec 2010 15:00:51 +0100
Message-Id: <1293199257-11255-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293199257-11255-1-git-send-email-tj@kernel.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLONE_STOPPED has been deprecated and generating warning messages
since 2.6.25 with recycling scheduled for 2.6.26.  Remove it to
prepare for signal stop / ptrace cleanup.

For more details, please refer to the commit bdff746a (clone: prepare
to recycle CLONE_STOPPED).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
---
 include/linux/sched.h |    1 -
 kernel/fork.c         |   28 +---------------------------
 2 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2238745..653644d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -21,7 +21,6 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-#define CLONE_STOPPED		0x02000000	/* Start in stopped state */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5447dc7..0d38381 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1408,23 +1408,6 @@ long do_fork(unsigned long clone_flags,
 	}
 
 	/*
-	 * We hope to recycle these flags after 2.6.26
-	 */
-	if (unlikely(clone_flags & CLONE_STOPPED)) {
-		static int __read_mostly count = 100;
-
-		if (count > 0 && printk_ratelimit()) {
-			char comm[TASK_COMM_LEN];
-
-			count--;
-			printk(KERN_INFO "fork(): process `%s' used deprecated "
-					"clone flags 0x%lx\n",
-				get_task_comm(comm, current),
-				clone_flags & CLONE_STOPPED);
-		}
-	}
-
-	/*
 	 * When called from kernel_thread, don't do user tracing stuff.
 	 */
 	if (likely(user_mode(regs)))
@@ -1462,16 +1445,7 @@ long do_fork(unsigned long clone_flags,
 		 */
 		p->flags &= ~PF_STARTING;
 
-		if (unlikely(clone_flags & CLONE_STOPPED)) {
-			/*
-			 * We'll start up with an immediate SIGSTOP.
-			 */
-			sigaddset(&p->pending.signal, SIGSTOP);
-			set_tsk_thread_flag(p, TIF_SIGPENDING);
-			__set_task_state(p, TASK_STOPPED);
-		} else {
-			wake_up_new_task(p, clone_flags);
-		}
+		wake_up_new_task(p, clone_flags);
 
 		tracehook_report_clone_complete(trace, regs,
 						clone_flags, nr, p);
-- 
1.7.1

