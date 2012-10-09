Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab2JIGjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:39:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39639 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab2JIGji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:39:38 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Cc: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Date: Mon,  8 Oct 2012 23:39:20 -0700
Message-Id: <1349764760-21093-5-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349764760-21093-1-git-send-email-koverstreet@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bunch of cleanup, and make it lockless so that userspace can safely pull
events off the ringbuffer without racing with io_getevents().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c |  220 +++++++++++++++++++++-----------------------------------------
 1 file changed, 73 insertions(+), 147 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index c3d97d1..1efc8a3 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -259,7 +259,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_set(&ctx->reqs_active, 1);
 
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -941,194 +940,121 @@ put_rq:
 }
 EXPORT_SYMBOL(aio_complete);
 
-/* aio_read_evt
- *	Pull an event off of the ioctx's event ring.  Returns the number of 
- *	events fetched (0 or 1 ;-)
- *	FIXME: make this use cmpxchg.
- *	TODO: make the ringbuffer user mmap()able (requires FIXME).
+/* aio_read_events
+ *	Pull an event off of the ioctx's event ring.  Returns the number of
+ *	events fetched
  */
-static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
+static int aio_read_events(struct kioctx *ctx, struct io_event __user *event,
+			   long nr)
 {
-	struct aio_ring_info *info = &ioctx->ring_info;
+	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring = info->ring;
-	unsigned long head;
-	int ret = 0;
-
-	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
-		 (unsigned long)ring->head, (unsigned long)ring->tail,
-		 (unsigned long)ring->nr);
-
-	if (ring->head == ring->tail)
-		goto out;
-
-	spin_lock(&info->ring_lock);
+	unsigned old, new;
+	int ret;
 
-	head = ring->head % info->nr;
-	if (head != ring->tail) {
-		*ent = ring->io_events[head];
-		head = (head + 1) % info->nr;
-		smp_mb(); /* finish reading the event before updatng the head */
-		ring->head = head;
-		ret = 1;
-	}
-	spin_unlock(&info->ring_lock);
+	pr_debug("h%lu t%lu m%lu\n",
+		 (unsigned long) ring->head,
+		 (unsigned long) ring->tail,
+		 (unsigned long) ring->nr);
+retry:
+	ret = 0;
+	old = new = ring->head;
 
-out:
-	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
-		 (unsigned long)ring->head, (unsigned long)ring->tail);
-	return ret;
-}
+	while (ret < nr && new != ring->tail) {
+		struct io_event *ev = &ring->io_events[new];
+		unsigned i = (new < ring->tail ? ring->tail : info->nr) - new;
 
-struct aio_timeout {
-	struct timer_list	timer;
-	int			timed_out;
-	struct task_struct	*p;
-};
+		i = min_t(int, i, nr - ret);
 
-static void timeout_func(unsigned long data)
-{
-	struct aio_timeout *to = (struct aio_timeout *)data;
+		if (unlikely(copy_to_user(event + ret, ev, sizeof(*ev) * i)))
+			return -EFAULT;
 
-	to->timed_out = 1;
-	wake_up_process(to->p);
-}
+		ret += i;
+		new += i;
+		new %= info->nr;
+	}
 
-static inline void init_timeout(struct aio_timeout *to)
-{
-	setup_timer_on_stack(&to->timer, timeout_func, (unsigned long) to);
-	to->timed_out = 0;
-	to->p = current;
-}
+	if (new != old) {
+		smp_mb(); /* finish reading the event before updatng the head */
 
-static inline void set_timeout(long start_jiffies, struct aio_timeout *to,
-			       const struct timespec *ts)
-{
-	to->timer.expires = start_jiffies + timespec_to_jiffies(ts);
-	if (time_after(to->timer.expires, jiffies))
-		add_timer(&to->timer);
-	else
-		to->timed_out = 1;
-}
+		if (cmpxchg(&ring->head, old, new) != old)
+			goto retry;
+	}
 
-static inline void clear_timeout(struct aio_timeout *to)
-{
-	del_singleshot_timer_sync(&to->timer);
+	pr_debug("ret %d  h%lu t%lu\n", ret,
+		 (unsigned long)ring->head,
+		 (unsigned long)ring->tail);
+	return ret;
 }
 
