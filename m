Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab2BJVou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:44:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37560 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759201Ab2BJVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:44:49 -0500
Date: Fri, 10 Feb 2012 16:44:48 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
In-Reply-To: <20120210211255.GK19392@google.com>
Message-ID: <Pine.LNX.4.44L0.1202101631180.1179-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Tejun Heo wrote:

> Hello, Alan.
> 
> On Fri, Feb 10, 2012 at 04:03:51PM -0500, Alan Stern wrote:
> > None of those resets above should have occurred.  They are the result
> > of trying to recover from the failure of a TEST UNIT READY command.
> 
> Thanks for the log.  Yeah, I was just thinking about libata and
> wondering why it would break that badly.
> 
> > > > I have verified that changing all occurrences of system_nrt_wq in 
> > > > block/genhd.c to system_freezable_wq fixes the bug.  However this may 
> > > > not be the way you want to solve it; you may prefer to have a freezable 
> > > > non-reentrant work queue.
> > > 
> > > Please feel free to send out a patch to fix the issue. :)
> > 
> > Is there a real reason for using system_nrt_wq?  Are you okay with just
> > switching over to system_freezable_wq?
> 
> I think it should be nrt.  It assumes that no one else is running it
> concurrently; otherwise, multiple CPUs could jump into
> disk->fops->check_events() concurrently which can be pretty ugly.

Come to mention it, how can a single work item ever run on more than
one CPU concurrently?  Are you concerned about cases where some other 
thread requeues the work item while it is executing?


Here's a separate but related problem.  Several drivers do I/O in async 
threads.  Two examples: The SCSI core calls kthread_run() to scan for 
devices below a newly-added host, and the sd driver uses 
async_schedule() to probe a newly-added SCSI disk.  There probably are 
lots of other cases I'm not aware of.

The problem is that these async threads generally aren't freezable.  
They will continue to run and do I/O while a system goes through a
sleep transition.  How should this be handled?

kthread_run() can be adjusted on a case-by-case basis, by inserting
calls to set_freezable() and try_to_freeze() at the appropriate places.  
But what about async_schedule()?

Alan Stern

