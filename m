Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1DRNpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab1DRNpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:45:45 -0400
Date: Mon, 18 Apr 2011 15:45:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] signal: retarget_shared_pending: consider
	shared/unblocked signals only
Message-ID: <20110418134501.GC15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_signals() checks signal_pending() before retarget_shared_pending() but
this is suboptimal. We can avoid the while_each_thread() loop in case when
there are no shared signals visible to us.

Add the "shared_pending.signal & ~blocked" check. We don't use tsk->blocked
directly but pass ~blocked as an argument, this is needed for the next patch.

Note: we can optimize this more. while_each_thread(t) can check t->blocked
into account and stop after every pending signal has the new target, see the
next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- sigprocmask/kernel/signal.c~2_optimize_retarget	2011-04-17 21:02:59.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-17 21:08:05.000000000 +0200
@@ -2022,10 +2022,15 @@ relock:
  * group-wide signal. Another thread should be notified now to take
  * the signal since we will not.
  */
-static void retarget_shared_pending(struct task_struct *tsk)
+static void retarget_shared_pending(struct task_struct *tsk, sigset_t *set)
 {
+	sigset_t shared_pending;
 	struct task_struct *t;
 
+	sigandsets(&shared_pending, &tsk->signal->shared_pending.signal, set);
+	if (sigisemptyset(&shared_pending))
+		return;
+
 	t = tsk;
 	while_each_thread(tsk, t) {
 		if (!signal_pending(t) && !(t->flags & PF_EXITING))
@@ -2036,6 +2041,7 @@ static void retarget_shared_pending(stru
 void exit_signals(struct task_struct *tsk)
 {
 	int group_stop = 0;
+	sigset_t set;
 
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
 		tsk->flags |= PF_EXITING;
@@ -2051,7 +2057,9 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	retarget_shared_pending(tsk);
+	set = tsk->blocked;
+	signotset(&set);
+	retarget_shared_pending(tsk, &set);
 
 	if (unlikely(tsk->signal->group_stop_count) &&
 			!--tsk->signal->group_stop_count) {

