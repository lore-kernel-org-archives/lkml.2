Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab1LVXll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:41:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1LVXlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:41:39 -0500
Date: Thu, 22 Dec 2011 15:41:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222154138.d6c583e3.akpm@linux-foundation.org>
In-Reply-To: <20111222232433.GQ17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111222224117.GL17084@google.com>
	<20111222145426.5844df96.akpm@linux-foundation.org>
	<20111222230047.GN17084@google.com>
	<20111222151649.de57746f.akpm@linux-foundation.org>
	<20111222232433.GQ17084@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 15:24:33 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Dec 22, 2011 at 03:16:49PM -0800, Andrew Morton wrote:
> > > The ones allocated in the last patch.  blk_group_cpu_stats.
> > 
> > What last patch.
> > 
> > I can find no occurence of "blk_group_cpu_stats" on linux-kernel or in
> > the kernel tree.
> 
> Sorry it's blkio_group_stats_cpu.  It's in the seventh path in this
> series.
> 
> > > The stats are per cgroup - request_queue pair.  We don't want to
> > > allocate for all of them for each combination as there are
> > > configurations with stupid number of request_queues and silly many
> > > cgroups and #cgroups * #request_queue * #cpus can be huge.  So, we
> > > want on-demand allocation.  While the stats are important, they are
> > > not critical and allocations can be opportunistic.  If the allocation
> > > fails this time, we can try it for the next time.
> > 
> > Without code to look at I am at a loss.
> 
> block/blk-cgroup.c blk-throttle.c cfq-iosched.c.  Have fun.
> 
> > request_queues are allocated in blk_alloc_queue_node(), which uses
> > GFP_KERNEL (and also mysteriously takes a gfp_t arg).
> 
> Yeah, sure, we *can* allocate everything for every combination when
> either request_queue or cgroup comes up.  That's the thing I tried to
> explain in the above quoted paragraph.
> 

All the code I'm looking at assumes that blkio_group.stats_cpu is
non-zero.  Won't the kerenl just go splat if that allocation failed?

If the code *does* correctly handle ->stats_cpu == NULL then we have
options.

a) Give userspace a new procfs/debugfs file to start stats gathering
   on a particular cgroup/request_queue pair.  Allocate the stats
   memory in that.

b) Or allocate stats_cpu on the first call to blkio_read_stat_cpu()
   and return zeroes for this first call.

c) Or change the low-level code to do
   blkio_group.want_stats_cpu=true, then test that at the top level
   after we've determined that blkio_group.stats_cpu is NULL.

d) Or, worse, punt the allocation into a workqueue thread.

Note that all these option will permit us to use GFP_KERNEL, which is
better.

Note that a) and b) means that users get control over whether these
stats are accumulated at all, so many won't incur needless memory and
CPU consumption.

I think I like b).  Fix the code so it doesn't oops when ->stats_cpu is
NULL, then turn on stats gathering the first time someone tries to read
the stats.

(Someone appears to have misspelled "throttle" as "throtl" for no
apparent reason about 1000 times.  Sigh.)


