Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132Ab2D0S12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:27:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35032 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760401Ab2D0S11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:27:27 -0400
Date: Fri, 27 Apr 2012 14:27:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <87haw55eed.fsf@xmission.com>
Message-ID: <Pine.LNX.4.44L0.1204271410470.1690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012, Eric W. Biederman wrote:

> >> > Another idea is to have A's method temporarily drop the sysfs readlock.  
> >> > Of course that would put the onus on the USB core of guaranteeing that
> >> > A cannot be removed while this happens, but we can handle that.
> >> 
> >> Yeah, that's an easier way out.  Please make it a proper sysfs API
> >> call tho so that people working on sysfs later can know of the special
> >> case.
> >
> > I will.
> >
> > Would it be better to release just the lockdep annotation while
> > continuing to hold the actual lock, or to really drop the lock?
> 
> We can't really drop the ``lock''.  That would imply not waiting for
> all of the methods using a sysfs attributes not to finish before we
> remove a sysfs attribute.  Kaboom!

That's why I wrote above "... would put the onus on the USB core 
of guaranteeing that A cannot be removed while this happens".  But 
regardless, we can keep the lock while dropping the annotation.

> Probably what would be better would figure out how to sneak in something
> that for this file we tell lockdep to ignore it like you do the device
> locks.  As you do for the device layer locking.

Dropping the annotation has pretty much that effect, right?  I don't 
want lockdep to ignore the locks entirely, because we still want to 
catch attributes that unregister themselves (as opposed to 
unregistering their counterparts in child devices).

> I don't like the choices available at this junction.  I have seen some
> nasty ABBA deadlocks with sysfs, and anything that makes those easier to
> see.
> 
> One thing that looks promising after reading lwn yesterday is what Al
> and Oleg are doing with fput and a per task work queue that runs before
> we return to user space.  If you could use that we could have our
> cake and eat it too.   You could schedule the work in a work queue but
> you could also be guaranteed that there are not any locking problems.
> 
> Do you think you could investigate that possibility?

Yes, I think that would work.  It would require a little more code and
some errors would not get reported correctly (those that occur during
the callback).

(Incidentally, the sysfs_workqueue used in sysfs_schedule_callback()  
could also be replaced by the per-task work queue.)

Which do you prefer: temporarily dropping the lockdep annotation, or
deferring the work to the per-task work queue?  Note that these "flush
before returning to userspace" things aren't in the kernel yet.

Alan Stern

