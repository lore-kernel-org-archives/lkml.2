Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1DRNpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:45:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1DRNp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:45:27 -0400
Date: Mon, 18 Apr 2011 15:44:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] signal: introduce retarget_shared_pending()
Message-ID: <20110418134443.GB15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes. Move the notify-other-threads code from exit_signals()
to the new helper, retarget_shared_pending().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- sigprocmask/kernel/signal.c~1_add_retarget_helper	2011-04-17 20:00:13.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-17 21:02:59.000000000 +0200
@@ -2017,10 +2017,25 @@ relock:
 	return signr;
 }
 
+/*
+ * It could be that complete_signal() picked us to notify about the
+ * group-wide signal. Another thread should be notified now to take
+ * the signal since we will not.
+ */
+static void retarget_shared_pending(struct task_struct *tsk)
+{
+	struct task_struct *t;
+
+	t = tsk;
+	while_each_thread(tsk, t) {
+		if (!signal_pending(t) && !(t->flags & PF_EXITING))
+			recalc_sigpending_and_wake(t);
+	}
+}
+
 void exit_signals(struct task_struct *tsk)
 {
 	int group_stop = 0;
-	struct task_struct *t;
 
 	if (thread_group_empty(tsk) || signal_group_exit(tsk->signal)) {
 		tsk->flags |= PF_EXITING;
@@ -2036,14 +2051,7 @@ void exit_signals(struct task_struct *ts
 	if (!signal_pending(tsk))
 		goto out;
 
-	/*
-	 * It could be that __group_complete_signal() choose us to
-	 * notify about group-wide signal. Another thread should be
-	 * woken now to take the signal since we will not.
-	 */
-	for (t = tsk; (t = next_thread(t)) != tsk; )
-		if (!signal_pending(t) && !(t->flags & PF_EXITING))
-			recalc_sigpending_and_wake(t);
+	retarget_shared_pending(tsk);
 
 	if (unlikely(tsk->signal->group_stop_count) &&
 			!--tsk->signal->group_stop_count) {

