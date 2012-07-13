Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2GMMiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:38:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135Ab2GMMiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:38:18 -0400
Date: Fri, 13 Jul 2012 14:38:17 +0200
From: Jan Kara <jack@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Subject: Re: Deadlocks due to per-process plugging
Message-ID: <20120713123817.GC20361@quack.suse.cz>
References: <20120711133735.GA8122@quack.suse.cz>
 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
 <20120711201601.GB9779@quack.suse.cz>
 <alpine.LFD.2.02.1207120011070.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207120011070.32033@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-07-12 00:12:44, Thomas Gleixner wrote:
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
  Yeah, that fix from Mike makes us unable to reproduce the problem. But
frankly it is a hack and I wouldn't bet a penny there isn't another
similar problem hiding elsewhere in the code. Just it would need a
different timing / load to trigger. So I think a better solution needs to
be found (an advice from JBD maintainer TM ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
