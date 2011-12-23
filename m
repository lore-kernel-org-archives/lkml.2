Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1LWBVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1LWBVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:21:22 -0500
Date: Thu, 22 Dec 2011 20:21:12 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20111223012112.GB12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111222224117.GL17084@google.com>
 <20111222145426.5844df96.akpm@linux-foundation.org>
 <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
 <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222154138.d6c583e3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 03:41:38PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 15:24:33 -0800
> Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > On Thu, Dec 22, 2011 at 03:16:49PM -0800, Andrew Morton wrote:
> > > > The ones allocated in the last patch.  blk_group_cpu_stats.
> > > 
> > > What last patch.
> > > 
> > > I can find no occurence of "blk_group_cpu_stats" on linux-kernel or in
> > > the kernel tree.
> > 
> > Sorry it's blkio_group_stats_cpu.  It's in the seventh path in this
> > series.
> > 
> > > > The stats are per cgroup - request_queue pair.  We don't want to
> > > > allocate for all of them for each combination as there are
> > > > configurations with stupid number of request_queues and silly many
> > > > cgroups and #cgroups * #request_queue * #cpus can be huge.  So, we
> > > > want on-demand allocation.  While the stats are important, they are
> > > > not critical and allocations can be opportunistic.  If the allocation
> > > > fails this time, we can try it for the next time.
> > > 
> > > Without code to look at I am at a loss.
> > 
> > block/blk-cgroup.c blk-throttle.c cfq-iosched.c.  Have fun.
> > 
> > > request_queues are allocated in blk_alloc_queue_node(), which uses
> > > GFP_KERNEL (and also mysteriously takes a gfp_t arg).
> > 
> > Yeah, sure, we *can* allocate everything for every combination when
> > either request_queue or cgroup comes up.  That's the thing I tried to
> > explain in the above quoted paragraph.
> > 
> 
> All the code I'm looking at assumes that blkio_group.stats_cpu is
> non-zero.  Won't the kerenl just go splat if that allocation failed?

If per cpu stat allocation fails, we fail the whole group allocation 
and IO is accounted to root group and is tried again when new IO
request comes in.

Look at throtl_alloc_tg() in block/blk-throttle.c

> 
> If the code *does* correctly handle ->stats_cpu == NULL then we have
> options.
> 
> a) Give userspace a new procfs/debugfs file to start stats gathering
>    on a particular cgroup/request_queue pair.  Allocate the stats
>    memory in that.
> 
> b) Or allocate stats_cpu on the first call to blkio_read_stat_cpu()
>    and return zeroes for this first call.

But the purpose of stats is that they are gathered even if somebody
has not read them even once? So if I create a cgroup and put some
task into it which does some IO, I think stat collection should start
immediately without user taking any action. Forcing the user to first
read a stat before the collection starts is kind of odd to me.

> 
> c) Or change the low-level code to do
>    blkio_group.want_stats_cpu=true, then test that at the top level
>    after we've determined that blkio_group.stats_cpu is NULL.
> 
> d) Or, worse, punt the allocation into a workqueue thread.

I implemented a patch to punt the allocation using a worker thread. Tejun
did not like it. I personally think that it is less intrusive to fix this
specific problem.

https://lkml.org/lkml/2011/12/19/291

> 
> Note that all these option will permit us to use GFP_KERNEL, which is
> better.
> 
> Note that a) and b) means that users get control over whether these
> stats are accumulated at all, so many won't incur needless memory and
> CPU consumption.
> 
> I think I like b).  Fix the code so it doesn't oops when ->stats_cpu is
> NULL, then turn on stats gathering the first time someone tries to read
> the stats.
> 
> (Someone appears to have misspelled "throttle" as "throtl" for no
> apparent reason about 1000 times.  Sigh.)

That someone would be me. I thought that throtl communicates the meaning
and keeps the length of all the strings relatively short. But if it does
not look good, I can change it.

Thanks
Vivek
