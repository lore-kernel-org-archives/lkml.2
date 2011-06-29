Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1F2Are (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 20:47:34 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:23644 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab1F2Ar1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 20:47:27 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 20:47:26 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0DAAF0Ck55LChDgWdsb2JhbABSp0IVAQEWJiWId8B3DoYiBJoXiCw
Date: Wed, 29 Jun 2011 10:42:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, andrea@betterlinux.com
Subject: Re: [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages()
Message-ID: <20110629004219.GP32466@dastard>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 11:35:01AM -0400, Vivek Goyal wrote:
> Hi,
> 
> This is V2 of the patches. First version is posted here.
> 
> https://lkml.org/lkml/2011/6/3/375
> 
> There are no changes from first version except that I have rebased it to
> for-3.1/core branch of Jens's block tree.
> 
> I have been trying to find ways to solve two problems with block IO controller
> cgroups.
> 
> - Current throttling logic in IO controller does not throttle buffered WRITES.
>   Well it does throttle all the WRITEs at device and by that time buffered
>   WRITE have lost the submitter's context and most of the IO comes in flusher
>   thread's context at device. Hence currently buffered write throttling is
>   not supported.

This problem is being solved in a different manner - by making the
bdi-flusher writeback cgroup aware.

That is, writeback will be done in the context of the cgroup that
dirtied the inode in the first place. Hence writeback will be done
in the context that the existing block throttle can understand
without modification.

And with cgroup-aware throttling in balance-dirty-pages (also part of
the same piece of work), we get the throttling based
on dirty memory usage of the cgroup and the rate at which the
bdi-flusher for the cgroup can clean pages. This is directly related
to the block throttle configuration of the specific cgroup....

There are already prototpyes for this infrastructure been written,
and we are currently waiting on the IO-less dirty throttling to be
merged before moving forward with it.

There is still one part missing, though - a necessary precursor to
this is that we need a bdi flush context per cgroup so we don't get
flushing of one cgroup blocking the flushing of another on the same
bdi. The easiest way to do this is to convert the bdi-flusher
threads to use workqueues. We can then easily extend the flush
context to be per-cgroup without an explosion of threads and the
management problems that would introduce.....

> - All WRITEs are throttled at device level and this can easily lead to
>   filesystem serialization.
> 
>   One simple example is that if a process writes some pages to cache and
>   then does fsync(), and process gets throttled then it locks up the
>   filesystem. With ext4, I noticed that even a simple "ls" does not make
>   progress. The reason boils down to the fact that filesystems are not
>   aware of cgroups and one of the things which get serialized is journalling
>   in ordered mode.

As I've said before - solving this problem is a filesystem problem,
not a throttling or cgroup infrastructure problem...

>   So even if we do something to carry submitter's cgroup information
>   to device and do throttling there, it will lead to serialization of
>   filesystems and is not a good idea.
> 
> So how to go about fixing it. There seem to be two options.
> 
> - Throttling should still be done at device level.

Yes, that is the way it should be done - all types of IO should be
throttled in the one place by the same mechanism.

> Make filesystems aware
>   of cgroups so that multiple transactions can make progress in parallel
>   (per cgroup) and there are no shared resources across cgroups in
>   filesystems which can lead to serialization.

How a specific filesystem solves this problem (if indeed it is a problem)
needs to be dealt with on a per-filesystem basis.

> - Throttle WRITEs while they are entering the cache and not after that.
>   Something like balance_dirty_pages(). Direct IO is still throttled
>   at device level. That way, we can avoid these journalling related
>   serialization issues w.r.t trottling.
> 
>   But the big issue with this approach is that we control the IO rate
>   entering into the cache and not IO rate at the device. That way it
>   can happen that flusher later submits lots of WRITEs to device and
>   we will see a periodic IO spike on end node.
> 
>   So this mechanism helps a bit but is not the complete solution. It
>   can primarily help those folks which have the system resources and
>   plenty of IO bandwidth available but they don't want to give it to
>   customer because it is not a premium customer etc.

As I said earlier - the cgroup aware bdi-flushing infrastructure
solves this problem directly inside balance_dirty_pages. i.e.  The
bdi flusher variant integrates much more cleanly with the way the MM
and writeback subsystems work and also work even when block layer
throttling is not being used at all.

If we weren't doing cgroup-aware bdi writeback and IO-less
throttling, then this block throttle method would probably be a good
idea. However, I think we have a more integrated solution already
designed and slowly being implemented....

> Option 1 seem to be really hard to fix. Filesystems have not been written
> keeping cgroups in mind. So I am really skeptical that I can convince file
> system designers to make fundamental changes in filesystems and journalling
> code to make them cgroup aware.

Again, you're assuming that cgroup-awareness is the solution to the
filesystem problem and that filesystems will require fundamental
changes. Some may, but different filesystems will require different
types of changes to work in this environment.

FYI, filesystem development cycles are slow and engineers are
conservative because of the absolute requirement for data integrity.
Hence we tend to focus development on problems that users are
reporting (i.e. known pain points) or functionality they have
requested.

In this case, block throttling works OK on most filesystems out of
the box, but it has some known problems. If there are people out
there hitting these known problems then they'll report them, we'll
hear about them and they'll eventually get fixed.

However, if no-one is reporting problems related to block throttling
then it either works well enough for the existing user base or
nobody is using the functionality. Either way we don't need to spend
time on optimising the filesystem for such functionality.

So while you may be skeptical about whether filesystems will be
changed, it really comes down to behaviour in real-world
deployments. If what we already have is good enough, then we don't
need to spend resources on fixing problems no-one is seeing...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
