Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab2FSV4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:56:51 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:56035 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108Ab2FSV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:56:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgwKAOH04E95LJ3s/2dsb2JhbABFtDsDgS2BCIIYAQEEATocIwULCAMOCi4UJQMhE4gGBLleFIsbgQ6FCwOVJIklhlmCcg
Date: Wed, 20 Jun 2012 07:56:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
Message-ID: <20120619215645.GP25389@dastard>
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
 <x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
 <20120613144840.GA3055@localhost>
 <x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
 <20120614133600.GB14883@localhost>
 <x491ulbjbzb.fsf@segfault.boston.devel.redhat.com>
 <20120619210212.GN25389@dastard>
 <x49vcinhuv1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49vcinhuv1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:09:22PM -0400, Jeff Moyer wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Tue, Jun 19, 2012 at 04:14:16PM -0400, Jeff Moyer wrote:
> >> Fengguang Wu <fengguang.wu@intel.com> writes:
> >> 
> >> > Good idea! Yes we can do some estimation and adaptively extend the
> >> > hang timeout for the current writeback_inodes_sb_nr()/sync_inodes_sb()
> >> > call.
> >> >
> >> > Note that it's not going to reliably get rid of false warnings due to
> >> > estimation errors, which could be pretty large and unavoidable on
> >> > change of workload. But still, it would be a net improvement and
> >> > perhaps enough to get rid of most false warnings, while still being
> >> > able to catch livelock or other kind of task hang.
> >> 
> >> Hi, Fengguang,
> >> 
> >> I didn't see a patch from you for this, so I went ahead and threw
> >> something together.  Let me know what you think of it.  I wasn't sure
> >> how to estimate the total I/O that will be issued for syncing out an
> >> entire superblock, though, so I didn't do that part.
> >
> > As I said to the original patch - having a hang check timeout on a
> > system that is overloaded w.r.t. IO is an important piece of
> > information when it comes to debugging problems. Often the hangcheck
> > timer is the first piece of information that we will get that
> > indicates a problem somewhere in a production system.
> 
> So, you believe that we should always check at 2 minute intervals (or
> whatever is configured), even if we know there is more than that much
> I/O queued?  In case there is any confusion, here, the patch I posted
> ensured that we would eventually spew a warning, but only if the process
> was blocked for longer than we (the kernel) expected.

Yes, because it gives us an indication of how long the problem
persisted for.

And basing the hangcheck time on the write bandwidth is a bad idea,
anyway. If we have random 4k writeback to a 24 disk RAID6 array, the
writeback rate is going to be under 1MB/s, and so that 10GB of dirty
data in memory is still going to take hours to write. The only
difference is that we won't get a warning until hours after the sync
command is run. Then we just get reports of "sync has hung" and we
hav eno information what-so-ever as to whether this is a one-off
event or it is a systemic problem....

Reducing the amount of information emitted that tells us something
is slow, possibly hung or just badly configured does not serve our
users in a positive way. It makes it harder for them to realise there
is a problem, it makes it harder for us to determine the nature of
the problem, and makes it much less likely that such problems will
be fixed.

> > Removing it does not magically fix the underlying problem - it
> > simply means that we don't hear about them until someone complains
> > that unmount is taking hours....
> 
> There isn't necessarily an underlying problem.  This is very much a gray
> area, Dave.  We get plenty of false positives in this code.  I was
> trying to reduce *that* problem.  Do you have a better idea on how to
> address the issue?

In my experience, they are rarely false positives - any system that
is taking more than 2 minutes to run sync has a problem that needs
addressing. At minimum, the owners of the system need to be aware
that their data is not getting written to disk in a timely manner,
and so their data loss liability in the face of system crashes is
*much* greater than they thought.

That, by itself, is reason enough to keep it as it stands - I *need
to know* if a report of loss of 5 minute old data on system crash is
a result of writeback not being able to keep up with the workload,
or whether there's some other problem we need to look at....

> Maybe this discussion requires looking at specific instances of the
> problem so we're all on the same page.  What do you think is the best
> way forward, here?

If advanced users don't want to be warned about this, then they can
configure the hangcheck timer appropriately. For everyone is - it's
a wakeup call that something in the IO subsystem is not working as
expected. I say leave it as it is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