-static int read_events(struct kioctx *ctx,
-			long min_nr, long nr,
-			struct io_event __user *event,
-			struct timespec __user *timeout)
+static int read_events(struct kioctx *ctx, long min_nr, long nr,
+		       struct io_event __user *event,
+		       struct timespec __user *timeout)
 {
-	long			start_jiffies = jiffies;
-	struct task_struct	*tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	int			ret;
-	int			i = 0;
-	struct io_event		ent;
-	struct aio_timeout	to;
-	int			retry = 0;
-
-	/* needed to zero any padding within an entry (there shouldn't be 
-	 * any, but C is fun!
-	 */
-	memset(&ent, 0, sizeof(ent));
+	DEFINE_WAIT(wait);
+	long until = MAX_SCHEDULE_TIMEOUT;
+	size_t i = 0;
+	int ret, retry = 0;
 retry:
-	ret = 0;
-	while (likely(i < nr)) {
-		ret = aio_read_evt(ctx, &ent);
-		if (unlikely(ret <= 0))
-			break;
-
-		dprintk("read event: %Lx %Lx %Lx %Lx\n",
-			ent.data, ent.obj, ent.res, ent.res2);
-
-		/* Could we split the check in two? */
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
-			break;
-		}
-		ret = 0;
-
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
-	}
+	ret = aio_read_events(ctx, event + i, nr - i);
+	if (ret < 0)
+		return ret;
 
-	if (min_nr <= i)
+	i += ret;
+	if (i >= min_nr)
 		return i;
-	if (ret)
-		return ret;
 
 	/* End fast path */
 
 	/* racey check, but it gets redone */
+	/* XXX: wtf is this for? */
 	if (!retry && unlikely(!list_empty(&ctx->run_list))) {
 		retry = 1;
 		aio_run_all_iocbs(ctx);
 		goto retry;
 	}
 
-	init_timeout(&to);
 	if (timeout) {
 		struct timespec	ts;
-		ret = -EFAULT;
 		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts))))
-			goto out;
+			return -EFAULT;
 
-		set_timeout(start_jiffies, &to, &ts);
+		until = timespec_to_jiffies(&ts);
 	}
 
-	while (likely(i < nr)) {
-		add_wait_queue_exclusive(&ctx->wait, &wait);
-		do {
-			set_task_state(tsk, TASK_INTERRUPTIBLE);
-			ret = aio_read_evt(ctx, &ent);
-			if (ret)
-				break;
-			if (min_nr <= i)
-				break;
-			if (unlikely(ctx->dead)) {
-				ret = -EINVAL;
-				break;
-			}
-			if (to.timed_out)	/* Only check after read evt */
-				break;
-			/* Try to only show up in io wait if there are ops
-			 *  in flight */
-			if (atomic_read(&ctx->reqs_active) > 1)
-				io_schedule();
-			else
-				schedule();
-			if (signal_pending(tsk)) {
-				ret = -EINTR;
-				break;
-			}
-			/*ret = aio_read_evt(ctx, &ent);*/
-		} while (1) ;
+	while (i < nr) {
+		prepare_to_wait_exclusive(&ctx->wait, &wait,
+					  TASK_INTERRUPTIBLE);
 
-		set_task_state(tsk, TASK_RUNNING);
-		remove_wait_queue(&ctx->wait, &wait);
+		ret = aio_read_events(ctx, event + i, nr - i);
+		if (ret < 0)
+			break;
 
-		if (unlikely(ret <= 0))
+		i += ret;
+		if (i >= min_nr)
 			break;
 
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			dprintk("aio: lost an event due to EFAULT.\n");
+		if (unlikely(ctx->dead)) {
+			ret = -EINVAL;
 			break;
 		}
 
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
+		if (!until)	/* Only check after read evt */
+			break;
+
+		/* Try to only show up in io wait if there are ops in flight */
+		if (atomic_read(&ctx->reqs_active) > 1)
+			until = io_schedule_timeout(until);
+		else
+			until = schedule_timeout(until);
+
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
 	}
 
-	if (timeout)
-		clear_timeout(&to);
-out:
-	destroy_timer_on_stack(&to.timer);
+	finish_wait(&ctx->wait, &wait);
 	return i ? i : ret;
 }
 
-- 
1.7.10.4

