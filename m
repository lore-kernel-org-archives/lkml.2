Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab2FNCGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:06:05 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:41310 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab2FNCGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:06:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlEJAMZF2U95LAcV/2dsb2JhbABFFrN2BIEwgQiCGAEBAQMBAQIkExwjBQsIAxUDLhQNBxEDIROHfQMGBAywWw2JThSKOmJJhGhgA5J7giWBE4lthH2Ccg
Date: Thu, 14 Jun 2012 12:05:59 +1000
From: Dave Chinner <david@fromorbit.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] writeback: avoid race when update bandwidth
Message-ID: <20120614020559.GB7339@dastard>
References: <1339501561-4570-1-git-send-email-liwp.linux@gmail.com>
 <20120612115219.GA17348@localhost>
 <20120613035920.GV22848@dastard>
 <20120613121434.GA937@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613121434.GA937@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:14:34PM +0800, Fengguang Wu wrote:
> On Wed, Jun 13, 2012 at 01:59:20PM +1000, Dave Chinner wrote:
> > On Tue, Jun 12, 2012 at 07:52:19PM +0800, Fengguang Wu wrote:
> > > On Tue, Jun 12, 2012 at 07:46:01PM +0800, Wanpeng Li wrote:
> > > > From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> > > > 
> > > > "V1 -> V2"
> > > > * remove dirty_lock
> > > > 
> > > > Since bdi->wb.list_lock is used to protect the b_* lists,
> > > > so the flushers who call wb_writeback to writeback pages will
> > > > stuck when bandwidth update policy holds this lock. In order
> > > > to avoid this race we can introduce a new bandwidth_lock who
> > > > is responsible for protecting bandwidth update policy.
> > > > 
> > > > Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> > > 
> > > Applied with a new title "writeback: use a standalone lock for
> > > updating write bandwidth". "race" is sensitive because it often
> > > refers to some locking error.
> > 
> > Fengguang - can we get some evidence that this is a contended lock
> > before changing the scope of it? All of the previous "breaking up
> > global locks" have been done based on lock contention data, so
> > moving back to a global lock for this needs to have the same
> > analysis provided...
> 
> Good point. Attached is the lockstat for the case "10 disks each runs
> 100 dd dirtier tasks":
> 
>         lkp-ne02/JBOD-10HDD-thresh=4G/xfs-100dd-1-3.2.0-rc5

(nothing attached)

> The wb->list_lock contention is much better than I expected, which is
> good.  What stand out are
>                                                         waittime-total
> - &rq->lock             by double_rq_lock()             6738952.13
> - clockevents_lock      by clockevents_notify()         2155554.37
> - mapping->tree_lock    by test_clear_page_writeback()   931550.13
> - sb_lock               by grab_super_passive()          918815.87
> - &zone->lru_lock       by pagevec_lru_move_fn()         912681.05
> 
> - sysfs_mutex           by sysfs_permission()           24029975.20 # mutex
> - ip->i_lock            by xfs_ilock()                  18428284.10 # mrlock

The wait time is not really an indication of contention problems.
Large wait time is usually an indication that the lock is being used
a lot.

What matters is the number of contentions vs the number of
acquisitions, and the number of those contentions that bounced the
lock. If the number of contentions is >= 0.5% of the acquisitions,
then the lock can be considered hot and needing some work. If I look
here:

http://lists.linux.hp.com/~enw/ext4/3.2/3.2-full-lockstats.2/ffsb_fsscale.xfs.large_file_creates_threads=192/profiling/iteration.1/lock_stat

Which is a 192 thread concurrent write on a 48-core machine, the
wb.list_lock shows 5,532 acquistions for the entire test, while the
mapping tree lock took 440 million!. So your test isn't really one
that shows wb.list_lock contention. The 192-thread mailserver
workload from the same machine:

http://lists.linux.hp.com/~enw/ext4/3.2/3.2-full-lockstats.2/ffsb_fsscale.xfs.mail_server_threads=192/profiling/iteration.1/lock_stat

Shows about 7.1m acquisitions of the wb.list_lock, but only 28,000
contentions. So it isn't really contended enough to justify
replacing it with a global lock.

FWIW, the third most contended lock on that workload is the XFS
delayed write queue lock - 25M acquisitions for 600k contentions - a
rate of about 2% which means quite severe contention.  That lock no
longer exists in 3.5 - Christoph completely reworked the delayed
write buffer support to remove the global list and lock because it
was showing up in profiles like this...

Indeed, that profile shows that XFS owns 7 of the 10 most contended
locks, and 3 of them have had significant work done to reduce the
contention since 3.2 as a result of recent profile results like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
