Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab2GMOq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 10:46:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2GMOqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 10:46:24 -0400
Date: Fri, 13 Jul 2012 16:46:22 +0200
From: Jan Kara <jack@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
Message-ID: <20120713144622.GB28715@quack.suse.cz>
References: <20120711133735.GA8122@quack.suse.cz>
 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
 <20120711201601.GB9779@quack.suse.cz>
 <alpine.LFD.2.02.1207121552111.32033@ionos>
 <20120713123318.GB20361@quack.suse.cz>
 <alpine.LFD.2.02.1207131444490.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207131444490.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 13-07-12 16:25:05, Thomas Gleixner wrote:
> On Fri, 13 Jul 2012, Jan Kara wrote:
> > On Thu 12-07-12 16:15:29, Thomas Gleixner wrote:
> > > >   Ah, I didn't know this. Thanks for the hint. So in the kdump I have I can
> > > > see requests queued in tsk->plug despite the process is sleeping in
> > > > TASK_UNINTERRUPTIBLE state.  So the only way how unplug could have been
> > > > omitted is if tsk_is_pi_blocked() was true. Rummaging through the dump...
> > > > indeed task has pi_blocked_on = 0xffff8802717d79c8. The dump is from an -rt
> > > > kernel (I just didn't originally thought that makes any difference) so
> > > > actually any mutex is rtmutex and thus tsk_is_pi_blocked() is true whenever
> > > > we are sleeping on a mutex. So this seems like a bug in rtmutex code.
> > > 
> > > Well, the reason why this check is there is that the task which is
> > > blocked on a lock can hold another lock which might cause a deadlock
> > > in the flush path.
> >   OK. Let me understand the details. Block layer needs just queue_lock for
> > unplug to succeed. That is a spinlock but in RT kernel, even a process
> > holding a spinlock can be preempted if I remember correctly. So that
> > condition is there effectively to not unplug when a task is being scheduled
> > away while holding queue_lock? Did I get it right?
> 
> blk_flush_plug_list() is not only queue_lock. There can be other locks
> taken in the callbacks, elevator ...
  Yeah, right.

> > > > Thomas, you seemed to have added that condition... Any idea how to avoid
> > > > the deadlock?
> > > 
> > > Good question. We could do the flush when the blocked task does not
> > > hold a lock itself. Might be worth a try.
> >   Yeah, that should work for avoiding the deadlock as well.
> 
> Though we don't have a lock held count except when lockdep is enabled,
> which you probably don't want to do when running a production system.
  Agreed :).

> But we only care about stuff being scheduled out while blocked on a
> "sleeping spinlock" - i.e. spinlock, rwlock.
> 
> So the patch below should allow the unplug to take place when blocked
> on mutexes etc.
  Thanks for the patch! Mike will give it some testing.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
