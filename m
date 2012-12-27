Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab2L0CEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:04:31 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58338 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2L0CAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:00:44 -0500
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: [PATCH 14/32] aio: Make aio_read_evt() more efficient, convert to hrtimers
Date: Wed, 26 Dec 2012 17:59:52 -0800
Message-Id: <1356573611-18590-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1356573611-18590-1-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, aio_read_event() pulled a single completion off the
ringbuffer at a time, locking and unlocking each time.  Changed it to
pull off as many events as it can at a time, and copy them directly to
userspace.

This also fixes a bug where if copying the event to userspace failed,
we'd lose the event.

Also convert it to wait_event_interruptible_hrtimeout(), which
simplifies it quite a bit.

v3: Convert to wait_event_interupttible_hrtimeout()
v2: Move finish_wait() call so we're not calling copy_to_user in
TASK_INTERRUPTIBLE state
v2: Restructure the code so we're not calling prepare_to_wait() until
after we've done everything that might block, also got rid of the
separate fast path

Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 fs/aio.c | 228 ++++++++++++++++++++++-----------------------------------------
 1 file changed, 78 insertions(+), 150 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index e0eb23d..06e1dd0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -63,7 +63,7 @@ struct aio_ring_info {
 	unsigned long		mmap_size;
 
 	struct page		**ring_pages;
-	spinlock_t		ring_lock;
+	struct mutex		ring_lock;
 	long			nr_pages;
 
 	unsigned		nr, tail;
@@ -341,7 +341,7 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	atomic_set(&ctx->users, 2);
 	atomic_set(&ctx->dead, 0);
 	spin_lock_init(&ctx->ctx_lock);
-	spin_lock_init(&ctx->ring_info.ring_lock);
+	mutex_init(&ctx->ring_info.ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
 	INIT_LIST_HEAD(&ctx->active_reqs);
@@ -744,187 +744,115 @@ put_rq:
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
+static int aio_read_events_ring(struct kioctx *ctx,
+				struct io_event __user *event, long nr)
 {
-	struct aio_ring_info *info = &ioctx->ring_info;
+	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
-	int ret = 0;
+	unsigned head, pos;
+	int ret = 0, copy_ret;
+
+	if (!mutex_trylock(&info->ring_lock)) {
+		__set_current_state(TASK_RUNNING);
+		mutex_lock(&info->ring_lock);
+	}
 
 	ring = kmap_atomic(info->ring_pages[0]);
-	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
+	head = ring->head;
+	kunmap_atomic(ring);
+
+	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
 
-	if (ring->head == ring->tail)
+	if (head == info->tail)
 		goto out;
 
-	spin_lock(&info->ring_lock);
-
-	head = ring->head % info->nr;
-	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head);
-		*ent = *evp;
-		head = (head + 1) % info->nr;
-		smp_mb(); /* finish reading the event before updatng the head */
-		ring->head = head;
-		ret = 1;
-		put_aio_ring_event(evp);
+	__set_current_state(TASK_RUNNING);
+
+	while (ret < nr) {
+		unsigned i = (head < info->tail ? info->tail : info->nr) - head;
+		struct io_event *ev;
+		struct page *page;
+
+		if (head == info->tail)
+			break;
+
+		i = min_t(int, i, nr - ret);
+		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
+			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+
+		pos = head + AIO_EVENTS_OFFSET;
+		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		pos %= AIO_EVENTS_PER_PAGE;
+
+		ev = kmap(page);
+		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
+		kunmap(page);
+
+		if (unlikely(copy_ret)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		ret += i;
+		head += i;
+		head %= info->nr;
 	}
-	spin_unlock(&info->ring_lock);
 
-out:
+	ring = kmap_atomic(info->ring_pages[0]);
+	ring->head = head;
 	kunmap_atomic(ring);
-	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
+
+	pr_debug("%d  h%u t%u\n", ret, head, info->tail);
+out:
+	mutex_unlock(&info->ring_lock);
+
 	return ret;
 }
 
-struct aio_timeout {
-	struct timer_list	timer;
-	int			timed_out;
-	struct task_struct	*p;
-};
-
-static void timeout_func(unsigned long data)
+static bool aio_read_events(struct kioctx *ctx, long min_nr, long nr,
+			    struct io_event __user *event, long *i)
 {
-	struct aio_timeout *to = (struct aio_timeout *)data;
+	long ret = aio_read_events_ring(ctx, event + *i, nr - *i);
 
-	to->timed_out = 1;
-	wake_up_process(to->p);
-}
+	if (ret > 0)
+		*i += ret;
 
-static inline void init_timeout(struct aio_timeout *to)
-{
-	setup_timer_on_stack(&to->timer, timeout_func, (unsigned long) to);
-	to->timed_out = 0;
-	to->p = current;
-}
+	if (unlikely(atomic_read(&ctx->dead)))
+		ret = -EINVAL;
 
-static inline void set_timeout(long start_jiffies, struct aio_timeout *to,
-			       const struct timespec *ts)
-{
-	to->timer.expires = start_jiffies + timespec_to_jiffies(ts);
-	if (time_after(to->timer.expires, jiffies))
-		add_timer(&to->timer);
-	else
-		to->timed_out = 1;
-}
+	if (!*i)
+		*i = ret;
 
-static inline void clear_timeout(struct aio_timeout *to)
-{
-	del_singleshot_timer_sync(&to->timer);
+	return ret < 0 || *i >= min_nr;
 }
 
-static int read_events(struct kioctx *ctx,
-			long min_nr, long nr,
+static long read_events(struct kioctx *ctx, long min_nr, long nr,
 			struct io_event __user *event,
 			struct timespec __user *timeout)
 {
-	long			start_jiffies = jiffies;
-	struct task_struct	*tsk = current;
-	DECLARE_WAITQUEUE(wait, tsk);
-	int			ret;
-	int			i = 0;
-	struct io_event		ent;
-	struct aio_timeout	to;
-
-	/* needed to zero any padding within an entry (there shouldn't be 
-	 * any, but C is fun!
-	 */
-	memset(&ent, 0, sizeof(ent));
-	ret = 0;
-	while (likely(i < nr)) {
-		ret = aio_read_evt(ctx, &ent);
-		if (unlikely(ret <= 0))
-			break;
-
-		pr_debug("%Lx %Lx %Lx %Lx\n",
-			 ent.data, ent.obj, ent.res, ent.res2);
-
-		/* Could we split the check in two? */
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			pr_debug("lost an event due to EFAULT.\n");
-			break;
-		}
-		ret = 0;
-
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
-	}
-
-	if (min_nr <= i)
-		return i;
-	if (ret)
-		return ret;
-
-	/* End fast path */
+	ktime_t until = { .tv64 = KTIME_MAX };
+	long ret = 0;
 
-	init_timeout(&to);
 	if (timeout) {
 		struct timespec	ts;
-		ret = -EFAULT;
+
 		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts))))
