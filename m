Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab1ASTpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:45:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab1ASTpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:45:18 -0500
Date: Wed, 19 Jan 2011 20:37:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 17/18] sched: Move the second half of ttwu() to
	the remote cpu
Message-ID: <20110119193714.GA16003@redhat.com>
References: <20110104145929.772813816@chello.nl> <20110104150103.164045216@chello.nl> <20110105210754.GA2579@redhat.com> <1294326577.2016.373.camel@laptop> <20110107152207.GA16341@redhat.com> <1295368688.30950.925.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295368688.30950.925.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18, Peter Zijlstra wrote:
>
> On Fri, 2011-01-07 at 16:22 +0100, Oleg Nesterov wrote:
>
> > Why sched_fork() does set_task_cpu() ? Just curious, it seems
> > that wake_up_new_task() does all we need.
>
> The only reason I can come up with is to properly initialize the
> data-structures before make the thing visible, by the time
> wake_up_new_task() comes along, its already fully visible.

Ah, thanks, this makes sense.

> > Doesn't __migrate_task() need pi_lock? Consider:
> >
> > ...
>
> Drad, yes I think you're right, now you've got me worried about the
> other migration paths too.. however did you come up with that
> scenario? :-)

I believe this is the only problem with migration... I mean, I failed
to find something else ;)

> A simple fix would be to keep ->pi_lock locked over the call to
> stop_one_cpu() from set_cpus_allowed_ptr().

I don't think this can work. Suppose that the target CPU spins waiting
for this ->pi_lock.

> I think the sched_fair.c load-balance code paths are ok because we only
> find a task to migrate after we've obtained both runqueue locks, so even
> if we migrate current, it cannot schedule (step 3).
>
> I'm not at all sure about the sched_rt load-balance paths, will need to
> twist my head around that..

I _think_ that sched_fair/rt are fine. At least, at first glance.

The new rules are simple, afaics. set_task_cpu/etc is protected by rq->lock
if the task was not deactivated, otherwise you need task->pi_lock. That is
why I think the things like pull_task() are fine, they are working with
the active tasks and thus they only need the src_rq->lock.

And that is why set_cpus_allowed_ptr()->__migrate_task() "call" looks wrong
in general. The first check in need_migrate_task() is fine, but then we drop
rq->lock. By the time __migrate_task() takes this lock again we can't trust
it, and thus we can't trust "if (p->on_rq)".

Oleg.

