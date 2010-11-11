Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab0KKORU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 09:17:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59338 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0KKORT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 09:17:19 -0500
Subject: Re: [RFC][PATCH 05/22] sched: SCHED_DEADLINE policy implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333814.8661.146.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333814.8661.146.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 15:17:03 +0100
Message-ID: <1289485023.2084.117.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:30 +0200, Raistlin wrote:
> +static void update_curr_dl(struct rq *rq)
> +{
> +       struct task_struct *curr = rq->curr;
> +       struct sched_dl_entity *dl_se = &curr->dl;
> +       u64 delta_exec;
> +
> +       if (!dl_task(curr) || !on_dl_rq(dl_se))
> +               return;
> +
> +       delta_exec = rq->clock - curr->se.exec_start;
> +       if (unlikely((s64)delta_exec < 0))
> +               delta_exec = 0;
> +
> +       schedstat_set(curr->se.statistics.exec_max,
> +                     max(curr->se.statistics.exec_max, delta_exec));
> +
> +       curr->se.sum_exec_runtime += delta_exec;
> +       account_group_exec_runtime(curr, delta_exec);
> +
> +       curr->se.exec_start = rq->clock;
> +       cpuacct_charge(curr, delta_exec);
> +
> +       dl_se->runtime -= delta_exec;
> +       if (dl_runtime_exceeded(rq, dl_se)) {
> +               __dequeue_task_dl(rq, curr, 0);
> +               if (likely(start_dl_timer(dl_se)))
> +                       dl_se->dl_throttled = 1;
> +               else
> +                       enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
> +
> +               resched_task(curr);
> +       }
> +} 

So you keep the current task in the rb-tree? If you remove the current
task from the tree you don't have to do the whole dequeue/enqueue thing.
Then again, I guess it only really matters once you push the deadline,
which shouldn't be that often.

Also, you might want to put a conditional around that resched, no point
rescheduling if you're still the leftmost task.


