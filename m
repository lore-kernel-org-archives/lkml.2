Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454Ab0LPF0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 00:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab0LPF0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 00:26:02 -0500
Date: Thu, 16 Dec 2010 00:25:31 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org
Subject: remove long deprecated CLONE_STOPPED flag.
Message-ID: <20101216052530.GA24168@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we remove this completely ? (like the untested patch below)

	Dave

---
This warning was added in commit bdff746a3915f109bd13730b6847e33e17e91ed3
three years ago. 2.6.26 came and went. As far as I know, no-one is
actually using CLONE_STOPPED.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..ec07afe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -21,7 +21,8 @@
 #define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-#define CLONE_STOPPED		0x02000000	/* Start in stopped state */
+/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
+   and is now available for re-use. */
 #define CLONE_NEWUTS		0x04000000	/* New utsname group? */
 #define CLONE_NEWIPC		0x08000000	/* New ipcs */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
diff --git a/kernel/fork.c b/kernel/fork.c
index 3b159c5..5270bea 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1407,23 +1407,6 @@ long do_fork(unsigned long clone_flags,
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
@@ -1461,16 +1444,7 @@ long do_fork(unsigned long clone_flags,
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
