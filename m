Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2LCVD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 16:03:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49143 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2LCU7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:59:33 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 13/26] aio: Convert read_events() to hrtimers
Date: Mon,  3 Dec 2012 12:58:29 -0800
Message-Id: <1354568322-29029-14-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354568322-29029-1-git-send-email-koverstreet@google.com>
References: <1354568322-29029-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting read_events() to prepare_to_wait_exclusive() and
hrtimers simplifies it quite a bit.

v2: Move finish_wait() call so we're not calling copy_to_user in
TASK_INTERRUPTIBLE state

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 77 ++++++++++++++++++----------------------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7b75590..46e6d30 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -785,54 +785,16 @@ out:
 	return ret;
 }
 
-struct aio_timeout {
-	struct timer_list	timer;
-	int			timed_out;
-	struct task_struct	*p;
-};
-
-static void timeout_func(unsigned long data)
-{
-	struct aio_timeout *to = (struct aio_timeout *)data;
-
-	to->timed_out = 1;
-	wake_up_process(to->p);
-}
-
-static inline void init_timeout(struct aio_timeout *to)
-{
-	setup_timer_on_stack(&to->timer, timeout_func, (unsigned long) to);
-	to->timed_out = 0;
-	to->p = current;
-}
-
-static inline void set_timeout(long start_jiffies, struct aio_timeout *to,
-			       const struct timespec *ts)
-{
-	to->timer.expires = start_jiffies + timespec_to_jiffies(ts);
-	if (time_after(to->timer.expires, jiffies))
-		add_timer(&to->timer);
-	else
-		to->timed_out = 1;
-}
-
-static inline void clear_timeout(struct aio_timeout *to)
-{
-	del_singleshot_timer_sync(&to->timer);
-}
-
 static int read_events(struct kioctx *ctx,
 			long min_nr, long nr,
 			struct io_event __user *event,
 			struct timespec __user *timeout)
 {
-	long			start_jiffies = jiffies;
-	struct task_struct	*tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	int			ret;
-	int			i = 0;
+	DEFINE_WAIT(wait);
+	struct hrtimer_sleeper t;
+	size_t i = 0;
+	int ret;
 	struct io_event		ent;
-	struct aio_timeout	to;
 
 	/* needed to zero any padding within an entry (there shouldn't be 
 	 * any, but C is fun!
@@ -867,20 +829,26 @@ static int read_events(struct kioctx *ctx,
 
 	/* End fast path */
 
-	init_timeout(&to);
+	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init_sleeper(&t, current);
+
 	if (timeout) {
 		struct timespec	ts;
-		ret = -EFAULT;
-		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts))))
+
+		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts)))) {
+			ret = -EFAULT;
 			goto out;
+		}
 
-		set_timeout(start_jiffies, &to, &ts);
+		hrtimer_start_range_ns(&t.timer, timespec_to_ktime(ts),
+				       current->timer_slack_ns, HRTIMER_MODE_REL);
 	}
 
 	while (likely(i < nr)) {
-		add_wait_queue_exclusive(&ctx->wait, &wait);
+		prepare_to_wait_exclusive(&ctx->wait, &wait,
+					  TASK_INTERRUPTIBLE);
+
 		do {
-			set_task_state(tsk, TASK_INTERRUPTIBLE);
 			ret = aio_read_evt(ctx, &ent);
 			if (ret)
 				break;
@@ -890,7 +858,7 @@ static int read_events(struct kioctx *ctx,
 				ret = -EINVAL;
 				break;
 			}
-			if (to.timed_out)	/* Only check after read evt */
+			if (!t.task)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
 			 *  in flight */
@@ -898,15 +866,14 @@ static int read_events(struct kioctx *ctx,
 				io_schedule();
 			else
 				schedule();
-			if (signal_pending(tsk)) {
+			if (signal_pending(current)) {
 				ret = -EINTR;
 				break;
 			}
 			/*ret = aio_read_evt(ctx, &ent);*/
 		} while (1) ;
 
-		set_task_state(tsk, TASK_RUNNING);
-		remove_wait_queue(&ctx->wait, &wait);
+		finish_wait(&ctx->wait, &wait);
 
 		if (unlikely(ret <= 0))
 			break;
@@ -921,11 +888,9 @@ static int read_events(struct kioctx *ctx,
 		event ++;
 		i ++;
 	}
-
-	if (timeout)
-		clear_timeout(&to);
 out:
-	destroy_timer_on_stack(&to.timer);
+	hrtimer_cancel(&t.timer);
+	destroy_hrtimer_on_stack(&t.timer);
 	return i ? i : ret;
 }
 
-- 
1.7.12

