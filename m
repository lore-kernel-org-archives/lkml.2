Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab0JABYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:24:31 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:40244 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046Ab0JABYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:24:30 -0400
Date: Fri, 1 Oct 2010 11:24:25 +1000
From: Dave Chinner <david@fromorbit.com>
To: "J.H." <warthog9@kernel.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>, users@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] cannot ssh to master.kernel.org
Message-ID: <20101001012425.GC5665@dastard>
References: <871v8bgpgb.fsf@deeprootsystems.com>
 <4CA51B61.8040404@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA51B61.8040404@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 04:21:05PM -0700, J.H. wrote:
> Hey everyone,
> 
> So this morning we found 'master' basically spinning off the hook, with
> a consistently high load [READ: around 160ish].  Needless to say, mail
> was getting differed due to the load and I'm sure ssh was having similar
> issues.
> 
> Several things were noticed on the system:
> 
> - Several cron jobs had spun up multiple copies of themselves, despite
> locking being present in the jobs.  I'm not sure if they were attempting
> to check the existing locks or if they were actually running through but
> they were present.
> 
> - The loads were relatively high, but not seemingly because of disk i/o.
>  There were a great number of processes in the run state.
> 
> - Attempting to explicitly kill may of the processes left the processes
> in a zombie state, but were still consuming CPU resources.  Attempting
> to kill them again did not result in the death of the processes, or the
> relinquishing of the cpu resources.  Attempting to strace the process
> yielded nothing of interest / use.  lsof on the zombie process did
> return it's currently open file handles, including tcp connections.
> 
> - Disks all seemed to be readable and writeable.
> 
> - a sysrq+l dump of the system in this messed up state can be found at
> http://pastebin.osuosl.org/35126 (this was originally requested by
> Johannes Weiner)

I'd say the machine had a severe low memory condition, followed by
severe lock contention in the XFS inode cache shrinker caused by
direct reclaim running in every process trying to allocate memory
and all trying to shrink the same cache.

That is, every CPU has traces like:

Sep 30 18:31:00 hera klogd:  [<ffffffffa0196d14>] spin_lock+0xe/0x10 [xfs]
Sep 30 18:31:00 hera klogd:  [<ffffffffa0198718>] xfs_perag_get+0x2b/0x9d [xfs]
Sep 30 18:31:00 hera klogd:  [<ffffffffa01add78>] xfs_inode_ag_iterator+0x50/0xd8 [xfs]
Sep 30 18:31:00 hera klogd:  [<ffffffffa01ad176>] ?  xfs_reclaim_inode+0x0/0x206 [xfs]
Sep 30 18:31:00 hera klogd:  [<ffffffffa01ade66>] xfs_reclaim_inode_shrink+0x66/0x12a [xfs]
Sep 30 18:31:00 hera klogd:  [<ffffffff810d6d45>] shrink_slab+0xdb/0x15f
Sep 30 18:31:00 hera klogd:  [<ffffffff810d7a99>] do_try_to_free_pages+0x21a/0x342
Sep 30 18:31:00 hera klogd:  [<ffffffff810d7d72>] try_to_free_pages+0x6f/0x71
Sep 30 18:31:00 hera klogd:  [<ffffffff810d5543>] ? isolate_pages_global+0x0/0x22a
Sep 30 18:31:00 hera klogd:  [<ffffffff810d1685>] __alloc_pages_nodemask+0x3eb/0x636
Sep 30 18:31:00 hera klogd:  [<ffffffff810f83e7>] alloc_pages_current+0x95/0x9e
Sep 30 18:31:00 hera klogd:  [<ffffffff810ffe2b>] alloc_slab_page+0x1b/0x28
Sep 30 18:31:00 hera klogd:  [<ffffffff810ffe8c>] new_slab+0x54/0x1d4
Sep 30 18:31:00 hera klogd:  [<ffffffff811004a3>] __slab_alloc+0x1f3/0x3a7

> - kswapd0 has been using a lot of cpu time.  I wouldn't be concerned
> about this if it was say, 10% of a cpu, or maybe even 20% of a cpu for a
> short time.  It has however been running in some cases at 100% cpu on a
> single core for hours on end.  This seems to happen, in particular,
> under slightly higher loads particularly relating to when there are a
> number of rsyncs going on simultaneously.

Yes, this is definitely related to the hang. The rsyncs are
generating xfs inode cache pressure, and the kswapd is running the
shrinker to clean it up.  master.kernel.org is running
2.6.34.7-56.fc11.x86_64, which has this commit:

http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.34.y.git;a=commit;h=9bf729c0af67897ea8498ce17c29b0683f7f2028

(xfs: add a shrinker to background inode reclaim)

This was necessary to avoid a far worse OOM panic, but until about a
month ago nobody had any idea there were major lock contention
problems with this shrinker.

The fundamental problem here is not the XFS shrinker - it is the
fact that direct reclaim allows shrinkers that act on global caches
to be called concurrently on every CPU at once. Hence situations
like this can occur where parallel access to a global lock/list is
the limiting factor.

However, it's only been the in the last month that I've really
managed to get the lock contention problem sorted out (because I
found a reproducable test case) and the shrinkers actually scaling.
The series they are in are:

http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=shortlog;h=refs/heads/metadata-scale

which is queued up in the XFS tree for merging in the .37 merge window.
The specific commits involved are:

6c97772 xfs: serialise inode reclaim within an AG
e1a48db xfs: batch inode reclaim lookup
c727163 xfs: implement batched inode lookups for AG walking
7227905 xfs: split out inode walk inode grabbing
fa78a91 xfs: split inode AG walking into separate code for reclaim
ec9cb17 xfs: lockless per-ag lookups

This is a major rework of the entire inode cache walking code, it
converts AG lookups to be lockless (RCU), it batches inode lookups
to reduce lock traffic and hold times, it reworks the "can we
reclaim inode" logic to avoid all locking until we are mostly
certain it can be reclaimed, etc.

I'm not about to ask anyone to push these changes into .36 because
they need wider testing first, so it's going to be a bit of time
before stable kernel backports are even possible.

> Replicating the rsyncs on a nearly identical box, running an older
> 2.6.30 kernel, did not see this much cpu usage of kswapd0.  Johannes
> Weiner was helping me look into it yesterday, but I don't think anything
> was explicitly conclusive.

Yes, these issues started appearing around 2.6.34 when the XFS inode
cache reclaim was pushed into a background thread for scalability
reasons.  I'd suggest that upgrade the kernel to the latest 2.6.35.y
kernel would be a good idea....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
