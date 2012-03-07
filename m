Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab2CGXFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:05:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2CGXFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:05:51 -0500
Date: Wed, 7 Mar 2012 15:05:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, hughd@google.com,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        linux-kernel@vger.kernel.org, dpshah@google.com, ctalbott@google.com,
        rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120307150549.955d6f9c.akpm@linux-foundation.org>
In-Reply-To: <20120307145556.GA11262@redhat.com>
References: <20120225214421.GA3401@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120227031146.GA25187@redhat.com>
	<20120227091141.GG3401@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120227194321.GF27677@redhat.com>
	<20120229173639.GB5930@redhat.com>
	<20120305221321.GF1263@google.com>
	<20120306210954.GF32148@redhat.com>
	<20120306132034.ecaf8b20.akpm@linux-foundation.org>
	<20120306213437.GG32148@redhat.com>
	<20120306135531.828ca78e.akpm@linux-foundation.org>
	<20120307145556.GA11262@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 09:55:56 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Mar 06, 2012 at 01:55:31PM -0800, Andrew Morton wrote:
> 
> [..]
> > > > hoo boy that looks like an infinite loop.  What's going on here?
> > > 
> > > If allocation fails, I am trying to allocate it again in infinite loop.
> > > What should I do? Try it after sleeping a bit? Or give up after certain
> > > number of tries? This is in worker thread context though, so main IO path
> > > is not impacted.
> > 
> > On a non-preemptible unprocessor kernel it's game over, isn't it? 
> > Unless someone frees some memory from interrupt context it is time for
> > the Big Red Button.
> 
> Yes.  Its an issue on non-preemptible UP kernels. I changed the logic to
> msleep(10) before retrying. Tested on UP non-preemptible kernel with
> always failing allocation and things are fine.
> 
> > 
> > I'm not sure what to suggest, really - if an allocation failed then
> > there's nothing the caller can reliably do to fix that.  The best
> > approach is to fail all the way back to userspace with -ENOMEM.
> 
> As user space is not waiting for this allocation, -ENOMEM is really
> not an option.

Well, it would have to be -EIO, because the block layer is stupid about
errnos.

> > 
> > In this context I suppose you could drop a warning into the logs then
> > bale out and retry on the next IO attempt.
> 
> Yes, that also can be done. I found msleep(10) to be easier solution then
> remvoing group from list, and trying again when new IO comes in. Is this
> acceptable?

Seems a bit sucky to me.  That allocation isn't *needed* for the kernel
to be able to complete the IO operation.  It's just that we
(mis)designed things so that we're dependent upon it succeeding.  Sigh.

msleep() will cause that kernel thread to contribute to load average
when it is in this state.  Intentional?

> [..]
> > 
> > btw, speaking of uniprocessor: please do perform a uniprocessor build
> > and see what impact the patch has upon the size(1) output for the .o
> > files.  We should try to minimize the pointless bloat for the UP
> > kernel.
> 
> But this logic is required both for UP and SMP kernels. So bloat on UP
> is not unnecessary?

UP doesn't need a per-cpu variable, hence it doesn't need to run
alloc_per_cpu() at all.  For UP all we need to do is to aggregate a
`struct blkio_group_stats' within `struct blkg_policy_data'?

This could still be done with suitable abstraction and wrappers. 
Whether that's desirable depends on how fat the API ends up, I guess.

> I ran size(1) on block/blk-cgroup.o with and without the patch and I can
> see some bloat.
> 
> Without patch(UP kernel)
> ------------------------
> # size block/blk-cgroup.o
>    text    data     bss     dec     hex filename
>   12950    5248      50   18248    4748 block/blk-cgroup.o
> 
> With patch(UP kernel)
> ------------------------
> # size block/blk-cgroup.o
>    text    data     bss     dec     hex filename
>   13316    5376      58   18750    493e block/blk-cgroup.o

Yeah.

The additional text imposes runtime overhead, but there's also
additional cost from things like the extra pointer hops to access the
per-cpu data.

