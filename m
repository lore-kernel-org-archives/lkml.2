Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0CUStV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:49:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0CUStS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:49:18 -0400
Date: Sun, 21 Mar 2010 19:47:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/3] exit: __exit_signal: use thread_group_leader()
	consistently
Message-ID: <20100321184751.GA29068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup:

- Add the boolean, group_dead = thread_group_leader(), for clarity.

- Do not test/set sig == NULL to detect the all-dead case, use this
  boolean.

- Pass this boolen to __unhash_process() and use it instead of another
  thread_group_leader() call which needs ->group_leader.

  This can be considered as microoptimization, but hopefully this also
  allows us do do other cleanups later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- 34-rc1/kernel/exit.c~11_EXIT_SIGNAL_CLEANUP_GROUP_DEAD	2010-03-19 19:17:53.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-21 18:34:02.000000000 +0100
@@ -59,11 +59,11 @@
 
 static void exit_mm(struct task_struct * tsk);
 
-static void __unhash_process(struct task_struct *p)
+static void __unhash_process(struct task_struct *p, bool group_dead)
 {
 	nr_threads--;
 	detach_pid(p, PIDTYPE_PID);
-	if (thread_group_leader(p)) {
+	if (group_dead) {
 		detach_pid(p, PIDTYPE_PGID);
 		detach_pid(p, PIDTYPE_SID);
 
@@ -80,6 +80,7 @@ static void __unhash_process(struct task
 static void __exit_signal(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
+	bool group_dead = thread_group_leader(tsk);
 	struct sighand_struct *sighand;
 	struct tty_struct *tty;
 
@@ -93,7 +94,7 @@ static void __exit_signal(struct task_st
 	atomic_dec(&sig->count);
 
 	posix_cpu_timers_exit(tsk);
-	if (thread_group_leader(tsk)) {
+	if (group_dead) {
 		posix_cpu_timers_exit_group(tsk);
 		tty = sig->tty;
 		sig->tty = NULL;
@@ -128,10 +129,9 @@ static void __exit_signal(struct task_st
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
-		sig = NULL; /* Marker for below. */
 	}
 
-	__unhash_process(tsk);
+	__unhash_process(tsk, group_dead);
 
 	/*
 	 * Do this under ->siglock, we can race with another thread
@@ -143,7 +143,7 @@ static void __exit_signal(struct task_st
 
 	__cleanup_sighand(sighand);
 	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
-	if (sig) {
+	if (group_dead) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
 		tty_kref_put(tty);

