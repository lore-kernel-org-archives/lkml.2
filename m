Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab1F1RlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 13:41:17 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:55668 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395Ab1F1RjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 13:39:11 -0400
Date: Tue, 28 Jun 2011 19:39:01 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/8][V2] blk-throttle: Throttle buffered WRITEs in
 balance_dirty_pages()
Message-ID: <20110628173901.GC1544@thinkpad>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
 <20110628162138.GA1544@thinkpad>
 <20110628170624.GA12949@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628170624.GA12949@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 01:06:24PM -0400, Vivek Goyal wrote:
> On Tue, Jun 28, 2011 at 06:21:38PM +0200, Andrea Righi wrote:
> > On Tue, Jun 28, 2011 at 11:35:01AM -0400, Vivek Goyal wrote:
> > > Hi,
> > > 
> > > This is V2 of the patches. First version is posted here.
> > > 
> > > https://lkml.org/lkml/2011/6/3/375
> > > 
> > > There are no changes from first version except that I have rebased it to
> > > for-3.1/core branch of Jens's block tree.
> > > 
> > > I have been trying to find ways to solve two problems with block IO controller
> > > cgroups.
> > > 
> > > - Current throttling logic in IO controller does not throttle buffered WRITES.
> > >   Well it does throttle all the WRITEs at device and by that time buffered
> > >   WRITE have lost the submitter's context and most of the IO comes in flusher
> > >   thread's context at device. Hence currently buffered write throttling is
> > >   not supported.
> > > 
> > > - All WRITEs are throttled at device level and this can easily lead to
> > >   filesystem serialization.
> > > 
> > >   One simple example is that if a process writes some pages to cache and
> > >   then does fsync(), and process gets throttled then it locks up the
> > >   filesystem. With ext4, I noticed that even a simple "ls" does not make
> > >   progress. The reason boils down to the fact that filesystems are not
> > >   aware of cgroups and one of the things which get serialized is journalling
> > >   in ordered mode.
> > > 
> > >   So even if we do something to carry submitter's cgroup information
> > >   to device and do throttling there, it will lead to serialization of
> > >   filesystems and is not a good idea.
> > > 
> > > So how to go about fixing it. There seem to be two options.
> > > 
> > > - Throttling should still be done at device level. Make filesystems aware
> > >   of cgroups so that multiple transactions can make progress in parallel
> > >   (per cgroup) and there are no shared resources across cgroups in
> > >   filesystems which can lead to serialization.
> > > 
> > > - Throttle WRITEs while they are entering the cache and not after that.
> > >   Something like balance_dirty_pages(). Direct IO is still throttled
> > >   at device level. That way, we can avoid these journalling related
> > >   serialization issues w.r.t trottling.
> > 
> > I think that O_DIRECT WRITEs can hit the same serialization problem if
> > we throttle them at device level.
> 
> I think it can but number of cases probably comes down significantly. One
> of the main problems seems to be sync related variants sync/fsync etc.
> And I think we do not make any gurantees for inflight requests
> (not completed yet).
> 
> So it will boil down to how dependent these sync primitives are on
> inflight direct WRITEs. I did basic testing with ext4 and it looked fine.
> On XFS, sync gets blocked behind inflight direct writes. Last time I
> raised that issue and looks like Christoph has plans to do something
> about it.
> 
> So currently my understanding is that dependency on direct writes might
> not be a major issue in practice. (Until and unless there is more to
> it I am not aware about).

OK, I was asking because I remember to have seen some problems with my
old io-throttle controller in presence of many O_DIRECT writes.

I'll repeat the tests also with this patch set.

> 
> > 
> > Have you tried to do some tests? (i.e. create multiple cgroups with very
> > low I/O limit doing parallel O_DIRECT WRITEs, and try to run at the same
> > time "ls" or other simple commands from the root cgroup or unlimited
> > cgroup).
> 
> I did. On ext4, I created a cgroup with limit 1byte per second and 
> started a direct write and did "ls", "sync" and some directory traversal
> operations in same diretory and it seems to work.

Good.

> 
> > 
> > If we hit the same serialization problem I think we should do something
> > similar also for O_DIRECT WRITEs (e.g, throttle them at the VFS layer),
> > as a temporary solution.
> 
> Yep, we could do that if need be. In fact I was thinking of creating
> a switch so that a user can also choose to throttle IO either at
> device level or page cache level.

I think it would be great to have this switch.

Throttling at VFS would have probably "granularity" problems. If a task
performs a large WRITE the only thing we can do is to put the task to
sleep for a large amount of time. And when the timer expires the large
WRITE will be submitted to the block layer all at once. Something like
the I/O spike issue with writeback I/O...

> 
> > 
> > The best solution is always to address this problem at the filesystem
> > layer (option 1), but it's a *huge* change, because all the filesystems
> > need to be redesigned to be cgroup-aware. For now the temporary solution
> > could help at least to avoid system lockups while doing large O_DIRECT
> > writes from I/O-limited cgroups.
> 
> Yep, handling it at file system level is the best solution but so far
> I have not seen any positive response on that front from filesystem
> developers. Dave Chinner though seemed open to the idea of associating
> one allocation group to one cgroup and bring some filesystem awareness
> in filesystem. But that is just one.
> 
> It is just 300 lines of simple change and we can always change it if
> filesystems ever decide to be cgroup aware and prefer write throttling
> at device level and not at page cache level.
> 
> I had raised buffered write issue at LSF this year and atleast there
> feedback was that we need to throttle buffered writes at the time of
> entering page cache.

Yes, it seems the best option right now.

-Andrea