-			goto out;
+			return -EFAULT;
 
-		set_timeout(start_jiffies, &to, &ts);
+		until = timespec_to_ktime(ts);
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
-			if (unlikely(atomic_read(&ctx->dead))) {
-				ret = -EINVAL;
-				break;
-			}
-			if (to.timed_out)	/* Only check after read evt */
-				break;
-			/* Try to only show up in io wait if there are ops
-			 *  in flight */
-			if (atomic_read(&ctx->reqs_active))
-				io_schedule();
-			else
-				schedule();
-			if (signal_pending(tsk)) {
-				ret = -EINTR;
-				break;
-			}
-			/*ret = aio_read_evt(ctx, &ent);*/
-		} while (1) ;
-
-		set_task_state(tsk, TASK_RUNNING);
-		remove_wait_queue(&ctx->wait, &wait);
-
-		if (unlikely(ret <= 0))
-			break;
-
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			pr_debug("lost an event due to EFAULT.\n");
-			break;
-		}
+	wait_event_interruptible_hrtimeout(ctx->wait,
+			aio_read_events(ctx, min_nr, nr, event, &ret), until);
 
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
-	}
+	if (!ret && signal_pending(current))
+		ret = -EINTR;
 
-	if (timeout)
-		clear_timeout(&to);
-out:
-	destroy_timer_on_stack(&to.timer);
-	return i ? i : ret;
+	return ret;
 }
 
 /* sys_io_setup:
-- 
1.7.12

