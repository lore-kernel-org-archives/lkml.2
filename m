Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1L0SeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:34:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36780 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1L0SeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:34:09 -0500
Date: Tue, 27 Dec 2011 10:34:02 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111227183402.GF17712@google.com>
References: <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111222224117.GL17084@google.com>
 <20111222145426.5844df96.akpm@linux-foundation.org>
 <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
 <20111222232433.GQ17084@google.com>
 <20111222154138.d6c583e3.akpm@linux-foundation.org>
 <20111222235455.GT17084@google.com>
 <20111222171432.e429c041.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222171432.e429c041.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens)

Hello, Andrew.

On Thu, Dec 22, 2011 at 05:14:32PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 15:54:55 -0800 Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > On Thu, Dec 22, 2011 at 03:41:38PM -0800, Andrew Morton wrote:
> > > All the code I'm looking at assumes that blkio_group.stats_cpu is
> > > non-zero.  Won't the kerenl just go splat if that allocation failed?
> > > 
> > > If the code *does* correctly handle ->stats_cpu == NULL then we have
> > > options.
> > 
> > I think it's supposed to just skip creating whole blk_group if percpu
> > allocation fails, so ->stats_cpu of existing groups are guaranteed to
> > be !%NULL.
> 
> What is the role of ->elevator_set_req_fn()?  And when is it called?

It allocates elevator specific data for a request and is called during
request construction, IOW, on IO issue path.

> It seems that we allocate the blkio_group within the
> elevator_set_req_fn() context?

The allocation may happen through any subsystem which implements blkcg
policy - at the moment, either blk-throttle or cfq-iosched.
elevator_set_req_fn() is for cfq-iosched.  In most cases, the user is
expected to be in IO submission path as that's the only place we can
identify active blkcg - request_queue pairs and we don't want to
create blk_group for all possible combinations.

> > Hmmm... IIRC, the stats aren't exported per cgroup-request_queue pair,
> > so reads are issued per cgroup.  We can't tell which request_queues
> > userland is actually interested in.
> 
> Doesn't matter.  The stats are allocated on a per-blkio_group basis. 
> blkio_read_stat_cpu() is passed the blkio_group.  Populate ->stats_cpu
> there.

Hmmm.... so you wanna break up blkg and its per-cpu stats allocation.

One problem I see is that there's no reliable way to tell when the
stats for specific pair has started.  ie. Reading the stats file from
userland shouldn't create blkg for all matching combinations.  It
should only walk the blkgs which are created by actual IOs.  So, blkg
stat counting would start on the first stats read after IOs happen for
that specific pair and there wouldn't be any way for userland to
discover whether stat gathering is in progress or not.  Ugh... that's
just nasty.  Jens, what do you think?

> > > c) Or change the low-level code to do
> > >    blkio_group.want_stats_cpu=true, then test that at the top level
> > >    after we've determined that blkio_group.stats_cpu is NULL.
> > 
> > Not following.  Where's the "top level"?
> 
> Somewhere appropriate where we can use GFP_KERNEL.  ie: the correct
> context for percpu_alloc().

There's no natural "top level" for block layer.  It either has to hook
off from userland access as you suggested above or we should
explicitly defer to work item.  That of course is possible but that is
worse than making use of existing infrastructure to solve the problem.
Note that explicitly deferring to wq is basically more specialized
version of using wq backed mempool and would take more code.

> Separately...
> 
> Mixing mempools and percpu_alloc() in the proposed fashion seems a
> pretty poor fit.  mempools are for high-frequency low-level allocations
> which have key characteristics: there are typically a finite number of
> elements in flight and we *know* that elements are being freed in a
> timely manner.

mempool is a pool of memory allocations.  Nothing more, nothing less.

> This doesn't fit with percpu_alloc(), which is a very heavyweight
> operation requiring GFP_KERNEL and it doesn't fit with
> blkio_group_stats_cpu because blkio_group_stats_cpu does not have the
> "freed in a timely manner" behaviour.

And, yes, it is a different usage of the same mechanism.  Nothing
changes for the mechanism itself (other than the silly GFP_WAIT
behavior which is buggy anyway).

> To resolve these things you've added the workqueue to keep the pool
> populated, which turns percpu_mempool into a quite different concept
> which happens to borrow some mempool code (not necessarily a bad thing).
> This will result in some memory wastage, keeping that pool full.

The wq thing can be moved into block layer if that's the bothering
part, but given this mode of usage would be the prevalent one for
percpu mempool, I think it would be better to put it there for obvious
reasons.

It's the same pool of allocations.  If you don't have inter-item
dependency and allocated items are guaranteed to be returned in finite
amount of time, it guarantees allocation attempts would succeed in
finite amount of time.  If you put in items in a context and take it
out in a different one, it serves as allocation buffer.

> More significantly, it's pretty unreliable: if the allocations outpace
> the kernel thread's ability to refill the pool, all we can do is to
> wait for the kernel thread to do some work.  But we're holding
> low-level locks while doing that wait, which will block the kernel
> thread.  Deadlock.

Ummm... if you try to allocate with GFP_KERNEL from IO path, deadlock
of course is possible.  That's the *whole* reason why allocation
buffering is used there.  It's filled from GFP_KERNEL context and
consumed from GFO_NOIO and as pointed out multiple times the allocaion
there is infrequent and can be opportunistic.  Sans the use of small
buffering items, this isn't any different from deferring allocation to
different context.  There's no guarantee when that allocation would
happen but in practice both will be reliable enough for the given use
case.

I don't necessarily insist on using mempool here but all the given
objections seem bogus to me.  The amount of code added is minimal and
straight-forward.  It doesn't change what mempool is or what it does
at all and the usage fits the problem to be solved.  I can't really
understand what the objection is about.

Thanks.

-- 
tejun
