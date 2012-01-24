Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2AXO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 09:27:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab2AXO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 09:27:50 -0500
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4F1DE6FE.4000603@fb.com>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
	 <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>
	 <1327352631.2446.22.camel@twins>  <4F1DE6FE.4000603@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Jan 2012 15:27:35 +0100
Message-ID: <1327415255.2614.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-23 at 15:02 -0800, Arun Sharma wrote:
> > +++ b/kernel/sched/fair.c
> > @@ -1191,6 +1191,9 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> >               if (entity_is_task(se)) {
> >                       struct task_struct *tsk = task_of(se);
> >
> > +                     se->statistics.sleep_start = 0;
> > +                     se->statistics.block_start = 0;
> > +
> 
> We might still need some additional logic to ignore sleep_start if the 
> last context switch was a preemption. Test case Andrew Vagin posted on 
> 12/21:
> 
> nanosleep();
> s = time(NULL);
> while (time(NULL) - s < 4);
> 
> During the busy wait while loop, sleep_start is non-zero and the first 
> sample from sched_stat_sleeptime() and anyone else doing the (now - 
> sleep_start) computation would get a bogus value until the next dequeue. 

Bah, you're right. Also yes your proposal is too intrusive, but that can
be fixed, I actually did, but then I noticed its broken too, it doesn't
matter if the schedule that schedules a task back in preempted another
task or not, what matters is if the task we're scheduling back in was
itself preempted or recently woken. And we simply don't know.

I'm tempted to revert 1ac9bc69 for now, userspace will simply have to
correlate trace_sched_switch() and trace_sched_stat_{sleep,blocked}(),
which shouldn't be too hard.



