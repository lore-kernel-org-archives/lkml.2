Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab1LVXzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:55:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62926 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1LVXzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:55:00 -0500
Date: Thu, 22 Dec 2011 15:54:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111222235455.GT17084@google.com>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 03:41:38PM -0800, Andrew Morton wrote:
> All the code I'm looking at assumes that blkio_group.stats_cpu is
> non-zero.  Won't the kerenl just go splat if that allocation failed?
> 
> If the code *does* correctly handle ->stats_cpu == NULL then we have
> options.

I think it's supposed to just skip creating whole blk_group if percpu
allocation fails, so ->stats_cpu of existing groups are guaranteed to
be !%NULL.

> a) Give userspace a new procfs/debugfs file to start stats gathering
>    on a particular cgroup/request_queue pair.  Allocate the stats
>    memory in that.
> 
> b) Or allocate stats_cpu on the first call to blkio_read_stat_cpu()
>    and return zeroes for this first call.

Hmmm... IIRC, the stats aren't exported per cgroup-request_queue pair,
so reads are issued per cgroup.  We can't tell which request_queues
userland is actually interested in.

> c) Or change the low-level code to do
>    blkio_group.want_stats_cpu=true, then test that at the top level
>    after we've determined that blkio_group.stats_cpu is NULL.

Not following.  Where's the "top level"?

> d) Or, worse, punt the allocation into a workqueue thread.

I would much prefer using mempool to this.  They are essentially the
same approach.

Thanks.

-- 
tejun
