Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0CRWi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:38:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab0CRWi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:38:58 -0400
Date: Thu, 18 Mar 2010 23:37:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] move tty_kref_put() outside of __cleanup_signal()
Message-ID: <20100318223736.GA12944@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_kref_put() have two callsites in copy_process() pathes,

	1. if copy_process() suceeds it is called before we copy
	   signal->tty from parent

	2. otherwise it is called from __cleanup_signal() under
	   bad_fork_cleanup_signal: label

In both cases tty_kref_put() is not right and unneeded because we don't
have the balancing tty_kref_get(). Fortunately, this is harmless because
this can only happen without CLONE_THREAD, and in this case signal->tty
must be NULL.

Remove tty_kref_put() from copy_process() and __cleanup_signal(), and
change another caller of __cleanup_signal(), __exit_signal(), to call
tty_kref_put() by hand.

I hope this change makes sense by itself, but it is also needed to
make ->signal refcountable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |    2 --
 kernel/exit.c |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

--- 34-rc1/kernel/fork.c~7_TTY_PUT	2010-03-17 16:04:22.000000000 +0100
+++ 34-rc1/kernel/fork.c	2010-03-18 22:45:14.000000000 +0100
@@ -896,7 +896,6 @@ static int copy_signal(unsigned long clo
 void __cleanup_signal(struct signal_struct *sig)
 {
 	thread_group_cputime_free(sig);
-	tty_kref_put(sig->tty);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1264,7 +1263,6 @@ static struct task_struct *copy_process(
 				p->nsproxy->pid_ns->child_reaper = p;
 
 			p->signal->leader_pid = pid;
-			tty_kref_put(p->signal->tty);
 			p->signal->tty = tty_kref_get(current->signal->tty);
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
--- 34-rc1/kernel/exit.c~7_TTY_PUT	2010-03-17 20:05:38.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-18 22:46:41.000000000 +0100
@@ -150,6 +150,7 @@ static void __exit_signal(struct task_st
 		 * see account_group_exec_runtime().
 		 */
 		task_rq_unlock_wait(tsk);
+		tty_kref_put(sig->tty);
 		__cleanup_signal(sig);
 	}
 }

