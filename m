Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab1F1QXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:23:30 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:50471 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225Ab1F1QVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:21:47 -0400
Date: Tue, 28 Jun 2011 18:21:38 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages()
Message-ID: <20110628162138.GA1544@thinkpad>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
> 
> - All WRITEs are throttled at device level and this can easily lead to
>   filesystem serialization.
> 
>   One simple example is that if a process writes some pages to cache and
>   then does fsync(), and process gets throttled then it locks up the
>   filesystem. With ext4, I noticed that even a simple "ls" does not make
>   progress. The reason boils down to the fact that filesystems are not
>   aware of cgroups and one of the things which get serialized is journalling
>   in ordered mode.
> 
>   So even if we do something to carry submitter's cgroup information
>   to device and do throttling there, it will lead to serialization of
>   filesystems and is not a good idea.
> 
> So how to go about fixing it. There seem to be two options.
> 
> - Throttling should still be done at device level. Make filesystems aware
>   of cgroups so that multiple transactions can make progress in parallel
>   (per cgroup) and there are no shared resources across cgroups in
>   filesystems which can lead to serialization.
> 
> - Throttle WRITEs while they are entering the cache and not after that.
>   Something like balance_dirty_pages(). Direct IO is still throttled
>   at device level. That way, we can avoid these journalling related
>   serialization issues w.r.t trottling.

I think that O_DIRECT WRITEs can hit the same serialization problem if
we throttle them at device level.

Have you tried to do some tests? (i.e. create multiple cgroups with very
low I/O limit doing parallel O_DIRECT WRITEs, and try to run at the same
time "ls" or other simple commands from the root cgroup or unlimited
cgroup).

If we hit the same serialization problem I think we should do something
similar also for O_DIRECT WRITEs (e.g, throttle them at the VFS layer),
as a temporary solution.

The best solution is always to address this problem at the filesystem
layer (option 1), but it's a *huge* change, because all the filesystems
need to be redesigned to be cgroup-aware. For now the temporary solution
could help at least to avoid system lockups while doing large O_DIRECT
writes from I/O-limited cgroups.

Thanks,
-Andrea

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
> 
> Option 1 seem to be really hard to fix. Filesystems have not been written
> keeping cgroups in mind. So I am really skeptical that I can convince file
> system designers to make fundamental changes in filesystems and journalling
> code to make them cgroup aware.
> 
> Hence with this patch series I have implemented option 2. Option 2 is not
> the best solution but atleast it gives us some control then not having any
> control on buffered writes. Andrea Righi did similar patches in the past
> here.
> 
> https://lkml.org/lkml/2011/2/28/115
> 
> This patch series had issues w.r.t to interaction between bio and task
> throttling, so I redid it.
> 
> Design
> ------
> 
> IO controller already has the capability to keep track of IO rates of
> a group and enqueue the bio in internal queues if group exceeds the
> rate and dispatch these bios later.
> 
> This patch series also introduce the capability to throttle a dirtying
> task in balance_dirty_pages_ratelimited_nr(). Now no WRITES except
> direct WRITES will be throttled at device level. If a dirtying task
> exceeds its configured IO rate, it is put on a group wait queue and
> woken up when it can dirty more pages.
> 
> No new interface has been introduced and both direct IO as well as buffered
> IO make use of common IO rate limit.
> 
> How To
> =====
> - Create a cgroup and limit it to 1MB/s for writes.
>   echo "8:16 1024000" > /cgroup/blk/test1/blkio.throttle.write_bps_device
> 
> - Launch dd thread in the cgroup
>   dd if=/dev/zero of=zerofile bs=4K count=1K
> 
>  1024+0 records in
>  1024+0 records out
>  4194304 bytes (4.2 MB) copied, 4.00428 s, 1.0 MB/s
> 
> Any feedback is welcome.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (8):
>   blk-throttle: convert wait routines to return jiffies to wait
>   blk-throttle: do not enforce first queued bio check in
>     tg_wait_dispatch
>   blk-throttle: use io size and direction as parameters to wait
>     routines
>   blk-throttle: specify number of ios during dispatch update
>   blk-throttle: get rid of extend slice trace message
>   blk-throttle: core logic to throttle task while dirtying pages
>   blk-throttle: do not throttle writes at device level except direct io
>   blk-throttle: enable throttling of task while dirtying pages
> 
>  block/blk-cgroup.c        |    6 +-
>  block/blk-cgroup.h        |    2 +-
>  block/blk-throttle.c      |  506 +++++++++++++++++++++++++++++++++++---------
>  block/cfq-iosched.c       |    2 +-
>  block/cfq.h               |    6 +-
>  fs/direct-io.c            |    1 +
>  include/linux/blk_types.h |    2 +
>  include/linux/blkdev.h    |    5 +
>  mm/page-writeback.c       |    3 +
>  9 files changed, 421 insertions(+), 112 deletions(-)
> 
> -- 
> 1.7.4.4
