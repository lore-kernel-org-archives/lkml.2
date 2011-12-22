Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1LVXA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:00:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43343 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab1LVXAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:00:52 -0500
Date: Thu, 22 Dec 2011 15:00:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111222230047.GN17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111222224117.GL17084@google.com>
 <20111222145426.5844df96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222145426.5844df96.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Dec 22, 2011 at 02:54:26PM -0800, Andrew Morton wrote:
> > These stats are userland visible and quite useful ones if blkcg is in
> > use.  I don't really see how these can be removed.
> 
> What stats?

The ones allocated in the last patch.  blk_group_cpu_stats.

> And why are we doing percpu *allocation* so deep in the code?  You mean
> we're *creating* stats counters on an IO path?  Sounds odd.  Where is
> this code?

Please read below.

> > > > > Or how about we fix the percpu memory allocation code so that it
> > > > > propagates the gfp flags, then delete this patchset?
> > > > 
> > > > Oh, no, this is gonna make things *way* more complex.  I tried.
> > > 
> > > But there's a difference between fixing a problem and working around it.
> > 
> > Yeah, that was my first direction too.  The reason why percpu can't do
> > NOIO is the same one why vmalloc can't do it.  It reaches pretty deep
> > into page table code and I don't think doing all that churning is
> > worthwhile or even desirable.  An altnernative approach would be
> > implementing transparent front buffer to percpu allocator, which I
> > *might* do if there really are more of these users, but I think
> > keeping percpu allocator painful to use from reclaim context isn't
> > such a bad idea.
> > 
> > There have been multiple requests for atomic allocation and they all
> > have been successfully pushed back, but IMHO this is a valid one and I
> > don't see a better way around the problem, so while I agree using
> > mempool for this is a workaround, I think it is a right choice, for
> > now, anyway.
> 
> For starters, doing pagetable allocation on the I/O path sounds nutty.
> 
> Secondly, GFP_NOIO is a *weaker* allocation mode than GFP_KERNEL.  By
> permitting it with this patchset, we have a kernel which is more likely
> to get oom failures.  Fixing the kernel to not perform GFP_NOIO
> allocations for these counters will result in a more robust kernel. 
> This is a good thing, which improves the kernel while avoiding adding
> more compexity elsewhere.
> 
> This patchset is the worst option and we should try much harder to avoid
> applying it!

The stats are per cgroup - request_queue pair.  We don't want to
allocate for all of them for each combination as there are
configurations with stupid number of request_queues and silly many
cgroups and #cgroups * #request_queue * #cpus can be huge.  So, we
want on-demand allocation.  While the stats are important, they are
not critical and allocations can be opportunistic.  If the allocation
fails this time, we can try it for the next time.

So, yeah, the suggested solution fits the problem.  If you have a
better idea, please don't be shy.

> > Yeah, some of PF_* flags already carry related role information.  I'm
> > not too sure how much pushing the whole thing into task_struct would
> > change tho.  We would need push/popping.  It could be simpler in some
> > cases but in essence wouldn't we have just relocated the position of
> > parameter?
> 
> The code would get considerably simpler.  The big benefit comes when
> you have deep call stacks - we're presently passing a gfp_t down five
> layers of function call while none of the intermediate functions even
> use the thing - they just pass it on to the next guy.  Pass it via the
> task_struct and all that goes away.  It would make maintenance a lot
> easier - at present if you want to add a new kmalloc() to a leaf
> function you need to edit all five layers of caller functions.

Hmmm... yeah, the relocation could save a lot of hassle, I suppose.

Thanks.

-- 
tejun
