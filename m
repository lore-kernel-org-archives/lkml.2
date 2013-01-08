Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3AHBA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:00:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3AHBA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:00:57 -0500
Date: Mon, 7 Jan 2013 17:00:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 14/32] aio: Make aio_read_evt() more efficient, convert
 to hrtimers
Message-Id: <20130107170055.aec2b6f0.akpm@linux-foundation.org>
In-Reply-To: <20130108002821.GM26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-16-git-send-email-koverstreet@google.com>
	<20130103151920.ae731c2c.akpm@linux-foundation.org>
	<20130108002821.GM26407@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013 16:28:21 -0800
Kent Overstreet <koverstreet@google.com> wrote:

> On Thu, Jan 03, 2013 at 03:19:20PM -0800, Andrew Morton wrote:
> > On Wed, 26 Dec 2012 17:59:52 -0800
> > Kent Overstreet <koverstreet@google.com> wrote:
> > 
> > > Previously, aio_read_event() pulled a single completion off the
> > > ringbuffer at a time, locking and unlocking each time.  Changed it to
> > > pull off as many events as it can at a time, and copy them directly to
> > > userspace.
> > > 
> > > This also fixes a bug where if copying the event to userspace failed,
> > > we'd lose the event.
> > > 
> > > Also convert it to wait_event_interruptible_hrtimeout(), which
> > > simplifies it quite a bit.
> > > 
> > > ...
> > >
> > > -static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
> > > +static int aio_read_events_ring(struct kioctx *ctx,
> > > +				struct io_event __user *event, long nr)
> > >  {
> > > -	struct aio_ring_info *info = &ioctx->ring_info;
> > > +	struct aio_ring_info *info = &ctx->ring_info;
> > >  	struct aio_ring *ring;
> > > -	unsigned long head;
> > > -	int ret = 0;
> > > +	unsigned head, pos;
> > > +	int ret = 0, copy_ret;
> > > +
> > > +	if (!mutex_trylock(&info->ring_lock)) {
> > > +		__set_current_state(TASK_RUNNING);
> > > +		mutex_lock(&info->ring_lock);
> > > +	}
> > 
> > You're not big on showing your homework, I see :(
> 
> No :(

Am still awaiting the patch which explains to people what the above
code is doing!

> > I agree that calling mutex_lock() in state TASK_[UN]INTERRUPTIBLE is at
> > least poor practice.  Assuming this is what the code is trying to do. 
> > But if aio_read_events_ring() is indeed called in state
> > TASK_[UN]INTERRUPTIBLE then the effect of the above code is to put the
> > task into an *unknown* state.
> 
> So - yes, aio_read_events_ring() is called after calling
> prepare_to_wait(TASK_INTERRUPTIBLE).
> 
> The problem is that lock kind of has to be a mutex, because it's got to
> call copy_to_user() under it, and it's got to take the lock to check
> whether it needs to sleep (i.e. after putting itself on the waitlist).
> 
> Though - (correct me if I'm wrong) the task state is not now unknown,
> it's either unchanged (still TASK_INTERRUPTIBLE) or TASK_RUNNING.

I call that "unknown" :)

> So
> it'll get to the schedule() part of the wait_event() loop in
> TASK_RUNNING state, but AFAIK that should be ok... just perhaps less
> than ideal.

aio_read_events_ring() is called via the
wait_event_interruptible_hrtimeout() macro's call to `condition' - to
work out whether aio_read_events_ring() should terminate.

A problem we should think about is "under what circumstances will
aio_read_events_ring() set us into TASK_RUNNING?".  We don't want
aio_read_events_ring() to do this too often because it will cause
schedule() to fall through and we end up in a busy loop, chewing CPU. 

afacit, aio_read_events_ring() will usually return non-zero if it
flipped us into TASK_RUNNING state.  An exception is where the
mutex_trylock() failed, in which case the thread slept in mutex_lock(),
whcih will help with the CPU-chewing.  But aio_read_events_ring() can
then end up returning 0 but in state TASK_RUNNING which will cause a
small cpu-chew in wait_event_interruptible_hrtimeout().

I think :( It is unfortunately complex and it would be nice to make
this dynamic behaviour more clear and solid.  Or at least documented! 
Explain how this code avoid getting stuck in a cpu-burning loop.  To
help prevent people from causing a cpu-burning loop when they later
change the code.

> However - I was told that calling mutex_lock() in TASK_INTERRUPTIBLE
> state was bad, but thinking about it more I'm not seeing how that's the
> case. Either mutex_lock() finds the lock uncontended and doesn't touch
> the task state, or it does and leaves it in TASK_RUNNING when it
> returns.
> 
> IOW, I don't see how it'd behave any differently from what I'd doing.
> 
> Any light you could shed would be most appreciated.

Well, the problem with running mutex_lock() in TASK_[UN]INTERRUPTIBLE
is just that: it may or may not flip you into TASK_RUNNING, so what the
heck is the caller thinking of?  It's strange to set the task state a
particular way, then call a function which will randomly go and undo
that.

The cause of all this is the wish to use a wait_event `condition'
predicate which must take a mutex.  hrm.

> > IOW, I don't have the foggiest clue what you're trying to do here and
> > you owe us all a code comment.  At least.
> 
> Yeah, will do.

Excited!

> This look better for the types?

yup.


Also, it's unclear why kioctx.shadow_tail exists.  Some overviewy
explanation at its definitions site is needed, IMO.

