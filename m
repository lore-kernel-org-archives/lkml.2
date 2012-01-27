Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2A0FU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:20:58 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54984 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2A0FU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:20:56 -0500
MIME-Version: 1.0
In-Reply-To: <tip-4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b@git.kernel.org>
References: <1327486224.2614.45.camel@laptop>
	<tip-4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b@git.kernel.org>
Date: Fri, 27 Jan 2012 11:20:56 +0600
Message-ID: <CADZ9YHi1=aP8j8vCFJvyMANyMWwB_mjT67KwSZZh902oyWy7pA@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Fix rq->nr_uninterruptible update race
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        kosaki.motohiro@gmail.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 2:25 AM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
> Gitweb:     http://git.kernel.org/tip/4ca9b72b71f10147bd21969c1805f5b2c4ca7b7b
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Wed, 25 Jan 2012 11:50:51 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 26 Jan 2012 19:38:09 +0100
>
> sched: Fix rq->nr_uninterruptible update race
>
> KOSAKI Motohiro noticed the following race:
>
>  > CPU0                    CPU1
>  > --------------------------------------------------------
>  > deactivate_task()
>  >                         task->state = TASK_UNINTERRUPTIBLE;
>  > activate_task()
>  >    rq->nr_uninterruptible--;
>  >
>  >                         schedule()
>  >                           deactivate_task()
>  >                             rq->nr_uninterruptible++;
>  >
>
> Kosaki-San's scenario is possible when CPU0 runs
> __sched_setscheduler() against CPU1's current @task.
>
> __sched_setscheduler() does a dequeue/enqueue in order to move
> the task to its new queue (position) to reflect the newly provided
> scheduling parameters. However it should be completely invariant to
> nr_uninterruptible accounting, sched_setscheduler() doesn't affect
> readyness to run, merely policy on when to run.
>
> So convert the inappropriate activate/deactivate_task usage to
> enqueue/dequeue_task, which avoids the nr_uninterruptible accounting.
>
Why would we want to avoid nr_uninterruptible accounting?
nr_uninterruptible has impact on load calculation, we might not get
the proper load weight if we don't account it. isn't it?

Thanks,
Rakib
