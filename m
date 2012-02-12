Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2BLRsY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:48:24 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53680 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755571Ab2BLRsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:48:23 -0500
Date: Sun, 12 Feb 2012 12:48:22 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
In-Reply-To: <20120211002349.GN19392@google.com>
Message-ID: <Pine.LNX.4.44L0.1202121216060.18114-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Tejun Heo wrote:

> Hello,
> 
> On Fri, Feb 10, 2012 at 04:44:48PM -0500, Alan Stern wrote:
> > > I think it should be nrt.  It assumes that no one else is running it
> > > concurrently; otherwise, multiple CPUs could jump into
> > > disk->fops->check_events() concurrently which can be pretty ugly.
> > 
> > Come to mention it, how can a single work item ever run on more than
> > one CPU concurrently?  Are you concerned about cases where some other 
> > thread requeues the work item while it is executing?
> 
> Yeah, there are multiple paths which may queue the work item.  For
> polling work, it definitely was possible but maybe locking changes
> afterwards removed that.  Even then, it would be better to use nrt wq
> as bug caused that way would be very difficult to track down.

Okay, I'll create a new workqueue for this purpose.


> > The problem is that these async threads generally aren't freezable.  
> > They will continue to run and do I/O while a system goes through a
> > sleep transition.  How should this be handled?
> 
> I think it would be better to use wq for most kthreads.  A lot of them
> aren't strictly correct in the way they deal with
> kthread_should_stop() and freezing.  kthread in general simply seems
> way too difficult to use correctly.

Maybe so, but getting rid of it at this point would be a big change.  
Also, kthreads were originally considered more suitable for tasks that
would need to run for a long time; is this no longer true?

> > kthread_run() can be adjusted on a case-by-case basis, by inserting
> > calls to set_freezable() and try_to_freeze() at the appropriate places.  
> > But what about async_schedule()?
> 
> Given the stuff async is used for, maybe just make all async execution
> freezable?

That probably won't work.  What if a driver relies on async thread
execution to carry out its I/O?

As another example, sd_probe() calls async_schedule(sd_probe_async,...)
to handle the long-running parts of probing a SCSI disk.  In turn,
sd_remove() calls async_synchronize_full() to insure that probing is
over before the device is unbound from sd.

What happens if a hot-unpluggable disk drive is unplugged while the
system is asleep?  It's entirely possible that the bus subsystem's
resume routine would see the device was gone and would try to 
unregister it.  Then sd_remove would wait for the async thread 
to finish, which would never happen because the thread would be frozen 
and wouldn't be thawed until all the resume routines had finished.

In this case, the proper solution is to have the SCSI prepare method 
call async_synchronize_full().  Other cases will require other 
solutions.

Alan Stern

