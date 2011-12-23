Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1LWPRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 10:17:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298Ab1LWPRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 10:17:33 -0500
Date: Fri, 23 Dec 2011 10:17:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20111223151725.GC16818@redhat.com>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 05:14:32PM -0800, Andrew Morton wrote:

[..]
> Separately...
> 
> Mixing mempools and percpu_alloc() in the proposed fashion seems a
> pretty poor fit.  mempools are for high-frequency low-level allocations
> which have key characteristics: there are typically a finite number of
> elements in flight and we *know* that elements are being freed in a
> timely manner.
> 
> This doesn't fit with percpu_alloc(), which is a very heavyweight
> operation requiring GFP_KERNEL and it doesn't fit with
> blkio_group_stats_cpu because blkio_group_stats_cpu does not have the
> "freed in a timely manner" behaviour.
> 
> To resolve these things you've added the workqueue to keep the pool
> populated, which turns percpu_mempool into a quite different concept
> which happens to borrow some mempool code (not necessarily a bad thing).
> This will result in some memory wastage, keeping that pool full.

Tejun seems to have created one global pool for all the device with
minimum number of objects at 8. So keeping just 8 objects aside for
the whole system is not a significant memory wastage, IMHO. This is
much better then creating all the possible cgroup, device pair cgroup
irrespective of the fact whether IO is happening on that pair or not.

> 
> More significantly, it's pretty unreliable: if the allocations outpace
> the kernel thread's ability to refill the pool, all we can do is to
> wait for the kernel thread to do some work.  But we're holding
> low-level locks while doing that wait, which will block the kernel
> thread.  Deadlock.

Sorry, I did not understand this point. In the IO path we don't wait
for kernel thread to do some work. If there are no elements in the pool,
we will simply return and not create the group and IO will be accounted to
root group. Once the new IO comes in, it will try again and if by
that time worker thread succeeded in filling the pool, we will allocate
the group.

So in tight memory situation we will not account the IO to actual cgroup
but to root cgroup. Once the memory situation eases, IO will be acccounted
to right cgroup.

Can't see any deadlock happening. Did I miss something?

Thanks
Vivek
