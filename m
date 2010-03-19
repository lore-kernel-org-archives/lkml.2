Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0CSSmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:42:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0CSSm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:42:28 -0400
Date: Fri, 19 Mar 2010 19:40:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] clear signal->tty when the last thread exits
Message-ID: <20100319184020.GA519@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the last thread exits signal->tty is freed, but the pointer is not
cleared and points to nowhere.

This is OK. Nobody should use signal->tty lockless, and it is no longer
possible to take ->siglock. However this looks wrong even if correct, and
the nice OOPS is better than subtle and hard to find bugs.

Change __exit_signal() to clear signal->tty under ->siglock.

Note: __exit_signal() needs more cleanups. It should not check "sig != NULL"
to detect the all-dead case and we have the same issues with signal->stats.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 34-rc1/kernel/exit.c~9_CLEAR_SIGNAL_TTY	2010-03-19 17:25:36.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-19 18:55:02.000000000 +0100
@@ -81,6 +81,7 @@ static void __exit_signal(struct task_st
 {
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *sighand;
+	struct tty_struct *tty;
 
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
@@ -94,6 +95,8 @@ static void __exit_signal(struct task_st
 	posix_cpu_timers_exit(tsk);
 	if (thread_group_leader(tsk)) {
 		posix_cpu_timers_exit_group(tsk);
+		tty = sig->tty;
+		sig->tty = NULL;
 	} else {
 		/*
 		 * If there is any task waiting for the group exit
@@ -148,7 +151,7 @@ static void __exit_signal(struct task_st
 		 * see account_group_exec_runtime().
 		 */
 		task_rq_unlock_wait(tsk);
-		tty_kref_put(sig->tty);
+		tty_kref_put(tty);
 	}
 }
 

