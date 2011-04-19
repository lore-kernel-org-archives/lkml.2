Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1DSAec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 20:34:32 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:29583 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357Ab1DSAe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 20:34:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugDAFHYrE15LHHJgWdsb2JhbAClQRUBARYmJYhvvlIOgwSCXwQ
Date: Tue, 19 Apr 2011 10:33:39 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Greg Thelen <gthelen@google.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cgroup IO throttling and filesystem ordered mode (Was: Re:
 [Lsf] IO less throttling and cgroup aware writeback (Was: Re: Preliminary
 Agenda and Activities for LSF))
Message-ID: <20110419003339.GA23985@dastard>
References: <20110405131359.GA14239@redhat.com>
 <20110405225639.GB31057@dastard>
 <20110406153715.GA18777@redhat.com>
 <20110406235039.GL31057@dastard>
 <20110407175537.GD27778@redhat.com>
 <20110411013630.GM30279@dastard>
 <20110415210750.GC28323@redhat.com>
 <20110416030602.GA26191@redhat.com>
 <20110418215844.GA15428@quack.suse.cz>
 <20110418225118.GM30783@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418225118.GM30783@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 06:51:18PM -0400, Vivek Goyal wrote:
> On Mon, Apr 18, 2011 at 11:58:44PM +0200, Jan Kara wrote:
> > On Fri 15-04-11 23:06:02, Vivek Goyal wrote:
> > > On Fri, Apr 15, 2011 at 05:07:50PM -0400, Vivek Goyal wrote:
> > > > How about doing throttling at two layers. All the data throttling is
> > > > done in higher layers and then also retain the mechanism of throttling
> > > > at end device. That way an admin can put a overall limit on such 
> > > > common write traffic. (XFS meta data coming from workqueues, flusher
> > > > thread, kswapd etc).
> > > > 
> > > > Anyway, we can't attribute this IO to per process context/group otherwise
> > > > most likely something will get serialized in higher layers.
> > > >  
> > > > Right now I am speaking purely from IO throttling point of view and not
> > > > even thinking about CFQ and IO tracking stuff.
> > > > 
> > > > This increases the complexity in IO cgroup interface as now we see to have
> > > > four combinations.
> > > > 
> > > >   Global Throttling
> > > >   	Throttling at lower layers
> > > >   	Throttling at higher layers.
> > > > 
> > > >   Per device throttling
> > > >  	 Throttling at lower layers
> > > >   	Throttling at higher layers.
> > > 
> > > Dave, 
> > > 
> > > I wrote above but I myself am not fond of coming up with 4 combinations.
> > > Want to limit it two. Per device throttling or global throttling. Here
> > > are some more thoughts in general about both throttling policy and
> > > proportional policy of IO controller. For throttling policy, I am 
> > > primarily concerned with how to avoid file system serialization issues.
> > > 
> > > Proportional IO (CFQ)
> > > ---------------------
> > > - Make writeback cgroup aware and kernel threads (flusher) which are
> > >   cgroup aware can be marked with a task flag (GROUP_AWARE). If a 
> > >   cgroup aware kernel threads throws IO at CFQ, then IO is accounted
> > >   to cgroup of task who originally dirtied the page. Otherwise we use
> > >   task context to account the IO to.
> > > 
> > >   So any IO submitted by flusher threads will go to respective cgroups
> > >   and higher weight cgroup should be able to do more WRITES.
> > > 
> > >   IO submitted by other kernel threads like kjournald, XFS async metadata
> > >   submission, kswapd etc all goes to thread context and that is root
> > >   group.
> > > 
> > > - If kswapd is a concern then either make kswapd cgroup aware or let
> > >   kswapd use cgroup aware flusher to do IO (Dave Chinner's idea).
> > > 
> > > Open Issues
> > > -----------
> > > - We do not get isolation for meta data IO. In virtualized setup, to
> > >   achieve stronger isolation do not use host filesystem. Export block
> > >   devices into guests.
> > > 
> > > IO throttling
> > > ------------
> > > 
> > > READS
> > > -----
> > > - Do not throttle meta data IO. Filesystem needs to mark READ metadata
> > >   IO so that we can avoid throttling it. This way ordered filesystems
> > >   will not get serialized behind a throttled read in slow group.
> > > 
> > >   May be one can account meta data read to a group and try to use that
> > >   to throttle data IO in same cgroup as a compensation.
> > >  
> > > WRITES
> > > ------
> > > - Throttle tasks. Do not throttle bios. That means that when a task
> > >   submits direct write, let it go to disk. Do the accounting and if task
> > >   is exceeding the IO rate make it sleep. Something similar to
> > >   balance_dirty_pages().
> > > 
> > >   That way, any direct WRITES should not run into any serialization issues
> > >   in ordered mode. We can continue to use blkio_throtle_bio() hook in
> > >   generic_make request().
> > > 
> > > - For buffered WRITES, design a throttling hook similar to
> > >   balance_drity_pages() and throttle tasks according to rules while they
> > >   are dirtying page cache.
> > > 
> > > - Do not throttle buffered writes again at the end device as these have
> > >   been throttled already while writting to page cache. Also throttling
> > >   WRITES at end device will lead to serialization issues with file systems
> > >   in ordered mode.
> > > 
> > > - Cgroup of a IO is always attributed to submitting thread. That way all
> > >   meta data writes will go in root cgroup and remain unthrottled. If one
> > >   is too concerned with lots of meta data IO, then probably one can
> > >   put a throttling rule in root cgroup.
> >   But I think the above scheme basically allows agressive buffered writer
> > to occupy as much of disk throughput as throttling at page dirty time
> > allows. So either you'd have to seriously limit the speed of page dirtying
> > for each cgroup (effectively giving each write properties like direct write)
> > or you'd have to live with cgroup taking your whole disk throughput. Neither
> > of which seems very appealing. Grumble, not that I have a good solution to
> > this problem...
> 
> [CCing lkml]
> 
> Hi Jan,
> 
> I agree that if we do throttling in balance_dirty_pages() to solve the
> issue of file system ordered mode, then we allow flusher threads to
> write data at high rate which is bad. Keeping write throttling at device
> level runs into issues of file system ordered mode write.
> 
> I think problem is that file systems are not cgroup aware (/me runs for
> cover) and we are just trying to work around that hence none of the proposed
> problem solution is not satisfying.
> 
> To get cgroup thing right, we shall have to make whole stack cgroup aware.
> In this case because file system journaling is not cgroup aware and is
> essentially a serialized operation and life becomes hard. Throttling is
> in higher layer is not a good solution and throttling in lower layer
> is not a good solution either.
> 
> Ideally, throttling in generic_make_request() is good as long as all the
> layers sitting above it (file systems, flusher writeback, page cache share)
> can be made cgroup aware. So that if a cgroup is throttled, others cgroup
> are more or less not impacted by throttled cgroup. We have talked about
> making flusher cgroup aware and per cgroup dirty ratio thing, but making
> file system journalling cgroup aware seems to be out of question (I don't
> even know if it is possible to do and how much work does it involve).

If you want to throttle journal operations, then we probably need to
throttle metadata operations that commit to the journal, not the
journal IO itself.  The journal is a shared global resource that all
cgroups use, so throttling journal IO inappropriately will affect
the performance of all cgroups, not just the one that is "hogging"
it.

In XFS, you could probably do this at the transaction reservation
stage where log space is reserved. We know everything about the
transaction at this point in time, and we throttle here already when
the journal is full. Adding cgroup transaction limits to this point
would be the place to do it, but the control parameter for it would
be very XFS specific (i.e. number of transactions/s). Concurrency is
not an issue - the XFS transaction subsystem is only limited in
concurrency by the space available in the journal for reservations
(hundred to thousands of concurrent transactions).

FWIW, this would even allow per-bdi-flusher thread transaction
throttling parameters to be set, so writeback triggered metadata IO
could possibly be limited as well.

I'm not sure whether this is possible with other filesystems, and
ext3/4 would still have the issue of ordered writeback causing much
more writeback than expected at times (e.g. fsync), but I suspect
there is nothing that can really be done about this.

> I will try to summarize the options I have thought about so far.
> 
> - Keep throttling at device level. Do not use it with host filesystems
>   especially with ordered mode. So this is primarily useful in case of
>   virtualization.
> 
>   Or recommend user to not configure too low limits on each cgroup. So
>   once in a while file systems in ordered mode will get serialized and
>   it will impact scalability but will not livelock the system.
> 
> - Move all write throttling in balance_dirty_pages(). This avoids ordering
>   issues but introduce the issue of flusher writting at high speed also
>   people have been looking for limiting traffic from a host coming to
>   shared storage. It does not work very well there as we limit the IO
>   rate coming into page cache and not going out of device. So there
>   will be lot of bursts.
> 
> - Keep throttling at device level and do something magical in file systems
>   journalling code so that it is more parallel and cgroup aware.

I think the third approach is the best long term approach.

FWIW, if you really want cgroups integrated properly into XFS, then
they need to be integrated into the allocator as well so we can push
isolateed cgroups into different, non-contending regions of the
filesystem (similar to filestreams containers). I started on an
general allocation policy framework for XFS a few years ago, but
never had more than a POC prototype. I always intended this
framework to implement (at the time) a cpuset aware policy, so I'm
pretty sure such an approach would work for cgroups, too. Maybe it's
time to dust off that patch set....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
