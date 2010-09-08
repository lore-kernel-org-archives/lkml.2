Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab0IHKFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:05:09 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:48755 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342Ab0IHKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:05:07 -0400
Date: Wed, 8 Sep 2010 20:05:03 +1000
From: Dave Chinner <david@fromorbit.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc3] Workqueues, XFS, dependencies and deadlocks
Message-ID: <20100908100503.GX705@dastard>
References: <20100907072954.GM705@dastard>
 <4C86003B.6090706@kernel.org>
 <20100907100108.GN705@dastard>
 <4C861582.6080102@kernel.org>
 <4C862F8E.7030507@kernel.org>
 <20100908082249.GT705@dastard>
 <4C874E90.5040405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C874E90.5040405@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 10:51:28AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 09/08/2010 10:22 AM, Dave Chinner wrote:
> > Ok, it looks as if the WQ_HIGHPRI is all that was required to avoid
> > the log IO completion starvation livelocks. I haven't yet pulled
> > the tree below, but I've now created about a billion inodes without
> > seeing any evidence of the livelock occurring.
> > 
> > Hence it looks like I've been seeing two livelocks - one caused by
> > the VM that Mel's patches fix, and one caused by the workqueue
> > changeover that is fixed by the WQ_HIGHPRI change.
> > 
> > Thanks for you insights, Tejun - I'll push the workqueue change
> > through the XFS tree to Linus.
> 
> Great, BTW, I have several questions regarding wq usage in xfs.
> 
> * Do you think @max_active > 1 could be useful for xfs?  If most works
>   queued on the wq are gonna contend for the same (blocking) set of
>   resources, it would just make more threads sleeping on those
>   resources but otherwise it would help reducing execution latency a
>   lot.

It may indeed help, but I can't really say much more than that right
now. I need a deeper understanding of the impact of increasing
max_active (I have a basic understanding now) before I could say for
certain.

> * xfs_mru_cache is a singlethread workqueue.  Do you specifically need
>   singlethreadedness (strict ordering of works) or is it just to avoid
>   creating dedicated per-cpu workers?  If the latter, there's no need
>   to use singlethread one anymore.

Didn't need per-cpu workers, so could probably drop it now.

> * Are all four workqueues in xfs used during memory allocation?  With
>   the new implementation, the reasons to have dedicated wqs are,

The xfsdatad, xfslogd and xfsconvertd are all in the memory reclaim
path. That is, they need to be able to run and make progress when
memory is low because if the IO does not complete, pages under IO
will never complete the transition from dirty to clean. Hence they
are not in the direct memory allocation path, but they are
definitely an important part of the memory reclaim path that
operates in low memory conditions.

>   - Forward progress guarantee in the memory allocation path.  Each
>     workqueue w/ WQ_RESCUER has _one_ rescuer thread reserved for
>     execution of works on the specific wq, which will be used under
>     memory pressure to make forward progress.

That, to me, says they all need a rescuer thread because they all
need to be able to make forward progress in OOM conditions.

>   - A wq is a flush domain.  You can flush works on it as a group.

We do that as well for the above workqueues as well to ensure
correct sync(1), freeze and unmount behaviour (see
xfs_flush_buftarg()).

>   - A wq is also a attribute domain.  If certain work items need to be
>     handled differently (highpri, cpu intensive, execution ordering,
>     etc...), they can be queued to a wq w/ those attributes specified.

And we already know that that xfslogd_workqueue needs the WQ_HIGHPRI
flag....

>   Maybe some of those workqueues can drop WQ_RESCUER or merged or just
>   use the system workqueue?

Maybe the mru wq can use the system wq, but I'm really opposed to
merging XFS wqs with system work queues simply from a debugging POV.
I've lost count of the number of times I've walked the IO completion
queueѕ with a debugger or crash dump analyser to try to work out if
missing IO that wedged the filesystem got stuck on the completion
queue. If I want to be able to say "the IO was lost by a lower
layer", then I have to be able to confirm it is not stuck in a
completion queue. That much harder if I don't know what the work
container objects on the queue are....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
