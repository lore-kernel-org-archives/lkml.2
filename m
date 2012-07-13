Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab2GMMd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:33:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab2GMMdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:33:20 -0400
Date: Fri, 13 Jul 2012 14:33:18 +0200
From: Jan Kara <jack@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
Message-ID: <20120713123318.GB20361@quack.suse.cz>
References: <20120711133735.GA8122@quack.suse.cz>
 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
 <20120711201601.GB9779@quack.suse.cz>
 <alpine.LFD.2.02.1207121552111.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207121552111.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-07-12 16:15:29, Thomas Gleixner wrote:
> On Wed, 11 Jul 2012, Jan Kara wrote:
> > On Wed 11-07-12 12:05:51, Jeff Moyer wrote:
> > > Jan Kara <jack@suse.cz> writes:
> > > 
> > > >   Hello,
> > > >
> > > >   we've recently hit a deadlock in our QA runs which is caused by the
> > > > per-process plugging code. The problem is as follows:
> > > >   process A					process B (kjournald)
> > > >   generic_file_aio_write()
> > > >     blk_start_plug(&plug);
> > > >     ...
> > > >     somewhere in here we allocate memory and
> > > >     direct reclaim submits buffer X for IO
> > > >     ...
> > > >     ext3_write_begin()
> > > >       ext3_journal_start()
> > > >         we need more space in a journal
> > > >         so we want to checkpoint old transactions,
> > > >         we block waiting for kjournald to commit
> > > >         a currently running transaction.
> > > > 						journal_commit_transaction()
> > > > 						  wait for IO on buffer X
> > > > 						  to complete as it is part
> > > > 						  of the current transaction
> > > >
> > > >   => deadlock since A waits for B and B waits for A to do unplug.
> > > > BTW: I don't think this is really ext3/ext4 specific. I think other
> > > > filesystems can get into problems as well when direct reclaim submits some
> > > > IO and the process subsequently blocks without submitting the IO.
> > > 
> > > So, I thought schedule would do the flush.  Checking the code:
> > > 
> > > asmlinkage void __sched schedule(void)
> > > {
> > >         struct task_struct *tsk = current;
> > > 
> > >         sched_submit_work(tsk);
> > >         __schedule();
> > > }
> > > 
> > > And sched_submit_work looks like this:
> > > 
> > > static inline void sched_submit_work(struct task_struct *tsk)
> > > {
> > >         if (!tsk->state || tsk_is_pi_blocked(tsk))
> > >                 return;
> > >         /*
> > >          * If we are going to sleep and we have plugged IO queued,
> > >          * make sure to submit it to avoid deadlocks.
> > >          */
> > >         if (blk_needs_flush_plug(tsk))
> > >                 blk_schedule_flush_plug(tsk);
> > > }
> > > 
> > > This eventually ends in a call to blk_run_queue_async(q) after
> > > submitting the I/O from the plug list.  Right?  So is the question
> > > really why doesn't the kblockd workqueue get scheduled?
> 
> >   Ah, I didn't know this. Thanks for the hint. So in the kdump I have I can
> > see requests queued in tsk->plug despite the process is sleeping in
> > TASK_UNINTERRUPTIBLE state.  So the only way how unplug could have been
> > omitted is if tsk_is_pi_blocked() was true. Rummaging through the dump...
> > indeed task has pi_blocked_on = 0xffff8802717d79c8. The dump is from an -rt
> > kernel (I just didn't originally thought that makes any difference) so
> > actually any mutex is rtmutex and thus tsk_is_pi_blocked() is true whenever
> > we are sleeping on a mutex. So this seems like a bug in rtmutex code.
> 
> Well, the reason why this check is there is that the task which is
> blocked on a lock can hold another lock which might cause a deadlock
> in the flush path.
  OK. Let me understand the details. Block layer needs just queue_lock for
unplug to succeed. That is a spinlock but in RT kernel, even a process
holding a spinlock can be preempted if I remember correctly. So that
condition is there effectively to not unplug when a task is being scheduled
away while holding queue_lock? Did I get it right?

> > Thomas, you seemed to have added that condition... Any idea how to avoid
> > the deadlock?
> 
> Good question. We could do the flush when the blocked task does not
> hold a lock itself. Might be worth a try.
  Yeah, that should work for avoiding the deadlock as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
