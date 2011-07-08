Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1GHRQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:16:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab1GHRQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:16:33 -0400
Date: Fri, 8 Jul 2011 19:13:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, indan@nul.nu, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace: mv send-SIGSTOP from do_fork() to
	ptrace_init_task()
Message-ID: <20110708171354.GC26943@redhat.com>
References: <20110708171320.GA26943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708171320.GA26943@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the new child is traced, do_fork() adds the pending SIGSTOP.
It assumes that either it is traced because of auto-attach or the
tracer attached later, in both cases sigaddset/set_thread_flag is
correct even if SIGSTOP is already pending.

Now that we have PTRACE_SEIZE this is no longer right in the latter
case. If the tracer does PTRACE_SEIZE after copy_process() makes the
child visible the queued SIGSTOP is wrong.

We could check PT_SEIZED bit and change ptrace_attach() to set both
PT_PTRACED and PT_SEIZED bits simultaneously but see the next patch,
we need to know whether this child was auto-attached or not anyway.

So this patch simply moves this code to ptrace_init_task(), this
way we can never race with ptrace_attach().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |    3 +++
 kernel/fork.c          |   12 ------------
 2 files changed, 3 insertions(+), 12 deletions(-)

--- ptrace/include/linux/ptrace.h~4_send_stop_from_ptrace_init	2011-07-08 17:24:46.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-07-08 18:32:05.000000000 +0200
@@ -227,6 +227,9 @@ static inline void ptrace_init_task(stru
 	if (unlikely(ptrace) && current->ptrace) {
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
+
+		sigaddset(&child->pending.signal, SIGSTOP);
+		set_tsk_thread_flag(child, TIF_SIGPENDING);
 	}
 }
 
--- ptrace/kernel/fork.c~4_send_stop_from_ptrace_init	2011-07-08 17:24:46.000000000 +0200
+++ ptrace/kernel/fork.c	2011-07-08 17:25:25.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/swap.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
-#include <linux/tracehook.h>
 #include <linux/futex.h>
 #include <linux/compat.h>
 #include <linux/kthread.h>
@@ -1522,17 +1521,6 @@ long do_fork(unsigned long clone_flags,
 		audit_finish_fork(p);
 
 		/*
-		 * Child is ready but hasn't started running yet.  Queue
-		 * SIGSTOP if it's gonna be ptraced - it doesn't matter who
-		 * attached/attaching to this task, the pending SIGSTOP is
-		 * right in any case.
-		 */
-		if (unlikely(p->ptrace)) {
-			sigaddset(&p->pending.signal, SIGSTOP);
-			set_tsk_thread_flag(p, TIF_SIGPENDING);
-		}
-
-		/*
 		 * We set PF_STARTING at creation in case tracing wants to
 		 * use this to distinguish a fully live task from one that
 		 * hasn't finished SIGSTOP raising yet.  Now we clear it

