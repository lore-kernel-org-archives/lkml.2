Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3AHA20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 19:28:26 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36146 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3AHA2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 19:28:24 -0500
Date: Mon, 7 Jan 2013 16:28:21 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 14/32] aio: Make aio_read_evt() more efficient, convert
 to hrtimers
Message-ID: <20130108002821.GM26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-16-git-send-email-koverstreet@google.com>
 <20130103151920.ae731c2c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103151920.ae731c2c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:19:20PM -0800, Andrew Morton wrote:
> On Wed, 26 Dec 2012 17:59:52 -0800
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > Previously, aio_read_event() pulled a single completion off the
> > ringbuffer at a time, locking and unlocking each time.  Changed it to
> > pull off as many events as it can at a time, and copy them directly to
> > userspace.
> > 
> > This also fixes a bug where if copying the event to userspace failed,
> > we'd lose the event.
> > 
> > Also convert it to wait_event_interruptible_hrtimeout(), which
> > simplifies it quite a bit.
> > 
> > ...
> >
> > -static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
> > +static int aio_read_events_ring(struct kioctx *ctx,
> > +				struct io_event __user *event, long nr)
> >  {
> > -	struct aio_ring_info *info = &ioctx->ring_info;
> > +	struct aio_ring_info *info = &ctx->ring_info;
> >  	struct aio_ring *ring;
> > -	unsigned long head;
> > -	int ret = 0;
> > +	unsigned head, pos;
> > +	int ret = 0, copy_ret;
> > +
> > +	if (!mutex_trylock(&info->ring_lock)) {
> > +		__set_current_state(TASK_RUNNING);
> > +		mutex_lock(&info->ring_lock);
> > +	}
> 
> You're not big on showing your homework, I see :(

No :(

> I agree that calling mutex_lock() in state TASK_[UN]INTERRUPTIBLE is at
> least poor practice.  Assuming this is what the code is trying to do. 
> But if aio_read_events_ring() is indeed called in state
> TASK_[UN]INTERRUPTIBLE then the effect of the above code is to put the
> task into an *unknown* state.

So - yes, aio_read_events_ring() is called after calling
prepare_to_wait(TASK_INTERRUPTIBLE).

The problem is that lock kind of has to be a mutex, because it's got to
call copy_to_user() under it, and it's got to take the lock to check
whether it needs to sleep (i.e. after putting itself on the waitlist).

Though - (correct me if I'm wrong) the task state is not now unknown,
it's either unchanged (still TASK_INTERRUPTIBLE) or TASK_RUNNING. So
it'll get to the schedule() part of the wait_event() loop in
TASK_RUNNING state, but AFAIK that should be ok... just perhaps less
than ideal.

However - I was told that calling mutex_lock() in TASK_INTERRUPTIBLE
state was bad, but thinking about it more I'm not seeing how that's the
case. Either mutex_lock() finds the lock uncontended and doesn't touch
the task state, or it does and leaves it in TASK_RUNNING when it
returns.

IOW, I don't see how it'd behave any differently from what I'd doing.

Any light you could shed would be most appreciated.

> IOW, I don't have the foggiest clue what you're trying to do here and
> you owe us all a code comment.  At least.

Yeah, will do.

> >  	ring = kmap_atomic(info->ring_pages[0]);
> > -	pr_debug("h%u t%u m%u\n", ring->head, ring->tail, ring->nr);
> > +	head = ring->head;
> > +	kunmap_atomic(ring);
> > +
> > +	pr_debug("h%u t%u m%u\n", head, info->tail, info->nr);
> >  
> > -	if (ring->head == ring->tail)
> > +	if (head == info->tail)
> >  		goto out;
> >  
> > -	spin_lock(&info->ring_lock);
> > -
> > -	head = ring->head % info->nr;
> > -	if (head != ring->tail) {
> > -		struct io_event *evp = aio_ring_event(info, head);
> > -		*ent = *evp;
> > -		head = (head + 1) % info->nr;
> > -		smp_mb(); /* finish reading the event before updatng the head */
> > -		ring->head = head;
> > -		ret = 1;
> > -		put_aio_ring_event(evp);
> > +	__set_current_state(TASK_RUNNING);
> > +
> > +	while (ret < nr) {
> > +		unsigned i = (head < info->tail ? info->tail : info->nr) - head;
> > +		struct io_event *ev;
> > +		struct page *page;
> > +
> > +		if (head == info->tail)
> > +			break;
> > +
> > +		i = min_t(int, i, nr - ret);
> > +		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
> > +			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
> 
> min_t() is kernel shorthand for "I screwed up my types".  Methinks
> `ret' should have long type.  Or, better, unsigned (negative makes no
> sense).  And when a C programmer sees an variable called "i" he thinks
> it has type "int", so that guy should be renamed.

Ret's got to be signed, because it can return an error. But yes, it
should definitely be long.

> Can we please clean all this up?

This look better for the types?

commit 8d5788d5542b7f4c57b8e1470650c772cb8fea81
Author: Kent Overstreet <koverstreet@google.com>
Date:   Mon Jan 7 16:24:42 2013 -0800

    aio: Fix aio_read_events_ring() types
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/fs/aio.c b/fs/aio.c
index 4033ebb..21b2c27 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -837,12 +837,13 @@ EXPORT_SYMBOL(aio_complete_batch);
  *	Pull an event off of the ioctx's event ring.  Returns the number of
  *	events fetched
  */
-static int aio_read_events_ring(struct kioctx *ctx,
-				struct io_event __user *event, long nr)
+static long aio_read_events_ring(struct kioctx *ctx,
+				 struct io_event __user *event, long nr)
 {
 	struct aio_ring *ring;
 	unsigned head, pos;
-	int ret = 0, copy_ret;
+	long ret = 0;
+	int copy_ret;
 
 	if (!mutex_trylock(&ctx->ring_lock)) {
 		__set_current_state(TASK_RUNNING);
@@ -861,23 +862,24 @@ static int aio_read_events_ring(struct kioctx *ctx,
 	__set_current_state(TASK_RUNNING);
 
 	while (ret < nr) {
-		unsigned i = (head < ctx->shadow_tail ? ctx->shadow_tail : ctx->nr) - head;
+		long avail = (head < ctx->shadow_tail
+			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
 
 		if (head == ctx->shadow_tail)
 			break;
 
-		i = min_t(int, i, nr - ret);
-		i = min_t(int, i, AIO_EVENTS_PER_PAGE -
-			  ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
+		avail = min(avail, nr - ret);
+		avail = min_t(long, avail, AIO_EVENTS_PER_PAGE -
+			      ((head + AIO_EVENTS_OFFSET) % AIO_EVENTS_PER_PAGE));
 
 		pos = head + AIO_EVENTS_OFFSET;
 		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
 		pos %= AIO_EVENTS_PER_PAGE;
 
 		ev = kmap(page);
-		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * i);
+		copy_ret = copy_to_user(event + ret, ev + pos, sizeof(*ev) * avail);
 		kunmap(page);
 
 		if (unlikely(copy_ret)) {
@@ -885,8 +887,8 @@ static int aio_read_events_ring(struct kioctx *ctx,
 			goto out;
 		}
 
-		ret += i;
-		head += i;
+		ret += avail;
+		head += avail;
 		head %= ctx->nr;
 	}
 
@@ -895,7 +897,7 @@ static int aio_read_events_ring(struct kioctx *ctx,
 	kunmap_atomic(ring);
 	flush_dcache_page(ctx->ring_pages[0]);
 
-	pr_debug("%d  h%u t%u\n", ret, head, ctx->shadow_tail);
+	pr_debug("%li  h%u t%u\n", ret, head, ctx->shadow_tail);
 
 	put_reqs_available(ctx, ret);
 out:
