Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab1ARXwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:52:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:58479 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1ARXwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:52:38 -0500
Date: Wed, 19 Jan 2011 00:52:36 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
Message-ID: <20110118235236.GA14087@quack.suse.cz>
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
 <x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
 <AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
 <x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
 <20110118190114.GA5070@quack.suse.cz>
 <AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-01-11 09:17:23, Nick Piggin wrote:
> On Wed, Jan 19, 2011 at 6:01 AM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 18-01-11 10:24:24, Nick Piggin wrote:
> >> On Tue, Jan 18, 2011 at 6:07 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >> > Nick Piggin <npiggin@gmail.com> writes:
> >> >> Do you agree with the theoretical problem? I didn't try to
> >> >> write a racer to break it yet. Inserting a delay before the
> >> >> get_ioctx might do the trick.
> >> >
> >> > I'm not convinced, no.  The last reference to the kioctx is always the
> >> > process, released in the exit_aio path, or via sys_io_destroy.  In both
> >> > cases, we cancel all aios, then wait for them all to complete before
> >> > dropping the final reference to the context.
> >>
> >> That wouldn't appear to prevent a concurrent thread from doing an
> >> io operation that requires ioctx lookup, and taking the last reference
> >> after the io_cancel thread drops the ref.
> >>
> >> > So, while I agree that what you wrote is better, I remain unconvinced of
> >> > it solving a real-world problem.  Feel free to push it in as a cleanup,
> >> > though.
> >>
> >> Well I think it has to be technically correct first. If there is indeed a
> >> guaranteed ref somehow, it just needs a comment.
> >  Hmm, the code in io_destroy() indeed looks fishy. We delete the ioctx
> > from the hash table and set ioctx->dead which is supposed to stop
> > lookup_ioctx() from finding it (see the !ctx->dead check in
> > lookup_ioctx()). There's even a comment in io_destroy() saying:
> >        /*
> >         * Wake up any waiters.  The setting of ctx->dead must be seen
> >         * by other CPUs at this point.  Right now, we rely on the
> >         * locking done by the above calls to ensure this consistency.
> >         */
> > But since lookup_ioctx() is called without any lock or barrier nothing
> > really seems to prevent the list traversal and ioctx->dead test to happen
> > before io_destroy() and get_ioctx() after io_destroy().
> >
> > But wouldn't the right fix be to call synchronize_rcu() in io_destroy()?
> > Because with your fix we could still return 'dead' ioctx and I don't think
> > we are supposed to do that...
> 
> With my fix we won't oops, I was a bit concerned about ->dead,
> yes but I don't know what semantics it is attempted to have there.
  But wouldn't it do something bad if the memory gets reallocated for
something else and set to non-zero? E.g. memory corruption?

> synchronize_rcu() in io_destroy()  does not prevent it from returning
> as soon as lookup_ioctx drops the rcu_read_lock().
  Yes, exactly. So references obtained before synchronize_rcu() would be
completely fine and valid references and there would be no references after
synchronize_rcu() because they'd see 'dead' set. But looking at the code
again it still would not be enough because we could still race with
io_submit_one() adding new IO to the ioctx which will be freed just after
put_ioctx() in do_io_submit().

The patch below implements what I have in mind - it should be probably
split into two but I'd like to hear comments on that before doing these
cosmetic touches ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 7a662553a44db06381d405a76426855b5507c61d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 19 Jan 2011 00:37:48 +0100
Subject: [PATCH] fs: Fix ioctx lookup races with io_destroy() in AIO

AIO code doesn't implement the rcu lookup pattern properly.
rcu_read_lock in lookup_ioctx() does not prevent refcount
going to zero, so we might take a refcount on a zero count
(possibly already freed) ioctx:

 CPU1						CPU2
lookup_ioctx()
  hlist_for_each_entry_rcu()
    if (ctx->user_id == ctx_id && !ctx->dead)
						io_destroy()
						  free ioctx
      get_ioctx(ctx);
      and return freed memory to innocent caller

Close this race by calling synchronize_rcu() in io_destroy().

Another race occurs when io_submit() races with io_destroy():

 CPU1						CPU2
io_submit()
  do_io_submit()
    ...
    ctx = lookup_ioctx(ctx_id);
						io_destroy()
    Now do_io_submit() holds the last reference to ctx.
    ...
    queue new AIO
    put_ioctx(ctx) - frees ctx with active AIOs

We solve this issue by checking whether ctx is being destroyed
in AIO submission path after adding new AIO to ctx. Then we
are guaranteed that either io_destroy() waits for new AIO or
we see that ctx is being destroyed and bail out.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/aio.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8c8f6c5..59ac692 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1225,6 +1225,17 @@ static void io_destroy(struct kioctx *ioctx)
 	if (likely(!was_dead))
 		put_ioctx(ioctx);	/* twice for the list */
 
+	/*
+	 * After this ioctx cannot be looked up because ioctx->dead is set.
+	 * But there could be still io_submit() running...
+	 */
+	synchronize_rcu();
+
+	/*
+	 * ... but once these functions finish, the io has been either
+	 * cancelled (if aio_get_req() has already run) or the ctx->dead
+	 * check in io_submit_one() triggers and no io is submitted.
+	 */
 	aio_cancel_all(ioctx);
 	wait_for_all_aios(ioctx);
 
@@ -1646,6 +1657,16 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		goto out_put_req;
 
 	spin_lock_irq(&ctx->ctx_lock);
+	/*
+	 * Raced with io_destroy()? See comments in io_destroy() for details.
+	 * The check is inside ctx->ctx_lock to avoid extra memory barrier
+	 * in this fast path...
+	 */
+	if (ctx->dead) {
+		spin_unlock_irq(&ctx->ctx_lock);
+		ret = -EINVAL;
+		goto out_put_req;
+	}
 	aio_run_iocb(req);
 	if (!list_empty(&ctx->run_list)) {
 		/* drain the run list */
-- 
1.7.1

