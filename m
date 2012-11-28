Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2K1QoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:44:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab2K1QoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:44:17 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: zab@redhat.com, bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 13/25] aio: Convert read_events() to hrtimers
Date: Wed, 28 Nov 2012 08:43:37 -0800
Message-Id: <1354121029-1376-14-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1354121029-1376-1-git-send-email-koverstreet@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting read_events() to prepare_to_wait_exclusive() and
hrtimers simplifies it quite a bit.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 78 +++++++++++++++++-----------------------------------------------
 1 file changed, 21 insertions(+), 57 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 9d27508..7961f60 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -743,54 +743,16 @@ out:
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
@@ -825,20 +787,26 @@ static int read_events(struct kioctx *ctx,
 
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
@@ -848,7 +816,7 @@ static int read_events(struct kioctx *ctx,
 				ret = -EINVAL;
 				break;
 			}
-			if (to.timed_out)	/* Only check after read evt */
+			if (!t.task)	/* Only check after read evt */
 				break;
 			/* Try to only show up in io wait if there are ops
 			 *  in flight */
@@ -856,16 +824,13 @@ static int read_events(struct kioctx *ctx,
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
-
 		if (unlikely(ret <= 0))
 			break;
 
@@ -879,11 +844,10 @@ static int read_events(struct kioctx *ctx,
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
+	finish_wait(&ctx->wait, &wait);
 	return i ? i : ret;
 }
 
-- 
1.7.12

