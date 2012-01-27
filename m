Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab2A0IUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:20:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2A0IUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:20:00 -0500
Message-ID: <1327652393.2446.126.camel@twins>
Subject: Re: [tip:sched/urgent] sched: Fix rq->nr_uninterruptible update race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com, mingo@elte.hu
Date: Fri, 27 Jan 2012 09:19:53 +0100
In-Reply-To: <CADZ9YHi1=aP8j8vCFJvyMANyMWwB_mjT67KwSZZh902oyWy7pA@mail.gmail.com>
References: <1327486224.2614.45.camel@laptop>
	 <tip-4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b@git.kernel.org>
	 <CADZ9YHi1=aP8j8vCFJvyMANyMWwB_mjT67KwSZZh902oyWy7pA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 11:20 +0600, Rakib Mullick wrote:
> On Fri, Jan 27, 2012 at 2:25 AM, tip-bot for Peter Zijlstra
> <a.p.zijlstra@chello.nl> wrote:
> > Commit-ID:  4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
> > Gitweb:     http://git.kernel.org/tip/4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Wed, 25 Jan 2012 11:50:51 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 26 Jan 2012 19:38:09 +0100
> >
> > sched: Fix rq->nr_uninterruptible update race
> >
> > KOSAKI Motohiro noticed the following race:
> >
> >  > CPU0                    CPU1
> >  > --------------------------------------------------------
> >  > deactivate_task()
> >  >                         task->state = TASK_UNINTERRUPTIBLE;
> >  > activate_task()
> >  >    rq->nr_uninterruptible--;
> >  >
> >  >                         schedule()
> >  >                           deactivate_task()
> >  >                             rq->nr_uninterruptible++;
> >  >
> >
> > Kosaki-San's scenario is possible when CPU0 runs
> > __sched_setscheduler() against CPU1's current @task.
> >
> > __sched_setscheduler() does a dequeue/enqueue in order to move
> > the task to its new queue (position) to reflect the newly provided
> > scheduling parameters. However it should be completely invariant to
> > nr_uninterruptible accounting, sched_setscheduler() doesn't affect
> > readyness to run, merely policy on when to run.
> >
> > So convert the inappropriate activate/deactivate_task usage to
> > enqueue/dequeue_task, which avoids the nr_uninterruptible accounting.
> >
> Why would we want to avoid nr_uninterruptible accounting?
> nr_uninterruptible has impact on load calculation, we might not get
> the proper load weight if we don't account it. isn't it?

Read again ;-)

sched_setscheduler() did:

  deactivate_task(); // remove it from the queue

  // change tasks's scheduler paramater

  activate_task(); // queue it in the new place

it is invariant wrt nr_uninterruptible but does include the
nr_uinterruptile accounting logic.

Now Kosaki-San noticed that if the task manages to change its ->state at
an inopportune moment (right between the dequeue and enqueue) we'll get
screwy nr_uninterruptible accounting.
