Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab2K3AU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 19:20:59 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50876 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab2K3AU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 19:20:56 -0500
Date: Thu, 29 Nov 2012 16:20:52 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 14/25] aio: Make aio_read_evt() more efficient
Message-ID: <20121130002052.GM15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-15-git-send-email-koverstreet@google.com>
 <20121129003816.GJ18574@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129003816.GJ18574@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 04:38:16PM -0800, Zach Brown wrote:
> As mentioned offlist: we don't want to be blocking under
> TASK_INTERRUPTIBLE.  Is the plan to do a non-blocking check and pop
> outside the wait loop to do a blocking copy?

Here's the latest version that I posted on irc earlier:


commit 913ff32bbd4de15a87b07a87ac196e978bc29e17
Author: Kent Overstreet <koverstreet@google.com>
Date:   Thu Nov 29 14:12:40 2012 -0800

    aio: Make aio_read_evt() more efficient
    
    Previously, aio_read_event() pulled a single completion off the
    ringbuffer at a time, locking and unlocking each time.
    
    Changed it to pull off as many events as it can at a time, and copy them
    directly to userspace.
    
    This also fixes a bug where if copying the event to userspace failed,
    we'd lose the event.
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/fs/aio.c b/fs/aio.c
index 46e6d30..5eca2a4 100644
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
@@ -746,149 +746,138 @@ put_rq:
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
+			   long nr, unsigned *head)
 {
-	struct aio_ring_info *info = &ioctx->ring_info;
+	struct aio_ring_info *info = &ctx->ring_info;
 	struct aio_ring *ring;
-	unsigned long head;
-	int ret = 0;
+	unsigned pos;
+	int ret = 0, copy_ret;
 
-	ring = kmap_atomic(info->ring_pages[0]);
-	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
+	pr_debug("h%u t%u m%u\n", *head, info->tail, info->nr);
 
-	if (ring->head == ring->tail)
-		goto out;
+	while (ret < nr) {
+		unsigned i = (*head < info->tail ? info->tail : info->nr) - *head;
+		struct io_event *ev;
+		struct page *page;
+
+		if (*head == info->tail)
+			break;
+
+		i = min_t(int, i, nr - ret);
+		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
+			  ((*head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+
+		pos = *head + AIO_EVENTS_OFFSET;
+		page = info->ring_pages[pos / AIO_EVENTS_PER_PAGE];
+		pos %= AIO_EVENTS_PER_PAGE;
 
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
+		ev = kmap(page);
+		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
+		kunmap(page);
+
+		if (unlikely(copy_ret))
+			return -EFAULT;
+
+		ret += i;
+		*head += i;
+		*head %= info->nr;
 	}
-	spin_unlock(&info->ring_lock);
 
-out:
+	smp_mb(); /* finish reading the event before updating the head */
+
+	ring = kmap_atomic(info->ring_pages[0]);
+	ring->head = *head;
 	kunmap_atomic(ring);
-	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
+
+	pr_debug("%d  h%u t%u\n", ret, *head, info->tail);
+
 	return ret;
 }
 
 static int read_events(struct kioctx *ctx,
-			long min_nr, long nr,
-			struct io_event __user *event,
-			struct timespec __user *timeout)
+		       long min_nr, long nr,
+		       struct io_event __user *event,
+		       struct timespec __user *timeout)
 {
 	DEFINE_WAIT(wait);
+	struct aio_ring_info *info = &ctx->ring_info;
+	struct aio_ring *ring;
 	struct hrtimer_sleeper t;
+	unsigned head;
 	size_t i = 0;
-	int ret;
-	struct io_event		ent;
+	int ret = 0;
 
-	/* needed to zero any padding within an entry (there shouldn't be 
-	 * any, but C is fun!
-	 */
-	memset(&ent, 0, sizeof(ent));
-	ret = 0;
-	while (likely(i < nr)) {
-		ret = aio_read_evt(ctx, &ent);
-		if (unlikely(ret <= 0))
-			break;
+	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_init_sleeper(&t, current);
 
-		pr_debug("%Lx %Lx %Lx %Lx\n",
-			 ent.data, ent.obj, ent.res, ent.res2);
+	mutex_lock(&info->ring_lock);
 
-		/* Could we split the check in two? */
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			pr_debug("lost an event due to EFAULT.\n");
+	while (i < nr) {
+		ring = kmap_atomic(info->ring_pages[0]);
+		head = ring->head;
+		kunmap_atomic(ring);
+retry:
+		ret = aio_read_events(ctx, event + i, nr - i, &head);
+		if (ret < 0)
 			break;
-		}
-		ret = 0;
 
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
+		i += ret;
+		if (i >= min_nr)
+			break;
+		if (unlikely(atomic_read(&ctx->dead))) {
+			ret = -EINVAL;
+			break;
+		}
+		if (!t.task)	/* Only check after read evt */
+			break;
 
-	hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer_init_sleeper(&t, current);
+		if (timeout) {
+			struct timespec	ts;
 
-	if (timeout) {
-		struct timespec	ts;
+			if (unlikely(copy_from_user(&ts, timeout, sizeof(ts)))) {
+				ret = -EFAULT;
+				break;
+			}
 
-		if (unlikely(copy_from_user(&ts, timeout, sizeof(ts)))) {
-			ret = -EFAULT;
-			goto out;
+			timeout = NULL;
+			hrtimer_start_range_ns(&t.timer, timespec_to_ktime(ts),
+					       current->timer_slack_ns,
+					       HRTIMER_MODE_REL);
 		}
 
-		hrtimer_start_range_ns(&t.timer, timespec_to_ktime(ts),
-				       current->timer_slack_ns, HRTIMER_MODE_REL);
-	}
-
-	while (likely(i < nr)) {
 		prepare_to_wait_exclusive(&ctx->wait, &wait,
 					  TASK_INTERRUPTIBLE);
 
-		do {
-			ret = aio_read_evt(ctx, &ent);
-			if (ret)
-				break;
-			if (min_nr <= i)
-				break;
-			if (unlikely(atomic_read(&ctx->dead))) {
-				ret = -EINVAL;
-				break;
-			}
-			if (!t.task)	/* Only check after read evt */
-				break;
-			/* Try to only show up in io wait if there are ops
-			 *  in flight */
-			if (atomic_read(&ctx->reqs_active))
-				io_schedule();
-			else
-				schedule();
-			if (signal_pending(current)) {
-				ret = -EINTR;
-				break;
-			}
-			/*ret = aio_read_evt(ctx, &ent);*/
-		} while (1) ;
+		if (head != info->tail) {
+			__set_current_state(TASK_RUNNING);
+			goto retry;
+		}
 
-		finish_wait(&ctx->wait, &wait);
+		mutex_unlock(&info->ring_lock);
 
-		if (unlikely(ret <= 0))
-			break;
+		/* Try to only show up in io wait if there are ops in flight */
+		if (atomic_read(&ctx->reqs_active))
+			io_schedule();
+		else
+			schedule();
 
-		ret = -EFAULT;
-		if (unlikely(copy_to_user(event, &ent, sizeof(ent)))) {
-			pr_debug("lost an event due to EFAULT.\n");
-			break;
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
 		}
 
-		/* Good, event copied to userland, update counts. */
-		event ++;
-		i ++;
+		__set_current_state(TASK_RUNNING);
+		mutex_lock(&info->ring_lock);
 	}
+
+	mutex_unlock(&info->ring_lock);
 out:
+	finish_wait(&ctx->wait, &wait);
 	hrtimer_cancel(&t.timer);
 	destroy_hrtimer_on_stack(&t.timer);
 	return i ? i : ret;
