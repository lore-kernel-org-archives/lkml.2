Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2FNNs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:48:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:13402 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab2FNNsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165651389"
Date: Thu, 14 Jun 2012 21:48:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Wanpeng Li <liwp.linux@gmail.com>, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liswp@linux.vnet.ibm.com>
Subject: Re: [PATCH] writeback: avoid race when update bandwidth
Message-ID: <20120614134818.GA15553@localhost>
References: <1339496803-2885-1-git-send-email-liwp.linux@gmail.com>
 <20120612112129.GA16639@localhost>
 <20120613035647.GU22848@dastard>
 <20120613042115.GA25842@localhost>
 <20120614013645.GA7339@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614013645.GA7339@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 11:36:45AM +1000, Dave Chinner wrote:
> On Wed, Jun 13, 2012 at 12:21:15PM +0800, Fengguang Wu wrote:
> > On Wed, Jun 13, 2012 at 01:56:47PM +1000, Dave Chinner wrote:
> > > On Tue, Jun 12, 2012 at 07:21:29PM +0800, Fengguang Wu wrote:
> > > > On Tue, Jun 12, 2012 at 06:26:43PM +0800, Wanpeng Li wrote:
> > > > > From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> > > > 
> > > > That email address is no longer in use?
> > > > 
> > > > > Since bdi->wb.list_lock is used to protect the b_* lists,
> > > > > so the flushers who call wb_writeback to writeback pages will
> > > > > stuck when bandwidth update policy holds this lock. In order
> > > > > to avoid this race we can introduce a new bandwidth_lock who
> > > > > is responsible for protecting bandwidth update policy.
> > > 
> > > This is not a race condition - it is a lock contention condition.
> > 
> > Nod.
> > 
> > > > This looks good to me. wb.list_lock could be contended and it's better
> > > > for bdi_update_bandwidth() to use a standalone and hardly contended
> > > > lock.
> > > 
> > > I'm not sure it will be "hardly contended". That's a global lock, so
> > > now we'll end up with updates on different bdis contending and it's
> > > not uncommon to see a couple of thousand processes on large machines
> > > beating on balance_dirty_pages().  Putting a global scope lock
> > > around such a function doesn't seem like a good solution to me.
> > 
> > It's more about the number of bdi's than the number of processes that matters.
> > Because here is a per-bdi 200ms ratelimit:
> > 
> > bdi_update_bandwidth():
> > 
> >        if (time_is_after_eq_jiffies(bdi->bw_time_stamp + BANDWIDTH_INTERVAL))
> >                 return;         
> >        // lock it
> 
> So now you get a thousand processes on a thousand CPUs all hit that
> case at the same time because they are all writing to disk at the
> same time, all nicely synchronised by MPI. Lock contention ahoy!

Yeah, the cost does increase fast with number of CPUs...

> > So a global should be enough when there are only dozens of disks.
> 
> Only needs one bdi, just with lots of processes trying to hit it at
> the same time such that they all pass the time after check.

It's more related to number of CPUs: once task A updates
bdi->bw_time_stamp, the other tasks B, C, D, ... will see the updated
value and will all back off in the next 200ms period.

> > However, the global bandwidth_lock will probably become a problem when
> > there comes hundreds of disks. If there are (or will be) such setups,
> > I'm fine to revert to the old per-bdi locking.
> 
> There are setups with hundreds of disks. They also tend to
> have hundreds of CPUs, too....

OK.. I'll drop the change.

> > > Oh, and if you want to remove the dirty_lock from
> > > global_update_limit(), then replacing the lock with a cmpxchg loop
> > > will do it just fine....
> > 
> > Yes. But to be frank, I don't care about that dirty_lock at all,
> > because it has its own 200ms rate limiting :-)
> 
> That has the same problem, only it's currently nested inside another
> lock which isolates it from contention.  This is why measurement is
> important - until there is that evidence shows that the lock
> contention is a problem, don't change it because it generally has a
> unpredictable cascading effect that often results in worse
> contention that was there originally....

You are right, it's good attitude to avoid "might be better" changes
for some "suspected problem".

Thanks,
Fengguang
