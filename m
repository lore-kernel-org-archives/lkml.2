Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1DKRVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:21:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1DKRVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:21:51 -0400
Date: Mon, 11 Apr 2011 19:20:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] signal: retarget_shared_pending: consider
	shared/unblocked signals only
Message-ID: <20110411172045.GC32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411171957.GA32469@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_signals() checks signal_pending() before retarget_shared_pending() but
this is suboptimal. We can avoid the while_each_thread() loop in case when
there are no shared signals visible to us.

Add the has_pending_signals(shared_pending, blocked) check. We don not use
tsk->blocked directly but pass this sigset_t as an argument, this is needed
for the next patch.

Note: we can optimize this more. while_each_thread(t) can check t->blocked
into account and stop after every pending signal has the new target.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- sigprocmask/kernel/signal.c~2_optimize_retarget	2011-04-10 19:33:45.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-10 21:54:24.000000000 +0200
@@ -2022,10 +2022,13 @@ relock:
  * group-wide signal. Another thread should be notified now to take
  * the signal since we will not.
  */
-static void retarget_shared_pending(struct task_struct *tsk)
+static void retarget_shared_pending(struct task_struct *tsk, sigset_t *blocked)
 {
 	struct task_struct *t;
 
+	if (!has_pending_signals(&tsk->signal->shared_pending.signal, blocked))
+		return;
+
 	t = tsk;
 	while_each_thread(tsk, t) {
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
@@ -2051,7 +2054,7 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	retarget_shared_pending(tsk);
+	retarget_shared_pending(tsk, &tsk->blocked);
 
 	if (unlikely(tsk->signal->group_stop_count) &&
 			!--tsk->signal->group_stop_count) {

