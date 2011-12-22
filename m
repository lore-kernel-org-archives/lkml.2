Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab1LVByu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:54:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36117 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1LVBys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:54:48 -0500
Date: Thu, 22 Dec 2011 02:54:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: tip-bot for Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        pjt@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:sched/core] sched: Fix cgroup movement of forking process
Message-ID: <20111222015440.GM17668@somewhere>
References: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
 <tip-4fc420c91f53e0a9f95665c6b14a1983716081e7@git.kernel.org>
 <20111221172632.GD9213@google.com>
 <20111221173733.GF9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221173733.GF9213@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 09:37:33AM -0800, Tejun Heo wrote:
> (cc'ing Frederic)
> 
> On Wed, Dec 21, 2011 at 09:26:32AM -0800, Tejun Heo wrote:
> > Hello, guys.
> > 
> > On Wed, Dec 21, 2011 at 03:44:14AM -0800, tip-bot for Daisuke Nishimura wrote:
> > > sched: Fix cgroup movement of forking process
> > > 
> > > There is a small race between task_fork_fair() and sched_move_task(),
> > > which is trying to move the parent.
> > > 
> > >         task_fork_fair()                 sched_move_task()
> > > --------------------------------+---------------------------------
> > >   cfs_rq = task_cfs_rq(current)
> > >     -> cfs_rq is the "old" one.
> > >   curr = cfs_rq->curr
> > >     -> curr is set to the parent.
> > >                                     task_rq_lock()
> > >                                     dequeue_task()
> > >                                       ->parent.se.vruntime -= (old)cfs_rq->min_vruntime
> > >                                     enqueue_task()
> > >                                       ->parent.se.vruntime += (new)cfs_rq->min_vruntime
> > >                                     task_rq_unlock()
> > >   raw_spin_lock_irqsave(rq->lock)
> > >   se->vruntime = curr->vruntime
> > >     -> vruntime of the child is set to that of the parent
> > >        which has already been updated by sched_move_task().
> > >   se->vruntime -= (old)cfs_rq->min_vruntime.
> > >   raw_spin_unlock_irqrestore(rq->lock)
> > > 
> > > As a result, vruntime of the child becomes far bigger than expected,
> > > if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
> > > 
> > > This patch fixes this problem by setting "cfs_rq" and "curr" after
> > > holding the rq->lock.
> > 
> > The race shouldn't happen with threadgroup locking scheduled to be
> > merged for the coming merge window.  sched_fork() and cgroup migration
> > become exclusive and won't happen concurrently.  Would still make
> > sense for -stable tho.
> 
> I retract that.  sched_move_task() can also be called from
> cgroup_exit() which is outside of threadgroup locking.
> 
> Frederic, so, it seems we actually have race conditions here.  I
> really wish cgroup made sure that things like this can't happen even
> if we pay a bit of overhead in relatively cold paths.  I could be
> being unrealistic tho.  Any ideas?

Hmm, I'm a bit confused about the issue. But doesn't this patch fix the issue?

Also the parent can't be calling sched_fork() and cgroup_exit() at
the same time.

Or am I missing something?
