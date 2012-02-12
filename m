Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2BLVWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:22:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab2BLVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:22:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bug in disk event polling
Date: Sun, 12 Feb 2012 22:26:21 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        "Linux-pm mailing list" <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1202121216060.18114-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202121216060.18114-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202122226.22082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 12, 2012, Alan Stern wrote:
> On Fri, 10 Feb 2012, Tejun Heo wrote:
> 
> > Hello,
> > 
> > On Fri, Feb 10, 2012 at 04:44:48PM -0500, Alan Stern wrote:
> > > > I think it should be nrt.  It assumes that no one else is running it
> > > > concurrently; otherwise, multiple CPUs could jump into
> > > > disk->fops->check_events() concurrently which can be pretty ugly.
> > > 
> > > Come to mention it, how can a single work item ever run on more than
> > > one CPU concurrently?  Are you concerned about cases where some other 
> > > thread requeues the work item while it is executing?
> > 
> > Yeah, there are multiple paths which may queue the work item.  For
> > polling work, it definitely was possible but maybe locking changes
> > afterwards removed that.  Even then, it would be better to use nrt wq
> > as bug caused that way would be very difficult to track down.
> 
> Okay, I'll create a new workqueue for this purpose.
> 
> 
> > > The problem is that these async threads generally aren't freezable.  
> > > They will continue to run and do I/O while a system goes through a
> > > sleep transition.  How should this be handled?
> > 
> > I think it would be better to use wq for most kthreads.  A lot of them
> > aren't strictly correct in the way they deal with
> > kthread_should_stop() and freezing.  kthread in general simply seems
> > way too difficult to use correctly.
> 
> Maybe so, but getting rid of it at this point would be a big change.  
> Also, kthreads were originally considered more suitable for tasks that
> would need to run for a long time; is this no longer true?
> 
> > > kthread_run() can be adjusted on a case-by-case basis, by inserting
> > > calls to set_freezable() and try_to_freeze() at the appropriate places.  
> > > But what about async_schedule()?
> > 
> > Given the stuff async is used for, maybe just make all async execution
> > freezable?
> 
> That probably won't work.  What if a driver relies on async thread
> execution to carry out its I/O?

Well, we use async in the suspend code itself. :-)

> As another example, sd_probe() calls async_schedule(sd_probe_async,...)
> to handle the long-running parts of probing a SCSI disk.  In turn,
> sd_remove() calls async_synchronize_full() to insure that probing is
> over before the device is unbound from sd.
> 
> What happens if a hot-unpluggable disk drive is unplugged while the
> system is asleep?  It's entirely possible that the bus subsystem's
> resume routine would see the device was gone and would try to 
> unregister it.  Then sd_remove would wait for the async thread 
> to finish, which would never happen because the thread would be frozen 
> and wouldn't be thawed until all the resume routines had finished.
> 
> In this case, the proper solution is to have the SCSI prepare method 
> call async_synchronize_full().  Other cases will require other 
> solutions.

Thanks,
Rafael
