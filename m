Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1LWBLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:11:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab1LWBLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:11:31 -0500
Date: Thu, 22 Dec 2011 17:14:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222171432.e429c041.akpm@linux-foundation.org>
In-Reply-To: <20111222235455.GT17084@google.com>
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
	<20111222235455.GT17084@google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 15:54:55 -0800 Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Dec 22, 2011 at 03:41:38PM -0800, Andrew Morton wrote:
> > All the code I'm looking at assumes that blkio_group.stats_cpu is
> > non-zero.  Won't the kerenl just go splat if that allocation failed?
> > 
> > If the code *does* correctly handle ->stats_cpu == NULL then we have
> > options.
> 
> I think it's supposed to just skip creating whole blk_group if percpu
> allocation fails, so ->stats_cpu of existing groups are guaranteed to
> be !%NULL.

What is the role of ->elevator_set_req_fn()?  And when is it called?

It seems that we allocate the blkio_group within the
elevator_set_req_fn() context?

(Your stack trace in the "block: fix deadlock through percpu allocation
in blk-cgroup" changelog is some unuseful ACPI thing.  It would be
better if it were to show the offending trace into the block code).

> > a) Give userspace a new procfs/debugfs file to start stats gathering
> >    on a particular cgroup/request_queue pair.  Allocate the stats
> >    memory in that.
> > 
> > b) Or allocate stats_cpu on the first call to blkio_read_stat_cpu()
> >    and return zeroes for this first call.
> 
> Hmmm... IIRC, the stats aren't exported per cgroup-request_queue pair,
> so reads are issued per cgroup.  We can't tell which request_queues
> userland is actually interested in.

Doesn't matter.  The stats are allocated on a per-blkio_group basis. 
blkio_read_stat_cpu() is passed the blkio_group.  Populate ->stats_cpu
there.

Advantages:

- performs allocation with the more reliable GPF_KERNEL

- avoids burdening users with the space and CPU overhead when they're
  not using the stats 

- avoids adding more code into the mempool code.

> > c) Or change the low-level code to do
> >    blkio_group.want_stats_cpu=true, then test that at the top level
> >    after we've determined that blkio_group.stats_cpu is NULL.
> 
> Not following.  Where's the "top level"?

Somewhere appropriate where we can use GFP_KERNEL.  ie: the correct
context for percpu_alloc().


Separately...

Mixing mempools and percpu_alloc() in the proposed fashion seems a
pretty poor fit.  mempools are for high-frequency low-level allocations
which have key characteristics: there are typically a finite number of
elements in flight and we *know* that elements are being freed in a
timely manner.

This doesn't fit with percpu_alloc(), which is a very heavyweight
operation requiring GFP_KERNEL and it doesn't fit with
blkio_group_stats_cpu because blkio_group_stats_cpu does not have the
"freed in a timely manner" behaviour.

To resolve these things you've added the workqueue to keep the pool
populated, which turns percpu_mempool into a quite different concept
which happens to borrow some mempool code (not necessarily a bad thing).
This will result in some memory wastage, keeping that pool full.

More significantly, it's pretty unreliable: if the allocations outpace
the kernel thread's ability to refill the pool, all we can do is to
wait for the kernel thread to do some work.  But we're holding
low-level locks while doing that wait, which will block the kernel
thread.  Deadlock.
