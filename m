Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0IMQQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 12:16:44 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33341 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750920Ab0IMQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 12:16:43 -0400
Date: Mon, 13 Sep 2010 12:16:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [RFC PATCH] check_preempt_tick should not compare vruntime with
	wall time
Message-ID: <20100913161641.GA28707@Krystal>
References: <20100911173732.551632040@efficios.com> <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop> <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop> <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop> <1284383758.2275.283.camel@laptop> <20100913135621.GA13442@Krystal> <1284387398.2275.311.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284387398.2275.311.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:09:01 up 233 days, 18:45,  5 users,  load average: 0.08, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2010-09-13 at 09:56 -0400, Mathieu Desnoyers wrote:
[...]
> > >  static void
> > >  check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> > >  {
> > > -     unsigned long ideal_runtime, delta_exec;
> > > +     unsigned long slice = sched_slice(cfs_rq, curr);
> > 
> > So you still compute the sched_slice(), based on sched_period(), based on
> > sysctl_sched_min_granularity *= nr_running when there are more than nr_latency
> > running threads.
> 
> What's wrong with that? I keep asking you, you keep not giving an
> answer. Stop focussing on nr_latency, its an by produce not a
> fundamental entity.
> 
>  period := max(latency, min_gran * nr_running)
> 
> See, no nr_latency -- the one and only purpose of nr_latency is avoiding
> that multiplication when possible.

OK, the long IRC discussions we just had convinced me that the current scheme
takes things into account by adapting the granularity dynamically, but also got
me to notice that check_preempt seems to compare vruntime with wall time, which
is utterly incorrect. So maybe all my patch was doing was to expose this bug:

---
 kernel/sched_fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng.git/kernel/sched_fair.c
===================================================================
--- linux-2.6-lttng.git.orig/kernel/sched_fair.c
+++ linux-2.6-lttng.git/kernel/sched_fair.c
@@ -869,7 +869,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq
 		struct sched_entity *se = __pick_next_entity(cfs_rq);
 		s64 delta = curr->vruntime - se->vruntime;
 
-		if (delta > ideal_runtime)
+		if (delta > calc_delta_fair(ideal_runtime, curr))
 			resched_task(rq_of(cfs_rq)->curr);
 	}
 }

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
