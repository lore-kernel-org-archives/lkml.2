Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2DXSvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 14:51:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2683 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2DXSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 14:51:00 -0400
X-Authority-Analysis: v=2.0 cv=XbcLPfF5 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=TWBfIqSxIMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=mZqyztykd7gaalCl7MkA:9 a=RRMpOAx0UObTo0kdlG8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335293456.28106.145.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Tue, 24 Apr 2012 14:50:56 -0400
In-Reply-To: <1335273316.28150.194.camel@twins>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	 <1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	 <1334162018.23924.268.camel@gandalf.stny.rr.com>
	 <1335273316.28150.194.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 15:15 +0200, Peter Zijlstra wrote:
> On Wed, 2012-04-11 at 12:33 -0400, Steven Rostedt wrote:
> > On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> > >  
> > > @@ -543,6 +897,9 @@ static void put_prev_task_dl(struct rq *rq, struct task_struct *p)
> > >  {
> > >  	update_curr_dl(rq);
> > >  	p->se.exec_start = 0;
> > > +
> > > +	if (on_dl_rq(&p->dl) && p->dl.nr_cpus_allowed > 1)
> > > +		enqueue_pushable_dl_task(rq, p);
> > >  }
> > 
> > Ouch! We need to fix this. This has nothing to do with your patch
> > series, but if you look at schedule():
> > 
> > 	put_prev_task(rq, prev);
> > 	next = pick_next_task(rq);
> > 
> > 
> > We put the prev task and then pick the next task. If we call schedule
> > for some reason when we don't need to really schedule, then we just
> > added and removed from the pushable rb tree the same task. That is, we
> > did the rb manipulation twice, for no good reason.
> > 
> > Not sure how to fix this. But it will require a generic change.
> 
> 
> Something like so: https://lkml.org/lkml/2012/2/16/487 ?

But it still does the same thing:

+static struct task_struct *
+pick_next_task_rt(struct rq *rq, struct task_struct *prev)
 {
-	struct task_struct *p = _pick_next_task_rt(rq);
+	struct task_struct *p;
+	struct rt_rq *rt_rq = &rq->rt;
+
+	if (!rt_rq->rt_nr_running)
+		return NULL;
+
+	if (rt_rq_throttled(rt_rq))
+		return NULL;
+
+	if (prev)
+		prev->sched_class->put_prev_task(rq, prev);
+
+	p = _pick_next_task_rt(rq);

Now if we can do the _pick_next_task_rt() before put_prev_task(), and
only do the put_prev_task() if p != prev, then that would be something.
 
-- Steve


