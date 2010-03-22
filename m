Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0CVSnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:43:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab0CVSnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:43:06 -0400
Date: Mon, 22 Mar 2010 19:41:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/3] proc: make task_sig() lockless
Message-ID: <20100322184136.GA3967@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that task->signal can't go away and collect_sigign_sigcatch()
is rcu-safe, task_sig() doesn't need ->siglock.

Remove lock_task_sighand() and unnecessary sigemptyset's, move
collect_sigign_sigcatch() under rcu_read_lock().

Of course, this means we read pending/blocked/etc nonatomically,
but I hope this is OK for fs/proc.

Probably we can change do_task_stat() to avod ->siglock too, except
we can't get tty_nr lockless.

Also, remove the "is this correct?" comment. I think it is safe
to dereference __task_cred(p)->user under rcu lock. In any case,
->siglock can't help to protect cred->user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/array.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

--- 34-rc1/fs/proc/array.c~PROC_3_TASK_SIG_DONT_USE_SIGLOCK	2010-03-22 17:39:42.000000000 +0100
+++ 34-rc1/fs/proc/array.c	2010-03-22 18:36:13.000000000 +0100
@@ -257,30 +257,24 @@ static void collect_sigign_sigcatch(stru
 
 static inline void task_sig(struct seq_file *m, struct task_struct *p)
 {
-	unsigned long flags;
 	sigset_t pending, shpending, blocked, ignored, caught;
 	int num_threads = 0;
 	unsigned long qsize = 0;
 	unsigned long qlim = 0;
 
-	sigemptyset(&pending);
-	sigemptyset(&shpending);
-	sigemptyset(&blocked);
 	sigemptyset(&ignored);
 	sigemptyset(&caught);
 
-	if (lock_task_sighand(p, &flags)) {
-		pending = p->pending.signal;
-		shpending = p->signal->shared_pending.signal;
-		blocked = p->blocked;
-		collect_sigign_sigcatch(p, &ignored, &caught);
-		num_threads = get_nr_threads(p);
-		rcu_read_lock();  /* FIXME: is this correct? */
-		qsize = atomic_read(&__task_cred(p)->user->sigpending);
-		rcu_read_unlock();
-		qlim = task_rlimit(p, RLIMIT_SIGPENDING);
-		unlock_task_sighand(p, &flags);
-	}
+	blocked = p->blocked;
+	pending = p->pending.signal;
+	shpending = p->signal->shared_pending.signal;
+	qlim = task_rlimit(p, RLIMIT_SIGPENDING);
+	num_threads = get_nr_threads(p);
+
+	rcu_read_lock();
+	collect_sigign_sigcatch(p, &ignored, &caught);
+	qsize = atomic_read(&__task_cred(p)->user->sigpending);
+	rcu_read_unlock();
 
 	seq_printf(m, "Threads:\t%d\n", num_threads);
 	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);

