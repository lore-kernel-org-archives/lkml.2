Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915Ab0J2UUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:20:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761895Ab0J2UU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:20:26 -0400
Date: Fri, 29 Oct 2010 13:19:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg Thelen <gthelen@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v4 00/11] memcg: per cgroup dirty page accounting
Message-Id: <20101029131946.5905d244.akpm@linux-foundation.org>
In-Reply-To: <1288336154-23256-1-git-send-email-gthelen@google.com>
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 00:09:03 -0700
Greg Thelen <gthelen@google.com> wrote:

This is cool stuff - it's been a long haul.  One day we'll be
nearly-finished and someone will write a book telling people how to use
it all and lots of people will go "holy crap".  I hope.

> Limiting dirty memory is like fixing the max amount of dirty (hard to reclaim)
> page cache used by a cgroup.  So, in case of multiple cgroup writers, they will
> not be able to consume more than their designated share of dirty pages and will
> be forced to perform write-out if they cross that limit.
> 
> The patches are based on a series proposed by Andrea Righi in Mar 2010.
> 
> Overview:
> - Add page_cgroup flags to record when pages are dirty, in writeback, or nfs
>   unstable.
> 
> - Extend mem_cgroup to record the total number of pages in each of the 
>   interesting dirty states (dirty, writeback, unstable_nfs).  
> 
> - Add dirty parameters similar to the system-wide  /proc/sys/vm/dirty_*
>   limits to mem_cgroup.  The mem_cgroup dirty parameters are accessible
>   via cgroupfs control files.

Curious minds will want to know what the default values are set to and
how they were determined.

> - Consider both system and per-memcg dirty limits in page writeback when
>   deciding to queue background writeback or block for foreground writeback.
> 
> Known shortcomings:
> - When a cgroup dirty limit is exceeded, then bdi writeback is employed to
>   writeback dirty inodes.  Bdi writeback considers inodes from any cgroup, not
>   just inodes contributing dirty pages to the cgroup exceeding its limit.  

yup.  Some broader discussion of the implications of this shortcoming
is needed.  I'm not sure where it would be placed, though. 
Documentation/ for now, until you write that book.

> - When memory.use_hierarchy is set, then dirty limits are disabled.  This is a
>   implementation detail.

So this is unintentional, and forced upon us my the present implementation?

>  An enhanced implementation is needed to check the
>   chain of parents to ensure that no dirty limit is exceeded.

How important is it that this be fixed?

And how feasible would that fix be?  A linear walk up the hierarchy
list?  More than that?

> Performance data:
> - A page fault microbenchmark workload was used to measure performance, which
>   can be called in read or write mode:
>         f = open(foo. $cpu)
>         truncate(f, 4096)
>         alarm(60)
>         while (1) {
>                 p = mmap(f, 4096)
>                 if (write)
> 			*p = 1
> 		else
> 			x = *p
>                 munmap(p)
>         }
> 
> - The workload was called for several points in the patch series in different
>   modes:
>   - s_read is a single threaded reader
>   - s_write is a single threaded writer
>   - p_read is a 16 thread reader, each operating on a different file
>   - p_write is a 16 thread writer, each operating on a different file
> 
> - Measurements were collected on a 16 core non-numa system using "perf stat
>   --repeat 3".  The -a option was used for parallel (p_*) runs.
> 
> - All numbers are page fault rate (M/sec).  Higher is better.
> 
> - To compare the performance of a kernel without non-memcg compare the first and
>   last rows, neither has memcg configured.  The first row does not include any
>   of these memcg patches.
> 
> - To compare the performance of using memcg dirty limits, compare the baseline
>   (2nd row titled "w/ memcg") with the the code and memcg enabled (2nd to last
>   row titled "all patches").
> 
>                            root_cgroup                    child_cgroup
>                  s_read s_write p_read p_write   s_read s_write p_read p_write
> mmotm w/o memcg   0.428  0.390   0.429  0.388
> mmotm w/ memcg    0.411  0.378   0.391  0.362     0.412  0.377   0.385  0.363
> all patches       0.384  0.360   0.370  0.348     0.381  0.363   0.368  0.347
> all patches       0.431  0.402   0.427  0.395
>   w/o memcg

afaict this benchmark has demonstrated that the changes do not cause an
appreciable performance regression in terms of CPU loading, yes?

Can we come up with any tests which demonstrate the _benefits_ of the
feature?

