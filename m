Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab1LUR0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:26:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53732 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1LUR0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:26:39 -0500
Date: Wed, 21 Dec 2011 09:26:32 -0800
From: Tejun Heo <tj@kernel.org>
To: tip-bot for Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        pjt@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] sched: Fix cgroup movement of forking process
Message-ID: <20111221172632.GD9213@google.com>
References: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
 <tip-4fc420c91f53e0a9f95665c6b14a1983716081e7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-4fc420c91f53e0a9f95665c6b14a1983716081e7@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Wed, Dec 21, 2011 at 03:44:14AM -0800, tip-bot for Daisuke Nishimura wrote:
> sched: Fix cgroup movement of forking process
> 
> There is a small race between task_fork_fair() and sched_move_task(),
> which is trying to move the parent.
> 
>         task_fork_fair()                 sched_move_task()
> --------------------------------+---------------------------------
>   cfs_rq = task_cfs_rq(current)
>     -> cfs_rq is the "old" one.
>   curr = cfs_rq->curr
>     -> curr is set to the parent.
>                                     task_rq_lock()
>                                     dequeue_task()
>                                       ->parent.se.vruntime -= (old)cfs_rq->min_vruntime
>                                     enqueue_task()
>                                       ->parent.se.vruntime += (new)cfs_rq->min_vruntime
>                                     task_rq_unlock()
>   raw_spin_lock_irqsave(rq->lock)
>   se->vruntime = curr->vruntime
>     -> vruntime of the child is set to that of the parent
>        which has already been updated by sched_move_task().
>   se->vruntime -= (old)cfs_rq->min_vruntime.
>   raw_spin_unlock_irqrestore(rq->lock)
> 
> As a result, vruntime of the child becomes far bigger than expected,
> if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
> 
> This patch fixes this problem by setting "cfs_rq" and "curr" after
> holding the rq->lock.

The race shouldn't happen with threadgroup locking scheduled to be
merged for the coming merge window.  sched_fork() and cgroup migration
become exclusive and won't happen concurrently.  Would still make
sense for -stable tho.

Thanks.

-- 
tejun
