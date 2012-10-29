Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab2J2RiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:38:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab2J2RiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:38:20 -0400
From: Benjamin Segall <bsegall@google.com>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [patch 02/16] sched: maintain per-rq runnable averages
References: <20120823141422.444396696@google.com>
	<20120823141506.442637130@google.com>
	<CAM4v1pOJfADYuz9=XaFMnNG-OYAJtsd93Y5YgMd6pn-9sz6Q+A@mail.gmail.com>
Date: Mon, 29 Oct 2012 10:38:15 -0700
In-Reply-To: <CAM4v1pOJfADYuz9=XaFMnNG-OYAJtsd93Y5YgMd6pn-9sz6Q+A@mail.gmail.com>
	(Preeti Murthy's message of "Sun, 28 Oct 2012 15:42:26 +0530")
Message-ID: <xm26hapd6uwo.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preeti Murthy <preeti.lkml@gmail.com> writes:

> Hi Paul, Ben,
>
> A few queries regarding this patch:
>
> 1.What exactly is the significance of introducing sched_avg structure
> for a runqueue? If I have
>    understood correctly, sched_avg keeps track of how long a task has
> been active,
>    how long has it been serviced by the processor and its lifetime.How
> does this apply analogously
>    to the runqueue?

Remember that sched_avg's are not just for tasks, they're for any CFS
group entity (sched_entity), for which they track the time runnable and
the time used, which allows the system-wide per-task_group computation
of runnable and usage.

Computing these on the root has no usage in this patchset, but any
extensions of this using hierarchy-based fractional usage or runnable
time would need it, and retrofitting it afterwards would be a pain.
>
> 2.Is this a right measure to overwrite rq->load.weight because the
> rq->sched_avg does not seem to
>    take care of task priorities.IOW, what is the idea behind
> introducing this metric for the runqueue?
>    Why cant the run queue load be updated the same way as the cfs_rq
> load is updated:
>     cfs_rq->runnable_load_avg and cfs_rq->blocked_load_avg.

Loadwise you would indeed want the cfs_rq statistics, that is what they
are there for. The sched_avg numbers are only useful in computing the
parent's load (irrelevant on the root), or for extensions using raw
usage/runnable numbers.
>
> 3.What is the significance of passing rq->nr_running in
> enqueue_task_fair while updating
>    the run queue load? Because __update_entity_runnable_avg does not
> treat this argument
>    any differently if it is >1.

That could just as well be rq->nr_running != 0, it would behave the same.
