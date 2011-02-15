Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1BOTdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 14:33:24 -0500
Received: from cantor.suse.de ([195.135.220.2]:54664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab1BOTdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 14:33:21 -0500
Date: Tue, 15 Feb 2011 20:33:16 +0100
From: Jan Kara <jack@suse.cz>
To: Milton Miller <miltonm@bga.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [2/2] fs: Fix race between io_destroy() and io_submit() in AIO
Message-ID: <20110215193316.GN17313@quack.suse.cz>
References: <1297774764-32731-3-git-send-email-jack@suse.cz>
 <aio-locking-comment@mdm.bga.com>
 <20110215171616.GJ17313@quack.suse.cz>
 <aio-locking-jan-reply@mdm.bga.com>
 <20110215191514.GM17313@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215191514.GM17313@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 15-02-11 20:15:14, Jan Kara wrote:
> On Tue 15-02-11 12:50:32, Milton Miller wrote:
> > On Tue, 15 Feb 2011 about 11:16:16 -0600, Jan Kara wrote:
> > > On Tue 15-02-11 12:59:24, Milton Miller wrote:
> > > > > A race can occur when io_submit() races with io_destroy():
> > > > > 
> > > > >  CPU1						CPU2
> > > > > io_submit()
> > > > >   do_io_submit()
> > > > >     ...
> > > > >     ctx = lookup_ioctx(ctx_id);
> > > > > 						io_destroy()
> > > > >     Now do_io_submit() holds the last reference to ctx.
> > > > >     ...
> > > > >     queue new AIO
> > > > >     put_ioctx(ctx) - frees ctx with active AIOs
> > > > > 
> > > > > We solve this issue by checking whether ctx is being destroyed
> > > > > in AIO submission path after adding new AIO to ctx. Then we
> > > > > are guaranteed that either io_destroy() waits for new AIO or
> > > > > we see that ctx is being destroyed and bail out.
> > > > > 
> > > > > Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> > > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > > > CC: Nick Piggin <npiggin@kernel.dk>
> > > > > 
> > > > > ---
> > > > > fs/aio.c |   15 +++++++++++++++
> > > > >  1 files changed, 15 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/fs/aio.c b/fs/aio.c
> > > > > index b4dd668..0244c04 100644
> > > > > --- a/fs/aio.c
> > > > > +++ b/fs/aio.c
> > > > > @@ -1642,6 +1642,21 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
> > > > >  		goto out_put_req;
> > > > >  
> > > > >  	spin_lock_irq(&ctx->ctx_lock);
> > > > > +	/*
> > > > > +	 * We could have raced with io_destroy() and are currently holding a
> > > > > +	 * reference to ctx which should be destroyed. We cannot submit IO
> > > > > +	 * since ctx gets freed as soon as io_submit() puts its reference.
> > > > > +	 * The check here is reliable since io_destroy() sets ctx->dead before
> > > > > +	 * waiting for outstanding IO. Thus if we don't see ctx->dead set here,
> > > > > +	 * io_destroy() waits for our IO to finish.
> > > > > +	 * The check is inside ctx->ctx_lock to avoid extra memory barrier
> > > > > +	 * in this fast path...
> > > > > +	 */
> > > > 
> > > > When reading this comment, and with all of the recient discussions I
> > > > had with Paul in the smp ipi thread (especially with resepect to third
> > > > party writes), I looked to see that the spinlock was paired with the
> > > > spinlock to set dead in io_destroy.  It is not.   It took me some time
> > > > to find that the paired lock is actually in wait_for_all_aios.  Also,
> > > > dead is also set in aio_cancel_all which is under the same spinlock.
> > > > 
> > > > Please update this lack of memory barrier comment to reflect the locking.
> > 
> > This locking description is wrong:
> > 
> > >   Hum, sorry but I don't understand. The above message wants to say that
> > > io_destroy() does
> > >   ctx->dead = 1
> > >   barrier (implied by a spin_unlock)
> > 
> > no spin_unlock only does a release barrier.
> > 
> > >   wait for reqs_active to get to 0
> > 
> > This read can move up into the spinlocked region (up to the lock acquire).
> > 
> > > 
> > > while io_submit() does
> > >   increment reqs_active
> > >   barrier (implied by a spin_lock - on a different lock but that does not
> > > matter as we only need the barrier semantics)
> > 
> > No only an acquire barrier, old writes can move into the spinlock region
> > 
> > >   check ctx->dead
> > 
> > the increment can move down past this check to the unlock here.
>   Ah OK, you're right. I was typing too fast and thinking too slow ;).
> 
> > > So if io_submit() gets past ctx->dead check, io_destroy() will certainly
> > > wait for our reference in reqs_active to be released.
> > > 
> > > I don't see any lock pairing needed here... But maybe I miss something.
> > > 
> > > 								Honza
> > 
> > spin lock and unlock are only half barriers as described in 
> > Documentation/memory-barriers.txt
> > 
> > 
> > Now, as I said, the code is ok because the active count is read and
> > written under ctx->ctx_lock, and aio_cancel_all sets dead under
> > that lock.
> > 
> > But the comment needs to reflect that and not just the the code is
> > under in some random spin_lock region instead of a memory barrier,
> > which is not sufficient.   Bad lock descriptions leads to making bad
> > code in the future, either through copying it to another context or
> > though future work removing the additional constraints not mentioned.
> > 
> > So please, comment which locks are being used here, as what
> > you described is not enough.
>   Yep, I'll improve the comment. Thanks for explanation.
  Do you like this comment better?
      /*
       * We could have raced with io_destroy() and are currently holding a
       * reference to ctx which should be destroyed. We cannot submit IO
       * since ctx gets freed as soon as io_submit() puts its reference.  The
       * check here is reliable: io_destroy() sets ctx->dead before waiting
       * for outstanding IO and the barrier between these two is realized by
       * unlock of mm->ioctx_lock and lock of ctx->ctx_lock.  Analogously we
       * increment ctx->reqs_active before checking for ctx->dead and the
       * barrier is realized by unlock and lock of ctx->ctx_lock. Thus if we
       * don't see ctx->dead set here, io_destroy() waits for our IO to
       * finish.
       */


								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
