Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1LSX5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:57:07 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63382 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495Ab1LSX5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:57:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av4EACbN7055LL6d/2dsb2JhbABDq2mBBoFyAQEEAQ4ZExwPFAULCAMYLhQlAyETG4dfuBcTi3kElH2JG4ko
Date: Tue, 20 Dec 2011 10:56:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111219235659.GT23662@dastard>
References: <1324265775.25089.20.camel@mengcong>
 <4EEEE866.2000203@linux.vnet.ibm.com>
 <4EEF0003.3010800@codeaurora.org>
 <4EEF1A13.4000801@linux.vnet.ibm.com>
 <20111219121100.GI2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219121100.GI2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 12:11:00PM +0000, Al Viro wrote:
> On Mon, Dec 19, 2011 at 04:33:47PM +0530, Srivatsa S. Bhat wrote:
> 
> > IMHO, we don't need to be concerned here because, {get,put}_online_cpus()
> > implement a refcounting solution, and they don't really serialize stuff
> > unnecessarily. The readers (those who prevent cpu hotplug, such as this lock-
> > unlock code) are fast and can be concurrent, while the writers (the task that
> > is doing the cpu hotplug) waits till all existing readers are gone/done with
> > their work.
> > 
> > So, since we are readers here, IMO, we don't have to worry about performance.
> > (I know that we get serialized just for a moment while incrementing the
> > refcount, but that should not be worrisome right?)
> > 
> > Moreover, using for_each_online_cpu() without using {get,put}_online_cpus()
> > around that, is plain wrong, because of the unhandled race with cpu hotplug.
> > IOW, our primary concern here is functionality, isn't it?
> > 
> > To summarize, in the current design of these VFS locks, using
> > {get,put}_online_cpus() is *essential* to fix a functionality-related bug,
> > (and not so bad performance-wise as well).
> > 
> > The following patch (v2) incorporates your comments:
> 
> I really don't like that.  Amount of contention is not a big issue, but the
> fact that now br_write_lock(vfsmount_lock) became blocking is really nasty.
> Moreover, we suddenly get cpu_hotplug.lock nested inside namespace_sem...
> BTW, it's seriously blocking - if nothing else, it waits for cpu_down()
> in progress to complete.  Which can involve any number of interesting
> locks taken by notifiers.
> 
> Dave's variant is also no good; consider this:
> CPU1: br_write_lock(); spinlocks grabbed
> CPU2: br_read_lock(); spinning on one of them
> CPU3: try to take CPU2 down.  We *can't* proceed to the end, notifiers or no
> notifiers, until CPU2 gets through the critical area.  Which can't happen
> until the spinlock is unlocked, i.e. until CPU1 does br_write_unlock().
> Notifier can't silently do spin_unlock() here or we'll get CPU2 free to go
> into the critical area when it's really not safe there.

Yeah, XFS has some, er, complexity to handle this.

Basically, it has global state (the on-disk superblock) that the
per-cpu counters synchronised back to every so often and hence the
per-cpu counters can be switched on and off.  There's also a global
state lock that is held through a counter modification slow path and
during notifier operations and the combination of these is used to
avoid such race conditions.  Hence when a cpu dies, we do:

        case CPU_DEAD:
        case CPU_DEAD_FROZEN:
                /* Disable all the counters, then fold the dead cpu's
                 * count into the total on the global superblock and
                 * re-enable the counters. */
                xfs_icsb_lock(mp);
                spin_lock(&mp->m_sb_lock);
                xfs_icsb_disable_counter(mp, XFS_SBS_ICOUNT);
                xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
                xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
....

Which is basically:

	1. take global counter state modification mutex
	2. take in-core superblock lock (global in-core fs state
	   that the per-cpu counters sync to)
	3. disable each online per-cpu counter
		a. lock all online per-cpu locks for the counter
		b. clear counter enabled bit
		c. unlock all online per-cpu locks

And when the counter is re-enabled after the cleanup of the per-cpu
counter state on the dead CPU, it does it via a rebalancing
operation:

	1. disable each online per-cpu counter
		a. lock all online per-cpu locks for the counter
		b. clear counter enabled bit
		c. unlock all online per-cpu locks
	2. balance counter across all online per-cpu structures
	3. enable each online epr-cpu counter:
		a. lock all online per-cpu locks for the counter
		b. set counter enabled bit
		c. unlock all online per-cpu locks
	4. drop in-core superblock lock
	5. drop global counter state modification mutex

Hence, in the situation you describe above, if CPU 2 gets the lock
before the notifier, all is well. In the case it doesn't, it get
blocked like this:

	prempt_disable()
	if (counter disabled)
		goto slow path
	lock_local_counter()			<<<< spin here
					cpu notifier disables counter
					and unlocks it. We get the lock
	if (counter disabled) {
		unlock_local_counter()
		goto slow path
	}

.....
slow_path:
	preempt_enable()
	xfs_icsb_lock(mp)		<<<< serialises on global notifier lock
					not on any of the spin locks

Like I said, there's quite a bit of complexity in all this to handle
the cpu notifiers in (what I think is) a race free manner. I've been
looking at replacing all this complexity (it's close to a 1000 lines
of code) with the generic per-cpu counters, but that's got it's own
problems that involve adding lots of complexity....

> That got one hell of a deadlock potential ;-/  So far I'm more or less
> in favor of doing get_online_cpus() explicitly in fs/namespace.c, outside
> of namespace_sem.  But I still have not convinced myself that it's
> really safe ;-/

Agreed, it looks like a lot simpler solution to this problem than a
notifier. But I don't think I know enough about the usage context to
determine if it is safe, either, so i can't really help you there. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
