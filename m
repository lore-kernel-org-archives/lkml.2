Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3AHB2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:28:19 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34110 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab3AHB2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:28:17 -0500
Date: Mon, 7 Jan 2013 17:28:13 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 14/32] aio: Make aio_read_evt() more efficient, convert
 to hrtimers
Message-ID: <20130108012813.GO26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-16-git-send-email-koverstreet@google.com>
 <20130103151920.ae731c2c.akpm@linux-foundation.org>
 <20130108002821.GM26407@google.com>
 <20130107170055.aec2b6f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107170055.aec2b6f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 05:00:55PM -0800, Andrew Morton wrote:
> aio_read_events_ring() is called via the
> wait_event_interruptible_hrtimeout() macro's call to `condition' - to
> work out whether aio_read_events_ring() should terminate.
> 
> A problem we should think about is "under what circumstances will
> aio_read_events_ring() set us into TASK_RUNNING?".  We don't want
> aio_read_events_ring() to do this too often because it will cause
> schedule() to fall through and we end up in a busy loop, chewing CPU. 
> 
> afacit, aio_read_events_ring() will usually return non-zero if it
> flipped us into TASK_RUNNING state.  An exception is where the
> mutex_trylock() failed, in which case the thread slept in mutex_lock(),
> whcih will help with the CPU-chewing.  But aio_read_events_ring() can
> then end up returning 0 but in state TASK_RUNNING which will cause a
> small cpu-chew in wait_event_interruptible_hrtimeout().

Yeah, that was my reasoning too.

> I think :( It is unfortunately complex and it would be nice to make
> this dynamic behaviour more clear and solid.  Or at least documented! 
> Explain how this code avoid getting stuck in a cpu-burning loop.  To
> help prevent people from causing a cpu-burning loop when they later
> change the code.

*nods*

> > However - I was told that calling mutex_lock() in TASK_INTERRUPTIBLE
> > state was bad, but thinking about it more I'm not seeing how that's the
> > case. Either mutex_lock() finds the lock uncontended and doesn't touch
> > the task state, or it does and leaves it in TASK_RUNNING when it
> > returns.
> > 
> > IOW, I don't see how it'd behave any differently from what I'd doing.
> > 
> > Any light you could shed would be most appreciated.
> 
> Well, the problem with running mutex_lock() in TASK_[UN]INTERRUPTIBLE
> is just that: it may or may not flip you into TASK_RUNNING, so what the
> heck is the caller thinking of?  It's strange to set the task state a
> particular way, then call a function which will randomly go and undo
> that.
> 
> The cause of all this is the wish to use a wait_event `condition'
> predicate which must take a mutex.  hrm.

I've run into this problem before, and I've yet to come up with a
satisfactory solution. What we kind of want is just pthreads style
condition variables. Or something. I'm surprised this doesn't come up
more often.

But, this code has been through like 5 iterations (with Zach Brown
picking most of them apart) and I think this is the best we've come up
with. Trying to get the task state stuff exactly right led to it being
_much_ more contorted, I think.

Does the patch below help?


> 
> > > IOW, I don't have the foggiest clue what you're trying to do here and
> > > you owe us all a code comment.  At least.
> > 
> > Yeah, will do.
> 
> Excited!
> 
> > This look better for the types?
> 
> yup.
> 
> 
> Also, it's unclear why kioctx.shadow_tail exists.  Some overviewy
> explanation at its definitions site is needed, IMO.

Ah, that's mostly just to reduce cacheline bouncing - in practice the
tail pointer that aio_complete() uses tends to be a lot more contended
than the head pointer, since events get delivered one at a time and then
pulled off all at once. So aio_complete() keeps it up to date and then
aio_read_events() doesn't have to compete for the tail cacheline.


commit ab92ba18a0a891821edd967c46dc988326ef6bb0
Author: Kent Overstreet <koverstreet@google.com>
Date:   Mon Jan 7 17:27:19 2013 -0800

    aio: Document, clarify aio_read_events() and shadow_tail
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/fs/aio.c b/fs/aio.c
index 21b2c27..932170a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -102,6 +102,19 @@ struct kioctx {
 	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
+
+		/*
+		 * Copy of the real tail, that aio_complete uses - to reduce
+		 * cacheline bouncing. The real tail will tend to be much more
+		 * contended - since typically events are delivered one at a
+		 * time, and then aio_read_events() slurps them up a bunch at a
+		 * time - so it's helpful if aio_read_events() isn't also
+		 * contending for the tail. So, aio_complete() updates
+		 * shadow_tail whenever it updates tail.
+		 *
+		 * Also needed because tail is used as a hacky lock and isn't
+		 * always the real tail.
+		 */
 		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
@@ -845,10 +858,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	long ret = 0;
 	int copy_ret;
 
-	if (!mutex_trylock(&ctx->ring_lock)) {
-		__set_current_state(TASK_RUNNING);
-		mutex_lock(&ctx->ring_lock);
-	}
+	mutex_lock(&ctx->ring_lock);
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
@@ -859,8 +869,6 @@ static long aio_read_events_ring(struct kioctx *ctx,
 	if (head == ctx->shadow_tail)
 		goto out;
 
-	__set_current_state(TASK_RUNNING);
-
 	while (ret < nr) {
 		long avail = (head < ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
@@ -939,6 +947,20 @@ static long read_events(struct kioctx *ctx, long min_nr, long nr,
 		until = timespec_to_ktime(ts);
 	}
 
+	/*
+	 * Note that aio_read_events() is being called as the conditional - i.e.
+	 * we're calling it after prepare_to_wait() has set task state to
+	 * TASK_INTERRUPTIBLE.
+	 *
+	 * But aio_read_events() can block, and if it blocks it's going to flip
+	 * the task state back to TASK_RUNNING.
+	 *
+	 * This should be ok, provided it doesn't flip the state back to
+	 * TASK_RUNNING and return 0 too much - that causes us to spin. That
+	 * will only happen if the mutex_lock() call blocks, and we then find
+	 * the ringbuffer empty. So in practice we should be ok, but it's
+	 * something to be aware of when touching this code.
+	 */
 	wait_event_interruptible_hrtimeout(ctx->wait,
 			aio_read_events(ctx, min_nr, nr, event, &ret), until);
 
