Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2GLCHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:07:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab2GLCHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:07:16 -0400
Message-ID: <1342058827.7338.5.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, mgalbraith@suse.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 12 Jul 2012 04:07:07 +0200
In-Reply-To: <20120711201601.GB9779@quack.suse.cz>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 22:16 +0200, Jan Kara wrote: 
> On Wed 11-07-12 12:05:51, Jeff Moyer wrote:
> > Jan Kara <jack@suse.cz> writes:
> > 
> > >   Hello,
> > >
> > >   we've recently hit a deadlock in our QA runs which is caused by the
> > > per-process plugging code. The problem is as follows:
> > >   process A					process B (kjournald)
> > >   generic_file_aio_write()
> > >     blk_start_plug(&plug);
> > >     ...
> > >     somewhere in here we allocate memory and
> > >     direct reclaim submits buffer X for IO
> > >     ...
> > >     ext3_write_begin()
> > >       ext3_journal_start()
> > >         we need more space in a journal
> > >         so we want to checkpoint old transactions,
> > >         we block waiting for kjournald to commit
> > >         a currently running transaction.
> > > 						journal_commit_transaction()
> > > 						  wait for IO on buffer X
> > > 						  to complete as it is part
> > > 						  of the current transaction
> > >
> > >   => deadlock since A waits for B and B waits for A to do unplug.
> > > BTW: I don't think this is really ext3/ext4 specific. I think other
> > > filesystems can get into problems as well when direct reclaim submits some
> > > IO and the process subsequently blocks without submitting the IO.
> > 
> > So, I thought schedule would do the flush.  Checking the code:
> > 
> > asmlinkage void __sched schedule(void)
> > {
> >         struct task_struct *tsk = current;
> > 
> >         sched_submit_work(tsk);
> >         __schedule();
> > }
> > 
> > And sched_submit_work looks like this:
> > 
> > static inline void sched_submit_work(struct task_struct *tsk)
> > {
> >         if (!tsk->state || tsk_is_pi_blocked(tsk))
> >                 return;
> >         /*
> >          * If we are going to sleep and we have plugged IO queued,
> >          * make sure to submit it to avoid deadlocks.
> >          */
> >         if (blk_needs_flush_plug(tsk))
> >                 blk_schedule_flush_plug(tsk);
> > }
> > 
> > This eventually ends in a call to blk_run_queue_async(q) after
> > submitting the I/O from the plug list.  Right?  So is the question
> > really why doesn't the kblockd workqueue get scheduled?
>   Ah, I didn't know this. Thanks for the hint. So in the kdump I have I can
> see requests queued in tsk->plug despite the process is sleeping in
> TASK_UNINTERRUPTIBLE state.  So the only way how unplug could have been
> omitted is if tsk_is_pi_blocked() was true. Rummaging through the dump...
> indeed task has pi_blocked_on = 0xffff8802717d79c8. The dump is from an -rt
> kernel (I just didn't originally thought that makes any difference) so
> actually any mutex is rtmutex and thus tsk_is_pi_blocked() is true whenever
> we are sleeping on a mutex. So this seems like a bug in rtmutex code.
> Thomas, you seemed to have added that condition... Any idea how to avoid
> the deadlock?

Tsk tsk, I completely overlooked sched_submit_work().

-Mike

