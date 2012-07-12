Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2GLEM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:12:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2GLEMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:12:52 -0400
Message-ID: <1342066364.7338.57.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Thu, 12 Jul 2012 06:12:44 +0200
In-Reply-To: <alpine.LFD.2.02.1207120011070.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207120011070.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 00:12 +0200, Thomas Gleixner wrote: 
> On Wed, 11 Jul 2012, Jan Kara wrote:
> > On Wed 11-07-12 12:05:51, Jeff Moyer wrote:
> > > This eventually ends in a call to blk_run_queue_async(q) after
> > > submitting the I/O from the plug list.  Right?  So is the question
> > > really why doesn't the kblockd workqueue get scheduled?
> >   Ah, I didn't know this. Thanks for the hint. So in the kdump I have I can
> > see requests queued in tsk->plug despite the process is sleeping in
> > TASK_UNINTERRUPTIBLE state.  So the only way how unplug could have been
> > omitted is if tsk_is_pi_blocked() was true. Rummaging through the dump...
> > indeed task has pi_blocked_on = 0xffff8802717d79c8. The dump is from an -rt
> > kernel (I just didn't originally thought that makes any difference) so
> > actually any mutex is rtmutex and thus tsk_is_pi_blocked() is true whenever
> > we are sleeping on a mutex. So this seems like a bug in rtmutex code.
> > Thomas, you seemed to have added that condition... Any idea how to avoid
> > the deadlock?
> 
> Mike has sent out a fix related to the plug stuff, which I just posted
> for the rt stable series. Can you verify against that ?

btw, I called io_schedule() instead of a plain unplug thinking we're
going to schedule anyway, but if we unplug and schedule, and we're not
leftmost (non-rt task 'course), while we're away, likely contended mutex
we're about to take may be released or at least become less contended.
What a we won't be doing is accruing sleep time to help trigger yet more
preemption.  Anyone more deserving can move smartly rightward, and thus
out of our way for a bit.

If we're leftmost or rt, all was for naught, but it seemed worth a shot.

-Mike

